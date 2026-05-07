# Controller Board (V1.0) Design Specification

**Status:** Draft
**Project:** Enigma-NG
**Author:** Izzyonstage & GitHub Copilot
**Version:** v.0.1.0
**Associated Hardware Revision:** Rev A
**Last Updated:** 2026-04-26

---

## 1. Overview

The Controller Board is a custom carrier board for the Raspberry Pi Compute Module 5 (CM5), providing the
central processing and supervisory function for the Enigma-NG system. It is the fixed mechanical
motherboard of the enclosure: the removable Power Module and Stator daughtercards both dock into the
Controller, and all enclosure-edge I/O is grouped on the Controller side.

* **Module:** Raspberry Pi Compute Module 5 (CM5).
* **Role:** Master traffic controller for power, external I/O, and encryption logic.
* **Stackup:** 6-Layer / 2oz Finished Copper (JLC06161H-2116) for 5Gbps differential pair integrity.
* **Shielding:** High-speed signals (Ethernet, USB 3.0, HDMI) routed as Striplines on L3, shielded by L2/L5 GND planes
  and L4 (Internal) for High-Current Power Plane (5V_MAIN / 3V3_ENIG).
* **RJ45 / PoE:** Ethernet entry, magnetics, ESD, and the PoE front-end are hosted locally on the Controller.
  The PoE front-end delivers its regulated auxiliary output to the Power Module over `J2`.
* **Power from PM:** The Controller receives `5V_MAIN` and `3V3_ENIG` from the Power Module over `J1`.
* **Status LED:** The Controller can override the PM status LED with full-colour control via the I2C connection over `J3`.

### GND_CHASSIS Single-Point Bond

Per `design/Standards/Global_Routing_Spec.md §5`, the Controller implements a local
`GND_CHASSIS` net tied to its mounting hardware, connector-shield / EMI landing features, and any
other deliberate enclosure-contact points, but it does **not** implement a local
GND-to-GND_CHASSIS bond. The system's only galvanic GND ↔ GND_CHASSIS bond remains on the Power
Module at the common power-entry point immediately before the eFuse, regardless of which input
source is active.

### Functional & Design Requirements

#### Functional Requirements

| ID | Functional Requirement | Notes | Satisfied By / Cross-Ref |
| :--- | :--- | :--- | :--- |
| FR-CTL-01 | Host the Raspberry Pi Compute Module 5 as the system master processor | CM5 runs the Linux OS and all application logic | BOM U1 (CM5) |
| FR-CTL-02 | Receive regulated rails from the Power Module and distribute them to the CM5, Stator, and local peripherals | Via PM dock `J1` and Stator docks `J4/J5` | §2 Dock Interfaces; BOM J1-J3, J4/J5 |
| FR-CTL-03 | Provide the system's enclosure-edge external I/O interfaces | GbE / PoE entry, HDMI, USB 3.0 | §8 Connectivity; BOM J6, J7, J8 |
| FR-CTL-04 | Provide JTAG programming capability for all 37 CPLDs in the system | Via JTAG Daughterboard and the `J5` Stator logic dock | §3 JTAG Programming Subsystem; BOM J4, J5 |
| FR-CTL-05 | Monitor system power and PM status via I²C, with only essential direct PM handshakes kept as dedicated pins | Telemetry: LTC3350 @ 0x09, STUSB4500 @ 0x28, PCA9534A @ 0x3F, INA219 x2 (PM U10 @ 0x40; Stator U2 @ 0x45); Direct handshakes: `PWR_GD`, `ROTOR_EN_N`, `PWR_BUT_N`, `LED_PWR_N` | §4 Telemetry & Logic; §6 CM5 GPIO Mapping Matrix |
| FR-CTL-06 | Maintain RTC operation across power cycles using a CR2032 backup battery | Non-rechargeable; service by disassembly | §5 RTC Backup Battery; BOM BT1, D1 (BAT54) |
| FR-CTL-07 | Route power, JTAG, and I²C between the Controller and the Stator board | Via `J4/J5` hybrid docks | §2 Dock Interfaces; BOM J4/J5 |
| FR-CTL-08 | Provide DSI1 display interface connector for optional lid-mounted touchscreen add-on | DSI1 4-lane FPC connector (J9) on Controller Board; display add-on board to be designed separately | §8 Connectivity; BOM J9 |
| FR-CTL-09 | Host one shared Actuation Module for the main depression-bar actuation path | Controller provides AM power and a single active-low `ACTUATE_REQUEST_N` control line; homing, PWM generation, and diagnostics are local to the AM | §6 CM5 GPIO Mapping Matrix; §8 Connectivity; BOM J11 |

#### Design Requirements

| ID | Design Requirement | Specification | Satisfied By / Cross-Ref |
| :--- | :--- | :--- | :--- |
| DR-CTL-01 | PCB stackup | 6-layer, 2oz finished copper (JLC06161H-2116) | §9 PCB Fabrication & Stackup |
| DR-CTL-02 | CM5 module | Raspberry Pi Compute Module 5 (SO-DIMM form factor). Multiple current CM5 variants are acceptable. Minimum spec: 4 GB RAM and 8 GB eMMC; on-board Wi-Fi may be fitted or omitted. CM5 Lite (no onboard eMMC) is NOT permitted. BOM reference: various CM5 SKUs. | BOM U1 |
| DR-CTL-03 | Controller-to-Power-Module dock connectors | `J1/J2/J3` = TE `1-1674231-1` 10-position 2.5mm receptacles | BOM J1-J3 |
| DR-CTL-04 | Controller-to-Stator dock connectors | `J4/J5` = Molex `2195630015` hybrid receptacles (5 power + 15 signal) | BOM J4, J5 |
| DR-CTL-05 | USB current limit | 1.6 A via TPS2065C; fault output to GPIO 6 (USB_FAULT_N) | BOM U2 (TPS2065C); §6 GPIO Mapping (GPIO 6) |
| DR-CTL-06 | RTC battery holder | BT1 = Keystone 3034TR (THT horizontal CR2032 holder; `TR` = tape-reel packaging) | §5 RTC Backup Battery; BOM BT1 (Keystone 3034TR) |
| DR-CTL-07 | RTC protection | D1 = BAT54 Schottky diode (blocks PMIC VBAT charge path) | §5 RTC Backup Battery; BOM D1 (BAT54) |
| DR-CTL-08 | RTC bypass capacitor | C6 = 100 nF 0402 on CM5 VBAT (Pin 76, Hirose DF40 200-pin) | §5 RTC Backup Battery; BOM C6 |
| DR-CTL-09 | PM status / SW1 LED interface | Controller must expose the shared `I2C-1` bus plus one optional interrupt input (`PM_IO_INT_N`) to the PM-local `PCA9534A @ 0x3F`, which virtualises `POE_STAT`, `USB_STAT`, `BATT_PRES_N`, `SYS_FAULT`, and runtime `SW_LED_R/G/B + SW_LED_CTRL`. | §4.1 I²C Bus Topology; §6 CM5 GPIO Mapping Matrix |
| DR-CTL-10 | OS/firmware configuration | All firmware configuration requirements (including RTC charging disable) are specified in the Linux OS design spec. See `design/Software/Linux_OS/`. | design/Software/Linux_OS/ |
| DR-CTL-11 | DSI1 connector | J9 = Amphenol F52Q-1A7H1-11015, 15-pin 1.0mm pitch right-angle ZIF/FPC connector; DSI1 4-lane: CLK+/-, D0+/-, D1+/-, D2+/-, D3+/- = 10 differential signals; 100 Ω differential impedance; route on L3 (stripline, same as HDMI); capacitive touch I²C may share the existing I²C-1 controller interface when the deferred display add-on is defined | §8 Connectivity; BOM J9 |
| DR-CTL-12 | Actuation Module host dock | J11 = Hirose DF40HC(3.5)-20DS-0.4V(51) receptacle (20-pin, 0.4mm pitch, 3.5mm stacking height); host-side mating connector for AM J1 (DF40C-20DP-0.4V(51)); carries `5V_MAIN`, `3V3_ENIG`, `ACTUATE_REQUEST_N`, and `GND` on a single connector | §8 Connectivity; BOM J11 |
| DR-CTL-13 | Actuation-request GPIO usage | `ACTUATE_REQUEST_N` uses CM5 GPIO 8 as an active-low host control output. The former direct `SERVO_PWM` / `SERVO_HOME` CM5 ownership is retired in favour of the shared Actuation Module architecture. | §6 CM5 GPIO Mapping Matrix |
| DR-CTL-14 | Actuation Module host envelope | The Controller area beneath the installed AM shall be a no-component placement zone except for J11 and four M2.5x3.5mm SMT standoffs (MH5-MH8, 9774035151R) and the copper / vias needed to route J11; standoff placement shall follow the pattern defined in `design/Electronics/Actuation_Module/Design_Spec.md DR-AM-03`; MH5-MH8 positions shall mirror the AM mounting hole pattern; MH5-MH8 pads shall be connected to `GND` (not `GND_CHASSIS`); do not crowd the module with nearby tall parts or enclosure features that would trap heat or block service access. **PCB layout for J11 and MH5-MH8 cannot be finalised until AM schematic capture and PCB layout are complete.** | §8.6; `design/Electronics/Controller/Board_Layout.md` |
| DR-CTL-15 | Power switch Vcc bypass capacitors | U2 (TPS2065CDBVR) and U3 (AP2331W-7) shall each have a dedicated 100nF X7R 50V 0402 bypass capacitor on their Vcc pin, placed within 1mm of the IC per `design/Standards/Global_Routing_Spec.md §3.2` | BOM: C13 (U2 bypass), C14 (U3 bypass) |
| DR-CTL-16 | PoE IC bypass capacitors | U7 (TPS2372-4RGWR) and U8 (TPS23730RMTR) shall each have a dedicated 100nF X7R 50V 0402 bypass capacitor on their VCC pin, placed within 1mm of the IC per `design/Standards/Global_Routing_Spec.md §3.2`. BOM: C18 (U7 bypass), C19 (U8 bypass) | BOM C18, C19 |
| DR-CTL-17 | ACTUATE_REQUEST_N boot-safe pull-up | R4 (10kΩ 0603) shall connect `ACTUATE_REQUEST_N` (CM5 GPIO 8) to `3V3_ENIG` as a pull-up resistor. This holds the active-low line HIGH (no-actuation state) before CM5 firmware configures GPIO 8 as an output, preventing a spurious actuation pulse to the Actuation Module during CM5 early boot. R4 is distinct from R1–R3, which are series protection resistors on GPIO input lines. | BOM R4; §7 Protection & EMI |
| DR-CTL-18 | PoE ACF primary-side clamp capacitor | C17 (10nF X7R 100V 0402) shall be placed in the U8 (TPS23730RMTR) primary-side active-clamp circuit as the Cclamp energy-storage capacitor. The 100V voltage rating is required by the primary-side operating environment: the PoE bus may reach 57V and transformer leakage transients on the primary drain node exceed this during switching. See `design/Electronics/Controller/PoE_Power_Analysis.md`. | BOM C17; §7.1 PoE Front-End Passive Components |
| DR-CTL-19 | JDB dock connector | J12 = Hirose DF40HC(3.5)-20DS-0.4V(51) 20-pin 0.4mm pitch BtB receptacle (3.5mm stack height) for the JTAG Daughterboard (JDB) dock. Mates with JDB J1 DF40C-20DP-0.4V(51). Placement and board location finalised at PCB layout time. | §8.3; BOM J12 |
| DR-CTL-20 | JDB dock no-component zone | The Controller area beneath the installed JDB shall be a no-component placement zone except for J12 and four M2.5×3.5mm SMT standoffs (MH13–MH16, 9774035151R) and the copper / vias needed to route J12; MH13–MH16 pads shall be connected to `GND` (not `GND_CHASSIS`); standoff placement shall mirror the JDB MH1–MH4 pattern per `design/Electronics/JTAG_Daughterboard/Design_Spec.md §4` and `design/Electronics/JTAG_Daughterboard/Board_Layout.md §8`. See DEC-057 (standoff ownership), DEC-058 (JDB BtB upgrade). **PCB layout for J12 and MH13–MH16 cannot be finalised until JDB schematic capture and PCB layout are complete.** | §8.3; `design/Electronics/Controller/Board_Layout.md` |

## 2. Dock Interfaces

The Controller is the fixed motherboard of the enclosure and carries both removable-board docks.

### 2.1. Controller ↔ Power Module Dock

The Controller connects to the Power Module through the `J1` / `J2` / `J3` TE dock set.
See §8.1 for the connector family, link allocations, reference PDFs, and the `J2`
current-sharing rationale.

### 2.2. Controller ↔ Stator Dock

The Controller connects to the Stator through the `J4` / `J5` Molex hybrid dock pair.
See §8.2 for the connector family, link allocations, reference PDFs, and the `J5`
logic-domain grouping rationale.

### 2.3. CM5 Module Under-Body Placement Envelope

The area directly beneath the mounted CM5 module (55mm x 40mm footprint) shall observe a
**height-limited placement envelope** rather than a total component keep-out:

* Low-profile **passive components only** may be placed within the CM5 shadow area.
* Maximum installed component height beneath the CM5: **2.0mm** above the Controller PCB surface.
* Active components, connectors, test points, tall features, and exposed via pads are prohibited within
  this area.
* Copper fills, signal routing, and power planes are permitted beneath the module.
* The mechanical envelope beneath the CM5 remains **2.5mm** using Amphenol `10164227-1004A1RLF`
  (4.0mm stack height). The 2.0mm component-height rule preserves ~0.5mm assembly margin within that
  official clearance.
* The CM5 footprint shadow should still be shown in KiCad on `User.Courtyard`, but as a placement
  reference boundary for the height rule rather than as a hard no-component keep-out.
* **CM5 mounting standoffs:** MH1–MH4 = four `9774040151R` (Wurth Elektronik M2.5×4.0mm SMT
  standoffs) set the 4.0mm stack height for the CM5 SO-DIMM sockets (J14–J15). Pads are connected
  to `GND` — **not** `GND_CHASSIS`. See `design/Standards/Global_Routing_Spec.md` for module
  mounting hole grounding rules.

### 2.4. Physical Connector Placement

1. **Top Edge:** Order from Left to Right
    * **Stator Dock:** `J4` + `J5` Molex hybrid connectors to the removable Stator daughterboard.
    * **PM Dock:** `J1` + `J2` + `J3` TE 10-position connectors to the removable Power Module.
2. **Right Edge:** Order from Top to Bottom to follow CM5 pinout flow:
    * **RJ45 / PoE Entry:** Long-body magnetics jack. The PoE front-end is local to the Controller.
    * **USB 3.0:** Dual-Stacked Type-A (Molex 48406-0003).
    * **HDMI:** Full-Size Type-A (TE 2007435-1).

**Right-edge support circuitry note:** The USB and HDMI current-limit switches, the edge-I/O ESD
protection network, and the `USB_FAULT_N` telemetry path are all local support circuitry for these
interfaces, but they are not enclosure-protruding connectors and do not define the external connector
order.

**External-face note:** Controller right-edge external connectors follow the global **2.0mm nominal
overhang** rule defined in `design/Standards/Global_Routing_Spec.md §4.1`.

## 3. JTAG Programming Subsystem (USB Blaster)

The Controller provides JTAG pass-through only. All JTAG chain architecture, device ordering, buffering, termination, and timing specifications are defined in the JDB Design_Spec.

* **Controller Pass-Through:** JTAG lines (TCK, TMS, TDI, TTD_RETURN, VREF) are routed directly
  from the JDB hat-headers (`J12`/`J13`) to the Stator logic dock (`J5`) on the Controller board without any active
  components. No buffer or series resistors reside on the Controller for JTAG signals.
* **Cross-ref:** See `design/Electronics/JTAG_Daughterboard/Design_Spec.md` for all JTAG chain architecture, FT232H module schematics, buffering, and assembly details. See DEC-016, DEC-024.

## 4. Telemetry & Logic (INA219 + SMBus)

Current monitoring for both rails is managed via the I2C-1 bus (CM5 GPIO 2/3) and is
implemented on the respective boards - not on the Controller:

* **INA219 U10 (0x40) - 5V_MAIN monitor:** Power Module. See `design/Electronics/Power_Module/Design_Spec.md §3 Telemetry`.
* **INA219 U2 (0x45) - Rotor-stack monitor:** Stator board. See `design/Electronics/Stator/Design_Spec.md §5. Power Telemetry`.

For DT bindings and driver configuration for both INA219 devices, see
`design/Software/Linux_OS/Power_Management.md §INA219 Rotor Stack Current Monitor`.

### 4.1. I²C Bus Topology

All I²C devices share the single I²C-1 bus (CM5 GPIO 2/3) routed to the Power Module over `J3` and to
the Stator over `J5`.

| Address | Device | Location | Function |
| :--- | :--- | :--- | :--- |
| 0x09 | LTC3350 | Power Module | Supercap charger/monitor |
| 0x0B | Smart Battery | Power Module | SMBus battery monitoring |
| 0x20 | MCP23017 (U6) | Stator | ENC_IN/ENC_OUT monitoring (16 GPIO) |
| 0x21 | MCP23017 (U7) | Stator | Virtual keypress injection, SOURCE_SEL, SYS_RESET_N, spare GPIO |
| 0x22 | MCP23017 (U8) | Stator | CPLD config output driver (DEC-032) |
| 0x23 | MCP23017 (U1) | User Settings Module | Switch input reader (DEC-032) |
| 0x24 | MCP23017 (U2) | User Settings Module | Bank 1 LED controller: 5x anodes + RGB bank-rail drivers (DEC-034) |
| 0x25 | MCP23017 (U3) | User Settings Module | Bank 2 LED controller: 7x anodes + RGB bank-rail drivers (DEC-034) |
| 0x28 | STUSB4500 | Power Module | USB-C PD controller |
| 0x3F | PCA9534A (U14) | Power Module | PM-local status inputs + SW1 RGB handoff control |
| 0x40 | INA219 (U10) | Power Module | 5V_MAIN current/power telemetry |
| 0x45 | INA219 (U2) | Stator | Rotor stack current/power telemetry |

> **MCP23017 configuration cross-reference:** Full GPIO pin assignments, port-function tables, and
> address-selection wiring for U6 (0x20), U7 (0x21), and U8 (0x22) are defined in
> `design/Electronics/Stator/Design_Spec.md §3` and the Stator BOM. This table lists I²C addresses
> and high-level functions only.

## 5. RTC Backup Battery

The CM5's MXL7704 PMIC contains an integrated RTC. To maintain timekeeping through power cycles,
a 3V coin cell is required on the CM5's VBAT pin (**Pin 76** on the CM5 Hirose DF40 200-pin connector).

### 5.1. Circuit Design

* **Battery (BT1):** Keystone 3034TR CR2032 THT horizontal click-in holder (`TR` = tape-reel packaging). CR2032 = 3.0V, 220mAh.
  Estimated service life >25 years at <1µA RTC quiescent draw.
* **Protection Diode (D1):** BAT54 Schottky diode (SOT-23, 30V, 200mA).
  Connected in series: BT1(+) → D1(anode), D1(cathode) → CM5 VBAT (Pin 76). Vf ≈ 0.3V @ 100µA; delivers
  ~2.7V to VBAT pin (within MXL7704 VBAT operating range). **This diode is mandatory with a CR2032 -
  it physically prevents the PMIC charging circuit from reaching the battery.**
* **Bypass Cap (C6):** 100nF X7R 0402 (Samsung CL05B104KB5NNNC) from VBAT to GND, placed within 5mm
  of the CM5 DF40 connector Pin 76.

> ⚠️ **Do NOT substitute ML2032 for CR2032 without removing D1.** The ML2032 is rechargeable and
> must connect directly to VBAT (no diode). The software charging-disable note in
> `design/Software/Linux_OS/Power_Management.md` also applies.
>
### 5.2. Placement

* **BT1:** Left edge of board, minimum 20mm from any high-speed trace (GbE pairs, USB 3.0, HDMI).
  Orient so the battery ejects away from the board centre for service access.
* **Battery replacement:** Classified as a **service-by-disassembly** task - not field-replaceable in-situ.
  Expected interval: >25 years under normal use. See `design/Guides/Maintenance_Guide.md`.

## 6. CM5 GPIO Mapping Matrix (Enigma-NG)

All GPIOs are referenced to **3V3_ENIG**. BCM2712 silicon limit: 50mA aggregate per GPIO bank.

> **CM5 VDD_GPIO_REF:** The CM5 module VDD_GPIO_REF pin on the Hirose DF40 200-pin module connector
> must be connected to **3V3_ENIG** (not to the CM5-internal `CM5 3V3` rail, which is not used as a
> logic reference on this board). This ensures GPIO logic levels match all 3V3_ENIG-powered peripherals
> (CPLDs, FT232H VCCIO, etc.). Failure to connect VDD_GPIO_REF to 3V3_ENIG will result in incorrect
> GPIO logic levels for the entire system.

| GPIO | Function | Type | Logic Level | Description |
| :--- | :--- | :--- | :--- | :--- |
| **2 / 3** | **I2C_SDA/SCL** | I2C | 3.3V | System I2C-1 shared with the devices listed in §4.1. |
| **4** | **ROTOR_EN_N** | Output | 3.3V | Active-low: drive LOW to enable Power Module `3V3_ENIG` LDO for sequenced rotor-stack power-up; held HIGH by R8 pull-up on PM until CM5 asserts. Routed on `J3`. |
| **5** | **PM_IO_INT_N** | Input | 3.3V | Optional interrupt input from the PM-local `PCA9534A @ 0x3F`, used to wake the power-management daemon for PM status changes. |
| **6** | **USB_FAULT_N** | Input | 3.3V | Active Low: USB power fault from on-board TPS2065C (local to Controller; no BtB pin required). |
| **7** | **PWR_GD** | Input | 3.3V | Direct PM rail-health telemetry only - HIGH while `5V_MAIN` ≥ 4.50V; does NOT trigger shutdown. Routed on `J3`. |
| **8** | **ACTUATE_REQUEST_N** | Output | 3.3V | Active-low request pulse into the Controller-local Actuation Module host dock (`J11`). |

> **GPIO matrix scope note:** `PWR_BUT_N` and `LED_PWR_N` are **not** CM5 GPIO signals and are
> deliberately absent from this table. `PWR_BUT_N` connects directly to the CM5 PMIC dedicated
> hardware power-key input pin (internal 10 kΩ pull-up; brief GND press/LOW pulse initiates orderly shutdown); active-LOW, confirmed by FR-PM-07.
> `LED_PWR_N` is a dedicated CM5 hardware output (pin 95) that drives the PM SW2 green LED circuit
> over J3. Neither signal requires GPIO direction, pull, or interrupt configuration.

### 6.1 CM5 Dedicated Hardware Pin Name Mapping

Where the CM5 exposes dedicated hardware signals (not GPIOs) using a naming convention other than
the Enigma-NG GRS `_N` active-low suffix, the design net is renamed. The original CM5 pin name is
preserved here for traceability (cross-ref: `design/Standards/Global_Routing_Spec.md §10`).

| CM5 Pin Name | CM5 Pin No. | Signal Type | Design Net Name | Notes |
| :--- | :--- | :--- | :--- | :--- |
| `LED_nPWR` | 95 (Hirose DF40 200-pin) | Dedicated hardware output | `LED_PWR_N` | Active-low power-state indicator; CM5 uses `n` prefix rather than `_N` suffix |
| `PWR_BUT` | 92 (Hirose DF40 200-pin, bottom) | Dedicated HW power-key input | `PWR_BUT_N` | CM5 datasheet name is `PWR_BUT`; renamed to `PWR_BUT_N` to follow GRS active-low `_N` suffix convention. Active-LOW; brief GND pulse initiates orderly CM5 shutdown; internal 10 kΩ pull-up to 5 V; idle HIGH |

## 7. Protection & EMI

* **External Links:** The CM5-facing status inputs `PM_IO_INT_N`, `USB_FAULT_N`, and `PWR_GD` each include
  a 10kΩ series resistor to limit transient current into the GPIO bank. These are R1 (`PM_IO_INT_N`),
  R2 (`USB_FAULT_N`), and R3 (`PWR_GD`).
* **ACTUATE_REQUEST_N Boot-Safe Pull-Up:** R4 (10kΩ) ties `ACTUATE_REQUEST_N` (CM5 GPIO 8) to
  `3V3_ENIG`, holding the active-low line HIGH (inactive / no-actuation state) while CM5 GPIO 8 is
  unconfigured during early boot, preventing a spurious request pulse to the Actuation Module. R4
  serves a pull-up function and is distinct from the series-protection role of R1–R3. See DR-CTL-17.
* **Voltage:** 5V signals are strictly forbidden on: CM5 GPIO pins, I²C SDA/SCL lines, JTAG (TDI/TDO/TCK/TMS), and all low-speed PM / Stator dock signals.
* **ESD Protection:** [TPD4E05U06QDQARQ1](https://www.ti.com) (AEC-Q100 automotive-qualified TVS array;
  5.5V DC working voltage; 6.4–8.7V breakdown voltage; 10V clamping voltage (V_CLAMP at 1A TLP pulse,
  I/O to GND); ±12kV contact discharge / ±15kV air-gap discharge, IEC 61000-4-2 Level 4; 0.5 pF per
  channel; USON-10 package) on Layer 1:
  * **U4:** USB-A interface + HDMI interface ESD protection arrays (4-channel device covers both
    connector clusters).
  * **U5:** Gigabit Ethernet differential pairs A+B ESD protection.
  * **U6:** Gigabit Ethernet differential pairs C+D ESD protection.
  * U5 and U6 together protect all four GbE differential pairs. All three devices are placed on
    Layer 1 at the connector entry to minimise stub length, per
    `design/Standards/Global_Routing_Spec.md`. The same TPD4E05U06QDQARQ1 (USON-10) is used on the
    Stator at U9–U12 per `design/Electronics/Stator/Design_Spec.md §8`.
* **5V_MAIN Bulk Entry:** 5x 10µF X7R 25V at the `J1` `5V_MAIN` entry region per `design/Standards/Global_Routing_Spec.md §3` Bulk Entry Bank Rule.
* **3V3_ENIG Tap Decoupling:** The `J1` `3V3_ENIG` entry on the Controller shall follow the
  global bulk-entry bank rule: **5x 10uF X7R 25V** placed at the tap node in a
  **symmetrical star/spoke pattern** per `design/Standards/Global_Routing_Spec.md §3`.
  This applies because `3V3_ENIG` is the Controller's canonical logic rail; the
  CM5-local `CM5 3V3` rail is not used as the board logic reference.

### 7.1. PoE Front-End Passive Components

The PoE front-end (U7 TPS2372-4RGWR, U8 TPS23730RMTR, T1 POE600F-12L) requires application-circuit
support capacitors in addition to the per-IC VCC bypass capacitors specified in DR-CTL-16 (C18 for U7,
C19 for U8).

* **C17 (10nF X7R 100V 0402) — ACF Clamp Capacitor (Cclamp):** Placed in the U8 (TPS23730RMTR)
  primary-side active-clamp circuit. In ACF operating mode (selected by DEC-019), Cclamp stores and
  recycles transformer leakage inductance energy each switching cycle. The 100V voltage rating is
  required by the primary-side operating environment: the PoE bus voltage can reach 57V and primary-side
  drain transients during switching exceed this level. See DR-CTL-18 and
  `design/Electronics/Controller/PoE_Power_Analysis.md`.
* **C12, C15, C16 (100nF X7R 50V 0402) — PoE Application Circuit Support Capacitors:** Three additional
  local decoupling and application-circuit filter capacitors within the U7/U8 PoE subsystem, distinct
  from the per-IC VCC bypass capacitors C18 (U7) and C19 (U8) specified in DR-CTL-16. Typical
  application nodes in the TPS2372-4 / TPS23730 reference circuit include the VAUX auxiliary supply
  output (U7), the VS auxiliary-winding sense input (U8), and secondary-output decoupling on
  `VIN_POE_12V`. Exact per-pin assignments shall be confirmed at schematic capture of the PoE front-end.

## 8. Connectivity

### 8.1. Controller ↔ Power Module Dock

The Power Module dock uses three copies of the TE 10-position 2.5 mm connector family:

* **Controller side:** `1-1674231-1`
* **Power Module side:** `1123684-7`

**Reference datasheets:** [`TE-1-1674231-1-datasheet.md`](design/Datasheets/TE-1-1674231-1-datasheet.md),
[`TE-1123684-7-datasheet.md`](design/Datasheets/TE-1123684-7-datasheet.md)

| Link | Allocation | Description |
| :--- | :--- | :--- |
| `J1` | `3 x 5V_MAIN`, `2 x 3V3_ENIG`, `5 x GND` | Main regulated rails from PM to Controller |
| `J2` | `3 x VIN_POE_12V`, `7 x GND` | Regulated PoE-derived auxiliary feed from Controller PoE front-end into PM OR-ing stage |
| `J3` | `I2C_SDA`, `I2C_SCL`, `PM_IO_INT_N`, `PWR_GD`, `ROTOR_EN_N`, `PWR_BUT_N`, `LED_PWR_N`, `3 x GND` | Low-speed control / telemetry connector |

`5V_MAIN` and `3V3_ENIG` both enter the Controller on `J1`. The Controller then distributes those rails
to the CM5, local peripherals, and the Stator docks.

`J2` intentionally uses only three positive `VIN_POE_12V` contacts because the TE dock family is rated
at 6 A/contact and the regulated PoE auxiliary feed is a 60 W / 12 V class source (~5 A worst case).
The positive side is therefore already heavily overprovisioned, while the additional ground contacts
reduce return impedance and spread the shared current path into the PM OR-ing stage.

### 8.2. Controller ↔ Stator Dock

The Stator dock uses the Molex EXTreme Guardian HD hybrid pair:

* **Controller side:** `2195630015` receptacle
* **Stator side:** `2195620015` plug

**Reference datasheets:** [`Molex-2195630015-datasheet.md`](design/Datasheets/Molex-2195630015-datasheet.md),
[`Molex-2195630015-drawings.md`](design/Datasheets/Molex-2195630015-drawings.md),
[`Molex-2195620015-datasheet.md`](design/Datasheets/Molex-2195620015-datasheet.md),
[`Molex-2195620015-drawings.md`](design/Datasheets/Molex-2195620015-drawings.md),
[`Molex-ExtremeGuardianHD-2141130000-PS-000-specification.md`](design/Datasheets/Molex-ExtremeGuardianHD-2141130000-PS-000-specification.md)

| Link | Allocation | Description |
| :--- | :--- | :--- |
| `J4` | `4 x 5V_MAIN` blades, `1 x GND` blade, signal field = `GND` returns / guards | 5V-biased dock |
| `J5` | `4 x 3V3_ENIG` blades, `1 x GND` blade, guarded `TCK`, `TMS`, `TDI`, `TTD_RETURN`, `I2C_SDA`, `I2C_SCL`, remaining signal contacts = `GND` | 3V3 / logic dock |

The `J5` connector deliberately groups the JTAG cluster and `TTD_RETURN` with the logic-domain `3V3_ENIG` feed.

### 8.3. JDB BtB Dock (J12)

The JTAG Daughterboard mounts on the Controller via a single Hirose DF40HC(3.5)-20DS-0.4V(51)
20-pin board-to-board receptacle (J12) with 3.5mm stack height, plus four M2.5×3.5mm SMT
standoffs (MH13–MH16, 9774035151R; pads to `GND`, not `GND_CHASSIS` — see
`design/Standards/Global_Routing_Spec.md` for module mounting hole grounding rules). The JDB J1 plug mates with J12 at bottom-centre of the JDB,
with R1 (outer edge row) oriented toward the LINK-BETA connector (J4/J5) to minimise JTAG trace lengths.
See DR-CTL-19, DR-CTL-20, DEC-057, DEC-058.

#### J12 - JDB BtB Dock Connector (20-Pin DF40HC)

> **Connector Definition Owner:** `design/Electronics/JTAG_Daughterboard/Design_Spec.md §3`.
> This board provides the mating receptacle (J12). Full connector pinout, pin assignments, and
> orientation are defined and owned by the JTAG Daughterboard. Net connections from this board
> to the mounted JDB:
>
> | CTL Net    | JDB Net    |
> | :--------- | :--------- |
> | `TCK`      | `TCK`      |
> | `TMS`      | `TMS`      |
> | `TDI`      | `TDI`      |
> | `TDO`      | `TDO`      |
> | `5V_USB`   | `5V_USB`   |
> | `USB+`     | `USB+`     |
> | `USB−`     | `USB−`     |
> | `3V3_ENIG` | `3V3_ENIG` |
> | `GND`      | `GND`      |

* **Part:** Hirose DF40HC(3.5)-20DS-0.4V(51) — 3.5mm stack-height BtB receptacle, 20-pin, 0.4mm pitch.
* **DigiKey:** 26-DF40HC(3.5)-20DS-0.4V(51)CT-ND | **Mouser:** 798-DF40HC3520DS04V5 | **JLCPCB:** C3644774
* **Mating Part (JDB J1):** Hirose DF40C-20DP-0.4V(51) — plug on JDB. See `design/Electronics/JTAG_Daughterboard/Design_Spec.md §3`.

### 8.4. Fan Connector (J10)

* **Part:** JST SM04B-SRSS-TB(LF)(SN) - 4-pin JST SH 1.0mm pitch right-angle header
* **Mating Part:** JST SHR-04V-S (female crimp housing)
* **JLCPCB:** C160404 | **Mouser:** 306-SM04BSRSSTBLFSN | **DigiKey:** 455-SM04B-SRSS-TBCT-ND
* **Pinout:**

| Pin | Signal | Source |
| --- | ------ | ------ |
| 1 | 5V_MAIN | Controller 5V_MAIN rail |
| 2 | GND | Controller GND |
| 3 | FAN_TACH | CM5 module connector Pin 16 |
| 4 | FAN_PWM | CM5 module connector Pin 19 |

* FAN_TACH and FAN_PWM connect directly from the CM5 module DF40 connector (dedicated BCM2712 fan controller interface). No GPIO allocation required.
* Mating fan cable: JST SHR-04V-S housing with 4x JST SSH-003T-P0.2 crimp terminals.

### 8.5. DSI1 Display Connector (J9)

* **DSI1 Display (J9):** Amphenol **F52Q-1A7H1-11015** 15-pin 1.0mm pitch ZIF/FPC connector.
  Breaks out DSI1
  4-lane interface from CM5 for optional lid-mounted touchscreen add-on. Display add-on board
  design is deferred (see DEC-033). Connector placed near CM5 mezzanine socket on L1.
  Touch I²C routed on I²C-1 bus shared with other Stator/Controller peripherals.
* **Interface:** MIPI DSI1 - 4-lane differential (CLK+/-, D0+/-, D1+/-, D2+/-, D3+/-).
* **Impedance:** 100 Ω differential; route on L3 (stripline) - same rule as HDMI/Ethernet.
* **Pin assignment:** The J9 pin-to-signal assignment (DSI1 CLK±, data lanes D0–D3±, GND, and power
  pins) is defined by the Raspberry Pi CM5 module standard and documented in the
  [Raspberry Pi CM5 Datasheet](https://datasheets.raspberrypi.com/cm5/cm5-datasheet.pdf). These
  assignments are not a board design choice and must follow the CM5 DSI1 interface definition
  exactly; any deviation would break CM5 module compatibility.
* **MPN:** Amphenol **F52Q-1A7H1-11015**. See `design/Electronics/Consolidated_BOM.md` and
  `design/Datasheets/amphenol_ffc_fpc_100mm_f52q_f52r-datasheet.md`.
* **Power / deferred scope boundary:** `J9` is the only Controller-side display connector fixed in
  the current design scope. No separate display power header is defined on the Controller at this
  stage; any future display power and touch-side auxiliary wiring stays deferred with the display
  add-on definition.

### 8.6. Actuation Module Host Dock (J11)

> **Connector Definition Owner:** `design/Electronics/Actuation_Module/Design_Spec.md §3.1`.
> This board provides the mating receptacle (J11). Full connector pinout is defined and owned by
> the Actuation Module. Net connections from this board to the mounted AM:
>
> | CTL Net | AM Net |
> | --- | --- |
> | `5V_MAIN` | `5V_MAIN` |
> | `3V3_ENIG` | `3V3_ENIG` |
> | `GND` | `GND` |
> | `ACTUATE_REQUEST_N` | `ACTUATE_REQUEST_N` |
>
> `ACTUATE_REQUEST_N` is sourced from CM5 GPIO 8 as an active-low output pulse. The Actuation Module
> performs local homing, one-shot latching, and servo PWM generation.
>
> **⚠ PCB Layout Dependency:** J11 and MH5-MH8 positions cannot be finalised until AM schematic
> capture and PCB layout are complete. MH5-MH8 shall mirror `design/Electronics/Actuation_Module/Design_Spec.md DR-AM-03` and
> connect to `GND`.

* **Part:** Hirose DF40HC(3.5)-20DS-0.4V(51) - 20-pin 0.4mm pitch BtB receptacle, 3.5mm stacking
  height.
* **Polarity enforcement:** The DF40 connector body is polarity-free (Note 4 in Hirose datasheet);
  asymmetric placement of MH5-MH8 standoffs (per `design/Electronics/Actuation_Module/Design_Spec.md DR-AM-03`) is mandatory to
  enforce a single valid mating orientation. A silkscreen pin-1 marker is required on both boards
  (per `design/Standards/Global_Routing_Spec.md §7.1`).
* **Standoffs:** MH5-MH8 = four 9774035151R (M2.5x3.5mm SMT) provide mechanical support and set the
  3.5mm board-to-board spacing; pads connected to `GND` (not `GND_CHASSIS`). See
  `design/Standards/Global_Routing_Spec.md` for module mounting hole grounding rules.
* **Host-board envelope:** Reserve the AM footprint shadow on the Controller as a no-component zone
  except for J11, MH5-MH8, and the routing / copper needed to feed them.

## 9. PCB Fabrication & Stackup

### 9.1. PCB Fabrication (JLCPCB Specs)

* **Layers:** **6-Layer** (JLC06161H-2116 stackup).
  For production runs requiring verified controlled impedance (differential pairs: USB/HDMI/GbE),
  specify JLCPCB's 'Controlled Impedance' service (TDR-verified, ±10% tolerance). Prototype orders
  may omit this per DEC-017.
* **Finish:** **ENIG (Gold)** for all pads.
* **Solder Mask:** **Dark Green** (Vintage Industrial Lacquer aesthetic).
* **Silkscreen:** White, Typewriter-style font, Bilingual (ALL-CAPS GERMAN / Sentence-case English).

### 9.2. Advanced Layer Stackup (6-Layer / 2oz) [JLCPCB JLC06161H-2116]

* **L1 (Top):** SMT Components, I2C + PWR Control GPIOs & Shielded Ground Pour.
* **L2 (Internal):** Primary GND Plane (Logic Reference).
* **L3 (Internal):** High-Speed Data Striplines (USB/HDMI/GBE).
  * 90Ω Diff: 5.5 mil width / 7.5 mil gap (USB 3.0).
  * 100Ω Diff: 4.5 mil width / 8.5 mil gap (HDMI, Ethernet).
* **L4 (Internal):** High-Current Power Plane (5V_MAIN / 3V3_ENIG).
* **L5 (Internal):** Secondary GND Plane (Shielding).
* **L6 (Bottom):** JTAG/Data Plate (Signal/Copper Pour).

### 9.3. Trace Widths & Impedance

| Net Class | Target Impedance | Width / Spacing | Layer |
| :--- | :--- | :--- | :--- |
| **3V3_ENIG power** | N/A (Power) | 0.80 mm (31.5 mil) - 3.0A LDO max output; consistent with PM §9 and Global_Routing_Spec §1.1 Medium supply (1.0-3.0A); 2oz copper system-wide | L1 surface + L4 inner pour |
| **5V_MAIN power rail** | N/A (Low Drop) | 78.7 mil (2.00 mm) min + inner pour - 8.76A worst-case; Very High Current (> 5.5A) per Global_Routing_Spec §1.1 | L1 surface + L4 inner pour |
| **Ethernet/HDMI** | 100Ω Differential | 4.5 mil / 8.5 mil | L3 (Stripline) |
| **JTAG signals** | 50Ω Single-ended | 5.0 mil (0.127 mm) | L6 |
| **Logic/I2C** | N/A | 0.20 mm (7.87 mil) | L1 |
| **USB 2.0** | 90Ω Differential | 5.5 mil / 7.5 mil | L3 (Stripline) |
| **USB 3.0** | 90Ω Differential | 5.5 mil / 7.5 mil | L3 (Stripline) |

## 10. Thermal & Branding

### 10.1. Thermal

Estimated Controller-local power dissipation at system peak load:

| Component | Normal Dissipation | Worst Case | Notes |
| :--- | :--- | :--- | :--- |
| U7 TPS2372-4 + U8 TPS23730 + T1 POE600F-12L | ~5.1W | ~5.7W | Controller-owned PoE front-end. Loss is dominated by the PoE ACF stage / transformer path at ~51-57W PoE load; see `design/Electronics/Controller/PoE_Power_Analysis.md §3.5`. |
| **Total** | **~5.1W** | **~5.7W** | Fixed Controller-local dissipation only; excludes the CM5 SOM and any optional fan load because those depend on the fitted module SKU and runtime workload. |

* **PM Dock Power Entry:** `J1` carries the grouped regulated rail entry for the Controller. Add a **"Caution: High Current"** silkscreen label adjacent to the PM dock cluster.
* **CM5 Module Thermal Management:**
  * **Heatsink:** Mount the [Raspberry Pi CM5 Cooler](https://www.raspberrypi.com/products/cm5-cooler/)
    (SC1144, passive aluminium heatsink, ~41x56x12.7mm, conductive silicone pad) directly onto the CM5 module.
    Fasten with the four corner mounting screws for secure thermal contact.
  * **Active Fan Header (J10):** A 4-pin JST SH (1.0mm pitch) fan connector is provided on the Controller
    board, matching the CM5IO J14 standard. Supports 5V PWM-controlled fans.
    See §8.4 for the connector pinout and mating-cable definition. FAN_TACH and FAN_PWM connect
    directly to the dedicated BCM2712 fan-controller pins on the CM5 module connector - no GPIO
    allocation required.

### 10.2. Aesthetics

* **Silkscreen:** Dark Green mask with White Bilingual Typewriter font. Silkscreen legend must label each pad individually.
* **Branding:** Top-left 10mm "Enigma-NG" shielded gold emblem (Exposed ENIG Gold tied to GND_CHASSIS). Inverted Master Data Plate (Silhouette + JLC Serial Block) on L6 (Bottom).
  See `design/Standards/Global_Routing_Spec.md §6` for full branding specification.

## 11. Bill of Materials

| RefDes | Specification | MPN | Manufacturer | DigiKey PN | Mouser PN | JLCPCB PN | Alt Supplier + PN | Notes | Footprint Available | Footprint Downloaded | Qty |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| BT1 | CR2032 holder THT horizontal | 3034TR | Keystone Electronics | 36-3034CT-ND | 534-3034TR | C5213768 | - | - | Yes | Pending | 1 |
| C1-C5, C7-C11 | 10µF X7R 25V 0805 | CL21B106KAYQNNE | Samsung | 1276-CL21B106KAYQNNECT-ND | 187-CL21B106KAYQNNE | C3039694 | - | - | Yes | Pending | 10 |
| C6, C12-C16, C18, C19 | 100nF X7R 50V 0402 | CL05B104KB5NNNC | Samsung | 1276-CL05B104KB5NNNCCT-ND | 187-CL05B104KB5NNNC | C960916 | - | - | Yes | Pending | 8 |
| C17 | 10nF 100V X7R 0402 | C0402C103K1RACAUTO | Kemet | 399-C0402C103K1RACAUTOCT-ND | 80-C0402C103K1RAUTO | C19862710 | - | - | Yes | Pending | 1 |
| D1 | Schottky SOT-23 | BAT54 | Vishay | 4878-BAT54CT-ND | 637-BAT54 | C49435667 | - | - | Yes | Pending | 1 |
| J1-J3 | 10-pos 2.5mm receptacle 10-pos vert | 1-1674231-1 | TE Connectivity | A119250-ND | 571-1-1674231-1 | C3683260 | - | - | Yes | Pending | 3 |
| J4, J5 | 5-pwr+15-sig press-fit receptacle hybrid | 2195630015 | Molex | 900-2195630015-ND | 538-219563-0015 | Global sourcing / consignment | Global sourcing | - | Yes | Pending | 2 |
| J6 | USB 3.0 Type-A dual-stack | 48406-0003 | Molex | WM10420-ND | 538-48406-0003 | C565298 | - | - | Yes | Pending | 1 |
| J7 | HDMI Type-A full-size | 2007435-1 | TE Connectivity | A141617-ND | 571-2007435-1 | C195051 | - | - | Yes | Pending | 1 |
| J8 | RJ45 w/ magnetics/PoE long-body THT | 7499111121A | Wurth Elektronik | 1297-1070-5-ND | 710-7499111121A | C5523983 | - | - | Yes | Pending | 1 |
| J9 | DSI1 15-pin 1.0mm ZIF | F52Q-1A7H1-11015 | Amphenol | 609-F52Q-1A7H1-11015CT-ND | 649-F52Q-1A7H1-11015 | C3169095 | - | - | Yes | Pending | 1 |
| J10 | 4-pin SH 1.0mm fan SMT | SM04B-SRSS-TB(LF)(SN) | JST | 455-SM04B-SRSS-TBCT-ND | 306-SM04BSRSSTBLFSN | C160404 | - | - | Yes | Pending | 1 |
| J11, J12 | 20-pin 0.4mm pitch BtB receptacle 3.5mm stack | DF40HC(3.5)-20DS-0.4V(51) | Hirose | 26-DF40HC(3.5)-20DS-0.4V(51)CT-ND | 798-DF40HC3520DS04V5 | C3644774 | - | - | Yes | Pending | 2 |
| J14-J15 | CM5 SO-DIMM 100-pin 4mm | 10164227-1004A1RLF | Amphenol | 609-10164227-1004A1RLFCT-ND | 649-101642271004RLF | C7435219 | - | - | Yes | Pending | 2 |
| MH1-MH4 | M2.5x4.0mm SMT standoff | 9774040151R | Wurth Elektronik | 732-7089-1-ND | 710-9774040151R | C5182034 | - | - | Yes | Pending | 4 |
| MH5-MH8, MH13-MH16 | M2.5x3.5mm SMT standoff | 9774035151R | Wurth Elektronik | 732-9774035151RCT-ND | 710-9774035151R | C22367582 | - | - | Yes | Pending | 8 |
| R1-R3 | 10kΩ 1% 0603 | ERJ-3EKF1002V | Panasonic | P10.0KHCT-ND | 667-ERJ-3EKF1002V | C191124 | - | - | Yes | Pending | 3 |
| R4 | 10kΩ 1% 0603 | ERJ-3EKF1002V | Panasonic | P10.0KHCT-ND | 667-ERJ-3EKF1002V | C191124 | - | - | Yes | Pending | 1 |
| T1 | PoE transformer 1500V 12-pin SMT | POE600F-12L | Coilcraft | N/A | N/A | N/A | - | Only available direct from Coilcraft | Yes | Pending | 1 |
| U1 | CM5 module SO-DIMM | CM5 | Raspberry Pi Ltd | N/A - source from RPi distributors | various CM5 SKUs | N/A - not stocked at JLCPCB | - | - | N/A | N/A | 1 |
| U2 | USB power switch SOT-23-5 | TPS2065CDBVR | Texas Instruments | 296-39353-1-ND | 595-TPS2065CDBVR | C353882 | - | - | Yes | Pending | 1 |
| U3 | HDMI power switch SOT-23-5 | AP2331W-7 | Diodes Inc | AP2331W-7DICT-ND | 621-AP2331W-7 | C460346 | - | - | Yes | Pending | 1 |
| U4-U6 | 4-ch ESD ±15kV 0.5pF U-DFN-10 | TPD4E05U06QDQARQ1 | Texas Instruments | 296-40696-1-ND | 595-PD4E05U06QDQARQ1 | C81353 | - | - | Yes | Pending | 3 |
| U7 | PoE PD interface VQFN-24 4x4mm | TPS2372-4RGWR | Texas Instruments | 296-45285-1-ND | 595-TPS2372-4RGWR | C470955 | - | - | Yes | Pending | 1 |
| U8 | PoE auxiliary controller WSON-10 3x3mm | TPS23730RMTR | Texas Instruments | 296-TPS23730RMTRCT-ND | 595-TPS23730RMTR | C3189530 | - | - | Yes | Pending | 1 |

### BOM Notes

Telemetry shunt specifications and Kelvin-sensing notes are detailed in §4. Protection, ESD, bulk
decoupling, and `ACTUATE_REQUEST_N` pull-up (R4) are detailed in §7; PoE front-end passive assignments
including the ACF clamp capacitor C17 and application-circuit support capacitors C12, C15, C16 are in
§7.1. Dock-connector ownership and mating-part specifications are in §8. The matching PM dock plugs are
`TE 1123684-7`; the matching Stator dock plugs are `Molex 2195620015`.

The Controller also owns the Ethernet / PoE front-end (`TPS2372-4RGWR` U7, `TPS23730RMTR` U8, `POE600F-12L` T1, and
the Ethernet-entry ESD arrays U5/U6 - TPD4E05U06QDQARQ1, one per pair of GbE differential pairs, placed between J8 and the integrated magnetics). Those parts are tracked as Controller-owned in
`design/Electronics/Consolidated_BOM.md`; connector and local ESD rows are also repeated here for completeness.
