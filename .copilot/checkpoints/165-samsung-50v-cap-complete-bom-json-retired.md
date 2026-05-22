# Checkpoint 165 — Samsung 50V cap complete; all_boards_bom.json retired; DEC-082/083; KiCAD import

**Date:** 2026-05-21  
**Session:** a2e511b4-0b5c-4db6-9142-dfa87ed93cc4

---

## Overview

Session continued Pass-10 findings resolution (EXT complete 9/9, STA complete 3/3, AM 2/3 resolved)
then branched into a significant side-task: standardising all 10µF bulk reservoir capacitors from
Samsung CL21B106KAYQNNE (25V 0805) to Samsung CL31B106KBK6PJE (50V 1206 AEC-Q200) across all 87
placements on 11 boards. DEC-082 formally records that decision. DEC-083 retires
`all_boards_bom.json` and formalises the BOM authority hierarchy. A full KiCAD library import was
completed for CL31B106KBK6PJE in all 4 formats. `todo-list.md` synced.

---

## Work Done

### Pass-10 findings resolved this session

| Finding | Sev | Board | Resolution |
|---------|-----|-------|------------|
| EXT-P10-05 | MED | EXT | FR-EXT-06 updated — ACTUATE_REQUEST_N sources documented |
| EXT-P10-06 | LOW | EXT | Closed stale — "see DEC-046" is design rationale, not procurement |
| EXT-P10-07 | LOW | EXT | Closed stale — full paths already present |
| EXT-P10-08 | LOW | EXT | Closed stale — GRS §5 cross-reference already present |
| EXT-P10-09 | LOW | EXT | Invalid — PRIMARY DIRECTIVE: Samtec DigiKey PNs pre-approved |
| STA-P10-02 | LOW | STA | Closed stale — CPLD power-rail table already present in §3 |
| STA-P10-03 | LOW | STA | Closed stale — bypass cap count table already in §3 |
| AM-P10-01 | LOW | AM | DR-AM-17 updated: STM32G071 PA14 pull-down confirmed (datasheet footnote 6) |
| AM-P10-02 | INFO | AM | C4/C5 BOM Notes "see DEC-046" removed (design rationale, not procurement) |

### Remaining open Pass-10 findings

| Finding | Sev | Board | Status |
|---------|-----|-------|--------|
| AM-P10-03 | LOW | AM | J2–J5 pin-1 marker callout absent in Board_Layout — **next up** |
| USM-P10-06 | LOW | USM | DEC-072 says "DPDT" — correct = SPDT; needs new DEC-084 |
| USM-P10-08 | LOW | USM | GRS §7.1 pin-1 marker compliance not confirmed |
| USM-P10-09 | LOW | USM | GRS §6 data plate not mentioned in Board_Layout |
| JM-P10-04 | LOW | JM | UART power-on contention window undocumented |
| JM-P10-05 | LOW | JM | "400mA peak" 5V_USB figure ≈4× actual — no derivation footnote |

### Samsung CL31B106KBK6PJE — 50V bulk cap standardisation (DEC-082)

- **87 placements** across 11 boards upgraded: PM (11), CTL (10), USM (10), ENC (5), AM (1),
  STA (10), REF (5), EXT (10), ROT-26 (5), ROT-64 (5) + 11 PM-20 = 87 total
- Supplier PNs confirmed and propagated everywhere:
  - DigiKey: `1276-CL31B106KBK6PJECT-ND`
  - Mouser: `187-CL31B106KBK6PJE`
  - JLCPCB: `C43935922`
- **DR-PM-17/DR-PM-18** derating updated: 5× → 10× (5V_MAIN) and 7.6× → 15.2× (3V3_ENIG)
- **GRS §3.2** Bulk Entry Bank Rule updated to 50V 1206, new derating figures
- **Consolidated_BOM.md** row updated, footprint → ✔
- All 11 board Design_Spec.md BOM tables updated
- Markdown datasheet created: `design/Datasheets/Samsung-CL31B106KBK6PJ-datasheet.md`

### KiCAD library import — CL31B106KBK6PJE / CAPC3216X190N

All 4 formats synced from `src/Electronics/Library/temp/LIB_CL31B106KBK6PJE.zip`:

| Target | Change |
|--------|--------|
| `SamacSys_Parts.kicad_sym` | Symbol appended |
| `SamacSys_Parts.lib` / `.dcm` | Legacy symbol + doc appended |
| `SamacSys_Parts.pretty/CAPC3216X190N.kicad_mod` | Footprint copied |
| `SamacSys_Parts.mod` | `CAPC3216X190N` added to `$INDEX` + `$MODULE` block appended |
| `3D_Models/CL31B106KBK6PJE.stp` | 3D model copied |
| `SamacSys_Parts.3dshapes/CL31B106KBK6PJE.stp` | 3D model copied |

### all_boards_bom.json retired (DEC-083)

Full audit found 43 missing entries, ~60 RefDes mismatches, 11 wrong MPNs — file was never
actively used and had diverged significantly from board specs. Moved to `.recycle-bin/`.
`agent-directives.md` BOM Authority Rules updated. `bom_audit_report.md` (working material) also
moved to `.recycle-bin/`. DEC-083 formalises the authority hierarchy:
- **System BOM:** `design/Electronics/Consolidated_BOM.md`
- **Board BOM:** individual `Design_Spec.md` BOM tables

### Design decisions appended

| DEC | Title |
|-----|-------|
| DEC-082 | 10µF Bulk Reservoir Capacitor Upgrade: 25V 0805 → 50V 1206, All Boards |
| DEC-083 | Retire `all_boards_bom.json`; Consolidate BOM Authority in Design_Spec Files and Consolidated_BOM |

Next DEC = **DEC-084**

### Todo sync

- `download-missing-3d-models` → **done** (summary table was correct; SQL INSERT was stale)
- `tps25751-i2c-review` SQL INSERT corrected from `blocked` → `done` (already done per Option C implementation)
- `todo-list.md` Last updated → 2026-05-21

---

## Files Modified

| File | Change |
|------|--------|
| `design/Design_Log.md` | DEC-082 and DEC-083 appended |
| `design/Datasheets/Samsung-CL31B106KBK6PJ-datasheet.md` | Created (39-page PDF → markdown) |
| `design/Electronics/Consolidated_BOM.md` | Row 97: MPN, supplier PNs, footprint ✔ |
| `design/Standards/Global_Routing_Spec.md` | §3.2 updated: 50V 1206, new derating, supplier PNs |
| `design/Electronics/Power_Module/Design_Spec.md` | DR-PM-17/18; C20, C68-C72, C73-C77 BOM rows; §5.3/§8 prose; FR-EXT fix N/A |
| `design/Electronics/Controller/Design_Spec.md` | BOM row |
| `design/Electronics/User_Settings_Module/Design_Spec.md` | BOM row + prose |
| `design/Electronics/Encoder/Design_Spec.md` | BOM row |
| `design/Electronics/Actuation_Module/Design_Spec.md` | DR-AM-17, §3.7; BOM C4/C5 Notes; BOM C5 supplier PNs |
| `design/Electronics/Stator/Design_Spec.md` | BOM row |
| `design/Electronics/Reflector/Design_Spec.md` | BOM row |
| `design/Electronics/Extension/Design_Spec.md` | BOM row; FR-EXT-06 updated |
| `design/Electronics/Rotor/Design_Spec.md` | BOM row |
| `src/Electronics/Library/SamacSys_Parts.kicad_sym` | CL31B106KBK6PJE symbol appended |
| `src/Electronics/Library/SamacSys_Parts.lib` | CL31B106KBK6PJE legacy symbol appended |
| `src/Electronics/Library/SamacSys_Parts.dcm` | CL31B106KBK6PJE legacy doc appended |
| `src/Electronics/Library/SamacSys_Parts.mod` | CAPC3216X190N in `$INDEX` + `$MODULE` |
| `src/Electronics/Library/SamacSys_Parts.pretty/CAPC3216X190N.kicad_mod` | Created |
| `src/Electronics/Library/3D_Models/CL31B106KBK6PJE.stp` | Created |
| `src/Electronics/Library/SamacSys_Parts.3dshapes/CL31B106KBK6PJE.stp` | Created |
| `.copilot/agent-directives.md` | BOM Authority Rules updated (JSON retired) |
| `.copilot/todo-list.md` | `download-missing-3d-models` and `tps25751-i2c-review` INSERT corrected; Last updated → 2026-05-21 |

## Files Retired (→ .recycle-bin/)

| File | Reason |
|------|--------|
| `design/Electronics/all_boards_bom.json` | Never used; severely out of sync; DEC-083 |
| `.copilot/bom_audit_report.md` | Working material; superseded by DEC-083 summary |

---

## Next Steps

1. **AM-P10-03** — Add GRS §7.1 pin-1 marker callout for J2–J5 in `Actuation_Module/Board_Layout.md`
2. **USM-P10-06** — DEC-072 "DPDT" → "SPDT"; append DEC-084 (new entry — do not amend DEC-072)
3. **USM-P10-08** — Confirm GRS §7.1 pin-1 markers in USM Board_Layout
4. **USM-P10-09** — Add GRS §6 data plate entry to USM Board_Layout
5. **JM-P10-04** — Document UART power-on contention window in JM Design_Spec §6
6. **JM-P10-05** — Add derivation footnote for 5V_USB 80–110mA figure in JM Board_Layout §5
