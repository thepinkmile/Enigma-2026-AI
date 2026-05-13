# Checkpoint 152 — Todo-list audit and cleanup

## Date
2026-05-13

## Overview

Full audit of `.copilot/todo-list.md` following session reboot. All 127 summary-table rows and
the SQL section reviewed against the actual `todos/` directory contents and the design files.
Twelve targeted edits applied to correct status mismatches, remove stale file links from done rows,
fix stale Blocked By entries, and update the SQL section. Three missing detail files created.

## Work Done

### Audit findings and corrections

**Category A — Component diagram rows — CORRECTION:**
This session initially searched for `block-beta` in Design_Spec.md files, found zero hits, and
**incorrectly** concluded all 10 component diagram todos were pending. The user confirmed this was
wrong: the diagrams ARE complete — implemented using `flowchart TD` with subgraphs after `block-beta`
was rejected as unviewable. The initial "correction" to `pending` was itself the error; all 10
rows have been restored to `done` with `—` file links, and the 10 detail files have been moved to
`.recycle-bin/`. SQL descriptions updated from `block-beta` → `flowchart TD`. This was an agent
error caused by searching for the wrong keyword without confirming with the user first.

**Category B — Done rows with stale file links:**
Seven done rows at lines 112–118 still had file links. Links cleared to `—`:
- `bulk-caps-per-power-source-or-conversion`
- `ctl-l02-refdes-gap`
- `enc-cpld-spare-pins-rule`
- `jtag-pin1-silkscreen-grs`
- `jtag-integrity-resistor-value-reconcile`
- `mcp23017-gpb7-silicon-fixed-review`
- `rot-i2c-residual-removal`

Also cleared: `am-button-review-production` (line 121), `ctl-t1-tdk-a120-component-analysis` (line 122).

**Category C — TDK transformer todos confirmed done by user:**
`ctl-t1-tdk-topology-confirm` and `ctl-t1-tdk-library-import` changed from `pending` → `done`;
file links cleared to `—`. Neither had detail files (consistent with done state).

**Category D — Stale Blocked By entries:**
- `interim-electronics-review-1` (line 69): Blocked By trimmed from 11 entries to 3; removed 8
  now-done blockers (`review-pass-1` through `review-pass-8`, `review-mounting-holes`,
  `review-pass-9`, `review-pass-7`, etc.); kept `review-pass-10`, `consolidate-design-spec-content`,
  `usm-spdt-switch-floating-review`
- `interim-electronics-review-2` (line 70): removed `review-mounting-holes` from Blocked By
- `prototype-pcb-manufacturing` (line 73): removed `review-mounting-holes` from Blocked By
- `full-pn-review` (line 35): removed `am-button-review-production` from Blocked By
- `ctl-t1-coilcraft-v2-review` (line 126): Blocked By changed from `ctl-t1-transformer-decision`
  → `—` (blocker is now done; v2.0 deferred but unblocked)

**Category E — SQL section:**
- `mcp23017-gpb7-silicon-fixed-review`: SQL status `'pending'` → `'done'`
- `ctl-t1-tdk-library-import`: SQL status `'pending'` → `'done'`
- `ctl-t1-tdk-topology-confirm`: SQL status `'pending'` → `'done'`

**Category F — Last Updated header:**
Line 12 updated to reflect full audit description (date: 2026-05-13).

### Missing detail files created

Three todos had file links in the summary table but no corresponding file in `todos/`:

1. **`.copilot/todos/usm-spdt-switch-floating-review.md`** — SPDT switch pin mapping and
   pull-down verification review. Describes: terminal wiring verification, pull-down vs pull-up
   check against E-Switch 200MSP1T2B4M2QE datasheet, floating throw analysis. USM Design_Spec
   already specifies DR-USM-09 (10× 10kΩ 0603 pull-downs, R1–R10, reads HIGH when closed).
   GPB7 silicon-fixed output-only (DEC-070) — switch assignments already avoid GPB7.

2. **`.copilot/todos/consolidate-design-spec-content.md`** — Design_Spec.md simplification task.
   Scope: all 10 board Design_Spec.md files. Blocked by `enc-connector-review-pre-pcb`.

3. **`.copilot/todos/ctl-t1-coilcraft-v2-review.md`** — v2.0 Coilcraft POE600F-12L transformer
   review. Was blocked by `ctl-t1-transformer-decision` (now done); v2.0 deferred but unblocked.

## Technical Notes

- **No SQL deps changes needed:** `todo_deps` INSERT statements still reference done todos
  (e.g. `rotor-refdes-reallocate`), but the "ready" query filters on `dep.status != 'done'` — done
  deps are automatically inert.
- **QUATERNARY violations noted (historical):** Several done todos have no detail files and are not
  in `.recycle-bin/`. Files appear to have been deleted directly in prior sessions. No corrective
  action possible without the original content. `.recycle-bin/` currently contains only 4 files.
- **Next checkpoint:** 153
- **Next DEC:** DEC-071

## Files Changed

- `.copilot/todo-list.md` — 12 edits applied (+ 3 correction edits)
- `.copilot/todos/usm-spdt-switch-floating-review.md` — created
- `.copilot/todos/consolidate-design-spec-content.md` — created
- `.copilot/todos/ctl-t1-coilcraft-v2-review.md` — created
- `.recycle-bin/` — 10 component diagram detail files moved here
