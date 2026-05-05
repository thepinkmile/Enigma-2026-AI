# Linux OS: Power Management

**Status:** Draft
**Project:** Enigma-NG
**Author:** Izzyonstage & GitHub Copilot
**Version:** v.0.1.0
**Last Updated:** 2026-04-25

## Overview

The CM5 (Raspberry Pi Compute Module 5) graceful shutdown is **hardware-initiated** via the CM5
PMIC power-button input (`PWR_BUT_N`). No firmware polling is required for the primary shutdown path.

**Primary shutdown path (hardware-automatic):**

1. Primary power fails → 5V_MAIN falls to **4.812V** → LTC3350 `/INTB` asserts LOW.
2. MIC1555 U13 (monostable one-shot) triggers → `PWR_BUT_N` held LOW for **3.01 seconds**.
3. CM5 PMIC sends power-key event → Linux `systemd-logind` `HandlePowerKey=poweroff` → graceful
   OS shutdown, identical to `sudo shutdown -h now`.
4. LTC3350 simultaneously restores 5V_MAIN to 5V; PWR_GD stays HIGH throughout shutdown.
5. Hold-up window: **≥33.5 seconds** from backup activation - OS typically shuts down in 10-15 s.

**Secondary telemetry signals (software-visible, not shutdown triggers):**

- **PWR_GD (GPIO 7):** Active-HIGH rail-health signal from MCP121T-450E (4.50V threshold). Stays HIGH
  throughout the hold-up window (LTC3350 keeps 5V_MAIN above 4.50V). Deasserts only if supercaps are
  depleted - by which time OS should already be halted.
- **PM-local status expander (`PCA9534A @ 0x3F`):** Provides `POE_STAT`, `USB_STAT`, `BATT_PRES_N`,
  `SYS_FAULT`, and the runtime SW1 RGB handoff outputs.
- **LTC3350 I²C telemetry** (0x09): Readable via I²C for backup-state detection, supercap charge / health
  monitoring, LED fault-state control, and post-mortem logging (see DEC-025).

> **Implementation note:** The custom LTC3350 interrupt driver (DEC-025) remains useful for telemetry
> and LED state control but is **not required** for shutdown safety. The hardware `PWR_BUT_N`
> one-shot circuit provides a guaranteed shutdown trigger independent of OS state.
>
## Hardware Signals

| Signal | Connection | Pull-up | Source | Role |
| --- | --- | --- | --- | --- |
| PWR_BUT_N | CM5 PMIC pin (via PM dock `J3`) | CM5 module internal 10kΩ | MIC1555 U13 one-shot / SW2 tactile | **Primary shutdown trigger** - 3 s LOW pulse from U13 on backup-mode entry; or manual press of SW2 |
| PWR_GD | GPIO 7 (BCM) | R3 10kΩ to 3V3_ENIG (Controller board) | MCP121T-450E U8 | **Rail-health telemetry only** - HIGH while 5V_MAIN ≥ 4.50V; stays HIGH throughout hold-up; deasserts only on supercap depletion |
| PM_IO_INT_N | GPIO 5 (BCM) | Open-drain on PM; controller-side pull-up as required | PCA9534A U14 | Optional interrupt line for PM status / SW1 LED expander updates |
| LTC3350 /INTB | PM-local only (not routed to CM5) | R22 10kΩ to 3V3_ENIG (Power Module) | LTC3350 U3 | **Hardware-only backup trigger** - active-LOW when LTC3350 enters backup mode (5V_MAIN < 4.812V, R14 = 30.1kΩ; see DR-PM-08, DEC-030); drives the MIC1555 U13 one-shot locally to generate the `PWR_BUT_N` shutdown pulse |

## Option C: Recommended Implementation

### Phase 1 - HandlePowerKey (Active - no custom driver required)

The primary shutdown path requires only a single `systemd-logind` configuration line. When the CM5
PMIC receives the 3-second `PWR_BUT_N` pulse, it generates a power-key event that `systemd-logind`
handles natively:

```ini
# /etc/systemd/logind.conf
[Login]
HandlePowerKey=poweroff
```

This is sufficient for production use. No polling, no daemon, no I²C read required for the shutdown
path itself.

### Phase 2 - LTC3350 I²C Telemetry Support (Deferred - DEC-025)
>
> **Deferred to Software PoC Stage.** Any LTC3350 software support is limited to I²C telemetry,
> LED state control, and post-mortem logging; it is **not required** for shutdown safety.
> No dedicated `/INTB` GPIO or device-tree interrupt mapping is required in the current
> architecture. Development is deferred until hardware is available. See **DEC-025**.

**Intended behaviour (reference only):**

The software support will:

1. Read LTC3350 STATUS register (I2C 0x09, register 0x01) to confirm BACKUP bit (bit 3) whenever PM
   telemetry is sampled.
2. Read LTC3350 charge / monitor status to determine whether the supercap bank is healthy and charged
   enough to provide the guaranteed hold-up window.
3. Set SW1 LED to **solid red** whenever the LTC3350 reports a PM fault or the supercap bank is not
   hold-up ready, even if a normal input source is still present.
4. Set SW1 LED to **2 Hz orange flash** during valid backup-mode operation when the bank remains healthy.
5. Log the event to the kernel ring buffer for post-mortem analysis.
6. Optionally read VCAP / charge telemetry for remaining supercap SOC estimation.

**I2C parameters (for deferred telemetry support reference):**

| Parameter | Value |
| --- | --- |
| I2C address | 0x09 |
| STATUS register | 0x01 |
| BACKUP bit | bit 3 (value 0x08) |

### Phase 3 - PWR_GD GPIO Backstop (Not Applicable)
>
> **Not applicable:** PWR_GD (GPIO 7) is rail-health telemetry only (HIGH while
> 5V\_MAIN ≥ 4.50 V). It must NOT be configured as a shutdown trigger.
> The active hardware shutdown backstop is the LTC3350 /INTB → MIC1555 U13 → Q5 BSS138
> → PWR\_BUT\_N one-shot circuit (3.01 s LOW pulse), which requires no software driver.
>
## Shutdown Timing Budget

| Event | Time from power loss | Action |
| --- | --- | --- |
| Mains fails / PoE drops | t = 0 | Input source lost |
| 5V_MAIN falls to 4.812V - LTC3350 BACKUP asserted | ~10 ms | `/INTB` goes LOW; MIC1555 U13 one-shot triggers; LTC3350 begins restoring 5V_MAIN |
| `PWR_BUT_N` held LOW (3.01 s pulse begins) | ~10 ms | CM5 PMIC receives power-key event; `systemd-logind` HandlePowerKey=poweroff initiated |
| LTC3350 hold-up fully engaged | ~20 ms | 5V_MAIN restored to 5V; PWR_GD stays HIGH; ≥33.5 s window active |
| `PWR_BUT_N` pulse ends | ~3.02 s | MIC1555 output returns HIGH; Q5 off; PWR_BUT_N returns HIGH via CM5 pull-up |
| OS syncs filesystems, halts | ~10-15 s | ROTOR_EN de-asserted; CM5 PMIC halted |
| Supercaps depleted / system off | ≥33.5 s from power loss | 5V_MAIN → 0V; MCP121T deasserts PWR_GD |

## Dependencies

- Python package: `smbus2` (`pip3 install smbus2`)
- Python package: `systemd` (`pip3 install systemd-python`) for sd_notify
- I²C enabled on CM5 (`dtparam=i2c_arm=on` in config.txt)
- `enigma-power-monitor.service` installed and enabled (`systemctl enable enigma-power-monitor`)

## SW1 RGB LED State Machine

The CM5 controls the SW1 RGB LED through the PM-local `PCA9534A @ 0x3F` once firmware initialises. The
hardware handoff sequence and colour states are defined below.

### Boot Handoff Sequence

1. **Power on (CM5 not yet booted):** `PCA9534A` powers up with all pins as inputs, so the PM hardware
   path dominates. MIC1555 (U9) drives Q4 → BAT54 diodes → **Red + Green only** → 1Hz orange flash on SW1.
2. **CM5 kernel boots, systemd target reached:** Power monitor service starts.
   Before asserting `SW_LED_CTRL`, program the PM expander outputs so `SW_LED_R=1`, `SW_LED_G=1`,
   `SW_LED_B=0` (solid orange).
3. **CM5 writes `SW_LED_CTRL=1` via `PCA9534A`:** Hardware Q4 gate disabled → MIC1555 path cut.
   Firmware has exclusive control of the runtime RGB sink stages.
4. **Power source detection / PM health:** Read `POE_STAT`, `USB_STAT`, `BATT_PRES_N`, and `SYS_FAULT`
   from the PM expander, plus LTC3350 backup / charge telemetry, and set LED colour per table below.

### LED Colour Table

| State | SW_LED_R | SW_LED_G | SW_LED_B | Colour | Control |
| --- | --- | --- | --- | --- | --- |
| Booting (pre-CM5) | 1Hz PWM | 1Hz PWM | Off | 🟠 Orange flash | Hardware (MIC1555 + Q4 + D6/D7) |
| CM5 ready, USB-C active | Off | On | Off | 🟢 Solid green | PM expander + RGB sink stages |
| CM5 ready, PoE active | Off | Off | On | 🔵 Solid blue | PM expander + RGB sink stages |
| CM5 ready, Battery active | On | On | Off | 🟠 Solid orange | PM expander + RGB sink stages |
| Supercap hold-up (mains fail, bank healthy) | PWM 2Hz | PWM 2Hz | Off | 🟠 Fast orange flash | PM expander + RGB sink stages |
| PM fault / hold-up unavailable | On | Off | Off | 🔴 Solid red | PM expander + RGB sink stages |

### PM Expander Initialisation (Python)

Add to the power monitor daemon startup sequence:

```python
from smbus2 import SMBus

PM_IO_ADDR = 0x3F
REG_INPUT = 0x00
REG_OUTPUT = 0x01
REG_CONFIG = 0x03

BIT_POE_STAT = 0
BIT_SYS_FAULT = 1
BIT_BATT_PRES_N = 2
BIT_USB_STAT = 3
BIT_SW_LED_R = 4
BIT_SW_LED_G = 5
BIT_SW_LED_B = 6
BIT_SW_LED_CTRL = 7


def set_led(bus: SMBus, r: int, g: int, b: int) -> None:
    value = (r << BIT_SW_LED_R) | (g << BIT_SW_LED_G) | (b << BIT_SW_LED_B) | (1 << BIT_SW_LED_CTRL)
    bus.write_byte_data(PM_IO_ADDR, REG_OUTPUT, value)


with SMBus(1) as bus:
    # P0..P3 inputs, P4..P7 outputs
    bus.write_byte_data(PM_IO_ADDR, REG_CONFIG, 0x0F)

    # Pre-set orange, then take control from the hardware path
    set_led(bus, 1, 1, 0)

    status = bus.read_byte_data(PM_IO_ADDR, REG_INPUT)
    poe_active = not bool(status & (1 << BIT_POE_STAT))
    usb_active = not bool(status & (1 << BIT_USB_STAT))
    batt_active = not bool(status & (1 << BIT_BATT_PRES_N))
    fault_active = not bool(status & (1 << BIT_SYS_FAULT))

    if fault_active:
        set_led(bus, 1, 0, 0)
    elif usb_active:
        set_led(bus, 0, 1, 0)
    elif poe_active:
        set_led(bus, 0, 0, 1)
    elif batt_active:
        set_led(bus, 1, 1, 0)
    else:
        set_led(bus, 1, 0, 0)
```

## INA219 Rotor Stack Current Monitor

The Stator board carries an INA219 (U2, I2C address **0x45**) monitoring the 3V3_ENIG current to the rotor stack via a **10mΩ KRL6432T4-M-R010-F-T1 shunt resistor**
(R1 on Stator, 2512 Kelvin-sense; PM R16 is the second system shunt - total build qty: **3**).

### Hardware Parameters

| Parameter | Value | Notes |
| --- | --- | --- |
| I2C address | 0x45 | Set by A0/A1 pin strapping on Stator INA219 |
| Shunt resistance | **0.010 Ω (10mΩ)** | KRL6432T4-M-R010-F-T1; hardcoded in firmware - do not change without updating Stator BOM |
| PGA range | ±80mV | Covers 0-8A range (3A LDO max → 30mV drop) |
| ADC resolution | 12-bit | |
| Current LSB | **4mA** | = 80mV full-scale / 2^11 steps / 0.010Ω |
| Calibration register | **0x0400** (1024 decimal) | CAL = 0.04096 / (Current_LSB x R_SHUNT) = 0.04096 / (0.004 x 0.010) |

### Firmware Note
>
> ⚠️ The INA219 calibration register must be written on every power-up before any current readings are taken.
> Write smbus2 value **0x0004** (byte-swapped from logical 0x0400 = 1024; smbus2 transmits LSB first so INA219 receives
> 0x0400 = 1024 as intended). If this is skipped, the `Current_Register` will read zero regardless of actual current.

```python
INA219_ADDR    = 0x45        # Rotor stack monitor on Stator board
REG_CONFIG     = 0x00
REG_CAL        = 0x05
REG_SHUNT_V    = 0x01
REG_CURRENT    = 0x04

R_SHUNT        = 0.010       # 10mΩ KRL6432T4-M-R010-F-T1 - hardcoded; do not change without updating Stator BOM
CURRENT_LSB    = 0.004       # 4mA per LSB

# INA219 config: 32V bus range, PGA /2 (±80mV shunt), 12-bit, continuous
# Register value 0x299F byte-swapped for smbus2 little-endian transmission
CONFIG_VALUE   = 0x9F29

bus.write_word_data(INA219_ADDR, REG_CONFIG, CONFIG_VALUE)
bus.write_word_data(INA219_ADDR, REG_CAL, 0x0004)  # CAL = 1024 (big-endian swap)

def read_rotor_current_mA():
    raw = bus.read_word_data(INA219_ADDR, REG_CURRENT)
    raw = ((raw & 0xFF) << 8) | ((raw >> 8) & 0xFF)  # swap bytes (smbus2 LE → INA219 BE)
    if raw > 32767: raw -= 65536   # signed 16-bit
    return raw * CURRENT_LSB * 1000  # convert to mA
```

> **Cross-ref:** See `Stator/Design_Spec.md §5. Power Telemetry` for shunt resistor spec
> and `design/Electronics/Power_Budgets.md` for expected current range (2.05A worst-case typical).

The **INA219 Power Module Monitor** (for 5V_MAIN) is at I2C address **0x40** on the Power Module board (separate device, different rail).

## INA219 5V_MAIN Power Module Monitor

Monitors the 5V_MAIN power rail on the Power Module board. See `Power_Module/Design_Spec.md §3 Telemetry` for hardware details.

### Hardware Parameters

| Parameter | Value | Notes |
| --- | --- | --- |
| I²C address | 0x40 | A0/A1 = GND on U12 |
| Shunt resistance | 0.010 Ω (10mΩ) | KRL6432T4-M-R010-F-T1 R16, Power Module |
| PGA range | ±160mV | Covers 0-16A; 9A worst-case → 90mV drop |
| ADC resolution | 12-bit | |
| Current LSB | 8mA | = 160mV / 2048 / 0.010Ω |
| Calibration register | 0x0200 (512) | CAL = 0.04096 / (0.008 x 0.010) |

### Firmware Note

The CONFIG and calibration registers must be written on every power-up before current readings are valid.

```python
import smbus2

BUS = smbus2.SMBus(1)
INA219_PM_ADDR = 0x40

# CONFIG register (0x00): 32V bus, PGA/4 (±160mV), 12-bit, continuous (big-endian swap)
BUS.write_word_data(INA219_PM_ADDR, 0x00, 0x9F31)  # logical 0x319F byte-swapped for smbus2
# Calibration register (0x05): set before reading current
BUS.write_word_data(INA219_PM_ADDR, 0x05, 0x0002)  # CAL = 512 (big-endian swap)

def read_5v_main_current_mA():
    """Read 5V_MAIN rail current in milliamps (INA219 U10, Power Module)."""
    raw = BUS.read_word_data(INA219_PM_ADDR, 0x04)
    raw = ((raw & 0xFF) << 8) | ((raw >> 8) & 0xFF)  # swap bytes
    if raw > 32767:
        raw -= 65536
    return raw * 8  # Current LSB = 8mA
```

> **Cross-ref:** See `Stator/Design_Spec.md §5. Power Telemetry` for the Rotor-stack INA219 (0x45) hardware spec.
>
## RTC Battery Configuration

The CM5 MXL7704 PMIC includes a battery charging circuit for the RTC backup battery. When a
**non-rechargeable CR2032** is fitted (as specified in `Controller/Design_Spec.md §5`), the
charging circuit must be disabled in software as a belt-and-suspenders measure alongside the
hardware Schottky diode (D1) that physically blocks the charge path at CM5 VBAT (Pin 76).

### config.txt Setting

Ensure the following line is **absent from** `/boot/firmware/config.txt` (do NOT include it):

```ini
# DO NOT add this line - it enables PMIC battery charging at 3.0V and will degrade a CR2032:
# dtparam=rtc_bbat_vchg=3000000
```

Ensure the `rtc_bbat_vchg` parameter is absent from `/boot/firmware/config.txt` - the CM5 defaults to no charging without it.

> **Note:** The following describes a non-standard alternative configuration only. For the
> Rev A production design (CR2032 + D1 Schottky), the `rtc_bbat_vchg` parameter must remain
> **absent** from `config.txt`. Do not apply the ML2032 configuration to Rev A hardware.
>
> **Note:** The hardware Schottky diode (D1, Nexperia BAT54) already physically prevents the
> PMIC from charging the CR2032 regardless of this software setting. The config.txt setting is
> a secondary safeguard. If the battery is ever changed to a rechargeable ML2032, remove D1
> from the PCB AND set `dtparam=rtc_bbat_vchg=3000000` to enable correct charging.
>
### RTC Time Synchronisation

The CM5 will use `systemd-timesyncd` (NTP) to synchronise the RTC on boot when network
is available. On first boot, or after battery replacement, the RTC may show an incorrect time
until network sync completes. This is expected behaviour.

To force an immediate RTC sync from the system clock (after NTP has synced):

```bash
sudo hwclock --systohc
```

To read the current RTC time:

```bash
sudo hwclock --show
```

## Open Items

- [ ] Test hold-up timing under actual CM5 load profile (5W assumed; measure at first prototype)

## Controller Actuation Module Host Interface

The servo motor is no longer driven directly from the CM5. The Controller now hosts one shared
**Actuation Module (AM)** and only provides an active-low `ACTUATE_REQUEST` control pulse on
**GPIO 8**. Servo homing, PWM generation, and the local home-switch handling are owned by the AM.
See `../Actuation_Module/Design_Spec.md` for the AM firmware design and boot/service behavior.

### GPIO Configuration

Configure GPIO 8 as a normal 3.3V digital output and drive it **LOW** to request one actuation
cycle, then return it HIGH / inactive. No direct `SERVO_HOME` CM5 GPIO is used in the active design.

### Enigma Daemon Hardware Initialisation Sequence

On startup, the `enigmad` daemon performs the following hardware init sequence before accepting
any cipher commands:

1. **Actuation-request GPIO setup:** Configure CM5 GPIO 8 as an output and drive it HIGH / inactive.
2. **AM homing guard time:** After rotor-stack power is available, wait the fixed AM power-up homing
   window (**3 seconds maximum**) before accepting any cipher commands.
3. **MCP23017 port direction init:**
   - U6 (0x20): GPA = 0xFF (all inputs), GPB = 0xFF (all inputs).
   - U7 (0x21): GPA = 0x00 (all outputs, including `SYS_RESET_N` on GPA[7]); GPB = 0xFF-equivalent spare state until any future functions are assigned.

### Virtual Keypress Sequence (One Key Injection Cycle)

To inject a virtual keypress for character N (5-bit address):

1. Assert SOURCE_SEL=1 (U7 GPA[6] HIGH) - switches CPLD to CM5 virtual input mode.
2. Write KEY_ADDR[4:0] = N to U7 GPA[4:0].
3. Assert KEY_EN (U7 GPA[5] HIGH) - CPLD samples the key address.
4. Deassert KEY_EN (LOW).
5. Assert `ACTUATE_REQUEST` LOW on GPIO 8 for one short request pulse (nominal 10-20 ms).
6. Return GPIO 8 HIGH / inactive.
7. Wait for the fixed AM actuation window (nominal **650 ms** worst-case for one full home -> act -> return cycle).
8. Deassert SOURCE_SEL (GPA[6] LOW) - returns CPLD to keyboard input mode.
