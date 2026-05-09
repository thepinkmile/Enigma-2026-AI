# Checkpoint 132 — BOM Reorder Complete; Temp Cleanup Done

## Overview

Completed the housekeeping pass begun in checkpoint 131. The Controller Design Spec BOM was corrupted by a failed PowerShell edit script (rows prepended to top of file via index `-1` bug); the file was repaired and C20, L1, Q1, Q2 are now in correct alphabetical positions. Consolidated BOM CTL section reordered to L1 → MH13-MH16 → T1. `C0805C223K2RACAUTO` temp files cleaned up. All outstanding items from the BOM/library housekeeping phase are now complete.

## Work Done

### Critical Fix — Design_Spec.md corruption repaired
- Root cause: prior script used `-SimpleMatch` flag with `^` anchor characters, so `Select-String` found no match, returning `$null`. `$null - 1 = -1` in PowerShell; `$lines[0..-1]` returns first+last elements only, not the whole array. The three BOM rows (C20, Q1, Q2, L1) were extracted from their end-of-file positions but then re-inserted before the true file start, creating 4 interleaved copies of the header and placing BOM rows at lines 2–9 of the file.
- Fix: extracted the 4 misplaced BOM rows from lines 2, 3, 6, 9 of the corrupted file; identified that clean file body starts at line index 10; used `for` loop with `-like` patterns to find insertion points; inserted C20 after C17, L1 after J14-J15, Q1+Q2 after MH5-MH8/MH9-MH12.
- Verified: 570-line file, first line = real header, C17=L525, C20=L526, D1=L527, J14-J15=L536, L1=L537, MH13-MH16=L538, MH5-MH8+MH9-MH12=L539, Q1=L540, Q2=L541, R1-R3=L542.

### Consolidated_BOM.md CTL section reordering
- Before: MH13-MH16 (line 102), T1 (103), L1 (104) — wrong order
- After: L1 (102), MH13-MH16 (103), T1 (104) — correct alphabetical order
- Fix: three-way rotate using direct index assignment (no Select-String).

### C0805C223K2RACAUTO temp cleanup
- `src/Electronics/Library/temp/_extract/C0805C223K2RACAUTO/` — deleted (entire extract tree removed)
- `src/Electronics/Library/temp/LIB_C0805C223K2RACAUTO.zip` — moved to `.recycle-bin/`
- `src/Electronics/Library/3D_Models/C0805C223K2RACAUTO.stp` — copied from extract before deletion
- `src/Electronics/Library/temp/` — now empty

## Files Modified

| File | Change |
|------|--------|
| `design/Electronics/Controller/Design_Spec.md` | Corruption repaired; C20, L1, Q1, Q2 inserted at correct alphabetical BOM positions |
| `design/Electronics/Consolidated_BOM.md` | CTL rows reordered: L1 before MH13-MH16, MH13-MH16 before T1 |
| `src/Electronics/Library/3D_Models/C0805C223K2RACAUTO.stp` | Created (copied from SamacSys extract) |

## Files Deleted / Recycled

| File | Action |
|------|--------|
| `src/Electronics/Library/temp/LIB_C0805C223K2RACAUTO.zip` | Moved to `.recycle-bin/` |
| `src/Electronics/Library/temp/_extract/C0805C223K2RACAUTO/` (entire tree) | Removed |

## Outstanding Items

- `750318938` (Würth 750318938 transformer) — no SamacSys symbol data, placeholder deferred. KiCAD library symbol creation request submitted.
- Known malformed `.kicad_sym` entries: `B82806D0060A120` and `PA4343.333NLT` have content appearing before their `(symbol "...")` headers near end of file (~lines 30047, 30115). KiCAD loads them tolerantly; deferred.
- Review pass 8 is the next active work item.
- `review-pass-9` and `review-pass-10` todos added to todo-list for future clean passes.
