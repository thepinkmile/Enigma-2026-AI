# Checkpoint 122 — 435F12012IET footprint created; AC72ABD corrected; BOM updated

## What was accomplished

1. **435F12012IET footprint created (unofficial)**
   - `src/Electronics/Library/SamacSys_Parts.pretty/435F12012IET.kicad_mod` created
   - Adapted from KiCAD 10.0 standard `Crystal_SMD_5032-4Pin_5.0x3.2mm.kicad_mod`
   - 4 roundrect SMD pads (1.6×1.3mm at ±1.65, ±1.0mm), F.CrtYd ±3.0×±2.1mm
   - 3D model: bare relative path `"435F12012IET.step"` (matches 3034TR convention)

2. **3D model copied**
   - Source: `C:\Program Files\KiCad\10.0\share\kicad\3dmodels\Crystal.3dshapes\Crystal_SMD_5032-2Pin_5.0x3.2mm.step` (151,989 bytes)
   - Destination: `src/Electronics/Library/3D_Models/435F12012IET.step`
   - Note: 2-pin variant used as approximation — body dimensions are identical to 4-pin 5032

3. **435F12012IET package correction**
   - CTS 435 datasheet confirms: 5.0×3.2×1.1mm = SMD-5032 (NOT SMD-3225 as previously documented)
   - The `F` in `435F` in the CTS part number designates the 5032 package
   - Corrected in `design/Electronics/Consolidated_BOM.md` line 115: "SMD-3225" → "SMD-5032"; `No | No` → `Yes* | Yes*`
   - Corrected in `design/Electronics/JTAG_Daughterboard/Design_Spec.md` line 229: same corrections

4. **AC72ABD status corrected**
   - Bourns AC72ABD is a battery-pack thermal cutoff — spot/laser-welded to battery cell tabs
   - Bourns datasheet explicitly prohibits PCB soldering (reflow, flow, or hand)
   - Corrected in `design/Electronics/Consolidated_BOM.md` line 44: `No | Requested` → `No | N/A`
   - Corrected in `design/Electronics/Power_Module/Design_Spec.md` line 511: `Yes | Pending` → `No | N/A`

5. **Legacy `.mod` file NOT updated** — following 3034TR precedent (unofficial footprints skip legacy format)

## Files modified

- `src/Electronics/Library/SamacSys_Parts.pretty/435F12012IET.kicad_mod` (CREATED)
- `src/Electronics/Library/3D_Models/435F12012IET.step` (CREATED — copied from KiCAD standard)
- `design/Electronics/Consolidated_BOM.md` (lines 44, 115)
- `design/Electronics/JTAG_Daughterboard/Design_Spec.md` (line 229)
- `design/Electronics/Power_Module/Design_Spec.md` (line 511)

## Lint status

- `design/Electronics/Consolidated_BOM.md` — clean
- `design/Electronics/JTAG_Daughterboard/Design_Spec.md` — clean
- `design/Electronics/Power_Module/Design_Spec.md` — pre-existing MD058 error at line 137 (unrelated to this session's changes)

## Remaining footprint candidates

- `435F12012IET` — **DONE** (Yes* | Yes*)
- `AC72ABD` — **N/A** (weld-attach only, no PCB footprint possible)
- `2BHR-30-VUA` — intentionally left as `No | Pending` (double-keyed shield; generic IDC wrong; user to revisit at schematic capture)
- `3034TR` — **DONE** (Yes* | Yes*) — completed prior session

## Key technical details

- CTS 435F 5032 pad layout: 4 pads at (-1.65,+1), (+1.65,+1), (+1.65,-1), (-1.65,-1); size 1.6×1.3mm roundrect (rratio 0.192308)
- Yes* notation: unofficial/adapted footprints — not manufacturer-supplied
- Commit not performed — awaiting user "Let's lock this in"
