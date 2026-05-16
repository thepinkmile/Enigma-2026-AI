# Reflector Board Layout Visualisations

**Status:** In Review
**Project:** Enigma-NG
**Author:** Izzyonstage & GitHub Copilot
**Version:** v.0.1.0
**Associated Hardware Revision:** Rev A
**Last Updated:** 2026-05-15

## 1. Component Areas

```text
TOP VIEW (L1) - 4-Layer / 2oz Copper
 ________________________________________________________________________________ 
|                                                                                |
|   [ 30-PIN INTERCONNECT HEADER ] <--- Vertical Shrouded Box Header             |
|   (2x15, 2.54mm Pitch)                                                         |
|                                                                                |
|   [ J1-J3: ERM8 CONNECTORS ] <--- ERM8-005 (x2) + ERM8-010 (x1), male headers  |
|   (Matching Rotor Pitch)                                                       |
|                                                                                |
|   [ DATA PLATE ] <--- Inverted White Silkscreen on L4                          |
|   (Enigma Silhouette + JLC Serial)                                             |
|                                                                                |
|   [ FILLETED CORNERS ] <--- 2.0mm Rounded PCB Edges                            |
|________________________________________________________________________________|
```

## 2. Simplified Layout

```text
 _____________________________________________ 
|                                             |
|   [ INTERCONNECT ]      [ CONTACTS ]        |
|                                             |
|   (JTAG Termination)   (Signal Loopback)    |
|                                             |
|   [ DATA PLATE ]                            |
|_____________________________________________|
```

## 3. Interconnect Pinout (30-Pin 2x15 Header, J4)

J4 uses the Adam Tech 2BHR-30-VUA 30-pin 2x15 shrouded IDC box header (2.54mm pitch),
consistent with the Extension Port pinout defined in `Stator/Board_Layout.md §1 J10`.
Odd pins are on row 1; even pins on row 2.

| PIN | SIGNAL          | DIR (Reflector) | DESCRIPTION                                     |
|-----|-----------------|-----------------|-------------------------------------------------|
| 1   | 5V_MAIN         | In              | Main 5V supply                                  |
| 2   | 5V_MAIN         | In              | Main 5V supply (paired)                         |
| 3   | 3V3_ENIG        | In              | 3.3V logic supply                               |
| 4   | 3V3_ENIG        | In              | 3.3V logic supply (paired)                      |
| 5   | GND             | -               | Guard / return                                  |
| 6   | GND             | -               | Guard / return                                  |
| 7   | ENC_OUT_REF[0]  | In              | Stator-driven outbound reflector-boundary bit 0 |
| 8   | ENC_OUT_REF[1]  | In              | Stator-driven outbound reflector-boundary bit 1 |
| 9   | ENC_OUT_REF[2]  | In              | Stator-driven outbound reflector-boundary bit 2 |
| 10  | ENC_OUT_REF[3]  | In              | Stator-driven outbound reflector-boundary bit 3 |
| 11  | ENC_OUT_REF[4]  | In              | Stator-driven outbound reflector-boundary bit 4 |
| 12  | ENC_OUT_REF[5]  | In              | Stator-driven outbound reflector-boundary bit 5 |
| 13  | GND             | -               | Guard / return                                  |
| 14  | GND             | -               | Guard / return                                  |
| 15  | CPLD_RESET_N    | In              | Active-low CPLD reset (broadcast from Stator)   |
| 16  | TTD_RETURN      | Out             | JTAG Data Out Return to Stator                  |
| 17  | GND             | -               | Guard / return                                  |
| 18  | GND             | -               | Guard / return                                  |
| 19  | ENC_IN_REF[0]   | Out             | Stator-bound inbound reflector-boundary bit 0   |
| 20  | ENC_IN_REF[1]   | Out             | Stator-bound inbound reflector-boundary bit 1   |
| 21  | ENC_IN_REF[2]   | Out             | Stator-bound inbound reflector-boundary bit 2   |
| 22  | ENC_IN_REF[3]   | Out             | Stator-bound inbound reflector-boundary bit 3   |
| 23  | ENC_IN_REF[4]   | Out             | Stator-bound inbound reflector-boundary bit 4   |
| 24  | ENC_IN_REF[5]   | Out             | Stator-bound inbound reflector-boundary bit 5   |
| 25  | GND             | -               | Guard / return                                  |
| 26  | GND             | -               | Guard / return                                  |
| 27  | 3V3_ENIG        | In              | 3.3V logic supply (paired)                      |
| 28  | 3V3_ENIG        | In              | 3.3V logic supply (paired)                      |
| 29  | 5V_MAIN         | In              | Main 5V supply (paired)                         |
| 30  | 5V_MAIN         | In              | Main 5V supply (paired)                         |

---

## 4. Routing - Trace Width Specifications

**Board specs:** 4-layer / 2oz finished copper — stackup per GRS §2.3.1.
L1 = signal (JTAG/routing); L2 = GND plane; L3 = 3V3_ENIG power pour; L4 = secondary routing / data plate.

**IPC-2221A basis (2oz copper, external, 10°C rise, 25°C ambient):**
For 2oz external: ~0.15 mm/A. The 3V3_ENIG inner pour (L3) carries the bus current without width constraints.
See Global_Routing_Spec.md §1.1 for the full current-category table.

### 4.1 Trace Width Table

| Net | Peak Current | IPC Calc (2oz ext) | Design Min | **Specified Width** | Layer | Notes |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| Signal (`ENC_OUT_REF`/`ENC_IN_REF`, `CPLD_RESET_N`) | < 5 mA | < 0.001 mm | 0.20 mm | **0.254 mm** | L1 | 3.3 V passive loopback logic signals (10 mil per Design_Spec §3) |
| JTAG signals: TTD_RETURN (CI) | signal | - | 0.127 mm | **per GRS §2.3.1 / JLCPCB_Manufacturing.md §1.1** | L1 (external) | 50 Ω controlled impedance over L2 GND plane; per DEC-016. External layer - no inner-layer minimum conflict. See `JTAG_Integrity.md`. |
| 3V3_ENIG power (J4 pin 1 → bulk caps only) | ≤ 200 mA | 0.030 mm | 0.80 mm | **0.80 mm** | L1 + L3 pour | 3V3_ENIG canonical 0.80 mm (Global_Routing_Spec §1.1); passive board - minimal local draw; J2 power pins NC |
| 3V3_ENIG distribution (inner power pour) | ≤ 200 mA | - | pour | **copper pour** | L3 | Full uninterrupted 2oz plane |
| GND return (inner GND pour) | - | - | pour | **copper pour** | L2 | Reference plane; must be solid and uninterrupted under all CI traces on L1 |

### 4.2 Notes

* **JTAG CI traces:** 50 Ω controlled impedance on L1 over the L2 GND plane. Trace width per GRS §2.3.1 and `design/Production/JLCPCB_Manufacturing.md §1.1`.
* **3V3_ENIG entry:** Power received at J4 pin 3 (3V3_ENIG) and distributed to bulk caps (C1-C5) only.
  J2 power pins are NC - no distribution to the rotor chain from this board.
  0.80 mm is the system-wide canonical minimum for all 3V3_ENIG surface traces.

---

## 5. Mounting Holes

The Reflector board uses 4x M3 PTH mounting holes for chassis attachment per DR-REF-07.

### 5.1 Specifications

* **Count:** 4x M3 PTH
* **Hole diameter:** Ø3.2mm (clearance for M3 fastener)
* **Annular ring:** 6.0mm ENIG exposed pad (per GRS §4)
* **Net:** `GND_CHASSIS` — copper ring pads tied to chassis ground for Faraday-cage continuity
* **BOM:** No BOM entry; these are plain chassis mounting holes with no fitted components

### 5.2 Positions

Positions follow GRS §4.3 Pattern B (D-shaped board). Exact XY coordinates to be confirmed at PCB layout per GRS §4.2; the following describe the intended placement:

| Hole | Position Description |
| :--- | :--- |
| MH1 | Bottom-left corner |
| MH2 | Bottom-right corner |
| MH3 | Board geometric centre |
| MH4 | Top-centre: midpoint of the rounded top arc, 7 mm inset along the arc normal |

> **Note:** Exact coordinates TBD at PCB layout per GRS §4.2. The Reflector board outline and connector clearances must be factored in before finalising hole positions.

### 5.3 Cross-References

| Document | Relevance |
| :--- | :--- |
| `design/Standards/Global_Routing_Spec.md §4` | Mechanical grounding, ENIG annular ring, GND_CHASSIS bonding rules |
| `design/Standards/Global_Routing_Spec.md §4.3` | Default mounting hole placement Pattern B (D-shaped board) |
| `design/Electronics/Reflector/Design_Spec.md DR-REF-07` | Design requirement for chassis mounting holes |
