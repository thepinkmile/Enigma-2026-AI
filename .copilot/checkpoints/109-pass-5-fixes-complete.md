# Checkpoint 027 — Pass 5 Fixes Complete

**Status:** Pass 5 fixes fully implemented (12/13 findings fixed; F-108 deferred/blocks Pass 6)
**Awaiting:** User "Let's lock this in" before git commit

---

## What Was Done This Session

All Pass 5 review findings (F-98 through F-110) actioned per user morning instructions.

### F-98 — PWR_BUT → PWR_BUT_N ✔
- Renamed across 7 files (48 total occurrences)
- `Controller/Design_Spec.md` §6 scope note updated; CM5 Dedicated HW Pin table row added
- `Design_Log.md` DEC-054 appended (append-only; no existing entries modified)

### F-99 — USB_FAULT → USB_FAULT_N ✔
- 4 occurrences in `Controller/Design_Spec.md` (lines 62, 118, 212, 234) renamed

### F-100 — CTL MH1–MH4 BOM Notes ✔
- `Controller/Design_Spec.md` BOM MH1–MH4 Notes: "CM5 module mounting standoffs; pads tied to GND (not GND_CHASSIS)"

### F-101 — Stator DR-STA-17 + §12 ✔
- DR-STA-17 added to `Stator/Design_Spec.md`
- §12 Mounting Holes added to `Stator/Board_Layout.md`

### F-102/F-103 — Rotor Mounting Holes + GND_CHASSIS ✔
- DR-ROT-08 updated: 4 holes at inscribed-square corners ±32.5mm on Ø92mm board
- §9 Mounting Holes added to `Rotor/Board_Layout.md` (all 4 subsections including GND_CHASSIS bond)

### F-104 — Rotor CPLD/FDC2114 Bypass Cap Attribution ✔
- `Rotor/Design_Spec.md` BOM Notes updated for C1–C8,C14 / C9–C13 / C15 rows
- GRS §3.2 cited in all Notes

### F-105/F-106/F-107 — Variant Bypass Cap Notes ✔
- `Rotor_64_Char_Design.md` C16B/C17B Notes added (U3B FDC2114 0x2B; GRS §3.2)
- `Rotor_26_Char_Design.md` C16A/C17A Notes added (U3A FDC2114 0x2B; GRS §3.2)

### F-108 — DR-EXT-10 Gap ⏸ DEFERRED
- Explicitly blocked in SQL (`p5-f108-deferred`, status = blocked)
- **Blocks Pass 6 launch** until user decision on DR-EXT-10 and RefDes review session

### F-109 — Pin-1 Silkscreen Arrow (GRS Global Rule) ✔
- GRS §7.1 "Connector Pin-1 Identification" added (global rule; all J-prefix RefDes)
- Per-board notes in CTL/DS, CTL/BL, AM/DS, AM/BL updated to reference §7.1
- Extension/Board_Layout.md J9 callout added
- All other boards covered by global rule without per-board duplication

### F-110 — USM §10 Mounting Holes ✔
- `User_Settings_Module/Board_Layout.md` §10 added (4× M3 PTH, GND_CHASSIS, TBD at layout)

### Production Folder ✔ (user request, not a review finding)
- `design/Production/JLCPCB_Manufacturing.md` created
  - §1: Board stackups (JLC04161H-7628 4-layer; JLC06161H-2116 6-layer CTL only)
  - §2: PCB fabrication capabilities table
  - §2.1: Via constraints (no blind/buried/micro on standard service)
  - §3: PCBA constraints (single-sided SMT; THT manual-fit; library types; MOQ)
  - §4: Cross-references back to GRS and all board specs
- GRS §2 cross-reference to Production doc added

---

## Review-Report Status

`.copilot/review-report.md` Pass 5 Fix Status table appended:
- F-98 through F-107, F-109, F-110: ✔ Fixed
- F-108: ⏸ Deferred (blocks Pass 6)

---

## Files Modified This Session

| File | Change |
| :--- | :--- |
| `design/Electronics/Controller/Design_Spec.md` | F-98 (4×), F-99 (4×), F-100 (MH Notes) |
| `design/Electronics/Controller/Board_Layout.md` | F-98 (1×) |
| `design/Electronics/Power_Module/Design_Spec.md` | F-98 (22×) |
| `design/Electronics/Power_Module/Board_Layout.md` | F-98 (3×) |
| `design/Electronics/System_Architecture.md` | F-98 (2×) |
| `design/Software/Linux_OS/Power_Management.md` | F-98 (9×) |
| `design/Datasheets/RPi-cm5-datasheet.md` | F-98 (7×) |
| `design/Design_Log.md` | DEC-054 appended |
| `design/Electronics/Stator/Design_Spec.md` | F-101: DR-STA-17 added |
| `design/Electronics/Stator/Board_Layout.md` | F-101: §12 added |
| `design/Electronics/Rotor/Design_Spec.md` | F-102: DR-ROT-08 updated; F-104: BOM Notes |
| `design/Electronics/Rotor/Board_Layout.md` | F-102/F-103: §9 added |
| `design/Electronics/Rotor/Rotor_64_Char_Design.md` | F-105/F-107: C16B/C17B Notes |
| `design/Electronics/Rotor/Rotor_26_Char_Design.md` | F-106/F-107: C16A/C17A Notes |
| `design/Electronics/User_Settings_Module/Board_Layout.md` | F-110: §10 added |
| `design/Standards/Global_Routing_Spec.md` | F-109: §7.1 added; Production cross-ref added |
| `design/Electronics/Actuation_Module/Design_Spec.md` | F-109: J1 pin-1 note updated |
| `design/Electronics/Actuation_Module/Board_Layout.md` | F-109: J1 note updated |
| `design/Electronics/Extension/Board_Layout.md` | F-109: J9 callout added |
| `design/Production/JLCPCB_Manufacturing.md` | **New file** — JLCPCB manufacturing constraints |
| `.copilot/review-report.md` | Pass 5 Fix Status table appended |

---

## Next Steps

1. **User confirms "Let's lock this in"** → git commit all changes
2. **F-108 + RefDes review session** → unblock Pass 6
3. **Pass 6 launch** (blocked until F-108 resolved)

---

## Standing Rules (Reminder)

- PRIMARY DIRECTIVE: Never modify any MPN or supplier part number without explicit user confirmation
- SECONDARY DIRECTIVE: Never commit without "Let's lock this in" or "Save state" from user
- Design_Log.md is append-only
- F-108 is blocked — do not implement
