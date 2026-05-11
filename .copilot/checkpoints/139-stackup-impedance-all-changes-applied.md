# Checkpoint 139 — Stackup & Impedance Changes Fully Applied

**Session:** e39f3cc4  
**Date:** 2026-07-13  
**Branch:** main  
**Git state:** Clean at commit `80007e8`; all changes written to disk, not staged (per SECONDARY directive)

---

## Overview

All stackup code corrections and JLCPCB-authoritative impedance values have been applied across
all 10 board Design_Spec.md files, plus JLCPCB_Manufacturing.md, Global_Routing_Spec.md, and
Design_Log.md. The research archive has been moved to `.recycle-bin/`. This checkpoint captures
the complete, final state of the stackup workstream (DEC-065).

---

## Work Completed This Session

### Board Design_Spec.md files (all 10 boards)

| Board | Changes applied |
| :--- | :--- |
| Rotor | DR-ROT-01 code; §3.3 physical params (h=0.092mm, t=0.030mm, Eᵣ=4.2); §4 code → `JLC041621-3313`; trace width → 0.1425 mm |
| Stator | Line 14 code; DR-STA-01; §7 code; bug fix §7 "0.5oz inner" → "1oz inner" |
| Extension | §4 code; JTAG trace width → 0.1425 mm (5.61 mil); DEC-017 ref updated |
| Reflector | DR-REF-01; §2 heading; §6 code → `JLC041621-3313` |
| Encoder | DR-ENC-01; §9 code; §5 trace width → 0.1425 mm |
| JTAG Module | §5 code → `JLC041621-3313`; §6 trace width → 0.1478 mm (inner stripline, inverted stackup per DEC-016) |
| Actuation Module | DR-AM-01 code → `JLC041621-3313` |
| User Settings Module | Overview; DR-USM-01; §8 code; copper weight description corrected |
| Power Module | DR-PM-13 code → `JLC061621-3313`; §1 stackup text (CI not required clarified) |
| Controller | Overview; DR-CTL-01; §9.1 (code + CI-required); §9.2 (full layer table rewrite, BI_DB crossover, USB SS dual-stack rationale); §9.3 (JLCPCB trace widths rewrite, IPC warning); §9.4 new (via-in-pad rules, stub resonance, anti-pad, ESD TVS placement) |

### Manufacturing & standards documents

| Document | Changes applied |
| :--- | :--- |
| `design/Production/JLCPCB_Manufacturing.md` | Full §1 rewrite: §1.0 naming convention; §1.1 JLC041621-3313 (physical table, CI trace widths, IPC warning, board list); §1.2 JLC061621-3313 (physical table, CI trace widths, CI requirement table); §1.3 stackup catalog; §4 cross-ref codes corrected |
| `design/Standards/Global_Routing_Spec.md` | §1 CI exception updated to per-stackup JLCPCB calculator reference; Signal/CI row in trace width table updated |
| `design/Design_Log.md` | DEC-065 appended (stackup selection rationale, correct codes, physical stackup confirmation, IPC accuracy finding, CI requirement difference CTL vs PM, all board assignments, all files changed) |

### File operations

- `.copilot/discussions/stackup-impedance-analysis.md` → `.recycle-bin/discussions/stackup-impedance-analysis.md` (moved per QUATERNARY directive)

---

## Authoritative Impedance Values (JLCPCB Calculator)

| Target | Type | JLC041621-3313 (4L) | JLC061621-3313 (6L) | Spacing |
| :--- | :--- | :--- | :--- | :--- |
| 50Ω SE | Microstrip (outer) | 0.1425 mm / 5.61 mil | 0.1425 mm / 5.61 mil | — |
| 50Ω SE | Stripline (inner) | 0.1478 mm / 5.82 mil | 0.1387 mm / 5.46 mil | — |
| 90Ω diff | Diff microstrip (outer) | 0.1468 mm / 5.78 mil | 0.1468 mm / 5.78 mil | 0.2032 mm / 8.00 mil |
| 100Ω diff | Diff stripline (inner) | 0.1128 mm / 4.44 mil | 0.1123 mm / 4.42 mil | 0.2032 mm / 8.00 mil |

---

## Standing Directives

- **PRIMARY:** Never modify MPNs or supplier PNs
- **SECONDARY:** Never git commit/stage — all changes written to disk only
- **TERTIARY:** Design_Log.md is append-only
- **QUATERNARY:** Never permanently delete files — move to `.recycle-bin/`
- **SENARY:** SENARY approval was granted for all stackup changes in this workstream

---

## Pending / Open Items

- User to review all changes and stage/commit when satisfied
- No outstanding todos from the `stackup-impedance-recalc` workstream
- **Metadata note:** Last Updated dates in Design_Spec.md files were NOT updated during this session. Two conflicting memories exist on this policy; user to decide whether to update dates before committing.

---

## Key Files Modified

- `design/Electronics/Rotor/Design_Spec.md`
- `design/Electronics/Stator/Design_Spec.md`
- `design/Electronics/Extension/Design_Spec.md`
- `design/Electronics/Reflector/Design_Spec.md`
- `design/Electronics/Encoder/Design_Spec.md`
- `design/Electronics/JTAG_Module/Design_Spec.md`
- `design/Electronics/Actuation_Module/Design_Spec.md`
- `design/Electronics/User_Settings_Module/Design_Spec.md`
- `design/Electronics/Power_Module/Design_Spec.md`
- `design/Electronics/Controller/Design_Spec.md`
- `design/Production/JLCPCB_Manufacturing.md`
- `design/Standards/Global_Routing_Spec.md`
- `design/Design_Log.md`
- `.recycle-bin/discussions/stackup-impedance-analysis.md` (moved from `.copilot/discussions/`)
