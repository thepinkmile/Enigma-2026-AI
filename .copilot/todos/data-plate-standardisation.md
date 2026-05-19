# Standardise Data Plate entries across all board Design_Spec.md files

**ID:** `data-plate-standardisation`
**Status:** pending
**Category:** Documentation / Standards
**Source:** Pass-10 findings resolution, 2026-05-19
**Blocked by:** `review-pass-10` (complete)

---

## Description

GRS §6 defines the Data Plate standard but does not formally document the revision block text
format (board name components). Two boards have German names defined in `Label:` bullets; eight
boards have no German name defined anywhere. This todo standardises all boards to a single format.

### Confirmed format (user-approved 2026-05-19)

Revision block text uses **square brackets**:

```
GERMAN-NAME [English Name] V{x}.{y}
```

Examples:
- `WALZE-26 [Rotor] V1.0`
- `REFLEKTOR [Reflector] V1.0`

Each board's `Design_Spec.md` Silkscreen/Mechanical section must contain exactly:

```markdown
* **Data Plate:** Per `design/Standards/Global_Routing_Spec.md §6` on Layer [n], Revision Block text: `GERMAN [English] V1.0`
```

---

## Work Required

### 1. Update GRS §6

`design/Standards/Global_Routing_Spec.md §6` currently shows only `AUSGABE [Rev] V1.0` as a
placeholder. Must be updated to formally define:

```
AUSGABE BOARD-NAME-DE [Board Name EN] V{x}.{y}
```

where `BOARD-NAME-DE` is the ALL-CAPS German board name and `[Board Name EN]` is the English
translation in square brackets, followed by the version: `GERMAN [English] Vx.y`.

Note: `AUSGABE` prefix is **not** used — the format is just `GERMAN [English] Vx.y`.

### 2. Agree German board names (8 boards TBD)

The following boards have no German name defined. Names must be agreed with the user before
Design_Spec entries can be written.

| Board | Layer | German Name | Status |
|-------|-------|-------------|--------|
| Rotor | L4 | `WALZE-{variant}` | Known — `Label:` bullet exists |
| Reflector | L4 | `REFLEKTOR` | Known — confirmed by user 2026-05-19 |
| Controller | L6 | TBD | Not defined |
| Extension | L4 | TBD | Not defined |
| Stator | L4 | TBD | Not defined |
| Power Module | L4 | TBD | Not defined |
| Actuation Module | L4 | TBD | Not defined |
| User Settings Module | L4 | TBD | Not defined |
| JTAG Module | L4 | TBD | Not defined |
| Encoder | L4 | TBD | Not defined |

### 3. Fix/add Data Plate bullet in every Design_Spec.md

| Board | Current state | Action |
|-------|---------------|--------|
| Rotor | `Per GRS §6` + separate `Label:` bullet | Add revision block text to Data Plate bullet; consolidate or keep Label bullet |
| Reflector | Bloated 3-line version (GRS elements duplicated) | Replace with standard 1-line form |
| Controller | Brief branding note only; GRS §6 referenced loosely | Replace with standard Data Plate bullet |
| Extension | `2oz Copper / Inverted White Data Plate (V1.0 traceability)` — no GRS ref | Replace with standard Data Plate bullet |
| Stator | Not mentioned | Add standard Data Plate bullet |
| Power Module | Not mentioned | Add standard Data Plate bullet |
| Actuation Module | Not mentioned | Add standard Data Plate bullet |
| User Settings Module | Not mentioned (spec text wrongly in Board_Layout.md line 217) | Add to Design_Spec; remove from Board_Layout |
| JTAG Module | Not mentioned | Add standard Data Plate bullet |
| Encoder | Not mentioned | Add standard Data Plate bullet |

### 4. Board_Layout cleanup

- `design/Electronics/User_Settings_Module/Board_Layout.md` line 217 contains spec text
  (`Per GRS §6, a data plate (board name, revision, fab date code) shall be placed on L4…`).
  This must be **removed** from Board_Layout (visualisation-only) and the intent moved to
  `User_Settings_Module/Design_Spec.md`.
- All other Board_Layout files show `[ DATA PLATE ]` in ASCII art diagrams only — correct,
  no change needed.

---

## Notes

- German board names for 8 boards must be agreed before entries can be written.
- The `Label:` bullets currently in Rotor and Reflector Design_Spec files may be consolidated
  into the Data Plate bullet or kept as separate silkscreen elements — to be decided during
  implementation.
- This todo is a dependency for `review-pass-11` — all Data Plate entries must be standardised
  before the next review pass so the reviewer sees a consistent state.
- REF-P10-07 was initially treated as a finding but is closely related to this standardisation.
  The Reflector Data Plate bullet has been partially corrected (GRS element duplication removed)
  but the final form awaits this work being completed.
- GRS §6 currently shows `AUSGABE [Rev] V1.0` — this must be updated to the new format
  `GERMAN [English] Vx.y` (dropping `AUSGABE`) when this todo is implemented.
