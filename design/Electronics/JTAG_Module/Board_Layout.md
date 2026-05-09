# JTAG Module Layout Visualisations

**Status:** In Review
**Project:** Enigma-NG
**Author:** Izzyonstage & GitHub Copilot
**Version:** v.0.1.0
**Associated Hardware Revision:** Rev A
**Last Updated:** 2026-04-26

This board implements our version of an Intel (Altera) USB Blaster II device for programming CPLDs.

## 1. Component Areas

```text
TOP VIEW (L1) - 4-Layer (DEC-017) / 2oz Copper
 _______________________________________________________________________________________
|                                                                                       |
|   [ MH1 ]                                                   [ MH2 ]                   |
|   (Top-Left, M2.5 NPTH, 7mm from edge)                     (Top-Right, M2.5 NPTH)     |
|                                                                                       |
|   [ FT232H IC ] <--- High-Speed USB to MPSSE Bridge                                   |
|   (Main IC for JTAG Blaster, 12MHz Crystal Attached)                                  |
|                                                                                       |
|   [ DATA PLATE ] <--- Inverted White Silkscreen on L4 (B.Silkscreen / exterior face)  |
|   (Enigma Silhouette + JLC Serial)                                                    |
|                                                                                       |
|    [ MH3 ]                     [ J1 DF40 ]                    [ MH4 ]                 |
|   (Bot-Left, inset 12mm)       (Bottom-Centre, 20-pin BtB)    (Bot-Right, inset 12mm) |
|_______________________________________________________________________________________|
```

## 2. Simplified Layout

```text
 ________________________________________________ 
|  [MH1]                               [MH2]     |
|                                                |
|          [ FT232H + supporting components ]    |
|                                                |
|  [MH3]         [ J1 DF40 BtB ]         [MH4]   |
|_________________(Bottom-Centre)________________|
```

> **Connector Definition Owner:** This board. All other boards connecting to the JTAG Module cross-reference here.
>
## 3. J1 DF40C-20 BtB Connector Pinout (20-Pin, Bottom-Centre)

**Part:** Hirose DF40C-20DP-0.4V(51)  
**Location:** Bottom-centre of board; R1 row on the outer (bottom) board edge.  
**Mating part (CTL J12):** Hirose DF40HC(3.5)-20DS-0.4V(51) — 3.5mm stack-height receptacle on CTL board.

```text
       C1     C2     C3     C4     C5     C6     C7     C8     C9    C10
  R1:  TCK    GND    GND   5V_U   GND    GND   3V3    GND    GND    TDI
  R2:  GND    TMS    GND    GND   USB+   USB-   GND    GND    TDO    GND
```

R1 = outer (bottom) edge; R2 = inner row.

| Pin   | Signal     | Dir        | Description                                         |
| :---- | :--------- | :--------- | :-------------------------------------------------- |
| C1R1  | TCK        | JM → CTL   | JTAG Clock (buffered via U2; 33Ω via R2)            |
| C2R1  | GND        | —          | Ground                                              |
| C3R1  | GND        | —          | Ground                                              |
| C4R1  | 5V_USB     | CTL → JM   | 5V USB power from CTL TPS2065C rail                 |
| C5R1  | GND        | —          | Ground                                              |
| C6R1  | GND        | —          | Ground                                              |
| C7R1  | 3V3_ENIG   | CTL → JM   | 3.3V logic rail / JTAG signal reference             |
| C8R1  | GND        | —          | Ground                                              |
| C9R1  | GND        | —          | Ground                                              |
| C10R1 | TDI        | JM → CTL   | JTAG Data In (33Ω via R4; R1 at FT232H)             |
| C1R2  | GND        | —          | Ground                                              |
| C2R2  | TMS        | JM → CTL   | JTAG Mode Select (buffered via U2; 33Ω via R3)      |
| C3R2  | GND        | —          | Ground                                              |
| C4R2  | GND        | —          | Ground                                              |
| C5R2  | USB+       | Bidir      | USB 2.0 D+ to CM5 (USB FS differential pair)        |
| C6R2  | USB−       | Bidir      | USB 2.0 D− to CM5 (USB FS differential pair)        |
| C7R2  | GND        | —          | Ground                                              |
| C8R2  | GND        | —          | Ground                                              |
| C9R2  | TDO        | CTL → JM   | JTAG Data Out (return from chain)                   |
| C10R2 | GND        | —          | Ground                                              |

## 5. PCB Stackup - JLC04161H-7628 (4-Layer)

**Stackup:** JLC04161H-7628 (JLCPCB standard 4-layer)

| Layer | Role | Notes |
| :--- | :--- | :--- |
| L1 | GND plane + SMT component pads (component side) | Faces toward Controller Board when JM is mounted as a hat |
| L2 | All signal traces (inner layer) | Shielded between L1 GND reference and L3 power |
| L3 | Power distribution pours (5V_USB + 3V3_ENIG) | Inner power layer |
| L4 | GND pour shield | Faces away from Controller (exterior/top when mounted) |

## 6. Grounding Notes

GND_CHASSIS is not implemented on the JM - see DEC-023. Mounting holes connect to GND (circuit return).

---

## 7. Routing - Trace Width Specifications

**Board specs:** 4-layer / 2oz finished copper (JLC04161H-7628).
L1 = GND plane (component side); L2 = all signal traces (inner layer); L3 = power pours; L4 = GND pour.

**IPC-2221A basis (2oz copper, 10°C rise, 25°C ambient):**
External: ~0.15 mm/A. Internal: multiply by 2.5x for same thermal rise.
See design/Standards/Global_Routing_Spec.md §1.1 for the full current-category table.

### 7.1 Trace Width Table

| Net | Peak Current | IPC Calc (2oz) | Design Min | **Specified Width** | Layer | Notes |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| 5V_USB (J1 C4R1 → FT232H VCC) | 400 mA | 0.06 mm | 0.50 mm | **0.50 mm** | L1 + L3 pour | FT232H absolute max VCC draw; power-rail minimum applies |
| 3V3_ENIG (J1 C7R1 → FT232H VCCIO) | 15 mA | 0.002 mm | 0.80 mm | **0.80 mm** | L1 + L3 pour | VCCIO domain; 3V3_ENIG canonical 0.80 mm (design/Standards/Global_Routing_Spec.md §1.1) |
| JTAG signals: TCK, TMS, TDI, TDO (CI) | signal | - | 0.127 mm | **0.127 mm (5 mil)** | L2 (inner) | JM inverted stackup (DEC-017): L2 is immediately below the L1 GND plane (buried microstrip, h ≈ 0.087 mm); 0.127 mm achieves ≈50 Ω, equivalent to outer-layer microstrip. Compliant - inverted stackup (L1=GND) places L2 immediately adjacent to the L1 GND reference plane, achieving equivalent controlled impedance per DEC-016 via buried-microstrip topology. |
| USB D+ / D- differential pair | signal | - | 0.15 mm | **0.15 mm (6 mil)** | L2 (inner) | 90 Ω differential USB 2.0; must be length-matched to within 0.1 mm; routed as a tightly-coupled pair |
| GND pours (outer layers) | - | - | pour | **copper pour** | L1 + L4 | Both outer layers = solid GND; provides dual-sided shielding for L2 signals |
| Power pours (inner power layer) | ≤ 400 mA | - | pour | **copper pour** | L3 | Separate pour zones for 5V_USB and 3V3_ENIG |

### 7.2 Notes

* All JTAG traces on L2 are sandwiched between the L1 GND reference (top) and L3 power pour (bottom),
  providing inherent shielding and a well-defined impedance environment.
* The 0.127 mm JTAG trace width is calculated for the JLC04161H-7628 stackup
  (h = 0.087 mm dielectric, t = 0.035 mm copper, Eᵣ = 4.4) targeting 50 Ω buried-microstrip
  impedance. This calculation is identical to the outer-layer microstrip at the same h value;
  applicable here because L2 is immediately adjacent to the L1 GND plane (DEC-017 inverted stackup).
  See `design/Electronics/JTAG_Module/JTAG_Integrity.md §3.1`.
* USB D+/D- traces at 0.15 mm over the L1 GND plane yield approximately 90 Ω differential
  on the JLC04161H-7628 inner signal layer - correct for USB 2.0 Full Speed.

---

## 8. Mounting Holes

JM mounting holes MH1–MH4 are M2.5 NPTH holes with a GND annular ring.
Net: **GND** (not GND_CHASSIS — daughterboard exception per DEC-057).
No purchasable BOM component on the JM; mounting standoffs are owned and sourced by the
**Controller Board BOM** (MH9–MH12, 9774035151R, M2.5×3.5mm SMT standoffs).
See `design/Standards/Global_Routing_Spec.md §4` for module mounting hole rules.
See DEC-057 (standoff ownership) and DEC-058 (JM BtB upgrade) for full rationale.

### MH1–MH4 Pattern

| Hole | Location           | From Left | From Right | From Top | From Bottom |
| :--- | :----------------- | :-------- | :--------- | :------- | :---------- |
| MH1  | Top-left corner    | 7 mm      | —          | 7 mm     | —           |
| MH2  | Top-right corner   | —         | 7 mm       | 7 mm     | —           |
| MH3  | Bottom-left inset  | 12 mm     | —          | —        | 7 mm        |
| MH4  | Bottom-right inset | —         | 12 mm      | —        | 7 mm        |

Notes:

* MH1 and MH2 are right in the top corners for maximum mechanical stability above the DF40 connector.
* MH3 and MH4 are inset from the bottom corners (12 mm from each side) to leave space for J1 (DF40) centred between them at the bottom edge.
* Final board dimensions are deferred to PCB layout time (same approach as AM board).
* Positional asymmetry (MH1/MH2 at 7 mm, MH3/MH4 at 12 mm from sides) enforces correct orientation, combined with silkscreen pin-1 markers on J1.
