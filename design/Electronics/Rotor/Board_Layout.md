# Rotor Board Layout Visualisations

**Status:** Draft
**Project:** Enigma-NG
**Author:** Izzyonstage & GitHub Copilot
**Version:** v.0.1.0
**Associated Hardware Revision:** Rev A
**Last Updated:** 2026-04-20

For mechanical tolerances and shroud assembly details, see
`design/Mechanical/Rotor/Design_Spec.md`.

---

## 1. Split Board Architecture Overview

Each rotor assembly consists of two circular PCBs (Board A and Board B), each Ø92mm, separated
by an 11.8mm gap and connected by four single-row 2.54mm THT headers (J7 1x5, J8 1x5,
J9 1x5, J10 1x7; 22 pins total; mixed gender for keying).The two boards are mechanically
retained inside the aluminium shroud (Ø100mm outer face, 4mm radial wall, Ø92mm inner). Total
rotor thickness is ~15mm.

---

## 2. Board A - Input Side (Ø92mm)

Board A faces the input (upstream) side of the rotor stack.

```text
4-Layer / 2oz Copper / ENIG / Circular Ø92mm - BOARD A (INPUT SIDE)

                        TOP (outer face, faces upstream)
         __________________________________________________
        /                                                  \
       /    [SW1] ring setting DIP                          \
      |     [SW2] forward map select DIP                     |
      |                                                      |
      |              [ U1: CPLD EPM570T100I5N ]              |
      |                  (( NPTH Ø10mm ))                    |
      |                  (centre keep-out r≥6mm)             |
      |                                                      |
      |   [S0][S1][S2]  <-- Track A sensor electrodes        |
      |   (bare Cu pads at r=44mm, Board A face)             |
      |         [ U2: FDC2114 ] (at r~40mm)                  |
      |                                                      |
      | [J1 ERM8]  [J2 ERM8]  [J3 ERM8]                      |
       \   (JTAG)   (Power)  (ENC Data)   equally spaced    /
        \__________________________________________________/

                    BOTTOM (inner face, faces Board B)
          [ J14 M ]  [ J7 F ]  [ J8 F ]  [ J11 M ]
                         (manually assembled post-SMT)
```

### 2.1 Board A Component Summary

| Ref | Component | Notes |
| :--- | :--- | :--- |
| U1 | EPM570T100I5N CPLD | Centre of board |
| U2 | FDC2114RGHR | Track A capacitive encoder IC (I²C addr 0x2A); r~40mm |
| U11A | FDC2114RGHR | STGC bit[4] sensor IC (I²C addr 0x2B); Board A, N=26 builds only - NOT POPULATED for N=64 |
| L1-L4 | Bourns CWF1610A-180K - 18 µH unshielded 0603 chip inductor | U2 CH0-CH3 resonant tank inductors - placed adjacent to U2, one per channel; pair with C16-C19 |
| L5A-L8A | Bourns CWF1610A-180K - same part as L1-L4 | U11A CH0-CH3 resonant tank inductors (includes dummy LC for unused channels) - **N=26 only, NOT POPULATED for N=64** |
| C16-C19 | YAGEO AC0402FRNPO9BN330 - 33 pF C0G/NP0 ±1% MLCC | U2 CH0-CH3 resonant tank capacitors - in parallel with L1-L4 between INxA/INxB |
| C22A-C25A | YAGEO AC0402FRNPO9BN330 - same part as C16-C19 | U11A CH0-CH3 resonant tank capacitors - **N=26 only, NOT POPULATED for N=64** |
| S0-S2 | Sensor electrodes (Track A) | Bare Cu pads at r=44mm, N=64 bits[5:3]; or S0-S4 for N=26 |
| SW1 | 6-pos DIP - ring setting | Input side only |
| SW2 | 6-pos DIP - forward map select | Input side |
| J1 | ERM8-005 male | JTAG input (10-pin 2x5, 0.8mm pitch) |
| J2 | ERM8-005 male | Power input (10-pin 2x5, 0.8mm pitch) |
| J3 | ERM8-010 male | ENC data input (20-pin 2x10, 0.8mm pitch) |
| J7 | Adam Tech RS1-05-G (female 1x5) | Inner face; manually assembled post-JLCPCB SMT |
| J8 | Adam Tech RS1-05-G (female 1x5) | Inner face; manually assembled post-JLCPCB SMT |
| J11 | Adam Tech PH1-05-UA (male 1x5) | Inner face; manually assembled post-JLCPCB SMT |
| J14 | Adam Tech PH1-07-UA (male 1x7) | Inner face; manually assembled post-JLCPCB SMT |
| U3 | TPD4E05U06QDQARQ1- 4-ch ESD array | J1 JTAG entry ESD; channels: TDI, TMS, TCK (1 spare) |
| U4 | TPD4E05U06QDQARQ1 - 4-ch ESD array | J3 ENC input ESD, array 1 of 3; ENC_IN[3:0] |
| U5 | TPD4E05U06QDQARQ1 - 4-ch ESD array | J3 ENC input ESD, array 2 of 3; ENC_IN[5:4], ENC_OUT[1:0] |
| U6 | TPD4E05U06QDQARQ1 - 4-ch ESD array | J3 ENC input ESD, array 3 of 3; ENC_OUT[5:2] |

---

## 3. Board B - Output Side (Ø92mm)

Board B faces the output (downstream) side of the rotor stack.

```text
4-Layer / 2oz Copper / ENIG / Circular Ø92mm - BOARD B (OUTPUT SIDE)

                    TOP (inner face, faces Board A)
          [ J10 F ]  [ J12 M ]  [ J13 M ]  [ J9 F ]
                         (manually assembled post-SMT)

         ___________________________________________________
        /                                                   \
       /    [SW3] return map select DIP                      \
      |                                                       |
      |                  (( NPTH Ø10mm ))                     |
      |                  (centre keep-out r≥6mm)              |
      |                                                       |
      |   [S3][S4][S5]  <-- Track B sensor electrodes         |
      |   (bare Cu pads at r=44mm, Board B face)              |
      |         [ U11B: FDC2114 ] (at r~40mm)                 |
      |         (NOT POPULATED for N=26 rotor)                |
      |                                                       |
      | [J4 ERF8]  [J5 ERF8]  [J6 ERF8]                       |
       \   (JTAG)   (Power)  (ENC Data)   equally spaced     /
        \___________________________________________________/

                        BOTTOM (outer face, faces downstream)
```

### 3.1 Board B Component Summary

| Ref | Component | Notes |
| :--- | :--- | :--- |
| U11B | FDC2114RGHR | Track B capacitive encoder IC (I²C addr 0x2B); r~40mm; **not populated for N=26** |
| L5B-L8B | Bourns CWF1610A-180K - same part as L1-L4 | U11B CH0-CH3 resonant tank inductors (includes dummy LC for unused channels) - **N=64 only, NOT POPULATED for N=26** |
| C22B-C25B | YAGEO AC0402FRNPO9BN330 - same part as C16-C19 | U11B CH0-CH3 resonant tank capacitors - **N=64 only, NOT POPULATED for N=26** |
| S3-S5 | Sensor electrodes (Track B) | Bare Cu pads at r=44mm, N=64 bits[2:0]; not present for N=26 |
| SW3 | 6-pos DIP - return map select | Output side |
| J4 | ERF8-005 female | JTAG output (10-pin 2x5, 0.8mm pitch) |
| J5 | ERF8-005 female | Power output (10-pin 2x5, 0.8mm pitch) |
| J6 | ERF8-010 female | ENC data output (20-pin 2x10, 0.8mm pitch) |
| J9 | Adam Tech RS1-05-G (female 1x5) | Inner face; manually assembled post-JLCPCB SMT |
| J10 | Adam Tech RS1-07-G (female 1x7) | Inner face; manually assembled post-JLCPCB SMT |
| J12 | Adam Tech PH1-05-UA (male 1x5) | Inner face; manually assembled post-JLCPCB SMT |
| J13 | Adam Tech PH1-05-UA (male 1x5) | Inner face; manually assembled post-JLCPCB SMT |
| U7 | TPD4E05U06QDQARQ1 - 4-ch ESD array | J4 JTAG exit ESD; channels: TDO, TMS, TCK (1 spare) |
| U8 | TPD4E05U06QDQARQ1 - 4-ch ESD array | J6 ENC output ESD, array 1 of 3; ENC_IN[3:0] |
| U9 | TPD4E05U06QDQARQ1 - 4-ch ESD array | J6 ENC output ESD, array 2 of 3; ENC_IN[5:4], ENC_OUT[1:0] |
| U10 | TPD4E05U06QDQARQ1 - 4-ch ESD array | J6 ENC output ESD, array 3 of 3; ENC_OUT[5:2] |

---

## 4. Stacking / Cross-Section

```text
  INPUT SIDE                                          OUTPUT SIDE
  (Board A outer)                                   (Board B outer)
      |                                                    |
      v                                                    v
  [J1 J2 J3]   [Board A 1.6mm]  [gap 11.8mm]  [Board B 1.6mm]   [J4 J5 J6]
  ERM8 male  |<--Ø92mm PCB-->|<--4 headers->|<--Ø92mm PCB-->|  ERF8 female
             |               |  22p total   |               |
             |<---------------  ~15mm total  -------------->|
             |       |                              |       |
             +---[SHAFT Ø10mm NPTH]---[SHAFT Ø10mm NPTH]---+
                 (board centre, keep-out r≥6mm each board)

  Aluminium shroud (Ø100mm outer, Ø92mm inner, 4mm radial wall)
  Shroud dish flange (Board A side): Track A Gray code slots milled on inner face
  Shroud cover flange (Board B side): Track B Gray code slots milled on inner face (N=64 only)
  Rolling-pin cylindrical bearings (ceramic or nylon) around circumference - electrically isolating
  Shroud outer cylindrical face: characters engraved at r=50mm
  Central metal shaft: passes through both PCBs; NPTH + copper keep-out; shaft electrically isolated from all PCB nets
```

**Dimensions summary:**

| Item | Value |
| :--- | :--- |
| Shroud outer diameter | Ø100mm |
| Shroud radial wall thickness | 4mm |
| PCB diameter (both boards) | Ø92mm |
| PCB thickness (each) | 1.6mm |
| Board gap (Board A inner to Board B inner) | ~11.8mm |
| Total rotor thickness | ~15mm |
| Sensor electrode radius | r=44mm |
| Shroud-electrode gap | 0.5mm ±0.15mm |
| Central shaft hole (NPTH, both PCBs) | Ø10mm nominal (8-12mm TBD) |
| Central copper keep-out zone | r ≥ 6mm from board centre |

---

## 5. Rotor Interface Connectors
>
> **Connector Definition Owner:** This board. All other boards hosting rotor interface connectors
> (Stator J1-J3, Extension J1-J6, Reflector J1-J3) cross-reference here.

Each rotor position uses **three connectors** - one for ENC data in, one for ENC data out, and one for power/JTAG.
These three connectors must be **positionally identical** across every board that mates with rotors
(Stator input side, Extension mid-stack, Reflector final output) to allow any rotor to mate at any position.

> **⚠️ Note:** The earlier draft signal maps (ENC-IN, ENC-OUT, PWR/JTAG with 8-pin and 14-pin tables)
> have been removed. All connector definitions now live exclusively in `Rotor/Design_Spec.md §3.4`.
> Use the Design_Spec §3.4 tables for all schematic and PCB layout work.
>
### 5.1 Connector Summary

Each rotor carries **six connectors** - three male ERM8 headers on the input side (J1-J3) and three female
ERF8 sockets on the output side (J4-J6). See `Rotor/Design_Spec.md §3.4` for the authoritative pinout tables.

| Designator | Type | Part | Pins | Function |
| :--- | :--- | :--- | :--- | :--- |
| J1 | ERM8-005 male | 200-ERM8005050SDVKTR | 10 (2x5) | JTAG input |
| J2 | ERM8-005 male | 200-ERM8005050SDVKTR | 10 (2x5) | Power input |
| J3 | ERM8-010 male | 200-ERM8010050SDVKTR | 20 (2x10) | Encoder data input |
| J4 | ERF8-005 female | 200-ERF8005050SDVKTR | 10 (2x5) | JTAG output → next rotor J1 |
| J5 | ERF8-005 female | 200-ERF8005050SDVKTR | 10 (2x5) | Power output → next rotor J2 |
| J6 | ERF8-010 female | 200-ERF8010050SDVKTR | 20 (2x10) | Encoder data output → next rotor J3 |

### 5.2 TTD Routing Note

TTD (JTAG Transmission Data) does not chain back through the Extension Port individually per rotor. Each
rotor passes TTD to the **next rotor's TDI** directly via J4 pin 6 → next Rotor J1 pin 6. Only **Rotor 30**
(last in chain) routes its TDO via the Reflector back to Stator J10 pin 16 as TTD_RETURN.

---

## 6. U1 - Rotor CPLD Signal Map (Logical Pin Budget)

> This is the board-authoritative **logical** signal map for Rotor Board A `U1`. The local MAX II
> handbook confirms `EPM570T100` package availability in TQFP-100, but it points printed device
> pin-outs to external package documentation rather than providing a fixed package pin table locally.
> The map below therefore freezes the required rotor connectivity while leaving exact TQFP pad numbers
> to schematic capture.

### 6.1 Dedicated device pins

| Function | Source / destination | Notes |
| :--- | :--- | :--- |
| `TCK` | J1 pin 2 / J8 pin 1 -> U1 | Dedicated JTAG clock input; forwarded to Board B and onwards to J4 |
| `TMS` | J1 pin 4 / J8 pin 3 -> U1 | Dedicated JTAG mode input; forwarded to Board B and onwards to J4 |
| `TDI` | J1 pin 6 (`TTD`) -> U1 | Incoming serial JTAG data from the previous stage; connector name stays `TTD` for stack clarity |
| `TDO` | U1 -> J8 pin 5 / J4 pin 6 (`TTD`) | Outgoing serial JTAG data to the next stage |
| `DEV_CLR_N` / reset input | J1 pin 8 (`SYS_RESET_N`) / J8 pin 4 -> U1 | Active-low device reset; held high locally by R4 (vendor name `DEV_CLRN` renamed `DEV_CLR_N` per GRS active-low naming convention) |

### 6.2 General-purpose signal groups

| Signal group | Pins | U1 direction | Notes |
| :--- | :---: | :--- | :--- |
| `J3 ENC_IN[5:0]` | 6 | Input | Forward-path cipher input from the upstream stage |
| `J6 ENC_OUT[5:0]` | 6 | Output | Forward-path cipher result to the downstream stage |
| `J6 ENC_IN[5:0]` | 6 | Input | Return-path cipher input from the downstream stage |
| `J3 ENC_OUT[5:0]` | 6 | Output | Return-path cipher result back to the upstream stage |
| `SW1[5:0]` | 6 | Input | Ring-setting switch bank on Board A |
| `SW2[5:0]` | 6 | Input | Forward-map select switch bank on Board A |
| `SW3[5:0]` | 6 | Input | Return-map select switch bank brought from Board B via `J14` |
| Local `SDA`, `SCL` | 2 | Bidirectional | CPLD I2C master for U2/U11A/U11B position sensors; `J11` extends the same bus to Board B U11B |

**Logical budget summary:** 44 general-purpose signal connections total = **30 inputs + 12 outputs + 2
bidirectional I2C lines**, plus the dedicated JTAG / reset pins above.

**Variant / reserve policy:** `ENC[5]` remains physically routed for the shared 20-pin connector pinout
even on N=26 builds where that bit is logically unused. `J11` pins 3-5 stay reserved and are not
currently tied into U1. Virtual JTAG position export uses the dedicated JTAG infrastructure and does
not consume extra board-level I/O pins.

---

## 7. Routing - Trace Width Specifications

**Board specs:** 4-layer / 2oz finished copper (JLC04161H-7628).
L1 = signal (JTAG/routing); L2 = GND plane; L3 = 3V3_ENIG power pour; L4 = secondary routing / data plate.

**IPC-2221A basis (2oz copper, external, 10°C rise, 25°C ambient):**
For 2oz external: ~0.15 mm/A. The 3V3_ENIG inner pour (L3) handles bus current without width constraints.
See Global_Routing_Spec.md §1.1 for the full current-category table.

**Rotor power analysis (pass-through sizing):**
Each rotor draws 50 mA (EPM570) + 2 x 2.1 mA (FDC2114 pair U2/U11B or U2/U11A) = **54.2 mA ≈ 55 mA** locally.
The J2 power input connector daisy-chains 3V3_ENIG through J5 to the next rotor within the same
mini-stack. Each mini-stack contains a maximum of **5 rotors**; 3V3_ENIG is re-injected fresh at
each mini-stack boundary by an Extension Board (via its J5, fed from the Extension Port J7).
All rotor PCBs are **identical**, so traces must be sized for the worst case - **Rotor 1** of any
mini-stack, which receives power for all 5 rotors in its group.
Using the 55 mA design budget, Rotor 1 carries **275 mA** through its J2 connector and passes
4 x 55 mA = **220 mA** to Rotor 2 via J5.

| Rotor position in mini-stack | J2 input current | Local draw | J5 output current |
| :--- | :--- | :--- | :--- |
| Rotor 1 (worst case) | 275 mA | 55 mA | 220 mA |
| Rotor 3 (mid-stack) | 165 mA | 55 mA | 110 mA |
| Rotor 5 (last in mini-stack) | 55 mA | 55 mA | 0 A |

IPC calculation for worst-case 275 mA at 2oz external: 0.275 x 0.15 mm = 0.04 mm → **0.80 mm**
(3V3_ENIG canonical width per Global_Routing_Spec §1.1; consistent with PM, Stator, and Extension
Board 3V3_ENIG trunk traces).

### 7.1 Trace Width Table

| Net | Peak Current | IPC Calc (2oz ext) | Design Min | **Specified Width** | Layer | Notes |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| Signal (ENC_IN/OUT, FDC2114 I2C SDA/SCL, SYS_RESET_N) | < 5 mA | < 0.001 mm | 0.20 mm | **0.20 mm** | L1 | 3.3 V logic; CPLD data I/O; I2C to FDC2114 capacitive encoder; SYS_RESET_N is a slow-logic CPLD reset sourced from Stator U7 GPA[7] - not a CI signal |
| JTAG signals: TCK, TMS, TTD in/out (CI) | signal | - | 0.127 mm | **0.127 mm (5 mil)** | L1 (external) | 50 Ω controlled impedance over L2 GND plane; per DEC-016. External layer - no inner-layer minimum conflict. |
| 3V3_ENIG local draw (J2 → CPLD + FDC2114 supply) | 55 mA | 0.008 mm | 0.80 mm | **0.80 mm** | L1 + L3 pour | 3V3_ENIG canonical 0.80 mm (Global_Routing_Spec §1.1); local IC supply only |
| 3V3_ENIG pass-through rail (J2 input → J5 output bus) | 275 mA (Rotor 1 of mini-stack; 5 rotors max) | 0.04 mm | 0.80 mm | **0.80 mm** | L1 + L3 pour | Canonical 3V3_ENIG trunk width (Global_Routing_Spec §1.1); Rotor 1 worst case for a 5-rotor mini-stack; feeds L3 pour via thermal vias between J2 and J5 |
| 3V3_ENIG distribution (inner power pour) | up to 275 mA | - | pour | **copper pour** | L3 | Full uninterrupted 2oz plane; primary distribution across the board |
| GND return (inner GND pour) | - | - | pour | **copper pour** | L2 | Reference plane; must be solid and uninterrupted under all CI traces on L1 |

### 7.2 Notes

* **JTAG CI traces:** 0.127 mm (5 mil) on L1 over the L2 GND plane achieves 50 Ω controlled
  impedance on the JLC04161H-7628 stackup (h = 0.087 mm, t = 0.035 mm, Eᵣ = 4.4). Per DEC-016.
  See `design/Electronics/Investigations/JTAG_Integrity.md §3.1`.
* **No series termination on BtB stack path.** 75 Ω series termination applies to the Stator ribbon
  cable ports only (see `Stator/Board_Layout.md §8`). Rotor-to-rotor BtB connectors (J4/J5) are
  unterminated; no series termination resistor is used on this board.
* **3V3_ENIG power rail:** The L3 copper pour is the primary current path. L1 surface traces at
  0.80 mm connect J2/J5 connector pads to the L3 pour via thermal vias. All rotor boards share
  the same PCB layout - the 0.80 mm canonical width provides substantial margin above the 275 mA
  mini-stack worst case (IPC minimum: 0.04 mm). 3V3_ENIG is re-injected at each mini-stack boundary
  by an Extension Board, so no rotor ever passes more than 5 x 55 mA = 275 mA through J2.

---

## 8. PCB Keep-Out Zones

### 8.1 Central Shaft Keep-Out

A central NPTH (non-plated through-hole) of Ø10mm nominal (8-12mm TBD) is required at the board
centre of **both** Board A and Board B to accommodate the rotor support shaft.

| Zone | Radius from centre | Constraint |
| :--- | :--- | :--- |
| Shaft hole | 0-5mm | NPTH - no copper barrel, no plating |
| Keep-out (clearance) | 5-6mm | No copper, pads, vias, or silkscreen |
| Routing may begin | r > 6mm | Components and traces permitted outside this boundary |

**Rationale:** The shaft is a metal rod and must remain electrically isolated from all PCB nets.
The NPTH construction with copper keep-out ensures no galvanic continuity between shaft and
board. The L2 GND plane and L3 3V3\_ENIG pour must both be voided around this zone on all layers.

> **Cross-reference:** `design/Mechanical/Rotor/Design_Spec.md §7` for full shaft support
> rationale, mechanical tolerance, and electrical isolation requirements.

---

## 9. Mounting Holes

Per DR-ROT-08, each rotor assembly uses 4x M2.5 mounting holes (2 per board). The hole positions
define the 4 corners of the inscribed square of the Ø92mm circular PCB, making it straightforward
to design a rectangular mechanical enclosure around the rotor stack.

### 9.1 Inscribed Square Reference

For a circular PCB of diameter Ø92mm (radius 45mm):

* Inscribed square side length: 92 / √2 ≈ 65.1mm
* Corner distance from board centre: ≈ 32.5mm along each axis

| Corner | X (from centre) | Y (from centre) |
| :--- | :--- | :--- |
| Top-left | −32.5 mm | +32.5 mm |
| Top-right | +32.5 mm | +32.5 mm |
| Bottom-right | +32.5 mm | −32.5 mm |
| Bottom-left | −32.5 mm | −32.5 mm |

> **Note:** Exact coordinates are subject to final confirmation at PCB Layout. The 8mm shaft hole
> at the board centre (§8.1) and the keep-out zone (r < 6mm) must be confirmed first. Rotor PCBs
> rotate within the mechanical enclosure so the inscribed-square hole positions ensure all 4 corners
> of any surrounding rectangular structure have a mounting point.

### 9.2 Board A — Mounting Holes

Board A carries 2 of the 4 inscribed-square corner holes:

| Hole | Position (from centre) | Specification |
| :--- | :--- | :--- |
| MH1A | Top-left (−32.5, +32.5) approx. | Ø2.7mm PTH; ENIG annular ring; net: `GND_CHASSIS` |
| MH2A | Bottom-right (+32.5, −32.5) approx. | Ø2.7mm PTH; ENIG annular ring; net: `GND_CHASSIS` |

### 9.3 Board B — Mounting Holes

Board B carries the remaining 2 inscribed-square corner holes:

| Hole | Position (from centre) | Specification |
| :--- | :--- | :--- |
| MH1B | Top-right (+32.5, +32.5) approx. | Ø2.7mm PTH; ENIG annular ring; net: `GND_CHASSIS` |
| MH2B | Bottom-left (−32.5, −32.5) approx. | Ø2.7mm PTH; ENIG annular ring; net: `GND_CHASSIS` |

### 9.4 GND_CHASSIS Bond

Per GRS §4 (Mechanical Grounding) and F-103: all 4 mounting hole copper ring pads (MH1A, MH2A,
MH1B, MH2B) are tied to the `GND_CHASSIS` net. This provides Faraday-cage continuity from the
rotor assembly to the chassis through the metal support rod and enclosure structure.

> **Note:** The 8mm support rod (DR-ROT-08) passes through the shaft hole at the board centre
> (§8.1), not through these corner mounting holes. The corner holes are for static mechanical
> attachment to the enclosure frame; the central rod provides dynamic alignment and connector
> stress relief for the rotating stack.

### 9.5 BOM

No BOM entry required for these mounting holes — they are plain PCB holes with ENIG annular
rings, fitted with M2.5 fasteners and standoffs sourced at assembly time.

### 9.6 Cross-References

| Document | Relevance |
| :--- | :--- |
| `design/Standards/Global_Routing_Spec.md §4` | Mechanical grounding, GND_CHASSIS bonding, ENIG annular ring spec |
| `design/Electronics/Rotor/Design_Spec.md DR-ROT-08` | Design requirement — 4x mounting holes, inscribed square positions |
| `design/Electronics/Rotor/Board_Layout.md §8.1` | Central shaft hole spec (separate from mounting holes) |
