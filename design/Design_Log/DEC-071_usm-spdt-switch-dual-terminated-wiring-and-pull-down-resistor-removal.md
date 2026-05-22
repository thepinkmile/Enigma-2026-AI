## DEC-071 - USM SPDT Switch Dual-Terminated Wiring and Pull-Down Resistor Removal

| Field | Value |
| :--- | :--- |
| **Decision ID** | DEC-071 |
| **Status** | Confirmed |
| **Date** | 2026-05-14 |
| **Author** | Izzyonstage & Copilot |
| **Amends** | USM DR-USM-09 (switch wiring topology); USM DR-USM-07 (R11 renumbered R1) |

### Context

A review of the SPDT toggle switch wiring for SW1-SW10 (E-Switch 200MSP1T2B4M2QE) raised the
question of whether the opposite/unasserted throw, left unconnected in the prior design, could
produce a floating GPIO input at U1. The three physical terminals of the 200MSP1T2B4M2QE are:

- **Pin 1 - NC (Normally Closed):** connected in the default/OFF switch position
- **Pin 2 - COM (Common):** centre lug, always present regardless of switch position
- **Pin 3 - NO (Normally Open):** connected in the asserted/ON switch position

### Decision

**D1 - Dual-terminated switch wiring adopted; pull-down resistors removed:**
Each toggle switch (SW1-SW10) is wired as follows:

- **NC terminal (Pin 1) → GND**
- **COM terminal (Pin 2) → CFG_* GPIO input on U1**
- **NO terminal (Pin 3) → 3V3_ENIG**

Both throws are now hard-terminated: in the NO/ON position the COM net is driven HIGH by
3V3_ENIG; in the NC/OFF position the COM net is driven LOW by GND. Neither switch position
leaves the COM terminal floating. The 10x 10kΩ 0603 pull-down resistors (R1-R10, DR-USM-09) are
no longer required and are removed from the design. There is no shoot-through path because only one
throw is connected at any time.

**D2 - R11 renumbered to R1:**
With R1-R10 removed, R11 (10kΩ 0603 pull-up for CFG_APPLY_N, DR-USM-07) becomes the sole 10kΩ
0603 resistor on the board. It is renumbered R1 to eliminate a gap in the RefDes sequence.
All cross-references to R11 in the USM Design_Spec.md, Board_Layout.md, and Consolidated_BOM.md
are updated to R1.

**D3 - LED driving architecture unchanged:**
The switch signal path (U1 @ 0x23) and LED output path (U2 @ 0x24, U3 @ 0x25) are fully
independent. LED illumination remains under software control exclusively; there is no hardware tie
between switch position and LED state.

### Rationale

The dual-terminated topology is strictly superior to pull-resistor termination for panel toggle
switches: it requires no additional components, eliminates both the floating-input risk and the
power draw through pull resistors, and produces well-defined GPIO logic levels in both switch
positions. The component reduction also simplifies board layout in the U1 vicinity.

R1-R10 were originally specified (DEC not recorded; reflected in the initial DR-USM-09 entry) as a
defensive measure against floating inputs. With hard termination on both throws, this defensive
measure is redundant.

### Files Changed

- design/Electronics/User_Settings_Module/Design_Spec.md - DR-USM-09 rewritten (dual-terminated
  topology, pull-downs removed); DR-USM-07 R11 reference updated to R1; U1 pin table Pull column
  updated for GPA[3:0] and GPB[5:0]; silicon note updated; §6 CFG_APPLY_N pull-up reference
  updated R11→R1; BOM row updated R1-R11 Qty 11 → R1 Qty 1; component count row removed (switch
  pull-downs); component count misc resistor row updated R11→R1; total component count 166→156;
  Last Updated 2026-05-14
- design/Electronics/User_Settings_Module/Board_Layout.md - placement zone note updated R11→R1,
  switch pull-down reference removed; Last Updated 2026-05-14
- design/Electronics/Consolidated_BOM.md - 10kΩ row RefDes updated USM: R1-R11 → USM: R1; USM
  quantity updated 11→1; row total updated 21→11
