# Checkpoint 133 — CTL + JDB BtB Upgrade Locked

**Date:** 2026-05-07  
**Session:** a38ceaab-453d-429a-b9a2-f597295a7147  
**Covers:** Checkpoints 118–133 (since last commit at 117)

---

## Overview

Two major workstreams completed and committed together:

1. **JDB DF40 BtB Connector Upgrade** — replaced the original dual-row IDC header approach with a single Hirose DF40HC(3.5)-20DS-0.4V(51) 20-pin BtB receptacle for the JTAG/USB/power link between the JTAG Daughterboard and the Controller. DEC-058 appended to Design Log.

2. **CTL Design_Spec editorial clean-up** — BOM consolidation, GND/GND_CHASSIS clarification, GRS cross-references, J12 pinout ownership deferral to JDB, and full path reference fix-up (all relative/short paths replaced with full repo-root-relative paths).

---

## Files Modified

- `design/Electronics/JTAG_Daughterboard/Design_Spec.md`
- `design/Electronics/JTAG_Daughterboard/Board_Layout.md`
- `design/Electronics/Controller/Design_Spec.md`
- `design/Electronics/Controller/Board_Layout.md`
- `design/Electronics/Consolidated_BOM.md`
- `design/Design_Log.md` — DEC-058 appended
- `.copilot/plan.md`
- `.copilot/todo-list.md`
- `.copilot/checkpoints/index.md`

---

## JDB BtB Upgrade Detail

### Design Decisions (DEC-058)
- DF40HC(3.5)-20DS-0.4V(51) selected as J1 on JDB / J12 on CTL
- 20-pin allocation: 2× power (5V_MAIN, GND), USB differential pair (USB_D+/USB_D−), 4× JTAG signals (TCK, TMS, TDI, TDO), 4× spares
- Final pinout (row C, columns 1–10):
  - C1: TCK, C2: TMS, C3: GND, C4: 5V_MAIN, C5: USB_D+, C6: USB_D−, C7: 5V_MAIN, C8: GND, C9: TDO, C10: TDI
  - R1 row: C1–C10 = SPARE (10 pins)
- R1 on outer board edge, facing LINK-BETA connector to minimise trace length to stator
- JTAG impedance analysis confirmed: ribbon cable dominates (~110Ω); 33Ω series resistors correct
- USB+ and USB− are proper differential pair; placed symmetrically at C5/C6 centre
- 5V_MAIN retained (FTDI FT232H requires 5V supply); Rev C note added to revisit FT232H for 3V3-capable variant

### JDB Design_Spec Changes
- §3: Old J1–J4 dual-row headers replaced with DF40 §3 pinout table
- §4: FR-JDB-01/02 collapsed to single FR-JDB-01; FR-JDB-02 deferred cleanup todo added
- External connector note retained (module is internal; no user-facing ESD needed)
- Mounting hole grounding note updated to reference GRS module spec

### CTL Design_Spec Changes
- §8.3 J12 section: full pinout removed; replaced with JDB ownership deferral blockquote + net summary table
- JDB now is the single point of truth for the DF40 20-pin pinout

---

## CTL Design_Spec Editorial Detail

### BOM Consolidation (§11)
- BOM rows re-ordered by RefDes
- MH1–MH4 (chassis mount): functional Notes text moved to §2.3 body; BOM Notes cleared
- MH5–MH8 + MH13–MH16 (module standoffs): consolidated to single row (Qty 8)
- J11 + J12 (DF40 receptacles): consolidated to single row (Qty 2)
- Duplicate standoff rows eliminated

### GND / GND_CHASSIS Clarification
- §2.3, DR-CTL-14, DR-CTL-20, §8.3, §8.6: all specify `GND` (not `GND_CHASSIS`) for module standoff grounding
- Deliberate SI decision now explicit in body text

### GRS Cross-References
- §8.3 JDB dock and §8.6 AM dock both now carry:
  > See `design/Standards/Global_Routing_Spec.md` for module mounting hole grounding rules.

### J12 Ownership Deferral
- §8.3: Full 20-pin pinout replaced with blockquote:
  > **Connector Definition Owner:** `design/Electronics/JTAG_Daughterboard/Design_Spec.md §3`.
  > This board provides the mating receptacle (J12). Full connector pinout is defined and owned by the JTAG Daughterboard.
- Net summary table retained in CTL spec for routing reference

### J11 Ownership Deferral
- §8.6: Blockquote updated to reference `design/Electronics/Actuation_Module/Design_Spec.md §3.1`

### Full Path Reference Fix-Up
All relative/short cross-references replaced with full repo-root-relative paths:
- `../../Datasheets/` → `design/Datasheets/` (7 markdown links)
- `AM Design_Spec.md` → `design/Electronics/Actuation_Module/Design_Spec.md` (4 refs)
- `JTAG_Daughterboard/...` → `design/Electronics/JTAG_Daughterboard/...` (5 refs)
- `Global_Routing_Spec.md` → `design/Standards/Global_Routing_Spec.md` (2 refs)
- `Electronics/Controller/PoE_Power_Analysis.md` → `design/Electronics/Controller/PoE_Power_Analysis.md` (3 refs)
- `Board_Layout.md` (CTL self-ref) → `design/Electronics/Controller/Board_Layout.md` (2 refs)
- Various `Power_Module/`, `Stator/`, `Software/`, `Consolidated_BOM.md` short refs (6 refs)

---

## Deferred Todos (added this session)

- `jdb-fr-renumber` — renumber JDB functional requirements consecutively
- `ftdi-3v3-rev-c` — revisit FT232H for 3V3-capable variant (Rev C)
- `ctl-display-v2` — display screen integration (Version 2)

---

## Next Steps

- `mh-refdes-standardise` — standardise MH RefDes numbering across all boards
- Verify Consolidated_BOM.md MH5–MH8 / MH13–MH16 rows are consolidated (may still be separate)
- Continue Pass 6 or open workstream per plan.md
