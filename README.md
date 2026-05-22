# Enigma NG: Digital Cryptography Ecosystem

The Enigma-NG is an advanced "Museum-Grade", modular, and historically-accurate digital recreation of the world’s most iconic encryption machines.
Powered by a **Raspberry Pi Compute Module 5 (CM5)**, this system controls a hardware stack of up to 30 custom CPLD-based rotors and a physical 64-jack plugboard.
Powered with either USB-C Power Adapter, PoE+ or Smart Battery. It bridges 1940s mechanical heritage with 2026 high-speed digital engineering.

## 🚀 Project Vision

To create a high-fidelity, educational, and industrially robust encryption platform.
The design prioritises classroom safety, professional EMI shielding, and deep hardware visibility for students via an integrated diagnostic bank.
Beyond a simple Enigma clone, this terminal is a **Universal Cipher Engine**. The hardware is designed to emulate:

* **Enigma Variants:** I, M3, M4, and Abwehr.
* **Typex:** The 5-rotor British adaptation with simulated printer output.
* **SIGABA:** The 15-rotor US system using complex 3-bank stepping algorithms.
* **NG-26** The modern digital enigma machine designed and created by Matthew McAtamney-Greenwood.

One of the long-term goals of this project is to introduce the ability to deliver Enigma encrypted data over the network,
and even provide the ability to deliver encrypted files using a base-64 encoding before executing the standard rotor-based encryption.
This end-goal will involve the definition of a new RFC for the "Enigma-Packet-Protocol (EnPP)", which will be a custom specification for this project's ecosystem.

## Tools Used

* **Visual Studio Code:** To manage the Documentation within this repository.
* **Visual Studio:** (Latest Community Edition) To develop the GUI Application.
* **KiCAD 9:** To develop the electrical components and PCB layouts.
* **OnShape:** To create and manage the mechanical designs and assemblies.
* **Yocto:** To create the custom Linux OS with built-in drivers and GUI Application.

## Core Component Overview

* **Controller Board:** Raspberry Pi Compute Module 5 (CM5) carrier board hosting the fixed
  motherboard, external I/O, and service docks.
* **Power Module:** Removable power-conditioning / UPS cartridge with PoE, USB-C, smart-battery
  inputs, eFuse protection, and supercap-backed hold-up.
* **Stator Board:** Removable vertical daughterboard and CPLD routing hub for the rotor stack,
  encoder ports, reflector return, and Settings Board I2C link.
* **Rotor Module:** Repeated smart encryption unit (up to 30 fitted) with local CPLD and position
  sensing.
* **Extension Board:** 5-rotor group bridge used to regenerate JTAG timing and carry power /
  return-path continuity between rotor groups.
* **Reflector Board:** Mandatory passive turnaround board at the end of the rotor chain.
* **Encoder Module:** Single generic 64-line interface board reused in keyboard, lightboard, and
  plugboard encode / decode roles.
* **Settings Board:** Panel-mount switch and RGB indicator board on the shared Stator I2C-1 bus.
* **JTAG Module:** Internal FT232H-based USB-to-JTAG bridge for programming all system CPLDs.
* **Actuation Module:** STM32-based servo-driver service board; one mounts on the Controller (virtual keypress depression bar) and one on each Extension Board (group-boundary carry actuation).

## Core Requirements

* **Interface:** Controller ↔ Power Module uses three TE 10-position 2.5mm dock connectors; Controller
  ↔ Stator uses two Molex EXTreme Guardian HD hybrid docks.
* **Diagnostics:** Two ENIG diagnostic banks are provided on the Controller for the PM and Stator dock
  interfaces.
* **UI:** .NET 10.0 Cross-platform GUI with:
  * Live power telemetry.
  * Historical resources.
  * 3D graphical visualiser.
  * Configuration programmer (and creator).

## Board Status Snapshot

| Board | Status |
| :--- | :--- |
| Controller Board | In Review |
| Power Module | In Review |
| Stator Board | In Review |
| Rotor Module | In Review |
| Extension Board | In Review |
| Reflector Board | In Review |
| Encoder Module | In Review |
| Settings Board | In Review |
| JTAG Module | In Review |
| Actuation Module | In Review |

## 🗺️ System Architecture

```mermaid
flowchart BT
    REF["🔵 Reflector Board<br>Passive turnaround · 30-pin J4"]

    subgraph RSTACK["🔄 Rotor Stack  — up to 30 rotors"]
        subgraph G1["Group 1  (Rotors 1–5)"]
            ROT["Rotor Module ×5<br>EPM570 CPLD · FDC2114 sensor<br>10 wiring sets · 4-pos DIP"]
        end
    end

    subgraph STATOR["⚙️ Stator + Config"]
        STA["Stator Board<br>EPM570T100I5N CPLD · ENC routing matrix"]
        SET["Settings Board<br>10× toggle · 12× RGB LED · MCP23017 ×3"]
        STA -. "I²C harness" .-> SET
    end

    subgraph PWR["⚡ Power Module"]
        PM["Power Module<br>PoE+ 802.3bt · USB-C PD · Battery<br>eFuse · Buck · LDO · Supercap UPS"]
    end

    subgraph ENCS["🔡 Encoder Modules  ×6"]
        KBD["KBD_ENC"]
        LBD["LBD_DEC"]
        PLG["PLG_PASS1_ENC · PLG_PASS1_DEC<br>PLG_PASS2_ENC · PLG_PASS2_DEC"]
    end

    subgraph CTRL["🖥️ Controller Board  (CM5 Carrier)"]
        CB["Raspberry Pi CM5<br>Link-Alpha & Link-Beta docks"]
        JTAG["JTAG Module<br>FT232H USB Blaster"]
        AM_C["Actuation Module<br>Depression bar  (STM32G071K8T3TR)"]
        CB -. "internal BtB J12" .-> JTAG
        CB -. "DF40C-20 BtB" .-> AM_C
    end

    subgraph EXTRSTACK["🔄 Extension Rotor Stack  — up to 30 rotors"]
        subgraph EXTG["Extension Board  +  Actuation Module  ×up to 5"]
            EXT["Extension Board<br>JTAG re-buffer · power bridge"]
            AME["Actuation Module<br>Group-boundary carry  (STM32G071K8T3TR)"]
            EXT -. "DF40HC J9" .-> AME
        end
    end

    REF ~~~ RSTACK ~~~ STATOR
    STATOR ~~~ PWR
    ENCS ~~~ CTRL
    EXTRSTACK ~~~ RSTACK

    PWR -- "Link-Alpha<br>3× TE 2.5mm docks<br>5V_MAIN · 3V3_ENIG" --> CTRL
    CTRL -- "Link-Beta<br>2× Molex EXTreme Guardian HD<br>ENC_DATA · JTAG · I²C" --> STATOR
    JTAG -- "JTAG chain entry" --> STA
    KBD -- "ENC_IN[5:0]" --> STA
    STA -- "ENC_OUT[5:0]" --> LBD
    PLG <-- "ENC_DATA" --> STA
    STA -- "Tri-connector Bus<br>Power · JTAG · ENC_DATA" --> ROT
    ROT -- "ENC_DATA" --> REF
    ROT <---> EXT
    REF -- "ENC_OUT[5:0]<br>TTD_RETURN" --> STA
    STA -- "ENC_IN[5:0]<br>5V_MAIN · 3V3_ENIG" --> REF
```

---

## 🔌 Hardware Architecture

### 1. Power Module (The Heart)

* **Input:** Triple-input OR-ing between PoE+ 802.3bt Type 4, USB-C 15V PD, and Battery
  11–16.4V via LM74700-Q1 + CSD17483F4T ideal-diode FETs. PoE is explicitly prioritised over
  USB-C; USB-C vs Battery precedence follows the active input voltages unless extra gating is added.
* **PoE:** Fully discrete 802.3bt Type 4 front end — TPS2372-4 (PD interface) + TPS23730 (ACF DC-DC) + TDK B82806D0060A120 ACF Forward transformer stage. Implemented 12V power stage capacity: 60W.
* **Protection:** TPS25980 eFuse — 7A ILIM, 11.0V UVLO, 16.9V OVLO, 3mΩ RON. Plus 72°C TCO thermal fuse.
* **Buck:** Dual-phase interleaved LMQ61460-Q1 (×2, 6A each, 12A combined, 400kHz DRSS, 180° SYNC). Effective ripple: 800kHz.
* **LDO:** TPS75733KTTRG3 3V3_ENIG (8.8µVRMS noise, 72dB PSRR, 3A, 2.05 A typical load at 68.3% utilisation).
* **UPS:** LTC3350 supercap manager + 8× Abracon ADCR-T02R7SA256MB (2S4P, 50 F) on 5V_MAIN bus. 50 F at 5.4V → ≥33.5 second hold-up for clean CM5 shutdown.
* **Output Rails:** 5V_MAIN (12A) and 3V3_ENIG (3A — logic, CPLDs, and rotor stack) via 80-pin Samtec ERF8 BtB to Controller Board for distribution.
* **Panel Controls:** SW1 is a rugged latching RGB power toggle (Adafruit 4660) and SW2 is a
  matching 16mm momentary RGB CM5 power button (Adafruit 3350); both are panel-mounted controls
  wired to the Power Module harness.

### 2. Controller Board (The Brain)

* **Module:** Raspberry Pi CM5 (BCM2712) on a custom 6-layer 2oz carrier.
* **Power Input:** 3-way seamless switching (LM74700-Q1 ideal-diode on Power Module).
  * **Smart Battery:** 5-pin Molex Micro-Fit connector (11V-16.4V nominal) with SMBus telemetry + BATT_PRES_N.
  * **PoE+ (802.3bt Type 4):** Power-over-Ethernet delivered through the Power Module discrete
    TPS2372-4 + TPS23730 + TDK B82806D0060A120 ACF Forward path. The implemented 12V stage is sized at 60W. Single
    Ethernet cable carries both data and power.
  * **USB-C PD:** 15V USB-C PD negotiated input.
* **Protection:** Over-voltage and over-current protection provided by Power Module eFuse upstream; local reverse-polarity and ESD protection on BtB interface.
* **Rotor Rail:** The rotor stack is powered by the **3V3_ENIG** rail (TPS75733KTTRG3 LDO, 3A) generated on the Power Module; routed to rotor stack via Controller Board → Link-Beta. CM5 GPIO 16
  (ROTOR_EN) gates the LDO enable for sequenced power-up.
* **JTAG Master:** Hosts the JTAG Module (FT232H-based USB Blaster) via internal BtB connector (J12); routes JTAG pass-through to the Stator logic dock (J5).
* **Connectivity:** Native USB 3.0 (SMT), HDMI (SMT), and Gigabit Ethernet.

### 3. JTAG Module

* **Logic:** FT232H USB-to-JTAG bridge with buffered TCK / TMS drive.
* **Role:** Programs the full 37-device JTAG chain (1 Stator + 6 Encoder + 30 Rotor CPLDs).
* **Mounting:** Small internal hat-style daughterboard on the Controller; no external connectors.

### 4. Actuation Module (AM)

* **Logic:** STM32G071K8T3TR MCU; owns power-up homing, request latching / one-shot behaviour, servo
  PWM generation, and local LED diagnostics.
* **Role:** Provides a single servo-driven actuation cycle on demand; the host board asserts only an
  active-low `ACTUATE_REQUEST_N` line — no PWM or position feedback wires are needed from the host.
* **Mounting:** Small internal daughterboard (inverted, component-side facing host PCB) via a 20-pin
  Hirose DF40C BtB connector plus four M2.5 standoffs. Fitted once on the Controller (virtual
  keypress depression bar) and once on each Extension Board (group-boundary carry actuation).
* **Service Headers:** Local SWD (J4) and UART bootloader (J5) headers plus dedicated RESET_N (SW1)
  and BOOT0 (SW2) buttons allow programming and debug without host-board involvement.

### 5. Stator Board (Nervous System)

* **Routing Hub:** Stator CPLD is the ENC_DATA routing matrix, reflector-map application point, and
  first device in the system JTAG chain.
* **Interconnects:** Hosts the Controller hybrid docks, rotor sockets, reflector / extension return
  connector, six Encoder-module IDC ports, and the Settings Board I2C harness.
* **Peripherals:** Owns the rotor-stack INA219 current monitor, three MCP23017 expanders, and the
  PCA9685 servo PWM driver.

### 6. Encoder Module (Universal Interface)

* **Generic PCB:** One single-sided board reused in six roles: `KBD_ENC`, `LBD_DEC`,
  `PLG_PASS1_DEC`, `PLG_PASS1_ENC`, `PLG_PASS2_DEC`, and `PLG_PASS2_ENC`.
* **Logic:** Intel **MAX II EPM570T100I5N** CPLD per board.
* **HID Path:** Physical keyboard layout is 40 positions (`[a-z0-9+=]` plus left / right Shift),
  while the logical repertoire remains the full 64-character code space.
* **Plugboard Path:** Two decode / encode board pairs provide the two configurable passive plugboard
  passes.

### 7. Settings Board (Configuration Panel)

* **Role:** User-accessible configuration board with 10 panel-mount toggles, 12 RGB LEDs, and a
  `CFG_APPLY_N` pushbutton.
* **Interface:** Shared Stator I2C-1 bus over a 6-wire harness (`3V3_ENIG`, `5V_MAIN`, `GND`, `SDA`,
  `SCL`, `GND`).
* **Expanders:** MCP23017 devices at `0x23`, `0x24`, and `0x25`.

### 8. Rotor Module (The Engine)

* **Logic:** Intel **MAX II EPM570T100I5N** CPLD.
* **Dimensions:** Ø92 mm PCB / **Ø100 mm shroud outer**.
* **Segments:** 64 characters with **8mm arc width** for high readability.
* **Memory:** 10 pre-loaded bidirectional wiring sets; 4-position DIP switch for "Rotor Identity" selection.
* **Sensing:** FDC2114RGHR capacitive encoder ICs (dual-track, 3+3 per rotor).
* **Tri-Connector Bus:**
  * Power (2x2), JTAG (2x4 Shielded), and Enigma (2x6 Bidirectional Relay) in a "Tripod" layout.

### 9. Extension Board

* **Role:** Mid-stack bridge inserted between 5-rotor groups in extended builds.
* **JTAG Support:** Re-buffers `TCK` and `TMS` with `SN74LVC2G125DCUR` to restore timing margin for
  the downstream rotor group.
* **Power / Return Path:** Receives `3V3_ENIG` and `GND` through the Extension Port, passes
  `ENC_IN[5:0]`, `ENC_OUT[5:0]`, `SYS_RESET_N`, and `TTD_RETURN`, and avoids a parallel power path
  through the rotor BtB power connector.
* **Scale:** Up to five Extension Boards may be fitted in the full 30-rotor architecture.
* **Actuation Module Host:** Each Extension Board hosts one AM via J9 (DF40HC dock) to regenerate a
  group-boundary carry event into a local single-step actuation of the next 5-rotor group without
  requiring live Controller-side servo supervision.

### 10. Reflector Board

* **Role:** Passive end-of-stack turnaround board for the final rotor group.
* **Mapping Ownership:** No local CPLD; the Stator CPLD remains responsible for reflector-map
  selection and application.
* **JTAG Return:** Terminates the JTAG daisy-chain and returns `TTD_RETURN` to the Stator through the
  30-pin reflector ribbon connector (J4).
* **Signal Path:** Returns the 6-bit ENC path back toward the Stator over a separate electrical path
  while keeping the board itself logically passive.

---

## 💻 Software Implementation

### 1. Linux Kernel Driver

* **Interrupt Handling:** High-priority monitoring of the `KEY_EVENT_INT` line.
* **State Mapping:** Maps 6-bit Input/Return Path to `/dev/enigma_state`.
* **Power Telemetry:** Exposes SMBus battery data and PoE status to userspace.
* **JTAG Control:** Executes Boundary Scan (SAMPLE/PRELOAD) upon keypress trigger.

### 2. .NET 10 GUI (The Terminal)

* **Binary File Transfer:** Encrypts files via Base64 encoding/decryption through the hardware rotors.
* **Ethernet/UDP Interface:** Secure 6-bit encrypted UDP streams for remote terminal communication.
* **Power Dashboard:** Real-time monitoring of Battery (SoC/Temp), PoE+, and USB-C sources.
* **Rotor Library Manager:** Visual tool to design custom wiring and flash the 30-rotor stack.
* **Historical Archive:** Educational database of Enigma, Typex, and SIGABA variants.

### 3. VHDL Firmware (The Navigators)

* **Stator CPLD:** Owns the ENC routing matrix, plugboard insertion positions, reflector-map
  application, and source-selection handoff between keyboard and CM5 virtual input.
* **Rotor CPLDs:** Implement the rotor wiring libraries and per-rotor identity selection.
* **Encoder CPLDs:** Provide the encode / decode logic used by the keyboard, lightboard, and both
  plugboard passes.
* **Status:** Board-level hardware architecture is defined in the active design specs; implementation
  planning and pseudo-code remain tracked as open work in `design/Design_Log/index.md`.

---

## ⚠️ Safety & Design Rules (KiCAD 9)

* **eFuse Latch-off:** Electronic fault protection requires manual power cycle to reset.
* **Soft Start:** SW1 drives the TPS25980 eFuse EN pin; the CM5 separately gates the 3V3_ENIG LDO with ROTOR_EN.
* **ESD Hardening:** TVS diodes on all exposed pins (JTAG, Enigma, and 64-jack lines).
* **Stackup:** Mixed stackup architecture: Controller Board and Power Module are 6-layer boards; the remaining electronics boards are 4-layer / 2oz designs.

---

## 📅 Development Roadmap

1. **Switch and connector review:** finalise USM SPDT switch GPIO expander pin mapping and confirm
   ENC module J1/J2 connector choices before PCB capture.
2. **Extension architecture review:** define full-system extension interconnect topology across all
   supported rotor-count variants (5–30); assess Stator/Reflector board merge and Extension A/B split.
3. **Battery connector review:** confirm whether alternative battery-connector options should replace
   or supplement the present Power Module choice.
4. **Coupon / acceptance-test planning:** add and review board-level coupons and acceptance-test hooks
   across the design set.
5. **Review passes and interim electronics review:** complete clean-pass verifications before
   proceeding to prototype PCB manufacturing.

## Contributions

This is an open-source development project. Contributions are welcomed from all.
When submitting an issue please ensure you provide the SHA commit hash for the version of code that exhibits your issue and provide full replication steps.
For any contributions, please create a Pull Request and ensure useful commit messages are provided.
Once a PR is accepted the changes with be squashed into the current working branch of this repository and your name will be added to the list of contributors.

<!-- readme: collaborators,contributors -start -->
<table>
	<tbody>
		<tr>
            <td align="center">
                <a href="https://github.com/thepinkmile">
                    <img src="https://avatars.githubusercontent.com/u/23457507?v=4" width="100;" alt="thepinkmile"/>
                    <br />
                    <sub><b>The Pink Mile Developer</b></sub>
                </a>
            </td>
		</tr>
	<tbody>
</table>
<!-- readme: collaborators,contributors -end -->

## Licensing

For enquiries regarding educational licensing, please contact the maintainer.
This repository is licensed under the GNU GENERAL PUBLIC LICENSE v3.
