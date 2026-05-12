# Checkpoint 145 — PM Bulk-Cap DEC-068 Propagation Complete

## What was accomplished

Closed out the `bulk-caps-per-power-source-or-conversion` todo by propagating all three locked
DEC-068 bulk-capacitor decisions across every affected design file. All writes are disk-only;
no git operations performed.

## Locked decisions (DEC-068)

| Position | Part MPN | Count | RefDes |
| :--- | :--- | :--- | :--- |
| Pre-OR-ing per input (×3 inputs) | CL32B226KAJNNNE (22µF X7R 25V 1210) | 3× per input = 9 total | C59–C67 |
| 5V\_MAIN near J1 | CL21B106KAYQNNE (10µF X7R 25V 0805) | 5× | C68–C72 |
| 3V3\_ENIG near J1 | CL21B106KAYQNNE (10µF X7R 25V 0805) | 5× | C73–C77 |

Key topology notes:
- Q1 three-cap banks: tight parallel cluster (linear row / close cluster), NOT GRS star — star is specific to five-cap banks
- Q2: C68–C72 are distinct from C14/C15 (DEC-030 holdup caps); do not co-locate
- Q3: C73–C77 are distinct from C23 (TPS75733 minimum-stability cap)
- GRS §3 exemption note corrected: "C1–C4" → "C1–C13" (13-cap input filter bank)

## Files updated

| File | Change |
| :--- | :--- |
| `.copilot/discussions/pm-bulk-caps-and-per-input-protection.md` | Edit 5: `**Decisions pending:**` block replaced with locked decisions log entry (Q1/Q2/Q3, precedence citations, checklist) |
| `design/Electronics/Power_Module/Design_Spec.md` | DR-PM-16/17/18 added; GRS §3 exemption note corrected; BOM rows C59–C67, C68–C72, C73–C77 added |
| `design/Electronics/Consolidated_BOM.md` | CL32B226KAJNNNE row: `PM: C1-C15` → `PM: C1-C15,C59-C67`, PM Qty 15→24; CL21B106KAYQNNE row: `PM: C20` → `PM: C20,C68-C77`, PM Qty 1→11; Last Updated updated |
| `design/Design_Log.md` | DEC-068 appended (context, decision, rationale, 6 precedence citations, placement constraints, files changed); Last Updated updated |
| `.copilot/todo-list.md` | `bulk-caps-per-power-source-or-conversion` marked done (table row + SQL seed block) |

## Housekeeping

- markdownlint run on discussion file and PM Design_Spec.md — clean
- SQL todo `bulk-caps-per-power-source-or-conversion` marked `done`
- `.copilot/todo-list.md` updated (both table and SQL seed block)

## Next steps

Resume remaining todo list. Open todos include:
- `ctl-t1-tdk-a120-component-analysis` (check whether already done)
- `jtag-integrity-resistor-value-reconcile` (pending)
- `mcp23017-gpb7-silicon-fixed-review` (pending)
- `rot-i2c-residual-removal` (pending)
- `consolidate-design-spec-content` (pending)
- `usm-spdt-switch-floating-review` (pending)
- Various component diagram and review todos
