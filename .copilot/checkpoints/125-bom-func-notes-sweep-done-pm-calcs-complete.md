# Checkpoint 125 — bom-func-notes-sweep complete; PM calc equations added

**Date:** 2026-05-08
**Status:** Complete — ready to commit

## Overview

`bom-func-notes-sweep` todo marked done. All BOM Notes column functional content had been swept in prior sessions. This checkpoint closes the task after confirming that all calculation equations removed from BOM Notes were correctly preserved in the spec body.

Additionally fixed Extension J9 BOM note (functional description removed → `-`).

## Work Done

### PM Design_Spec.md — calc equations added to spec body

Three calculation blocks were missing from the spec body after the BOM Notes sweep:

1. **R11/R12 backup threshold derivation** (§5, ~line 306–310):
   - Added working-backward derivation from target V_trigger=4.812V
   - Formula: `R11/R12 = (V_trigger/V_thr) − 1 = (4.812/1.2) − 1 = 3.010`
   - Choice: R12=10.0kΩ → R11=30.10kΩ → E96 exact at 30.1kΩ
   - Verification: `1.2V × 40.1/10.0 = 4.812V ✓`

2. **MIC1555 astable timing formula** (§5, ~line 343–345):
   - Added formula `f = 1.44 / ((R_A + 2×R_B) × C)` with full substitution
   - `1.44 / ((10kΩ + 2×715kΩ) × 1µF) = 1.44 / 1.44 = 1.00Hz ✓`
   - Duty cycle: `D = 715/1440 ≈ 49.7% ≈ 50% ✓`

3. **R23 LTC3350 switching frequency rationale** (§5, ~line 319–323):
   - Added body bullet explaining why 400kHz is required
   - 200kHz default → only 2 cycles in 10.2µs window → insufficient
   - R23=33.2kΩ to GND → 400kHz → ≥4 cycles → reliable switchover
   - Reference: LTC3350 datasheet RT programming table; DEC-030

Already correct (no action needed):
- R9 RICHARGE formula `ICH = VICHARGE / (RICHARGE × RSENSE)` ✓
- U13 monostable `t = 1.1 × R21 × C40 = 3.01s` ✓

### Extension Design_Spec.md

- J9 BOM Notes column: `AM host dock` → `-` (functional description removed; covered by DR-EXT-09 and §2)

### todo-list.md

- `bom-func-notes-sweep` marked `✔ DONE` with strikethrough

## Files Modified

- `design/Electronics/Power_Module/Design_Spec.md`
- `design/Electronics/Extension/Design_Spec.md`
- `.copilot/todo-list.md`

## Next Steps

Review remaining todo items. Candidates:
- `bom-notes-sweep` — procurement-only notes audit across all boards
- `full-pn-review` — supplier PN integrity sweep before KiCAD work
- `footprint-requests-pending` — download remaining pending footprints
