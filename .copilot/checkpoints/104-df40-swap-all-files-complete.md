# Checkpoint 180 — DF40 swap all files complete

**Status:** Complete — awaiting "Let's lock this in" before committing

## What was done

Replaced Samtec ERM8-005/ERF8-005 AM board-to-board connectors with Hirose DF40 20-pin
3.5mm stacking-height connectors across all affected design files. All seven files updated,
linted, and clean.

### Motivation

ERM8/ERF8 minimum stacking height (~7mm) is incompatible with DR-AM-11's 2.0mm max component
height requirement (minimum gap ~2.4–2.5mm after margin). DF40 3.5mm stack provides 1.5mm
clearance above 2.0mm components — within spec.

### Approved part numbers (PRIMARY DIRECTIVE — do not modify)

| Part | Role | MPN | DigiKey | Mouser | JLCPCB |
|---|---|---|---|---|---|
| DF40HC(3.5)-20DS-0.4V(51) | Receptacle (EXT J9, CTL J11) | same | `26-DF40HC(3.5)-20DS-0.4V(51)CT-ND` | `798-DF40HC3520DS04V5` | `C3644774` |
| DF40C-20DP-0.4V(51) | Plug (AM J1) | same | `H11618CT-ND` | `798-DF40C20DP0.4V51` | `C424637` |
| 9774035151R | Standoff M2.5×3.5mm SMT | same | `732-9774035151RCT-ND` | `710-9774035151R` | `C22367582` |

### Pin allocation — AM J1 (20 pins)

- Pins 1,3,5,7,9: `5V_MAIN` (1.5A available; 5× 0.3A rated = 1.5A)
- Pins 2,4,6,8,10: `GND` (servo power return)
- Pins 11,13: `3V3_ENIG` (0.6A available; 2× 0.3A rated)
- Pins 12,14: `GND` (logic return)
- Pin 15: `ACTUATE_REQUEST_N` (active-low; idle-HIGH via STM32 internal pull-up)
- Pins 16–20: `GND` (signal return / guard)

### Connector designator changes

- AM: J1 only (J2 retired; DR-AM-03 repurposed for MH1–MH4 mounting holes)
- EXT: J9 only (J10 retired; DR-EXT-10 retired stub added)
- CTL: J11 only (J16 retired; DR-CTL-13 retired stub added)
- **Rotor connectors NOT changed** (ERM8/ERF8 on EXT J1–J6, ROT, REF, STA unchanged)

### Standoffs

- EXT: MH5–MH8 (4× 9774035151R) — AM mounting on Extension
- CTL: MH5–MH8 (4× 9774035151R) — AM mounting on Controller
- AM: MH1–MH4 (NPTH M2.5mm) — defined in DR-AM-03
- Asymmetric placement (non-square pattern) mandatory to enforce DF40 mating orientation
  (DF40 body is polarity-free per Note 4 in Hirose datasheet)

## Files changed

| File | Status |
|---|---|
| `design/Electronics/Actuation_Module/Design_Spec.md` | ✅ Complete |
| `design/Electronics/Actuation_Module/Board_Layout.md` | ✅ Complete |
| `design/Electronics/Extension/Design_Spec.md` | ✅ Complete |
| `design/Electronics/Extension/Board_Layout.md` | ✅ Complete |
| `design/Electronics/Controller/Design_Spec.md` | ✅ Complete |
| `design/Electronics/Controller/Board_Layout.md` | ✅ Complete |
| `design/Electronics/Consolidated_BOM.md` | ✅ Complete |

All 7 files linted clean (exit code 0).

## Key design decisions / notes

- DF40 plug body height ~1.14mm above AM PCB — within DR-AM-11 2.0mm component limit ✓
- Same standoff series (WA-SMSI) as CM5's 9774040151R (4.0mm); same footprint, different height
- Consolidated BOM: ERF8-005 qty 12→8 (CTL and 2× EXT removed); ERM8-005 qty 10→8 (AM J1/J2 removed);
  3 new rows added (DF40HC receptacle, DF40C plug, 9774035151R standoffs)
- Hirose footprints already downloaded by user into KiCAD Library
- Standoff footprints requested by user at end of session
