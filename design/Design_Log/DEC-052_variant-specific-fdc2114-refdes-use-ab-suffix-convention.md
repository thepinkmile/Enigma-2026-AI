## DEC-052 - Variant-Specific FDC2114 RefDes Use A/B Suffix Convention

- **Status:** Active
- **Date:** 2025-07-10
- **Category:** Architecture
- **Area:** Rotor Board - Position Sensing (FDC2114 sensor ICs and associated passives)

### Decision

Variant-specific FDC2114 sensor components on the Rotor board are assigned RefDes with an A or B
suffix to indicate which PCB sub-board they are physically located on:

- **Board A (N=26 variant):** `U3A`, `C16A`, `C17A`, `C22A`-`C25A`, `L5A`-`L8A`
- **Board B (N=64 variant):** `U3B`, `C16B`, `C17B`, `C22B`-`C25B`, `L5B`-`L8B`

The B-suffix base numbers mirror the A-suffix base numbers exactly, making the pairing
immediately readable. The always-fitted sensor (`U2`) and its bypass and resonant front-end
components (`C14`, `C15`, `C18`-`C21`, `L1`-`L4`) retain plain RefDes with no suffix as they
are fitted on all variants.

In KiCAD the A and B suffixes are unique RefDes. Two project variants are defined:

- **N26:** U3A fitted; U3B (and associated B-suffix passives) marked DNP.
- **N64:** U3B fitted; U3A (and associated A-suffix passives) marked DNP.

The Consolidated BOM System Qty column counts only the components fitted in a single variant:
each mutually-exclusive sensor row carries qty **1** per rotor.

### Rationale

KiCAD does not support duplicate RefDes within a single project. Using A/B suffixes allows
both Board A and Board B sensor circuits to coexist in the same schematic and PCB layout file
while remaining unique. Mirroring the base number across A and B (e.g. `C16A` / `C16B`) makes
the pairing unambiguous without a separate mapping table. The overall capacitor and inductor
sequence is kept consecutive with no gaps.

### Alternatives Considered

- **U3 / U4 (no suffix):** Used prior to this decision. Abandoned because schematic and PCB
  layout tools require unique RefDes; U3 and U4 appeared confusingly similar to Controller
  Board RefDes (U4-U6) documented elsewhere.
- **Separate schematic/layout per variant:** Rejected; doubles maintenance burden and makes
  shared JTAG and data routing harder to manage.

### Impact

- `design/Electronics/Rotor/Design_Spec.md` - all occurrences of `U3`/`U4` for the Rotor
  board updated to `U3A`/`U3B`; bypass and tank passive RefDes updated throughout.
- `design/Electronics/Rotor/Board_Layout.md` - Board A and Board B tables updated.
- `design/Electronics/Rotor/Rotor_26_Char_Design.md` - variant spec updated.
- `design/Electronics/Rotor/Rotor_64_Char_Design.md` - variant spec updated.
- `design/Electronics/Consolidated_BOM.md` - rows for C16/C17, C18-C21, C22-C25, L5-L8,
  and U3/U4 updated; System Qty corrected for mutually-exclusive rows.
