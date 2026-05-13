# Checkpoint 148 — JTAG integrity reconcile complete

## Overview

Full reconciliation of `JTAG_Integrity.md` against all board Design_Specs following
the DEC-065 stackup code change (JLC04161H-7628 → JLC041621-3313 /
JLC06161H-2116 → JLC061621-3313). Seven discrepancies were found — all in
`JTAG_Integrity.md` only; all board Design_Specs were already correct.
One cross-reference error in Extension/Design_Spec.md was fixed as a collateral
correction. All files lint-clean; no new DEC entries required (documentation
corrections only, not design decisions).

## Work Done

- **§7 narrative + §7.4 Stator TDI refdes corrected:** R27-R32 → R24-R29
- **§7 narrative + §7.4 Stator TMS refdes corrected:** R33-R38 → R30-R35
  (old range falsely overlapped MCP23017 /RESET pull-ups R36-R38 which are 10kΩ)
- **§8 trace widths updated (all boards):** 0.127 mm → 0.1425 mm (L1 outer
  microstrip); JM L2 inner stripline 0.1478 mm (was also 0.127 mm)
- **§8 stackup codes updated (all boards):** JLC04161H-7628 → JLC041621-3313 (4L);
  JLC06161H-2116 → JLC061621-3313 (6L) — eliminated codes removed per DEC-065
- **§9 cost table Stator package corrected:** 0603 → 0402 (ERJ-2RKF75R0X)
- **§9 cost table Stator refdes grouping corrected:** R7-R12, R27-R38 → R7-R12, R24-R35
- **§9 cost table JM R1 restored:** JM R2-R4 qty 3 → JM R1-R4 qty 4
- **Extension/Design_Spec.md cross-reference corrected:** stale Stator JTAG refdes
  R27-R32/R33-R38 → R24-R29/R30-R35 to match Stator Design_Spec.md
- **Date fields updated** in both modified files to 2026-05-13
- **`todo-list.md` updated:** `jtag-integrity-resistor-value-reconcile` → done
- **Todo detail file removed** to `.recycle-bin/`

## Files Modified

- `design/Electronics/JTAG_Module/JTAG_Integrity.md` — 9 edits across §7, §8, §9; Date updated
- `design/Electronics/Extension/Design_Spec.md` — Stator refdes cross-ref corrected; Last Updated updated
- `.copilot/todo-list.md` — status updated to done (table + SQL block)

## Technical Details

**JTAG resistor value framework (unchanged — authority confirmed correct):**

| Context | Value |
|---|---|
| Output driving ribbon cable (~100Ω IDC) | 75Ω |
| Output driving short BtB/intra-board 50Ω trace | 33Ω |
| Reflector R1 — end-of-chain TDO | 22Ω |
| Pull resistors (TMS pull-up, TCK pull-down, RESET_N) | 10kΩ |

**Trace width authority (JLCPCB_Manufacturing.md §1.1, JLC041621-3313 stackup):**
- L1 outer microstrip: 0.1425 mm (5.61 mil) — Stator, Encoder, Rotor, Reflector, Extension, CTL
- L2 inner stripline: 0.1478 mm (5.82 mil) — JM only (inverted stackup, JTAG on L2)

**Board-by-board status (all confirmed correct, no changes needed):**

| Board | Component | Value |
|---|---|---|
| JM | R1-R4 | 33Ω 0402 |
| JM | R5-R7 | 10kΩ 0402 |
| Stator | R7-R12 | 75Ω 0402 (TCK → J4-J9) |
| Stator | R24-R29 | 75Ω 0402 (TDI chain) |
| Stator | R30-R35 | 75Ω 0402 (TMS → J4-J9) |
| Encoder | R6 | 75Ω 0402 (TDO cable output) |
| Reflector | R1 | 22Ω 0603 (end-of-chain TDO) |
| Rotor | — | No series resistors (BtB path) |
| Extension | — | No series resistors (U1 re-buffer) |
| Controller | — | Pass-through only |

## Next Workstreams

1. `mcp23017-gpb7-silicon-fixed-review` — pending, no blockers
2. `usm-spdt-switch-floating-review` — pending, no blockers
3. `enc-connector-review-pre-pcb` — pending, no blockers
4. `consolidate-design-spec-content` — pending, blocked by `enc-connector-review-pre-pcb`
