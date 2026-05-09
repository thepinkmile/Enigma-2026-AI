# Checkpoint 127 — MH RefDes Standardisation Complete

**Date:** 2026-05-08
**Status:** Committed (`3443e2d`)

## What Was Done

Completed the `mh-refdes-standardise` todo: all mounting hole RefDes across every board
renumbered to conform to the canonical global scheme defined in DEC-057/DEC-058.

### Canonical MH numbering scheme

| Group | RefDes | Boards | Spec | Notes |
| :--- | :--- | :--- | :--- | :--- |
| Chassis mounting holes | MH1–MH4 | All chassis-mounted boards | M3 PTH, GND_CHASSIS | No BOM entry (GRS plain holes) |
| AM dock standoffs | MH5–MH8 | CTL, EXT (on carrier) | M2.5×3.5mm SMT, 9774035151R, GND | In CTL/EXT BOM; NOT AM BOM |
| JM dock standoffs | MH9–MH12 | CTL only | M2.5×3.5mm SMT, 9774035151R, GND | In CTL BOM; NOT JM BOM |
| CM5 SoM standoffs | MH13–MH16 | CTL only | M2.5×4.0mm SMT, 9774040151R, GND | In CTL BOM |

**Exceptions:**
- Rotor: MH1A/2A/1B/2B (split circular board — described in DEC-057)
- AM and JM: GND pad not GND_CHASSIS (daughterboard exception — DEC-057)

### GRS §4.3 added

New section added to `design/Standards/Global_Routing_Spec.md` defining:
- Pattern A (rectangular board): corners, inside courtyard
- Pattern B (D-shaped board): symmetric positions
- Named Exceptions table (CTL listed with all 4 groups)

### Lint fixes in this commit

Two markdownlint errors resolved before commit:

- **MD060 (CTL Design_Spec.md line 352):** Header right-cell `JM Net    ` had 4 trailing
  spaces vs data cells with 5; added one space → `JM Net     `
- **MD013 (JM Design_Spec.md line 180):** 342-char list-item continuation line split into
  two lines at "unofficial" boundary (168 + 175 chars, both under 200-char limit)

### Todo status updates at this commit

- `mh-refdes-standardise` → ✔ DONE
- `connector-stacking-height-review` → ✔ DONE (user confirmed already complete)
- `interim-electronics-review-1` → ✔ DONE (passes 1–6 complete; next is pass 7)
- `review-mounting-holes` → ✔ DONE (verified all 10 boards conformant)
- `da-01`–`da-04` → ⛔ BLOCKED (deferred pre-production items, not current phase)

## Files Changed

| File | Change |
| :--- | :--- |
| `design/Electronics/Controller/Design_Spec.md` | DR-CTL-20 (JM dock MH9–12), DR-CTL-21 (chassis MH1–4), CM5 body (MH13–16), BOM rows; MD060 fix |
| `design/Electronics/JTAG_Module/Design_Spec.md` | CTL standoff refs updated MH13–16 → MH9–12; MD013 line-wrap fix |
| `design/Electronics/JTAG_Module/Board_Layout.md` | CTL standoff ref updated |
| `design/Electronics/Consolidated_BOM.md` | Both CTL MH RefDes cells updated |
| `design/Standards/Global_Routing_Spec.md` | §4.3 Default Mounting Hole Placement added; Named Exceptions table updated |
| `design/Electronics/Extension/Design_Spec.md` | MH RefDes conformance update |
| `design/Electronics/Reflector/Design_Spec.md` | MH RefDes conformance update |
| `design/Electronics/Stator/Design_Spec.md` | MH RefDes conformance update |
| `design/Electronics/Stator/Board_Layout.md` | MH conformance note added |
| `design/Electronics/Encoder/Design_Spec.md` | MH RefDes conformance update |
| `design/Electronics/User_Settings_Module/Design_Spec.md` | MH RefDes conformance update |
| `design/Electronics/Power_Module/Design_Spec.md` | MH RefDes conformance update |
| `design/Electronics/Power_Module/Board_Layout.md` | MH section added (Pattern A positions) |
| `design/Electronics/Rotor/Design_Spec.md` | MH RefDes exception documented |
| `.copilot/todo-list.md` | `mh-refdes-standardise` strikethrough corrected |

## Next Work

- `enc-connector-review-pre-pcb` — ENC connector and bypass cap pre-PCB check (now unblocked)
- `review-pass-7` — Post-Pass-6 design verification review
