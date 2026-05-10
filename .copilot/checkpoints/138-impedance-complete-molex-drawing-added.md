# Checkpoint 138 — Impedance Results Complete; Molex Drawing Markdown Added

## Overview

Two workstreams closed this session:

1. **Stackup impedance workstream finalised (analysis phase):** JLCPCB authoritative impedance
   results received and documented for both selected stackups — 4-layer `JLC041621-3313` and
   6-layer `JLC061621-3313`. Via design implications for the CTL 6-layer board analysed and
   documented. All results are in the `.copilot` analysis workspace; no `design/` files have
   been modified yet — those changes await SENARY approval per the list below.

2. **Molex 48406-0003 drawing markdown created:** The dimensional drawing PDF was converted to
   a structured markdown reference (`Molex-48406-0003-drawing.md`) covering pin assignments,
   drill sizes, all extractable dimensions (including decoded rotated text), materials, plating,
   tolerances, referenced specs, and Enigma-NG design notes (tail protrusion on 1.6 mm CTL
   board, via anti-pad guidance). The `_generated_markdown_inventory.json` was updated to
   register the new PDF→markdown mapping.

---

## History

### Authoritative impedance results — 4-layer `JLC041621-3313`

Received from JLCPCB impedance calculator (prior session):

| Target | Type | Layer | Trace width (mm) | Trace width (mil) | Spacing (mm) | Spacing (mil) |
|---|---|---|---|---|---|---|
| 50 Ω SE | Microstrip | L1 | 0.1425 | 5.61 | — | — |
| 50 Ω SE | Stripline | L2 | 0.1478 | 5.82 | — | — |
| 90 Ω diff | Diff microstrip | L1 | 0.1468 | 5.78 | 0.2032 | 8.00 |
| 100 Ω diff | Diff stripline | L2 | 0.1128 | 4.44 | 0.2032 | 8.00 |

### Authoritative impedance results — 6-layer `JLC061621-3313`

Received from JLCPCB impedance calculator (this session):

| Target | Type | Layer | Trace width (mm) | Trace width (mil) | Spacing (mm) | Spacing (mil) |
|---|---|---|---|---|---|---|
| 50 Ω SE | Microstrip | L1 | 0.1425 | 5.61 | — | — |
| 50 Ω SE | Stripline | L2 | 0.1387 | 5.46 | — | — |
| 90 Ω diff | Diff microstrip | L1 | 0.1468 | 5.78 | 0.2032 | 8.00 |
| 100 Ω diff | Diff stripline | L2 | 0.1123 | 4.42 | 0.2032 | 8.00 |

Key finding: outer values identical (same 3313 prepreg geometry). Inner 50 Ω narrower on 6-layer
because the thinner 0.45 mm core is more symmetric — closer bottom reference → narrower trace
needed for same impedance.

### Physical stackup — 6-layer `JLC061621-3313`

| Layer | Material | Thickness (mil) | Thickness (mm) |
|---|---|---|---|
| L1 outer | 2oz copper | 2.76 | 0.070 |
| Prepreg L1→L2 | 3313 RC57% | 3.62 | 0.092 |
| L2 inner | 1oz copper | 1.18 | 0.030 |
| Core L2–L3 | 0.45mm core | 17.72 | 0.450 |
| L3 inner | 1oz copper | 1.18 | 0.030 |
| Prepreg L3→L4 | 2×2116 RC54% | 8.58 | 0.218 |
| L4 inner | 1oz copper | 1.18 | 0.030 |
| Core L4–L5 | 0.45mm core | 17.72 | 0.450 |
| L5 inner | 1oz copper | 1.18 | 0.030 |
| Prepreg L5→L6 | 3313 RC57% | 3.62 | 0.092 |
| L6 outer | 2oz copper | 2.76 | 0.070 |

Finished thickness: ~1.6 mm ✅

### Via design analysis — CTL 6-layer

- Stub resonance L2→L6 ≈ 27 GHz — no back-drilling required for GbE / USB SS signals ✅
- CM5 Amphenol connector: via-in-pad, resin-filled and capped (not just tented)
- ESD TVS: must be line-side (before magnetics primary) for PoE++ protection
- Diff pair vias: + and − placed symmetrically
- Anti-pad (clearance in L1 GND pour) around CI signal vias: drill + 0.2–0.3 mm
- PoE++ power path (center taps → rectifier → DC/DC): non-CI, no impedance control needed

### Molex 48406-0003 drawing markdown

`design/Datasheets/Molex-48406-0003-drawing.md` created. Contents:
- 18-pin table with signal names, types, descriptions for both ports
- PCB drill table: 18×⌀0.70 mm pin holes, 2×⌀2.30 mm mounting holes
- Dimensional tables (envelope, footprint, vertical, pitch/spacing) with decoded/verified callouts
- Materials, plating (15 μin Au for -0003 vs 30 μin Au for -0001), tolerances
- CTL design notes: tail protrusion on 1.6 mm board (0.77 mm min vs 0.50 mm IPC floor ✅),
  CI via anti-pad guidance, mounting hole routing exclusion zones

`design/Datasheets/_generated_markdown_inventory.json` updated: new entry for
`Molex-48406-0003-drawing.pdf` → `Molex-48406-0003-drawing.md` (type: same_stem).

---

## Work Done

- [x] Received and parsed 4-layer impedance results (prior session)
- [x] Received and parsed 6-layer impedance results
- [x] Cross-stackup comparison documented in `.copilot/discussions/stackup-impedance-analysis.md` §21–22
- [x] Via design implications analysed and documented in §23
- [x] `Molex-48406-0003-drawing.md` created
- [x] `_generated_markdown_inventory.json` updated

---

## Technical Details

**All values above JLCPCB manufacturing floor (3.5 mil minimum):** ✅
- Narrowest value: 4.42 mil (100 Ω diff stripline, 6L L2) — 26% above floor

**IPC-2141A estimate accuracy (post-calibration note):**
- Outer 50 Ω: IPC estimate −9% low vs actual
- Inner 50 Ω (4L): IPC estimate +13% high vs actual
- Inner 50 Ω (6L): IPC estimate +21% high vs actual
- Calculator values are mandatory — IPC estimates not suitable for spec documents

**Next design log entry:** DEC-062 (stackup selection and CI trace widths)

---

## Important Files

- `.copilot/discussions/stackup-impedance-analysis.md` (~1060 lines) — §21–23 added this session
- `design/Datasheets/Molex-48406-0003-drawing.md` — new; dimensional drawing reference
- `design/Datasheets/_generated_markdown_inventory.json` — updated with drawing entry

---

## Next Steps — Pending SENARY Approval

The following design files are queued for update with authoritative stackup/impedance data.
Each requires separate explicit approval before modification:

1. **`design/Production/JLCPCB_Manufacturing.md`** — full stackup catalogue, layer parameters,
   CI trace tables (both stackups), via design rules
2. **`design/Standards/Global_Routing_Spec.md`** — per-stackup CI trace width rules, layer
   philosophy, via design rules (anti-pad, diff symmetry, VIP spec)
3. **`design/Electronics/Controller/Design_Spec.md`** — 6-layer stackup, layer assignments,
   CTL-specific routing rationale (inner L2/L5 for CI)
4. **All remaining 9 board `Design_Spec.md` files** — 4-layer stackup, layer assignments
5. **`design/Design_Log.md`** — append DEC-062

**Open design question (not blocking):**
- JM/AM layer order convention: confirm GND as bottom layer for carrier-mounted boards;
  document in GRS when approved.

---

## Checkpoint Complete

Git state: clean (no staged changes). All work this session written to disk only.
SECONDARY directive: no commit performed. User to review before locking in.
