# Checkpoint 154 — Pin format fixes, NC cleanup, todo dep restoration

**Date:** 2026-05-13

## Overview

Applied three categories of clean-up work across USM and Stator design documents and the todo-list,
correcting pin range designator ordering, removing residual `spare/no-connect` text, and restoring
todo dependency entries that a prior agent had incorrectly stripped from the markdown table.

## Work Done

### Pin range format fixes (`[MSB:LSB]` ordering enforced)

All pin range designators in formal pin tables corrected to `PIN_NAME[MSB:LSB]` convention:

| File | Location | Old | New |
| :--- | :--- | :--- | :--- |
| `Stator/Design_Spec.md` | U7 GPB NC range | `[2:6]` | `[6:2]` |
| `Stator/Design_Spec.md` | U8 GPA NC range | `[4:5]` | `[5:4]` |
| `USM/Design_Spec.md` | U1 GPA NC range | `[4:5]` | `[5:4]` |
| `USM/Design_Spec.md` | U2 GPB NC range | `[0:6]` | `[6:0]` |
| `USM/Design_Spec.md` | U3 GPB NC range | `[2:6]` | `[6:2]` |
| `USM/Board_Layout.md` | U3 GPB NC range | `[2:6]` | `[6:2]` |

Note: Prose references such as `GPA[0:6] and GPB[0:6]` in silicon-restriction blockquotes are
descriptive text (not formal pin designators) and were intentionally left unchanged.

### NC terminology cleanup (`spare/no-connect` / `spare/NC` → `NC`)

Applied to `USM/Design_Spec.md` only (no remaining instances in other files):

- U1 GPA[7] description: `; spare/no-connect` → `; NC`
- U1 GPB[7] description: `; spare/no-connect` → `; NC`
- U1 silicon note: `GPA[7] is spare/NC. GPB[7] is spare/NC.` → `GPA[7] is NC. GPB[7] is NC.`
- U2 GPB[7] description: `; spare/no-connect` → `; NC`
- U2 silicon note: `GPB[7] is spare/NC.` → `GPB[7] is NC.`
- U3 GPB[7] description: `; spare/no-connect` → `; NC`
- U3 silicon note: `GPB[7] is spare/NC.` → `GPB[7] is NC.`

### Todo dependency restoration (`.copilot/todo-list.md`)

A prior agent stripped done-but-existing dependency entries from the markdown table. Restored:

| Todo row | Change |
| :--- | :--- |
| `full-pn-review` | Added `am-button-review-production` |
| `interim-electronics-review-1` | Restored 8 done deps: `rotor-refdes-reallocate`, `bulk-caps-per-power-source-or-conversion`, `ctl-l02-refdes-gap`, `enc-cpld-spare-pins-rule`, `jtag-pin1-silkscreen-grs`, `jtag-integrity-resistor-value-reconcile`, `mcp23017-gpb7-silicon-fixed-review`, `rot-i2c-residual-removal` — total now 11 |
| `interim-electronics-review-2` | Added `review-mounting-holes` |
| `prototype-pcb-manufacturing` | Added `review-mounting-holes` |
| `ctl-t1-coilcraft-v2-review` | Replaced `—` with `ctl-t1-transformer-decision` |

SQL dep section: added missing entry `('ctl-t1-coilcraft-v2-review', 'ctl-t1-transformer-decision')`.

## Files Modified

- `design/Electronics/Stator/Design_Spec.md`
- `design/Electronics/User_Settings_Module/Design_Spec.md`
- `design/Electronics/User_Settings_Module/Board_Layout.md`
- `.copilot/todo-list.md`

## Open Workstreams

- `usm-spdt-switch-floating-review` — USM SPDT switch pin mapping to GPIO expander + pull-up/down check against datasheet
- `enc-connector-review-pre-pcb` — ENC J1/J2 and 100nF cap review
- `consolidate-design-spec-content` — blocked by `enc-connector-review-pre-pcb`
