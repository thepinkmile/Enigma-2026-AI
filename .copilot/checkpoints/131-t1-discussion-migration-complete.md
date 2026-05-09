# Checkpoint 033 — T1 Discussion Migration Complete

**Date:** 2026-05-09
**Session:** e39f3cc4-9f05-4ca9-9cb1-d2190ef81f9f
**Status:** ✅ Complete

---

## Summary

Completed the full CTL T1 transformer investigation audit and documentation migration. All content
from the discussion file `.copilot/discussions/ctl-t1-poe-transformer-investigation.md` has been
migrated to permanent design documents. The discussion file has been recycled.

---

## Work Done This Checkpoint

### 1. Created `design/Electronics/Controller/PoE_Power_Analysis_Coilcraft_v2.md` (new)

A new deferred reference file containing:
- Prominent DEFERRED header referencing `ctl-t1-coilcraft-v2-review` todo
- Coilcraft POE600F-12L full part details table and procurement table
- Samples note: Ref 153954 received; pre-production; lab testing only; cannot use in v1 production
- Full verbatim migration of original `PoE_Power_Analysis.md` content (§1–§6: Background, Market
  Survey, Option A Coilcraft ACF, Option B Bourns Flyback, Head-to-Head, Original Decision DEC-019)
- Supporting component calculations for n=1.71 design: duty cycle (36/48/57V), VCC, Vds=78.2V,
  C17=47nF (conservative), Cout=100µF minimum
- Conduction loss table: 3.896W total at n=1.71 (vs 0.593W for TDK — 3.3W difference)
- ACF Flyback design reference equations
- Revert checklist — what must change when actioning `ctl-t1-coilcraft-v2-review` (T1 MPN, C17,
  L1 removal, DR-CTL-25 revision, topology label, footprint, Llk verification from Coilcraft)

### 2. Replaced `design/Electronics/Controller/PoE_Power_Analysis.md` (full rewrite)

New content contains TDK B82806D0060A120 ACF Forward analysis:
- Background: ACF Forward vs ACF Flyback distinction, TI PMP23253 reference
- TDK B82806D0060A120 electrical parameters table
- Duty cycle table (36V→40.8%, 48V→34.1%, 57V→30.3%); all within TPS23730 5–75% ✅
- TPS23730 VCC: 11.6V ✅
- Vds stress: 81.8V → 200V class MOSFET ✅
- C17 sizing: 22nF selected (TI PMP23253 reference design; empirical optimisation)
- L1 requirement (ACF Forward topology); ripple 21.5% at 36V ✅
- C20 sizing: 85µF minimum → 4× TDK 47µF = 188µF ✅
- Conduction losses: 0.593W (0.99% of 60W) — primary 0.255W + secondary 0.338W
- Lm ±30% tolerance impact: I_pk +5.5% — within MOSFET ratings ✅
- Clamp energy: 0.148W (recycled; not dissipated)
- TDK vs Coilcraft comparison table
- ACF Forward design reference equations
- Reference: TI PMP23253 design

### 3. Edited `design/Electronics/Controller/Design_Spec.md`

- T1 BOM row (line 541): solder bridge note appended to Notes column:
  "PCB layout note: TDK datasheet permits solder bridges between pins 1–2 and pins 7–8
  (intra-group within same net only; not primary-to-secondary). Confirm against footprint drawing
  during PCB layout phase."
- Last Updated: 2026-05-09 (already current — no date change required)

### 4. Recycled `.copilot/discussions/ctl-t1-poe-transformer-investigation.md`

- Moved to `.recycle-bin/ctl-t1-poe-transformer-investigation.md`
- All useful content had been migrated to permanent design documents

---

## Files Changed

| File | Operation |
| :--- | :--- |
| `design/Electronics/Controller/PoE_Power_Analysis_Coilcraft_v2.md` | Created (new deferred file) |
| `design/Electronics/Controller/PoE_Power_Analysis.md` | Full rewrite (TDK ACF Forward) |
| `design/Electronics/Controller/Design_Spec.md` | Edited (T1 BOM row solder bridge note) |
| `.recycle-bin/ctl-t1-poe-transformer-investigation.md` | Moved from `.copilot/discussions/` |

---

## Standing State of CTL T1 Investigation Todos

| Todo | Status |
| :--- | :--- |
| `ctl-t1-wurth-datasheet-review` | ✅ Complete (prior session) |
| `ctl-t1-pulse-pa1137nlt-analysis` | ✅ Complete (prior session) |
| `ctl-t1-coilcraft-poe600f-evaluation` | ✅ Complete (discussion file audited and recycled) |
| `ctl-t1-coilcraft-v2-review` | ⏸ DEFERRED — awaiting production availability of Coilcraft POE600F-12L |

---

## Confirmed Parts (PRIMARY DIRECTIVE — DO NOT MODIFY SUPPLIER PNs)

| RefDes | MPN | DigiKey | Mouser | JLCPCB |
| :--- | :--- | :--- | :--- | :--- |
| T1 | TDK B82806D0060A120 | 495-76653-1-ND | 871-B82806D0060A120 | C7218686 |
| Q1, Q2 | STD25NF20 | 497-13749-1-ND | 511-STD25NF20 | C388326 |
| L1 | Yageo PA4343.333NLT | 553-3457-1-ND | 673-PA4343.333NLT | C2453886 |
| C17 | Kemet C0805C223K2RACAUTO | 399-17630-1-ND | 80-C0805C223K2RAUTO | C3843023 |

---

## Next Steps

CTL T1 investigation is fully closed for v1. Open design work continues on other CTL subsystems
and remaining board specs. The `ctl-t1-coilcraft-v2-review` todo is deferred until the Coilcraft
POE600F-12L achieves production-ready mainstream distributor availability.
