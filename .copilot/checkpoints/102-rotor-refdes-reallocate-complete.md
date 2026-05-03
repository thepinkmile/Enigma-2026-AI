# Checkpoint 102 — Rotor RefDes reallocation complete

## What was done

Pre-condition `rotor-refdes-reallocate` completed before deep-review pass 4.

R1 was removed in pass 3 (series termination resistor, "no series termination resistor is
used on this board"). This left a RefDes gap (R2–R7 with no R1). All references renumbered
to close the gap:

| Old | New | Function |
|-----|-----|---------|
| R2 | R1 | TMS 10kΩ pull-up |
| R3 | R2 | TDI 10kΩ pull-up |
| R4 | R3 | TCK 10kΩ pull-down |
| R5 | R4 | SYS_RESET_N 10kΩ pull-up (DEV_CLR_N) |
| R6 | R5 | 4.7kΩ I²C pull-up |
| R7 | R6 | 4.7kΩ I²C pull-up |

## Files changed

| File | Change |
|------|--------|
| `design/Electronics/Rotor/Design_Spec.md` | Pull resistor heading R2–R5→R1–R4; bullet labels R2/R3/R4/R5→R1/R2/R3/R4; BOM rows R2–R5→R1–R4 and R6–R7→R5–R6; support-network note R6/R7→R5/R6 |
| `design/Electronics/Rotor/Board_Layout.md` | U1 signal map: R5 (DEV_CLR_N pull-up) → R4 |
| `design/Electronics/Consolidated_BOM.md` | ROT row R2-R5→R1-R4 (10kΩ); ROT row R6,R7→R5,R6 (4.7kΩ) |
| `.copilot/agent-directives.md` | Review Suppression: ROT-MOQ label updated R6/R7→R5/R6 |

## Lint

All 3 design files: `markdownlint` exit 0 — clean.

## Status

- [x] `rotor-refdes-reallocate` — DONE
- [ ] Deep-review pass 4 — starting next
