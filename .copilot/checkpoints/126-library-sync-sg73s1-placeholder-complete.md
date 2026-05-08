# Checkpoint 126 — Library sync and SG73S1ERTTP4702D placeholder complete

## Summary

Two outstanding BOM footprint tasks completed:

1. **`SG73S1ERTTP4702D` 0402 placeholder** — generic `Resistor_SMD:R_0402_1005Metric` DEF
   added to `SamacSys_Parts.lib`; official footprint request submitted to supplier.
2. **Library sync** — `sym_sync_lib_to_kicad_sym.py` created and executed; 9 symbols
   previously missing from `SamacSys_Parts.kicad_sym` (KiCAD 7+ format) extracted via
   `kicad-cli sym upgrade` and appended; both files now at **96 symbols**.
3. **BOM updated** — line 121 `SG73S1ERTTP4702D` changed from `No | Requested` → `Yes* | Yes*`
   with placeholder note.
4. **`.kicad_sym.bak` removed** — script artifact; git history covers rollback.

## Files Changed

- `src/Electronics/Library/SamacSys_Parts.lib` — `SG73S1ERTTP4702D` DEF added; 96 symbols
- `src/Electronics/Library/SamacSys_Parts.kicad_sym` — 9 symbols synced in; 96 symbols; `.bak` deleted
- `src/Electronics/Library/SamacSys_Parts.dcm` — updated alongside `.lib`
- `src/Electronics/Library/SamacSys_Parts.mod` — updated alongside `.lib`
- `src/Electronics/Library/3D_Models/` — `1285-ST.step/.wrl`, `CGA6P3X7R1H475K250AD.step/.wrl` added
- `design/Electronics/Consolidated_BOM.md` — line 121 `Yes* | Yes*` with placeholder note
- `.copilot/agent-scripts/sym_sync_lib_to_kicad_sym.py` — **NEW** sync script
- `.copilot/todo-list.md` — status updates from previous work in this session
- `design/Guides/Classroom_Guide.md` — **NEW** ESD classroom guidance placeholder (DA-02)
- `design/Mechanical/Complete_System_Assembly/Design_Spec.md` — assembly connectors rows updated
- `design/Standards/Certification_Evidence.md` — updated in session

## Todo Status

- `footprint-requests-pending` → **done**

## Technical Notes

- `kicad-cli sym upgrade INPUT.lib -o OUTPUT.kicad_sym` at KiCAD 9.0.7
  (`C:\Program Files\KiCad\9.0\bin\kicad-cli.exe`)
- `SG73S1ERTTP4702D`: ROHM SG73 47kΩ ±0.5% AEC-Q200 0402; DigiKey `2019-SG73S1ERTTP4702DTR-ND`;
  Mouser `660-SG73S1ERTTP4702D`; uses `Yes*` convention (unofficial placeholder)
- 9 symbols synced: `1285-ST`, `200MSP1T2B4M2QE`, `C0402C103K1RACAUTO`,
  `C0402C330J5GACAUTO`, `CGA6P3X7R1H475K250AD`, `ERJ-3EKF1000V`, `ERJ-3EKF1500V`,
  `SG73S1ERTTP4702D`, `WP154A4SEJ3VBDZGW_CA`
