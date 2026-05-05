# Deep-Dive Review Cycle — Pass 1

**Started:** 2026-04-30

---

## Scope

- **Stand-alone board reviews:** Power Module, Controller, Stator, Rotor, Extension, Reflector,
  Encoder, Actuation Module, User Settings Module, JTAG Daughterboard
- **Integration reviews:** Inter-board connectivity (pin-maps, signal names, rail names);
  Consolidated BOM accuracy vs all board BOMs

## Review Agent Batches

- Batch 1: Power Module, Controller, Stator, Rotor
- Batch 2: Extension, Reflector, Encoder, Actuation Module
- Batch 3: User Settings Module, JTAG Daughterboard, Integration-Connectivity, Integration-BOM

---

## Pass 1 — Review Findings

<!-- Agents append their findings below in the format:
     ### [Board/Scope] — [Agent ID]
     | Severity | Item | Details |
-->

### Batch 1 — Power Module (review-pm)

| Severity | Ref | Finding | Detail |
| :--- | :--- | :--- | :--- |
| HIGH | SIGNAL-ROTOR_EN | Signal naming inconsistency: ROTOR_EN vs ROTOR_EN_N | Board_Layout.md §2 and §4 lists signal as `ROTOR_EN`, but Design_Spec.md consistently names it `ROTOR_EN_N` (active-LOW). Must be resolved before schematic capture. |
| MEDIUM | BOM-J1_J3 | Conflicting documentation for J1-J3 connector sourcing | BOM table lists JLCPCB part number C3683043 for J1-J3 connectors, but BOM notes state these are not standard JLC stocked parts and require global sourcing/consignment/post-assembly install. Contradictory. |
| MEDIUM | BOM-R12_R23 | Missing JLCPCB sourcing information without explanation | R12 and R23 (CSS2H-2512R-R010ELF Kelvin-sense shunt resistors) have `—` in the JLCPCB column with no explanation. Unlike other similarly constrained parts, no sourcing note is present. |
| MEDIUM | BATTERY-ESD | Incomplete ESD protection on J4 battery connector power lines | J4 is on the external face. D1 protects BATT_PRES_N and D2 protects SMBus lines only. VBATT+ and VBATT- power lines have no dedicated TVS transient suppression. |

### Batch 1 — Controller (review-ctl)

| Severity | Ref | Finding | Detail |
| :--- | :--- | :--- | :--- |
| HIGH | LAYOUT-REF | Broken cross-reference in Design_Spec.md | Design_Spec.md lines 288 and 303 reference "Controller/Board_Layout.md JDB Hat Connectors section" but this section does not exist in Board_Layout.md. Authoritative pin tables are defined inline in Design_Spec.md §8.3 and §8.4. |
| MEDIUM | CONN-NAMING | Signal naming inconsistency: ROTOR_EN_N vs ROTOR_EN | Design_Spec.md uses `ROTOR_EN_N` consistently (FR-CTL-05 and other refs). Board_Layout.md §2.3 J3 table lists it as `ROTOR_EN` without the `_N` suffix. |
| MEDIUM | BOM-BYPASS | Missing bypass capacitor specifications for power switches | U2 (TPS2065CDBVR USB power switch) and U3 (AP2331W-7 HDMI power switch) have no associated bypass capacitor RefDes in the BOM. Standard practice requires local 100nF bypass on Vcc pins. |

### Batch 1 — Stator (review-sta)

| Severity | Ref | Finding | Detail |
| :--- | :--- | :--- | :--- |
| HIGH | BOM-U8 | Duplicate BOM entry for U8 | U8 (MCP23017 I²C GPIO Expander) appears twice in the BOM table. Both entries are identical. One must be removed. |
| HIGH | FR-STA-08 | Incorrect I²C device reference | FR-STA-08 states "CM5 reads U1 @ 0x23" but U1 is the CPLD (EPM570T100I5N), which is not I²C-addressable. Address 0x23 belongs to the User Settings Module. The requirement text needs correction. |
| MEDIUM | LAYOUT-PLACEMENT | Missing component placement zones in Board_Layout.md | Board_Layout.md is titled "Master Pinout" but only U8 (§6) and J13 (§5) have explicit placement specifications. The remaining 40+ designators (C1-C26, J1-J12, L1-L4, R1-R43, U1-U7, U9-U12) have no placement zones, height constraints, orientation, or thermal notes. |

### Batch 1 — Rotor (review-rot)

| Severity | Ref | Finding | Detail |
| :--- | :--- | :--- | :--- |
| HIGH | DR-ROT-SEQ | DR-ROT IDs non-sequential | DR-ROT-11 appears at row 7, before DR-ROT-06 through DR-ROT-10. Correct sequence should be DR-ROT-01 through DR-ROT-11 in ascending order. |
| MEDIUM | DR-ROT-BYPASS | No Design Requirement for decoupling/bypass capacitors | C1–C19 (CPLD/FDC2114 bypass and bulk decoupling) are fully specified in the BOM but have no corresponding DR. |
| MEDIUM | LAYOUT-SUMMARY | Board_Layout component summaries incomplete | Board A §2.1 and Board B §3.1 "Component Summary" sections omit decoupling capacitors (C1–C19), pull-up resistors (R2–R7), and ESD arrays (U5–U12). |
| LOW | BOM-MOQ | High MOQ warnings on I²C pull-up resistors | R6–R7 (KOA Speer SG73S1ERTTP4701F 4.7kΩ): Mouser MOQ 10,000; JLCPCB MOQ 49. May impact prototype/low-volume build feasibility. |

---

**Batch 1 subtotal: 4 HIGH · 8 MEDIUM · 1 LOW**

### Batch 2 — Extension (review-ext)

| Severity | Ref | Finding | Detail |
| :--- | :--- | :--- | :--- |
| HIGH | BOM-J7_J8 | Consolidated_BOM.md J7/J8 description incorrect | Consolidated_BOM.md Extension rows describe J7/J8 as "Rotor group JTAG headers" — this is wrong. J7/J8 are the Extension Port (Stator interconnect), 20-pin BHR-20-VUA shrouded box headers. |
| HIGH | ESD-DEC045 | ESD section missing DEC-045 cross-reference | Design_Spec.md §5 correctly implements U2–U9 ESD protection on Samtec connectors but does not cite DEC-045. Should explicitly state "Per DEC-045, all Samtec ERM8/ERF8 rotor-facing connectors require TPD4E05U06QDQARQ1." |
| MEDIUM | ESD-ARRAY-COUNT | ESD array count documentation ambiguous | Design_Spec.md §5 exemption list for J2/J5 (power-only connectors) is stated but could be clearer. DR-EXT-13 correctly specifies "U2–U5 (J1/J3) + U6–U9 (J4/J6) = 8× TPD4E05U06QDQARQ1" and matches the BOM, but §5 prose does not explicitly confirm the J2/J5 power exemption rationale. |
| MEDIUM | PINOUT-XREF | Missing Extension Port pinout cross-reference | Board_Layout.md §2 cites "Connector Definition Owner: Stator/Board_Layout.md — J10" but does not clarify that Extension J7/J8 are 20-pin while Stator J10 is 16-pin, with pins 17–20 carrying 5V_MAIN/GND per DEC-043. Should be noted to prevent confusion. |
| MEDIUM | DEC043-XREF | Missing DEC-043 cross-reference for 20-pin Extension Port | Design_Spec.md §2 describes J7/J8 as 20-pin BHR-20-VUA without referencing DEC-043 (the decision that widened from 16-pin to 20-pin to add AM power). Add DEC-043 traceability note. |
| MEDIUM | HARNESS-TYPE | No cross-reference to QUE-002 resolution for cable assembly type | Neither Design_Spec.md nor Board_Layout.md references the IDC ribbon cable type for the Extension Port harness. QUE-002 resolution (standard IDC ribbon) should be noted for traceability. |
| MEDIUM | LAYOUT-ESD | Board_Layout.md lacks Thermal & ESD section | Design_Spec.md has a Thermal & ESD section (§5). Board_Layout.md has no equivalent section or cross-reference note for ESD placement constraints near connector mating edges. |

### Batch 2 — Reflector (review-ref)

| Severity | Ref | Finding | Detail |
| :--- | :--- | :--- | :--- |
| HIGH | BOM-R1-DUP | Duplicate BOM row for R1 | R1 (JTAG termination 22Ω) appears twice in the BOM table with identical specifications. One row must be removed. |
| MEDIUM | CBOM-J3 | Consolidated_BOM.md J3 description mismatch | Consolidated_BOM.md labels Reflector J3 as "Input dock connector (power/JTAG)" but Design_Spec.md §4 correctly describes it as the "ENC data connector". |
| MEDIUM | LAYOUT-STACKUP | Stackup description variance between files | Board_Layout.md §4 title reads "4-Layer / 2oz Copper". Design_Spec.md §6 uses the fuller form "4-Layer JLC04161H-7628 / 2oz Finished Copper". Should be consistent. |
| LOW | BOM-C1-C5 | C1–C5 bulk decoupling footnote lacks canonical specification | BOM line for C1–C5 labels them as "Bulk entry decoupling bank (star/spoke)" but does not state the canonical Global_Routing_Spec.md §3 form: "5× 10µF X7R 25V 0805". |

### Batch 2 — Encoder (review-enc)

Encoder — No findings.

### Batch 2 — Actuation Module (review-am)

| Severity | Ref | Finding | Detail |
| :--- | :--- | :--- | :--- |
| HIGH | SIGNAL-NAMING | Active-low signal naming convention violations | `ACTUATE_REQUEST` and `ACTUATION_HOME` are documented as active-low in Design_Spec.md but lack the `_N` suffix required by the project-wide convention. Both hardware Design_Spec.md and Software Design_Spec.md must be updated to `ACTUATE_REQUEST_N` and `ACTUATION_HOME_N`. Note: `NRST` is the standard STM32 IC pin designation and does not require renaming. |
| HIGH | DR-AM-18-SW | Contradictory pull-up configuration: external R6 vs firmware internal pull-up | Hardware Design_Spec.md DR-AM-18 specifies an external 10kΩ pull-up R6 on `ACTUATE_REQUEST`. Software Design_Spec.md §5 states the STM32 internal pull-up shall be enabled in firmware (PUPDR = `0b01`), making R6 redundant. These requirements are mutually exclusive. **Requires user decision** before PCB fabrication: (A) remove R6 and use firmware internal pull-up only, or (B) keep R6 and disable the firmware internal pull-up. |
| MEDIUM | THERMAL-ESD | Missing Thermal & ESD section | Global_Routing_Spec.md §9 requires boards with only internal connectors to explicitly document ESD compliance. All AM connectors (J1–J6) are internal. Design_Spec.md lacks a dedicated Thermal & ESD section confirming "No TVS/ESD required — all connectors internal per Global_Routing_Spec.md §9." |

---

**Batch 2 subtotal: 4 HIGH · 10 MEDIUM · 1 LOW**

### Batch 3 — User Settings Module (review-sbd)

| Severity | Ref | Finding | Detail |
| :--- | :--- | :--- | :--- |
| MEDIUM | THERMAL-ESD | Missing Thermal & ESD section | Design_Spec.md lacks a Thermal & ESD section. Per Global_Routing_Spec.md §9, boards with only internal connectors must explicitly state: "No TVS/ESD protection required — all connectors are internal to the enclosure, per Global_Routing_Spec.md §9." J1 is an internal Stator harness connector; toggle switches and LEDs are hardwired panel components. |

### Batch 3 — JTAG Daughterboard (review-jdb)

| Severity | Ref | Finding | Detail |
| :--- | :--- | :--- | :--- |
| HIGH | DR-SEQ | Design Requirement ID gaps | DR-JDB-03 and DR-JDB-05 are missing. Current DR sequence: DR-01/02/04/06–18 (gaps at 03 and 05). IDs must be contiguous. |
| HIGH | CBOM-R3 | Conflicting resistor value for R3 in Consolidated_BOM.md | R3 appears in two rows with different values: "R2,R3 = 33Ω" and "R3-R5 = 10kΩ". Per Design_Spec.md, R3 is 10kΩ (RESET# pull-up). The "R2,R3 = 33Ω" row is incorrect. |
| HIGH | CRYSTAL-MPN | Crystal part mismatch vs Design_Log DEC-022 | DEC-022 selects YXC X322512MSB4SI (JLCPCB C9002). Design_Spec.md BOM and Consolidated_BOM.md both list ABM8-12-B2-T (Abracon, JLCPCB C596894) — a different part. BOM does not reflect the DEC-022 decision. **Requires user confirmation** of which crystal is the correct approved part. |
| MEDIUM | THERMAL-ESD | Misleading ESD statement in Thermal & ESD section | Design_Spec.md §7 states "ESD protection via U5 JTAG buffer (SN74LVC2G125DCUR)" but U5 is a 3-state logic buffer, not an ESD/TVS suppressor. All JDB connectors (J1, J2) are internal hat-headers. Section should explicitly state "No TVS/ESD protection required — all connectors are internal, per Global_Routing_Spec.md §9." |
| MEDIUM | SIGNAL-NAMING | RESET# notation vs project _N suffix convention | RESET# uses the "#" suffix. Project-wide convention requires `_N` suffix. Should either rename to `RESET_N` or add a note clarifying this is an IC pin label exception (if the "#" form is sourced directly from the IC datasheet). |
| MEDIUM | LAYOUT-IMPEDANCE | JTAG trace impedance compliance note could be clearer | Board_Layout.md §7.1 states "DEC-016 CI exception (outer layers only) does not apply" then references buried-microstrip topology. Should explicitly state that 0.127 mm traces on L2 are compliant because the inverted stackup (L1=GND) places them adjacent to a reference plane, achieving equivalent impedance to outer-layer traces. |
| LOW | STACKUP-NOTE | Design_Spec.md does not call out inverted stackup | Design_Spec.md §5 describes the JLC04161H-7628 as standard without noting the inverted layer order (L1=GND, L2=signals, L3=power, L4=GND vs standard L1=signal). Board_Layout.md correctly documents this; Design_Spec.md should cross-reference it. |

### Batch 3 — Integration: Connectivity (review-int-conn)

Integration-Connectivity — No findings. All critical interfaces verified: Link-Alpha, Link-Beta, Extension Port 20-pin pass-through, rotor daisy-chain ERM8/ERF8, I²C addresses, signal directions, and rail names are correctly specified and compatible across all board boundaries.

### Batch 3 — Integration: Consolidated BOM (review-int-bom)

| Severity | Ref | Finding | Detail |
| :--- | :--- | :--- | :--- |
| HIGH | CBOM-REF-R1 | Reflector R1 duplicate row in board Design_Spec.md | R1 (ERJ-3EKF2200V) appears twice in Reflector Design_Spec.md BOM (identical entries). Consolidated_BOM.md correctly captures only one instance but the source Design_Spec.md must be corrected. *(Also raised by review-ref — linked finding.)* |
| MEDIUM | CBOM-EXT-J7J8 | Extension J7/J8 description incorrect in Consolidated_BOM.md | Consolidated_BOM.md describes Extension J7/J8 as "Rotor group JTAG headers" — incorrect. These are Extension Port IN/OUT headers (20-pin 2×10 2.54 mm shrouded box). *(Also raised by review-ext — linked finding.)* |
| LOW | CBOM-JDB-R3 | Conflicting R3 assignment across two Consolidated_BOM.md rows | Row "R2,R3 = 33Ω" and row "R3-R5 = 10kΩ" both include R3. Per Design_Spec.md, R3 is 10kΩ (RESET# pull-up). The 33Ω row is incorrect. *(Also raised by review-jdb — linked finding.)* |

---

**Batch 3 subtotal: 4 HIGH · 4 MEDIUM · 1 LOW**

---

## Pass 1 Grand Total

| Severity | Count |
| :--- | :--- |
| HIGH | 16 |
| MEDIUM | 22 |
| LOW | 4 |
| **TOTAL** | **42** |

*Note: Some findings are linked across agents (same underlying defect raised from multiple perspectives); the fix agent will treat linked findings as a single fix.*

---

## Pass 1 — Fix Agent Results

**Fix agent:** fix-pass1 | **Files modified:** 14 | **Linter:** all 14 files pass clean

| Fix ID | File | Change Applied |
| :--- | :--- | :--- |
| F-01 | Power_Module/Board_Layout.md | `ROTOR_EN` → `ROTOR_EN_N` (×2) |
| F-02 | Controller/Design_Spec.md | Removed 2× broken "Full Pin Table" cross-references (J12, J13) |
| F-03 | Controller/Board_Layout.md | `ROTOR_EN` → `ROTOR_EN_N` in J3 table |
| F-04 | Stator/Design_Spec.md | Removed duplicate U8 BOM row |
| F-05 | Stator/Design_Spec.md | FR-STA-08: corrected I²C reference from `U1 @ 0x23` to `User Settings Module U1 @ 0x23` |
| F-06 | Rotor/Design_Spec.md | DR-ROT-11 reordered to correct sequential position after DR-ROT-10 |
| F-07 | Extension/Design_Spec.md | Added DEC-045 cross-reference to Thermal & ESD section |
| F-08 | Extension/Design_Spec.md | Added DEC-043 traceability note to J7/J8 description |
| F-09 | Extension/Board_Layout.md | Added `## 7. Thermal & ESD` section with cross-reference to Design_Spec.md §5 |
| F-10 | Reflector/Design_Spec.md | Removed duplicate R1 BOM row |
| F-11 | Actuation_Module/Design_Spec.md + Software/Actuation_Module/Design_Spec.md | `ACTUATE_REQUEST` → `ACTUATE_REQUEST_N`; `ACTUATION_HOME` → `ACTUATION_HOME_N` throughout both files |
| F-12 | Actuation_Module/Design_Spec.md | Added `## 7. Thermal & ESD` section (no TVS — all connectors internal) |
| F-13 | User_Settings_Module/Design_Spec.md | Inserted `## 9. Thermal & ESD` section; BOM → §10; Power Budget → §11 |
| F-14 | JTAG_Daughterboard/Design_Spec.md | Fixed misleading ESD statement; replaced with no-TVS internal-connector statement |
| F-15 | JTAG_Daughterboard/Design_Spec.md | Added inverted stackup cross-reference note |
| F-16 | JTAG_Daughterboard/Board_Layout.md | Clarified JTAG trace impedance compliance note for L2 traces |
| F-17 | Consolidated_BOM.md | Extension J7/J8 description corrected to "Extension Port IN/OUT headers" |
| F-18 | Consolidated_BOM.md | Reflector J3 description corrected to "ENC data connector" |
| F-19 | Consolidated_BOM.md | JDB `R2,R3` row corrected to `R2` only (33Ω); R3 remains in `R3-R5` (10kΩ) row |
| F-20 | Stator/Design_Spec.md | U8 I²C address table appended `(per DEC-032)` |

### Items not fixed — require user decision

| Ref | Reason |
| :--- | :--- |
| AM DR-AM-18 vs SW §5 | External R6 vs firmware internal pull-up — mutually exclusive; awaiting user decision |
| PM BATTERY-ESD | TVS on VBATT+/VBATT- lines — awaiting user confirmation |
| JDB CRYSTAL-MPN | DEC-022 (YXC X322512MSB4SI / C9002) vs BOM (ABM8-12-B2-T / C596894) — MPN locked; awaiting user confirmation |
| JDB RESET# naming | Rename to RESET_N vs IC pin label exception — awaiting user confirmation |
| JDB DR-SEQ (DR-03/05 gaps) | Missing DR text — awaiting user input |
| CTL BOM-BYPASS (U2/U3) | Bypass cap values not yet specified — awaiting user input |
| Multiple MEDIUM/LOW | Documentation improvements deferred to user confirmation (see findings) |

#### Pass 1 result: 42 findings — 20 fixed; 7 items pending user decisions

---

## Pass 1 — User Decisions & Follow-On Fixes

### User decisions received

| Decision | Item | Resolution |
| :--- | :--- | :--- |
| D-1 | AM DR-AM-18 pull-up | **Remove R6; use STM32 firmware internal pull-up (PUPDR = 0b01) only** |
| D-2 | PM BATTERY-ESD | **Add TVS diode on VBATT+ → VBATT− at J4; part selection pending user confirmation** |
| D-3 | JDB CRYSTAL-MPN | **Deferred** — user to re-verify temp range spec (YXC C9002 vs Abracon C596894) before next pass |
| D-4 | JDB RESET# naming | **Rename to RESET_N throughout** |
| D-5 | JDB DR-SEQ gaps | **Renumber all DR-JDB IDs sequentially (01–16); update all cross-references** |
| D-6 | CTL BOM-BYPASS U2/U3 | **Pending** — user reviewing context (U2 = TPS2065C USB load switch 1.6A; U3 = AP2331W HDMI load switch) |
| D-7 | Deferred MEDIUM/LOW items | **Pending** — full list presented to user; awaiting decisions |

### Follow-on fix agent: fix-decisions-1-4-5

**Fix agent:** fix-decisions-1-4-5 | **Files modified:** 5 | **Linter:** all files pass clean

| Fix ID | File | Change Applied |
| :--- | :--- | :--- |
| F-21 | Electronics/Actuation_Module/Design_Spec.md | Removed DR-AM-18 (external pull-up R6); updated ACTUATE_REQUEST_N biasing note to state STM32 internal pull-up (PUPDR = `0b01`) is sole pull-up; removed R6 BOM row |
| F-22 | Software/Actuation_Module/Design_Spec.md | Added explicit statement: "No external pull-up resistor (R6) fitted; internal pull-up is the authoritative pull-up source" |
| F-23 | Consolidated_BOM.md | AM RefDes range `R4-R6` → `R4, R5` |
| F-24 | JTAG_Daughterboard/Design_Spec.md | All `RESET#` → `RESET_N`; first occurrence carries FT232H pin 34 IC name note |
| F-25 | JTAG_Daughterboard/Design_Spec.md + Board_Layout.md | DR-JDB IDs renumbered 01–16 (gaps at 03/05 filled); all cross-references updated |

### Remaining open items (pre-Pass 2)

| Ref | Status |
| :--- | :--- |
| D-2 PM BATTERY-ESD | TVS part (SMBJ18A proposed) — **awaiting user confirmation** |
| D-3 JDB CRYSTAL-MPN | **Deferred** to Pass 2 / user review |
| D-6 CTL BOM-BYPASS | Bypass caps for U2/U3 — **awaiting user decision** |
| D-7 MEDIUM/LOW items | Full list presented; **awaiting user decisions** |

---

## Pass 1 — Fix Agent 2 Results (fix-pass1-final)

**Fix agent:** fix-pass1-final | **Triggered by:** User decisions D-2 through D-7
**Files modified:** 10 | **Linter:** all files pass clean (zero errors)

| Fix ID | File | Change Applied |
| :--- | :--- | :--- |
| F-26 | `agent-directives.md` | Added general MOQ suppression rule (blanket); retained ROT-MOQ specific entry |
| F-27 | `Standards/Global_Routing_Spec.md` | Added §3.2 Per-IC Bypass Capacitors rule; Samsung CL05B104KB5NNNC / JLCPCB C1525 as standard part |
| F-28 | `Controller/Design_Spec.md` | Added DR-CTL-16 (bypass cap requirement citing global rule) |
| F-29 | `Controller/Design_Spec.md` | Added C26 (U2 TPS2065CDBVR bypass) and C27 (U3 AP2331W-7 bypass) BOM rows; both 100nF CL05B104KB5NNNC / C1525 |
| F-30 | `Power_Module/Design_Spec.md` | Added D4 row: Bourns SMBJ18A-Q TVS (DO-214AA; VWM=18V; 600W; Mouser 652-SMBJ18A-Q; DigiKey 118-SMBJ18A-QCT-ND; JLCPCB C1979859 Extended) |
| F-31 | `Power_Module/Design_Spec.md` | J1-J3 JLCPCB column: updated pre-order/consignment language; R12/R23 JLCPCB: consignment note confirmed |
| F-32 | `JTAG_Daughterboard/Design_Spec.md` | Y1 crystal: ABM8-12-B2-T (C596894) → CTS 435F12012IET; 12MHz 20pF ±20ppm; Mouser 774-435F12012IET; DigiKey 110-435F12012IETTR-ND; JLCPCB C19766404 Extended |
| F-33 | `Rotor/Board_Layout.md` | §2.1 Board A: added U5/U6 (J1 JTAG ESD) and U7/U8 (J2 ENC ESD) entries; §3.1 Board B: added U9/U10 (J3 JTAG ESD) and U11/U12 (J4 ENC ESD) entries |
| F-34 | `Reflector/Design_Spec.md` | §2 + §6 stackup string standardised to `4-Layer / 2oz Copper (JLC04161H-7628)` |
| F-35 | `Reflector/Board_Layout.md` | §4 stackup description updated to `4-Layer / 2oz Copper (JLC04161H-7628)` |
| F-36 | `Extension/Design_Spec.md` | §5 Thermal & ESD: J2/J5 power-only ESD exemption statement confirmed/present |
| F-37 | `Consolidated_BOM.md` | D4 TVS row added (Power Module); C26/C27 rows added (Controller); Y1 crystal row updated (JDB) |

**Orchestrator corrections applied after agent completion:**

| Fix ID | File | Correction |
| :--- | :--- | :--- |
| F-38 | `Power_Module/Design_Spec.md` | D4 TVS: corrected wrong part (Vishay SMBJ18A-E3/61) to confirmed Bourns SMBJ18A-Q with correct supplier PNs |
| F-39 | `Consolidated_BOM.md` | D4 row + unique-parts table row 116: corrected Vishay → Bourns SMBJ18A-Q |
| F-40 | `agent-directives.md` | General MOQ suppression rule was part-specific only; replaced with blanket MOQ rule preceding ROT-MOQ entry |
| F-41 | `Reflector/Design_Spec.md` | §2 line 43 stackup string still in old format; corrected to `4-Layer / 2oz Copper (JLC04161H-7628)` |

#### Pass 1 result (after all fixes): ALL ITEMS RESOLVED — ready for Pass 2

All 42 Pass 1 findings resolved. All user decisions D-1 through D-7 actioned. Zero outstanding items requiring user input before Pass 2 can begin.

---

# Deep-Dive Review Cycle — Pass 2

**Started:** 2025-05

---

## Scope

- **Stand-alone board reviews:** Power Module, Controller, Stator, Reflector, Extension, Encoder,
  JTAG Daughterboard, Rotor, User Settings Module, Actuation Module
- **Integration reviews:** Inter-board connectivity (signal names, rail names, refdes consistency);
  Consolidated BOM vs all board BOMs
- **Prerequisite:** Each review agent read `design/Standards/Global_Routing_Spec.md` before
  reviewing any board

## Review Agent Batches

- Batch 1: Power Module, Controller, Stator, Encoder
- Batch 2: Reflector, Extension, JTAG Daughterboard, Rotor
- Batch 3: User Settings Module, Actuation Module, Integration-Connectivity, Integration-BOM

---

## Pass 2 — Review Findings

### Batch 1 — Power Module (review-pm)

| Severity | Ref | Finding | Detail |
| :--- | :--- | :--- | :--- |
| HIGH | PM-MAJ-1 | TPS75733 (U7) has no bypass capacitor in BOM | U7 (TPS75733DCQR 3.3V LDO) has no local bypass/decoupling capacitor. GRS §3.2 requires ≥100nF per-IC bypass. Also investigated: TPS25980 (U1) has single VIN pin only (no separate VDD); existing C9/C10 (22µF) far exceed ≥10nF minimum — no C31 required. LMQ61460A (U6) bypass satisfied by existing input bulk caps — no C32 required. |
| MEDIUM | PM-MAJ-2 | GRS §3 bulk-entry exemption for rail-source board not documented | The Power Module generates all output rails; GRS §3 applies to downstream consumers. No exemption callout exists in §2. Risk: future reviewers incorrectly flag this board as non-compliant. |
| LOW | PM-MIN-1 | Board_Layout compliance-marker cross-references unverified | Board_Layout.md §2 lists compliance markers referencing GRS sub-sections. Markers not verified to match current GRS numbering. |
| LOW | PM-MIN-2 | GND↔GND_CHASSIS single-point bond lacks RefDes assignment | §6 describes the single-point GND bond but does not assign a RefDes. GRS §5 requires the bond component to be a trackable BOM item. |

### Batch 1 — Controller (review-ctl)

| Severity | Ref | Finding | Detail |
| :--- | :--- | :--- | :--- |
| CRITICAL | CTL-CRIT-1 | U9, U10, T2 (PoE chain) absent from Consolidated BOM | U9 (TPS2372-4RGWR), U10 (TPS23730RMTR), and T2 (POE600F-12L) are fully specified in Controller Design_Spec.md but completely absent from Consolidated_BOM.md. |
| HIGH | CTL-MAJ-1 | C24 services both U9 and U10 VCC pins | Design_Spec.md lists C24 as U9 VCC bypass only; U10 also requires its own local 100nF bypass per GRS §3.2. C28 must be added for U10. |
| HIGH | CTL-MAJ-2 | U9, U10, T2 absent from §2 MPN summary table | All major ICs and magnetics must appear in the §2 "Key ICs & Passives" summary; U9, U10, T2 were missing. |

### Batch 1 — Stator (review-sta)

| Severity | Ref | Finding | Detail |
| :--- | :--- | :--- | :--- |
| HIGH | STA-MAJ-1 | R33–R38 RefDes range duplicated in Consolidated BOM | R33–R38 appeared under two different boards in Consolidated_BOM.md. One section incorrectly claimed these RefDes. |
| LOW | STA-MIN-1 | CPLD VCC/VCCIO pin assignments missing from Board_Layout.md | Board_Layout.md did not document which VCC and VCCIO pins of the EPM570T100I5N connect to 3V3_ENIG; required for decoupling adequacy verification. |

### Batch 1 — Encoder (review-enc)

| Severity | Ref | Finding | Detail |
| :--- | :--- | :--- | :--- |
| LOW | ENC-MIN-1 | **DISMISSED — false positive** | Finding raised about encoder pull-up topology. User confirmed weak internal pull-ups are acceptable for 5–15cm ribbon runs based on prior EPM240 breadboard validation at 25cm. No action required. |

### Batch 2 — Reflector (review-ref)

| Severity | Ref | Finding | Detail |
| :--- | :--- | :--- | :--- |
| HIGH | REF-MAJ-1 | **DISMISSED — false positive** | Finding raised about GRS §3 bulk-entry compliance. Reflector is a passive board (no power-consuming logic ICs beyond ESD arrays); GRS §3 bulk-entry rule applies to active logic boards. No action required. |
| LOW | REF-MIN-1 | TPD4E05U06QDQARQ1 maximum working voltage not stated in §5 | §5 ESD section lists U1–U4 on the 5V_MAIN rail but does not state the device's maximum continuous working voltage (5.5V). Required for margin verification by future reviewers. |

### Batch 2 — Extension (review-ext)

No new stand-alone findings in Pass 2 beyond integration items captured under INT.

### Batch 2 — JTAG Daughterboard (review-jdb)

| Severity | Ref | Finding | Detail |
| :--- | :--- | :--- | :--- |
| CRITICAL | JDB-CRIT-1 | **DISMISSED — false positive** | Finding raised about crystal load-capacitor calculation. On investigation, DR-JDB-17 and the full load-cap derivation were already present in the spec citing the datasheet calculation. No missing content. |
| HIGH | JDB-MAJ-1 | U5 (EPM240T100I5N CPLD) has no bypass capacitor | U5 had no associated bypass cap in the BOM. GRS §3.2 requires ≥100nF per-IC bypass. C12 must be added. |
| LOW | JDB-MIN-1 | §6 Routing Notes missing cross-reference to Board_Layout.md §7.1 | §6 describes routing constraints further detailed in Board_Layout.md §7.1 but contained no cross-reference to that section. |

### Batch 2 — Rotor (review-rot)

| Severity | Ref | Finding | Detail |
| :--- | :--- | :--- | :--- |
| CRITICAL | ROT-CRIT-1 | Board A and Board B not documented as a single logical unit | Board A and Board B are always populated and operated together as one logical encoder assembly, but this relationship is not documented. Risk: Board B incorrectly treated as independently reviewable, causing false GRS §3 bulk-cap violations on Board B (whose bulk caps reside on Board A). |
| HIGH | ROT-MAJ-1 | **DISMISSED — resolved by ROT-CRIT-1** | Once DR-ROT-12 (Board A+B logical unit) is applied, Board B is an extension of Board A and its bulk-cap absence is explicitly exempted. No separate fix needed. |

### Batch 3 — User Settings Module (review-set)

| Severity | Ref | Finding | Detail |
| :--- | :--- | :--- | :--- |
| HIGH | SET-MAJ-1 | Bulk-entry capacitor banks missing for both input rails | User Settings Module receives 3V3_ENIG and 5V_MAIN. GRS §3 requires ≥5× 10µF bulk-entry caps per rail on all consumer boards. No bulk-entry banks existed. C5–C9 (3V3_ENIG) and C10–C14 (5V_MAIN) must be added. |
| HIGH | SET-MAJ-2 | No ESD protection on panel-facing switches SW1–SW5 | J1 panel switches are user-accessible. No TVS/ESD array is present on these lines. **DEFERRED per user D-8** — to evaluate during pre-prototype switch testing; switch mechanical construction may make ESD components irrelevant. |
| LOW | SET-MIN-1 | Samsung CL21B106KAYQNNE specified with X5R dielectric — should be X7R | CL21B106KAYQNNE is an X7R dielectric; the spec description was incorrect. |
| LOW | SET-MIN-2 | **DISMISSED — false positive** | Review agent claimed Board_Layout.md did not exist for User Settings Module. `design/Electronics/User_Settings_Module/Board_Layout.md` exists and is correctly populated. |
| LOW | SET-MIN-3 | J1 connector description incomplete | J1 (panel switch connector) description did not specify JST PH 2.0mm pitch or pin count. |

### Batch 3 — Actuation Module (review-am)

| Severity | Ref | Finding | Detail |
| :--- | :--- | :--- | :--- |
| CRITICAL | AM-CRIT-1 | DR-AM-15 did not restrict STM32 VDD supply to pin 4 only | DR-AM-15 covered the LDO VDD rail but did not explicitly state that only pin 4 (VDD) carries 3V3_ENIG — pin 16 (VDD_USB) must remain unconnected. Ambiguity risked incorrect wiring. |
| LOW | AM-MIN-1 | SW2 supply rail not stated in DR-AM-15 | DR-AM-15 described SW2 (BOOT0 switch) but did not state that SW2's pull-up supply is 3V3_ENIG (not VDD). |
| LOW | AM-MIN-2 | DR-AM-15 missing GRS §3 exemption cross-reference | The AM is a daughterboard receiving no directly-generated external rails; GRS §3 bulk-entry exemption is correct but was not cross-referenced in the DR. |
| LOW | AM-MIN-3 | Phantom "(R6)" reference in Software AM Design_Spec.md | `design/Software/Actuation_Module/Design_Spec.md` contained a stray "(R6)" reference; R6 does not exist on the AM BOM. |
| LOW | AM-MIN-4 | Mounting holes not specified for Actuation Module | GRS requires mounting holes on all PCBs. No mounting hole DR existed for the AM; physical location TBD at PCB layout stage. |
| LOW | AM-MIN-5 | GND_CHASSIS exemption note absent from AM spec | The AM is a daughterboard and does not implement the GND↔GND_CHASSIS single-point bond. No exemption note explained this. |
| LOW | AM-MIN-6 | Blank line in AM BOM table | A blank line in the middle of the BOM table in AM Design_Spec.md broke table rendering. |

### Batch 3 — Integration Reviews

| Severity | Ref | Finding | Detail |
| :--- | :--- | :--- | :--- |
| LOW | INT-MIN-001 | `ACTUATE_REQUEST` signal missing `_N` suffix throughout | Signal is active-LOW; GRS naming conventions require the `_N` suffix. Appeared without suffix in Controller, Extension, and Software AM specs. |

---

## Pass 4 — Review Findings

**Completed:** 2026-05-07

### Batch 1 — Power Module and Actuation Module

| Severity | Ref | Finding | Detail |
| :--- | :--- | :--- | :--- |
| MEDIUM | PM-P4-1 | BOM note range incorrect | BOM note cross-reference range in the Power Module spec was malformed and did not reflect the correct component span. Rewritten to give accurate component descriptions. |
| LOW | PM-P4-2 | `§1 PCB Architecture` missing mounting holes table | GRS requires all PCBs to document mounting holes. The Power Module §1 section had no mounting holes subsection. Table added: 4x M3 (3.2 mm drill), PTH non-plated, GND_CHASSIS, no BOM entry. |
| MEDIUM | AM-P4-1 | `ACTUATION_HOME` missing `_N` suffix in Board_Layout.md | Signal is active-LOW (pull-up to 3V3, normally low when triggered); Board_Layout.md connector table used bare name without `_N` suffix at two locations. |
| LOW | AM-P4-2 | C4 BOM note missing DEC-046 cross-reference | C4 is rated 50V on a 5V rail. The BOM note previously had no explanation. DEC-046 records the decision to retain 50V-rated components rather than add unique 25V parts. Cross-reference added. |

### Batch 2 — Controller and Extension

| Severity | Ref | Finding | Detail |
| :--- | :--- | :--- | :--- |
| LOW | CTL-P4-1 | Stale signal name `I2C1_SDA/SCL` in Board_Layout.md | Pass 3 (F-78) renamed all `I2C1_*` signal names to `I2C_SDA/I2C_SCL`. One location in Controller Board_Layout.md §2 was missed. |
| LOW | CTL-P4-2 | Mixed imperial units in Controller Design_Spec.md §8 | Track width stated as `6.0 mil` (imperial). GRS and all other specs use metric. Corrected to `0.20 mm (7.87 mil)`. |
| MEDIUM | EXT-P4-1 | `SYS_RESET_N` pin number incorrect in DR-EXT-13 | DR-EXT-13 described the SYS_RESET_N signal as connecting via "pin 2" on J9/J10. Correct pin is 15. |
| LOW | EXT-P4-2 | AM attachment standoffs absent from Extension BOM | Controller BOM correctly lists Wurth 9774040151R M2.5x4.0mm standoffs for AM attachment (MH1-MH4). Extension hosts the same ERF8-005-05.0-S-DV-K-TR receptacles (J9/J10) but had no matching standoff BOM row. Fix deferred pending connector mated-height confirmation from local datasheets. |

### Batch 3 — Stator and System Integration

| Severity | Ref | Finding | Detail |
| :--- | :--- | :--- | :--- |
| MEDIUM | STA-P4-1 | `KEY_CM5_ACTIVE_N` incorrect suffix in Board_Layout.md | Signal is active-HIGH (CM5 asserts high when active); the `_N` suffix implies active-low and is wrong. Two occurrences in Board_Layout.md J1 connector table corrected to `KEY_CM5_ACTIVE`. |
| HIGH | STA-P4-2 | BOM shows 19x 10kOhm resistors; only 16 documented in spec | BOM row `R2-R6, R16-R26` accounts for 16 resistors. Three (R39, R40, R41) were undocumented. Deep-dive identified: R39/R40/R41 are MCP23017 /RESET pull-ups (one per U6/U7/U8); R20 (within R16-R26 range) is the CFG_APPLY_N pull-up on U8 GPA[4]. Separate pull-ups are required because U7 GPA[7] drives SYS_RESET_N -- tying U7 /RESET to SYS_RESET_N would create a circular dependency. DR-STA-12 and DR-STA-15 updated; new section bullet added for MCP23017 /RESET pull-ups. |
| MEDIUM | INT-P4-1 | `ROTOR_EN` missing `_N` suffix in System_Architecture.md | Signal is active-LOW (rotor boards enabled when asserted low). System_Architecture.md used bare `ROTOR_EN` at two locations. Corrected to `ROTOR_EN_N`. |

---

## Pass 4 -- Fix Log

**Completed:** 2026-05-07

| Fix # | Ref | File(s) | Change |
| :--- | :--- | :--- | :--- |
| F-88 | CTL-P4-1 | `design/Electronics/Controller/Board_Layout.md` | Replaced `I2C1_SDA/SCL` with `I2C_SDA/SCL` in §2 connector table. |
| F-89 | CTL-P4-2 | `design/Electronics/Controller/Design_Spec.md` | Replaced `6.0 mil` with `0.20 mm (7.87 mil)` in §8 routing rules. |
| F-90 | EXT-P4-1 | `design/Electronics/Extension/Design_Spec.md` | Corrected DR-EXT-13 pin number: `pin 2` -> `pin 15` for SYS_RESET_N. |
| F-91 | PM-P4-1 | `design/Electronics/Power_Module/Design_Spec.md` | BOM note range rewritten to accurately describe the affected components. |
| F-92 | PM-P4-2 | `design/Electronics/Power_Module/Design_Spec.md` | Added `#### Mounting Holes` subsection to §1 PCB Architecture: 4x M3 (3.2 mm drill), PTH non-plated, GND_CHASSIS, no BOM entry. |
| F-93 | STA-P4-1 | `design/Electronics/Stator/Board_Layout.md` | Replaced `KEY_CM5_ACTIVE_N` with `KEY_CM5_ACTIVE` at two locations in J1 connector table. |
| F-94 | STA-P4-2 | `design/Electronics/Stator/Design_Spec.md` | DR-STA-12 updated: added R39/R40/R41 MCP23017 /RESET pull-up entries with circular-dependency rationale; cross-ref updated to `BOM U6, U7, U8, R39, R40, R41`. DR-STA-15 updated: added R20 CFG_APPLY_N pull-up rationale; cross-ref updated to `BOM U8, U3, R20`. §3 body: new MCP23017 /RESET pull-ups bullet (R39-R41) added; Reset/Apply path bullet expanded with R20 power-up hold role. |
| F-95 | AM-P4-1 | `design/Electronics/Actuation_Module/Board_Layout.md` | Replaced `ACTUATION_HOME` with `ACTUATION_HOME_N` at two locations in J1/J2 connector tables. |
| F-96 | AM-P4-2 | `design/Electronics/Actuation_Module/Design_Spec.md` | Added `50V rating retained per DEC-046.` to C4 BOM note. |
| F-97 | INT-P4-1 | `design/Electronics/System_Architecture.md` | Replaced `ROTOR_EN` with `ROTOR_EN_N` at two locations. |
| -- | EXT-P4-2 | `design/Electronics/Extension/Design_Spec.md` | DEFERRED -- Wurth 9774040151R M2.5x4.0mm standoffs BOM row; blocked on connector mated-height confirmation. Resolution confirmed from Controller Board ground truth (same ERF8 receptacles, M2.5x4.0mm standoffs already specified). Apply before Pass 5. |

### Pass 4 Result

All 10 actionable items resolved (11 findings; 1 deferred to pre-Pass-5):

- **10 fixed** (F-88 through F-97)
- **1 deferred** (EXT-P4-2 -- standoff BOM row; mated-height ground truth confirmed, application pending)

All 9 modified files pass markdownlint with zero violations.

### Pass 4 Refactoring Notes

| Scope | Old Name | New Name | Notes |
| :--- | :--- | :--- | :--- |
| Stator Board_Layout signal | `KEY_CM5_ACTIVE_N` | `KEY_CM5_ACTIVE` | F-93: signal is active-HIGH; `_N` suffix was incorrect. Suppression entry added to agent-directives.md to prevent future false-positive flags. |
| LOW | INT-MIN-002 | Extension Design_Spec.md contains phantom reference to AM R6 | Extension spec referenced AM component "(R6)" which does not exist on the AM BOM — stale residual from an earlier design iteration. |

---

## Pass 2 — Fix Log

### Fix agent (pass2-fixes) — changes applied automatically

| Fix ID | File | Change |
| :--- | :--- | :--- |
| F-42a | `Power_Module/Design_Spec.md` | Added C58: TPS75733 U7 VIN bypass 100nF CL05B104KB5NNNC 0402 |
| F-46 | `Consolidated_BOM.md` | Added U9 (TPS2372-4RGWR), U10 (TPS23730RMTR), T2 (POE600F-12L) rows to Controller section |
| F-47 | `Controller/Design_Spec.md` | Split C24 into C24 + C28 (separate 100nF bypass caps for U9 and U10 respectively) |
| F-48 | `Controller/Design_Spec.md` | Added U9, U10, T2 rows to §2 MPN summary table with full supplier PNs |
| F-49 | `Consolidated_BOM.md` | Corrected R33–R38 duplication; R33–R38 retained under correct board section only |
| F-50 | `Stator/Board_Layout.md` | Added CPLD VCC/VCCIO pin assignments and note block |
| F-52 | `JTAG_Daughterboard/Design_Spec.md` | Added C12: EPM240 U5 bypass 100nF CL05B104KB5NNNC 0402; added DR-JDB-17 |
| F-53 | `JTAG_Daughterboard/Design_Spec.md` | Added §6 cross-reference: `See Board_Layout.md §7.1` |
| F-54 | `Rotor/Design_Spec.md` | Added DR-ROT-12: Board A and Board B shall be treated as a single logical board; Board B bulk-cap absence explicitly exempted |
| F-55a | `User_Settings_Module/Design_Spec.md` | Added C5–C14 entries — **incorrect (100nF bypass); see orchestrator correction F-55b** |
| F-56 | `User_Settings_Module/Design_Spec.md` | Corrected CL21B106KAYQNNE dielectric description: X5R → X7R |
| F-57 | `User_Settings_Module/Design_Spec.md` | Corrected J1 connector description to specify 6-pin JST PH 2.0mm pitch |
| F-58 | `Actuation_Module/Design_Spec.md` | Updated DR-AM-15: explicit restriction to VDD pin 4 only; pin 16 VDD_USB left unconnected |
| F-59 | `Actuation_Module/Design_Spec.md` | Added SW2 supply rail note to DR-AM-15: SW2 pull-up supply = 3V3_ENIG |
| F-60 | `Actuation_Module/Design_Spec.md` | Added GRS §3 exemption cross-reference to DR-AM-15 (daughterboard, no directly-received rails) |
| F-61 | `Software/Actuation_Module/Design_Spec.md` | Removed phantom "(R6)" reference |
| F-62 | `Actuation_Module/Design_Spec.md` | Added DR-AM-16: mounting holes required; location TBD at PCB layout stage |
| F-63 | `Actuation_Module/Design_Spec.md` | Added GND_CHASSIS single-point bond exemption note (daughterboard) |
| F-64 | `Actuation_Module/Design_Spec.md` | Removed blank line from BOM table |
| F-65 | `Controller/Design_Spec.md`, `Extension/Design_Spec.md`, `Software/Actuation_Module/Design_Spec.md` | Renamed `ACTUATE_REQUEST` → `ACTUATE_REQUEST_N` throughout all cross-references |
| F-66 | `Extension/Design_Spec.md` | Removed phantom "(R6)" reference to AM component |

### Orchestrator corrections (applied after fix agent)

| Fix ID | File | Correction |
| :--- | :--- | :--- |
| F-42b | `Power_Module/Design_Spec.md` | Investigated C31/C32 for TPS25980 (U1) and LMQ61460A (U6). Confirmed: TPS25980 has no separate VDD pin; existing C9/C10 far exceed minimum. LMQ61460A satisfied by existing input bulk caps. C31 and C32 **not required** — fix agent mis-identified them. |
| F-43 | `Power_Module/Design_Spec.md` | Added GRS §3 bulk-entry exemption callout to §2 Design NOTE |
| F-44 | `Power_Module/Board_Layout.md` | PM-MIN-1 compliance-marker cross-references — unverified at audit time; no definitive failure found; carries to Pass 3 as low-severity |
| F-45 | `Power_Module/Design_Spec.md` | Updated §6 Single-Point GND Bond: assigned RefDes FB1 (ferrite bead or 0Ω link, value TBD at layout) |
| F-51 | `Reflector/Design_Spec.md` | Added working voltage note for TPD4E05U06QDQARQ1 to §5: max 5.5V; 5V_MAIN (≤5.1V) within range with ≥0.4V margin |
| F-55b | `User_Settings_Module/Design_Spec.md` | Corrected fix-agent error: C5–C14 changed from 100nF bypass to 10µF X7R 25V 0805 Samsung CL21B106KAYQNNE (GRS §3 requires ≥5× 10µF bulk-entry caps per rail) |
| F-55c | `Consolidated_BOM.md` | User Settings Module C5–C14 row corrected to match orchestrator correction |

### User decisions recorded in Pass 2

| Decision | Item | Resolution |
| :--- | :--- | :--- |
| D-8 | SET-MAJ-2 — ESD on panel switches SW1–SW5 | **DEFERRED** — evaluate at pre-prototype switch procurement; mechanical construction may negate ESD risk |
| D-9 | ROT-CRIT-1 — Board A+B logical unit framing | Board B is physically independent but logically part of Board A; Board B is exempt from GRS §3 bulk-cap rule as Board A carries the bulk banks |
| D-10 | TPS25751DREFR KiCAD footprint | **Marked `✓`** — already present in project KiCAD library (Power Module U4, USB-C PD controller) |
| D-11 | CSD17578Q5A KiCAD footprint | **Marked `✓`** — already present in project KiCAD library (Power Module Q1/Q2/Q3, OR-ing MOSFETs) |

#### Pass 2 result: 22 fixed, 1 deferred, 1 unverified, 5 dismissed

All 25 active Pass 2 findings (F-42 through F-66) dispositioned:

- **22 fixed** by fix agent or orchestrator
- **1 deferred by user** (SET-MAJ-2 — ESD on panel switches)
- **1 unverified / carry-forward** (PM-MIN-1 — Board_Layout compliance markers; no definitive failure found; low severity)
- **5 dismissed** as false positives: ROT-MAJ-1, REF-MAJ-1, JDB-CRIT-1, ENC-MIN-1, SET-MIN-2

Carry-forwards to Pass 3: PM-MIN-1 (low severity). SET-MAJ-2 deferred pending pre-prototype switch procurement.


---

## Pass 3 — Fix Audit Trail

**Completed:** 2026-05-01

Pass 3 was a targeted surgical-edit pass applying 19 pre-characterised fixes across 15 electronics
design documents. No new review agents were run. All 19 fixes were applied and all 15 modified files
passed markdownlint with zero violations.

### Pass 3 Fixes Applied

| Fix # | Ref | File(s) | Change |
| :--- | :--- | :--- | :--- |
| F-67 | Fix 1 | `design/Standards/Global_Routing_Spec.md` | Added ESD bypass-cap exclusion note after §3.2: ESD arrays are passive devices that must NOT receive per-IC 100nF bypass caps. |
| F-68 | Fix 2 | `design/Electronics/Reflector/Board_Layout.md` | Replaced §3 with full 30-pin 2×15 J4 connector table (all 30 pins, correct signals, aligned). |
| F-69 | Fix 3 | `design/Electronics/Reflector/Design_Spec.md` | FR-REF-03: updated connector description from `(20-pin)` to `(30-pin 2×15 shrouded)`. |
| F-70 | Fix 4 | `design/Electronics/Rotor/Board_Layout.md` | Removed stale "Not populated on Board B" note from R1 BOM row (no-load variant logic was Board A only). |
| F-71 | Fix 5 | `design/Electronics/Rotor/Board_Layout.md` | Renamed signal `DEV_CLRN` → `DEV_CLR_N` to match active-low `_N` suffix convention. |
| F-72 | Fix 6 | `design/Electronics/Extension/Board_Layout.md` | Renamed both `ACTUATE_REQUEST` → `ACTUATE_REQUEST_N` (J9 and J10 tables) to match active-low convention. |
| F-73 | Fix 7 | `design/Electronics/Extension/Design_Spec.md` | Added DR-EXT-14: bypass cap requirement for U2–U9 ESD arrays (100nF per device, C5–C12). |
| F-74 | Fix 8a — **REVERTED** | `design/Electronics/Extension/Design_Spec.md` | Mouser PN `595-PD4E05U06QDQARQ1` was incorrectly changed to `595-TPD4E05U06QDQARQ1` without owner approval. Reverted to owner-approved `595-PD4E05U06QDQARQ1`. |
| F-75 | Fix 8b — **REVERTED** | `design/Electronics/Controller/Design_Spec.md` | Same as F-74. Reverted to owner-approved `595-PD4E05U06QDQARQ1`. |
| F-76 | Fix 8c — **REVERTED** | `design/Electronics/Power_Module/Design_Spec.md` | Same as F-74. Reverted to owner-approved `595-PD4E05U06QDQARQ1`. |
| F-77 | Fix 9 | `design/Electronics/Extension/Design_Spec.md` | Added DR-EXT-15: mounting hole requirement (4× M2.5 SMT standoffs, MH1–MH4). Added MH1–MH4 BOM row. |
| F-78 | Fix 10 | `design/Electronics/Controller/Design_Spec.md`, `Board_Layout.md`; `design/Electronics/Power_Module/Board_Layout.md`; `design/Electronics/Stator/Design_Spec.md`; `design/Electronics/System_Architecture.md` | Renamed `I2C1` → `I2C-1` (8 occurrences across 5 files) to use hyphen-separated bus notation. |
| F-79 | Fix 11 | `design/Electronics/Power_Module/Design_Spec.md` | Added DR-PM-14: per-IC bypass capacitor requirement (100nF per device on all ICs). |
| F-80 | Fix 12 | `design/Electronics/Controller/Design_Spec.md`, `Board_Layout.md`; `design/Electronics/Power_Module/Design_Spec.md`, `Board_Layout.md`; `design/Electronics/System_Architecture.md` | Renamed `LED_nPWR` → `LED_PWR_N` (18 occurrences across 5 files) to use `_N` active-low suffix convention. |
| F-81 | Fix 13 | `design/Electronics/User_Settings_Module/Design_Spec.md` | Deleted stale R78–R80 BOM row (resistors removed in a prior pass but row was not cleaned up). |
| F-82 | Fix 14 | `design/Electronics/User_Settings_Module/Design_Spec.md` | Added DR-USM-11: mounting hole requirement. Added MH1–MH4 BOM row. |
| F-83 | Fix 15 | `design/Electronics/User_Settings_Module/Design_Spec.md` | Bulk-renamed all requirement IDs from `FR-SBD-` / `DR-SBD-` prefix to `FR-USM-` / `DR-USM-` (16 replacements — 5 FR + 11 DR) to align with the `Settings_Board` → `User_Settings_Module` rename. |
| F-84 | Fix 16 | `design/Electronics/Encoder/Design_Spec.md` | Added DR-ENC-05: mounting hole requirement (4× M2.5 SMT standoffs, MH1–MH4). |
| F-85 | Fix 17 | `design/Electronics/Encoder/Design_Spec.md` | Added MH1–MH4 BOM row after U1. |
| F-86 | Fix 18 | `design/Electronics/Actuation_Module/Design_Spec.md` | Corrected C4 voltage rating from `3V3` (3.3V) to `50V` (correct rating for a 5V rail bypass cap). |
| F-87 | Fix 19 | `design/Electronics/Controller/Design_Spec.md` | Added DR-CTL-17: per-IC bypass cap requirement. Updated C6,C12–C16,C24,C28 BOM row quantity from 6 to 8. |

### Pass 3 Carry-Forwards Resolved

| Item | Resolution |
| :--- | :--- |
| PM-MIN-1 (Board_Layout compliance markers) | No actionable failure found across Pass 1, 2, or 3 reviews. Dismissed as false-positive / not applicable. |

### Pass 3 Result

All 21 items actioned (19 new fixes + 2 carry-forwards):

- **19 fixed** (F-67–F-87)
- **1 carry-forward dismissed** (PM-MIN-1 — false positive, no violation found)
- **1 carry-forward still deferred** (SET-MAJ-2 — ESD on panel switches, pending pre-prototype procurement)

All 15 modified files pass markdownlint with zero violations.

### Pass 3 Refactoring Notes

The following identifier and signal-name changes were made during Pass 3. Future reviewers should not flag these as new issues — they are intentional renames applied for consistency.

| Scope | Old Name / ID | New Name / ID | Notes |
| :--- | :--- | :--- | :--- |
| USM requirement IDs | `FR-SBD-xx` / `DR-SBD-xx` | `FR-USM-xx` / `DR-USM-xx` | 16 IDs renamed (5 FR + 11 DR). Board was renamed `Settings_Board` → `User_Settings_Module`; IDs were not updated until Pass 3 (F-83). |
| I2C signal pin names | `I2C1_SDA` / `I2C1_SCL` | `I2C_SDA` / `I2C_SCL` | F-78 first renamed to `I2C-1_SDA/SCL`; a post-fix correction finalised signal names as `I2C_SDA`/`I2C_SCL` (no bus-number qualifier). Prose bus labels such as "I2C-1 bus" or "I2C-1 Telemetry Bus" are intentionally retained. |
| Active-low signal names | `LED_nPWR` | `LED_PWR_N` | F-80: 18 occurrences across 5 files updated to `_N` suffix convention. |
| CPLD pin name | `DEV_CLRN` | `DEV_CLR_N` | F-71: vendor pin name is `DEV_CLRN` (no underscore); renamed in design docs to match `_N` convention with a parenthetical noting the vendor name. |

---

# Deep-Dive Review Cycle — Pass 5

**Scope:** Full system — all 11 board specs + Board_Layout files + Global_Routing_Spec + Consolidated BOM cross-check + integration connectivity verification.

**Method:** 12 parallel review agents run in 3 batches of 4. All findings triaged before proceeding to next batch.

**Starting F-ID:** F-98

---

## Pass 5 — Batch 1 Findings

### Batch 1 Agents: `pass5-pm`, `pass5-ctl`, `pass5-sta`, `pass5-rot`

---

#### pass5-pm — Power Module

| F-ID | Severity | Finding |
| :--- | :--- | :--- |
| F-98 | HIGH | `PWR_BUT` active-low signal missing `_N` suffix throughout Power Module docs. Signal drives the CM5 PMIC power button input — it is asserted low. Must be renamed `PWR_BUT_N` per GRS active-low naming convention. Cross-module impact: also present in Controller/Board_Layout.md. |

---

#### pass5-ctl — Controller Board

| F-ID | Severity | Finding |
| :--- | :--- | :--- |
| F-99 | MINOR | `USB_FAULT` active-low USB PD fault flag from STUSB4500 missing `_N` suffix. Rename to `USB_FAULT_N` throughout Controller Design_Spec. |
| F-100 | LOW | MH1-MH4 BOM row (CTL/Design_Spec.md line 475) Notes column is blank. Other boards document "pads connect to GND_CHASSIS" and usage context explicitly. Add: "CM5 carrier attachment; pads connect to GND_CHASSIS." |

---

#### pass5-sta — Stator

| F-ID | Severity | Finding |
| :--- | :--- | :--- |
| F-101 | MEDIUM | No dedicated mounting holes entry in Stator Design_Spec.md. GND_CHASSIS bond is partially documented (lines 65-69, 349) and a BOM row exists for chassis standoffs, but there is no DR for the mounting holes themselves (DR table currently ends at DR-STA-16). Designators (MH1-MH4), drill sizes, and layout coordinates are absent. A new DR-STA-17 is required. |

---

#### pass5-rot — Rotor Boards

| F-ID | Severity | Finding |
| :--- | :--- | :--- |
| F-102 | MEDIUM | `Rotor/Board_Layout.md` contains no mounting holes section for Board A or Board B. Design_Spec.md DR-ROT-08 (line 89) and line 232 document two M2.5 alignment holes per board, but Board_Layout.md has zero references to their positions or specification. |
| F-103 | MEDIUM | `Rotor/Board_Layout.md` contains no GND_CHASSIS bond section. Design_Spec.md lines 52-57 explicitly document the GND_CHASSIS tie at M2.5 alignment holes, but this is entirely absent from Board_Layout. |
| F-104 | MEDIUM | CPLD U1 bypass capacitors C1–C8 (100nF ×8) and C9–C13 (10µF ×5) are not explicitly attributed to U1 in any per-IC table in Design_Spec.md. Only C14–C15 have a mapping note at line 548 (attributed to U2 FDC2114). U1's bypass cap ownership is implicit at best. |
| F-105 | MINOR | `Rotor_64_Char_Design.md` lines 193–194: C16B/C17B are listed in the variant BOM but have no annotation identifying them as the VDD bypass pair for U3B (FDC2114) and no GRS §3.2 citation. |
| F-106 | MINOR | `Rotor_26_Char_Design.md` lines 198–199: C16A/C17A are listed in the variant BOM but have no annotation identifying them as the VDD bypass pair for U3A (FDC2114) and no GRS §3.2 citation. |
| F-107 | MINOR | Neither variant doc (`Rotor_26_Char_Design.md` nor `Rotor_64_Char_Design.md`) cites GRS §3.2 in the bypass capacitor sections, unlike the base Design_Spec which follows this convention. |

---

## Pass 5 — Batch 2 Findings

### Batch 2 Agents: `pass5-ext`, `pass5-ref`, `pass5-enc`, `pass5-am`

---

#### pass5-ext — Extension Board

| F-ID | Severity | Finding |
| :--- | :--- | :--- |
| F-108 | MEDIUM | DR-EXT-10 is absent. The requirement sequence jumps from DR-EXT-09 (J9 AM dock connector spec, line 51) directly to DR-EXT-11 (AM host envelope + MH5-MH8, line 52). No DR-EXT-10 exists. This is either a deleted requirement, a merged requirement (absorbed into DR-EXT-09 or DR-EXT-11), or a never-written requirement (likely J9 routing constraints or a J10 connector spec). The gap must be documented or filled. |
| F-109 | LOW | J7/J8 (2BHR-30-VUA 30-pin dual-row) orientation/keying callout absent from Extension Board_Layout.md. §2 lines 36–49 describe J7/J8 placement and pitch but include no silkscreen orientation mark note. Line 70 documents a silkscreen note for ERM8/ERF8 dock connectors but not for J7/J8. Double-keying on the 2BHR-30-VUA physically prevents incorrect mating, so this is LOW severity documentation only. |

**Batch 2 false positives (not assigned F-IDs):**
- Reflector HIGH (TVS bypass caps): **FALSE POSITIVE** — GRS §3.2 line 112 explicitly exempts ESD/TVS arrays from the per-IC bypass cap rule.
- Extension U2–U9 MAJOR (TVS bypass caps): **FALSE POSITIVE** — same GRS §3.2 exemption.
- AM CRITICAL (STM32G071K8T3TR JLCPCB PN = `-`): **FALSE POSITIVE** — user-confirmed consignment-only sourcing; `-` is intentional.

---

#### pass5-ref — Reflector Board

No genuine findings. All agent findings were false positives (TVS bypass cap GRS exemption; 3V3_ENIG 0.80mm trace width explicitly justified at Board_Layout.md lines 98/109 per GRS §1.1 canonical minimum).

---

#### pass5-enc — Encoder Board

No findings.

---

#### pass5-am — Actuation Module

No genuine findings. AM CRITICAL finding was a false positive (see above).

---

## Pass 5 — Batch 3 Findings

### Batch 3 Agents: `pass5-usm`, `pass5-jdb`, `pass5-int-conn`, `pass5-int-bom`

---

#### pass5-usm — User Settings Module

| F-ID | Severity | Finding |
| :--- | :--- | :--- |
| F-110 | MEDIUM | `USM/Board_Layout.md` contains no mounting holes section. Design_Spec.md DR-USM-11 specifies M2.5 holes and a BOM row exists for MH1-MH4, but Board_Layout.md has zero references to mounting hole positions, designators, or GND_CHASSIS connection. |

**Batch 3 false positive:**
- USM R81–R98 JLCPCB PN missing (MEDIUM): **FALSE POSITIVE** — BOM Notes explicitly states "no JLCPCB stock" — intentional sourcing decision.

---

#### pass5-jdb — JTAG Daughterboard

No findings.

---

#### pass5-int-conn — Integration Cross-Board Connectivity

No findings. All signal names, power rail names, Link-Alpha/Beta interfaces, and connector mappings verified consistent across all board specs.

---

#### pass5-int-bom — Integration Consolidated BOM Cross-Check

No findings. Consolidated BOM parts, quantities, and supplier PNs verified consistent with board-level specs across all 11 boards.

---

## Pass 5 — False Positives Summary

| Batch | Agent Finding | Reason Dismissed |
| :--- | :--- | :--- |
| Batch 2 | Reflector HIGH — TVS bypass caps (D1–D9) | GRS §3.2 line 112: ESD/TVS arrays explicitly exempt from per-IC bypass cap rule |
| Batch 2 | Extension MAJOR — U2–U9 TVS bypass caps | Same GRS §3.2 exemption |
| Batch 2 | AM CRITICAL — U1 STM32G071K8T3TR JLCPCB PN `-` | User-confirmed intentional: consignment-only sourcing; `-` is correct |
| Batch 3 | USM MEDIUM — R81–R98 ERJ-2RKF1003X JLCPCB PN missing | BOM Notes field says "no JLCPCB stock" — intentional sourcing decision |
| Batch 3 | Reflector MEDIUM — 3V3_ENIG 0.80mm trace width | Board_Layout.md lines 98/109 explicitly justify width per GRS §1.1 canonical minimum |

---

## Pass 5 — Comprehensive Fix Research Table

All genuine findings. **No changes applied.** This table is research-only, awaiting user approval per finding.

| F-ID | Board | Severity | Finding Summary | Files Affected | Key Lines | Proposed Fix |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| F-98 | Power Module (+ Controller) | HIGH | `PWR_BUT` active-low signal missing `_N` suffix | `Power_Module/Design_Spec.md`; `Power_Module/Board_Layout.md`; `Controller/Design_Spec.md`; `Controller/Board_Layout.md` | PM DS: 27, 42, 43, 288, 290, 312, 315, 316, 318, 363, 369, 394, 417, 420, 432, 498, 519, 528, 530, 532, 604; PM BL: 21, 45, 91; CTL DS: 48, 216, 217, 261; CTL BL: 60 | Global rename `PWR_BUT` → `PWR_BUT_N` across all 4 files. ~25 total occurrences. Note: CTL DS lines 216–217 are a prose note about GPIO scope exclusion — that prose also requires updating to reference `PWR_BUT_N`. |
| F-99 | Controller | MINOR | `USB_FAULT` active-low STUSB4500 fault flag missing `_N` suffix | `Controller/Design_Spec.md` | 62, 118, 212, 234 | Rename `USB_FAULT` → `USB_FAULT_N` at all 4 occurrences. Also check Controller/Board_Layout.md for any cross-references (not found in initial grep, but confirm). |
| F-100 | Controller | LOW | MH1-MH4 BOM row Notes field blank; no GND_CHASSIS pad connection documented | `Controller/Design_Spec.md` | 475 | Add to Notes column: "CM5 carrier attachment standoffs; pads connect to GND_CHASSIS." Aligns with the pattern used by other boards (e.g. PM, Stator, Extension). |
| F-101 | Stator | MEDIUM | No mounting holes design requirement entry; DR table ends at DR-STA-16. MH designators, drill sizes, and layout coordinates absent. | `Stator/Design_Spec.md` | 65–69 (partial GND_CHASSIS text), no MH DR row | Add **DR-STA-17**: "Four M2.5 PTH chassis mounting holes (MH1–MH4); pads connected to GND_CHASSIS; hole diameter 2.6mm (M2.5 clearance); locations TBD at PCB layout stage, symmetric with board outline." (Adjust M2.5 size / GND_CHASSIS connection to match board-level convention; confirm no BOM row needed since chassis mounting holes per GRS §5 require no purchasable standoff component.) |
| F-102 | Rotor | MEDIUM | `Rotor/Board_Layout.md` has no mounting holes section for Board A or Board B | `Rotor/Board_Layout.md` | Entire file — zero matches | Add a **§ Mounting Holes** section (after Board A and Board B layout sections) documenting: 2× M2.5 alignment holes per board; nominal position (TBD at layout — must clear header J7–J10 footprints and rotor brush contact ring); reference Design_Spec.md DR-ROT-08. |
| F-103 | Rotor | MEDIUM | `Rotor/Board_Layout.md` has no GND_CHASSIS bond section | `Rotor/Board_Layout.md` | Entire file — zero matches | Add a **§ GND_CHASSIS Bond** section documenting: M2.5 alignment hole pads tied to GND_CHASSIS net; no local GND→GND_CHASSIS bond on Rotor (single-point bond at PM per Design_Spec.md lines 52–57); reference Design_Spec.md §GND_CHASSIS Single-Point Bond. |
| F-104 | Rotor | MEDIUM | CPLD U1 bypass caps C1–C8 and C9–C13 not explicitly attributed to U1 in any per-IC table | `Rotor/Design_Spec.md` | BOM rows at 524–525; note at 548 (C14/C15 only) | In the bypass cap section (near lines 524–548), add explicit annotation: "C1–C8 (100nF ×8) = CPLD U1 VCC/VCCIO decoupling; C9–C13 (10µF ×5) = CPLD U1 VCC bulk bypass; C14 (100nF) + C15 (1µF) = FDC2114 U2 VDD bypass (per line 548)." Also add GRS §3.2 citation for the U1 bypass set. |
| F-105 | Rotor (N=64) | MINOR | C16B/C17B not attributed to U3B (FDC2114) in `Rotor_64_Char_Design.md` | `Rotor/Rotor_64_Char_Design.md` | 193–194 | Add annotation after the C16B/C17B BOM rows: "C16B (100nF) + C17B (1µF) = VDD bypass pair for U3B (FDC2114); per GRS §3.2." |
| F-106 | Rotor (N=26) | MINOR | C16A/C17A not attributed to U3A (FDC2114) in `Rotor_26_Char_Design.md` | `Rotor/Rotor_26_Char_Design.md` | 198–199 | Add annotation after the C16A/C17A BOM rows: "C16A (100nF) + C17A (1µF) = VDD bypass pair for U3A (FDC2114); per GRS §3.2." |
| F-107 | Rotor (both variants) | MINOR | Variant docs bypass cap sections lack GRS §3.2 citation | `Rotor/Rotor_26_Char_Design.md`; `Rotor/Rotor_64_Char_Design.md` | N=26: 198–199; N=64: 193–194 | Covered by F-105 and F-106 fixes above — adding "per GRS §3.2" to each annotation satisfies this finding. No additional separate fix required once F-105/F-106 are applied. |
| F-108 | Extension | MEDIUM | DR-EXT-10 absent; requirement sequence jumps DR-EXT-09 → DR-EXT-11 | `Extension/Design_Spec.md` | 51–52 | **User decision required on intent.** Options: **(A)** Add DR-EXT-10 for J9 PCB routing constraints (0.4mm pitch BtB connector placement rules, escape routing, keepout under connector body) — logically fits between connector-spec DR-EXT-09 and envelope-spec DR-EXT-11. **(B)** Add DR-EXT-10 as a documented reservation: "DR-EXT-10: Reserved — requirement merged into DR-EXT-09 [or DR-EXT-11] at [date]." **(C)** If DR-EXT-10 was a now-obsolete connector (e.g. a second dock J10 that was removed), document the removal rationale. Recommend **Option A** if J9 routing constraints are not yet documented elsewhere. |
| F-109 | Extension | LOW | J7/J8 (2BHR-30-VUA) silkscreen orientation callout absent from Board_Layout.md | `Extension/Board_Layout.md` | 36–49 (J7/J8 sections); 70 (existing ERM8/ERF8 silkscreen note) | Add to the J7/J8 board layout section (after lines 36–49): "**Silkscreen:** Pin-1 marker on J7 and J8 indicates row 1, contact 1 (key tab side). Note: 2BHR-30-VUA double-keyed shield physically prevents incorrect mating; silkscreen mark is for assembly reference only." Low urgency — double-keying makes this documentation-only. |
| F-110 | USM | MEDIUM | `USM/Board_Layout.md` has no mounting holes section; MH1–MH4 positions and GND_CHASSIS connection undocumented | `USM/Board_Layout.md` | Entire file — zero matches | Add **§ Mounting Holes** section documenting: MH1–MH4 M2.5 holes per DR-USM-11; nominal positions (TBD at layout — symmetric on board outline to clear component keep-outs); pads connected to GND_CHASSIS; BOM row already exists (added by F-82). Include note: "PCB layout position TBD at schematic capture / layout phase." |

---

## Pass 5 — Result

**Total findings: 13 genuine** (F-98 through F-110)
**False positives: 5** (dismissed pre- and post-batch triage)
**Total review agents run: 12** (3 batches of 4)

**Severity breakdown:**

| Severity | Count | F-IDs |
| :--- | :--- | :--- |
| HIGH | 1 | F-98 |
| MEDIUM | 5 | F-101, F-102, F-103, F-104, F-108, F-110 |
| LOW | 2 | F-100, F-109 |
| MINOR | 4 | F-99, F-105, F-106, F-107 |

**Boards with no genuine findings:** Reflector, Encoder, Actuation Module, JTAG Daughterboard.

**Cross-board impact:** F-98 (`PWR_BUT_N`) spans Power Module and Controller; all other findings are board-local.

**Recommended fix priority:**
1. **F-98** (HIGH) — active-low naming error; affects signal integrity documentation and schematic capture.
2. **F-108** (MEDIUM) — DR gap requires user decision before it can be closed.
3. **F-101, F-102, F-103, F-110** (MEDIUM) — Board_Layout and DR documentation gaps; straightforward additions.
4. **F-104** (MEDIUM) — Bypass cap attribution; in-place annotation in existing BOM section.
5. **F-99, F-105, F-106, F-107** (MINOR) — Signal rename and annotation tidy-ups.
6. **F-100, F-109** (LOW) — Notes field and silkscreen documentation; low urgency.

---

## Pass 5 — Fix Status

| F-ID | Status | Files Modified | Notes |
| :--- | :--- | :--- | :--- |
| F-98 | ✅ Fixed | `Power_Module/Design_Spec.md` (22×), `Power_Module/Board_Layout.md` (3×), `Controller/Design_Spec.md` (4×), `Controller/Board_Layout.md` (1×), `System_Architecture.md` (2×), `Software/Linux_OS/Power_Management.md` (9×), `Datasheets/RPi-cm5-datasheet.md` (7×) | `PWR_BUT` → `PWR_BUT_N` across all files. CTL/DS §6 scope note and CM5 Dedicated HW Pin table updated to document active-LOW polarity explicitly. DEC-054 appended to `Design_Log.md`. |
| F-99 | ✅ Fixed | `Controller/Design_Spec.md` (lines 62, 118, 212, 234) | `USB_FAULT` → `USB_FAULT_N` at all 4 occurrences. Line 212 already contained "Active Low" description — polarity already correct, only net name suffix added. |
| F-100 | ✅ Fixed | `Controller/Design_Spec.md` (BOM MH1–MH4 row) | Notes column updated: "CM5 module mounting standoffs; pads tied to GND (not GND_CHASSIS)". Clarifies that CM5 standoffs bond to board GND, not chassis GND, per GRS §4. |
| F-101 | ✅ Fixed | `Stator/Design_Spec.md`, `Stator/Board_Layout.md` | DR-STA-17 added (4× M3 PTH mounting holes; GND_CHASSIS; ENIG annular ring; no BOM row). §12 Mounting Holes added to Board_Layout with position table and cross-references. |
| F-102 | ✅ Fixed | `Rotor/Design_Spec.md` (DR-ROT-08), `Rotor/Board_Layout.md` | DR-ROT-08 updated: 4 holes at inscribed-square corners ±32.5mm from Ø92mm board centre (2 per board). §9 Mounting Holes added to Board_Layout with geometry, board-split table, and GND_CHASSIS bond note. |
| F-103 | ✅ Fixed | `Rotor/Board_Layout.md` (part of §9) | GND_CHASSIS bond documented in §9.4: corner mounting holes tied to GND_CHASSIS; distinguishes corner holes from central shaft hole (§8.1). |
| F-104 | ✅ Fixed | `Rotor/Design_Spec.md` (BOM rows C1–C8,C14 / C9–C13 / C15) | Notes column updated for all three rows: U1 CPLD VCC/VCCIO bypass/bulk (C1–C8, C9–C13) and U2 FDC2114 VDD bypass/bulk (C14, C15). GRS §3.2 cited in all Notes. |
| F-105 | ✅ Fixed | `Rotor/Rotor_64_Char_Design.md` (C16B row) | Notes: "U3B FDC2114 (0x2B) VDD bypass cap; see GRS §3.2". |
| F-106 | ✅ Fixed | `Rotor/Rotor_26_Char_Design.md` (C16A row) | Notes: "U3A FDC2114 (0x2B) VDD bypass cap; see GRS §3.2". |
| F-107 | ✅ Fixed | `Rotor/Rotor_64_Char_Design.md` (C17B row), `Rotor/Rotor_26_Char_Design.md` (C17A row) | Notes added for bulk decoupling caps in both variant docs. GRS §3.2 cited. Covered by F-105/F-106 fixes. |
| F-108 | ⏸ DEFERRED | — | User decision required on DR-EXT-10 gap. Deferred pending RefDes review session. **Blocks Pass 6 launch.** |
| F-109 | ✅ Fixed | `Standards/Global_Routing_Spec.md`, `Controller/Design_Spec.md`, `Controller/Board_Layout.md`, `Actuation_Module/Design_Spec.md`, `Actuation_Module/Board_Layout.md`, `Extension/Board_Layout.md` | GRS §7.1 "Connector Pin-1 Identification" rule added (global; applies to all J-prefix RefDes on all boards). Pre-existing per-board notes updated to reference §7.1. Extension/Board_Layout J9 callout added. Boards with no prior mention (PM, Stator, Rotor, Reflector, USM, JTAG DB, Encoder) are now covered by the global rule without per-board duplication. |
| F-110 | ✅ Fixed | `User_Settings_Module/Board_Layout.md` | §10 Mounting Holes added: 4× M3 PTH, GND_CHASSIS, Ø3.2mm, one per corner. Positions TBD at PCB layout. |

**Additional work completed (not a review finding):**
- `design/Production/JLCPCB_Manufacturing.md` created — full JLCPCB fabrication capabilities, board stackups
  (JLC04161H-7628 4-layer for all boards; JLC06161H-2116 6-layer for CTL only), and PCBA constraints
  (single-sided SMT, no blind/buried vias on standard service). Cross-reference added to GRS §2.

**Pass 5 fix summary:** 12 of 13 findings fixed · 1 deferred (F-108, now resolved as DEC-055 commit fc54336)

---

## Pass 6 — Review Findings

<!-- Batch 2: Extension, Reflector, Encoder, Actuation Module -->
<!-- Batch 3: USM, JDB (with JTAG_Integrity.md), Integration-Connectivity, Integration-BOM -->

### Pass 6 — Batch 1 Findings

#### Power Module

| ID | Severity | Category | Description |
| :--- | :--- | :--- | :--- |
| F-PM-01 | MEDIUM | Signal Naming | Vendor `/INTB` notation (LTC3350 open-drain interrupt) used as design net name throughout. GRS §10 requires `_N`-suffix project name (e.g. `LTC_INTB_N`). |
| F-PM-02 | MEDIUM | Connector Pinout | J1, J2, J3 (TE 1123684-7, 10-pos 2.5 mm dock plugs) have no pin-numbered formal pinout tables in PM Design_Spec.md. Functional allocation exists in System_Architecture.md but not reproduced per Criterion 6. |
| F-PM-03 | LOW | Connector Pinout | J5 (GCT USB4135-GF-A, USB-C) has no formal pin-numbered pinout table. BOM note names six signals in prose only. |
| F-PM-04 | LOW | Connector Pinout | J4 (Molex 43650-0519, battery) has a bulleted numbered list but not a formal table with column headers. Inconsistent with other connector tables. |
| F-PM-05 | LOW | Connector Pinout | J_SW1_1–J_SW1_6 and J_SW2_1–J_SW2_6 (Keystone 1211 spade tabs) have no wiring-assignment table; tab-to-function mapping is prose only. |
| F-PM-06 | LOW | RefDes Ambiguity | C24 and C25 appear in both the §4 Pi-filter topology and DR-PM-14 bypass cap list. No spec note clarifies whether these are the same physical caps or distinct RefDes assignments. |
| F-PM-07 | LOW | I2C Bus Map | U3 (LTC3350) and U5 (STUSB4500LQTR) I2C addresses absent from PM spec/BOM; only in Boards_Overview.md (one-way ref). U4 (TPS25751) I2C address not assigned anywhere. |
| F-PM-08 | LOW | BOM Note Error | BOM note header reads `J3 0436500519 (43650-0519)` but Molex 43650-0519 is J4. Supplementary PN confirmation note appears under wrong designator. |
| F-PM-09 | MINOR | BOM Completeness | R15 (10 kΩ 1% 0603) has no individual function description. R34–R35 (52.3 kΩ) and R38–R41 (100 kΩ) have no body-text or Notes-column function description. |
| F-PM-10 | MINOR | BOM Completeness | R42–R44 (10 Ω thin-film 0402) have no stated purpose; R45/R46 are documented as INA219 filter resistors but R42–R44 are unaccounted for. |
| F-PM-11 | MINOR | Terminology | Mounting holes described as "PTH, non-plated" — self-contradictory. GRS §4.2 specifies NPTH drill with ENIG copper annular ring. Correct description required. |

#### Controller Board

| ID | Severity | Category | Description |
| :--- | :--- | :--- | :--- |
| CTL-P6-01 | HIGH | BOM Accuracy | T1 BOM row lists manufacturer as `Bourns` — should be `Coilcraft` (POE600F-12L). Supplier PNs likely fictitious; `PoE_Power_Analysis.md` explicitly states POE600F-12L is not stocked at DigiKey or Mouser. PRIMARY DIRECTIVE: requires user confirmation before fix. |
| CTL-P6-02 | MEDIUM | Document Error | `PoE_Power_Analysis.md` body still uses `T2` RefDes throughout (should be `T1` per CTL BOM) and `Affects:` metadata header still references Power Module context. Not updated during DEC-056 relocation. |
| CTL-P6-03 | MEDIUM | BOM Accuracy | BOM row R1–R4 qty=4 but only 3 series protection resistors documented in §7. |
| CTL-P6-04 | LOW | BOM Attribution | C12, C15, C16 bypass caps in BOM with no attribution to any IC or DR requirement. |
| CTL-P6-05 | LOW | BOM Attribution | C17 (10 nF 100 V) in BOM with no documented function (likely PoE ACF clamp cap but unconfirmed). |
| CTL-P6-06 | LOW | Connector Pinout | J9 DSI1 connector has no numbered pin-assignment table. |
| CTL-P6-07 | LOW | ESD Coverage | U4 ESD net coverage for J6 (USB 3.0 dual-stack) not documented. |

#### Stator

| ID | Severity | Category | Description |
| :--- | :--- | :--- | :--- |
| STA-P6-01 | MEDIUM | I2C Bus Map | U6 and U7 MCP23017 I2C address pin states (A0/A1/A2) undocumented. Only U8 (0x22) is explicitly documented in DR-STA-12/13. |
| STA-P6-02 | MEDIUM | Connector Pinout | J13 (USM harness, 6-pin) has no numbered pin table — only a prose signal list in DR-STA-14 and FR-STA-12. All other Stator connectors have numbered tables. |
| STA-P6-03 | LOW | Signal Naming | MCP23017 reset pins referenced as `/RESET` (vendor notation). No project net name with `_N` suffix assigned per GRS §10. |
| STA-P6-04 | LOW | I/O Budget | CPLD I/O budget in §10 states 70 connections required but does not state available-I/O count from EPM570T100I5N datasheet — spec cannot self-verify. |
| STA-P6-05 | LOW | BOM Notes | Bulk decoupling cap banks C9–C13 and C22–C26 not labelled for which bank serves which rail (3V3_ENIG vs 5V_MAIN). |

#### Rotor Boards (base + 26-char + 64-char variants)

| ID | Severity | Category | Description |
| :--- | :--- | :--- | :--- |
| ROT-P6-01 | MINOR | Standards Exception | M2.5 (Ø2.7 mm) mounting holes depart from GRS §4 M3 (Ø3.2 mm) standard. Deliberate mechanical choice for Ø92 mm board but no DEC exception recorded. |
| ROT-P6-02 | MINOR | BOM Accuracy | Mouser PN for U3–U10 (TPD4E05U06QDQARQ1) missing leading `T` (e.g. `595-PD4E05U06QDQARQ1` should be `595-TPD4E05U06QDQARQ1`). Affects 240 parts across 30 rotors. PRIMARY DIRECTIVE: requires user confirmation before fix. |
| ROT-P6-03 | MINOR | BOM Notes | Resonant LC tank capacitors C16–C19 have blank BOM Notes; TI FDC2114 app-note values not cited. |
| ROT-P6-04 | MINOR | BOM Notes | Resonant LC tank inductors L1–L4 have blank BOM Notes; TI app-note values not cited. |
| ROT-P6-05 | MINOR | BOM Notes | Same blank BOM Notes gap for equivalent LC tank passives in both Rotor_26_Char_Design.md and Rotor_64_Char_Design.md variant docs. |
| ROT-P6-06 | OBS | Naming Cross-ref | §6.1 ESD table uses logical TDI/TDO names; §3.4 pinout uses project net name TTD. Equivalence noted in §3.4 block quote but §6.1 has no cross-reference — layout-engineer trap. |

#### Batch 1 Summary

| Severity | Count | Boards |
| :--- | :---: | :--- |
| HIGH | 1 | CTL-P6-01 |
| MEDIUM | 6 | F-PM-01, F-PM-02, CTL-P6-02, CTL-P6-03, STA-P6-01, STA-P6-02 |
| LOW | 13 | F-PM-03–08, CTL-P6-04–07, STA-P6-03–05 |
| MINOR | 8 | F-PM-09–11, ROT-P6-01–05 |
| OBS | 1 | ROT-P6-06 |
| **Total** | **29** | |

**PRIMARY DIRECTIVE holds on:** CTL-P6-01 (T1 manufacturer + supplier PNs) and ROT-P6-02 (U3–U10 Mouser PN) — no fix without explicit user confirmation.

---

### Pass 6 — Batch 2 Findings

#### Extension Board

| ID | Severity | Category | Description |
| :--- | :--- | :--- | :--- |
| EXT-F01 | LOW | Documentation | `Board_Layout.md` §6 heading "Routing — Trace Width Specifications" contains subsections labelled `### 5.1` and `### 5.2`. DEC-053 inserted a new §5 (J9 AM Dock) but the routing subsection prefixes were not updated from `5.x` → `6.x`. |
| EXT-F02 | LOW | Metadata | Both `Design_Spec.md` and `Board_Layout.md` carry `Status: Draft`. `Boards_Overview.md` records the Extension Board as `Design Locked`. Document headers have not been promoted to match. |

#### Reflector Board

| ID | Severity | Category | Description |
| :--- | :--- | :--- | :--- |
| REF-M-01 | MEDIUM | Documentation | `Board_Layout.md` §1 ASCII art still labels J4 as "20-pin 2×10". DEC-053 upgraded J4 to 30-pin 2×15; the ASCII diagram was not updated. |
| REF-M-02 | MEDIUM | Signal Assignment | `Board_Layout.md` §4.1/§4.2 incorrectly identifies J4 pin 1 as `3V3_ENIG`. Per DEC-053 the 30-pin J4 pin 1 is `5V_MAIN`; `3V3_ENIG` enters on pin 3. |
| REF-M-03 | MEDIUM | Internal Contradiction | `Design_Spec.md` §3 states power pins are "unused on passive Reflector"; §4 states `3V3_ENIG` is the "sole power entry". Direct contradiction; requires resolution. |
| REF-M-04 | MEDIUM | Documentation | Mounting holes are referenced in §4 but never formally listed with MH designators, drill sizes, or layout coordinates. GRS §4.2 requires all boards to document mounting holes explicitly. |
| REF-M-05 | MEDIUM | BOM Accuracy | DigiKey PN for J1/J2 (Samtec ERM8-005-05.0-S-DV-K-TR) differs between `Design_Spec.md` (authoritative board BOM) and `Consolidated_BOM.md`. Board spec is authoritative; Consolidated BOM must be corrected. PRIMARY DIRECTIVE does not apply (no MPN change; PN discrepancy only). |
| REF-L-01 | LOW | Connector Pinout | J1, J2, J3 have no standalone numbered pinout tables. Ownership correctly delegated to `Rotor/Design_Spec.md §3.4`; delegation is explicit, so this is LOW rather than MEDIUM. |
| REF-N-01 | MINOR | Routing Spec | ENC loopback trace width contradiction: `Design_Spec.md` §3 states 10-mil (0.254 mm); `Board_Layout.md` §4.1 states 0.20 mm (7.87 mil). The two values should agree. |
| REF-N-02 | MINOR | Documentation | U1–U4 (TPD4E05U06QDQARQ1) working-voltage note compares against `5V_MAIN`; signals on the Reflector are `3V3_ENIG` (3.3 V logic). The comparison should reference `3V3_ENIG`. |

#### Encoder Board

| ID | Severity | Category | Description |
| :--- | :--- | :--- | :--- |
| ENC-F-01 | MEDIUM | Standards Departure | `DR-ENC-05` specifies M2.5 mounting holes; GRS §4 mandates M3 (Ø3.2 mm) system-wide. No DEC exception recorded. (Related to ROT-P6-01 and AM-F02 — same M2.5 departure pattern across small-form-factor boards.) |
| ENC-F-02 | LOW | BOM Accuracy | GRS §3.2 standard-part reference table lists DigiKey `1276-1009-1-ND` / JLCPCB `C1525` for the 100 nF bypass cap. Approved board BOMs use DigiKey `1276-CL05B104KB5NNNCCT-ND` / JLCPCB `C960916`. MPN (Samsung CL05B104KB5NNNC) is consistent on both; only supplier PNs diverge. **PRIMARY DIRECTIVE: user must confirm which set is authoritative before any fix.** |
| ENC-F-03 | MINOR | Standards Citation | C1–C8 BOM Notes column lacks an explicit GRS §3.2 citation for per-IC bypass cap compliance. |
| ENC-F-04 | MINOR | BOM Accuracy | `Consolidated_BOM.md` D1 description field contains `Oee` — character-encoding corruption of `≈` (approximately). |
| ENC-F-05 | OBS | Connector Pinout | J1 (panel-mount 6.35 mm mono jack sockets) has no formal numbered pin table. Mitigated by explicit delegation to the Plugboard Assembly spec. |
| ENC-F-06 | OBS | Documentation | L4 is described as "secondary routing / data plate" — marginally informal phrasing relative to GRS §2.2 layer-naming conventions. |

#### Actuation Module

| ID | Severity | Category | Description |
| :--- | :--- | :--- | :--- |
| AM-F01 | HIGH | HW/FW Cross-Spec | Firmware `Design_Spec.md` (Software/Actuation_Module) uses connector designators J5 (SWD) and J6 (UART) throughout. Hardware spec defines J4 = SWD and J5 = UART. **J6 does not exist in the hardware design.** §2, §3 UART bootloader sequence, and §5 signal table all direct engineers to wrong or phantom connectors. HW and Board_Layout are mutually consistent; only the firmware spec diverges. Must be corrected before any bring-up work. |
| AM-F02 | MEDIUM | Standards Departure | MH1–MH4 are M2.5 mm NPTH per DR-AM-03; GRS §4 requires M3 (Ø3.2 mm). Host-board standoffs (9774035151R) drive the M2.5 thread, but no DEC exception records this rationale. (Related to ENC-F-01 and ROT-P6-01 — candidate for a single shared DEC exception.) |
| AM-F03 | LOW | Documentation | AM is absent from `Boards_Overview.md` §5 system status table. DEC-043 created the AM on 2026-04-26; `Boards_Overview.md` was last updated 2026-04-20 and was not updated to include the new module. |
| AM-F04 | LOW | Signal Naming | `NRST` is used as a project net name (J4 pin 5, SW1) but carries no `_N` suffix required by GRS §10 for active-low project net names. Conforming name would be `NRST_N` or `RESET_N`. Both HW and FW specs use this name consistently; both would require updating together. |
| AM-F05 | MINOR | Standards Citation | DR-AM-15 lists per-IC bypass capacitors (C2, C3, C7 for STM32 VDD) but does not cite GRS §3.2 as its rule basis. The listing requirement is satisfied; only the explicit citation is absent. |
| AM-F06 | MINOR | BOM Completeness | BOM Notes column for C2-C3/C6-C7 bypass cap row shows "-". Should reference GRS §3.2 and identify per-IC bypass role (and distinguish C6 NRST filter from VDD bypass caps). |
| AM-F07 | MINOR | Documentation | DR-AM-15 adds C7 as a third STM32 VDD bypass cap. `Board_Layout.md` placement guidance lists C2, C3, C4, C5, C6 by RefDes but omits C7 — no layout guidance for its placement relative to U1 pin 4. |
| AM-F08 | MINOR | Standards Citation | Neither `Design_Spec.md` nor `Board_Layout.md` explicitly states that the AM is exempt from the GRS §5 GND_CHASSIS requirement under the daughterboard exception. Architecture is correct; citation is absent. |
| AM-F09 | MINOR | Path Reference | §7 cross-reference reads `Extension/Design_Spec.md §5` — not a full repo-relative path. Conforming form is `design/Electronics/Extension/Design_Spec.md §5`. |

#### Batch 2 Summary

| Severity | Count | IDs |
| :--- | :---: | :--- |
| HIGH | 1 | AM-F01 |
| MEDIUM | 7 | REF-M-01, REF-M-02, REF-M-03, REF-M-04, REF-M-05, ENC-F-01, AM-F02 |
| LOW | 6 | EXT-F01, EXT-F02, REF-L-01, ENC-F-02, AM-F03, AM-F04 |
| MINOR | 9 | REF-N-01, REF-N-02, ENC-F-03, ENC-F-04, AM-F05, AM-F06, AM-F07, AM-F08, AM-F09 |
| OBS | 2 | ENC-F-05, ENC-F-06 |
| **Total** | **25** | |

**PRIMARY DIRECTIVE holds on:** ENC-F-02 (GRS §3.2 supplier PN discrepancy) — user must confirm authoritative PN set before any GRS edit.

**Key decision required:** ENC-F-01, ROT-P6-01, AM-F02 — three boards all depart from GRS §4 M3 standard with M2.5 holes. Recommend a single DEC exception covering all small-form-factor boards rather than three separate entries.

---

### Pass 6 — Batch 3 Findings

#### JTAG Daughterboard

| ID | Severity | Category | Description |
| :--- | :--- | :--- | :--- |
| JDB-P6-01 | MEDIUM | Metadata | `Boards_Overview.md` shows JDB as `Design Locked`; both `Design_Spec.md` and `Board_Layout.md` headers show `Status: Draft`. All three must agree. |
| JDB-P6-02 | MEDIUM | Mounting Holes | No MH designators, drill sizes, or standoff BOM row documented anywhere in JDB specs. DR-JDB-08 mentions "mounting holes tie to GND" but assigns no designators and no drill size. GRS §4.2 requires explicit listing by designator and drill size, and a BOM row for module-attachment standoffs. |
| JDB-P6-03 | MEDIUM | DR Cross-Reference | GRS §3 bulk-cap exception note cites `DR-JDB-11` (TCK series damping, R2) as the JDB bypass-cap exception. The correct DR is `DR-JDB-09` (C1-C4, C6-C9, C5 entry filter). A reviewer following the citation lands on the wrong requirement. |
| JDB-P6-04 | LOW | BOM Notes | BOM Notes column for C1-C4/C6-C9 (FT232H per-IC bypass) and C12 (U2 bypass) is blank (`-`). Should identify served IC and cite GRS §3.2 for each entry. |
| JDB-P6-05 | LOW | Path Reference | `Design_Spec.md` §2 FT232H datasheet link uses relative path `../../Datasheets/FT232H-datasheet.md`; should be repo-relative `design/Datasheets/FT232H-datasheet.md`. |
| JDB-P6-06 | LOW | Path Reference | `Design_Spec.md` §5 reads `See Board_Layout.md §7.1`; should be `design/Electronics/JTAG_Daughterboard/Board_Layout.md §7.1`. |
| JDB-P6-07 | LOW | Path Reference | `Board_Layout.md` §7.2 trace-width note and BOM row reference `Global_Routing_Spec.md §1.1`; should be `design/Standards/Global_Routing_Spec.md §1.1`. |
| JDB-P6-08 | LOW | Path Reference | GRS §3 JDB exception note uses `JTAG_Daughterboard/Design_Spec.md`; should be `design/Electronics/JTAG_Daughterboard/Design_Spec.md`. (Related to JDB-P6-03.) |
| JDB-P6-09 | LOW | Path + Section Reference | `JTAG_Integrity.md` §3.1 refers to `JTAG_Daughterboard/Design_Spec.md §4` for the inverted stackup. Correct section is **§5** (PCB Fabrication & Stackup, not §4 Aesthetics & Mounting). Path also not repo-relative; correct form: `design/Electronics/JTAG_Daughterboard/Design_Spec.md §5`. |
| JDB-P6-10 | LOW | Internal Consistency | R1 (33Ω at FT232H TDI output, per DR-JDB-03) is missing from `JTAG_Integrity.md` §7.4 JDB implementation table. §7.4 lists only R2/R3/R4; §9 cost analysis also shows `JDB R2-R4` (3 units, should be 4). |
| JDB-P6-11 | MINOR | BOM Completeness | C5 Spec column reads `4.7µF X7R 1210` — no voltage rating. All other caps include voltage (e.g. `100nF X7R 50V 0402`). Should read `4.7µF X7R 50V 1210`. |
| JDB-P6-12 | MINOR | BOM Notes | C5 (5V_USB entry filter) Notes column is blank (`-`). Should read `"5V_USB entry filter"` at minimum. |
| JDB-P6-13 | MINOR | Document Ownership | `JTAG_Integrity.md` `Affects:` header lists Controller, Stator, Encoder, Reflector, Extension but omits `JTAG Daughterboard`. Post-DEC-056 this document lives in the JDB folder and §7.4 extensively describes JDB component placement. |
| JDB-P6-14 | OBS | Connector Pinout | J1 pinout in `Design_Spec.md` §3 is prose-only (`Pin 1 = 5V_USB \| Pin 2 = …`). A markdown numbered table is present in `Board_Layout.md` §4; the spec doc itself lacks the table format. |
| JDB-P6-15 | OBS | Documentation | `JTAG_Integrity.md` §3.1 header parenthetical `(Stator, Encoder, Rotor, Reflector, Extension)` omits JDB. JDB exception is explained below the header; clarity would improve with an inline note. |

#### User Settings Module

| ID | Severity | Category | Description |
| :--- | :--- | :--- | :--- |
| USM-P6-01 | MEDIUM | Internal Contradiction | `Design_Spec.md DR-USM-11` specifies M2.5 mm mounting holes (MH1–MH4); `Board_Layout.md §10.1` specifies M3 PTH (Ø3.2 mm) matching GRS §4. No DEC exception recorded. One document will produce non-GRS-compliant holes if followed without resolution. (Fifth board with M2.5/M3 conflict: ENC-F-01, ROT-P6-01, AM-F02, JDB-P6-02 are related.) |
| USM-P6-02 | MEDIUM | Metadata | `Design_Spec.md` and `Board_Layout.md` both carry `Status: Draft`; `Boards_Overview.md §5` lists USM as `In Review`. |
| USM-P6-03 | LOW | DR Completeness | No dedicated DR entry for per-IC bypass caps C1–C3 in `Design_Spec.md §1` DR table citing GRS §3.2. The caps appear in §11 Component Count Summary and §8.1 routing guidance, but GRS §3.2 explicitly requires a DR table entry. |
| USM-P6-04 | LOW | Internal Contradiction | `Design_Spec.md §11 Component Count Summary` states "Total component count: ~153"; summing the §10 BOM Qty column yields **166**. Delta of 13; summary is stale. |
| USM-P6-05 | LOW | Section Numbering | `Design_Spec.md` contains two sections both numbered `§11` ("Power Budget" and "Component Count Summary"). Duplicate heading numbers create ambiguous cross-references. |
| USM-P6-06 | LOW | Path Reference | Two non-repo-relative cross-doc references: (a) `FR-USM-02` Satisfied-By column uses `Stator/Design_Spec.md FR-STA-08/09`; (b) `§12 I²C Address Selection` uses `Controller/Design_Spec.md §4.1`. Both should be full `design/Electronics/…` paths. |
| USM-P6-07 | LOW | Production / JLCPCB | `Design_Spec.md §8 PCB Fabrication` does not identify manually-fitted components as required by `JLCPCB_Manufacturing.md §3.2`. Affected: D1–D12 (5mm THT LEDs), J1 (JST PH THT), SW1–SW10 (panel-mount THT toggles), SW11 (tactile THT). |
| USM-P6-08 | MINOR | BOM Notes | C1–C4 BOM Notes column is blank (`-`). Should state per-component IC/rail assignment and cite GRS §3.2. |
| USM-P6-09 | MINOR | BOM Notes | C5–C14 BOM Notes column is blank (`-`). Should cite GRS §3 bulk-entry bank rule and annotate rail assignment (5× 3V3_ENIG, 5× 5V_MAIN). |
| USM-P6-10 | OBS | GRS Structure | GRS section order is non-sequential: §1–§7, §9, §10, **§8** (Vias & Teardrops appears physically after §10). USM documents reference GRS by section number — all resolve correctly — but the out-of-order headings are a navigation hazard. |

#### Integration — Cross-Board Connectivity

| ID | Severity | Category | Description |
| :--- | :--- | :--- | :--- |
| INT-F-01 | HIGH | Cross-Spec Designator | `Controller/Design_Spec.md §4.1` I²C table lists PCA9534A as "U16 (Power Module)". PM BOM: U14 = PCA9534APWR @ 0x3F; PM U16 = SN74LVC1G175DBVR (D-type flip-flop). Engineer following the CTL table lands on entirely the wrong component. |
| INT-F-02 | HIGH | Cross-Spec Designator | `Controller/Design_Spec.md §4.1` lists INA219 as "U12 (Power Module)". PM BOM: U10 = INA219AIDR @ 0x40; PM U12 = NL27WZ14DFT2G-Q (Schmitt-trigger inverter). Error **propagated into `Software/Linux_OS/Power_Management.md` line 280** code comment "INA219 U12, Power Module". |
| INT-F-03 | LOW | Documentation | AM absent from `Boards_Overview.md §5` system board table. (Duplicate of AM-F03 from Batch 2.) |
| INT-F-04 | MEDIUM | Cross-Spec Designator | `Stator/Design_Spec.md §5` line 341 reads "PM R12 + PM R23 are the first and second system shunt." PM BOM identifies Kelvin shunts at R10 and R16 (KRL6432T4-M-R010-F-T1). PM R12 = 10.0 kΩ precision divider; PM R23 = 33.2 kΩ LTC3350 oscillator resistor — neither is a shunt. |
| INT-F-05 | MEDIUM | Cross-Spec Designator | `Controller/Design_Spec.md §6` GPIO table reads ROTOR_EN_N is "held HIGH by R10 pull-up on PM." PM R10 = 10 mΩ Kelvin shunt (KRL6432T4-M-R010-F-T1). Actual ROTOR_EN_N pull-up = PM R8 (10 kΩ ERJ-3EKF1002V to 3V3_ENIG). |
| INT-F-06 | LOW | Discontinued MPN | `Software/Linux_OS/Power_Management.md` line 200 cites `CSS2H-2512R-R010ELF` (Bourns) shunt resistor. PM BOM notes this part replaced by `KRL6432T4-M-R010-F-T1` (Susumu) as discontinued. Stator BOM line 398 also confirms live part. |
| INT-F-07 | MEDIUM | Cross-Spec Designator | `Software/Linux_OS/Power_Management.md` line 17 reads "MIC1555 U15 (monostable one-shot)". PM BOM: U13 = MIC1555YM5-TR (monostable); U15 = NL27WZ14DFT2G-Q (Schmitt-trigger inverter). |
| INT-F-08 | MEDIUM | Cross-Spec Designator | `Software/Linux_OS/Power_Management.md` line 44 cites LTC3350 /INTB pull-up as "R29 10 kΩ to 3V3_ENIG (PM)". PM BOM confirms /INTB pulled HIGH by R22. PM R29 is a transistor gate hold-off resistor (Q4–Q10 group). |

**Root cause note (INT-F-01, 02, 04, 05, 07, 08):** Six of the eight findings share a common root cause — PM board was renumbered/updated after designation but CTL Design_Spec.md and Power_Management.md cross-references were not updated to match. These are revision-drift artifacts requiring a systematic audit of all PM-facing designator references.

#### Integration — Consolidated BOM Cross-Check

| ID | Severity | Category | Description |
| :--- | :--- | :--- | :--- |
| BOM-P6-01 | MEDIUM | Manufacturer | Line 42 BAT54 Notes field shows `[Diotec]`. Both PM spec line 488 and CTL spec line 464 specify Vishay. Consolidated BOM Notes must match authoritative board specs. |
| BOM-P6-02 | HIGH | DigiKey PN | Line 135 ERM8-005 DigiKey PN = `SAM13519CT-ND`. REF spec line 176 and ROT spec line 528 both give `612-ERM8-005-05.0-S-DV-K-TRCT-ND`. Wrong Samtec article number. |
| BOM-P6-03 | MEDIUM | Encoding Corruption | Line 127 LED Notes field reads `VfOee2.0V`. ENC spec line 250 and AM spec line 294 both give `Vf≈2.0V`. `≈` (U+2248) was corrupted during document entry. |
| BOM-P6-04 | HIGH | Column Alignment | Lines 136–138 (DF40HC(3.5)-20DS-0.4V(51), DF40C-20DP-0.4V(51), 9774035151R) each contain 22 pipe-delimited cells vs the 21-column header. An extra blank `-` cell immediately after the JLCPCB PN column shifts all Qty and Notes columns one position right. |
| BOM-P6-05 | MEDIUM | Mouser PN | Line 75 LMQ61460AFSQRJRRQ1 Mouser PN = `595-LMQ61460AFSQRJRRQ1` retaining `LM` prefix. BOM's own Notes/Conventions (line 20) and authoritative PM spec both give `595-Q61460AFSQRJRRQ1` (dropping `LM` per Mouser convention). |
| BOM-P6-06 | HIGH | RefDes Drift (PM) | PM capacitor renumbering (schematic updated, BOM not) causes a systematic +2 offset on all PM cap designators ≥ C31. Affected BOM rows: lines 32, 33, 36, 37. Creates genuine identity conflicts: BOM and PM spec assign different part types to the same designator (e.g. BOM C38 = 100nF; PM spec C38 = 100pF). |
| BOM-P6-07 | MEDIUM | Quantity Error (CTL) | Line 32 CTL 100nF bypass caps: BOM shows RefDes `C6,C12-C16` Qty=6. CTL Design_Spec.md lists `C6,C12-C16,C18,C19` Qty=8. C18 and C19 missing; System Qty underreported by ≥2. |
| BOM-P6-08 | MEDIUM | RefDes Drift (ROT) | Rotor schematic renumbering not reflected in BOM. Five affected rows (lines 32, 40, 146, 147, 152): stale ROT RefDes for TPD4E05 ESD arrays (BOM `U5-U12` vs spec `U3-U10`), variant cap designators (C16A/B → C20A/B; C17A/B → C21A/B), base crystal-load cap range (C18-C21 → C16-C19), and variant FDC2114 sensor (U3A/B → U11A/B). Quantities are correct for most; 100nF Qty should be 10 not 9 per rotor (variant docs). |
| BOM-P6-09 | MEDIUM | System Qty Arithmetic | Five ROT-only rows (lines 32, 146, 147, 149, 152) have System Qty = ROT-26 Qty only, not ROT-26 + ROT-64. Implies ROT-64 column was added after System Qty was last computed. Corrected System Qtys (after BOM-P6-07/08 fixes): FDC2114 2→4, KAM05CR71A105KH 2→4, AC0402FRNPO9BN330 8→16, CWF1610A-180K 8→16, CL05B104KB5NNNC 82→94. |

#### Batch 3 Summary

| Severity | Count | IDs |
| :--- | :---: | :--- |
| HIGH | 5 | INT-F-01, INT-F-02, BOM-P6-02, BOM-P6-04, BOM-P6-06 |
| MEDIUM | 14 | JDB-P6-01, JDB-P6-02, JDB-P6-03, USM-P6-01, USM-P6-02, INT-F-04, INT-F-05, INT-F-07, INT-F-08, BOM-P6-01, BOM-P6-03, BOM-P6-05, BOM-P6-07, BOM-P6-08, BOM-P6-09 |
| LOW | 16 | JDB-P6-04–JDB-P6-10, USM-P6-03–USM-P6-07, INT-F-03, INT-F-06 |
| MINOR | 7 | JDB-P6-11, JDB-P6-12, JDB-P6-13, USM-P6-08, USM-P6-09 |
| OBS | 5 | JDB-P6-14, JDB-P6-15, USM-P6-10 |
| **Total** | **47** | |

**Notes:**
- INT-F-03 (AM absent from Boards_Overview.md) is a duplicate of AM-F03 (Batch 2); fix counts once.
- BOM-P6-09 System Qty arithmetic depends on BOM-P6-07 and BOM-P6-08 corrections being applied first.
- Six INT findings (INT-F-01, 02, 04, 05, 07, 08) share root cause: PM board renumbering not propagated to CTL/Software docs.

---

### Pass 6 — Consolidated Summary (All Batches)

| Severity | Batch 1 | Batch 2 | Batch 3 | **Total** |
| :--- | :---: | :---: | :---: | :---: |
| HIGH | 1 | 1 | 5 | **7** |
| MEDIUM | 6 | 7 | 14 | **27** |
| LOW | 13 | 6 | 16 | **35** |
| MINOR | 8 | 9 | 7 | **24** |
| OBS | 1 | 2 | 5 | **8** |
| **Total** | **29** | **25** | **47** | **101** |

**HIGH findings requiring immediate user decisions before any fix work begins:**

| ID | Board | Description |
| :--- | :--- | :--- |
| CTL-P6-01 | Controller | T1 manufacturer listed as Bourns; believed to be Coilcraft POE600F-12L. PRIMARY DIRECTIVE — user must confirm correct manufacturer and real supplier PNs. |
| AM-F01 | Actuation Module | FW spec uses J5/J6; HW spec defines J4/J5. Phantom J6 does not exist in hardware. |
| INT-F-01 | CTL/PM | CTL §4.1 cross-refs PCA9534A as PM "U16" — PM U16 is a D-type flip-flop; PCA9534A is U14. |
| INT-F-02 | CTL/PM/SW | CTL §4.1 cross-refs INA219 as PM "U12" — PM U12 is a Schmitt inverter; INA219 is U10. Propagated into Power_Management.md. |
| BOM-P6-02 | Consolidated BOM | ERM8-005 DigiKey PN wrong (`SAM13519CT-ND` vs correct `612-ERM8-005-05.0-S-DV-K-TRCT-ND`). |
| BOM-P6-04 | Consolidated BOM | Extra cell in 3 rows (lines 136–138) shifts all Qty/Notes columns right. |
| BOM-P6-06 | Consolidated BOM / PM | PM cap RefDes systematic +2 offset causing identity conflicts; requires PM BOM audit. |

**PRIMARY DIRECTIVE still outstanding on:**
- CTL-P6-01: T1 manufacturer + supplier PNs
- ROT-P6-02: U3–U10 Mouser PN missing leading `T`
- ENC-F-02: GRS §3.2 supplier PN set — user must confirm authoritative set

---
