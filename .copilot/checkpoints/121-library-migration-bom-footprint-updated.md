# Checkpoint 121 — Library migration complete; BOM footprint status updated

## Overview

KiCAD 4 → KiCAD 6 legacy library migration completed (prior session) and all
BOM "Footprint Downloaded" status fields updated across Consolidated_BOM.md
and all 10 board-level Design_Spec.md files.

## Work Done

### Library migration (completed prior session, verified this session)

- `src/Electronics/Library/SamacSys_Parts.kicad_sym` — 16 new symbols appended
  (KiCAD 6 format); file integrity confirmed (27,761 lines, structurally valid)
- `src/Electronics/Library/SamacSys_Parts.pretty/` — 15 new `.kicad_mod` files
  added; spot-checked B3F1060 (THT) and CAPC2012X145N (SMD) — both correct

### BOM footprint status updates

Updated `Footprint Downloaded` column from `Pending` → `Yes` for 16 components:

| MPN | Board(s) |
|---|---|
| `1211` | PM |
| `CL21B106KAYQNNE` | CTL, PM, USM, AM, STA, EXT, ROT, ENC, REF |
| `1-1674231-1` | CTL |
| `2195630015` | CTL |
| `48406-0003` | CTL |
| `2007435-1` | CTL |
| `F52Q-1A7H1-11015` | CTL |
| `SM04B-SRSS-TB(LF)(SN)` | CTL |
| `ERF8-005-05.0-S-DV-K-TR` | STA, EXT, ROT |
| `RS1-05-G` | ROT |
| `10164227-1004A1RLF` | CTL |
| `POE600F-12L` | CTL |
| `PH1-05-UA` | AM, ROT |
| `ERJ-2RKF33R0X` | JDB |
| `B6B-PH-K-S(LF)(SN)` | USM, STA |
| `B3F-1070` | USM, AM |

Files updated:
- `design/Electronics/Consolidated_BOM.md` — 16 rows
- `design/Electronics/Controller/Design_Spec.md` — 9 rows
- `design/Electronics/Power_Module/Design_Spec.md` — 2 rows
- `design/Electronics/User_Settings_Module/Design_Spec.md` — 3 rows
- `design/Electronics/Actuation_Module/Design_Spec.md` — 3 rows
- `design/Electronics/Stator/Design_Spec.md` — 3 rows
- `design/Electronics/Extension/Design_Spec.md` — 2 rows
- `design/Electronics/Rotor/Design_Spec.md` — 4 rows
- `design/Electronics/Encoder/Design_Spec.md` — 1 row
- `design/Electronics/Reflector/Design_Spec.md` — 1 row
- `design/Electronics/JTAG_Daughterboard/Design_Spec.md` — 1 row

### Rows intentionally NOT changed (per prior user direction)

| MPN | Row | Reason |
|---|---|---|
| `3034TR` | BOM line 89 | Custom footprint creation submitted; no manufacturer footprint |
| `9774040151R` | BOM line 102 | Generic mounting hole; user to confirm footprint approach |
| `435F12012IET` | BOM line 115 | Custom footprint creation submitted |
| `2BHR-30-VUA` | BOM line 129 | Double-keyed shield; generic IDC footprint incorrect |

## Technical Notes

- `SM04B-SRSS-TB(LFSN).kicad_mod` — parentheses in filename valid on Windows
  NTFS; may need renaming for Linux KiCAD on CM5; raise when doing schematic
  capture
- `10164227-1004A1RLF` (100-pin SODIMM) — not yet visually verified in KiCAD;
  complex multi-pin symbols most likely to have conversion artefacts

## Open Question

`SM04B-SRSS-TB(LFSN).kicad_mod` filename parentheses — may need renaming to
`SM04B-SRSS-TB_LFSN_.kicad_mod` for Linux KiCAD on CM5. Raise at schematic
capture stage.

## Next Steps

Remaining Pass 5 work (tracked in plan.md):
- F-98: PWR_BUT_N signal rename
- F-99: USB_FAULT_N signal rename
- F-100: MH1-MH4 notes update (CTL)
- F-101: Stator mounting holes
- F-102/103: Rotor mounting holes
- F-104: Rotor bypass cap BOM notes
- F-105/106/107: Rotor variant BOM notes
- F-108: Deferred (BLOCKED)
- F-109: Silkscreen rule review
- F-110: USM mounting holes
- Production folder creation
