# Checkpoint 160 — Library Import (Hirose + TPS), Todo Sync, Directives Hardened

## Date
2026-05-16

## Summary
Official Hirose DF40 and TPS component library files imported and fully synchronised across
STP, `.kicad_mod`, `.kicad_sym`, and legacy `.mod` SHAPE3D formats. Session DB seeding mandated
in OCTONARY directive. Three-way todo sync rule introduced. `board-interconnect-diagram` status
corrected from `pending` to `done` across all three tracking layers. `review-pass-9` marked done.
New todos added: `download-missing-3d-models` (33 parts) and `review-pass-11`.

---

## Work Done

### Library: 5 official parts imported / replaced

| MPN | Source | STP | kicad_mod | kicad_sym | legacy SHAPE3D |
|-----|--------|-----|-----------|-----------|----------------|
| DF40C20DP04V51 | Official Hirose/Mouser SamacSys | ✔ (replaced) | ✔ (replaced) | ✔ (replaced) | ✔ (added) |
| DF40HC3520DS04V51 | Official Hirose/Mouser SamacSys | ✔ (new) | ✔ (new) | ✔ (replaced) | ✔ (added) |
| TPS23730RMTR | TI/Mouser SamacSys | ✔ (new) | ✔ (replaced) | ✔ (replaced) | ✔ (added) |
| TPS25751DREFR | TI/Mouser SamacSys | ✔ (new) | ✔ (replaced) | ✔ (replaced) | ✔ (added) |
| TPS259804ONRGER | TI/Mouser SamacSys | ✔ (new) | ✔ (replaced) | ✔ (replaced) | ✔ (added) |

**Hirose DF40 Mouser MPN quirk noted:** Mouser lists `DF40C-20DP-0.4V(51)` (hyphens, decimal
pitch) while our library uses `DF40C20DP04V51`. BOM procurement note added to
`Consolidated_BOM.md`, `Actuation_Module/Design_Spec.md`, and `JTAG_Module/Design_Spec.md`.

**Legacy `.mod` SHAPE3D blocks:** All 5 parts had `$SHAPE3D` blocks added to
`SamacSys_Parts.mod`. Offsets/rotations taken from authoritative `.kicad_mod` model blocks.

**Sync audit confirmed:** All 5 parts ✔ across STP / `.kicad_mod` / symbol / legacy SHAPE3D.

**SamacSys unquoted model ref note:** KiCad 6+ `.kicad_mod` files from SamacSys use
`(model PARTNAME.stp` without quotes. Pattern `\(model\s+\S+` required; `(model "..."` will
false-negative.

---

### BOM Design File Updates

- `design/Electronics/Consolidated_BOM.md` — DF40C procurement note added
- `design/Electronics/Actuation_Module/Design_Spec.md` — DF40C procurement note added
- `design/Electronics/JTAG_Module/Design_Spec.md` — DF40C procurement note added

---

### Todo System

- **`download-missing-3d-models`** — new todo added; 33 parts still lacking STP files listed in
  `.copilot/todos/download-missing-3d-models.md`. User hit daily download limit; remaining
  downloads to continue next session.
- **`review-pass-11`** — new todo added; blocked by both `download-missing-3d-models` and
  `review-pass-10`. Detail file at `.copilot/todos/review-pass-11.md`.
- **`review-pass-9`** — marked done in summary table, Agent SQL INSERT, and session DB.
- **`board-interconnect-diagram`** — summary table was `done`; Agent SQL INSERT was `pending`.
  Corrected to `done` in SQL block and session DB.

Session DB seeded from full `todo-list.md` Agent SQL block: 109 todos (35 pending, 6 blocked,
68 done), 95 dependency rows.

---

### Agent Directives

**OCTONARY DIRECTIVE expanded** (`agent-directives.md`):
- **SESSION START — MANDATORY FIRST ACTION**: seed session DB todos + deps from `todo-list.md`
  Agent SQL block before any other work; verify row counts; treat failure as directive violation.
- **KEEPING IN SYNC**: all three layers (summary table + Agent SQL INSERT + session DB) must be
  updated together for every status change, new todo, or dependency change.
- **Archive correction**: "delete detail file on close" wording corrected to "archive to
  `.recycle-bin/`" to align with QUATERNARY directive.

---

## Files Modified

- `src/Electronics/Library/SamacSys_Parts.mod` — `$SHAPE3D` blocks added for 5 parts
- `src/Electronics/Library/SamacSys_Parts.pretty/DF40C20DP04V51.kicad_mod` — replaced (official)
- `src/Electronics/Library/SamacSys_Parts.pretty/DF40HC3520DS04V51.kicad_mod` — replaced (official)
- `src/Electronics/Library/SamacSys_Parts.pretty/TPS23730RMTR.kicad_mod` — replaced
- `src/Electronics/Library/SamacSys_Parts.pretty/TPS25751DREFR.kicad_mod` — replaced
- `src/Electronics/Library/SamacSys_Parts.pretty/TPS259804ONRGER.kicad_mod` — replaced
- `src/Electronics/Library/SamacSys_Parts.kicad_sym` — 5 symbol blocks replaced (names preserved)
- `src/Electronics/Library/SamacSys_Parts.3dshapes/DF40C20DP04V51.stp` — replaced (official)
- `src/Electronics/Library/SamacSys_Parts.3dshapes/DF40HC3520DS04V51.stp` — new
- `src/Electronics/Library/SamacSys_Parts.3dshapes/TPS23730RMTR.stp` — new
- `src/Electronics/Library/SamacSys_Parts.3dshapes/TPS25751DREFR.stp` — new
- `src/Electronics/Library/SamacSys_Parts.3dshapes/TPS259804ONRGER.stp` — new
- `design/Electronics/Consolidated_BOM.md` — DF40C procurement note
- `design/Electronics/Actuation_Module/Design_Spec.md` — DF40C procurement note
- `design/Electronics/JTAG_Module/Design_Spec.md` — DF40C procurement note
- `.copilot/todo-list.md` — new todos added; `review-pass-9` + `board-interconnect-diagram` status fixed; Agent SQL updated; OCTONARY seeding block updated
- `.copilot/agent-directives.md` — OCTONARY expanded (session-start seeding + 3-way sync + archive fix)
- `.copilot/todos/download-missing-3d-models.md` — new detail file (33 parts)
- `.copilot/todos/review-pass-11.md` — new detail file

## Files Added

- `src/Electronics/Library/SamacSys_Parts.3dshapes/DF40HC3520DS04V51.stp`
- `src/Electronics/Library/SamacSys_Parts.3dshapes/TPS23730RMTR.stp`
- `src/Electronics/Library/SamacSys_Parts.3dshapes/TPS25751DREFR.stp`
- `src/Electronics/Library/SamacSys_Parts.3dshapes/TPS259804ONRGER.stp`
- `.copilot/todos/download-missing-3d-models.md`
- `.copilot/todos/review-pass-11.md`

## Cleanup

- All 5 source zips and extraction folders moved to `.recycle-bin\`
- `src/Electronics/Library/temp/` is now empty (folder preserved per user instruction)

---

## Key Numbers
- Next checkpoint: **161** (assign when user next approves)
- Next DEC entry: **DEC-073**
- `review-report.md`: ~1487 lines, complete through Pass 9
- Library: `SamacSys_Parts.3dshapes/` now contains 32 STP files (was 27 before this session)

## Standing Directives (all active)
- PRIMARY: Never modify MPN/supplier PN
- SECONDARY: NEVER git commit/add/unstage; trigger = "Let's lock this in" or "Save state"
- TERTIARY: `design/Design_Log.md` append-only; next entry = DEC-073
- QUATERNARY: Never permanently delete — move to `.recycle-bin/`
- QUINARY: Review sub-agents READ-ONLY
- SENARY: No file changes without explicit user approval
- SEPTENARY: Every sub-agent prompt must start with mandatory preamble block
- OCTONARY: Seed session DB from `todo-list.md` Agent SQL block as mandatory first action; keep
  summary table + Agent SQL INSERT + session DB in 3-way sync at all times
- No unsolicited checkpoints — write only when user approves
