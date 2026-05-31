# System Design Specification: Stackable RP2040 Servo Controller Module

## 1. Executive Summary
This document specifies the architecture for a modular, stackable peripheral subsystem controlled by a Raspberry Pi Compute Module 5 (CM5) host. The stack contains 1 to 6 identical physical modules. Each module features a Raspberry Pi RP2040 microcontroller responsible for low-level, real-time control of a single hobby servo, localized homing sequences, and passing a parallel 12-bit system data bus (6 active-low system inputs, 6 active-low system outputs). Inter-module communications and dynamic addressing are handled via an automated SPI daisy-chain topology.

---

## 2. Subsystem Architecture & Constraints

### 2.1 Mechanical Stackability & Scaling
* **Stack Depth:** Minimum 1 module; maximum 6 modules.
* **Addressing:** Dynamic token-pass enumeration at boot time. No physical DIP switches or hardcoded hardware addresses are permitted.
* **Component Footprint:** The production environment uses Surface Mount Devices (SMD) to maintain a low vertical profile.

### 2.2 Power Architecture
* **Primary Rails:** 5V high-current rail for servo motor actuation; 3.3V rail for digital logic.
* **Prototype Testing Mode:** For non-load interface verification, the test board is powered entirely from the CM5's 3.3V output rail, bypassing the 5V regulator and servo power requirements.

### 2.3 Clock Reference Requirements
* **System Heartbeat:** The RP2040 cannot utilize the gated, transactional SPI clock (`SCK`) from the CM5 as a core reference clock. 
* **Reference Source:** Each module must contain an independent, localized **12.000 MHz reference clock source** (such as a 3225-package SMD crystal with 15pF loading capacitors or a MEMS oscillator) to feed the `XIN` pin and lock the internal Phase-Locked Loops (PLLs) to a default 125 MHz core frequency.

---

## 3. Communication Protocol & Topology

### 3.1 SPI Daisy-Chain
The communication network operates as a synchronous SPI daisy chain configured in Slave Mode (`CPOL=0`, `CPHA=0`, `MSB First`) matching a Linux user-space `spidev` driver.

* **Shared Lines:** Clock (`SCK`) and Chip Select (`CS`) are bused in parallel across all stacked layers.
* **Cascaded Data Lines:** The Master Out Slave In (`MOSI`) line is chained sequentially through the stack. The host `MOSI` connects to Module 1 `MOSI`. Module 1 `MISO` links directly to Module 2 `MOSI`, cascading down to the final layer before returning to the host's `MISO` line.

### 3.2 Dynamic Enumeration Sequence
Automatic board configuration uses a dedicated active-high Selector line (`SEL_IN` and `SEL_OUT`) passed down through the physical header pins.

1. At boot, all modules pull `SEL_OUT` low and await a wake-up signal.
2. The CM5 asserts the first module's `SEL_IN` pin **HIGH**.
3. Module 1 catches this state, initializes its configuration, sets its internal module ID to 1, and drives its own `SEL_OUT` pin **HIGH**.
4. This signal awakens Module 2, cascading down until all physical layers are enumerated.
5. The CM5 issues a 16-bit discovery frame (`0xF000`). Each module increments the payload's lowest byte before passing it along. The returned word explicitly defines the active module count.

---

## 4. Input / Output Logic & Electrical Specification

All system-level communication lines use **active-low** signals to interact natively with EPM570 CPLD internal pull-ups.

### 4.1 Input & Output Configuration Table
The test board maps functions to the following consecutive, non-overlapping RP2040 GPIO headers:


| Peripheral Assignment | RP2040 GPIO | Electrical Configuration | LED State Indicator | Diagnostic Hardware |
| :--- | :--- | :--- | :--- | :--- |
| **System Inputs** (Driven by RP2040) | `GP0` to `GP5` | `GPIO_OUT`, Default `1` (High) | 6x Green LEDs (Sinking to Pin) | Outgoing bit validation probe loops |
| **System Outputs** (Read by RP2040) | `GP6` to `GP11` | `GPIO_IN`, `gpio_pull_up` active | 6x Yellow LEDs (Sinking to Pin) | System injection probe loops |
| **Servo PWM Output** | `GP12` | `GPIO_FUNC_PWM` (Sub-µs timing) | None (Direct trace) | Dedicated Logic Analyser loop |
| **End-Stop Switch Input** | `GP13` | `GPIO_IN`, `gpio_pull_up` active | None (Direct trace) | Dedicated Scope Capture loop |
| **Actuate Trigger Input** | `GP14` | `GPIO_IN`, `gpio_pull_up` active | None (Direct trace) | Dedicated Latency Capture loop |

### 4.2 LED Active-Low Visual Circuit Design
To visually confirm active-low states, all 12 diagnostic LEDs use a current-sinking configuration to prevent floating states from feeding false data:
* **Green Array (Inputs to System):** `3.3V Rail` ──► `330Ω Resistor` ──► `Green LED Anode (+) / Cathode (-)` ──► `RP2040 Output Pin`
* **Yellow Array (Outputs from System):** `3.3V Rail` ──► `470Ω Resistor` ──► `Yellow LED Anode (+) / Cathode (-)` ──► `RP2040 Input Pin`
* *Behavior:* When the digital line transitions to a logic `0` (GND), current passes from the 3.3V rail through the LED, illuminating the component during active states.

---

## 5. Firmware Code Architectures (Pico SDK C++)

### 5.1 Slave Module Data Packing and I/O Loop
The low-level firmware utilizes the RP2040 C++ Pico SDK to evaluate inputs and pack system states into a standard 16-bit payload.

```cpp
#include "pico/stdlib.h"
#include "hardware/spi.h"

uint8_t read_system_outputs() {
    uint8_t result = 0;
    for (int i = 0; i < 6; i++) {
        if (gpio_get(6 + i) == 0) { 
            result |= (1 << i); 
        }
    }
    return result;
}

void write_system_inputs(uint8_t active_bits) {
    for (int i = 0; i < 6; i++) {
        bool bit_is_active = (active_bits & (1 << i));
        gpio_put(0 + i, bit_is_active ? 0 : 1); 
    }
}

void process_spi_transactions() {
    uint16_t tx_buf = 0;
    uint16_t rx_buf = 0;

    uint8_t current_outputs = read_system_outputs(); 
    tx_buf = (current_outputs << 6) | 0x003F; 

    spi_write16_read16_blocking(spi0, &tx_buf, &rx_buf, 1);

    uint8_t system_commands = (rx_buf >> 6) & 0x3F;
    uint8_t target_inputs    = rx_buf & 0x3F;

    write_system_inputs(target_inputs);
}
```

### 5.2 Localized Servo Homing and Edge-Triggered Actuation
Servo operations leverage asynchronous hardware interrupts and PWM slice counters to isolate long delay cycles from blocking the real-time background SPI communication loops.

```cpp
#include "pico/stdlib.h"
#include "hardware/pwm.h"
#include "hardware/gpio.h"

#define PIN_SERVO_PWM 12
#define PIN_ENDSTOP   13
#define PIN_ACTUATE   14

#define PWM_WRAP 20000
#define CLK_DIV  125.0f

volatile bool is_actuating = false;
uint32_t slice_num;

void set_servo_angle(float degrees) {
    uint32_t pulse_width = 1000 + (uint32_t)((degrees / 180.0f) * 1000);
    pwm_set_chan_level(slice_num, pwm_gpio_to_channel(PIN_SERVO_PWM), pulse_width);
}

void perform_homing_sequence() {
    float angle = 45.0f;
    while (gpio_get(PIN_ENDSTOP) != 0) { // Active-Low check
        set_servo_angle(angle);
        angle -= 0.5f;
        sleep_ms(15);
        if (angle < -10.0f) { 
            pwm_set_chan_level(slice_num, pwm_gpio_to_channel(PIN_SERVO_PWM), 0);
            while(1); 
        }
    }
    set_servo_angle(0.0f);
    sleep_ms(500);
}

void gpio_callback(uint gpio, uint32_t events) {
    if (gpio == PIN_ACTUATE && !is_actuating) {
        is_actuating = true;
        set_servo_angle(150.0f); // Fast forward sweep
        sleep_ms(600);
        set_servo_angle(0.0f);   // Return home
        sleep_ms(600);
        is_actuating = false;
    }
}
```

---

## 6. Host Linux C++ User-Space Driver

The CM5 controls the stack via a user-space execution layer leveraging modern Linux `libgpiodcxx` and standard `spidev` APIs.

```cpp
#include <iostream>
#include <fcntl.h>
#include <unistd.h>
#include <sys/ioctl.h>
#include <linux/spi/spidev.h>
#include <gpiod.hpp>
#include <vector>
#include <cstring>

class ModuleStackDriver {
private:
    int spi_fd = -1;
    gpiod::line sel_line;
    int active_modules = 0;

public:
    bool init() {
        spi_fd = open("/dev/spidev0.0", O_RDWR);
        uint8_t mode = SPI_MODE_0;
        uint8_t bits = 16;
        uint32_t speed = 1000000;

        ioctl(spi_fd, SPI_IOC_WR_MODE, &mode);
        ioctl(spi_fd, SPI_IOC_WR_BITS_PER_WORD, &bits);
        ioctl(spi_fd, SPI_IOC_WR_MAX_SPEED_HZ, &speed);

        gpiod::chip chip("gpiochip4");
        sel_line = chip.get_line(22);
        sel_line.request({"CM5_SEL_OUT", gpiod::line_request::DIRECTION_OUTPUT, 0}, 0);
        return true;
    }

    int enumerate_stack() {
        sel_line.set_value(1);
        usleep(50000);
        sel_line.set_value(0);

        uint16_t tx_buf[6] = {0xF000, 0, 0, 0, 0, 0};
        uint16_t rx_buf[6] = {0};

        struct spi_ioc_transfer tr;
        std::memset(&tr, 0, sizeof(tr));
        tr.tx_buf = (unsigned long)tx_buf;
        tr.rx_buf = (unsigned long)rx_buf;
        tr.len = sizeof(tx_buf);
        tr.speed_hz = 1000000;
        tr.bits_per_word = 16;

        ioctl(spi_fd, SPI_IOC_MESSAGE(1), &tr);

        for (int i = 0; i < 6; ++i) {
            if ((rx_buf[i] >> 12) == 0xF) {
                active_modules = rx_buf[i] & 0x00FF;
                break;
            }
        }
        return active_modules;
    }
};
```
