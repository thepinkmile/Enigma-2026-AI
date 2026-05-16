# Checkpoint 161 — TPS25751 EEPROM Option C Implementation Complete

**Date:** 2026-05-16
**Session Phase:** Pass 10 triage — tps25751-i2c-review resolved

---

## Summary

The `tps25751-i2c-review` blocked TODO is fully resolved. Option C (SafeMode + external EEPROM + isolated I2Ct debug header) has been designed, decided, and all documentation updated.

---

## Work Done

### New datasheet
- `design/Datasheets/STM-M24512-RDW6TP-datasheet.md` — generated from PDF using `generate_markdown_datasheets.py`; DS6520 Rev 31, 47 pages, SO8N package, 512-Kbit / 64KB, 1.8–5.5V

### PM Design_Spec.md
- U4 note replaced: removed "fixed passive NVM" description; replaced with full SafeMode + EEPROM + debug header architecture including ADCIN config, cross-refs to TPS25751 §8.3.6 Tables 8-5/8-6 and M24512 DS6520 §2.2/§2.3/§2.4/§2.6.1
- DR-PM-20 added: TPS25751 PD profile EEPROM (U18, I2Cc at 0x50, E2=E1=E0=GND, R47/R48 pull-ups, C78 decoupling)
- DR-PM-21 added: I2Ct field-programming header J6 (5-pin 2.54mm, R49/R50 pull-ups, isolated from system I2C-1)
- DR-PM-22 added: ADCIN SafeMode startup configuration (ADCIN1=LDO_3V3 decoded 7, ADCIN2=GND decoded 0 → SafeMode + I2Ct 0x20)
- BOM: U18 (M24512-RDW6TP) row added after U17
- BOM: J6 (61300511121) row added after J5
- BOM: R5/R6 row extended to R5/R6/R47/R48/R49/R50 (qty 2→6, same MPN ERJ-3EKF4701V)
- BOM: C78 added to 100nF CL05B104KB5NNNC group (qty 24→25), note updated
- BOM notes: U18 and J6 notes appended with full details including supplier PNs, datasheet cross-refs, usage notes
- Last Updated: 2026-05-16

### design/Design_Log.md
- DEC-075 appended: TPS25751 Option C — External EEPROM + Isolated I2Ct Debug Header; full rationale, ADCIN config details, component assignments, affected files
- Last Updated: 2026-05-16

### design/Guides/Maintenance_Guide.md
- §5 added: "TPS25751 PD Profile Field Reprogramming" — J6 pinout table, required tools placeholder, programming procedure placeholder, cross-references to PM Design_Spec and DEC-075
- Last Updated: 2026-05-16

### .copilot/todos/tps25751-i2c-review.md
- Status: blocked → done
- Resolution section added with full Option C summary
- Action items crossed off

### .copilot/todo-list.md
- tps25751-i2c-review: blocked → done
- Last updated line updated

### .copilot/todos/footprint-requests-pending.md
- M24512-RDW6TP (SO8N) and 61300511121 (5-pin 2.54mm header) added to pending download list

---

## Key Design Decisions (DEC-075)

- **ADCIN1 = LDO_3V3** (decoded value 7), **ADCIN2 = GND** (decoded value 0) → SafeMode + I2Ct address 0x20
- **U18 = M24512-RDW6TP** at I2C address 0x50 (E2=E1=E0=GND) on isolated I2Cc bus — no connection to system I2C-1
- **J6** 5-pin 2.54mm debug header: Pin1=GND (sq), Pin2=LDO_3V3 (sense only), Pin3=I2Ct_SCL, Pin4=I2Ct_SDA, Pin5=I2Ct_IRQ — isolated from system I2C-1
- No boot dependency: TPS25751 reads EEPROM autonomously at power-up; CM5 boot not required
- Factory initial NVM programming via J6 required before first system use (Maintenance_Guide.md §5)

---

## New Components (PM BOM)

| RefDes | MPN | Notes |
| :--- | :--- | :--- |
| U18 | M24512-RDW6TP | 64KB EEPROM SO8N; I2Cc at 0x50; footprint pending |
| J6 | 61300511121 | 5-pin 2.54mm THT header; I2Ct debug; footprint pending |
| R47, R48, R49, R50 | ERJ-3EKF4701V | 4.7kΩ 1% 0603 pull-ups (I2Cc + I2Ct); extends existing R5/R6 row |
| C78 | CL05B104KB5NNNC | 100nF 50V X7R 0402; U18 VCC decoupling; extends existing 100nF group |

---

## Open Items Remaining

- `INT-P10-001` in `.copilot/review-report.md` still marked "false positive" — should be updated to "resolved: DEC-075"
- Maintenance_Guide.md §5 programming procedure is a placeholder — tool and cable TBD
- U18 and J6 footprints / 3D models pending download (added to footprint-requests-pending.md)
- DigiKey PN for M24512-RDW6TP (`497-2700-1-ND`) should be verified before ordering
- JLCPCB PNs for U18 and J6 noted as "global sourcing / consignment" — need sourcing verification

---

## Files Changed This Checkpoint

- `design/Datasheets/STM-M24512-RDW6TP-datasheet.md` (created)
- `design/Electronics/Power_Module/Design_Spec.md` (U4 note, DR-PM-20/21/22, BOM, notes)
- `design/Design_Log.md` (DEC-075 appended)
- `design/Guides/Maintenance_Guide.md` (§5 added)
- `.copilot/todos/tps25751-i2c-review.md` (status → done, resolution added)
- `.copilot/todo-list.md` (status updated, last-updated line)
- `.copilot/todos/footprint-requests-pending.md` (U18 + J6 added)
- `.copilot/checkpoints/161-tps25751-eeprom-option-c-complete.md` (this file)
- `.copilot/checkpoints/index.md` (entry 161 added)
- `.copilot/plan.md` (status updated)
- `.copilot/handoff.md` (updated)
