# JTAG Daughterboard (V1.0) Design Specification

**Status:** Draft
**Project:** Enigma-NG
**Author:** Izzyonstage & GitHub Copilot
**Version:** v.0.1.0
**Associated Hardware Revision:** Rev A
**Last Updated:** 2026-04-20

## 1. Overview

A high-speed USB-to-JTAG bridge module that allows the CM5 to natively program the 30-rotor CPLDs and the 6 I/O CPLDs and 1 Mapping CPLD.
This module replicates the functionality of an **Intel (Altera) USB Blaster II** on a tiny daughterboard.

### Functional & Design Requirements

#### Functional Requirements

| ID | Functional Requirement | Notes | Satisfied By / Cross-Ref |
| :--- | :--- | :--- | :--- |
| FR-JDB-01 | Provide a USB-to-JTAG programming interface for all 37 CPLDs in the system | 1 Stator + 6 Encoder + 30 Rotor CPLDs | §2 Core Logic; BOM U1 (FT232H) |
| FR-JDB-02 | Generate series-damped drive signals suitable for the controlled-impedance JTAG chain | U2 buffers TCK/TMS; 33 Ω source termination at all JTAG outputs (R2/R3 after U2 buffer, R1 at FT232H TDI, R4 before J2 TDI pin) | §6 Electrical Requirements; BOM U2, R1, R2, R3, R4 |
| FR-JDB-03 | Interface with the CM5 via USB 2.0 for JTAG programming software control | Presented as FTDI JTAG device to OpenOCD via libftdi; no custom driver required | §3 Interface & Wiring; BOM J1 (INPUT 5-pin header), U1 (FT232H) |

#### Design Requirements

| ID | Design Requirement | Specification | Satisfied By / Cross-Ref |
| :--- | :--- | :--- | :--- |
| DR-JDB-01 | PCB stackup | 4-layer, 2oz finished copper (JLC04161H-7628) | §5 PCB Fabrication & Stackup |
| DR-JDB-02 | USB-to-JTAG bridge | FTDI FT232H (U1) in MPSSE mode | §2 Core Logic; BOM U1 (FT232HL LQFP-48) |
| DR-JDB-03 | TDI series damping at FT232H | R1 = 33 Ω 0402 at FT232H TDI output | §6 Electrical Requirements; BOM R1 |
| DR-JDB-04 | JTAG chain device count | 37 devices total (1 Stator CPLD + 6 Encoder CPLDs + 30 Rotor CPLDs) | §2 Core Logic; BOM U1 (FT232H) |
| DR-JDB-05 | USB interface | USB 2.0 Full Speed via CM5 internal USB port; D+/D- route via hat-header J1 | §3 Interface & Wiring; BOM J1 (5-pin INPUT header), Y1 (12MHz crystal) |
| DR-JDB-06 | Power source | 5V_USB and 3V3_ENIG from Controller Board via hat-header J1; FT232H self-powered USB mode | §6 Electrical Requirements |
| DR-JDB-07 | Hat-style connectors | J1 = 1x5 2.54mm male pin header (INPUT); J2 = 1x10 2.54mm male pin header (JTAG OUTPUT) | §3 Interface & Wiring; BOM J1, J2 |
| DR-JDB-08 | GND_CHASSIS exemption | JDB is exempt from the local `GND_CHASSIS` net rule because it is a non-chassis-connected daughterboard; mounting holes tie to GND only | §3 Interface & Wiring |
| DR-JDB-09 | Bulk cap exception | JDB exempt from 5x bulk entry bank rule; C1-C4, C6-C9 = 8x 100nF per-IC decoupling (one per FT232H supply pin: VCCA, VCORE, VCCD, VCCIOx3, VPLL, VPHY) + C5 = 4.7µF 5V_USB entry filter | §6 Electrical Requirements; BOM C1-C9 |
| DR-JDB-10 | JTAG buffer | U2 = SN74LVC2G125DCUR (VSSOP-8) dual-channel buffer for TCK and TMS; placed between FT232H and J2 header | §6 Electrical Requirements; BOM U2; DEC-024 |
| DR-JDB-11 | TCK series damping after buffer | R2 = 33 Ω 0402 after U2 TCK output, before J2 pin 1 (TCK) | §6 Electrical Requirements; BOM R2; DEC-024 |
| DR-JDB-12 | TMS series damping after buffer | R3 = 33 Ω 0402 after U2 TMS output, before J2 pin 7 (TMS) | §6 Electrical Requirements; BOM R3; DEC-024 |
| DR-JDB-13 | TDI series damping before J2 | R4 = 33 Ω 0402 before J2 pin 3 (TDI) | §6 Electrical Requirements; BOM R4; DEC-024 |
| DR-JDB-14 | TMS pull-up near J2 | R6 = 10 kΩ 0402 pull-up from TMS to 3V3_ENIG near J2 header; idle-state TAP control | §6 Electrical Requirements; BOM R6 |
| DR-JDB-15 | TCK pull-down near J2 | R7 = 10 kΩ 0402 pull-down from TCK to GND near J2 header; idle-state TAP control | §6 Electrical Requirements; BOM R7 |
| DR-JDB-16 | FT232H RESET_N pull-up | R5 = 10 kΩ 0402 pull-up from FT232H RESET_N (FT232H pin 34; IC datasheet designates this pin as RESET#; renamed RESET_N per project convention) to 3V3_ENIG; holds RESET_N deasserted (HIGH) during normal operation per FTDI application note AN_108; absence of pull-up risks chip latching in reset | §6 Electrical Requirements; BOM R5 |
| DR-JDB-17 | JTAG buffer VCC bypass | C12 = 100nF X7R 0402 bypass capacitor shall be placed on the VCC supply of U2 (SN74LVC2G125DCUR) within 0.5mm of the VCC pin | §6 Electrical Requirements; BOM C12 |

## 2. Core Logic

* **Role:** Converts the CM5's USB 2.0 signals into standard JTAG signalling (TCK, TMS, TDI, TDO) commands.
* **Bridge IC:** [FT232H datasheet](../../Datasheets/FT232H-datasheet.md) - High-Speed USB 2.0 to MPSSE.
* **Function:** Dedicated JTAG programmer for the global chain (30x Rotor CPLDs + 6x Encoder CPLDs + 1x Stator CPLD).
* **Configuration:** 12MHz crystal-controlled for stable JTAG programming via the CM5. See DEC-022.
* **Software Stack:** `ftdi_sio` kernel module for USB enumeration; `OpenOCD` with `libftdi` for JTAG/MPSSE
  operation (no custom driver required). CM5 enumerates the FT232H on Linux boot via `ftdi_sio`.

## 3. Interface & Wiring

### J1 - INPUT Header (5-Pin, USB/Power Side)

* **Type:** Single-row 2.54mm pitch male pin header, 5 pins
* **Pinout:** Pin 1 = 5V_USB | Pin 2 = 3V3_ENIG | Pin 3 = D+ | Pin 4 = D- | Pin 5 = GND
* **Purpose:** System power in (5V_USB + GND from Controller Board TPS2065C-protected USB rail);
  JTAG signal voltage reference (3V3_ENIG from Controller Board); internal USB 2.0 data to CM5 (D+/D-)
* **Physical location:** One edge of the board (INPUT side)
* **Mating Part (Controller J12):** Adam Tech RS1-05-G - 1x5 2.54mm female socket (JLCPCB C3321119)

### J2 - JTAG OUTPUT Header (10-Pin)

* **Type:** Single-row 2.54mm pitch male pin header, 10 pins
* **Physical location:** Opposing edge of the board (OUTPUT side), physically opposite J1
* **Mating Part (Controller J13):** Adam Tech RS1-10-G - 1x10 2.54mm female socket (JLCPCB C3320525)

> **No external connectors:** The JDB has no external connectors. USB is entirely internal via J1.
> No USB-C connector exists on the JDB. CC pins are irrelevant (USB 2.0 only).
>
### J2 JTAG Pinout (10-Pin, Interleaved GND)

| Pin | Signal | Description |
| :--- | :--- | :--- |
| 1 | TCK | JTAG Clock |
| 2 | GND | Ground |
| 3 | TDI | JTAG Data In |
| 4 | GND | Ground |
| 5 | TDO | JTAG Data Out |
| 6 | GND | Ground |
| 7 | TMS | JTAG Mode Select |
| 8 | GND | Ground |
| 9 | VREF (3V3_ENIG) | Voltage Reference |
| 10 | GND | Ground |

### FT232H JTAG Signal Mapping (MPSSE Mode)

* AD0 → **TCK** (Clock)
* AD1 → **TDI** (Data In)
* AD2 → **TDO** (Data Out)
* AD3 → **TMS** (State Machine)

### Voltage

3.3V logic level (VCCIO = 3V3_ENIG). FT232H VCC = 5V_USB. 5V-tolerant I/O.

### GND_CHASSIS Single-Point Bond

Per `design/Standards/Global_Routing_Spec.md §5`, the JDB is exempt from the local
`GND_CHASSIS` requirement because it is a board-mounted daughterboard that does **not** connect
directly to the enclosure. Its mounting holes / conductive standoffs therefore tie to **GND**
only, not to a standalone `GND_CHASSIS` net. The system's only galvanic GND ↔ GND_CHASSIS bond
remains on the Power Module at the common power-entry point immediately before the eFuse.

## 4. Aesthetics & Mounting

* **Visibility:** Completely hidden internally.
* **Mounting:** Small **4-layer** PCB (DEC-017) mounted as a hat on the Controller Board via conductive
  standoffs. As a non-chassis-connected daughterboard, its mounting holes tie to **GND** only.

## 5. PCB Fabrication & Stackup

**Stackup:** JLC04161H-7628 (JLCPCB standard 4-layer, same as all other non-CTL/PM boards in the system)

| Layer | Role | Notes |
| :--- | :--- | :--- |
| L1 | GND plane + SMT component pads (component side) | Faces toward the Controller Board when JDB is mounted as a hat |
| L2 | All signal traces (inner layer) | Shielded between L1 GND reference and L3 power |
| L3 | Power distribution pours (5V_USB + 3V3_ENIG) | Inner power layer |
| L4 | GND pour shield | Faces away from the Controller (exterior/top when mounted) |

**Rationale:** Board mounts face-down on Controller (L1 toward Controller PCB). L4 GND provides exterior
shielding. L2 signals are sandwiched between two reference planes for good signal integrity. Single-side
assembly on L1 is consistent with JLCPCB SMT assembly requirements.

> **Note - Inverted Stackup:** The JDB uses an intentionally inverted 4-layer assignment (L1=GND, L2=signals, L3=power, L4=GND) vs. the standard
> pattern (L1=signal, L2=GND, L3=power, L4=signal). Placing signals on L2 immediately adjacent to the L1 GND plane achieves equivalent controlled
> impedance to outer-layer microstrip, consistent with DEC-016. See `Board_Layout.md §7.1` for JTAG trace impedance compliance detail.

## 6. Electrical Requirements

* **Power Architecture:**
  * FT232H VCC = **5V_USB** (5V) via hat-header J1 Pin 1 - from the Controller Board's TPS2065C-protected
    USB power rail (same current-limited rail as the USB 3.0 ports, 1.6A limit).
  * FT232H VCCIO = **3V3_ENIG** (3.3V) via hat-header J1 Pin 2 - sets JTAG signal voltage to match
    CPLD I/O logic levels (same role as CM5 GPIO reference voltage).
  * FT232H VBUS pin tied to **5V_USB** (always-on; USB connection to CM5 is internal - no VBUS monitoring needed).
  * USB connection is **entirely internal**: D+ and D- travel from FT232H via J1 hat-header through the
    Controller Board PCB directly to the CM5 USB 2.0 port. No USB-C connector on the JDB.
  * FT232H operates in **self-powered USB mode** - power from system (5V_USB), not from USB host.
  * CM5 enumerates the FT232H when Linux boots and ftdi_sio loads; no JDB-side power sequencing required.
  * Controller TPS2065C is the upstream current limiter; no additional current limiter on JDB.
* **Bulk Capacitor Exception:** The JDB is exempt from the standard 5x bulk entry bank rule. The Controller
  Board upstream provides a fully-bypassed power rail. Per-IC decoupling per FT232H datasheet: C1-C4, C6-C9
  = 8x 100nF (one per FT232H supply pin: VCCA, VCORE, VCCD, VCCIOx3, VPLL, VPHY) plus a single 4.7µF
  entry filter (C5) on 5V_USB.
* **FT232H RESET_N Biasing:** R5 (10kΩ) pulls FT232H RESET_N (pin 34) to 3V3_ENIG, ensuring the chip
  remains deasserted (RESET_N HIGH = normal operation) at all times during normal use. RESET_N is active-low;
  if left floating the pin may latch LOW and prevent the FT232H from operating. An external pull-up is
  required per FTDI application note AN_108 when RESET_N is not driven by the host (see DR-JDB-16).
* **Clocking:** Dedicated 12MHz SMD crystal (Y1) for the FT232H reference clock. The FT232H internal PLL requires 12MHz; CM5 GPCLK
  option was considered and rejected - see DEC-022. Crystal load capacitors C10-C11 (33pF C0G) set the 20pF crystal load capacitance.
  **Load cap calculation:** The crystal specifies C_L = 20pF. Two equal load caps in series give C_series = C/2; adding PCB stray
  capacitance (C_stray ≈ 3-4pF, from PCB traces and FT232H XTIN input capacitance) yields:
  C_L = C/2 + C_stray = 33/2 + 3.5 ≈ 16.5 + 3.5 = **20pF ✔**
  33pF C0G is therefore the correct value. Do not change to 15pF (which would give C_L ≈ 7.5 + 3.5 = 11pF, far below spec).
* **JTAG Signal Integrity:**
  * **R1 (33Ω):** Series termination on FT232H TDI output, placed within 2mm of the FT232H TDI pin.
    TDI drives only the first CPLD in the chain (single load) - source termination at the FT232H pin
    provides matched drive (FT232H output ≈ 20Ω + R1 33Ω ≈ 53Ω) for the board-to-board path.
    Per DEC-016 intra-board/BtB termination rule. See `design/Electronics/Investigations/JTAG_Integrity.md`.
  * **R4 (33Ω):** Series damping on TDI signal (not buffered) before J2 (TDI pin). Combined with R1 at FT232H, provides damping at both ends of the FT232H-to-J2 TDI path.
  * **U2 (SN74LVC2G125DCUR, VSSOP-8):** Dual-channel 3-state buffer placed between the FT232H and
    J2 header (JTAG OUTPUT), buffering TCK and TMS for the 37-device JTAG chain load. TDI is not
    buffered - FT232H TDI drives only the first device in the chain directly.
  * **R2 (33Ω):** Series damping on U2 TCK output, placed within 2mm of the U2 output pin, before
    J2 JTAG header (TCK pin). Source impedance after U2: U2_out (≈15Ω) + R2 (33Ω) ≈ 48Ω - matched
    to 50Ω BtB trace impedance per DEC-024.
  * **R3 (33Ω):** Series damping on U2 TMS output - same function as R2 (TCK). Placed before J2 (TMS pin).
  * **Pull Resistors:** TMS 10kΩ pull-up (R6) and TCK 10kΩ pull-down (R7) near J2 header to hold JTAG TAP in defined state
    when idle (see §5 and JTAG best-practice note in `design/Electronics/Investigations/JTAG_Integrity.md`).
  * **Trace Width Rule:** All JTAG signal traces on L2 (signal layer) shall be routed at **0.127 mm (5 mil)** over the L1 GND reference plane, targeting **50 Ω controlled impedance**. See DEC-016.

> **Signal Integrity note (JDB as complete JTAG master):** The JDB hosts all JTAG buffering and
> termination for the system. U2 buffers TCK and TMS for the 37-device chain load. Series damping
> (R2-R4) at 33 Ω matches the BtB trace impedance (50 Ω) per DEC-016. The Controller `J5` ↔ Stator
> `J12` logic dock is a direct board-to-board connection (no cable) - 33 Ω applies throughout (not
> the 75 Ω cable-driving rule).
> The Controller board routes JTAG lines as pass-through without active components. See DEC-024.
>
## 7. Thermal & ESD

* **Thermal:** Low-power debug board; no thermal management required.
* **ESD:** No TVS/ESD protection required - all connectors (J1, J2) are internal hat-headers, per `design/Standards/Global_Routing_Spec.md §9`.

---

## 8. Bill of Materials

<!-- markdownlint-disable MD013 MD055 MD056 -->
| RefDes | Specification | MPN | Manufacturer | DigiKey PN | Mouser PN | JLCPCB PN | Alt Supplier + PN | Notes | Footprint Available | Footprint Downloaded | Qty |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| C1-C4, C6-C9, C12 | 100nF X7R 50V 0402 | CL05B104KB5NNNC | Samsung | 1276-CL05B104KB5NNNCCT-ND | 187-CL05B104KB5NNNC | C960916 | - | - | Yes | Pending | 9 |
| C5 | 4.7µF X7R 1210 | CGA6P3X7R1H475K250AD | TDK | 445-10040-1-ND | 810-CGA6P3X7R1H475KD | C3877549 | - | - | Yes | Pending | 1 |
| C10-C11 | 33pF C0G/NP0 crystal load 0402 | C0402C330J5GAUTO | Kemet | 399-12979-1-ND | 80-C0402C330J5GAUTO | C2169327 | - | C0G/NP0 exception approved - only C0G in system | Yes | Pending | 2 |
| J1 | 1x5 2.54mm male INPUT header THT | PH1-05-UA | Adam Tech | 2057-PH1-05-UA-ND | 737-PH1-05-UA | C5374051 | - | - | Yes | Pending | 1 |
| J2 | 1x10 2.54mm male JTAG OUTPUT header THT | PH1-10-UA | Adam Tech | 2057-PH1-10-UA-ND | 737-PH1-10-UA | C3330527 | - | - | Yes | Pending | 1 |
| R1-R4 | 33Ω 1% 0402 | ERJ-2RKF33R0X | Panasonic | P33.0LCT-ND | 667-ERJ-2RKF33R0X | C278594 | - | see DEC-016; see DEC-024 | Yes | Pending | 4 |
| R5-R7 | 10kΩ 1% 0402 | ERJ-2RKF1002X | Panasonic | P10.0KLCT-ND | 667-ERJ-2RKF1002X | C191123 | - | - | Yes | Pending | 3 |
| U1 | USB 2.0 to MPSSE bridge LQFP-48 | FT232HL-REEL | FTDI Chip | 768-1101-1-ND | 895-FT232HL-REEL | C51997 | - | - | Yes | Pending | 1 |
| U2 | Dual 3-state buffer VSSOP-8 | SN74LVC2G125DCUR | Texas Instruments | 296-SN74LVC2G125DCURCT-ND | 595-SN74LVC2G125DCUR | C21404 | - | - | Yes | Pending | 1 |
| Y1 | 12MHz 20pF ±20ppm crystal SMD-3225 | 435F12012IET | CTS | 110-435F12012IETTR-ND | 774-435F12012IET | C19766404 (Extended) | - | see DEC-022 | Yes | Pending | 1 |
<!-- markdownlint-enable MD013 MD055 MD056 -->
