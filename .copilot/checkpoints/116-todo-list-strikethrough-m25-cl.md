# Checkpoint 116 — todo-list strikethrough; m25 closed

**Date:** 2026-05-06
**Branch:** main

## Overview

Closed `m25-m3-dec-exception` (verified covered by GRS §5 + DEC-057), applied
`~~strikethrough~~` to all 8 completed rows in `todo-list.md` tables, and updated
JLCPCB part numbers for CTL U7 (TPS2372-4RGWR → C470955) and U8 (TPS23730RMTR →
C3189530) in `Consolidated_BOM.md` and `Controller/Design_Spec.md`.

## Files Changed

- `.copilot/todo-list.md`
  - `m25-m3-dec-exception` row: status → done; description cites GRS §5 and DEC-057
  - SQL reconstruction reference: status `'pending'` → `'done'`
  - 8 done rows (1 in Open Workstreams, 7 in Electronics Deferrals) now have
    full per-cell `~~strikethrough~~` formatting

- `design/Electronics/Consolidated_BOM.md`
  - CTL U7 TPS2372-4RGWR: JLCPCB → `C470955`; consignment qualifier removed
  - CTL U8 TPS23730RMTR: JLCPCB → `C3189530`; consignment qualifier removed

- `design/Electronics/Controller/Design_Spec.md`
  - U7 TPS2372-4RGWR: JLCPCB → `C470955`
  - U8 TPS23730RMTR: JLCPCB → `C3189530`

- `.copilot/checkpoints/115-b4-batch-bom-complete.md` — encoding fix (`✓` → `[ok]`)
- `.copilot/checkpoints/index.md` — encoding artefact removed; entry 115 added

## Technical Notes

- `m25-m3-dec-exception` resolution: DEC-057 is comprehensive — covers M2.5
  NPTH daughterboard holes, GND vs GND_CHASSIS rule, standoff BOM ownership,
  CTL/EXT/AM/JDB special-case tables. GRS §5 (lines 172–174) provides policy basis.
- Strikethrough applied per-cell (between `|` separators) as required by GFM spec.
  Already-wrapped cells were skipped; separator rows were not touched.
- CoilCraft samples ordered (POE600F-12L, Ref: 153954) — noted in todo-list.md.

## Remaining JLCPCB Consignment Parts (3)

- PM FB1: BMC-Q2AY0600M — JLCPCB global sourcing
- PM J1–J3: 1123684-7 (LCSC C3683043) — JLCPCB consignment
- AM U1: STM32G071K8T3TR — JLCPCB consignment

## Next Steps

- `jdb-standoff-height` — determine JDB hat-header stacking height and M2.5 SMT standoff PN
- `mh-refdes-standardise` — blocked on `jdb-standoff-height`
