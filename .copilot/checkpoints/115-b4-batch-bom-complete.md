# Checkpoint 115 — b4 Batch BOM Work Complete

**Session:** a38ceaab-453d-429a-b9a2-f597295a7147  
**Date:** 2026-05-05 / 2026-05-06  
**Status:** Awaiting user review and commit approval

---

## Overview

Three queued batch todos (`b4-consolidated-bom`, `bypass-cap-audit-100nf`, `bom-system-qty-audit`) have all been completed. No MPNs or supplier PNs were changed. The Consolidated BOM is consistent and correct.

---

## Work Done

### `b4-consolidated-bom` (BOM-P6-08 + BOM-P6-09)

Five rows corrected in `design/Electronics/Consolidated_BOM.md`:

| Line | Column fixed | Old value | New value |
|------|-------------|-----------|-----------|
| 33 | Board RefDes (ROT-26 portion) | `C16A` | `C20A` |
| 33 | Board RefDes (ROT-64 portion) | `C16B` | `C20B` |
| 33 | ROT-26 Qty | 9 | 10 |
| 33 | ROT-64 Qty | 9 | 10 |
| 33 | System Qty | 84 | 94 |
| 147 | Board RefDes (ROT-26 portion) | `C15,C17A` | `C15,C21A` |
| 147 | Board RefDes (ROT-64 portion) | `C15,C17B` | `C15,C21B` |
| 147 | System Qty | 2 | 4 |
| 148 | Board RefDes (base ROT portion) | `C18-C21` | `C16-C19` |
| 148 | System Qty | 8 | 16 |
| 150 | System Qty | 8 | 16 |
| 153 | Board RefDes (ROT-26 portion) | `U3A` | `U11A` |
| 153 | Board RefDes (ROT-64 portion) | `U3B` | `U11B` |
| 153 | System Qty | 2 | 4 |

### `bypass-cap-audit-100nf`

Audited all board Design_Spec.md files and both rotor variant files for 100nF X7R bypass cap part numbers. All boards carry exactly:
- MPN: `CL05B104KB5NNNC`
- DigiKey: `1276-CL05B104KB5NNNCCT-ND`
- Mouser: `187-CL05B104KB5NNNC`
- JLCPCB: `C960916`

No discrepancies found. No changes required.

### `bom-system-qty-audit` — Corrected (2026-05-06)

Prior session had applied two errors that were identified and fixed this session:

**1. Line 21 Notes text** — Prior session incorrectly changed from "5× single-variant" to "1× each variant". Reverted to correct rule: **5× ROT boards of a single rotor variant (either all ROT-26 or all ROT-64 — never both)**. Formula: `System Qty = non-ROT sum + (ROT per-board count × 5)`.

**2. All ROT System Qty values recalculated with ×5 multiplier:**

| Line | Component | Wrong Sys Qty | Correct Sys Qty | Formula |
|------|-----------|---------------|-----------------|---------|
| 33 | 100nF 0402 | 94 | 124 | 74 + 10×5 |
| 41 | TPD4E05 ESD | 36 | 60 | 20 + 8×5 |
| 91 | 10µF 0805 | 62 | 77 | 52 + 5×5 |
| 99 | ERF8 female 10-pin | 8 | 14 | 4 + 2×5 |
| 100 | RS1-05-G | 7 | 16 | 1 + 3×5 |
| 135 | EPM570 CPLD | 4 | 7 | 2 + 1×5 |
| 136 | ERM8 male 10-pin | 8 | 14 | 4 + 2×5 |
| 141 | ERF8 female 20-pin | 4 | 7 | 2 + 1×5 |
| 145 | ERM8 male 20-pin | 4 | 7 | 2 + 1×5 |
| 147 | 1µF 0402 | 4 | 10 | 0 + 2×5 |
| 148 | 33pF 0402 | 16 | 40 | 0 + 8×5 |
| 149 | PH1-07-UA | 2 | 5 | 0 + 1×5 |
| 150 | 18µH inductor | 16 | 40 | 0 + 8×5 |
| 151 | 4.7kΩ 0402 | 4 | 10 | 0 + 2×5 |
| 152 | DIP switch | 6 | 15 | 0 + 3×5 |
| 153 | FDC2114 | 4 | 10 | 0 + 2×5 |
| 154 | RS1-07-G | 2 | 5 | 0 + 1×5 |

All b4 RefDes changes from prior session were verified correct against board Design_Spec.md files:
- C16-C19: confirmed 33pF base resonant caps (Rotor Design_Spec.md line 548) [ok]
- C20A/B: confirmed 100nF bypass for U11A/U11B [ok]
- C21A/B: confirmed 1µF bulk decap for U11A/U11B [ok]
- U11A/U11B: confirmed FDC2114 at I²C addr 0x2B [ok]

---

## Files Changed

- `design/Electronics/Consolidated_BOM.md` — 5 data rows corrected (b4); Notes line 21 reverted to correct 5× rule + 17 System Qty rows recalculated (bom-system-qty-audit)

---

## SQL State

All three todos marked `done`. No blocking todos introduced. Next relevant pending todos:
- `bom-func-notes-sweep` — BOM function notes conformity sweep
- `jdb-standoff-height` — JDB hat-header stacking height review (user-guided)

---

## Constraints Respected

- No MPNs or supplier PNs modified
- No git staging or committing performed
- Footprint Downloaded column data untouched
