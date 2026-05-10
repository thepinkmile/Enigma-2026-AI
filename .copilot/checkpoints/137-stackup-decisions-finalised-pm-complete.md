# Checkpoint 091 — Stackup Decisions Finalised, PM Analysis Complete

**Date:** 2026-05-10
**Session:** e39f3cc4
**Todo:** stackup-impedance-recalc (in progress)

## Status

All board stackup selections confirmed by user. PM 6-layer analysis complete.
JLCPCB calculator verification step is next — requires user to run manually online.

## Decisions confirmed (2026-05-10)

| Board group | Stackup | CI service? |
|---|---|---|
| All 4-layer boards (8 boards) | JLC041621-3313 | Required |
| CTL (6-layer) | JLC061621-3313 | Required |
| PM (6-layer) | JLC061621-3313 | NOT required |

One stackup per layer-count group. No mixed variants across the system.

## PM analysis summary

- PM carries zero CI signals (confirmed: Design_Spec §6)
- Needs 2oz outer for GND_CHASSIS fills and power rails
- 1oz inner preferred over H/HOZ for current-carrying inner routes (up to several amps)
- JLC061621-3313 is the correct stackup independently of CTL
- CI service can be explicitly opted out for PM at JLCPCB

## Pending actions

1. **User to run JLCPCB impedance calculator** for JLC041621-3313 and JLC061621-3313
   - Inputs documented in .copilot/discussions/stackup-impedance-analysis.md Section 20
   - Need: W for 50 ohm outer microstrip, 50 ohm inner stripline, 90 ohm diff outer, 100 ohm diff inner

2. After calculator results confirmed, per-file SENARY approval then file updates:
   - design/Production/JLCPCB_Manufacturing.md
   - design/Standards/Global_Routing_Spec.md
   - All 10 board Design_Spec.md files
   - design/Design_Log.md (append DEC-062)

3. Open: JM/AM layer order convention (GND as bottom for carrier-mounted boards)

## Files updated this session

- .copilot/discussions/stackup-impedance-analysis.md (Section 13 updated, Section 15 updated, Section 20 appended)
- .copilot/handoff.md (2026-05-10 stackup session section added)

## Key archive

.copilot/discussions/stackup-impedance-analysis.md — approx 830 lines, complete research archive

