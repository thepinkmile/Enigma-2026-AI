# Extension Board Layout Visualisations

**Status:** Draft
**Project:** Enigma-NG
**Author:** Izzyonstage & GitHub Copilot
**Version:** v.0.1.0
**Associated Hardware Revision:** Rev A
**Last Updated:** 2026-05-15

---

## 1. Component Areas

```text
TOP VIEW (L1) - 4-Layer / 2oz Copper / ENIG
 _____________________________________________________________________________
|                                                                             |
|   [ J7: EXTENSION PORT IN ] <--- 30-pin 2x15 shrouded, from previous stage  |
|                                                                             |
|   [ BULK DECOUPLING ] <--- 5x 10uF X7R star/spoke near J7                   |
|                                                                             |
|   [ ROTOR INTERFACE CONNECTORS ]                                            |
|   (J1-J3: input side ERM8 male; J4-J6: output side ERF8 female)             |
|                                                                             |
|   [ JTAG BUFFER (U1) ] <--- SN74LVC2G125DCUR, TCK+TMS re-drive for output   |
|   [ J9: AM HOST DOCK (DF40HC 20-pin) ] <--- Single dock + MH5-MH8 standoffs |
|                                                           for shared AM     |
|   [ J8: EXTENSION PORT OUT ] <--- 30-pin 2x15 shrouded, to next stage       |
|                                                                             |
|   [ DATA PLATE ] <--- Inverted White Silkscreen on L4                       |
|_____________________________________________________________________________|
```

---

## 2. J7 - Extension Port IN (30-Pin 2x15)
>
> **Connector Definition Owner:** `Stator/Board_Layout.md - J10`.
> This board uses the mating connector on J7. See BOM for part number.
> Authoritative pinout per DEC-053: 30-pin 2x15 symmetric layout; `5V_MAIN` on pins 1-2 and 29-30,
> `3V3_ENIG` on pins 3-4 and 27-28, `ENC_OUT_REF[5:0]` on pins 7-12, `ENC_IN_REF[5:0]` on pins 19-24,
> `CPLD_RESET_N` on pin 15, `TTD_RETURN` on pin 16, and GND guard pairs on pins 5-6, 13-14, 17-18, 25-26.

---

## 3. J8 - Extension Port OUT (30-Pin 2x15)
>
> **Connector Definition Owner:** `Stator/Board_Layout.md - J10`.
> This board uses the mating connector on J8. Carries the same signals as J7, passed through.
> See BOM for part number.

---

## 4. J1-J6 - Rotor Interface Connectors (ERM8/ERF8 Family, 0.8mm Pitch)
>
> **Connector Definition Owner:** `Rotor/Design_Spec.md §3.4`.
> J1-J3 are ERM8 male headers (input side - plug into previous rotor group's last rotor J4-J6 ERF8 outputs).
> J4-J6 are ERF8 female sockets (output side - receive next rotor group's first rotor J1-J3 ERM8 male headers).

| Ref | Side | Signal Group | Type | JLCPCB PN |
| --- | ---- | ------------ | ---- | --------- |
| J1 | Input (plugs into previous group last rotor J4) | JTAG | ERM8-005-05.0-S-DV-K-TR (10-pin, **male**) | C3649741 |
| J2 | Input (plugs into previous group last rotor J5) | Power | ERM8-005-05.0-S-DV-K-TR (10-pin, **male**) | C3649741 |
| J3 | Input (plugs into previous group last rotor J6) | ENC Data | ERM8-010-05.0-S-DV-K-TR (20-pin, **male**) | C374877 |
| J4 | Output (receives next group first rotor J1) | JTAG | ERF8-005-05.0-S-DV-K-TR (10-pin, female) | C7273978 |
| J5 | Output (receives next group first rotor J2) | Power | ERF8-005-05.0-S-DV-K-TR (10-pin, female) | C7273978 |
| J6 | Output (receives next group first rotor J3) | ENC Data | ERF8-010-05.0-S-DV-K-TR (20-pin, female) | C3646170 |

**Important:** ERM8/ERF8 0.8mm pitch - physically incompatible with any 2.54mm connector.
Mark clearly on silkscreen: `ERM8/ERF8 / 0.8mm / NICHT 2.54mm`.

---

## 5. J9 - Actuation Module Host Dock

> **Connector Definition Owner:** `AM Design_Spec.md §3.1`.
> This board provides the mating receptacle (J9). Full connector pinout is defined and owned by
> the Actuation Module. Net connections from this board to the mounted AM:
>
> | EXT Net | AM Net |
> | --- | --- |
> | `5V_MAIN` | `5V_MAIN` |
> | `3V3_ENIG` | `3V3_ENIG` |
> | `GND` | `GND` |
> | `ACTUATE_REQUEST_N` | `ACTUATE_REQUEST_N` |
>
> **⚠ PCB Layout Dependency:** J9 and MH5-MH8 positions cannot be finalised until AM schematic
> capture and PCB layout are complete. MH5-MH8 shall mirror `AM Design_Spec.md DR-AM-03` and
> connect to `GND`.

* **J9:** Single 20-pin Hirose DF40HC(3.5)-20DS-0.4V(51) AM host socket (stacking height = 3.5mm).
  A silkscreen pin-1 marker is required on both the Extension and AM boards (per
  `design/Standards/Global_Routing_Spec.md §7.1`).
* **MH5-MH8:** Four M2.5x3.5mm SMT standoffs (9774035151R); positions mirror `AM Design_Spec.md
  DR-AM-03`; pads connected to `GND`; no-component placement zone (except J9, MH5-MH8, and routing).
* The mounted AM footprint on the Extension shall be kept as a **no-component placement zone** except
  for J9, MH5-MH8 and the routing / copper needed to reach them.

## 6. Routing - Trace Width Specifications

**Board specs:** 4-layer / 2oz finished copper — stackup per GRS §2.3.1.
L1 = signal (JTAG/routing); L2 = GND plane; L3 = 3V3_ENIG power pour; L4 = secondary routing / data plate.

**IPC-2221A basis (2oz copper, external, 10°C rise, 25°C ambient):**
For 2oz external: ~0.15 mm/A. The 3V3_ENIG inner pour (L3) carries the bus current without width constraints.
See Global_Routing_Spec.md §1.1 for the full current-category table.

**Extension board power pass-through analysis:**
The Extension Board passes `3V3_ENIG` to the downstream rotor mini-stack via its **J5** output
(5 rotors x 55 mA = **275 mA** maximum). Separately, `3V3_ENIG` is forwarded via the Extension
Port (**J7 → J8**) to power further Extension Boards and their mini-stacks downstream in the chain.
The Extension Board also receives a `5V_MAIN` feed via J7 for the local Actuation Module, forwarded
to J8 for the next Extension Board.

Worst-case J7 design current: the Extension Port connector is sized to supply the full 30-rotor
system - **30 rotors x 55 mA = 1.65 A** design budget (intentional over-spec to ensure any future
stacking architecture chosen during the `extension-mechanical-usage` design phase is fully
supported). All Extension boards share an identical PCB layout; traces are sized for this budget.

### 6.1 Trace Width Table

| Net | Peak Current | IPC Calc (2oz ext) | Design Min | **Specified Width** | Layer | Notes |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| Signal (ENC_IN/OUT, CPLD_RESET_N, ACTUATE_REQUEST_N) | < 5 mA | < 0.001 mm | 0.20 mm | **0.20 mm** | L1 | 3.3 V logic signals; pass-through from J7 to J8 and local AM trigger routing |
| JTAG signals: TTD_RETURN (CI) | signal | - | 0.127 mm | **per GRS §2.3.1 / JLCPCB_Manufacturing.md §1.1** | L1 (external) | 50 Ω controlled impedance over L2 GND plane; per DEC-016. External layer - no inner-layer minimum conflict. See `JTAG_Integrity.md`. |
| 3V3_ENIG J7 entry trunk (J7 → L3 pour → J5 and J8) | 1.65 A (design budget; 30 rotors x 55 mA) | 0.25 mm | 0.80 mm | **0.80 mm** | L1 + L3 pour | 3V3_ENIG canonical 0.80 mm (Global_Routing_Spec §1.1); conservative full-system budget; resolved by DEC-053 (4 dedicated pins for 0.41 A/conductor) |
| 3V3_ENIG J5 output (J5 → downstream mini-stack J2) | 275 mA (5-rotor mini-stack worst case) | 0.04 mm | 0.80 mm | **0.80 mm** | L1 + L3 pour | Canonical 0.80 mm minimum; 275 mA = Rotor 1 of downstream mini-stack |
| 3V3_ENIG local draw (J7 → U1 VCC) | ≤ 10 mA | 0.002 mm | 0.80 mm | **0.80 mm** | L1 | Buffer IC supply; 3V3_ENIG canonical 0.80 mm minimum |
| 3V3_ENIG distribution (inner power pour) | 1.65 A (J7 design budget) | - | pour | **copper pour** | L3 | Full uninterrupted 2oz plane; primary distribution |
| 5V_MAIN to AM host dock (J7 → J9) | 0.50 A | 0.08 mm | 0.80 mm | **0.80 mm** | L1 | Local Extension actuation supply path |
| GND return (inner GND pour) | - | - | pour | **copper pour** | L2 | Reference plane; must be solid and uninterrupted under all CI traces on L1 |

### 6.2 Notes

* **JTAG CI traces:** 50 Ω controlled impedance on L1 over the L2 GND plane. Trace width per GRS §2.3.1 and `design/Production/JLCPCB_Manufacturing.md §1.1`.
* **3V3_ENIG pass-through:** The 0.80 mm is the canonical system-wide minimum for all 3V3_ENIG
  surface traces (Global_Routing_Spec §1.1). IPC calculation for worst-case J7 entry 1.65 A at
  2oz external: 1.65 x 0.15 mm = 0.25 mm → **0.80 mm** canonical width provides 3.2x margin.
  For the J5 output (275 mA only): 0.275 x 0.15 mm = 0.04 mm → **0.80 mm** provides 20x margin.
* **Extension Port 3V3_ENIG pin count:** Resolved by DEC-053 - the 2BHR-30-VUA 30-pin connector
  provides 4 dedicated `3V3_ENIG` pins (pins 3-4 and 27-28), distributing 1.65 A across 4 conductors
  for 0.41 A/conductor - well within the 28 AWG IDC ribbon limit of ~1 A/conductor. The trace and
  copper pour widths (0.80 mm / L3 pour) are unaffected by this change.

---

## 7. Thermal & ESD

> **ESD detail:** See `Design_Spec.md §5 - Thermal & ESD` for the full ESD protection scheme applicable to this board.

* **Rotor-facing connectors (TVS required):** All Samtec ERM8/ERF8 connectors (J1-J6) require TPD4E05U06QDQARQ1 ESD arrays within 3mm of the mating edge per DEC-045 and DEC-048.
  Arrays are assigned to U2-U9 (see `Design_Spec.md §5`).
* **Internal connectors (no TVS required):** J7, J8 (Extension Port 2BHR-30-VUA shrouded box) and J9 (AM dock, DF40HC-20DS) are not operator-accessible during live rotor swap.
  No TVS required per `design/Standards/Global_Routing_Spec.md §9`.

---

## 8. Mounting Holes

The Extension board uses 4x M3 PTH mounting holes for chassis attachment per DR-EXT-14.

### 8.1 Specifications

- **Count:** 4x M3 PTH
- **Hole diameter:** Ø3.2mm (clearance for M3 fastener)
- **Annular ring:** 6.0mm ENIG exposed pad (per GRS §4)
- **Net:** `GND_CHASSIS` — copper ring pads tied to chassis ground for Faraday-cage continuity
- **BOM:** No BOM entry; these are plain chassis mounting holes with no fitted components

### 8.2 Positions

Positions follow GRS §4.3 Pattern B (D-shaped board). Exact XY coordinates to be confirmed at PCB layout per GRS §4.2; the following describe the intended placement:

| Hole | Position Description |
| :--- | :--- |
| MH1 | Bottom-left corner |
| MH2 | Bottom-right corner |
| MH3 | Board geometric centre |
| MH4 | Top-centre: midpoint of the rounded top arc, 7 mm inset along the arc normal |

> **Note:** Exact coordinates TBD at PCB layout per GRS §4.2. The Extension board outline, connector clearances, and AM-dock standoffs (MH5–MH8) must be factored in before finalising hole positions.

### 8.3 Cross-References

| Document | Relevance |
| :--- | :--- |
| `design/Standards/Global_Routing_Spec.md §4` | Mechanical grounding, ENIG annular ring, GND_CHASSIS bonding rules |
| `design/Standards/Global_Routing_Spec.md §4.3` | Default mounting hole placement Pattern B (D-shaped board) |
| `design/Electronics/Extension/Design_Spec.md DR-EXT-14` | Design requirement for chassis mounting holes |
