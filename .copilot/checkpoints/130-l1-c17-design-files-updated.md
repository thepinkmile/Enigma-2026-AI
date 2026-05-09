# Checkpoint 030 — L1 & C17 Design Files Updated

**Date:** 2026-05-09
**Session:** e39f3cc4
**Status:** Complete

## What Was Done

All design files updated with confirmed L1 (Yageo PA4343.333NLT) and C17 (Kemet C0805C223K2RACAUTO) selections following SENARY approval.

### Files Modified

#### `design/Electronics/Controller/Design_Spec.md`
- Last Updated: 2025-07-10 → 2026-05-09
- DR-CTL-18: Updated C17 package/voltage from `100V 0402` → `200V 0805`; added DC bias derating rationale; added reference to DEC-064
- DR-CTL-25: Replaced "Part selection pending" with Yageo PA4343.333NLT full spec and supplier PNs; added DCR procurement-constrained exception note; added reference to DEC-063
- BOM C17 row: `TBD` → `C0805C223K2RACAUTO | Kemet | 399-17630-1-ND | 80-C0805C223K2RAUTO | C3843023`; spec updated to `22nF 200V X7R 0805`
- BOM L1 row: `TBD` → `PA4343.333NLT | Yageo | 553-3457-1-ND | 673-PA4343.333NLT | C2453886`; DCR exception note added
- BOM Notes footer: Updated "TBD MPN / part selection pending" → confirmed selections with DEC references

#### `design/Electronics/Consolidated_BOM.md`
- Last Updated: 2026-05-08 → 2026-05-09
- CTL: C17 row: `C0402C103K1RACAUTO` (10nF 100V 0402) → `C0805C223K2RACAUTO` (22nF 200V 0805) with full supplier PNs
- CTL: L1 row: `TBD` → `PA4343.333NLT` with full supplier PNs and DCR exception note

#### `design/Design_Log.md`
- Last Updated: 2026-05-07 → 2026-05-09
- Appended DEC-063: L1 selection — Yageo PA4343.333NLT; three-candidate evaluation; Würth/Bourns eliminated; DCR exception documented
- Appended DEC-064: C17 final selection — Kemet C0805C223K2RACAUTO (22nF 200V X7R 0805); DC bias derating rationale; package/voltage upgrade from 0402/100V

## Confirmed Supplier PNs

| RefDes | MPN | DigiKey | Mouser | JLCPCB |
|---|---|---|---|---|
| T1 | TDK B82806D0060A120 | 495-76653-1-ND | 871-B82806D0060A120 | C7218686 |
| Q1, Q2 | STD25NF20 | 497-13749-1-ND | 511-STD25NF20 | C388326 |
| L1 | Yageo PA4343.333NLT | 553-3457-1-ND | 673-PA4343.333NLT | C2453886 |
| C17 | Kemet C0805C223K2RACAUTO | 399-17630-1-ND | 80-C0805C223K2RAUTO | C3843023 |

## Outstanding Items

- L1 KiCAD footprint: User has zip in temp folder — extract and add to KiCAD library at schematic capture stage
- DR-CTL-25 DCR exception: retained at ≤50mΩ; Yageo max 58mΩ documented as procurement-constrained exception
- CTL PoE T1 review (ctl-t1-wurth-datasheet-review todo) — completed earlier in session history
- Next phase: schematic capture for CTL PoE power stage
