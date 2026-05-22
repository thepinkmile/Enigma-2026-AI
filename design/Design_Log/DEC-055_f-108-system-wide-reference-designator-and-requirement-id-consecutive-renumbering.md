## DEC-055 - F-108 System-Wide Reference Designator and Requirement ID Consecutive Renumbering

**Date:** 2026-05-05
**Author:** Izzyonstage & GitHub Copilot
**Status:** Accepted

### Context

Pass 5 design review (finding F-108) identified non-consecutive reference designator (RefDes) and
requirement ID (FR/DR) numbering sequences in multiple board Design_Spec.md files. Gaps arose from
components and requirements retired during earlier design iterations. Consecutive numbering is
required for clean BOM grouping during Schematic Capture and PCB Layout.

### Decision

Renumber all affected component RefDes and FR/DR requirement IDs consecutively across all impacted
board Design_Spec files. No electrical change; documentation renaming only.

### Scope and Complete Renaming Mapping

#### JTAG Daughterboard (JDB)

**Component RefDes changes:**

| Old RefDes | New RefDes | Value / Type | Notes |
| --- | --- | --- | --- |
| R2 | R1 | 33 Ω 0402 | TDI series damping at FT232H |
| R6 | R2 | 33 Ω 0402 | TCK series damping after U2 buffer |
| R7 | R3 | 33 Ω 0402 | TMS series damping after U2 buffer |
| R8 | R4 | 33 Ω 0402 | TDI series damping before J2 |
| R3 | R5 | 10 kΩ 0402 | FT232H RESET_N pull-up |
| R4 | R6 | 10 kΩ 0402 | TMS pull-up near J2 |
| R5 | R7 | 10 kΩ 0402 | TCK pull-down near J2 |
| U5 | U2 | SN74LVC2G125DCUR | Dual 3-state JTAG buffer (U2-U4 were gaps) |

**FR/DR IDs:** Already consecutive DR-JDB-01 through DR-JDB-17; no ID renumbering required.
Cross-references within FR/DR cells updated to reflect new component RefDes above.

**Files updated:** `JTAG_Daughterboard/Design_Spec.md`, `Investigations/JTAG_Integrity.md`

---

#### Actuation Module (AM)

**Component RefDes changes:**

| Old RefDes | New RefDes | Value / Type | Notes |
| --- | --- | --- | --- |
| J2 | - | (retired) | Removed from sequence; was a gap entry |
| J3 | J2 | 1×5 2.54mm header | Programming header |
| J4 | J3 | 1×5 2.54mm header | |
| J5 | J4 | 1×5 2.54mm header | |
| J6 | J5 | 1×5 2.54mm header | |

**FR/DR IDs:** No renumbering required.

**Files updated:** `Actuation_Module/Design_Spec.md`

---

#### Power Module (PM)

**Component RefDes changes:**

| Old RefDes | New RefDes | Value / Type | Notes |
| --- | --- | --- | --- |
| D5 | - | (removed) | Invalid component; gap removed |
| D6 | D5 | BAT54 Schottky SOT-23 | |
| D7 | D6 | BAT54 Schottky SOT-23 | |

**FR/DR IDs:** No renumbering required.

**Files updated:** `Power_Module/Design_Spec.md`, `Power_Module/Board_Layout.md`

---

#### Rotor Board (ROT, ROT-26, ROT-64)

**Component RefDes changes:**

| Old RefDes | New RefDes | Value / Type | Notes |
| --- | --- | --- | --- |
| C14 | C9 | 100 nF X7R 50V 0402 | Moved into the contiguous 100nF group C1-C9 |
| C9 | C10 | 10 µF X7R 25V 0805 | Shifted +1 to make room for new C9 |
| C10 | C11 | 10 µF X7R 25V 0805 | |
| C11 | C12 | 10 µF X7R 25V 0805 | |
| C12 | C13 | 10 µF X7R 25V 0805 | |
| C13 | C14 | 10 µF X7R 25V 0805 | |

Result: C1-C9 all 100 nF 0402; C10-C14 all 10 µF 0805. Variant-specific refs (C16A/B, C17A/B,
C18-C21, C22A/B-C25A/B) unchanged.

**FR/DR IDs:** No renumbering required.

**Files updated:** `Rotor/Design_Spec.md`, `Rotor/Rotor_26_Char_Design.md`,
`Rotor/Rotor_64_Char_Design.md`, `Rotor/Board_Layout.md`

---

#### Controller Board (CTL)

**Component RefDes changes:**

| Old RefDes | New RefDes | Value / Type | Notes |
| --- | --- | --- | --- |
| C24 | C18 | 100 nF 0402 | PoE auxiliary bypass cap |
| C28 | C19 | 100 nF 0402 | PoE auxiliary bypass cap |
| U9 | U7 | TPS2372-4RGWR VQFN-24 | PoE PD interface (U7-U8 were gaps) |
| U10 | U8 | TPS23730RMTR WSON-10 | PoE auxiliary controller |

**FR/DR ID changes:**

DR-CTL-13 was retired (removed gap):

| Old ID | New ID |
| --- | --- |
| DR-CTL-14 | DR-CTL-13 |
| DR-CTL-15 | DR-CTL-14 |
| DR-CTL-16 | DR-CTL-15 |
| DR-CTL-17 | DR-CTL-16 |

**Files updated:** `Controller/Design_Spec.md`

---

#### Stator Board (STA)

**Component RefDes changes (shift −3 to fill gap at R13-R15):**

| Old Range | New Range | Value / Type |
| --- | --- | --- |
| R16-R43 | R13-R40 | Various 0402 resistors (28 components, all shifted −3) |

Detailed per-resistor mapping (old → new):
R16→R13, R17→R14, R18→R15, R19→R16, R20→R17, R21→R18, R22→R19, R23→R20, R24→R21, R25→R22,
R26→R23, R27→R24, R28→R25, R29→R26, R30→R27, R31→R28, R32→R29, R33→R30, R34→R31, R35→R32,
R36→R33, R37→R34, R38→R35, R39→R36, R40→R37, R41→R38, R42→R39, R43→R40.

**FR/DR IDs:** No renumbering required.

**Files updated:** `Stator/Design_Spec.md`

---

#### User Settings Module (USM)

**Component RefDes changes (shift −3 to fill gap at R78-R80):**

| Old Range | New Range | Value / Type |
| --- | --- | --- |
| R81-R98 | R78-R95 | 100 kΩ 1% 0402 (18 components, all shifted −3) |

**FR/DR IDs:** No renumbering required.

**Files updated:** `User_Settings_Module/Design_Spec.md`

---

#### Extension Module (EXT)

**Component RefDes changes:** None.

**FR/DR ID changes:**

DR-EXT-10 was retired (removed gap):

| Old ID | New ID |
| --- | --- |
| DR-EXT-11 | DR-EXT-10 |
| DR-EXT-12 | DR-EXT-11 |
| DR-EXT-13 | DR-EXT-12 |
| DR-EXT-14 | DR-EXT-13 |
| DR-EXT-15 | DR-EXT-14 |

**Files updated:** `Extension/Design_Spec.md`

---

### Consolidated BOM Updates

`design/Electronics/Consolidated_BOM.md` updated to reflect all renaming above. Additionally, a
pre-existing BOM error was corrected: `USM: R78-R80` (listed as 10 kΩ 0402 with count 3) was
removed from the 10 kΩ row. These components do not exist in USM Design_Spec.md; the entry was a
historic BOM artefact. The USM count in that row changed from 3 to `-` and the row total from 48
to 45.

### Alternatives Considered

- **Leave gaps:** Rejected. Schematic capture tools auto-increment RefDes; gaps cause annotation
  confusion and complicate BOM grouping.
- **Renumber variants separately from main:** Rejected for Rotor. Variant components now continue
  from the end of the main list (C10-C14) to preserve clarity and avoid dual-sequence confusion.

### Impact

- No electrical change; all renaming is documentation only.
- All cross-references within affected Design_Spec files (FR/DR cells, prose, BOM tables) updated.
- Consolidated BOM aligned with current Design_Spec state across all boards.
- JTAG_Integrity.md JDB-scoped references updated; Stator and Encoder references in that file
  intentionally left unchanged.
