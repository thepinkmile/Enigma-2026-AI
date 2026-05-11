# Actuation Module (AM) Design Specification

**Status:** In Review
**Project:** Enigma-NG
**Author:** Izzyonstage & GitHub Copilot
**Version:** v.0.1.0
**Associated Hardware Revision:** Rev A
**Last Updated:** 2026-05-11

## 1. Overview

The **Actuation Module (AM)** is a small shared service PCB used anywhere Enigma-NG needs one local
servo-driven single-step actuation cycle without continuous CM5 supervision. The same AM is fitted:

* once on the **Controller** to actuate the main depression bar for virtual keypress injection
* once on each **Extension** to regenerate a group-boundary carry event into a local single-step
  actuation of the next 5-rotor group

The host board only provides power and a single active-low `ACTUATE_REQUEST_N` line. The AM owns the
power-up homing sequence, request latching / one-shot behaviour, servo PWM generation, and local LED
diagnostics.

## 2. Functional & Design Requirements

### Functional Requirements

| ID | Functional Requirement | Notes | Satisfied By / Cross-Ref |
| :--- | :--- | :--- | :--- |
| FR-AM-01 | Accept a local power feed from a host board | Host provides `5V_MAIN`, `3V3_ENIG`, and multiple `GND` returns | §3 Connectivity; BOM J1 |
| FR-AM-02 | Accept a single active-low `ACTUATE_REQUEST_N` input from the host board | Same electrical contract works for a CM5-driven request on the Controller and a switch-derived request on an Extension | §3 Connectivity; BOM J1 |
| FR-AM-03 | Auto-home the local servo on power-up without host feedback wires | Host waits a fixed startup window; AM shows local LED state only | §4 Local control behaviour; BOM J3, D1-D3 |
| FR-AM-04 | Convert each valid request into exactly one complete servo cycle | Held request inputs must not retrigger until the current cycle completes and the input has released | §4 Local control behaviour; BOM U1 |
| FR-AM-05 | Drive one external hobby servo through a local loom connection | Servo is mechanically mounted near the actuation bar, not on the AM PCB | §3 Connectivity; BOM J2 |
| FR-AM-06 | Monitor a local home switch through a separate loom connection | Home switch is physically mounted near the mechanism and wired back to the AM | §3 Connectivity; BOM J3 |
| FR-AM-07 | Provide local diagnostic indication without any host-side status return pins | `PWR`, `HOMED`, and `ACT` LEDs are sufficient for bench and service diagnostics and shall remain visible from the AM board edge during maintenance | BOM D1-D3, R1-R3 |
| FR-AM-08 | Provide a dedicated local SWD programming / service header on the AM itself | Required so the STM32 can always be programmed and debugged before first use without depending on the host board | §3.4; BOM J4 |
| FR-AM-09 | Provide a dedicated local UART bootloader / service header on the AM itself | Keep a second programming path available for ad-hoc USB-to-UART use, with explicit boot-entry control exposed on the header pinout | §3.5; BOM J5 |
| FR-AM-10 | Provide a local momentary reset control next to the UART service header | Required so the UART bootloader path can be entered without awkward clip leads on `RESET_N` | §3.6; BOM SW1 |
| FR-AM-11 | Provide a local momentary `BOOT0` control next to the UART service header | Required so the UART bootloader path can be entered directly at the AM without needing a temporary jumper on the header | §3.7; BOM SW2 |

### Design Requirements

| ID | Design Requirement | Specification | Satisfied By / Cross-Ref |
| :--- | :--- | :--- | :--- |
| DR-AM-01 | PCB stackup | Inverted stackup per `design/Standards/Global_Routing_Spec.md §2.3.2` | `Board_Layout.md` |
| DR-AM-02 | Host dock connector | J1 = Hirose DF40C-20DP-0.4V(51) (module-side 20-pin plug, 0.4mm pitch); host uses matching DF40HC(3.5)-20DS-0.4V(51) receptacle; stacking height = 3.5mm; carries `5V_MAIN`, `3V3_ENIG`, `ACTUATE_REQUEST_N`, and `GND` on a single connector | §3.1; BOM J1; `design/Standards/Global_Routing_Spec.md §7.1` |
| DR-AM-03 | AM mounting holes | MH1-MH4 shall be M2.5mm NPTH through-holes with copper annular ring using the KiCAD built-in `MountingHole_Pad` footprint (no purchasable BOM component); pads shall be connected to `GND`. Matching 3.5mm SMT standoffs (9774035151R) on the host board (EXT MH5-MH8 or CTL MH5-MH8). Placement shall follow the asymmetric pattern: MH1 (top-left) and MH3 (bottom-left) at 7 mm from the left edge and 7 mm from the top and bottom edges respectively; MH2 (top-right) and MH4 (bottom-right) at 7 mm from the right edge and 12 mm from the top and bottom edges respectively. This non-square pattern enforces a single valid mating orientation, compensating for the polarity-free DF40 connector body. Exact coordinates to be confirmed at PCB layout stage. Per DEC-057 daughterboard exception — AM mounts to CTL/EXT via M2.5 standoffs and uses GND (not GND_CHASSIS). | `Board_Layout.md`; §3.1 |
| DR-AM-04 | Servo loom header | J2 = Adam Tech PH1-05-UA, manually fitted post-PCBA; only pins 1-3 are active in Rev A | §3.2; BOM J2 |
| DR-AM-05 | Home-switch loom header | J3 = Adam Tech PH1-05-UA, manually fitted post-PCBA; twisted-pair wiring required for the active signal and return | §3.3; BOM J3 |
| DR-AM-06 | Local controller architecture | U1 shall be a small 3.3V local controller with native hardware PWM, at least 2 digital inputs, at least 4 spare / LED-capable GPIOs, power-on reset, and a package suitable for low-profile service-module assembly | §4; BOM U1 |
| DR-AM-07 | Diagnostics LED parts and placement | Reuse the existing green 0603 status LED and 330Ω 0402 resistor already used on Encoder boards, but place the LED footprints at the visible board edge on the PCBA side so their light remains observable when the AM is installed upside-down | BOM D1-D3, R1-R3; `Board_Layout.md` |
| DR-AM-08 | Home-input biasing | `ACTUATION_HOME_N` uses a local 10kΩ pull-up to `3V3_ENIG` plus a 1µF local RC debounce capacitor - RC time constant 10 ms | BOM R4, C1 |
| DR-AM-09 | Mounting orientation and layer assignment | Module mounts upside-down on host board using intentionally inverted 4-layer assignment per `design/Standards/Global_Routing_Spec.md §2.3.2` and DEC-016; L1 (component/connector-facing side) faces host PCB, L4 (exterior face) is user-visible side | `Board_Layout.md`; DEC-016 |
| DR-AM-10 | SWD service connector | J4 = Adam Tech PH1-05-UA, manually fitted 1x5 2.54mm SWD header using the common compact 5-pin STM32/ST-LINK flying-lead order (`VTref`, `SWCLK`, `GND`, `SWDIO`, `RESET_N`) | §3.4; BOM J4 |
| DR-AM-11 | Inter-board component envelope | All PCBA-fitted parts on the enclosed connector-facing side of the AM shall remain low profile and shall not exceed 2.0 mm installed height above the PCB; all manual-fit loom / service headers remain on the opposite side | `Board_Layout.md`; §4 |
| DR-AM-12 | UART bootloader connector | J5 = Adam Tech PH1-05-UA, manually fitted 1x5 2.54mm UART bootloader header; pins 1-4 shall follow the common 3.3V TTL serial order (`GND`, `3V3`, `TX`, `RX`) and pin 5 shall expose `BOOT0` | §3.5; BOM J5 |
| DR-AM-13 | Local reset button | SW1 = Omron B3F-1070 or equivalent SPST NO through-hole tactile switch, wired to pull `RESET_N` low momentarily and placed adjacent to J5 for convenient UART bootloader entry | §3.6; BOM SW1 |
| DR-AM-14 | Local `BOOT0` button | SW2 = Omron B3F-1070 or equivalent SPST NO through-hole tactile switch, wired to assert `BOOT0` HIGH while pressed and placed adjacent to J5 / SW1 for convenient UART bootloader entry | §3.7; BOM SW2 |
| DR-AM-15 | Local decoupling and reservoir caps | AM is exempt from the full 5x bulk-entry-bank rule used on larger boards, but it shall still include local STM32 supply decoupling plus compact 3V3/5V reservoir caps: C2-C3 = 100nF X7R 0402 at the STM32 VDD/VDDA supply domain (pin 4, combined VDD/VDDA in LQFP-32), C7 = 100nF X7R 0402 also at STM32 VDD/VDDA (pin 4, combined VDD/VDDA in LQFP-32; multiple caps per datasheet decoupling guidance), C4 = 4.7uF X7R on `3V3_ENIG`, C5 = 10uF X7R on `5V_MAIN` near the servo/power entry region. Per GRS §3.2 per-IC bypass capacitor requirement. | §4; BOM C2-C3, C5, C7; `Board_Layout.md` |
| DR-AM-16 | RESET_N filter capacitor | An external 100 nF X7R filter capacitor (C6) shall be placed between the MCU NRST pin and GND per STM32G071 datasheet Figure 23 to suppress voltage spikes on the reset line | §3.6; BOM C6; `Board_Layout.md` |
| DR-AM-17 | BOOT0 series protection resistor | A 10 kΩ series resistor (R5) shall be placed between the SW2 / J5 pin 5 shared node and the MCU BOOT0 pin to limit current during BOOT0 assertion and protect the pin from conflict when the external harness and SW2 are both driven | §3.7; BOM R5; `Board_Layout.md` |
| DR-AM-18 | `ACTUATE_REQUEST_N` pull-up policy | The `ACTUATE_REQUEST_N` signal on `J1 pin 15` shall be held HIGH by the STM32G071K8T3TR internal GPIO pull-up (PUPDR = `0b01`) only; no external pull-up resistor shall be fitted on the AM hardware | §3.1 J1 pin 15; BOM (no external pull-up component) |
| DR-AM-19 | STM32G071K8T3TR LQFP-32 supply topology | The LQFP-32 package has a single combined VDD/VDDA pin (pin 4); all decoupling caps C2, C3, and C7 shall target pin 4 exclusively; no separate VDDA pin exists in this package | §4; BOM C2-C3, C7 |

> **Note - Minimum board size guidance (non-binding):** The DR-AM-03 asymmetric mounting hole pattern
> implies a minimum board height of approximately **26 mm** (right-pair 12 mm insets x 2 plus 1 mm
> edge clearance each side) and a minimum board width of approximately **28 mm** (7 mm insets each
> side plus clearance for the DF40C connector body). These are guidance values only; final dimensions
> shall be determined during schematic capture and PCB layout.

## 3. Connectivity

### 3.1 J1 - Host Dock (Power + Trigger)

**Module-side part:** Hirose **DF40C-20DP-0.4V(51)** (plug, 20-pin, 0.4mm pitch, ~1.14mm above PCB)  
**Host-side mating part:** Hirose **DF40HC(3.5)-20DS-0.4V(51)** (receptacle, 20-pin, 3.5mm stacking height)  
**Board-to-board gap:** 3.5mm (clearance to DR-AM-11 2.0mm limit: 1.5mm ✔)

> ⚠️ **Polarity note:** The DF40 connector body is mechanically polarity-free (Hirose Note 4). Correct
> mating orientation is enforced by the asymmetric standoff hole pattern (MH1-MH4; see DR-AM-03 and
> `Board_Layout.md`). Pin 1 is defined as the top-left pin when the AM is viewed from its component side
> (connector-facing side) with the short standoff-pair edge on the left. Verify against the silkscreen
> pin-1 marker on both AM and host board before installation (per
> `design/Standards/Global_Routing_Spec.md §7.1`).

**Current budget:**  Rated 0.3 A per contact.  
`5V_MAIN`: 5 pins x 0.3 A = 1.5 A available (≥ 3x SG90 stall current headroom ✔).  
`3V3_ENIG`: 2 pins x 0.3 A = 0.6 A available.  
`ACTUATE_REQUEST_N`: logic signal only (< 5 mA).

`ACTUATE_REQUEST_N` is **active-low**. The host asserts a request by pulling the line LOW. The idle-HIGH
bias is provided by the STM32 internal GPIO pull-up (PUPDR = `0b01`) configured in firmware - no external
pull-up resistor is fitted on the AM hardware.

| Pin | Signal | Direction | Notes |
| :--- | :--- | :--- | :--- |
| 1 | 5V_MAIN | Host → AM | Servo supply |
| 2 | GND | - | Servo power return |
| 3 | 5V_MAIN | Host → AM | Servo supply |
| 4 | GND | - | Servo power return |
| 5 | 5V_MAIN | Host → AM | Servo supply |
| 6 | GND | - | Servo power return |
| 7 | 5V_MAIN | Host → AM | Servo supply |
| 8 | GND | - | Servo power return |
| 9 | 5V_MAIN | Host → AM | Servo supply |
| 10 | GND | - | Servo power return |
| 11 | 3V3_ENIG | Host → AM | Logic rail |
| 12 | GND | - | Logic return |
| 13 | 3V3_ENIG | Host → AM | Logic rail |
| 14 | GND | - | Logic return |
| 15 | ACTUATE_REQUEST_N | Host → AM | Active-low request input |
| 16 | GND | - | Signal return / guard |
| 17 | GND | - | Signal return / guard |
| 18 | GND | - | Signal return / guard |
| 19 | GND | - | Signal return / guard |
| 20 | GND | - | Signal return / guard |

### 3.2 J2 - Servo Loom Header

**Part:** Adam Tech **PH1-05-UA** - 1x5 2.54mm male pin header, manually fitted after PCB assembly.

| Pin | Signal | Notes |
| :--- | :--- | :--- |
| 1 | 5V_MAIN | Servo supply |
| 2 | GND | Servo return |
| 3 | SERVO_PWM | AM-generated local PWM |
| 4 | NC | Reserved |
| 5 | NC | Reserved |

### 3.3 J3 - Home Switch Loom Header

**Part:** Adam Tech **PH1-05-UA** - 1x5 2.54mm male pin header, manually fitted after PCB assembly.

| Pin | Signal | Notes |
| :--- | :--- | :--- |
| 1 | ACTUATION_HOME_N | Active-low home-switch input |
| 2 | GND | Twisted-pair return with pin 1 |
| 3 | GND | Spare return |
| 4 | NC | Reserved |
| 5 | NC | Reserved |

### 3.4 J4 - SWD Programming / Service Header

**Part:** Adam Tech **PH1-05-UA** - 1x5 2.54mm male pin header, manually fitted for firmware loading
and bench-service access.

This is the primary programming and debug header for the selected STM32. It uses the common compact
5-pin SWD flying-lead order so an ST-LINK, J-Link, or similar SWD probe can be adapted without
inventing a board-specific pin order.

| Pin | Signal | Notes |
| :--- | :--- | :--- |
| 1 | 3V3_ENIG | Target reference / programming rail |
| 2 | SWCLK | SWD clock |
| 3 | GND | Reference |
| 4 | SWDIO | SWD data I/O |
| 5 | RESET_N | Target reset |

### 3.5 J5 - UART Bootloader / Service Header

**Part:** Adam Tech **PH1-05-UA** - 1x5 2.54mm male pin header, manually fitted for bench-service
UART access and optional STM32 ROM-bootloader programming.

Pins 1-4 keep the common 3.3V TTL serial order so a simple ad-hoc UART harness can be made easily.
Pin 5 exposes `BOOT0` so the ROM bootloader can still be selected from an external harness when needed.
At the board itself, the AM also provides local tactile buttons for both `RESET_N` and `BOOT0`. In use,
`BOOT0` is treated as a **momentary operator action with a timing constraint**: hold it active while
reset occurs, then release it after the boot-mode sample point. To make that practical on the bench,
the AM provides a local reset button at SW1 and a local `BOOT0` button at SW2.

| Pin | Signal | Notes |
| :--- | :--- | :--- |
| 1 | GND | Reference |
| 2 | 3V3_ENIG | Target reference / logic rail |
| 3 | UART_TX | AM -> external UART adapter |
| 4 | UART_RX | External UART adapter -> AM |
| 5 | BOOT0 | Assert HIGH during reset to enter the STM32 ROM bootloader; connects to SW2 / J5 node, then to MCU BOOT0 pin via series R5 (10 kΩ) |

### 3.6 SW1 - Local Reset Button

**Part:** Omron **B3F-1070** - SPST NO through-hole tactile switch.

SW1 provides a local momentary reset by pulling `RESET_N` LOW while pressed. Place it next to J5 so the
normal UART bootloader sequence is straightforward:

1. Hold `BOOT0` HIGH on J5 pin 5.
2. Press and release SW1 to reset the STM32.
3. Release `BOOT0` after reset if desired; the MCU will stay in the ROM bootloader until power is
   cycled or the next reset occurs with `BOOT0` LOW.

> **RESET_N filter capacitor (C6):** The `RESET_N` line carries a 100 nF X7R filter capacitor (C6) to GND,
> placed adjacent to U1's NRST pin per STM32G071 datasheet Figure 23 to suppress voltage spikes on the
> reset line. C6 uses the same approved part as C1-C3.

### 3.7 SW2 - Local `BOOT0` Button

**Part:** Omron **B3F-1070** - SPST NO through-hole tactile switch.

SW2 provides a local momentary `BOOT0` assertion by driving `BOOT0` HIGH while pressed. Place it beside
SW1 so the two-button UART bootloader action is simple and repeatable:

1. Press and hold SW2.
2. Press and release SW1.
3. Release SW2.

> **BOOT0 series resistor (R5):** SW2 and J5 pin 5 share a common node that connects to the MCU `BOOT0` pin via
> series resistor R5 (10 kΩ). R5 limits current during `BOOT0` assertion and prevents conflict if the external
> harness and SW2 are operated simultaneously. R5 uses the same approved part as R4.

This gives the same effect as holding `BOOT0` HIGH on J5 pin 5 during reset, but without needing a
temporary jumper or second hand on the header itself.

## 3.8 Device-to-Design Net Name Mapping

The following table maps STM32G071 device pin names to the board-level net names used in this document and in the KiCAD schematic:

| Component Pin Name | Design Net Name | Notes |
| --- | --- | --- |
| NRST | RESET_N | STM32 reset pin; active-low; board-local net (does not conflict with system-level SYS_RESET_N) |

## 4. Local Control Behaviour

The AM is intentionally **host-light** and **mechanically local**:

1. Firmware is loaded via J4 (SWD) or, when needed, via J5 plus the local SW1 / SW2 button pair before
   the module is placed into service.
2. On power-up, U1 boots from local non-volatile memory and performs a homing sequence using the
   external home switch on J3.
3. Until homing completes, further actuation requests are ignored.
4. Once homed, each valid low-going `ACTUATE_REQUEST_N` event is latched and converted into one complete
   servo cycle.
5. A held request input must not cause repeated cycles; the request must release before the next cycle
   can be accepted.
6. The host receives no `BUSY`, `HOMED`, or fault wire. Service state is indicated only by the local
   LEDs.

### Local supply-decoupling note

The AM should follow a **small daughterboard decoupling strategy**, not the full bulk-entry-bank pattern
used by larger mainline boards. The closest precedent is the JTAG Module (JM), which is
explicitly exempt from the 5x bulk-entry-bank rule and instead uses per-IC 100nF decoupling plus a
single 4.7uF entry filter.

The AM should follow the same general daughterboard logic, but with one important addition: unlike the
JM, the AM drives a local servo load from `5V_MAIN`, so it should include a **local 5V reservoir cap**
as well as MCU decoupling. Rev A therefore requires:

* **C2-C3:** 100nF X7R 0402 local decoupling at the STM32 supply domains
* **C4:** 4.7uF X7R local `3V3_ENIG` reservoir / entry filter
* **C5:** 10uF X7R local `5V_MAIN` reservoir near the servo power path

This does **not** replace the host board's upstream bulk decoupling. It is local high-frequency
decoupling and short-burst current support for the AM itself.

### Preferred controller-part requirement

The selected U1 is **STMicroelectronics STM32G071K8T3TR**. This is a 32-pin 3.3V STM32G071 device
with native timer/PWM resources and enough GPIO margin for the AM's homing input, request input,
diagnostic LEDs, and service/programming access. A standalone PWM driver such as the PCA9685 remains a
reviewed part in the repository, but it is **not sufficient on its own** for the AM because the module
also needs autonomous homing, request latching, and cycle sequencing.
The selected STM32 also keeps both requested service paths practical: J4 carries the normal SWD debug
interface, while J5 plus the local SW1 / SW2 button pair exposes a simple UART/`BOOT0` path for
ROM-bootloader use with ad-hoc wiring.
The reviewed STM32 family reference is
[`design/Datasheets/stm32g071.md`](../../Datasheets/stm32g071.md), which links back to the preserved
vendor PDF at `design/Datasheets/stm32g071.pdf`.

Approved supplier references for the selected AM controller are:

* DigiKey: `497-STM32G071K8T3TR-ND`
* Mouser: `511-STM32G071K8T3TR`
* JLCPCB: global sourcing or consignment only

The Mouser product page is also useful during later PCB work because it provides footprint and 3D-model
links for the selected package.

## 5. Software / Firmware Cross-Reference

The AM firmware specification now lives under the software tree at
[`design/Software/Actuation_Module/Design_Spec.md`](../../Software/Actuation_Module/Design_Spec.md).

That software document is the source of truth for:

* the SWD and UART boot / programming paths
* the SW1 / SW2 UART bootloader button sequence
* the STM32 firmware state machine
* homing, actuation, and fault behaviour
* firmware bring-up order and implementation notes

This hardware design spec remains the source of truth for the AM's electrical interface, connector
pinouts, mechanical constraints, and BOM.

## 6. Bill of Materials

| RefDes | Specification | MPN | Manufacturer | DigiKey PN | Mouser PN | JLCPCB PN | Alt Supplier + PN | Notes | Footprint Available | Footprint Downloaded | Qty |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| C1 | 1µF X7R 50V 0805 | C0805C105K5RACTU | Kemet | 399-C0805C105K5RACTUCT-ND | 80-C0805C105K5R | C3018567 | - | - | ✔ | Pending | 1 |
| C2-C3, C6-C7 | 100nF X7R 50V 0402 | CL05B104KB5NNNC | Samsung | 1276-CL05B104KB5NNNCCT-ND | 187-CL05B104KB5NNNC | C960916 | - | - | ✔ | Pending | 4 |
| C4 | 4.7µF X7R 50V 1210 | CGA6P3X7R1H475K250AD | TDK | 445-10040-1-ND | 810-CGA6P3X7R1H475KD | C3877549 | - | see DEC-046 | ✔ | Pending | 1 |
| C5 | 10µF X7R 25V 0805 | CL21B106KAYQNNE | Samsung | 1276-CL21B106KAYQNNECT-ND | 187-CL21B106KAYQNNE | C3039694 | - | - | ✔ | ✔ | 1 |
| D1-D3 | Green SMD LED diagnostic 0603 | 150060VS75000 | Wurth Elektronik | 732-4980-1-ND | 710-150060VS75000 | C6848499 | - | - | ✔ | Pending | 3 |
| J1 | 20-pin 0.4mm pitch BtB plug | DF40C-20DP-0.4V(51) | Hirose | H11618CT-ND | 798-DF40C20DP0.4V51 | C424637 | - | - | ✔ | ✔ | 1 |
| J2-J5 | 1x5 2.54mm male THT | PH1-05-UA | Adam Tech | 2057-PH1-05-UA-ND | 737-PH1-05-UA | C5374051 | - | manually-fit | ✔ | ✔ | 4 |
| R1-R3 | 330Ω 1% 0402 | ERJ-2RKF3300X | Panasonic | P330LCT-ND | 667-ERJ-2RKF3300X | C278592 | - | - | ✔ | Pending | 3 |
| R4-R5 | 10kΩ 1% 0402 | ERJ-2RKF1002X | Panasonic | P10.0KLCT-ND | 667-ERJ-2RKF1002X | C191123 | - | - | ✔ | Pending | 2 |
| SW1-SW2 | SPST NO tactile THT | B3F-1070 | Omron | SW406-ND | 653-B3F-1070 | C726011 | - | - | ✔ | ✔ | 2 |
| U1 | Local actuation controller LQFP32 | STM32G071K8T3TR | STMicroelectronics | 497-STM32G071K8T3TR-ND | 511-STM32G071K8T3TR | - | Global sourcing | JLCPCB consignment only | ✔ | Pending | 1 |

The servo motor and the home switch are off-board electromechanical items and are therefore specified
by the host mechanical assembly rather than as AM PCB-fitted BOM rows.

## 7. Thermal & ESD

* **Thermal:** No active cooling required on the AM. U1 (STM32G071K8T3TR LQFP-32) dissipates well below 100 mW; no heatsinking required.
* **ESD - J1 (DF40C host dock, no TVS required):** J1 mates to the host board (Extension J9 or Controller J11).
  It is not operator-accessible during live rotor swap and is explicitly outside DEC-048 scope per `design/Electronics/Extension/Design_Spec.md §5`.
  No TVS required per `design/Standards/Global_Routing_Spec.md §9`.
* **ESD - J2-J5 (manual-fit loom/service headers, no TVS required):** All remaining connectors (Adam Tech PH1-05-UA) are internal assembly headers; not accessible under live conditions.
  No TVS required per `design/Standards/Global_Routing_Spec.md §9`.
