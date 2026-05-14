# Checkpoint 157 — USM Switch Topology Complete

## Overview

Full resolution of the `usm-spdt-switch-floating-review` todo. Replaced the original pull-down resistor topology (R1–R10) on SPDT toggle switches with a dual-terminated switch wiring scheme, and renumbered the sole remaining 10kΩ resistor R11 → R1. DEC-071 appended to the design log. All affected design files updated.

## What Was Done

### Design decisions
- E-Switch 200MSP1T2B4M2QE SPDT terminals: Pin 1=NC, Pin 2=COM, Pin 3=NO
- New wiring: NC→GND, COM→CFG_* GPIO (U1), NO→3V3_ENIG
- Both throws hard-terminated; no floating in either switch position; no pull resistors required
- R1–R10 (10kΩ 0603 switch pull-downs) removed entirely
- R11 (10kΩ 0603 CFG_APPLY_N pull-up, DR-USM-07) renumbered to R1
- LED architecture confirmed independent (U2 @ 0x24, U3 @ 0x25 — software controlled only)

### Design_Log.md
- DEC-071 appended covering dual-terminated topology adoption, R1–R10 removal, R11→R1 renumbering

### design/Electronics/User_Settings_Module/Design_Spec.md
- Last Updated updated to 2026-05-14
- DR-USM-07: BOM cross-ref `SW11, R11, C4` → `SW11, R1, C4`
- DR-USM-09: Full rewrite — dual-terminated topology described; no pull-down content
- U1 GPA[0:3] and GPB[0:5] pin tables: Pull column `10kΩ pull-down` → `— (switch-terminated)`
- Silicon note: rewritten — switch-terminated inputs, NC→GND/NO→3V3_ENIG/COM→GPIO, R1 for CFG_APPLY_N
- §6 body: `(R11)` → `(R1)`
- BOM row: `R1-R11 | Qty 11` → `R1 | Qty 1`
- Component count table: removed pull-down row (10 parts); kept single `0603 Resistors | 1 | R1` row; total 166 → 156

### design/Electronics/User_Settings_Module/Board_Layout.md
- Last Updated updated to 2026-05-14
- Placement zone §2 line: `Centre-left: U1, switch pull-downs, R11, C4` → `Centre-left: U1, R1, C4`

### design/Electronics/Consolidated_BOM.md
- Last Updated updated to 2026-05-14
- 10kΩ row: RefDes `USM: R1-R11` → `USM: R1`; USM qty 11 → 1; System qty 21 → 11

### .copilot/todo-list.md
- `usm-spdt-switch-floating-review`: status pending → done; file link removed
- `interim-electronics-review-1`: removed `usm-spdt-switch-floating-review` from blocked-by list
- SQL INSERT: `usm-spdt-switch-floating-review` status `'pending'` → `'done'`
- Last Updated date updated

### .copilot/todos/usm-spdt-switch-floating-review.md
- Moved to `.recycle-bin/`

## Standing Constraints

- PRIMARY: Never modify MPN/supplier PN
- SECONDARY: Never git commit/add/unstage
- TERTIARY: Design_Log.md append-only; next entry = DEC-072
- QUATERNARY: Never delete files — move to `.recycle-bin/`
- SENARY: No file changes without explicit user approval

## Next Steps

- Continue with remaining ready todos
- `interim-electronics-review-1` is still blocked by: `review-pass-10`, `stackup-impedance-recalc`, `bulk-caps-per-power-source-or-conversion`, `ctl-l02-refdes-gap`, `enc-cpld-spare-pins-rule`, `jtag-pin1-silkscreen-grs`, `jtag-integrity-resistor-value-reconcile`, `mcp23017-gpb7-silicon-fixed-review`, `rot-i2c-residual-removal`, `consolidate-design-spec-content`
