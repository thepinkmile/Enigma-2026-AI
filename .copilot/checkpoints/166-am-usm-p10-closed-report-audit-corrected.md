# Checkpoint 166 — AM/USM P10 findings closed; review-report Phase A audit corrected; two new todos

**Date:** 2026-05-22

---

## Overview

Session resolved the four remaining AM and USM Pass-10 findings (all were stale or already applied
by the user manually), added two new structural todos (`design-log-restructure` and
`copilot-dir-restructure`) as blockers for `review-pass-11`, and corrected multiple stale
discrepancies found in the review-report.md Phase A Summary table. Only JM-P10-04 and JM-P10-05
remain open.

---

## Work Done

### New todos added (both blocking `review-pass-11`)

| Todo ID | Description |
|---------|-------------|
| `design-log-restructure` | Restructure `design/Design_Log.md` into `design/Design_Log/` directory with `index.md` + per-DEC files named `DEC-NNN_{kebab-title}.md`; Design_Log/ to be first entry in GitHub Actions wiki nav |
| `copilot-dir-restructure` | Split `agent-directives.md` (~38 KB) and `todo-list.md` (~37 KB) into smaller focused files to reduce context pressure and prevent directive drop-out |

Both added to `todo-list.md` summary table, Agent SQL block, and dep entries for `review-pass-11`.
Detail files created under `.copilot/todos/`.

### Pass-10 findings resolved this session

| Finding | Sev | Board | Resolution |
|---------|-----|-------|------------|
| AM-P10-03 | LOW | AM | Stale — `Board_Layout.md` lines 56/61 already have GRS §7.1 pin-1 callouts for J2/J3 and J4/J5. Not previously checked off. |
| USM-P10-06 | LOW | USM | Already resolved manually by user. "DPDT" does not appear anywhere in `Design_Log.md` (full-file search). `Design_Spec.md` uses "SPDT" consistently. No DEC entry created or required. |
| USM-P10-08 | LOW | USM | Stale — `Board_Layout.md` line 69 already has GRS §7.1 pin-1 callout for J1 (only external connector on USM). Not previously checked off. |
| USM-P10-09 | LOW | USM | Deferred to `data-plate-standardisation` workstream. Full corrective actions (remove spec blockquote at `Board_Layout.md` line 217; add standard Data Plate bullet to `Design_Spec.md`) documented in `.copilot/todos/data-plate-standardisation.md` §3–§4. |

### Remaining open Pass-10 findings (2)

| Finding | Sev | Board | Status |
|---------|-----|-------|--------|
| JM-P10-04 | LOW | JM | UART power-on contention window undocumented — **next up** |
| JM-P10-05 | LOW | JM | "400mA peak" 5V_USB figure ≈4× actual — no derivation footnote |

### review-report.md audit and corrections

Multiple board summary lines and Phase A Summary table rows were found to be stale. All corrected
to match the actual per-finding status in each table.

**Summary line corrections:**

| Board | Old | New |
|-------|-----|-----|
| REF | 5 resolved, 1 partial, 2 open | 7 resolved, 1 partial, 0 open |
| AM | 4 resolved, 0 partial, 3 open (stale) | 7 resolved, 0 partial, 0 open |
| USM | 9 resolved, 0 partial, 3 open | 12 resolved, 0 partial, 0 open |

**Phase A Summary table corrections:**

| Board | Old | New |
|-------|-----|-----|
| STA | 1 \| 1 \| 1 \| 3 | 3 \| 0 \| 0 \| 3 |
| EXT | 0 \| 1 \| 8 \| 9 | 9 \| 0 \| 0 \| 9 |
| ENC | 1 \| 0 \| 5 \| 6 | 6 \| 0 \| 0 \| 6 |
| AM | 4 \| 0 \| 3 \| 7 | 7 \| 0 \| 0 \| 7 |
| USM | 9 \| 0 \| 3 \| 12 | 12 \| 0 \| 0 \| 12 |
| **TOTAL** | **72 \| 3 \| 16 \| 91** | **88 \| 1 \| 2 \| 91** |

The 2 remaining open findings are JM-P10-04 and JM-P10-05. The 1 partial is REF-P10-05
(2BHR-30-VUA footprint pending supplier response — not a blocker for design phase).

### plan.md corrections

- DEC-080 description corrected: "SPDT/DPDT terminology correction" was an agent error;
  actual DEC-080 = "Retrospective: PM and Stator Dock Connector Redesignation (Amends DEC-038)"
- DEC-081 description corrected: actual DEC-081 = "Retrospective: Rotor TTD No-Series-Resistor
  Policy (In Addition to DEC-016)"

### data-plate-standardisation.md

§4 (Board_Layout cleanup) updated to include the exact blockquote text to be removed from
`User_Settings_Module/Board_Layout.md` line 217, and clarified that the Design_Spec.md
Data Plate bullet will be added as part of §3 once the USM German board name is agreed.

---

## Files Modified

`.copilot/plan.md` ·
`.copilot/todo-list.md` ·
`.copilot/review-report.md` ·
`.copilot/handoff.md` ·
`.copilot/todos/design-log-restructure.md` (created) ·
`.copilot/todos/copilot-dir-restructure.md` (created) ·
`.copilot/todos/data-plate-standardisation.md` (§4 expanded) ·
`.copilot/checkpoints/166-am-usm-p10-closed-report-audit-corrected.md` (this file) ·
`.copilot/checkpoints/index.md`

---

## State at Checkpoint

- **Next checkpoint = 167**
- **Next DEC = DEC-084**
- **Pass-10:** 89 resolved + 1 partial + 2 open = 91 total; only JM-P10-04 and JM-P10-05 remain
- **review-pass-11** blocked by: `data-plate-standardisation`, `design-log-restructure`, `copilot-dir-restructure`
- **Next action:** JM-P10-04 — document UART power-on contention window in `JTAG_Module/Design_Spec.md` §6
