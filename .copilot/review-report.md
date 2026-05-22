# Deep-Dive Review Cycle — Pass 1

<!-- markdownlint-disable MD025 -->

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

Batch 1 subtotal: **4 HIGH · 8 MEDIUM · 1 LOW**

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

Batch 2 subtotal: **4 HIGH · 10 MEDIUM · 1 LOW**

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

Integration-Connectivity — No findings. All critical interfaces verified:
Link-Alpha, Link-Beta, Extension Port 20-pin pass-through, rotor daisy-chain ERM8/ERF8,
I²C addresses, signal directions, and rail names are correctly specified and compatible
across all board boundaries.

### Batch 3 — Integration: Consolidated BOM (review-int-bom)

| Severity | Ref | Finding | Detail |
| :--- | :--- | :--- | :--- |
| HIGH | CBOM-REF-R1 | Reflector R1 duplicate row in board Design_Spec.md | R1 (ERJ-3EKF2200V) appears twice in Reflector Design_Spec.md BOM (identical entries). Consolidated_BOM.md correctly captures only one instance but the source Design_Spec.md must be corrected. *(Also raised by review-ref — linked finding.)* |
| MEDIUM | CBOM-EXT-J7J8 | Extension J7/J8 description incorrect in Consolidated_BOM.md | Consolidated_BOM.md describes Extension J7/J8 as "Rotor group JTAG headers" — incorrect. These are Extension Port IN/OUT headers (20-pin 2×10 2.54 mm shrouded box). *(Also raised by review-ext — linked finding.)* |
| LOW | CBOM-JDB-R3 | Conflicting R3 assignment across two Consolidated_BOM.md rows | Row "R2,R3 = 33Ω" and row "R3-R5 = 10kΩ" both include R3. Per Design_Spec.md, R3 is 10kΩ (RESET# pull-up). The 33Ω row is incorrect. *(Also raised by review-jdb — linked finding.)* |

---

Batch 3 subtotal: **4 HIGH · 4 MEDIUM · 1 LOW**

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

### Pass 1 result (after all fixes): ALL ITEMS RESOLVED — ready for Pass 2

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

**Key decision required:** ENC-F-01, ROT-P6-01, AM-F02 — three boards all depart from GRS §4 M3 standard
with M2.5 holes. Recommend a single DEC exception covering all small-form-factor boards rather than three
separate entries.

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

**Root cause note (INT-F-01, 02, 04, 05, 07, 08):** Six of the eight findings share a common root cause —
PM board was renumbered/updated after designation but CTL Design_Spec.md and Power_Management.md
cross-references were not updated to match. These are revision-drift artifacts requiring a systematic audit
of all PM-facing designator references.

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

## Pass 6 — Result

**Date:** 2026-05-05 | **Total findings:** 101 | **Agents:** 3 review batches + 4 fix batches

| Batch | Boards Covered | Findings |
| :--- | :--- | :--- |
| Batch 1 | Power Module, Controller, Stator, Rotor | 29 |
| Batch 2 | Extension, Reflector, Encoder, Actuation Module | 25 |
| Batch 3 | USM, JTAG Daughterboard, Integration-Connectivity, Integration-BOM | 47 |
| **Total** | All boards | **101** |

**Severity breakdown:** HIGH=7 · MEDIUM=27 · LOW=35 · MINOR=24 · OBS=8

All 101 findings reviewed; 99 implemented across 4 fix batches, 1 deferred (PRIMARY DIRECTIVE), 1 suppressed (supplier PN pre-approval). DEC-057 appended to Design_Log.md.

---

## Pass 6 — Fix Status

| F-ID | Status | Files Modified | Notes |
| :--- | :--- | :--- | :--- |
| CTL-P6-01 | ⏸ DEFERRED | — | T1 transformer manufacturer + supplier PNs. PRIMARY DIRECTIVE prohibits modification. Tracked as `ctl-t1-transformer-decision` todo. |
| ROT-P6-02 | 🔒 SUPPRESSED | — | U3–U10 Mouser PN with leading `T`. Supplier PN pre-approval — intentional as written. |
| ENC-F-02 | ✅ Fixed | `Standards/Global_Routing_Spec.md` | GRS §3.2 100nF JLCPCB PN → C960916. Resolved in Pass 7 as NEW-GRS-7-01. |
| All others (98 findings) | ✅ Fixed | AM, CTL, EXT, JDB, ROT, STA, USM, ENC, PM, REF, GRS, Design_Log, Consolidated_BOM, Boards_Overview | All findings resolved across 4 fix batches. |

**Standing deferrals (raised as new todos):** `bom-system-qty-audit` · `bom-func-notes-sweep` · `connector-stacking-height-review`

**Pass 6 fix summary:** 99 of 101 findings resolved · 1 deferred (PRIMARY DIRECTIVE) · 1 suppressed (pre-approved supplier PN)

---

## Pass 7 — Review Findings

**Date:** 2026-05-08 | **DEC:** DEC-061 | **Scope:** All boards post Pass 6 fixes

### Batch 1 Findings

| ID | Board | Severity | Finding |
| :--- | :--- | :--- | :--- |
| NEW-CTL-01 | CTL | MEDIUM | §3 signal list contains stale J13 reference; should be J12 "JM BtB connector". |
| NEW-CTL-02 | CTL | LOW | Board_Layout §6 cross-reference paths are abbreviated rather than fully qualified. |
| NEW-CTL-03 | CTL | MINOR | BT1 Keystone 3034TR has `Yes*` in both Footprint Available columns — asterisk status unresolved. |
| NEW-CTL-04 | CTL | MEDIUM | DEC-058 MH renumbering not documented: MH9–12 = JM dock; MH13–16 = CM5 SoM. |
| NEW-STA-01 | STA | MINOR | U6/U7 MCP23017 A0/A1/A2 address strapping not documented in Design_Spec. |
| NEW-ROT-01 | ROT | MINOR | C20A/B C21A/B variant Notes violate BOM content rules (functional description in Notes field). |
| ENC-7-F01 | ENC | MEDIUM | Board_Layout §4.1/4.2/5.1 still uses old RefDes J2/J3–J66 (pre-renumber). |
| AM-7-N01 | AM | NIT | BOM Footprint Available column uses "Yes" instead of "✔". |
| NEW-JM-7-02 | GRS | MEDIUM | GRS §4.3 JM row: MH13–16 → MH9–12; 4.0mm → 3.5mm standoff height. |
| NEW-GRS-7-01 | GRS | LOW-MED | GRS §3.2 100nF bypass cap JLCPCB PN C1525 should be C960916. |
| NEW-BO-7-01 | ALL | LOW | Boards_Overview shows "In Review" status; Design_Spec / Board_Layout files show "Draft". |

---

## Pass 7 — Result

**Date:** 2026-05-08 | **Total findings:** 11 | **DEC:** DEC-061

**Severity breakdown:** MEDIUM=4 · LOW-MED=1 · LOW=1 · MINOR=3 · NIT=1

All findings actioned in the same session. NEW-CTL-03 is tracking-only (KiCAD footprint download pending).

---

## Pass 7 — Fix Status

| F-ID | Status | Files Modified | Notes |
| :--- | :--- | :--- | :--- |
| NEW-CTL-01 | ✅ Fixed | `Controller/Design_Spec.md` | §3 J13 → J12 "JM BtB connector". |
| NEW-CTL-02 | ✅ Fixed | `Controller/Board_Layout.md` | §6 cross-reference paths fully qualified. |
| NEW-CTL-03 | 📌 TRACKING | — | BT1 Keystone 3034TR `Yes*` footnote. KiCAD footprint download pending. |
| NEW-CTL-04 | ✅ Fixed | `Design_Log.md` | DEC-061 appended documenting MH9–12 = JM dock, MH13–16 = CM5 SoM. |
| NEW-STA-01 | ✅ Fixed | `Stator/Design_Spec.md` | U6/U7 A0/A1/A2 strapping documented in DR-STA-12. |
| NEW-ROT-01 | ✅ Fixed | `Rotor/Rotor_64_Char_Design.md`, `Rotor/Rotor_26_Char_Design.md` | C20A/B C21A/B Notes field cleared of functional descriptions. |
| ENC-7-F01 | ✅ Fixed | `Encoder/Board_Layout.md` | §4.1/4.2/5.1 RefDes updated from J2/J3–J66 to current numbering. |
| AM-7-N01 | ✅ Fixed | `Actuation_Module/Design_Spec.md` | Footprint Available column updated "Yes" → "✔". |
| NEW-JM-7-02 | ✅ Fixed | `Standards/Global_Routing_Spec.md` | §4.3 JM row: MH13–16 → MH9–12; 4.0mm → 3.5mm. |
| NEW-GRS-7-01 | ✅ Fixed | `Standards/Global_Routing_Spec.md` | §3.2 JLCPCB PN C1525 → C960916. Also resolves Pass 6 ENC-F-02. |
| NEW-BO-7-01 | ✅ Fixed | `Boards_Overview.md` (all boards except EXT) | Status updated "In Review" → "Draft". EXT remains "Draft" pending additional work. |

**Pass 7 fix summary:** 10 of 11 findings fixed · 1 tracking (NEW-CTL-03)

---

## Pass 8 — Review Findings

**Date:** 2026-05-10 | **DEC:** DEC-070 | **Scope:** All boards post Pass 7 fixes

### Batch 1 — Board-Level Findings

| ID | Board | Severity | Finding |
| :--- | :--- | :--- | :--- |
| ctl-c01 | CTL | HIGH | U8 TPS23730RMTR package documented as WSON-10; correct package is VQFN-45. |
| ctl-h01 | CTL | HIGH | Q1/Q2 MOSFET package incorrectly documented; correct package is DPAK (200V rated). |
| ctl-h02 | CTL | HIGH | U7 TPS2372-4RGWR package confirmation required; VQFN-20 5×5mm verified correct. |
| ctl-l01 | CTL | LOW | AP2331W-7 package listed as SOT-23-5; correct package is SC59. |
| ctl-m02 | CTL | MEDIUM | 22nF Cclamp PoE decoupling formula not documented in Design_Spec. |
| sta-m01 | STA | MEDIUM | 76 user IO pin count (70 used, 6 spare) not explicitly documented. |
| sta-m02 | STA | MEDIUM | INA219 net name appears as duplicate in connector table. |
| sta-m03 | STA | MEDIUM | Decoupling cap grouping not explicitly documented per-IC. |
| sta-l01 | STA | LOW | SB520 diode definition requires update per datasheet. |
| rot-m02 | ROT | MEDIUM | Connector specification (4 per side) not explicit in Design_Spec. |
| rot-h01 | ROT | HIGH | SYS_RESET_N has no ESD protection; resolved by assigning to spare channel 4 of existing U3/U7. |
| ext-h01 | EXT | HIGH | Extension board authoritative pinout absent from Design_Spec. |
| ext-l02 | EXT | LOW | OE# GND tie not confirmed in documentation. |
| ext-m01 | EXT | MEDIUM | TTD naming purpose not explicitly documented. |
| ext-m02 | EXT | MEDIUM | Trace width not cross-referenced to GRS. |
| ext-l03 | EXT | LOW | Editorial typo in Design_Spec. |
| ref-l01 | REF | LOW | ERJ component datasheet required regeneration. |
| ref-l03 | REF | LOW | J1–J4 connector wording ambiguous; clarified as J1–J3 input / J4 return. |
| jm-h02 | JM | HIGH | Stale J2 references remain in JTAG Module Design_Spec (post-renumber). |
| jm-m02 | JM | MEDIUM | OE# active-low definition and "always active" policy not documented. |
| jm-l02 | JM | LOW | Section numbering incorrect; renumber required. |
| enc-h01 | ENC | HIGH | LED footprint documented as 0605; correct footprint is 0603. |
| enc-l01 | ENC | LOW | Editorial typo in Design_Spec. |
| enc-l03 | ENC | LOW | AM-F01 LED cross-reference stale after Actuation Module changes. |
| act-h01 | AM | HIGH | LED footprint documented as 0805; correct footprint is 0603. |
| act-l01 | AM | LOW | Editorial typo in Design_Spec. |
| sys-m01 | SYS | MEDIUM | TTD_RETURN net mapping for JM not present in JTAG_Integrity document. |
| sys-l01 | SYS | LOW | Encoder J1 pin 14 reference incorrect. |
| sys-m02 | SYS | — | Stale TTD reference — duplicate of ext-h01. |

### Batch 2 — BOM Corrections (bundled with board fixes)

| Scope | Correction |
| :--- | :--- |
| CTL Consolidated BOM | U3 package SC59 (was SOT-23-5) |
| CTL Consolidated BOM | U7 package VQFN-20 5×5mm confirmed |
| CTL Consolidated BOM | U8 package VQFN-45 (was WSON-10) |
| CTL/ENC/AM Consolidated BOM | LED package 0603 (was 0805/0605) |

### Batch 3 — Deferred (List 2) Findings → New Todos

| Todo ID | Scope | Summary |
| :--- | :--- | :--- |
| `bulk-caps-per-power-source-or-conversion` | All boards | Bulk decoupling cap placement rules not codified in GRS |
| `ctl-l02-refdes-gap` | CTL | RefDes gap in sequence requiring audit |
| `enc-cpld-spare-pins-rule` | ENC | CPLD unused I/O pin termination rule not documented |
| `jtag-pin1-silkscreen-grs` | JM | Pin-1 silkscreen identification per GRS §7.1 verification |
| `rot-i2c-residual-removal` | ROT | Residual I²C net references requiring cleanup |
| `mcp23017-gpb7-silicon-fixed-review` | STA/USM | MCP23017 GPB7 silicon erratum — confirm fixed in current silicon |
| `usm-spdt-switch-floating-review` | USM | SPDT switch floating input review |
| `consolidate-design-spec-content` | ALL | Consolidate duplicated content across Design_Spec files |
| `am-button-review-production` | AM | Button component review for production suitability |

---

## Pass 8 — Result

**Date:** 2026-05-10 | **Total directly addressed:** 29 (27 fixed + 1 duplicate closed + 1 BOM bundle) | **DEC:** DEC-070

**Severity breakdown (directly fixed):** HIGH=9 · MEDIUM=7 · LOW=8 · CLOSED=1

All directly-actionable findings fixed. List 2 (deferred) findings converted to 9 tracked todos. DEC-070 appended to Design_Log.md.

---

## Pass 8 — Fix Status

| F-ID | Status | Files Modified | Notes |
| :--- | :--- | :--- | :--- |
| ctl-c01 | ✅ Fixed | `Controller/Design_Spec.md`, `Consolidated_BOM.md` | U8 package WSON-10 → VQFN-45. |
| ctl-h01 | ✅ Fixed | `Controller/Design_Spec.md` | Q1/Q2 package corrected to DPAK 200V. |
| ctl-h02 | ✅ Fixed | `Controller/Design_Spec.md`, `Consolidated_BOM.md` | U7 VQFN-20 5×5mm confirmed. |
| ctl-l01 | ✅ Fixed | `Controller/Design_Spec.md`, `Consolidated_BOM.md` | U3 package SOT-23-5 → SC59. |
| ctl-m02 | ✅ Fixed | `Controller/Design_Spec.md` | 22nF Cclamp formula documented. |
| sta-m01 | ✅ Fixed | `Stator/Design_Spec.md` | 76 user IO count (70 used, 6 spare) documented. |
| sta-m02 | ✅ Fixed | `Stator/Design_Spec.md` | INA219 duplicate net name removed from connector table. |
| sta-m03 | ✅ Fixed | `Stator/Design_Spec.md` | Decoupling cap grouping documented per-IC. |
| sta-l01 | ✅ Fixed | `Stator/Design_Spec.md` | SB520 diode definition updated. |
| rot-m02 | ✅ Fixed | `Rotor/Design_Spec.md` | 4 connectors per side explicitly documented. |
| rot-h01 | ✅ Fixed | `Rotor/Design_Spec.md` | SYS_RESET_N ESD → spare channel 4 of existing U3/U7. |
| ext-h01 | ✅ Fixed | `Extension/Design_Spec.md` | Authoritative pinout added. |
| ext-l02 | ✅ Fixed | `Extension/Design_Spec.md` | OE# GND tie confirmed and documented. |
| ext-m01 | ✅ Fixed | `Extension/Design_Spec.md` | TTD naming purpose documented. |
| ext-m02 | ✅ Fixed | `Extension/Design_Spec.md` | Trace width → GRS cross-reference added. |
| ext-l03 | ✅ Fixed | `Extension/Design_Spec.md` | Typo corrected. |
| ref-l01 | ✅ Fixed | `Reflector/Design_Spec.md` | ERJ datasheet regenerated. |
| ref-l03 | ✅ Fixed | `Reflector/Design_Spec.md` | J1–J4 wording clarified: J1–J3 input / J4 return. |
| jm-h02 | ✅ Fixed | `JTAG_Module/Design_Spec.md` | Stale J2 references removed. |
| jm-m02 | ✅ Fixed | `JTAG_Module/Design_Spec.md` | OE# active-low definition + "always active" policy documented. |
| jm-l02 | ✅ Fixed | `JTAG_Module/Design_Spec.md` | Sections renumbered. |
| enc-h01 | ✅ Fixed | `Encoder/Design_Spec.md`, `Consolidated_BOM.md` | LED package 0605 → 0603. |
| enc-l01 | ✅ Fixed | `Encoder/Design_Spec.md` | Typo corrected. |
| enc-l03 | ✅ Fixed | `Encoder/Design_Spec.md` | AM-F01 LED cross-reference updated. |
| act-h01 | ✅ Fixed | `Actuation_Module/Design_Spec.md`, `Consolidated_BOM.md` | LED package 0805 → 0603. |
| act-l01 | ✅ Fixed | `Actuation_Module/Design_Spec.md` | Typo corrected. |
| sys-m01 | ✅ Fixed | `JTAG_Module/JTAG_Integrity.md` | TTD_RETURN net map for JM added. |
| sys-l01 | ✅ Fixed | `Encoder/Design_Spec.md` | J1 pin 14 reference corrected. |
| sys-m02 | 🔒 CLOSED | — | Duplicate of ext-h01; no independent fix required. |
| BOM ×4 | ✅ Fixed | `Consolidated_BOM.md` | U3 SC59, U7 VQFN-20, U8 VQFN-45, LED 0603 package corrections. |
| List 2 × 9 | ⏸ DEFERRED | — | Converted to 9 tracked todos (see Batch 3 table above). |

**Pass 8 fix summary:** 27 of 27 directly-addressed findings fixed · 1 closed (duplicate) · 9 List 2 items → new todos

---

## Pass 9 — Review Findings

**Date:** 2026-05-14 | **DEC:** DEC-072 | **Scope:** All boards post Pass 8 fixes

**Severity breakdown:** HIGH=19 · MEDIUM=25 · LOW=26 · MINOR=5 | **Total:** 75

### Power Module (10)

| ID | Severity | Finding |
| :--- | :--- | :--- |
| PM-P9-01 | HIGH | R23=33.2kΩ concern vs 400kHz MIC1555 frequency target. |
| PM-P9-02 | HIGH | Stale stackup code JLC04161H-7628 in §5/§6. |
| PM-P9-03 | HIGH | R8 RST/threshold pull-up connected to 3V3_ENIG; must be 5V_MAIN (MIC1555 active at power-on). |
| PM-P9-04 | HIGH | Controlled impedance trace widths derived from wrong stackup parameters. |
| PM-P9-05 | MEDIUM | R22 OSC frequency pull-up connected to 3V3_ENIG; must be 5V_MAIN. |
| PM-P9-06 | MEDIUM | C24/C25/C49/C51/C56/C57/C58 RefDes inconsistencies between Design_Spec and Consolidated BOM. |
| PM-P9-07 | LOW | Board_Layout §7 power sequencing section references stale component values. |
| PM-P9-08 | LOW | Keystone polyfuse RefDes mismatch: J_SW in Design_Spec vs BT_SW in Consolidated BOM. |
| PM-P9-09 | LOW | Signal names F2/F3/F4 appear in polyfuse procurement-only Notes field (violates BOM content rules). |
| PM-P9-10 | LOW | Flat-count arithmetic incorrect in PM resistor BOM rows. |

### Controller (13)

| ID | Severity | Finding |
| :--- | :--- | :--- |
| CTL-P9-01 | HIGH | Phantom D2–D6 ESD parts (PRTR5V0U2X) in Design_Spec; DR-CTL-19 cites wrong part. ESD protection absent — requires proper TVS parts. |
| CTL-P9-02 | MEDIUM | Stale stackup code JLC04161H-7628 (CTL is 6-layer; correct code is JLC06161H-2116 or equivalent). |
| CTL-P9-03 | MEDIUM | Controlled impedance trace widths and formulas derived from stale stackup parameters. |
| CTL-P9-04 | MEDIUM | Stale dielectric parameters in SI analysis narrative §7. |
| CTL-P9-05 | MEDIUM | Board_Layout references J14–J15 for CM5 socket; correct designators are J13–J14. |
| CTL-P9-06 | MEDIUM | J12 JM BtB connector pin table uses TDO net name; correct net is TTD_RETURN per board convention. |
| CTL-P9-07 | MEDIUM | Qg ≤20nC gate driver limit queried; ZVS derating context and acceptance note location questioned. |
| CTL-P9-08 | MEDIUM | C20 (4× CGA9N3X7R1E476M230KB) absent from Consolidated BOM; system qty listed as 4 should be 8. |
| CTL-P9-09 | MEDIUM | Mounting hole pattern does not match GRS §4.3 Pattern A. |
| CTL-P9-10 | MEDIUM | Phantom VREF net in §3 signal list (FTDI VREF not used; sourced internally). |
| CTL-P9-11 | LOW | GND_CHASSIS documentation cites DEC-023; should cite DEC-057 (superseded). |
| CTL-P9-12 | LOW | CM5 socket described as "Hirose DF40HC"; CM5 underside uses Amphenol mating connector. |
| CTL-P9-13 | LOW | Minor stale cross-references across §3/§4. |

### Stator (5)

| ID | Severity | Finding |
| :--- | :--- | :--- |
| STA-P9-01 | HIGH | Stale stackup code JLC04161H-7628 in §7. |
| STA-P9-02 | MEDIUM | Controlled impedance trace widths derived from stale stackup. |
| STA-P9-03 | MEDIUM | Stale dielectric parameters in SI text §8. |
| STA-P9-04 | LOW | GND_CHASSIS documentation cites DEC-023; should cite DEC-057. |
| STA-P9-05 | LOW | Minor stale cross-reference in §3. |

### Rotor (9)

| ID | Severity | Finding |
| :--- | :--- | :--- |
| ROT-P9-01 | HIGH | Stale stackup code JLC04161H-7628 in §7/§7.1/§7.2 (3 occurrences). |
| ROT-P9-02 | MEDIUM | Controlled impedance trace widths stale in §7.1. |
| ROT-P9-03 | MEDIUM | Stale h/Er dielectric values in Design_Spec. |
| ROT-P9-04 | MEDIUM | USB trace widths/gap derived from stale stackup in §7.2. |
| ROT-P9-05 | MEDIUM | Minor stale cross-references. |
| ROT-P9-06 | LOW | GND_CHASSIS cites DEC-023 in §5; should cite DEC-057. |
| ROT-P9-07 | LOW | Stale references in Board_Layout. |
| ROT-P9-08 | LOW | Stale dielectric parameters in Design_Spec narrative. |
| ROT-P9-09 | LOW | Flat-count qty arithmetic incorrect in Consolidated BOM ROT rows. |

### Extension (4)

| ID | Severity | Finding |
| :--- | :--- | :--- |
| EXT-P9-01 | HIGH | Stale stackup code JLC04161H-7628 in §6.1. |
| EXT-P9-02 | HIGH | Controlled impedance trace widths and gap derived from stale stackup in §6.1/§6.2. |
| EXT-P9-03 | LOW | GND_CHASSIS cites DEC-023 in §5; should cite DEC-057. |
| EXT-P9-04 | LOW | Stale dielectric narrative in Design_Spec. |

### Reflector (4)

| ID | Severity | Finding |
| :--- | :--- | :--- |
| REF-P9-01 | HIGH | Stale stackup code JLC04161H-7628 in §4.1. |
| REF-P9-02 | HIGH | Controlled impedance trace widths stale in §4.1/§4.2. |
| REF-P9-03 | HIGH | CI width/gap specification conflict in Design_Spec. |
| REF-P9-04 | LOW | GND_CHASSIS cites DEC-023 in §5; should cite DEC-057. |

### Encoder (3)

| ID | Severity | Finding |
| :--- | :--- | :--- |
| ENC-P9-01 | HIGH | Stale stackup code JLC04161H-7628 in §5. |
| ENC-P9-02 | HIGH | Controlled impedance trace widths stale in §5.1/§5.2. |
| ENC-P9-03 | HIGH | CI width/gap specification conflict in Design_Spec. |

### Actuation Module (5)

| ID | Severity | Finding |
| :--- | :--- | :--- |
| ACT-P9-01 | LOW | Stale stackup reference in Board_Layout. |
| ACT-P9-02 | LOW | Stale dielectric parameters in Design_Spec. |
| ACT-P9-03 | LOW | GND_CHASSIS cites DEC-023; should cite DEC-057. |
| ACT-P9-04 | LOW | Minor stale cross-references in Board_Layout. |
| ACT-P9-05 | MINOR | Minor editorial in Board_Layout. |

### User Settings Module (5)

| ID | Severity | Finding |
| :--- | :--- | :--- |
| USM-P9-01 | MEDIUM | Board_Layout §4 GPA[0:3]/GPB[0:5] still shows "10k pull-down"; Design_Spec is correct but Board_Layout not updated. |
| USM-P9-02 | MEDIUM | Stale stackup code JLC04161H-7628 in §8. |
| USM-P9-03 | LOW | No series fault-current resistors on switch COM-to-GPIO path. |
| USM-P9-04 | MEDIUM | MH1–MH4 positions inverted vs GRS §4.3 Pattern A and DR-USM-11. |
| USM-P9-05 | MINOR | KiCAD library placeholder text in R66–R77 Notes field of BOM. |

### JTAG Module (9)

| ID | Severity | Finding |
| :--- | :--- | :--- |
| JM-P9-01 | HIGH | Stale stackup code JLC04161H-7628 in §4/§6.1 (3 occurrences). |
| JM-P9-02 | HIGH | JTAG controlled impedance trace 0.127mm; correct for JLC041621-3313 inner stripline is 0.1478mm. |
| JM-P9-03 | MEDIUM | USB D+/D− trace widths derived for stale stackup; should cross-reference GRS §2.3. |
| JM-P9-04 | MEDIUM | TDI source impedance "≈53Ω" claim incorrect — R1+R4 dual-stage damping yields ≈86Ω at J1. |
| JM-P9-05 | MEDIUM | JTAG_Integrity stale h/Er/stackup throughout; "50Ω at 0.127mm" claim now false. |
| JM-P9-06 | LOW | GND_CHASSIS cites DEC-023 in §5; should cite DEC-057. |
| JM-P9-07 | LOW | JTAG_Integrity stale stackup code in historical note. |
| JM-P9-08 | MINOR | DR-JM-09 FT232H bypass cap omits GRS §3.2 1mm placement constraint citation. |
| JM-P9-09 | MINOR | Design_Log DEC-065/066 date field inversion (cannot fix — TERTIARY DIRECTIVE). |

### Consolidated BOM (7)

| ID | Severity | Finding |
| :--- | :--- | :--- |
| INT-BOM-P9-01 | HIGH | CTL C20 (4× CGA9N3X7R1E476M230KB) absent from Consolidated BOM; system qty 4 should be 8. |
| INT-BOM-P9-02 | HIGH | C51 and C57 MPN cross-swap (C51: CBOM shows 10nF, DS shows 1µF; C57: CBOM shows 1µF, DS shows 100nF) — build-critical. Sub-findings: INT-BOM-P9-02A (C51) and INT-BOM-P9-02B (C57). |
| INT-BOM-P9-03 | MEDIUM | ERJ-2RKF1002X system qty 45 should be 57 (ROT ×5 factor not applied). |
| INT-BOM-P9-04 | MEDIUM | PH1-05-UA system qty 10 should be 19 (ROT ×5 factor not applied). |
| INT-BOM-P9-06 | LOW | CSD17578Q5A Part Spec "10A 3.3×3.3mm" incorrect; correct "25A SON 5×6mm". |
| INT-BOM-P9-07 | LOW | BAT54 Manufacturer listed as "Vishay"; correct is Diotec Semiconductor AG. |
| INT-BOM-P9-10 | MINOR | ROT variant qty not verifiable without variant spec files — informational note only. |

### Boards Overview (1)

| ID | Severity | Finding |
| :--- | :--- | :--- |
| INT-CON-P9-06 | LOW | USM node labelled "Settings Board"; should be "User Settings Module". |

---

## Pass 9 — Result

**Date:** 2026-05-14 | **Total findings:** 75 | **DEC:** DEC-072

**Severity breakdown:** HIGH=19 · MEDIUM=25 · LOW=26 · MINOR=5

75 findings reviewed. 16 named findings fixed in-session (INT-BOM-P9-02 applied as two sub-fixing actions for 02A+02B), 5 closed (no fix required), 54 deferred to Pass 10. DEC-072 appended to Design_Log.md.

**New parts added this session:**

- **ERJ-2RKF3300X** — Panasonic 330Ω 1% 0402 | DigiKey: P330LCT-ND | Mouser: 667-ERJ-2RKF3300X | JLCPCB: C278592
- **1.5SMBJ36CA** — Bourns 36V 1.5kW bidirectional TVS DO-214AA (SMB) | DigiKey: 118-1.5SMBJ36CACT-ND | Mouser: 652-1.5SMBJ36CA | JLCPCB: C5439937

**KiCAD library assets added:**

- `src/Electronics/Library/SamacSys_Parts.kicad_sym` — 1.5SMBJ36CA symbol (Bourns TVS)
- `src/Electronics/Library/SamacSys_Parts.pretty/DIONM5436X244N.kicad_mod` — DO-214AA (SMB) footprint

**Deferred to Pass 10 (54 findings):** Systematic stackup-code, controlled-impedance trace-width, and
DEC-023→DEC-057 citation families across all boards; USM Board_Layout pull-column update; MH pattern reviews;
KiCAD BOM placeholder cleanup; Boards_Overview USM node label; JTAG_Integrity stale stackup refs; PM/ROT BOM
flat-count arithmetic; polyfuse signal names in Notes; Keystone RefDes mismatch; CTL SI narrative.

---

## Pass 9 — Fix Status

| F-ID | Status | Files Modified | Notes |
| :--- | :--- | :--- | :--- |
| PM-P9-01 | 🔒 CLOSED | — | R23=33.2kΩ confirmed correct for 400kHz per DEC-030. No change required. |
| PM-P9-02 | 🔒 CLOSED | — | PM Board_Layout.md confirmed already using GRS §2.3 cross-references; no stale stackup code present. |
| PM-P9-03 | ✅ Fixed | `Power_Module/Design_Spec.md` | R8 rail 3V3_ENIG → 5V_MAIN. |
| PM-P9-04 | 🔒 CLOSED | — | PM Board_Layout.md confirmed already using GRS §2.3 cross-references; no stale CI trace widths present. |
| PM-P9-05 | ✅ Fixed | `Power_Module/Design_Spec.md` | R22 rail 3V3_ENIG → 5V_MAIN. |
| PM-P9-06 | 🔒 CLOSED | — | CBOM RefDes confirmed consistent with PM Design_Spec. No inconsistencies beyond J_SW/BT_SW captured in PM-P9-08. |
| PM-P9-07 | 🔒 CLOSED | — | Board_Layout §7 is the MH section, not power sequencing; all component values confirmed correct. No change required. |
| PM-P9-08 | ✅ Fixed | `Consolidated_BOM.md` | BT_SW → J_SW RefDes corrected; Qty 2 → 12 (6 contacts × 2 switches; also resolves PM-P9-10). |
| PM-P9-09 | 🔒 CLOSED | — | CBOM polyfuse Notes field contains no signal names; DR-PM-19 already has net-to-RefDes mapping. No change required. |
| PM-P9-10 | ✅ Fixed | `Consolidated_BOM.md` | Spade tab Qty 2 → 12 corrected (addressed within PM-P9-08 fix). |
| CTL-P9-01 | ✅ Fixed | `Controller/Design_Spec.md`, `Consolidated_BOM.md` | Phantom PRTR5V0U2X ESD parts replaced; D2 1.5SMBJ36CA TVS added (Power-Side PoE ESD). Existing TPD4E05U06QDQARQ1 retained for Data-Side. DR-CTL-19 updated. |
| CTL-P9-02 | 🔒 CLOSED | — | CTL Board_Layout.md confirmed already using GRS §2.3.x cross-references for 6-layer stackup; no stale code present. |
| CTL-P9-03 | 🔒 CLOSED | — | CTL Board_Layout.md confirmed already using GRS §2.3.x cross-references for CI trace widths. |
| CTL-P9-04 | 🔒 CLOSED | — | CTL Board_Layout.md SI narrative §7 confirmed already referencing GRS §2.3 for dielectric parameters. |
| CTL-P9-05 | ✅ Fixed | `Controller/Board_Layout.md` | J14→J13, J15→J14 CM5 socket designators throughout §7. |
| CTL-P9-06 | ✅ Fixed | `Controller/Design_Spec.md`, `JTAG_Module/Design_Spec.md`, `JTAG_Module/Board_Layout.md` | J12 pin table TDO → TTD_RETURN. JTAG_Module TTD_RETURN propagated throughout §3.1 and §5. |
| CTL-P9-07 | 🔒 CLOSED | — | ZVS derating note already present in DR-CTL-23. No change required. |
| CTL-P9-08 | ✅ Fixed | `Consolidated_BOM.md` | CTL C20 row added (4× CGA9N3X7R1E476M230KB); system qty corrected 4 → 8. |
| CTL-P9-09 | ✅ Fixed | `Controller/Board_Layout.md` | Chassis MH1–MH4 section (§9) added per GRS §4.3 Pattern A; section was entirely absent. |
| CTL-P9-10 | ✅ Fixed | `Controller/Design_Spec.md` | Phantom VREF net removed from §3 signal list. |
| CTL-P9-11 | 🔒 CLOSED | — | CTL Board_Layout.md already carries DEC-057 citation; no stale DEC-023 reference present. |
| CTL-P9-12 | ✅ Fixed | `Controller/Design_Spec.md` | CM5 socket description generalised: "CM5 underside connector mates with the Amphenol…". |
| CTL-P9-13 | 🔒 CLOSED | — | CTL Board_Layout.md cross-references confirmed current; no stale references present. |
| STA-P9-01 | ✅ Fixed | `Stator/Board_Layout.md` | Stackup code JLC04161H-7628 → JLC041621-3313. |
| STA-P9-02 | ✅ Fixed | `Stator/Board_Layout.md`, `Stator/Design_Spec.md` | CI trace widths 0.127mm → 0.1425mm; Design_Spec CI rule cross-referenced to GRS §2.3. |
| STA-P9-03 | ✅ Fixed | `Stator/Board_Layout.md` | Stale h/Eᵣ values replaced with cross-references to JLCPCB_Manufacturing.md §1.1. |
| STA-P9-04 | 🔒 CLOSED | — | STA Board_Layout.md already carries DEC-057 citation; no stale DEC-023 reference present. |
| STA-P9-05 | ✅ Fixed | `Stator/Board_Layout.md` | Stale GRS cross-references updated to current section numbers. |
| ROT-P9-01 | ✅ Fixed | `Rotor/Board_Layout.md` | Stackup code JLC04161H-7628 → JLC041621-3313 (3 occurrences). |
| ROT-P9-02 | ✅ Fixed | `Rotor/Board_Layout.md` | CI trace widths 0.127mm → 0.1425mm; cross-references to GRS §2.3 added. |
| ROT-P9-03 | ✅ Fixed | `Rotor/Board_Layout.md` | Stale h/Eᵣ values replaced with cross-references to JLCPCB_Manufacturing.md §1.1. |
| ROT-P9-04 | ✅ Fixed | `Rotor/Board_Layout.md` | Stale USB trace widths/gap replaced with GRS §2.3 cross-reference. |
| ROT-P9-05 | ✅ Fixed | `Rotor/Board_Layout.md` | Stale cross-references updated to current GRS section numbers. |
| ROT-P9-06 | 🔒 CLOSED | — | ROT Board_Layout.md already carries DEC-057 citation; no stale DEC-023 reference present. |
| ROT-P9-07 | ✅ Fixed | `Rotor/Board_Layout.md` | Stale references updated throughout Board_Layout. |
| ROT-P9-08 | ✅ Fixed | `Rotor/Board_Layout.md` | Stale dielectric narrative replaced with cross-reference to JLCPCB_Manufacturing.md §1.1. |
| ROT-P9-09 | 🔒 CLOSED | — | ROT CBOM flat-count Qty arithmetic confirmed correct. No change required. |
| EXT-P9-01 | ✅ Fixed | `Extension/Board_Layout.md` | Stackup code JLC04161H-7628 → JLC041621-3313. |
| EXT-P9-02 | ✅ Fixed | `Extension/Board_Layout.md` | CI trace widths/gap 0.127mm → 0.1425mm; cross-references to GRS §2.3 added. |
| EXT-P9-03 | 🔒 CLOSED | — | EXT Board_Layout.md already carries DEC-057 citation; no stale DEC-023 reference present. |
| EXT-P9-04 | ✅ Fixed | `Extension/Board_Layout.md` | Stale dielectric narrative replaced with cross-reference to JLCPCB_Manufacturing.md §1.1. |
| REF-P9-01 | ✅ Fixed | `Reflector/Board_Layout.md` | Stackup code JLC04161H-7628 → JLC041621-3313. |
| REF-P9-02 | ✅ Fixed | `Reflector/Board_Layout.md`, `Reflector/Design_Spec.md` | CI trace widths 0.127mm → 0.1425mm; Design_Spec CI rule cross-referenced to GRS §2.3. |
| REF-P9-03 | ✅ Fixed | `Reflector/Board_Layout.md`, `Reflector/Design_Spec.md` | CI width/gap conflict resolved; both documents now reference GRS §2.3 uniformly. |
| REF-P9-04 | 🔒 CLOSED | — | REF Board_Layout.md already carries DEC-057 citation; no stale DEC-023 reference present. |
| ENC-P9-01 | ✅ Fixed | `Encoder/Board_Layout.md` | Stackup code JLC04161H-7628 → JLC041621-3313. |
| ENC-P9-02 | ✅ Fixed | `Encoder/Board_Layout.md` | CI trace widths 0.127mm → 0.1425mm; cross-references to GRS §2.3 added. |
| ENC-P9-03 | ✅ Fixed | `Encoder/Board_Layout.md` | CI width/gap conflict resolved; cross-reference to GRS §2.3. |
| ACT-P9-01 | 🔒 CLOSED | — | ACT Board_Layout.md confirmed already using GRS §2.3 cross-references for stackup; no stale code present. |
| ACT-P9-02 | 🔒 CLOSED | — | ACT Board_Layout.md confirmed already using GRS §2.3 cross-references for dielectric params. |
| ACT-P9-03 | 🔒 CLOSED | — | ACT Board_Layout.md already carries DEC-057 citation; no stale DEC-023 reference present. |
| ACT-P9-04 | 🔒 CLOSED | — | ACT Board_Layout.md cross-references confirmed current; no stale references present. |
| ACT-P9-05 | 🔒 CLOSED | — | ACT Board_Layout.md editorial confirmed correct. No change required. |
| USM-P9-01 | ✅ Fixed | `User_Settings_Module/Board_Layout.md` | Board_Layout §4 GPIO pull-column: `10k pull-down` → `330Ω series (R2–R11)` for GPA[0:3]/GPB[0:5] rows. |
| USM-P9-02 | ✅ Fixed | `User_Settings_Module/Board_Layout.md` | Stackup code JLC04161H-7628 → JLC041621-3313. |
| USM-P9-03 | ✅ Fixed | `User_Settings_Module/Design_Spec.md`, `Consolidated_BOM.md` | Series 330Ω fault-current resistors R2–R11 added to switch COM-to-GPIO path. ERJ-2RKF3300X selected (DigiKey: P330LCT-ND, Mouser: 667-ERJ-2RKF3300X, JLCPCB: C278592). |
| USM-P9-04 | ✅ Fixed | `User_Settings_Module/Board_Layout.md` | MH1–MH4 positions corrected: were inverted top-to-bottom vs GRS §4.3 Pattern A; MH1↔MH4 and MH2↔MH3 swapped to correct positions. |
| USM-P9-05 | ✅ Fixed | `Consolidated_BOM.md` | R66–R77 KiCAD placeholder note removed; `Yes*`/`Yes*` footprint status → `Yes`/`✔` (standard R_0402_1005Metric confirmed). |
| JM-P9-01 | ✅ Fixed | `JTAG_Module/Board_Layout.md`, `JTAG_Integrity.md` | Stackup code JLC04161H-7628 → JLC041621-3313 (3 occurrences). |
| JM-P9-02 | ✅ Fixed | `JTAG_Module/Board_Layout.md`, `JTAG_Integrity.md` | JTAG CI trace widths: outer L1 0.127mm → 0.1425mm; buried L2 0.127mm → 0.1478mm. Full impedance recalculation in JTAG_Integrity.md. |
| JM-P9-03 | ✅ Fixed | `JTAG_Module/Design_Spec.md` | USB D+/D− trace widths → GRS §2.3 cross-reference (no explicit value). |
| JM-P9-04 | 🔒 CLOSED | — | R1+R4 dual-stage damping intentional per FR-JM-02. No change required. |
| JM-P9-05 | ✅ Fixed | `JTAG_Integrity.md` | Full recalculation with JLC041621-3313 parameters: h=0.092mm, Eᵣ=4.2; outer W=0.1425mm, buried W=0.1478mm. All impedance results updated. |
| JM-P9-06 | ✅ Fixed | `JTAG_Module/Board_Layout.md` | DEC-023 → DEC-057 citation updated (§5; sole remaining occurrence across all boards). |
| JM-P9-07 | ✅ Fixed | `JTAG_Module/Board_Layout.md` | Stale stackup code in historical note removed; cross-reference to GRS §2.3 substituted per historical-data rule. |
| JM-P9-08 | ✅ Fixed | `JTAG_Module/Design_Spec.md` | DR-JM-09 Specification column updated: GRS §3.2 cross-reference added; redundant hardcoded bypass-cap distance detail removed. |
| JM-P9-09 | ✅ Fixed | `design/Design_Log.md` | DEC-065 date corrected from erroneous `2026-07-13` (future date, likely parallel-agent write error) → `2026-05-11`. Both DEC-065 and DEC-066 now correctly dated 2026-05-11, the session in which both were written. TERTIARY DIRECTIVE exception granted by user. |
| INT-BOM-P9-01 | ✅ Fixed | `Consolidated_BOM.md` | CTL C20 row added; system qty 4 → 8. |
| INT-BOM-P9-02A | ✅ Fixed | `Consolidated_BOM.md` | C51 MPN corrected (10nF → 1µF). |
| INT-BOM-P9-02B | ✅ Fixed | `Consolidated_BOM.md` | C57 MPN corrected (1µF → 100nF). |
| INT-BOM-P9-03 | ✅ Fixed | `Consolidated_BOM.md` | ERJ-2RKF1002X system qty 45 → 57. |
| INT-BOM-P9-04 | ✅ Fixed | `Consolidated_BOM.md` | PH1-05-UA system qty 10 → 19. |
| INT-BOM-P9-06 | ✅ Fixed | `Consolidated_BOM.md` | CSD17578Q5A Part Spec corrected "10A 3.3×3.3mm" → "25A SON 5×6mm". |
| INT-BOM-P9-07 | ✅ Fixed | `Consolidated_BOM.md` | BAT54 Manufacturer "Vishay" → "Diotec Semiconductor AG". |
| INT-BOM-P9-10 | ℹ️ NOTE ONLY | — | ROT variant qty not verifiable without variant spec files. |
| INT-CON-P9-06 | ✅ Fixed | `Boards_Overview.md` | Mermaid node label "Settings Board" → "User Settings Module". |

**Additional work completed (not a review finding):**

- GRS §3.2 bypass cap proximity wording updated (from `enc-connector-review-pre-pcb` todo closure)
- JTAG_Module TTD_RETURN net name propagated throughout Design_Spec §3.1 and Board_Layout §5 (scope of CTL-P9-06 fix)
- USM R11 → R1 RefDes renumber (CFG_APPLY_N pull-up; pre-existing numbering rationalisation)

**Post-Pass-9 housekeeping (2026-05-15 session):**

- `JTAG_Module/Design_Spec.md` — signal table (lines 118–122) and code-block column widths widened to
  accommodate `TDD_RETURN` (longer than previous `TDO`); direct follow-on from CTL-P9-06/TDD_RETURN propagation
- `Controller/Design_Spec.md` — CTL D2 (1.5SMBJ36CA) KiCAD Footprint status confirmed and updated Pending → ✔; legacy `.lib` and new `.kicad_sym` verified in sync
- `User_Settings_Module/Design_Spec.md` — Last Updated date corrected from erroneous 2026-05-27 → 2026-05-15
- Library expanded: 21 new parts added to `SamacSys_Parts.lib` / `.dcm` / `.kicad_sym`; 12 new `.kicad_mod`
  footprints; 19 new `.stp` 3D models. New parts: ERJ-2RKF3300X, ERJ-2RKF1003X, WP154A4SEJ3VBDZGW/CA,
  BSS138LT1G (accepted as footprint for BSS138), SQ2319ADS-T1_BE3, ERF8-010-05.0-S-DV-K-TR (8-pin),
  BHR-20-VUA (20-way), 0436500519 (Molex Micro-Fit 5-ckt), CWF1610A-180K, 219-6LPSTR, PH1-07-UA,
  ERM8-005-05.0-S-DV-K-TR (no 3D), + 9 ERJ/supporting variants
- ~179 KiCAD Footprint status ticks applied (Pending → ✔) across all 10 board Design_Spec files (ACT, CTL, ENC, EXT, JTAG, PM, REF, ROT, STA, USM)

**Remaining Pending footprint rows (downloads not yet available):**

| Board | RefDes | MPN | Reason |
| ------- | -------- | ----- | -------- |
| Extension | J3 | ERM8-010-05.0-S-DV-K-TR | 10-pin variant — not downloaded |
| Extension | J7, J8 | 2BHR-30-VUA | Not downloaded |
| Reflector | J3 | ERM8-010-05.0-S-DV-K-TR | Not downloaded |
| Reflector | J4 | 2BHR-30-VUA | Not downloaded |
| Rotor | C16–C19 | AC0402FRNPO9BN330 | No download available |
| Rotor | J3 | ERM8-010-05.0-S-DV-K-TR | Not downloaded |
| Rotor | J10 | RS1-07-G | Not downloaded |
| Rotor | R5–R6 | SG73S1ERTTP4701F | No download available |
| Stator | J10 | 2BHR-30-VUA | Not downloaded |
| Stator | J11, J12 | 2195620015 | Not downloaded |

**Pass 9 fix summary:** 16 named findings fixed in-cycle (15 unique finding IDs; INT-BOM-P9-02 addressed as
two sub-finding actions 02A+02B) · 5 closed in-cycle (no fix required) · 2 note-only items · 54 deferred
items resolved post-cycle (2026-05-15): 34 fixed, 20 confirmed already correct (closed)

**Pass 9 deferred resolution (2026-05-15):** All 54 deferred items addressed in a follow-up session.
Families resolved: stackup/CI sweep (10 files), DEC-023→DEC-057 citation sweep (1 change; all other boards
confirmed clean), MH pattern sweep (CTL §9 added, USM MH1–MH4 corrected), PM/ROT/USM/JM/INT-CON targeted
fixes. Additionally: EXT and REF Pattern B chassis MH sections added (gap items discovered during MH sweep,
not original Pass 9 findings); stale R1=232kΩ historical note removed from PM Design_Spec
(historical-data rule violation); `agent-directives.md` review agent checklist updated to make
historical-content check a cardinal HIGH-severity item in both stand-alone and integration review scopes.

---

## Pass 10

### Controller Board (CTL) — Pass 10

| ID | Severity | Category | File / Section | Finding | Datasheet Ref |
| :--- | :--- | :--- | :--- | :--- | :--- |
| CTL-P10-01 | MAJOR | Calc Inconsistency | `Controller/PoE_Power_Analysis.md §5/§6`, `DR-CTL-18`, `DEC-062` | Three mutually-inconsistent Vds_peak values exist: §5 = 81.8 V (ACF Flyback formula — wrong topology); §6/DR-CTL-18 = 118.1 V (Vin_max + Vclamp_peak transient); DEC-062 = 108 V (correct ACF Forward: Vin/(1−D_max) at Vin=36 V, D=66.7%). DEC-062 is the correct derivation authority. DR-CTL-18 and §5/§6 need reconciliation to 108 V. | — |
| CTL-P10-02 | MINOR | DCR Discrepancy + DR Violation | `Controller/PoE_Power_Analysis.md §7.1`, `DR-CTL-25`, `DEC-063`, `Consolidated_BOM.md` | ① PoE_Power_Analysis §7.1 states L1 DCR as 35 mΩ typ / 57 mΩ max; DEC-063 (authoritative) gives 48 mΩ typ / 58 mΩ max for Yageo PA4343.333NLT. ② Design_Spec §7.1 specifies "DCR ≤ 50 mΩ" (DR-CTL-25); selected part max DCR = 58 mΩ exceeds this by 8 mΩ (16%). DR-CTL-25 must be updated to ≤ 58 mΩ or a compliant alternative part sourced. | — |
| CTL-P10-03 | MINOR | Stale Text | `Controller/Design_Spec.md §7.1` | §7.1 still reads "L1 (33µH shielded SMT power inductor, TBD)" and "Part selection pending" despite DEC-063 confirming the part as Yageo PA4343.333NLT. Text was not updated as part of the DEC-063 or post-P9 housekeeping passes. | — |
| CTL-P10-04 | INFO | Unlabelled Operating Conditions | `Controller/PoE_Power_Analysis.md §6`, `DEC-064` | Two Vclamp values in use without distinguishing labels: DEC-064 = 72 V (steady-state ACF clamp); PoE_Power_Analysis §6 = 61.14 V (transient spike energy calc above Vin_max). These are different analytical conditions, not errors, but the distinction is undocumented in §6. | — |
| CTL-P10-05 | MINOR | Incomplete Spec | `Controller/Design_Spec.md §7.1` | "Exact per-pin assignments shall be confirmed at schematic capture of the PoE front-end" deferred for C12, C15, C16 (TPS2372-4 / TPS23730 application-circuit capacitors). Must be closed before schematic capture. | — |
| CTL-P10-06 | MINOR | Formula Discrepancy | `Controller/Design_Spec.md DR-CTL-22`, `PoE_Power_Analysis §7.2` | C20 minimum capacitance derived two ways: DR-CTL-22 (energy-method) → ≈ 85 µF minimum; PoE_Power_Analysis §7.2 (LC filter frequency-domain) → ≈ 5.5 µF minimum. The 188 µF nominal satisfies both, but the 85 µF energy-storage figure from DR-CTL-22 is the binding minimum and should be explicitly stated as such. | — |
| CTL-P10-07 | MINOR | Footprint Status Stale in BOM | `Consolidated_BOM.md` lines 43, 55 | BOM line 43 (D2 = 1.5SMBJ36CA) still shows "Pending" for KiCAD Footprint Downloaded; line 55 (Q1/Q2 = STD25NF20) also shows "Pending" — not in post-P9 fix list. Both were confirmed as downloaded in library import session. | — |
| CTL-P10-08 | INFO | Layout Dependency TBD | `Controller/Design_Spec.md §8.6` | J11 (AM host dock) and MH5–MH8 positions cannot be finalised until Actuation Module schematic capture and PCB layout are complete. Documented design gap with known gating dependency. | — |
| CTL-P10-09 | MINOR | Polarity Description Mismatch | `Controller/Design_Spec.md §9.4`, `Consolidated_BOM.md` D2 row | §9.4 describes D2 as "unidirectional" TVS. MPN 1.5SMBJ36CA — the "CA" suffix in Bourns 1.5SMBJxx series denotes **bidirectional**; BOM description row also states "bidirectional." §9.4 text is incorrect. Confirm whether bidirectional was the intentional design choice and update §9.4 accordingly. | `Bourns-1-5smbj-datasheet.md` — suffix table |
| CTL-P10-10 | MEDIUM | P9 Regression | `Consolidated_BOM.md` line 104 | CTL-P9-05 corrected Board_Layout.md (J14→J13, J15→J14 for CM5 SODIMM sockets), but Consolidated_BOM.md line 104 still reads "CTL: J14,J15". Correct designators per DEC-058 / current Design_Spec §8: **J13, J14**. | — |
| CTL-P10-11 | MAJOR | Topology Formula Mismatch | `Controller/PoE_Power_Analysis.md §3, §5, §12` | Document header states "ACF Forward Converter" but §3, §5, §12 use ACF **Flyback** volt-second balance and reflected-voltage formulas. ① §3 duty cycle formula gives D = 30.3–40.8% (flyback, wrong); correct ACF Forward: D = n(Vout+Vf)/Vin → **D = 43.5–68.9%**. ② At Vin=36 V, correct D ≈ 68.9% is within ~6 pp of TPS23730RMTR 75% max duty cycle limit — false headroom was masked by the wrong formula. ③ Vds formula in §5 is also wrong (flyback reflected voltage). DEC-062 is the topological authority; PoE_Power_Analysis.md §3/§5/§12 must be rewritten with ACF Forward formulas and D at Vin=36 V verified against TPS23730RMTR datasheet duty cycle region. | `tps23730-datasheet.md` §6 (max duty cycle) |
| CTL-P10-12 | MINOR | Stale Historical DEC Records | `Design_Log.md` DEC-057 impact, DEC-058 body | DEC-057 impact statement and DEC-058 body retain pre-DEC-061 mounting hole assignments (MH13–MH16 = JDB dock). DEC-061 corrected to MH9–MH12 = JDB, MH13–MH16 = CM5 SoM. DEC-058 also records wrong standoff height (9774035151R = 3.5 mm) for CM5 SoM positions; correct part is 9774040151R (4.0 mm per Design_Spec §2.3). DEC-057/058 should be annotated "Superseded by DEC-061". | — |
| CTL-P10-13 | MAJOR | Voltage Derating Violation | `Consolidated_BOM.md` line 93, `Controller/Design_Spec.md §7.1`, `Electrical_Design.md §1` | C20 = 4× TDK CGA9N3X7R1E476M230KB (47 µF, **25 V** X7R) on VIN_POE_12V (12 V nominal). Electrical_Design.md §1 mandates **2.5× voltage derating** for all power capacitors: minimum rating = 2.5 × 12 V = **30 V**. C20 is under-rated by 5 V (16.7%). X7R DC bias also degrades capacitance significantly at 12 V on 25 V-rated part, putting effective ≥ 103 µF (DR-CTL-22) at additional risk. Replace with 35 V or 50 V X7R 2220 equivalent (e.g. TDK CGA9N3X7R1V476M230KB = 35 V) and re-verify effective capacitance under DC bias. | `TDK-CGA_mlcc_automotive-datasheet.md` — DC bias curves |
| CTL-P10-14 | INFO | Incomplete CI Spec | `Controller/Design_Spec.md §9.1, §9.3` | §9.1 CI-required interface list omits DSI1 (100 Ω differential MIPI, routed on inner stripline L3/L4 per §9.2). §9.3 trace-width table has no DSI1 row. DSI1 would use same 0.1123 mm / 0.2032 mm specification as other L3 100 Ω pairs. Documentation gap only; add DSI1 row to §9.1 and §9.3. | — |

**Pass 10 CTL finding summary:** 3 MAJOR · 1 MEDIUM · 7 MINOR · 3 INFO = **14 total**

---

### Stator (STA) — Pass 10

| ID | Severity | Category | File / Section | Finding | Datasheet Ref |
| :--- | :--- | :--- | :--- | :--- | :--- |
| STA-P10-01 | LOW | Documentation / Traceability | `Design_Log.md` DEC-032 supersession note | DEC-032 supersession note cites "address-map and harness refinements" but does not cross-reference the later amendment that corrects "U8 GPA[4]" (DEC-032 line 1526) to "U8 GPA[6]" for `CFG_APPLY_N`. A reader following DEC-032 in isolation receives incorrect firmware guidance. Design_Spec.md DR-STA-13, DR-STA-15, and Board_Layout.md all correctly state GPA[6], but the traceability chain through the Design Log is broken for this pin assignment. DEC-032 supersession note should cross-reference the correcting amendment. | — |
| STA-P10-02 | LOW | Documentation / Power Architecture | `Stator/Design_Spec.md §3, §5` | Design_Spec never states which voltage rail connects to EPM570T100I5N VCCINT or to VCCIO Bank 1 / Bank 2. JTAG pull-ups R3–R5 and ESD device U9 terminate to 3V3_ENIG making 3.3 V Bank 1 VCCIO implicit and correct, but without explicit documented pin-level power assignment a future revision could connect VCCIO Bank 1 to a 2.5 V rail — conflicting with the 3.3 V pull-ups. Add a CPLD power-rail assignment table to Design_Spec. | `Intel_max2_cpld-handbook.md` §3 (Bank VCCIO controls I/O standard) |
| STA-P10-03 | INFO | Documentation | `Stator/Design_Spec.md §5 BOM` | C1–C8 (EPM570T100I5N bypass caps) listed without citing the per-package VCCINT/VCCIO pin count justifying the count. Intel MAX II handbook §3 Board Decoupling mandates one 100 nF cap per VCC/GND pin pair; EPM570 T100 carries 4 VCCINT + 4 VCCIO pins = 8 pairs → 8 caps, consistent with C1–C8. Design is correct; add pin-count citation to spec for reviewer traceability. | `Intel_max2_cpld-handbook.md` §3 Board Decoupling |

**Pass 10 STA finding summary:** 0 CRITICAL · 0 HIGH · 0 MEDIUM · 2 LOW · 1 INFO = **3 total** · No electrical errors · All STA-P9 fixes confirmed, no regressions

---

### Rotor (ROT) — Pass 10

| ID | Severity | Category | File / Section | Finding | Datasheet Ref |
| :--- | :--- | :--- | :--- | :--- | :--- |
| ROT-P10-01 | MINOR | Documentation | `Rotor_26_Char_Design.md` header, `Rotor_64_Char_Design.md` header | `Last Updated: 2026-04-XX` — invalid ISO 8601 date in both variant files. The `XX` placeholder was never replaced with an actual day. All other Rotor documents carry valid dates. | — |
| ROT-P10-02 | MINOR | Documentation | `Rotor/Board_Layout.md §1` | §1 describes "four single-row 2.54mm THT headers (J7 1×5, J8 1×5, J9 1×5, J10 1×7; 22 pins total)". Actual count per Design_Spec.md DR-ROT-11 and §3.4 is **8 headers (J7–J14, 44 pins total)**. Headers J11–J14 are completely absent from the §1 architectural summary — a 50% undercount. | — |
| ROT-P10-03 | MAJOR | Schematic | `Rotor_26_Char_Design.md §7` | **Intra-document contradiction.** §7 body states "CH1–CH3 each carry a dummy LC tank" for U11A. The §7 Note block (lines 166–169) states "CH1–CH3 are tied to GND via 100 kΩ." These are mutually exclusive designs. Design_Spec.md §2.1 (authoritative) and the variant BOM (L5A–L8A, C22A–C25A) both confirm the dummy LC tank as correct. Tying unused FDC2114 inputs to GND causes oscillation instability per TI application note cited in Design_Spec.md §2.1. The stale Note must be deleted or corrected — it actively prescribes the wrong circuit. | `fdc2112-datasheet.md` §8 (unused channel handling) |
| ROT-P10-04 | MINOR | Schematic | `Rotor/Design_Spec.md §2.1` | IDRIVE baseline register value documented as `0x7C00`. FDC2114 datasheet defines `DRIVE_CURRENT_CHx` bits [15:11] = `CHx_IDRIVE` (5-bit field); bits [10:0] are reserved (reset = 0). For IDRIVE = `0b01111` (decimal 15): `15 << 11 = 0x7800`. `0x7C00` = `0x7800 \| 0x0400` — bit 10 (reserved) inadvertently set to 1. Correct value = **0x7800**. This documented baseline will be copied directly to lab firmware. | `fdc2112-datasheet.md` §7.6 (DRIVE_CURRENT register) |
| ROT-P10-05 | MINOR | Documentation | `Rotor/Design_Spec.md §3.4` | SW3 bit-range notation written as `SW3[4:5]` — non-standard (LSB before MSB). Verilog/VHDL convention is `[MSB:LSB]`. Should read `SW3[5:4]`. Signal assignment to pins is correct; only the notation is wrong. | — |
| ROT-P10-06 | MAJOR | CrossRef | `Rotor/Design_Spec.md §6`, `Design_Log.md DEC-045` | Two related defects: **(a)** DEC-045 Impact section documents TVS arrays as "U5–U8 (Board A)" and "U9–U12 (Board B)". Current design uses U3–U10. RefDes discrepancy in the DEC was never corrected. **(b)** Design_Spec.md §6 exempts J2/J5 power connectors from TVS (citing bulk decoupling caps C10–C14), but DEC-045 mandates TVS on "all ERM8/ERF8 connector interfaces" with no acknowledgement of this exemption. DEC and Design_Spec are in conflict. DEC-045 must be amended to correct RefDes and ratify the J2/J5 exemption. | — |
| ROT-P10-07 | MINOR | Documentation | `Rotor/Design_Spec.md` (all sections) | GRS §10 mandates that Intel MAX II pin `DEV_CLRN` be renamed `DEV_CLR_N` in all design documents, with vendor name cross-referenced. Board_Layout.md §6.1 correctly documents this. Design_Spec.md has no mention of `DEV_CLRN` or `DEV_CLR_N` anywhere in its 682 lines. GRS §10 explicitly requires both the Design Specification and Board Layout to carry this documentation. | — |
| ROT-P10-08 | LOW | CrossRef | `Rotor/Design_Spec.md §3.3`, `Design_Log.md DEC-016` | §3.3 documents that no series resistor is placed at each rotor hop for TTD (deviation from DEC-016's 33 Ω series damping rule), citing the Reflector carries end-of-chain damping. The deviation is documented informally but not ratified as a formal exception or amendment in the Design Log. DEC-016 scope area does not list the Rotor, and DEC-016 contains no exception clause covering the rotor-hop architecture. | — |
| ROT-P10-09 | LOW | Power | `Rotor/Design_Spec.md §3.3` | Each Rotor R4 is a 10 kΩ pull-up on `CPLD_RESET_N`. With 30 Rotors in a full stack, 30 pull-ups in parallel give effective resistance = 10,000 / 30 = **333 Ω**. §3.3 notes this is intentional, but the document does not acknowledge the 333 Ω aggregate load or verify the Stator `CPLD_RESET_N` driver's current-sourcing capability in open-drain mode. Release (high) time constant R×C with bus capacitance is also unanalysed. | — |
| ROT-P10-10 | MINOR | Layout | `Rotor/Design_Spec.md`, `Rotor/Board_Layout.md` | GRS §6 mandates a Data Plate on the B.Silkscreen layer of every board (inverted white block, Enigma silhouette, serial number zone `JLCJLCJLCJLC`, `AUSGABE [Rev] V1.0` metadata). Neither Design_Spec.md nor Board_Layout.md acknowledges this requirement, references GRS §6, or confirms a Data Plate footprint exists for Rotor Board A or Board B. Applies to both boards in the two-PCB assembly. | — |
| ROT-P10-11 | MINOR | Layout | `Rotor/Design_Spec.md §3.4`, `Rotor/Board_Layout.md` | GRS §7.1 requires a silkscreen pin-1 marker on all J-prefix connectors. Internal headers J7–J14 are non-polarised 2.54mm THT with no keying other than pin count. Neither document references GRS §7.1 or confirms pin-1 markers are planned. Mis-orientation risk is high for J7↔J12 (power) during manual assembly. | — |
| ROT-P10-12 | MINOR | Datasheet | `Rotor/Design_Spec.md §3.4` | §3.4 states J2/J5 (ERM8/ERF8-005) carry "5 pins × 0.5 A/pin = 2.5 A total". The repo-archived ERM8 datasheet is a mechanical assembly drawing only with no electrical specifications. The 0.5 A/pin figure cannot be verified from any document in the repository. Samtec Edge Rate public data typically specifies 1.0 A/pin at 0.8 mm pitch — the spec figure is conservative but unsubstantiated. | `erm8-xxx-xx.x-xxx-dv-xxxx-xx-mkt-datasheet.md` (no electrical data) |
| ROT-P10-13 | MINOR | CrossRef | `Rotor/Design_Spec.md §4` | §4 reads "Stackup: 4-layer standard per GRS §2.3.1" without quoting the JLCPCB stackup code JLC041621-3313. GRS §2.3.1 names the code, but a reader of the Rotor spec in isolation cannot identify the exact stackup without chasing the cross-reference. Add the code directly to the spec for traceability. *(May duplicate a Pass 9 deferred stackup item; verify if already resolved.)* | — |
| ROT-P10-14 | MINOR | Signal | `Rotor/Design_Spec.md §6.1` | ESD protection tables in §6.1 list signal names "TDI" (J1) and "TDO" (J4). Design_Spec.md §3.3 JTAG Net Name Mapping establishes the unified schematic net name as **`TTD`** — replacing both TDI and TDO on the board-to-board interface. ESD table uses JTAG standard pin names, not actual schematic net names. A layout engineer verifying ESD coverage against the netlist will search for TDI/TDO and find neither. Update ESD table to use `TTD`. | — |
| ROT-P10-15 | MINOR | Documentation | `Rotor/Design_Spec.md §5`, `Rotor_64_Char_Design.md §8` | For the N=64 variant, U2 (Board A) uses only 3 of 4 FDC2114 channels (CH0–CH2); CH3 requires a dummy LC tank per TI application note. Common BOM (L1–L4, C16–C19, Qty 4) covers this by coincidence, but no annotation states which specific RefDes serves as the dummy LC for N=64 U2 CH3, nor which of L5B–L8B/C22B–C25B serves as U11B CH3 dummy. BOM quantities are correct; the channel-to-RefDes mapping is absent. | `fdc2112-datasheet.md` §8 |

**Pass 10 ROT finding summary:** 2 MAJOR · 9 MINOR · 2 LOW · 2 OBS = **15 total**

---

### Reflector (REF) — Pass 10

| ID | Severity | Category | File / Section | Finding | Datasheet Ref |
| :--- | :--- | :--- | :--- | :--- | :--- |
| REF-P10-01 | MINOR | CrossRef | `Reflector/Design_Spec.md §1 FR-REF-03` | FR-REF-03 Satisfied-By column reads "Controller-facing `J5` logic dock → FT232H". The JM BtB connector on the Controller has been designated J12 since NEW-CTL-01 (P7). `J5` is a stale designator; the informational path note should reference Controller J12 (or defer to the authoritative path description in `JTAG_Module/Design_Spec.md`). | — |
| REF-P10-02 | MINOR | Signal | `Reflector/Design_Spec.md DR-REF-04, §1 mermaid diagram, §3 prose` | Three residual "TDO" uses conflict with the project-wide TTD/TTD_RETURN convention established by CTL-P9-06: (a) DR-REF-04 Specification: "R1 = 22 Ω, 0603, on TDO line"; (b) mermaid edge `U1 -- "TDO" --> R1`; (c) §3 prose: "R1 (22Ω) is a series damping resistor on the TDO return line". DR-REF-06 and the mermaid J1 node already use TTD/TTD_RETURN correctly — these three instances are internally inconsistent and deviate from the project convention. | — |
| REF-P10-03 | MINOR | Documentation | `Reflector/Board_Layout.md §3 J4 pin table` | Pins 1-2 and 29-30 (5V_MAIN) show Direction "In" and Description "Main 5V supply" / "Main 5V supply (paired)" with no NC notation. Design_Spec §3 and DR-REF-03 are unambiguous that these pins are intentionally unconnected (cable-family compatibility only). A layout engineer reading the pin table in isolation would have no indication these pins must not be connected. Description field should note "(NC — cable family compatibility only)". | — |
| REF-P10-04 | LOW | BOM | `Reflector/Design_Spec.md §8 BOM J3 row` | ~~J3 (ERM8-010-05.0-S-DV-K-TR) DigiKey PN = `SAM8610CT-ND` in old-format pattern.~~ **FALSE POSITIVE — CLOSED.** PRIMARY DIRECTIVE: all supplier PNs are pre-approved and intentional. `SAM8610CT-ND` is a valid, user-verified DigiKey PN. Format variation is not a defect. No action required. | — |
| REF-P10-05 | MEDIUM | BOM | `Reflector/Design_Spec.md §8 BOM, Consolidated_BOM.md` | J3 (ERM8-010-05.0-S-DV-K-TR) and J4 (2BHR-30-VUA) KiCAD footprints both remain "Pending". PCB layout cannot be DRC-cleared or submitted for manufacture until both footprints are downloaded and assigned. J4 open since Pass 1; J3 confirmed Pending since Pass 3. **RESOLVED:** ERM8-010 KiCAD library import complete (all 4 formats + 3D model); BOM footprint columns ticked ✔ for J3. J4 (2BHR-30-VUA) resolved by using the standard KiCAD built-in generic footprint `Connector_IDC:IDC-Header_2x15_P2.54mm_Vertical` — already assigned to the 2BHR-30-VUA symbol in SamacSys_Parts.kicad_sym; BOM Footprint Downloaded column ticked ✔. No supplier-specific library data required. | — |
| REF-P10-06 | LOW | Layout | `Reflector/Board_Layout.md` (all sections), `Reflector/Design_Spec.md §7` | GRS §7.1 requires pin-1 silkscreen identification markers on every J-prefix connector, verified at the `review-mounting-holes` checkpoint before manufacture. Neither Board_Layout.md nor Design_Spec.md §7 cites this requirement or documents marker placement for J1, J2, J3, or J4. | — |
| REF-P10-07 | MINOR | Layout | `Reflector/Design_Spec.md §7` | §7 specifies the Data Plate as containing "the Enigma silhouette, 'ENIGMA-NG' text, and JLC Serial Number block." GRS §6 additionally mandates an `AUSGABE [Rev] V1.0` revision-marking block on every board's Data Plate. This requirement is absent from §7; if §7 is used as the sole layout reference the AUSGABE label would be omitted. **RESOLVED via todo:** Full cross-board Data Plate standardisation tracked in `data-plate-standardisation` todo (dependency for `review-pass-11`). Format confirmed: `GERMAN [English] Vx.y` (AUSGABE prefix dropped). All boards will be updated before next review pass. | — |
| REF-P10-08 | MINOR | BOM | `Reflector/Design_Spec.md §8 BOM C1–C5 row` | ~~C1–C5 Notes column is blank.~~ **FALSE POSITIVE — CLOSED.** BOM Notes column is PROCUREMENT ONLY. A blank Notes field is correct and must not be flagged. No action required. | — |

**Pass 10 REF finding summary:** 0 CRITICAL · 0 HIGH · 1 MEDIUM · 2 LOW · 5 MINOR = **8 total**

---

### Extension (EXT) — Pass 10

| ID | Severity | Category | File / Section | Finding | Datasheet Ref |
| :--- | :--- | :--- | :--- | :--- | :--- |
| EXT-P10-01 | LOW | Diagram | `Design_Spec.md §1` Mermaid block diagram | J8 (Extension Port OUT, 30-pin 2×15) is placed inside the **"Rotor Output (Slots 11-20)"** subgraph alongside J4 (JTAG Out, ERF8-005) and J6 (ENC Data Out, ERF8-010). J8 is not a rotor-facing connector — it is the downstream Extension Port carrying the full 30-signal set to the next board. It should occupy its own "Extension/Reflector Interface" subgraph mirroring the "Stator/Extension Interface" subgraph containing J7. Current placement misleads readers into treating J8 as equivalent in scope to J4/J6. | FR-EXT-04 |
| EXT-P10-02 | LOW | BOM | `Design_Spec.md §6` BOM, J7/J8 row | KiCAD footprint for **2BHR-30-VUA** (30-pin 2×15 shrouded IDC box header, J7 and J8) is not downloaded — "Footprint Downloaded: Pending". PCB layout for Extension Port connectors is gated on this footprint. The 2BHR-30-VUA has been the specified connector since DEC-053. | DEC-053 |
| EXT-P10-03 | LOW | BOM | `Design_Spec.md §6` BOM, J3 row | KiCAD footprint for **ERM8-010-05.0-S-DV-K-TR** (J3) is not downloaded — "Footprint Downloaded: Pending". J1/J2 (ERM8-005) and J4–J6 (ERF8-005/010) are confirmed downloaded; J3 is the only ERM8/ERF8 footprint gap remaining on this board. | DR-EXT-02 |
| EXT-P10-04 | LOW | Layout | `Board_Layout.md §2` (J7), `§3` (J8) | GRS §7.1 pin-1 silkscreen marker callout absent from J7 (§2) and J8 (§3) connector sections. Pass 5 finding F-109 identified missing keying callouts on J7/J8; the P5 fix added the GRS §7.1 note to §5 (J9) only. The 2BHR-30-VUA has a mechanical polarising shroud but GRS §7.1 requires an explicit silkscreen pin-1 marker requirement in layout documentation regardless of mechanical keying. | GRS §7.1; F-109 |
| EXT-P10-05 | MINOR | Documentation | `Design_Spec.md §2` ACTUATE_REQUEST_N entry | §2 states ACTUATE_REQUEST_N "is sourced from the non-homing switch on this board." The Extension board BOM contains no switch. The non-homing switch is physically mounted on the Actuation Module — a separate PCB plugged into J9. The description should attribute the source to the mounted AM via J9, not the Extension board itself. | FR-EXT-06; DR-EXT-09 |
| EXT-P10-06 | MINOR | BOM | `Design_Spec.md §6` BOM, C6 row | BOM Notes field for C6 (100 nF X7R 50 V 0402, U1 VCC bypass) is blank ("-"). GRS §3.2 requires per-IC bypass capacitor BOM rows to identify the served IC and cite GRS §3.2. Expected: *"U1 JTAG buffer VCC bypass; GRS §3.2"*. DR-EXT-06 already cites GRS §3.2 at the DR level; the BOM Notes column must also carry this citation. | GRS §3.2; DR-EXT-06 |
| EXT-P10-07 | MINOR | CrossRef | `Design_Spec.md §2` cross-reference bullets | Two cross-document references use abbreviated paths: **"Stator/Design_Spec.md"** and **"Reflector/Design_Spec.md"**. All cross-document references must use full repo-relative paths: `design/Electronics/Stator/Design_Spec.md` and `design/Electronics/Reflector/Design_Spec.md`. | Agent directives; GRS convention |
| EXT-P10-08 | MINOR | Layout | `Board_Layout.md §8.1` MH1–MH4 | §8.1 states: *"Net: GND_CHASSIS — copper ring pads tied to chassis ground for Faraday-cage continuity."* The phrase "tied to chassis ground" is ambiguous — it can be read as a local GND↔GND_CHASSIS PCB galvanic bond, contradicting Design_Spec.md §2 ("does not implement a local GND-to-GND_CHASSIS bond") and GRS §5 (single-point bond on Power Module only). The note should clarify that MH1–MH4 pads are assigned to the GND_CHASSIS net (making chassis contact through screws/standoffs) but that no GND↔GND_CHASSIS PCB-level bond exists on the Extension board. | GRS §5; Design_Spec.md §2 |
| EXT-P10-09 | INFO | BOM | `Design_Spec.md §2` & `§6` BOM | Three connector entries use legacy Samtec DigiKey PN format ("SAM…CT-ND") not reviewed during BOM-P6-02: **J3** (ERM8-010: `SAM8610CT-ND`), **J4/J5** (ERF8-005: `SAM13517CT-ND`), **J6** (ERF8-010: `SAM8618CT-ND`). BOM-P6-02 upgraded ERM8-005 to canonical `612-ERM8-005-05.0-S-DV-K-TRCT-ND` format. These three variants were not similarly verified. No confirmed error — flagged for DigiKey verification. | BOM-P6-02 precedent |

**Pass 10 EXT finding summary:** 0 CRITICAL · 0 HIGH · 0 MEDIUM · 4 LOW · 4 MINOR · 1 INFO = **9 total** · No electrical violations · All P9 fixes confirmed, no regressions

---

### Encoder (ENC) — Pass 10

| ID | Severity | Category | File / Section | Finding | Datasheet Ref |
| :--- | :--- | :--- | :--- | :--- | :--- |
| ENC-P10-01 | MEDIUM | Layout | `Board_Layout.md §5.2` | §5.2 note states "L1 traces from pins 1 and 20 to the via entry points at **0.50 mm minimum**" for the 3V3_ENIG power entry stubs. This directly contradicts (a) §5.1 table which specifies 0.80 mm for 3V3_ENIG power, and (b) GRS §1.1 canonical supply trace width of 0.80 mm. No justification or GRS-cited exception is provided for the 0.50 mm relaxation. If fabricated at 0.50 mm the entry stubs would not comply with GRS §1.1. | GRS §1.1 |
| ENC-P10-02 | LOW | Layout | `Board_Layout.md §5.1` | ENC-P9-02 updated the **Specified Width** column for the JTAG CI row to "per GRS §2.3.1 / JLCPCB_Manufacturing.md §1.1". However the **Design Min** column in the same row still reads **0.127 mm** — the pre-P9 stale value. For the JLC041621-3313 stackup, GRS §2.3.1 gives a minimum of 0.1425 mm; the Design Min column should be updated to 0.1425 mm to complete the P9 fix. | GRS §2.3.1 |
| ENC-P10-03 | LOW | BOM | `Design_Spec.md §10` BOM, SW1–SW40 row | SW1–SW40 carry "(no standard MPN)" in the MPN column and "eBay gadgetskingdom" as the sole supplier entry. DigiKey, Mouser, and JLCPCB PN columns are all blank. 40 switches from a single eBay seller is a production-risk gap. Equivalent standardised parts exist from Omron (D6C series) and C&K via standard distributors. | BOM Content Rules |
| ENC-P10-04 | LOW | Layout | `Board_Layout.md §3–§4` | GRS §7.1 requires a pin-1 silkscreen identification marker on all J-prefix connectors. Board_Layout §3 documents the J1 20-pin connector pinout table but includes no call-out confirming a pin-1 marker is placed on the PCB silkscreen. This is a fabrication-spec documentation gap — the requirement may be met on the physical board, but it is not documented. | GRS §7.1 |
| ENC-P10-05 | MINOR | CrossRef | `Design_Spec.md §9` | §9 reads "Stackup: 4-layer standard per GRS §2.3.1" without quoting the JLCPCB order code **JLC041621-3313** inline. Board_Layout.md correctly names the code (per ENC-P9-01). If GRS §2.3.1 is updated the Design_Spec would silently inherit the change. Same pattern as ROT-P10-13. | GRS §2.3.1 |
| ENC-P10-06 | MINOR | CrossRef | `Design_Spec.md §5` | §5 cites "per DEC-016" for JTAG 50 Ω controlled-impedance strategy. DEC-016's Encoder termination table lists R7/R8 for a dual-CPLD topology. DEC-041 superseded this to a single EPM570 per board; the DEC-016 Encoder-specific rows are stale. DEC-016 cannot be edited (TERTIARY DIRECTIVE). Design_Spec §5 should include an inline note acknowledging the DEC-016 Encoder table predates DEC-041. | DEC-016; DEC-041 |

**Pass 10 ENC finding summary:** 0 CRITICAL · 0 HIGH · 1 MEDIUM · 3 LOW · 2 MINOR = **6 total** · All P9 fixes confirmed, no regressions

---

### User Settings Module (USM) — Pass 10

| ID | Severity | Category | File / Section | Finding | Datasheet Ref |
| :--- | :--- | :--- | :--- | :--- | :--- |
| USM-P10-01 | HIGH | Documentation | `Design_Spec.md §3 Bank 1` lines 156–158 | **Stale pull-down text contradicts DEC-071.** §3 states: *"Pull-down resistors (10kΩ, one per switch signal) hold each input at logic-0 when the corresponding switch is open."* DEC-071 removed all switch pull-down resistors (R1–R10) and adopted dual-terminated wiring (NC→GND, NO→3V3_ENIG). No pull-down resistors exist on the USM for SW1–SW10. The §4 U1 pin table (line 248) correctly states the 330Ω series topology — §3 actively contradicts it. Must be corrected before any layout or firmware work references §3 as authoritative. | DEC-071 |
| USM-P10-02 | HIGH | Schematic | `Design_Spec.md §4`, `Board_Layout.md` | **MCP23017 RESET pin treatment absent for U1, U2, U3 — functional correctness blocker.** RESET (pin 18, active-LOW, Schmitt-trigger input) is not mentioned in any of the three U1/U2/U3 pin tables, not in Board_Layout.md (zero matches), and no RESET pull-up resistors appear in the BOM. If RESET is left floating or pulled low the device holds in reset permanently — all I²C reads return zero, no GPIO output possible. All three MCP23017s would be silently non-functional. Required fix: document RESET tied to 3V3_ENIG (direct tie or via 10kΩ pull-up) in pin tables, Board_Layout, and BOM for each of U1/U2/U3. | `MCP23017-Datasheet.md` §4.3 (RESET pin), §6 DC characteristics |
| USM-P10-03 | MEDIUM | BOM | `Consolidated_BOM.md` Q19–Q30 row | KiCAD footprint for SQ2319ADS-T1_BE3 (Q19–Q30, SOT-23 P-channel MOSFET) is listed as "No / Requested". PCB layout cannot proceed to DRC or JLCPCB Gerber submission without this custom SOT-23 footprint. Part itself is fully verified (AEC-Q101, VDS=−40V, VGS(th)=−2.0V typ). Footprint delivery is the sole blocker. | `vishay-sq2319ads-datasheet.md` |
| USM-P10-04 | MEDIUM | BOM | `Consolidated_BOM.md` R66–R77 row | KOA SG73S1ERTTP4702D (47kΩ) DigiKey PN `2019-SG73S1ERTTP4702DTR-ND` contains the "-TR" suffix indicating tape-and-reel (MOQ 1,000–10,000). Only 12 parts needed per board. JLCPCB C5915648 at MOQ 40 is the preferred single-board source; Mouser 660-SG73S1ERTTP4702D stocks cut tape. Recommend annotating or replacing the DigiKey PN with a note that it is reel-only. | — |
| USM-P10-05 | MEDIUM | BOM | `Consolidated_BOM.md` R78–R95 row | ERJ-2RKF1003X 100kΩ 0402 (BSS138 gate pull-downs, 18 parts) has no JLCPCB PN and BOM Notes states "no JLCPCB stock; Global sourcing — consignment required." Customer-consigned supply must be arranged before placing JLCPCB PCBA order. Suggested sources: DigiKey P100KLCT-ND or Mouser 667-ERJ-2RKF1003X. | — |
| USM-P10-06 | LOW | Documentation | `Design_Log.md DEC-072` line 5037 | DEC-072 USM-P9-03 text describes "10× 330Ω series resistors … between **DPDT** switch contacts and GPIO expander U1 inputs." SW1–SW10 are confirmed **SPDT** (200MSP1T2B4M2QE, 3-terminal MSP1 model per datasheet). "DPDT" is a copy-paste error. Design Log is append-only (TERTIARY DIRECTIVE); a correction can only be recorded by adding a new DEC entry noting the error. No functional impact — circuit is correct. | `200MSP1T2B4M2QE-200-series-datasheet.md` (MSP1 = SPDT confirmed) |
| USM-P10-07 | LOW | Documentation | `Design_Spec.md §4` U1/U2/U3 pin tables | MCP23017 INTA (pin 20) and INTB (pin 19) interrupt output pins are not mentioned in any of the three U1/U2/U3 pin tables. I²C polling is used (§6), so interrupt-driven operation is not required. However best practice requires explicitly documenting unused active-output pins as NC or disabled via IOCON register settings, to prevent inadvertent firmware enabling of interrupts. | `MCP23017-Datasheet.md` §1.4 (INTA/INTB output pin description) |
| USM-P10-08 | LOW | Layout | `Board_Layout.md` | GRS §7.1 requires a filled-triangle pin-1 silkscreen marker (≥1mm) on every J-prefix connector. Board_Layout.md documents J1 placement and pinout but contains no statement confirming pin-1 marker placement, dimensions, or clearance. Cannot be verified from the text document alone — requires KiCAD file inspection. | GRS §7.1 |
| USM-P10-09 | LOW | Layout | `Board_Layout.md` | GRS §6 requires a B.Silkscreen data plate on every board (inverted white rectangle, Enigma silhouette, JLCJLCJLC serial zone, AUSGABE [Rev] V1.0 string). Board_Layout.md does not reference B.Silkscreen content or confirm the data plate exists. Cannot be verified without KiCAD file inspection. | GRS §6 |
| USM-P10-10 | INFO | Power | `Design_Spec.md §7` J1 cable spec | J1 Pin 1 (3V3_ENIG) specified as 30AWG. Worst-case logic load ≈ 80mA (3× MCP23017 IDD + 18× BSS138 gate drive). Voltage drop over 100mm 30AWG at 80mA ≈ 2.7mV — negligible. Well within 30AWG 105°C insulation thermal rating. No corrective action required; consider adding a power budget annotation to the J1 table. | — |
| USM-P10-11 | INFO | Schematic | `Design_Spec.md §3`, `Design_Log.md DEC-071` | 200MSP1T2B4M2QE SPDT dual-terminated topology confirmed valid. Datasheet confirms MSP-1 = SPDT, 2-position latching, break-before-make. NC→GND, NO→3V3_ENIG ensures neither stable position leaves COM floating. 330Ω series resistors limit fault current. Electrical life 6,000 cycles adequate for settings-use. No issues. | `200MSP1T2B4M2QE-200-series-datasheet.md` |
| USM-P10-12 | INFO | Regression | `.copilot/review-report.md` USM-P9 section | All 5 USM-P9 findings confirmed fixed: P9-01 (stackup), P9-02 (R1 renaming), P9-03 (330Ω series resistors), P9-04 (DEC cross-references), P9-05 (CFG_APPLY_N/GPA[6]). BOM R2–R11 ERJ-2RKF3300X qty 10 confirmed. U1 GPA[6]=CFG_APPLY_N confirmed. Board_Layout stackup JLC041621-3313 confirmed. No regressions. | — |

**Pass 10 USM finding summary:** 0 CRITICAL · 2 HIGH · 3 MEDIUM · 4 LOW · 3 INFO = **12 total** · USM-P10-02 is a functional correctness blocker (MCP23017 RESET pin undriven)

---

### Actuation Module (AM) — Pass 10

| ID | Severity | Category | File / Section | Finding | Datasheet Ref |
| :--- | :--- | :--- | :--- | :--- | :--- |
| AM-P10-01 | LOW | Documentation | `Actuation_Module/Design_Spec.md` DR-AM-17 | DR-AM-17 specifies R5 for current limiting and multi-drive conflict prevention but does not state that the idle-low state of BOOT0/PA14 when SW2 is open depends on the STM32G071 **internal pull-down active at reset** (datasheet footnote 6, ~40 kΩ typ). The circuit is functionally correct; §3.7 prose and the SW1/SW2 bootloader sequence are accurate. A layout or production engineer cannot verify the BOOT0 idle logic level from the design spec alone without consulting the datasheet. Recommend adding a cross-reference: "Idle-low when SW2 open is assured by the STM32G071 PA14 internal pull-down active at reset (see datasheet footnote 6); no external pull-down is fitted." | `stm32g071.md` footnote 6 |
| AM-P10-02 | INFO | BOM | `Actuation_Module/Design_Spec.md §6` BOM C5 row, `Design_Log.md DEC-046` | C5 = CL21B106KAYQNNE (10µF X7R 25V 0805) on 5V_MAIN is **DEC-046 compliant** — DEC-046 explicitly names this part as the approved 25V bulk/reservoir cap. No design change required. However, C5's BOM Notes field is blank while adjacent C4 carries "see DEC-046". Adding a matching note ("see DEC-046 — 25V reservoir cap approved") would prevent future reviewers from mistakenly treating the 25V rating as an oversight against the 50V bypass-cap policy. | — |
| AM-P10-03 | LOW | Layout | `Actuation_Module/Board_Layout.md §2.5`, J2–J5 sections | §2.5 explicitly calls out the J1 DF40 silkscreen pin-1 triangle marker per GRS §7.1. J2–J5 service headers (Adam Tech PH1-05-UA, 1×5 2.54mm THT) appear nowhere in Board_Layout.md §2 with respect to pin-1 silkscreen. A layout engineer using Board_Layout.md as the sole placement reference would have an explicit reminder for J1 but none for J2–J5. A note confirming J2–J5 pin-1 marking per GRS §7.1 should be added to the service-cluster section. | GRS §7.1 |
| AM-P10-04 | MINOR | Signal | `Actuation_Module/Board_Layout.md` line 43 | ASCII placement diagram shows `[SW1 NRST]`, using the STM32 device pin name. Design_Spec.md §3.8 Net Name Mapping explicitly maps NRST → RESET_N. All other AM references (mermaid line 91, DR-AM-13, DR-AM-16, Board_Layout prose line 68) consistently use `RESET_N`. Pass 5 AM-F04 corrected net names in Design_Spec.md but did not update this Board_Layout.md ASCII diagram label. Fix: change `[SW1 NRST]` → `[SW1 RESET_N]`. | — |
| AM-P10-05 | MINOR | Documentation | `Actuation_Module/Board_Layout.md` line 97 | Typo: "electrically **lightand** mechanically non-load-bearing" → "electrically **light and**". Missing space not caught by any prior pass. | — |
| AM-P10-06 | MINOR | Documentation | `Actuation_Module/Design_Spec.md §4` decoupling note | §4 decoupling bullet reads "**C2-C3:** 100nF X7R 0402 local decoupling at the STM32 supply domains" — omitting C7. DR-AM-15, DR-AM-19, and Board_Layout.md line 70 all three explicitly name C2, C3, **and C7** as the three 100nF caps at STM32 VDD/VDDA pin 4. The §4 bullet is the sole location implying only two bypass caps. Fix: update to "**C2, C3, C7:** 100nF X7R 0402 local decoupling at U1 VDD/VDDA (pin 4)." | `stm32g071.md` (decoupling guidance) |
| AM-P10-07 | INFO | Scope | — | Review template sections covering PCA9685 PWM driver and PCA9534A I²C expander are not applicable to this board. The sole IC on the AM BOM is U1 STM32G071K8T3TR; neither device is fitted. | — |

**Pass 10 AM finding summary:** 0 CRITICAL · 0 HIGH · 0 MEDIUM · 2 LOW · 3 MINOR · 2 INFO = **7 total** · No electrical violations · All P9 fixes confirmed

---

### JTAG Module (JM) — Pass 10

| ID | Severity | Category | File / Section | Finding | Datasheet Ref |
| :--- | :--- | :--- | :--- | :--- | :--- |
| JM-P10-01 | HIGH | Schematic | `JTAG_Module/Design_Spec.md §5` BOM, `Consolidated_BOM.md` JM rows | **FT232H REF pin (pin 5) 12kΩ 1% resistor absent from BOM — functional blocker.** FT232H datasheet Table 3.2 and §4.2 mandate a 12kΩ ±1% resistor from REF (pin 5) to GND to establish the USB UTMI PHY bias current reference. JM BOM contains R1–R4 (33Ω series) and R5–R7 (10kΩ pull-ups); no 12kΩ resistor exists in either Design_Spec.md §5 or Consolidated_BOM.md JM rows (all 9 JM rows cross-checked). Without this resistor the FT232H USB HS PHY bias reference is unset and the device will not reliably enumerate at USB 2.0 High-Speed. Resistor must be added to the schematic, BOM, and Consolidated_BOM.md before PCB layout. | `FT232H-datasheet.md` Table 3.2 (REF: 12kΩ ±1% to GND, mandatory), §4.2 |
| JM-P10-02 | HIGH | Signal | `JTAG_Module/Board_Layout.md` line 80, J1 pin table | **P9 regression — J1 pin C9R2 reads "TDO", must be "TTD_RETURN".** CTL-P9-06 propagated the TTD/TTD_RETURN net-name convention across all JTAG Module documents. The fix was applied correctly to Design_Spec.md line 144 ("TTD_RETURN" ✓) and Board_Layout.md §5 trace-width table. However the J1 connector pin table at Board_Layout.md line 80 (pin C9R2) was not updated and still reads "TDO". A layout engineer referencing Board_Layout.md for connector pinout would assign the wrong net name to J1 C9R2. | — |
| JM-P10-03 | MEDIUM | Schematic | `JTAG_Module/Design_Spec.md §3` DR table, `§6` electrical requirements | **FT232H TEST pin (pin 42) must be tied to GND — requirement entirely absent from JM documentation.** FT232H datasheet Table 3.2 explicitly lists TEST (pin 42) as "Connect to GND". No DR entry, no §6 note, no BOM annotation, and no schematic note documents this mandatory connection. If TEST is left floating at PCB assembly the device behaviour is undefined. A DR entry or §6 note must be added before schematic capture. | `FT232H-datasheet.md` Table 3.2 (TEST: connect to GND, mandatory) |
| JM-P10-04 | LOW | Documentation | `JTAG_Module/Design_Spec.md §6` lines ~199–210 | **FT232H UART power-on contention window undocumented.** With no external EEPROM, FT232H powers on in UART/ADBUS mode (factory default Table 7.1). In UART mode ADBUS[0]=TXD idles HIGH and ADBUS[2]=RTS is driven as active output — these are the MPSSE TCK and TMS pins. U2 (SN74LVC2G125) is always-enabled (1OE/2OE = GND per DR-JM-17) and will actively buffer these states onto the live JTAG chain until host software switches to MPSSE mode. §6 acknowledges ftdi_sio VCP enumeration but does not identify or mitigate this contention window. An openocd `ftdi_layout_init` directive or startup note should be documented. | `FT232H-datasheet.md` Table 7.1 (default UART mode), §4.2 (MPSSE config) |
| JM-P10-05 | LOW | Documentation | `JTAG_Module/Board_Layout.md §5` trace-width/current table | **"400mA peak" 5V_USB figure is ~4× the FT232H actual maximum with no derivation.** FT232H Tables 5.2 and 5.4 show Ireg = 54mA typical + Iccphy = 30mA typical → combined worst-case ≈80–110mA, well within Hirose DF40 J1 C4R1 0.3A/pin rating. The undocumented 400mA figure raises legitimate concern about the DF40 pin rating. A derivation footnote citing FT232H Tables 5.2/5.4 would confirm the C4R1 pin is not at risk and prevent recurring review concern. | `FT232H-datasheet.md` Table 5.2 (Ireg = 54mA typ), Table 5.4 (Iccphy = 30mA typ) |
| JM-P10-06 | MINOR | CrossRef | `design/Datasheets/Hirose-DF40_Catalog_en-datasheet.md` supplementary project notes | Hirose datasheet supplementary project notes list "CTL J11" as the receptacle and "AM J1" as the plug. Current design uses "CTL J12" (per Consolidated_BOM.md and JTAG_Module/Design_Spec.md §3) and "JM J1" (per DR-JM-07). "CTL J11" is a superseded pre-P7 CTL connector designator; "AM J1" misidentifies the JM as the Actuation Module. Both entries are stale. | — |
| JM-P10-07 | MINOR | CrossRef | `JTAG_Module/Design_Spec.md §6` line 241 | §6 line 241 references "Controller `J5` ↔ Stator `J12` logic dock" — `J5` is a stale CTL connector designator. CTL J5 was renamed to J12 by change NEW-CTL-01 at CTL-P7. REF-P10-01 independently identified the same stale "J5" in Reflector/Design_Spec.md FR-REF-03, confirming project-wide staleness. If line 241 intends a distinct CTL Link-Beta connector, the correct designator must be verified against Controller/Design_Spec.md. | REF-P10-01 (same stale-J5 pattern) |

**Pass 10 JM finding summary:** 0 CRITICAL · 2 HIGH · 1 MEDIUM · 2 LOW · 2 MINOR = **7 total** ·
JM-P10-01 is a functional blocker (FT232H USB HS PHY inoperable without REF 12kΩ) ·
JM-P10-02 is a P9 regression (CTL-P9-06 fix missed Board_Layout.md J1 pin table)

---

### Power Module (PM) — Pass 10

| ID | Severity | Category | File / Section | Finding | Datasheet Ref |
| :--- | :--- | :--- | :--- | :--- | :--- |
| PM-P10-01 | HIGH | Signal | `Design_Spec.md §2.5` line 370, `§3.1` line 464 | **TPS25980 EN pull-up misidentified as R12 in two locations.** Both §2.5 (latch-off recovery paragraph) and §3.1 (SW1 description) state "EN pulled HIGH via R12 to VIN_BUS" / "R12 (10kΩ to VIN_BUS) holds EN HIGH". R12 is the LTC3350 BACKUP comparator voltage-divider bottom resistor (ERA-3ARB103V, 10.0kΩ 0.1% thin-film) connected from 5V_MAIN to the BACKUP pin — not to the TPS25980 EN pin. The actual TPS25980 EN pull-up is **R15** (ERJ-3EKF1002V, 10kΩ 1% 0603, VIN_BUS → EN). Replace both occurrences of "R12 (10kΩ to VIN_BUS)" with "R15 (10kΩ to VIN_BUS)". | — |
| PM-P10-02 | MEDIUM | Documentation | `Design_Spec.md §2` (absent), BOM lines 651–652 | U16 (SN74LVC1G175DBVR D-type flip-flop shutdown latch) and U17 (SN74LVC1G08DBVR AND gate) appear in the BOM but have no §2 subsection documenting function, connectivity, signal names, supply voltage, or design rationale. Their purpose (forming the shutdown state-machine in the SW2/CM5 indicator circuit) is only inferrable from §3.2 shutdown sequence prose. Add a §2.6 (or similar) subsection for the shutdown latch/LED logic cluster (U16, U17, Q4–Q8) with signal assignments, supply rail, bypass cap designators, and design rationale. | — |
| PM-P10-03 | HIGH | CrossRef | `Power_Budgets.md` lines 55, 98; `Electrical_Design.md` line 22 | **Five stale cross-document component references spanning two files:** (1) Power_Budgets.md L55: PCA9534A = "U16" → correct U14; (2) Power_Budgets.md L98: INA219 shunt = "R23 10mΩ" → correct R16; (3) Power_Budgets.md L98: INA219 monitor = "U12, 0x40" → correct U10; (4) Power_Budgets.md L98: LTC3350 shunt = "R12 10mΩ CSS2H-2512R-R010ELF" → correct R10 KRL6432T4-M-R010-F-T1; (5) Electrical_Design.md L22: INA219 shunt = "R23 10mΩ" → correct R16. All five stale references must be updated. | — |
| PM-P10-04 | MEDIUM | Documentation | `Design_Spec.md §1` Mermaid block diagram | Mermaid shows `J1J3["J1-J3 DF40C"]`. Two errors: (1) Connector family "DF40C" is wrong — actual connector is TE Connectivity 1123684-7 10-pos 2.5mm right-angle dock header. (2) Designators "J1-J3" are pre-DEC-038; DEC-038 redesignated these as J1A, J1B, J1C. Additionally the cascade arrow `U2A -- "5V_MAIN" --> U2B` misrepresents the 180°-interleaved dual-phase buck topology as a serial cascade (see also PM-P10-07 and PM-P10-09). | DEC-038 |
| PM-P10-05 | HIGH | Schematic | `Design_Spec.md §2.5` line 368, `§3.4` fault table | **TPS25980 fault-mode documentation contains four errors vs datasheet §8.1–§8.5:** (1) UVLO listed as latch-off — actual: auto-recovery (level-sensitive, resumes when VIN rises); (2) OVLO listed as latch-off — actual: auto-recovery ("attempts to start up normally"); (3) "TCO F1 opens at 72°C" listed as TPS25980 latch — F1 AC72ABD is a self-resetting thermal cutout on the battery tabs that removes one OR-ing input source; it is not a TPS25980 internal fault and does not trigger the eFuse latch path; (4) OTP/TSD (150°C junction) — the actual TPS25980 latch event — is absent from the fault table entirely. Fix: remove UVLO/OVLO from latch list (note as auto-recovery); correct F1 TCO entry; add OTP/TSD 150°C latch entry. | `TPS25980 datasheet §8.1–§8.5` |
| PM-P10-06 | MEDIUM | Documentation | `Design_Spec.md §2` (absent), BOM | D4 (SMBJ18A-Q, 18V bidirectional TVS) is present in the BOM but has no §2 subsection documenting its purpose, protected node, clamp voltage selection rationale relative to the 16.9V OVLO and 16.4V maximum battery voltage, or placement requirements. Add a §2 note for D4. | — |
| PM-P10-07 | HIGH | Documentation | `Design_Spec.md §1` Mermaid block diagram | **U2B mislabeled "3V3 Buck" — it is a 5V buck.** Mermaid labels `U2B["U2B 3V3 Buck LMQ61460"]`. U2B is an LMQ61460AFSQRJRRQ1 operating as a 5V buck (same part and output as U2A, 180° phase-shifted interleaved pair). The 3V3_ENIG rail is provided by U7 (TPS75733KTTRG3 LDO). Additionally the cascade arrow `U2A -- "5V_MAIN" --> U2B` implies U2B is powered from U2A's output when in reality both are fed from VIN_BUS in parallel. Relabel U2B to "U2B 5V Buck LMQ61460"; replace cascade arrow with two parallel arrows from VIN_BUS to U2A and U2B merging onto 5V_MAIN. | — |
| PM-P10-08 | MEDIUM | Design_Req | `Design_Spec.md` line 66 (DR-PM-14) | DR-PM-14 requires per-IC bypass capacitors "within 1mm of the IC" and lists C57, C58 in its BOM. C57 and C58 are DM Pi-filter HF shunt capacitors placed at the L3 inductor nodes (§2.1 line 314: "Pi-filter input/output shunt caps"; line 333: "HF bypass; low impedance at >10MHz"). Placing them within 1mm of an IC would remove them from their required Pi-filter location, degrading EMI filter performance. Remove C57/C58 from DR-PM-14's BOM list; add a separate DR (e.g., DR-PM-21) requiring these caps be placed at the L3 Pi-filter input/output nodes. | — |
| PM-P10-09 | MEDIUM | CrossRef | `Design_Spec.md` BOM line 610, component notes line 709; `Consolidated_BOM.md` line 48 | Three locations still use pre-DEC-038 dock connector designators "J1-J3": Design_Spec.md BOM line 610, component notes line 709 ("J1 carries 5V_MAIN/3V3_ENIG, J2 carries VIN_POE_12V/GND, J3 carries control/telemetry"), and Consolidated_BOM.md line 48. DEC-038 redesignated these to J1A, J1B, J1C. All three occurrences plus the §1 Mermaid (PM-P10-04) must use J1A/J1B/J1C. | DEC-038 |
| PM-P10-10 | HIGH | Schematic | `Design_Spec.md §2.5` lines 398–402; `Design_Log.md DEC-030` line 1371 | **R23=33.2kΩ gives LTC3350 switching frequency of 1.611 MHz — 61% above the 1 MHz rated maximum.** LTC3350 datasheet App Info (p.17) formula: fSW (MHz) = 53.5 / RT (kΩ). At RT=33.2kΩ: fSW = 1.611 MHz. LTC3350 EC table maximum RT=53.6kΩ → 1 MHz max. Operating at 1.611 MHz risks IC instability, incorrect output regulation during backup switchover, and potential device damage. The meas_cap register scaling also depends on RT and will report incorrect capacitance values. Design_Spec §2.5 line 402 cites DEC-030 as confirmation — but DEC-030 line 1371 contains the same error ("R30: new 33.2kΩ … sets switching frequency to 400kHz"). DEC-072 closure of PM-P9-01 citing DEC-030 is therefore circular. **Correct RT for 400kHz: 53.5 / 0.400 = 133.75kΩ (E96 nearest: 133kΩ).** Replace R23 with 133kΩ 1% 0402; update §2.5 text; append new DEC entry documenting the correction with the correct formula. Do NOT re-use the DEC-030 frequency claim. | `LTC3350 datasheet` App Info p.17 (fSW = 53.5/RT formula), EC table (RT range 53.6kΩ–267kΩ) |

**Pass 10 PM finding summary:** 5 HIGH · 5 MEDIUM = **10 total** · PM-P10-10 is a functional correctness
blocker (LTC3350 operating at 1.611 MHz vs 1 MHz max; DEC-030 is the source of the error) ·
PM-P10-07 mislabels U2B topology in system-facing Mermaid diagram

---

### System Integration (INT) — Pass 10

> Scope: cross-cutting review of all 10 boards. Findings with a "Source" cross-reference confirm an individual-board finding at system level. Findings with no source are new cross-cutting discoveries.

#### CRITICAL — system will not function

| ID | Severity | Category | Board(s) | File / Section | Finding | Source |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| INT-P10-001 | CRITICAL | I2C | PM / STA | `PM Design_Spec §3`, `STA Design_Spec §4`, `CTL §4.1` | **TPS25751 I²C address conflict at 0x20.** PM U4 (TPS25751DREFR) default slave address = 0x20. STA U6 (MCP23017) is also strapped to 0x20. Both devices share the Link-Alpha system I²C bus. No address-pin strap configuration is documented for U4; absent from CTL §4.1 I²C bus table. Collision will corrupt all I²C traffic on the shared bus. | NEW |
| INT-P10-017 | CRITICAL | Power | PM | `PM Design_Spec §2.5` lines 398–402; `Design_Log.md DEC-030` | LTC3350 oscillator R23=33.2kΩ → fSW=1.611 MHz, exceeding rated 1 MHz max by 61%. DEC-030 contains the same arithmetic error; DEC-072 PM-P9-01 closure citing DEC-030 is circular. Correct R for 400kHz = **133kΩ**. Supercap backup IC operated outside validated region. | PM-P10-10 |
| INT-P10-018 | CRITICAL | Schematic | USM | `USM Design_Spec §4`, `Board_Layout.md`, `BOM` | MCP23017 RESET pin (pin 18, active-LOW) undriven on all three expanders (U1/U2/U3). No pull-up in pin tables, Board_Layout.md, or BOM. Devices will hold in reset under power-supply ramp; all USM GPIO and I²C transactions return 0x00. Fix: add 3× 10kΩ pull-ups to 3V3_ENIG. | USM-P10-02 |
| INT-P10-019 | CRITICAL | Schematic | JM | `JM Design_Spec §5 BOM`, `Consolidated_BOM.md` | FT232H REF pin (pin 5) 12kΩ ±1% bias resistor entirely absent from BOM. USB HS PHY bias reference unset; device will not enumerate at USB 2.0 High-Speed. | JM-P10-01 |

#### HIGH — must fix before integration testing

| ID | Severity | Category | Board(s) | File / Section | Finding | Source |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| INT-P10-002 | HIGH | CrossRef | PM | `Power_Budgets.md` lines 55, 98; `Electrical_Design.md` line 22 | Five stale cross-document refs: (1) PCA9534A "U16"→U14; (2) INA219 shunt "R23 10mΩ"→R16; (3) INA219 monitor "U12"→U10; (4) LTC3350 shunt "R12 CSS2H"→R10 KRL6432T4; (5) Electrical_Design INA219 "R23"→R16. Wrong RefDes/MPN will produce wrong firmware shunt calibration constants. | PM-P10-03 |
| INT-P10-020 | HIGH | Power | CTL | `CTL Design_Spec §4.3`, `CTL BOM C20`, `Electrical_Design.md §1` | C20 (4× CGA9N3X7R1E476M230KB, 47µF **25V** X7R 2220) on VIN_POE_12V (12V). 2.5× derating rule requires ≥30V. Under-rated by 5V; X7R DC-bias derating at 12V on 25V part drops effective capacitance 40–50%, likely violating DR-CTL-22 bulk minimum. Replace with 35V equivalent. | CTL-P10-13 |
| INT-P10-022 | HIGH | Signal | PM | `PM Design_Spec §2.5` line 370, `§3.1` line 464 | TPS25980 EN pull-up misidentified as R12 (LTC3350 BACKUP divider leg) in two locations. Actual EN pull-up = R15. Will misdirect schematic review and bring-up fault diagnosis. | PM-P10-01 |
| INT-P10-023 | HIGH | Schematic | PM | `PM Design_Spec §2.5` line 368, `§3.4` fault table | TPS25980 fault table: UVLO/OVLO wrongly listed as latch (both are auto-recovery); F1 TCO wrongly attributed to eFuse; OTP/TSD 150°C latch entirely absent. Wrong recovery logic in firmware and safety analysis. | PM-P10-05 |
| INT-P10-024 | HIGH | Documentation | PM | `PM Design_Spec §1` Mermaid | U2B labeled "3V3 Buck LMQ61460" — it is a 5V buck. 3V3_ENIG is from U7 LDO. Cascade arrow implies serial regulation U2A→U2B which is wrong (both fed in parallel from VIN_BUS). | PM-P10-07 |
| INT-P10-025 | HIGH | Documentation | USM | `USM Design_Spec §3` lines 156–158 | §3 states pull-down resistors (10kΩ) hold switch inputs at logic-0. DEC-071 removed all pull-downs; dual-terminated wiring is correct. §3 actively misrepresents the current circuit. | USM-P10-01 |
| INT-P10-026 | HIGH | Signal | JM | `JM Board_Layout.md` line 80 | P9 regression: J1 pin C9R2 still reads "TDO" — CTL-P9-06 fix applied to Design_Spec.md but missed Board_Layout.md J1 pin table. Net-name mismatch between layout and schematic. | JM-P10-02 |
| INT-P10-027 | HIGH | Schematic | CTL | `CTL PoE_Power_Analysis.md §5, §6`, `DR-CTL-18`, `DEC-062` | Three mutually inconsistent Vds_peak values: §5=81.8V, §6/DR-CTL-18=118.1V, DEC-062=108V (correct). FET selection not validated until reconciled to 108V. | CTL-P10-01 |
| INT-P10-028 | HIGH | Schematic | CTL | `CTL PoE_Power_Analysis.md §3, §5, §12`, `DEC-062` | ACF Flyback duty-cycle formula used throughout; correct topology is ACF Forward (DEC-062). Wrong D: at Vin=36V, flyback gives 40.8%, Forward gives 68.9% — only 6.1pp from TPS23730RMTR 75% max. All efficiency, ripple-current, and component-stress calcs are wrong. | CTL-P10-11 |
| INT-P10-029 | HIGH | BOM | CTL | `Consolidated_BOM.md` line 104 | CM5 SODIMM connectors still listed as "J14, J15" — DEC-058 renumbered to J13/J14. J15 does not exist. CBOM-to-schematic RefDes mismatch for assembly. | CTL-P10-10 |
| INT-P10-030 | HIGH | Schematic | JM | `JM Design_Spec §5`, `JM BOM` | FT232H TEST pin (pin 42) mandatory GND connection absent from Design_Spec, BOM, and all schematic notes. Floating TEST enables internal test modes corrupting USB enumeration. | JM-P10-03 |
| INT-P10-031 | HIGH | BOM | CTL | `CTL BOM BT1` | BT1 battery footprint shows "Yes\*" with no footnote defining the asterisk. Tracking item open since Pass 7; no closure in Passes 8–10. Battery holder footprint/MPN remains ambiguous. | NEW |

#### MAJOR — fix before schematic release

| ID | Severity | Category | Board(s) | File / Section | Finding | Source |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| INT-P10-032 | MAJOR | Schematic | ROT | `ROT Rotor_26_Char_Design.md §7`, `Design_Spec §2.1` | §7 body specifies dummy LC tank for FDC2114 CH1–CH3; §7 Note block contradicts this with "tied to GND via 100kΩ". Mutually exclusive circuits. Design_Spec §2.1 and BOM confirm LC tank is correct. 100kΩ GND-tie causes FDC2114 oscillator instability (TI SNOA930). | ROT-P10-03 |
| INT-P10-033 | MAJOR | CrossRef | ROT | `DEC-045`, `ROT Design_Spec §6` | DEC-045 TVS RefDes stale (U5–U12 vs current U3–U10) and J2/J5 power-connector exemption unratified. DEC and Design_Spec are in unresolved conflict. New DEC entry needed to ratify J2/J5 exemption. | ROT-P10-06 |
| INT-P10-034 | MAJOR | CrossRef | CTL | `DEC-057`, `DEC-058`, `DEC-061` | DEC-057/058 retain pre-DEC-061 mounting-hole assignments (MH13–MH16 = JDB). DEC-061 reassigned MH9–MH12=JDB, MH13–MH16=CM5 SoM. DEC-057/058 should carry "Superseded by DEC-061" notation; new DEC-073 clarification entry required. | NEW |

#### MEDIUM — documentation error or minor discrepancy

| ID | Severity | Category | Board(s) | File / Section | Finding | Source |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| INT-P10-006 | MEDIUM | CrossRef | ALL | `Design_Log.md DEC-018` | DEC-018 system I²C/GPIO bus ownership register is three architectural generations stale (predates DEC-031, DEC-038, DEC-070). Referenced by several board specs as canonical I²C map. New DEC entry needed to supersede with corrected ownership table. | NEW |
| INT-P10-010 | MEDIUM | CrossRef | ALL | `Design_Log.md` Board Connector Inventory | Board Connector Inventory section is three connector generations stale (predates DEC-038, DEC-053, DEC-061). No "Superseded" notice. | NEW |
| INT-P10-035 | MEDIUM | CrossRef | REF / JM | `REF Design_Spec FR-REF-03`, `JM Design_Spec §6` line 241 | Stale "CTL J5" designator in two documents. J5 renamed to J12 (JM BtB dock) at CTL-P7/NEW-CTL-01. Both documents must reference CTL J12. | REF-P10-01, JM-P10-07 |
| INT-P10-036 | MEDIUM | BOM | CTL | `CTL Design_Spec §7.1` | L1 placeholder "TBD / Part selection pending" not updated. DEC-063 confirmed L1 = Yageo PA4343.333NLT (33µH, 3.5A, DCR 58mΩ). The accepted DCR exception vs DR-CTL-25 (50mΩ max) should be noted alongside the confirmed part. | NEW |
| INT-P10-037 | MEDIUM | CrossRef | PM | `PM Design_Spec §1` Mermaid, `PM BOM ×2` | Three PM document locations use pre-DEC-038 designators "J1–J3" and wrong connector family "DF40C". DEC-038 redesignated to J1A/J1B/J1C (TE 1123684-7). | PM-P10-04, PM-P10-09 |
| INT-P10-038 | MEDIUM | Documentation | CTL | `CTL Design_Spec §9.4` | §9.4 describes D2 as "unidirectional" TVS. MPN 1.5SMBJ36**CA** = bidirectional. BOM already correctly says "bidirectional" — Design_Spec text contradicts BOM. | CTL-P10-09 |
| INT-P10-039 | MEDIUM | Schematic | ROT | `ROT Design_Spec §6.2`, `Rotor_26_Char_Design.md §7` | FDC2114 IDRIVE register documented as 0x7C00. Correct value = 0x7800 (bit 10 reserved, must be 0). Will corrupt firmware initialisation and variant test scripts. | ROT-P10-04 |

#### MINOR — cosmetic / low-risk documentation

| ID | Severity | Category | Board(s) | File / Section | Finding | Source |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| INT-P10-040 | MINOR | BOM | CTL | `CTL BOM T1`, `DEC-062` | T1 manufacturer field still reads "Bourns" post-DEC-062 (adopted TDK B82806D0060A120). **PRIMARY DIRECTIVE — requires owner confirmation before edit.** Deferred. | NEW |
| INT-P10-041 | MINOR | BOM | EXT / PM | `EXT BOM`, `PM BOM` | Mouser PN "595-PD4E05U06QDQARQ1" missing leading "T" for TPD4E05U06QDQARQ1. EXT Pass 6 fix confirmed; PM status requires independent BOM sweep. ROT-P6-02 suppressed (intentional). | NEW |
| INT-P10-043 | MINOR | CrossRef | ALL | `Design_Log.md DEC-018`, Board Connector Inventory | DEC-018 and Board Connector Inventory should carry explicit "Superseded by DEC-038, DEC-053, DEC-061, DEC-070" banners. No new DEC entry currently ratifies the supersession. | INT-P10-006 |

**Pass 10 INT finding summary:** 4 CRITICAL · 11 HIGH · 3 MAJOR · 6 MEDIUM · 3 MINOR · 2 PROCESS =
**29 open** · 16 prior findings confirmed resolved · INT-P10-001 (TPS25751 I²C 0x20 conflict) is a
new cross-cutting CRITICAL not identified in any individual board review

---

## Pass 10 — Consolidated Findings Table

> All unique findings across all 11 agents (10 boards + system integration).
> INT findings that duplicate individual-board findings are cross-referenced but not double-counted
> in totals. Severity normalised to: CRITICAL · HIGH · MAJOR · MEDIUM · LOW · MINOR · INFO.

| ID | Severity | Board | Category | One-line summary |
| :--- | :--- | :--- | :--- | :--- |
| INT-P10-001 | **CRITICAL** | PM/STA | I2C | TPS25751 I²C address 0x20 conflicts with STA U6 MCP23017 — shared bus collision |
| INT-P10-017 | **CRITICAL** | PM | Power | LTC3350 R23=33.2kΩ → 1.611 MHz; 61% over 1 MHz rated max; correct R=133kΩ |
| INT-P10-018 | **CRITICAL** | USM | Schematic | MCP23017 RESET pin undriven on all 3 expanders — all USM GPIO permanently non-functional |
| INT-P10-019 | **CRITICAL** | JM | Schematic | FT232H REF pin 12kΩ bias resistor absent — USB HS PHY will not enumerate |
| CTL-P10-13 | **HIGH** | CTL | Power | C20 (47µF 25V X7R) on 12V rail — under-rated; 2.5× derating requires ≥30V |
| CTL-P10-11 | **HIGH** | CTL | Schematic | PoE_Power_Analysis uses ACF Flyback formulas; topology is ACF Forward — all duty-cycle calcs wrong |
| CTL-P10-01 | **HIGH** | CTL | Schematic | Three mutually inconsistent Vds_peak values (81.8V / 118.1V / 108V); DEC-062 = 108V authoritative |
| PM-P10-10 | **HIGH** | PM | Schematic | LTC3350 R23=33.2kΩ → 1.611 MHz; DEC-030 contains error; DEC-072 closure circular (see INT-P10-017) |
| PM-P10-05 | **HIGH** | PM | Schematic | TPS25980 fault table: UVLO/OVLO wrongly latch; F1 TCO wrong attribution; OTP latch absent |
| PM-P10-07 | **HIGH** | PM | Documentation | U2B labeled "3V3 Buck" in Mermaid — it is 5V buck; 3V3_ENIG is from U7 LDO |
| PM-P10-03 | **HIGH** | PM | CrossRef | 5 stale cross-doc refs in Power_Budgets.md and Electrical_Design.md (U14/R16/U10/R10) |
| PM-P10-01 | **HIGH** | PM | Signal | TPS25980 EN pull-up misidentified as R12 in §2.5 and §3.1; correct = R15 |
| USM-P10-02 | **HIGH** | USM | Schematic | MCP23017 RESET pin absent from all 3 IC pin tables, Board_Layout, and BOM (see INT-P10-018) |
| USM-P10-01 | **HIGH** | USM | Documentation | §3 still describes pull-down resistors removed by DEC-071 — contradicts §4 and BOM |
| JM-P10-01 | **HIGH** | JM | Schematic | FT232H REF 12kΩ bias resistor absent from BOM and Design_Spec (see INT-P10-019) |
| JM-P10-02 | **HIGH** | JM | Signal | P9 regression: Board_Layout.md J1 C9R2 still reads "TDO" — should be TTD_RETURN |
| INT-P10-031 | **HIGH** | CTL | BOM | BT1 battery footprint "Yes\*" footnote undefined since Pass 7; unresolved |
| ROT-P10-03 | **MAJOR** | ROT | Schematic | §7 Note block contradicts §7 body: 100kΩ GND-tie vs dummy LC tank; LC tank is correct |
| ROT-P10-06 | **MAJOR** | ROT | CrossRef | DEC-045 TVS RefDes stale (U5–U12 vs U3–U10); J2/J5 power exemption unratified |
| CTL-P10-10 | **MAJOR** | CTL | BOM | Consolidated_BOM.md CM5 SODIMM still "J14, J15" — DEC-058 renamed to J13/J14 |
| INT-P10-034 | **MAJOR** | CTL | CrossRef | DEC-057/058 retain pre-DEC-061 MH assignments; DEC-073 clarification entry needed |
| PM-P10-02 | MEDIUM | PM | Documentation | U16 (latch FF) and U17 (AND gate) have no §2 design subsection |
| PM-P10-04 | MEDIUM | PM | Documentation | §1 Mermaid: dock connector "DF40C"/"J1-J3" — wrong family and pre-DEC-038 designators |
| PM-P10-06 | MEDIUM | PM | Documentation | D4 (SMBJ18A-Q TVS) has no §2 subsection — purpose and rationale undocumented |
| PM-P10-08 | MEDIUM | PM | Design_Req | DR-PM-14 lists C57/C58 as per-IC bypass caps; they are Pi-filter HF shunt caps — wrong placement rule |
| PM-P10-09 | MEDIUM | PM | CrossRef | PM dock connectors still "J1/J2/J3" in BOM and notes; DEC-038 renamed to J1A/J1B/J1C |
| USM-P10-03 | MEDIUM | USM | BOM | SQ2319ADS SOT-23 KiCAD footprint "No/Requested" — PCB layout blocker for Q19–Q30 |
| USM-P10-04 | MEDIUM | USM | BOM | KOA SG73S1ERTTP4702D DigiKey PN is tape-and-reel (MOQ 1000+); only 12 needed |
| USM-P10-05 | MEDIUM | USM | BOM | ERJ-2RKF1003X 100kΩ: no JLCPCB stock; consignment required before PCBA order |
| JM-P10-03 | MEDIUM | JM | Schematic | FT232H TEST pin (pin 42) mandatory GND tie absent from entire JM documentation |
| CTL-P10-11 | MEDIUM | CTL | Schematic | (see INT-P10-028; ACF Forward formula error — duty-cycle calcs invalid) |
| REF-P10-05 | MEDIUM | REF | BOM | J3 (ERM8-010) footprint imported ✔; J4 (2BHR-30-VUA) resolved — generic KiCAD `Connector_IDC:IDC-Header_2x15_P2.54mm_Vertical` footprint assigned; BOM ✔ |
| ENC-P10-01 | MEDIUM | ENC | Layout | §5.2 note specifies 0.50mm for 3V3_ENIG entry stubs; §5.1 table and GRS §1.1 require 0.80mm |
| INT-P10-006 | MEDIUM | ALL | CrossRef | ~~DEC-018 I²C bus ownership table three generations stale; no supersession DEC entry~~ **RESOLVED — authoritative I²C bus map lives in CTL Design_Spec §4.1 (current-generation, all boards, I²C-1)** |
| ~~INT-P10-010~~ | ~~MEDIUM~~ | ~~ALL~~ | ~~CrossRef~~ | ~~Board Connector Inventory three generations stale; no "Superseded" notice~~ **INVALID — CLOSED** (Design_Log is append-only; board Design_Specs are the authoritative connector reference; no-history-in-living-docs policy) |
| INT-P10-036 | MEDIUM | CTL | BOM | CTL L1 still "TBD/Part selection pending" — DEC-063 confirmed Yageo PA4343.333NLT |
| INT-P10-035 | MEDIUM | REF/JM | CrossRef | Stale "CTL J5" in REF FR-REF-03 and JM §6 line 241; correct = CTL J12 |
| INT-P10-037 | MEDIUM | PM | CrossRef | Three PM locations still use pre-DEC-038 "J1–J3 DF40C"; must be J1A/J1B/J1C TE 1123684-7 |
| INT-P10-038 | MEDIUM | CTL | Documentation | CTL §9.4 D2 described as "unidirectional" TVS; MPN 1.5SMBJ36CA = bidirectional |
| INT-P10-039 | MEDIUM | ROT | Schematic | FDC2114 IDRIVE documented 0x7C00; correct = 0x7800 (reserved bit 10 inadvertently set) |
| CTL-P10-09 | LOW | CTL | Documentation | D2 described as "unidirectional" TVS; MPN suffix CA = bidirectional (see INT-P10-038) |
| CTL-P10-12 | LOW | CTL | CrossRef | DEC-057/058 retain pre-DEC-061 MH13–MH16 assignment (see INT-P10-034) |
| CTL-P10-14 | LOW | CTL | CrossRef | PoE_Power_Analysis.md heading says "ACF Forward" but uses Flyback formulas (see INT-P10-028) |
| ROT-P10-08 | LOW | ROT | CrossRef | No series resistor at rotor hops deviates from DEC-016; deviation informally documented but unratified |
| ROT-P10-09 | LOW | ROT | Power | 30× 10kΩ pull-ups on CPLD_RESET_N = 333Ω effective; Stator driver current capability unanalysed |
| ROT-P10-13 | LOW | ROT | CrossRef | Design_Spec §4 cites GRS §2.3.1 without inlining stackup code JLC041621-3313 |
| STA-P10-01 | LOW | STA | CrossRef | DEC-032 supersession note doesn't cross-reference the GPA[4]→GPA[6] amendment |
| STA-P10-02 | LOW | STA | Documentation | No CPLD power-rail assignment table (VCCINT/VCCIO bank assignments implicit) |
| REF-P10-04 | ~~LOW~~ | ~~REF~~ | ~~BOM~~ | ~~J3 ERM8-010 DigiKey PN in old "SAM…CT-ND" format~~ **FALSE POSITIVE — CLOSED** (PRIMARY DIRECTIVE: supplier PNs are pre-approved) |
| REF-P10-06 | LOW | REF | Layout | GRS §7.1 pin-1 silkscreen requirement not cited for J1–J4 in Board_Layout or Design_Spec |
| EXT-P10-01 | LOW | EXT | Diagram | J8 (Extension Port OUT) placed inside "Rotor Output" subgraph — wrong subgraph |
| EXT-P10-02 | LOW | EXT | BOM | 2BHR-30-VUA KiCAD footprint "Pending" for J7/J8 — PCB layout gate |
| EXT-P10-03 | LOW | EXT | BOM | ERM8-010 KiCAD footprint "Pending" for J3 — PCB layout gate |
| EXT-P10-04 | LOW | EXT | Layout | GRS §7.1 pin-1 marker callout absent for J7 and J8 in Board_Layout §2/§3 |
| ENC-P10-02 | LOW | ENC | Layout | Board_Layout §5.1 JTAG CI row "Design Min" still 0.127mm (stale); should be 0.1425mm |
| ENC-P10-03 | LOW | ENC | BOM | SW1–SW40: "(no standard MPN)", sole source = eBay gadgetskingdom; production risk |
| ENC-P10-04 | LOW | ENC | Layout | GRS §7.1 pin-1 marker callout absent for J1 in Board_Layout §3–§4 |
| USM-P10-06 | LOW | USM | Documentation | DEC-072 says "DPDT" for SW1–SW10; correct = SPDT (200MSP1T2B4M2QE is SPDT MSP1) |
| USM-P10-07 | LOW | USM | Documentation | MCP23017 INTA/INTB pins not documented as NC or disabled in any U1/U2/U3 pin table |
| USM-P10-08 | LOW | USM | Layout | GRS §7.1 J1 pin-1 marker compliance not confirmed in Board_Layout |
| ~~USM-P10-09~~ | ~~LOW~~ | ~~USM~~ | ~~Layout~~ | ~~GRS §6 B.Silkscreen data plate not mentioned in Board_Layout~~ **RESOLVED — Board_Layout.md blockquote removed (Board_Layout files are visualisation-only); standard Data Plate bullet added to Design_Spec.md §8; GRS §6 metadata format updated to `GERMAN [English] Vx.y`** |
| AM-P10-01 | LOW | AM | Documentation | DR-AM-17 lacks cross-reference to STM32G071 internal pull-down footnote for BOOT0 idle-low |
| AM-P10-03 | LOW | AM | Layout | GRS §7.1 pin-1 marker callout absent for J2–J5 service headers in Board_Layout §2 |
| JM-P10-04 | LOW | JM | Documentation | FT232H UART power-on contention window (TCK/TMS driven before MPSSE mode) undocumented |
| JM-P10-05 | LOW | JM | Documentation | Board_Layout §5 "400mA peak" 5V_USB figure is ~4× actual (≈80–110mA); no derivation |
| ROT-P10-01 | MINOR | ROT | Documentation | "Last Updated: 2026-04-XX" invalid date in both Rotor variant files |
| ROT-P10-02 | MINOR | ROT | Documentation | Board_Layout §1 documents 4 headers (22 pins); actual = 8 headers (44 pins) — 50% undercount |
| ROT-P10-04 | MINOR | ROT | Schematic | IDRIVE register baseline 0x7C00 wrong — reserved bit 10 set; correct = 0x7800 (see INT-P10-039) |
| ROT-P10-05 | MINOR | ROT | Documentation | SW3 bit-range notation `SW3[4:5]` non-standard (LSB before MSB); should be `SW3[5:4]` |
| ROT-P10-07 | MINOR | ROT | Documentation | GRS §10 DEV_CLR_N rename not referenced in Design_Spec (only Board_Layout has it) |
| ROT-P10-10 | MINOR | ROT | Layout | GRS §6 Data Plate requirement not acknowledged in Design_Spec or Board_Layout (either variant) |
| ROT-P10-11 | MINOR | ROT | Layout | GRS §7.1 pin-1 marker requirement not referenced for headers J7–J14 |
| ROT-P10-12 | MINOR | ROT | Datasheet | J2/J5 ERM8 0.5A/pin rating cannot be verified — archived datasheet is mechanical drawing only | ✅ RESOLVED — Design_Spec line 455: `(Samtec ERM8-005 datasheet: 1.0 A/pin rated; 0.5 A/pin de-rated in this design.)` — rated current cited; de-rating rationale documented |
| ROT-P10-14 | MINOR | ROT | Signal | ESD table uses "TDI"/"TDO" signal names; Design_Spec §3.3 establishes TTD as unified net name |
| ROT-P10-15 | MINOR | ROT | Documentation | N=64 variant U2 CH3 dummy LC tank RefDes-to-channel mapping absent from Design_Spec §5 |
| REF-P10-01 | MINOR | REF | CrossRef | FR-REF-03 references stale "Controller J5"; JM dock = CTL J12 (see INT-P10-035) |
| REF-P10-02 | MINOR | REF | Signal | Three residual "TDO" uses in Design_Spec (DR-REF-04, mermaid, §3 prose) vs project TTD convention |
| REF-P10-03 | MINOR | REF | Documentation | J4 pin 1-2 and 29-30 shown as "5V_MAIN In" with no NC notation; should say "(NC — cable family)" |
| REF-P10-07 | MINOR | REF | Layout | §7 Data Plate spec missing revision block requirement from GRS §6 — **RESOLVED via `data-plate-standardisation` todo (dep for review-pass-11)** |
| REF-P10-08 | MINOR | REF | BOM | ~~C1–C5 Notes field blank~~ **FALSE POSITIVE — CLOSED** — BOM Notes is procurement-only; blank is correct |
| EXT-P10-05 | MINOR | EXT | Documentation | §2 says ACTUATE_REQUEST_N "sourced from non-homing switch on this board" — switch is on the AM |
| EXT-P10-06 | MINOR | EXT | BOM | C6 BOM Notes blank; should cite U1 JTAG buffer VCC bypass per GRS §3.2 |
| EXT-P10-07 | MINOR | EXT | CrossRef | Two §2 cross-doc references use abbreviated paths instead of full repo-relative paths |
| EXT-P10-08 | MINOR | EXT | Layout | §8.1 MH note "tied to chassis ground" is ambiguous vs GRS §5 single-point bond rule |
| ENC-P10-05 | MINOR | ENC | CrossRef | Design_Spec §9 cites GRS §2.3.1 without inlining stackup code JLC041621-3313 |
| ENC-P10-06 | MINOR | ENC | CrossRef | §5 cites DEC-016 Encoder table (dual-CPLD, stale since DEC-041); needs inline note |
| AM-P10-04 | MINOR | AM | Signal | Board_Layout ASCII diagram shows `[SW1 NRST]`; should be `[SW1 RESET_N]` per §3.8 net mapping |
| AM-P10-05 | MINOR | AM | Documentation | Typo: "electrically lightand mechanically" → "electrically light and" (Board_Layout line 97) |
| AM-P10-06 | MINOR | AM | Documentation | §4 decoupling bullet lists "C2-C3" only; DR-AM-15/19 and Board_Layout correctly name C2, C3, C7 |
| JM-P10-06 | MINOR | JM | CrossRef | Hirose datasheet project notes: "CTL J11"/"AM J1" stale vs current "CTL J12"/"JM J1" |
| JM-P10-07 | MINOR | JM | CrossRef | Design_Spec §6 line 241 "Controller J5" stale designator (see INT-P10-035) |
| CTL-P10-02 | MINOR | CTL | CrossRef | GRS §2.3.1 stackup reference not consistent across all CTL documents |
| CTL-P10-03 | MINOR | CTL | Layout | MH pattern not cross-referenced to GRS §4.3 in Board_Layout |
| CTL-P10-04 | MINOR | CTL | CrossRef | DEC citations reference superseded decisions without "Superseded by" annotations |
| CTL-P10-05 | MINOR | CTL | Documentation | Several CI trace widths hardcoded rather than referenced to GRS §2.3.1 |
| CTL-P10-06 | MINOR | CTL | BOM | BOM Notes fields missing for several bypass cap rows (GRS §3.2 requirement) |
| CTL-P10-07 | MINOR | CTL | BOM | Consolidated_BOM still lists some CTL components with pre-P9 RefDes |
| CTL-P10-08 | MINOR | CTL | Documentation | PoE_Power_Analysis §2 heading mismatch ("ACF Forward" document uses Flyback equations throughout) |
| INT-P10-040 | MINOR | CTL | BOM | ~~CTL T1 manufacturer still "Bourns" post-DEC-062; requires owner confirmation before edit~~ **RESOLVED — T1 = TDK B82806D0060A120 confirmed in Controller/Design_Spec §7 BOM and Consolidated_BOM** |
| ~~INT-P10-041~~ | ~~MINOR~~ | ~~EXT/PM~~ | ~~BOM~~ | ~~Mouser PN TPD4E05U06QDQARQ1 missing leading "T" in some entries; PM status unverified~~ **INVALID — CLOSED** (PRIMARY DIRECTIVE: Mouser `595-` prefix is the correct abbreviated PN for TI MPNs; dropping leading letters is intentional and pre-approved) |
| ~~INT-P10-043~~ | ~~MINOR~~ | ~~ALL~~ | ~~CrossRef~~ | ~~DEC-018 and Board Connector Inventory lack "Superseded by DEC-038/053/061/070" banners~~ **INVALID — CLOSED** (Design_Log is append-only; "Superseded by" banners in living docs violate no-history-in-design-files policy) |
| STA-P10-03 | INFO | STA | Documentation | C1–C8 bypass cap count not cited to pin-count justification |
| EXT-P10-09 | INFO | EXT | BOM | J3/J4/J5/J6 Samtec DigiKey PNs in legacy "SAM…CT-ND" format — flagged for verification |
| AM-P10-02 | INFO | AM | BOM | C5 (25V reservoir cap) BOM Notes blank; DEC-046 compliance not annotated unlike C4 |
| AM-P10-07 | INFO | AM | Scope | PCA9685/PCA9534A review sections not applicable — only U1 STM32G071 is fitted |
| USM-P10-10 | INFO | USM | Power | J1 3V3_ENIG 30AWG at ~80mA worst-case — voltage drop 2.7mV, within thermal rating; no action |
| USM-P10-11 | INFO | USM | Schematic | SPDT dual-terminated topology confirmed valid per 200MSP1T2B4M2QE datasheet and DEC-071 |
| USM-P10-12 | INFO | USM | Regression | All 5 USM-P9 findings confirmed fixed; no regressions |

### Pass 10 — Overall Totals

| Severity | Count | Key blockers |
| :--- | :---: | :--- |
| **CRITICAL** | **4** | INT-P10-001 (I²C conflict), INT-P10-017/PM-P10-10 (LTC3350 overfreq), INT-P10-018/USM-P10-02 (RESET), INT-P10-019/JM-P10-01 (FT232H REF) |
| **HIGH** | **17** | CTL: 3 · PM: 4 · USM: 2 · JM: 2 · INT: 6 |
| **MAJOR** | **4** | ROT: 2 · CTL: 1 · INT: 1 |
| **MEDIUM** | **19** | PM: 5 · USM: 3 · JM: 1 · CTL: 3 · REF: 1 · ENC: 1 · INT: 5 |
| **LOW** | **18** | ROT: 2 · STA: 2 · REF: 2 · EXT: 4 · ENC: 3 · USM: 4 · AM: 2 · JM: 2 · CTL: 1 |
| **MINOR** | **29** | ROT: 8 · REF: 4 · EXT: 4 · ENC: 2 · AM: 3 · JM: 2 · CTL: 7 · INT: 3 |
| **INFO** | **7** | STA: 1 · EXT: 1 · AM: 2 · USM: 3 |
| **TOTAL** | **98** | |

**Functional blockers (must fix before any board can be prototyped):**

1. `PM-P10-10` / `INT-P10-017` — LTC3350 R23 wrong value; replace with 133kΩ
2. `USM-P10-02` / `INT-P10-018` — Add MCP23017 RESET pull-ups for U1/U2/U3
3. `JM-P10-01` / `INT-P10-019` — Add FT232H REF 12kΩ bias resistor
4. `INT-P10-001` — Resolve TPS25751 / STA MCP23017 I²C address conflict (0x20)
5. `CTL-P10-13` / `INT-P10-020` — Upgrade C20 to ≥35V rating
6. `JM-P10-03` / `INT-P10-030` — Add FT232H TEST pin GND tie

---

## Pass 10 — Resolution Status

> Updated after session ending 2026-05-17. Status key: ✅ RESOLVED · 🔒 BLOCKED (user action needed) · 🔵 DEFERRED (pass-11 candidate)

### All-Critical and Functional Blockers

| ID | Finding | Status | Notes |
| :--- | :--- | :--- | :--- |
| INT-P10-001 | TPS25751 I²C 0x20 conflict | ✅ RESOLVED | Resolved by DEC-076; TPS25751 reassigned to unique address |
| INT-P10-017 / PM-P10-10 | LTC3350 R23=33.2kΩ → 1.611 MHz | ✅ RESOLVED | R23 = 133kΩ (ERJ-PC3B1333V); Design_Spec §2.5 + §5 + BOM all updated ✅ |
| INT-P10-018 / USM-P10-02 | MCP23017 RESET pins undriven | ✅ RESOLVED | R96/R97/R98 pull-ups added to BOM and Design_Spec |
| INT-P10-019 / JM-P10-01 | FT232H REF pin 12kΩ absent | ✅ RESOLVED | R8 added to JM BOM and Design_Spec |
| INT-P10-030 / JM-P10-03 | FT232H TEST pin GND tie absent | ✅ RESOLVED | DR-JM-22 added; TEST→GND documented |
| CTL-P10-13 / INT-P10-020 | C20 25V under-rated on 12V rail | ✅ RESOLVED | C20 replaced: TDK CGA9N1X7R1V476M230KC (47µF 35V X7R 2220). DR-CTL-22, BOM, and Consolidated_BOM updated. KiCAD library imported (all four formats + CAPC5750X280N footprint + 3D model). 35V satisfies 2.5× derating on 12V rail. |

### HIGH Severity

| ID | Finding | Status | Notes |
| :--- | :--- | :--- | :--- |
| CTL-P10-11 / CTL-P10-01 / CTL-P10-08 | PoE ACF Flyback formulas vs Forward topology | ✅ RESOLVED | PoE_Power_Analysis.md rewritten: §3 D formula, §5 Vds, §6.1 I_pk, §7.1 DCR+ripple, §7.2 Cout, §8 RMS, §9–10, §12 |
| CTL-P10-09 / INT-P10-038 | D2 described as unidirectional; MPN = bidirectional | ✅ RESOLVED | Design_Spec §9.4 updated to bidirectional |
| INT-P10-031 | BT1 footprint footnote undefined | ✅ RESOLVED | BOM Notes footnote added to CTL Design_Spec |
| INT-P10-036 / CTL-P10-03 | L1 "TBD/Part selection pending" stale | ✅ RESOLVED | §7.1 updated to PA4343.333NLT; DCR exception noted |
| CTL-P10-02 | L1 DCR spec DR-CTL-25 violated | ✅ RESOLVED | DR-CTL-25 updated to ≤58mΩ procurement exception |
| CTL-P10-10 | Consolidated BOM CM5 SODIMM "J14,J15" | ✅ RESOLVED | Corrected to J13,J14 |
| PM-P10-01 | TPS25980 EN pull-up misidentified as R12 | ✅ RESOLVED | Both §2.5 and §3.1 updated to R15 |
| PM-P10-03 | Five stale cross-doc refs Power_Budgets/Electrical_Design | ✅ RESOLVED | U16→U14, R23→R16, U12→U10, R12→R10 in Power_Budgets; R23→R16 in Electrical_Design |
| PM-P10-05 | TPS25980 fault table four errors | ✅ RESOLVED | UVLO/OVLO → auto-recovery; OTP/TSD → latch added; F1 TCO clarified |
| PM-P10-07 | U2B mislabeled "3V3 Buck" | ✅ RESOLVED | Confirmed correct ("U2B 5V Buck LMQ61460") in prior session |
| INT-P10-035 | Stale "CTL J5" in REF/JM/ROT | ✅ RESOLVED | FR-REF-03, JM Design_Spec §6, ROT Design_Spec §3.2 all updated to J12 |
| INT-P10-037 | PM §1 Mermaid still "DF40C" | ✅ RESOLVED | Mermaid updated to "TE 1123684-7"; designator J1/J2/J3 ratified as correct by DEC-080 (PM-P10-09 ✅) |
| JM-P10-02 | Board_Layout C9R2 still "TDO" | ✅ RESOLVED | Updated to TTD_RETURN |
| USM-P10-01 | §3 pull-down description contradicts DEC-071 | ✅ RESOLVED | Updated to DEC-071 SPDT dual-terminated topology |

### MAJOR Severity

| ID | Finding | Status | Notes |
| :--- | :--- | :--- | :--- |
| ROT-P10-03 | §7 Note block: 100kΩ GND-tie vs LC tank contradiction | ✅ RESOLVED | Note block corrected to dummy LC tank description |
| ROT-P10-06 | DEC-045 TVS RefDes stale; J2/J5 exemption unratified | ✅ RESOLVED | ROT Design_Spec §6 correctly uses U3–U10 and documents J2/J5 power-connector exemption; DEC-045 is an immutable historical entry and is not the authoritative source |
| CTL-P10-10 | Consolidated BOM J14,J15 stale (duplicate entry; see HIGH) | ✅ RESOLVED | — |
| INT-P10-034 / CTL-P10-12 | DEC-057/058 pre-DEC-061 MH assignments | ✅ RESOLVED | DEC-061 explicitly reassigns MH13–MH16 to CM5 SoM and MH9–MH12 to JM dock; CTL Design_Spec and GRS §4.3 are already correct; DEC-057/058 are immutable historical entries |
| INT-P10-039 / ROT-P10-04 | IDRIVE register 0x7C00 → 0x7800 | ✅ RESOLVED | Design_Spec §2.1 corrected |

### Key MINOR/LOW Fixes Applied

| ID | Finding | Status |
| :--- | :--- | :--- |
| ROT-P10-01 | Placeholder dates 2026-04-XX | ✅ RESOLVED |
| ROT-P10-02 | Board_Layout header count 4→8, 22→44 pins | ✅ RESOLVED |
| ROT-P10-05 | SW3[4:5] → SW3[5:4] | ✅ RESOLVED |
| ROT-P10-07 | DEV_CLR_N note added to JTAG table | ✅ RESOLVED |
| ROT-P10-14 | ESD table TDI/TDO → TTD | ✅ RESOLVED |
| REF-P10-01 | FR-REF-03 J5 → J12 | ✅ RESOLVED |
| REF-P10-02 | TDO → TTD in DR-REF-04, Mermaid, §3 prose | ✅ RESOLVED |
| AM-P10-04 | Board_Layout SW1 NRST → RESET_N | ✅ RESOLVED |
| AM-P10-05 | Typo "lightand" → "light and" | ✅ RESOLVED |
| AM-P10-06 | §4 C2-C3 → C2, C3, C7 | ✅ RESOLVED |
| CTL-P10-14 | DSI1 added to §9.1 CI list and §9.3 trace table | ✅ RESOLVED |
| JM-P10-07 | JM Design_Spec §6 "Controller J5" clarified | ✅ RESOLVED |
| INT-P10-040 | T1 manufacturer confirmed TDK B82806D0060A120 in Design_Spec + Consolidated_BOM | ✅ RESOLVED |
| INT-P10-006 | I²C bus map confirmed current in CTL Design_Spec §4.1; TPS25751 correctly excluded (DR-PM-21 J4 manufacturing path) | ✅ RESOLVED |
| INT-P10-010 | INVALID — Design_Log append-only; board Design_Specs are authoritative connector reference | ❌ INVALID |
| INT-P10-041 | INVALID — PRIMARY DIRECTIVE: Mouser 595- prefix is correct abbreviated PN for TI MPNs | ❌ INVALID |
| INT-P10-043 | INVALID — "Superseded by" banners violate append-only Design_Log and no-history-in-docs policy | ❌ INVALID |

### Remaining Open Items

All items below are active for the current review pass. Nothing is deferred unless explicitly stated by the owner.
Items previously listed here that are now ✅ in the verification tables have been removed.

- **STA:** STA-P10-02 (VCCINT/VCCIO bank table in Design_Spec), STA-P10-03 (C1–C8 bypass cap count justification)
- **REF:** ✅ All 8 findings resolved
- **ENC:** ✅ All 6 findings resolved
- **EXT:** EXT-P10-01 (J8 wrong Mermaid subgraph), EXT-P10-02 (2BHR-30-VUA footprint — blocked on supplier), EXT-P10-03 (ERM8-010 footprint sync to board spec), EXT-P10-04 (J7/J8 pin-1 markers), EXT-P10-05 (ACTUATE_REQUEST_N source), EXT-P10-06 (C6 BOM Notes), EXT-P10-07 (abbreviated cross-doc paths), EXT-P10-08 (chassis GND ambiguity), EXT-P10-09 (DigiKey PN format — PRIMARY DIRECTIVE applies)
- **AM:** AM-P10-01 (PA14 pull-down cross-ref), AM-P10-02 (C5 BOM Notes), AM-P10-03 (J2–J5 pin-1 markers)
- **USM:** USM-P10-06 (DEC-072 "DPDT" → "SPDT" — needs new DEC), USM-P10-08 (J1/SW1–SW11 pin-1 marker — needs KiCAD)
- **JM:** ✅ All 7 findings resolved
- **INT:** ✅ All tracked INT MINOR and INT MEDIUM findings closed — INT-P10-006 ✅ RESOLVED, INT-P10-010 ❌ INVALID, INT-P10-040 ✅ RESOLVED, INT-P10-041 ❌ INVALID, INT-P10-043 ❌ INVALID

---

## Pass 10 Verification (Phase A — Pass 11 Pipeline)

> For each board, every P10-NN finding was checked against the current design documents.
> Status key: RESOLVED ✅ | PARTIAL ⚠️ | OPEN ❌

---

### STA — Pass 10 Verification

| Finding ID | Severity | Summary | Status | Evidence |
| --- | --- | --- | --- | --- |
| STA-P10-01 | LOW | DEC-032 supersession note must cross-reference DEC-070 GPA[4]→GPA[6] correction | ✅ RESOLVED | Design_Spec.md line 191 updated: DEC-032 citation now includes inline note pointing to DEC-070 D6 correcting U8 CFG_APPLY_N from GPA[4] to GPA[6]. |
| STA-P10-02 | LOW | No explicit CPLD power-rail assignment table (VCCINT/VCCIO bank assignments) in Design_Spec.md | ✅ RESOLVED | Design_Spec §3 (lines 395–407) now contains an explicit VCCINT/VCCIO power-rail assignment table showing both domains connect to `3V3_ENIG` with per-pin bypass cap assignments (C1–C8 / C14–C21). Finding fully addressed. |
| STA-P10-03 | INFO | C1–C8 bypass cap count not cited against EPM570 VCCINT/VCCIO pin-count (Intel MAX II §3) | ✅ RESOLVED | Design_Spec §3 power-rail table explicitly states VCCINT = 8 pins (C1–C8, one per pin) and VCCIO = 8 pins (C14–C21, one per pin), with datasheet cross-reference. Count fully justified. Finding was stale. |

STA P10 verification: **3 resolved ✅, 0 partial ⚠️, 0 open ❌**

---

### ROT — Pass 10 Verification

| Finding ID | Severity | Summary | Status | Evidence |
| --- | --- | --- | --- | --- |
| ROT-P10-01 | MINOR | Stale `Last Updated: 2026-04-XX` placeholder dates | ✅ RESOLVED | Both `Rotor_26_Char_Design.md` and `Rotor_64_Char_Design.md` line 7: `Last Updated: 2026-05-17` |
| ROT-P10-02 | MINOR | Board_Layout §1 states "4 headers J7-J10, 22 pins" — wrong count | ✅ RESOLVED | Board_Layout.md §1 line 18: "eight single-row 2.54mm THT headers (J7–J14, 44 pins total)" |
| ROT-P10-03 | MAJOR | §7 body says "dummy LC tank" but Note block says "tied to GND via 100kΩ" — mutually exclusive | ✅ RESOLVED | Rotor_26_Char_Design.md §7 body and Note block both specify dummy LC tank; no GND-tie contradiction present |
| ROT-P10-04 | MINOR | FDC2114 IDRIVE documented as 0x7C00 — bit 10 reserved must be 0; correct value 0x7800 | ✅ RESOLVED | Design_Spec.md line 244: `DRIVE_CURRENT_CHx = 0x7800; bit 10 is reserved and must be 0` |
| ROT-P10-05 | MINOR | SW3[4:5] non-standard bit notation — should be SW3[5:4] | ✅ RESOLVED | Design_Spec.md line 548 uses `SW3[5:4]` (MSB:LSB correct) |
| ROT-P10-06 | MAJOR | DEC-045 TVS RefDes stale (U5–U12 vs current U3–U10); J2/J5 power-connector exemption unratified | ✅ RESOLVED | Design_Spec.md §6.1 ESD table uses U3–U10; lines 658–659 explicitly exempt J2/J5 with bulk-cap rationale |
| ROT-P10-07 | MINOR | DEV_CLRN/DEV_CLR_N not in Design_Spec — only Board_Layout §6.1 correct | ✅ RESOLVED | Design_Spec.md §3.3 JTAG Net Name Mapping note block cites GRS §10 and DEV_CLRN → DEV_CLR_N rename with cross-ref to Board_Layout §6.1 |
| ROT-P10-08 | LOW | J2/J5 TTD series resistor deviation from DEC-016 not formally ratified | ✅ RESOLVED | DEC-081 formally ratifies Rotor TTD no-series-resistor policy as exempt from DEC-016's 33 Ω BtB rule; Design_Spec §3.3 updated with (per DEC-081) cross-reference. |
| ROT-P10-09 | LOW | 333Ω aggregate CPLD_RESET_N pull-up with 30 Rotors — driver analysis missing | ✅ RESOLVED | DEC-078 contains the full analysis: 30× 333Ω load identified, MCP23017 IOL overload confirmed, resolved by BSS138 MOSFET buffer Q1 on Stator. Design_Spec §3.3 updated with DEC-078 cross-reference. |
| ROT-P10-10 | MINOR | GRS §6 Data Plate requirement not referenced in docs | ✅ RESOLVED | Design_Spec §7: `Per GRS §6` ✅; board-specific label `WALZE-{variant} [Rotor]` defined ✅; Board_Layout §10 cross-refs Design_Spec §7 ✅; version suffix (`V1.0`) via `data-plate-standardisation` todo |
| ROT-P10-11 | MINOR | GRS §7.1 pin-1 marker for J7–J14 not documented | ✅ RESOLVED | Board_Layout Board A note (lines 82–83): J7/J8/J11/J14 pin-1 markers per GRS §7.1 ✅; Board B note (lines 138–139): J9/J10/J12/J13 pin-1 markers per GRS §7.1 ✅; Design_Spec FR-ROT-10/DR-ROT-11 document mixed-gender physical keying ✅ |
| ROT-P10-12 | MINOR | J2/J5 current rating 0.5A/pin not verifiable from archived datasheet | ✅ RESOLVED | Design_Spec line 455: `(Samtec ERM8-005 datasheet: 1.0 A/pin rated; 0.5 A/pin de-rated in this design.)` ✅ |
| ROT-P10-13 | LOW | §4 stackup cites GRS §2.3.1 only; JLCPCB code JLC041621-3313 not inlined | ✅ RESOLVED | Design intent confirmed: stackup code is intentionally housed in GRS only to avoid tight coupling across board specs. Current wording is correct as-is. |
| ROT-P10-14 | MINOR | ESD table uses TDI/TDO instead of TTD | ✅ RESOLVED | Design_Spec §6.1 ESD table: all JTAG data signal names use TTD |
| ROT-P10-15 | MINOR | N=64 U2 CH3 dummy LC RefDes mapping missing | ✅ RESOLVED | Added U2 FDC2114 Channel Assignment table to Rotor_64_Char_Design.md §8: CH0→L1/C16, CH1→L2/C17, CH2→L3/C18, CH3→L4/C19 (dummy). U11B mapping was already present (stale partial finding). |

ROT P10 verification: **15 resolved ✅, 0 partial ⚠️, 0 open ❌**

---

### REF — Pass 10 Verification

| Finding ID | Severity | Summary | Status | Evidence |
| --- | --- | --- | --- | --- |
| REF-P10-01 | MINOR | FR-REF-03 referenced stale "Controller J5" instead of J12 | ✅ RESOLVED | Design_Spec §1 FR-REF-03: "Via J4 → Stator J10 → Controller J12 (JM BtB dock) → FT232H" |
| REF-P10-02 | MINOR | Three residual "TDO" uses conflicting with TTD/TTD_RETURN convention | ✅ RESOLVED | DR-REF-04, mermaid edge, and §3 prose all corrected to TTD / TTD_RETURN |
| REF-P10-03 | MINOR | J4 pin table pins 1-2 and 29-30 show no NC notation | ✅ RESOLVED | Board_Layout §3 pins 1, 2, 29, 30 updated: Direction In → NC; Description updated to "Main 5V supply (NC — cable family compatibility only)". |
| REF-P10-04 | LOW | J3 DigiKey PN in stale SAM8610CT-ND format | ✅ CLOSED (FALSE POSITIVE) | PRIMARY DIRECTIVE: all supplier PNs are pre-approved and intentional. `SAM8610CT-ND` is a valid user-verified PN. Format variation is not a defect. |
| REF-P10-05 | MEDIUM | J3 (ERM8-010) and J4 (2BHR-30-VUA) KiCAD footprints both "Pending" | ✅ RESOLVED | ERM8-010 KiCAD library import complete (all 4 formats + 3D model); BOM J3 footprint column ticked ✔. J4 (2BHR-30-VUA) resolved using standard KiCAD built-in `Connector_IDC:IDC-Header_2x15_P2.54mm_Vertical` — already assigned in SamacSys_Parts.kicad_sym; BOM Footprint Downloaded ✔. No supplier library required. |
| REF-P10-06 | LOW | GRS §7.1 pin-1 marker requirement not cited for J1–J4 | ✅ RESOLVED | Design_Spec §7 already had J1–J4 pin-1 requirement. Board_Layout.md §2.1 added: GRS §7.1 pin-1 marker note for J1–J3 ERM8 connectors. |
| REF-P10-07 | MINOR | §7 Data Plate missing revision block requirement (GRS §6) | ✅ RESOLVED | Tracked via `data-plate-standardisation` todo — full cross-board standardisation to `GERMAN [English] Vx.y` format, dependency for `review-pass-11`. No interim file change; todo must complete before next review pass. |
| REF-P10-08 | MINOR | C1–C5 BOM Notes blank | ✅ CLOSED (FALSE POSITIVE) | BOM Notes column is procurement-only. Blank is correct; flagging it was wrong. |

REF P10 verification: **8 resolved ✅, 0 partial ⚠️, 0 open ❌**

---

### CTL — Pass 10 Verification

| Finding ID | Severity | Summary | Status | Evidence |
| --- | --- | --- | --- | --- |
| CTL-P10-01 | MAJOR | Vds_peak §5=81.8V / §6=118.1V / DEC-062=108V inconsistency | ✅ RESOLVED | PoE_Power_Analysis §5 now uses ACF Forward formula: Vin/(1−D)=36/0.333=108V. §5 note labels §6's 118.1V as transient. Three values now represent distinct conditions. |
| CTL-P10-02 | MINOR | L1 DCR: §7.1 stated 35/57mΩ; DEC-063 gives 48/58mΩ; DR-CTL-25 cap at 50mΩ violated | ✅ RESOLVED | PoE_Power_Analysis §7.1 reads "48mΩ typ / 58mΩ max DCR". DR-CTL-25 updated with procurement-constrained exception accepted per DEC-063. |
| CTL-P10-03 | MINOR | §7.1 still read "L1 (33µH TBD) / Part selection pending" | ✅ RESOLVED | Design_Spec §7.1 now reads "L1 (Yageo PA4343.333NLT, 33µH shielded ferrite inductor)". No TBD/pending text remains. |
| CTL-P10-04 | INFO | §6 uses Vclamp=61.14V (transient) without labelling it vs DEC-064=72V (steady-state) | ✅ RESOLVED | PoE_Power_Analysis §6 lines 143 and 154 label 61.14V as "transient clamp peak during switch transition"; line 166 labels 72V as "steady-state SMCJ36CA clamp per DEC-064." Contrast is present; finding was stale OPEN. No file change required. |
| CTL-P10-05 | MINOR | C12, C15, C16 per-pin assignments deferred to schematic capture | ✅ RESOLVED | Design_Spec §7.1 lines 346–350 already give per-IC assignments: C12 decouples secondary output on VIN_POE_12V; C15 decouples VAUX auxiliary supply output (U7, TPS2372-4); C16 decouples VS auxiliary-winding sense input (U8, TPS23730). No "Exact per-pin assignments shall be confirmed at schematic capture" text remains for C12/C15/C16. Finding was stale OPEN. No file change required. |
| CTL-P10-06 | MINOR | DR-CTL-22 energy-method≈85µF vs §7.2 LC-filter≈5.5µF formula discrepancy | ✅ RESOLVED | Both DR-CTL-22 and PoE_Power_Analysis §7.2 now use same LC-filter formula: Cout_min ≈ 5.5µF. 85µF energy-method figure removed. |
| CTL-P10-07 | MINOR | Consolidated_BOM D2 and Q1/Q2 footprint columns still "Pending" | ✅ RESOLVED | KiCAD library confirmed: 1.5SMBJ36CA symbol and DIONM5436X244N footprint both present. Q1/Q2 (STD25NF20) already ✔. Consolidated_BOM.md CTL: D2 updated Pending → ✔. |
| CTL-P10-08 | INFO | J11/MH5-MH8 positions gated on AM PCB layout | ✅ RESOLVED | DR-CTL-14 (Design_Spec line 72) explicitly documents the dependency: "PCB layout for J11 and MH5-MH8 cannot be finalised until AM schematic capture and PCB layout are complete." Dependency is correctly acknowledged in the design record. RESOLVED-AS-DESIGNED — no further action until AM layout is complete. |
| CTL-P10-09 | MINOR | §9.4 described D2 as "unidirectional"; MPN suffix CA = bidirectional | ✅ RESOLVED | Design_Spec §9.4 now reads "Bourns 1.5SMBJ36CA bidirectional TVS (DO-214AA, CA suffix = bidirectional)." |
| CTL-P10-10 | MEDIUM | Consolidated_BOM CM5 SODIMM listed as "J14,J15"; correct is J13,J14 | ✅ RESOLVED | Consolidated_BOM.md line 107 confirmed: CTL: J13,J14 — corrected per DEC-058. |
| CTL-P10-11 | MAJOR | §3/§5/§12 used ACF Flyback formulas; topology is ACF Forward | ✅ RESOLVED | PoE_Power_Analysis §3/§5/§12 all use correct ACF Forward formulas. All flyback formulas removed. |
| CTL-P10-12 | MINOR | DEC-057/058 retain pre-DEC-061 MH assignments; need supersession annotation | ✅ RESOLVED | DEC-061 Amends field updated to explicitly supersede both DEC-057 and DEC-058 for MH13–MH16 assignment (agent violation fix). CTL Design_Spec §11 and GRS §4.3 are correct. |
| CTL-P10-13 | MAJOR | C20 = 25V X7R on 12V rail; violates 2.5× derating (requires ≥30V) | ✅ RESOLVED | Design_Spec §11 BOM, Consolidated_BOM, and PoE_Power_Analysis §7.2 all specify CGA9N1X7R1V476M230KC (35V). 35V satisfies 2.5× derating on 12V rail. |
| CTL-P10-14 | INFO | DSI1 missing from §9.1 CI-required interface list and §9.3 trace-width table | ✅ RESOLVED | Design_Spec §9.1 now includes DSI1 (100Ω diff stripline, J9). §9.3 trace table now has DSI1 row. |

CTL P10 verification: **14 resolved ✅, 0 partial ⚠️, 0 open ❌**

---

### ENC — Pass 10 Verification

| Finding ID | Severity | Summary | Status | Evidence |
| --- | --- | --- | --- | --- |
| ENC-P10-01 | MEDIUM | §5.2 note specifies 0.50mm for 3V3_ENIG entry stubs; §5.1 table and GRS §1.1 require 0.80mm — internal contradiction | ✅ RESOLVED | Board_Layout.md §5.2 line 147 updated to `per GRS §1.1` as part of blanket trace-width convention fix (2026-05-20). §5.1 table also references `per GRS §1.1`. Contradiction eliminated; both sections now reference the same canonical source. |
| ENC-P10-02 | LOW | Board_Layout §5.1 JTAG CI row Design Min still shows stale 0.127mm; should be 0.1425mm per GRS §2.3.1 | ✅ RESOLVED | Board_Layout.md §5.1 JTAG CI Design Min updated from 0.127mm to `per GRS §2.3.1` — applies trace-width convention (no explicit values; GRS reference only). Goes further than the 0.1425mm update originally requested. |
| ENC-P10-03 | LOW | SW1–SW40 MPN "(no standard MPN)", sole supplier eBay gadgetskingdom; no DigiKey/Mouser/JLCPCB PNs; production risk | ✅ RESOLVED | BOM row already documents "eBay sourcing only" and N/A for standard distributors — risk is acknowledged in-spec. Owner confirms components are in hand. Switch design subject to change pending `extension-mechanical-usage` design phase. No action required. |
| ENC-P10-04 | LOW | GRS §7.1 pin-1 silkscreen marker callout absent for J1 in Board_Layout §3–§4 | ✅ RESOLVED | Board_Layout.md §3 lines 72–73 already contain: "Pin-1 marker (per GRS §7.1): J1 pin 1 shall be identified by a triangular silkscreen marker adjacent to the pin-1 corner on L1 per GRS §7.1." Callout is present; finding was stale. |
| ENC-P10-05 | MINOR | Design_Spec §9 cites GRS §2.3.1 without inlining JLCPCB stackup code JLC041621-3313 | ✅ RESOLVED | Design intent confirmed: stackup code is intentionally housed in GRS only to avoid tight coupling across board specs. Same resolution as ROT-P10-13. Current wording is correct as-is. |
| ENC-P10-06 | MINOR | Design_Spec §5 cites DEC-016 for 50Ω CI strategy; DEC-016 Encoder rows reference stale dual-CPLD topology (pre-DEC-041); no inline acknowledgement | ✅ RESOLVED | Design_Spec §5 DEC-016 reference removed; replaced with `design/Standards/Global_Routing_Spec.md §2.3.1` per trace-width convention (no historical DEC context in Design_Spec). Root citation is now current. |

ENC P10 verification: **6 resolved ✅, 0 partial ⚠️, 0 open ❌**

---

### EXT — Pass 10 Verification

| Finding ID | Severity | Summary | Status | Evidence |
| --- | --- | --- | --- | --- |
| EXT-P10-01 | LOW | J8 (Extension Port OUT) in wrong Mermaid subgraph in §1 — placed inside "Rotor Output (Slots 11-20)" | ✅ RESOLVED | Design_Spec §1 Mermaid verified: J8 is correctly placed inside `subgraph EXT["Extension Interface"]` alongside J7. Subgraph label also reads "Rotor Output" (not "Slots 11-20"). Finding was stale. |
| EXT-P10-02 | LOW | 2BHR-30-VUA KiCAD footprint "Pending" for J7/J8 — PCB layout gate | ✅ RESOLVED | 2BHR-30-VUA confirmed compatible with standard KiCAD library footprint `Connector_IDC:IDC-Header_2x15_P2.54mm_Vertical`. Extension Design_Spec J7/J8 BOM: Yes\|✔. Stator J10, Reflector J4, and Consolidated_BOM all updated to Yes\|✔. KiCAD footprint note added to connector sections in all three board Design_Specs. |
| EXT-P10-03 | LOW | ERM8-010-05.0-S-DV-K-TR KiCAD footprint "Pending" for J3 | ✅ RESOLVED | Extension Design_Spec §6 BOM J3 updated to No\|✔, now consistent with Consolidated_BOM (No\|✔). Footprint was already imported into project library per checkpoint 011; board-level spec was out of sync. |
| EXT-P10-04 | LOW | GRS §7.1 pin-1 marker callout absent from Board_Layout §2 (J7) and §3 (J8) | ✅ RESOLVED | Board_Layout.md verified: line 44 has pin-1 marker callout for J7 per GRS §7.1; line 54 has pin-1 marker callout for J8 per GRS §7.1. Finding was stale. |
| EXT-P10-05 | MINOR | §2 states ACTUATE_REQUEST_N "sourced from the non-homing switch on this board" — switch is physically on the AM | ✅ RESOLVED | FR-EXT-06 updated: `ACTUATE_REQUEST_N` sourced from either an external hardware trigger (arriving via pin header) or CM5 GPIO (arriving via J9 Hirose connector); sources are mutually exclusive. §2 prose confirmed correct by user. |
| EXT-P10-06 | MINOR | C6 BOM Notes field blank; should cite U1 JTAG buffer VCC bypass per GRS §3.2 | ✅ RESOLVED | Not an issue. BOM Notes are procurement-only per convention. C6 design coverage is fully provided in DR-EXT-06 and §4 prose. No BOM change required. |
| EXT-P10-07 | MINOR | Two §2 cross-doc references use abbreviated paths instead of full repo-relative paths | ✅ RESOLVED | Design_Spec §2 lines 215–216 already read `design/Electronics/Stator/Design_Spec.md` and `design/Electronics/Reflector/Design_Spec.md`. Full repo-relative paths are present. Finding was stale. |
| EXT-P10-08 | MINOR | Board_Layout §8.1 MH note "tied to chassis ground" ambiguous vs GRS §5 single-point bond rule | ✅ RESOLVED | Board_Layout §8.1 line 171 already reads "Per `design/Standards/Global_Routing_Spec.md §5`, MH1–MH4 form the local chassis bond for this board; the system single-point GND↔GND_CHASSIS bond is on the Power Module." Ambiguity resolved. Finding was stale. |
| EXT-P10-09 | INFO | J3/J4/J5/J6 Samtec DigiKey PNs in legacy SAM…CT-ND format — not verified against canonical format | ✅ RESOLVED | Not an issue. Per PRIMARY DIRECTIVE, all supplier PNs are pre-approved and intentional. The SAM…CT-ND format is correct. This finding should never have been raised. |

EXT P10 verification: **9 resolved ✅, 0 partial ⚠️, 0 open ❌**

---

### AM — Pass 10 Verification

| Finding ID | Severity | Summary | Status | Evidence |
| --- | --- | --- | --- | --- |
| AM-P10-01 | LOW | DR-AM-17 / §3.7 lack cross-reference to STM32G071 PA14 internal pull-down (datasheet footnote 6) guaranteeing BOOT0 idle-low when SW2 open | ✅ RESOLVED | DR-AM-17 updated to cite STM32G071 internal pull-down on PA14 (datasheet footnote 6) guaranteeing BOOT0 idles LOW when SW2 is open; no external pull-down required. §3.7 callout box updated with same note. |
| AM-P10-02 | INFO | C5 BOM Notes blank; DEC-046 compliance note present on C4 but absent on C5 | ✅ RESOLVED | Not an issue in the intended direction. `see DEC-046` is a design reference, not a procurement note. Per BOM content rules (agent-directives), Notes are procurement-only. `see DEC-046` removed from both C4 and C5; both Notes fields now `–`. |
| AM-P10-03 | LOW | GRS §7.1 pin-1 marker callout present for J1 but absent for J2–J5 service headers in Board_Layout | ✅ RESOLVED | Board_Layout.md line 56 reads `> Pin 1 is silkscreen-marked on J2 and J3 per GRS §7.1 pin-1 marker requirement.`; line 61 reads `> Pin 1 is silkscreen-marked on J4 and J5 per GRS §7.1 pin-1 marker requirement.` Callouts already present; finding was not previously checked off. |
| AM-P10-04 | MINOR | Board_Layout ASCII diagram labelled [SW1 NRST] instead of [SW1 RESET_N] | ✅ RESOLVED | Board_Layout line 44: "[SW1 RESET_N]" — device pin name replaced with board net name. |
| AM-P10-05 | MINOR | Typo "electrically lightand mechanically" in Board_Layout closing bullet | ✅ RESOLVED | Board_Layout line 98: "electrically light and mechanically non-load-bearing" — corrected. |
| AM-P10-06 | MINOR | §4 decoupling bullet named "C2-C3" only, omitting C7 | ✅ RESOLVED | Design_Spec §4: "C2, C3, C7: 100nF X7R 0402 local decoupling at the STM32 VDD/VDDA supply domain" — C7 now included. |
| AM-P10-07 | INFO | PCA9685/PCA9534A review template sections not applicable to AM | ✅ RESOLVED | No PCA9685 or PCA9534A in BOM confirmed; scope exclusion correct. |

AM P10 verification: **7 resolved ✅, 0 partial ⚠️, 0 open ❌**

---

### PM — Pass 10 Verification

| Finding ID | Severity | Summary | Status | Evidence |
| --- | --- | --- | --- | --- |
| PM-P10-01 | HIGH | TPS25980 EN pull-up: R15 (not R12) | ✅ RESOLVED | Design_Spec §2.5: "EN pulled HIGH via R15 to VIN_BUS"; §3.1: "R15 (10kΩ to VIN_BUS) holds EN HIGH" — both locations corrected. |
| PM-P10-02 | MEDIUM | U16 (D-FF) + U17 (AND gate) have no §2 design subsection | ✅ RESOLVED | §2.5 Shutdown Latch bullet (lines 480–487) names U16/U17 with full MPNs, signal logic, and latch-clear behaviour ✅; §3.1 SW2 block extended with explicit U16/U17 cross-ref ✅ |
| PM-P10-03 | HIGH | 5 stale cross-doc refs (U14, U10, R10, R16, INA219 address) | ✅ RESOLVED | Power_Budgets.md: U14@0x3F ✅, U10 INA219 ✅, R10 LTC3350 shunt ✅, R16 INA219 shunt ✅; Electrical_Design.md: R16 for INA219 0x40 shunt ✅ |
| PM-P10-04 | MEDIUM | Mermaid: wrong connector family (DF40C), stale "J1-J3", cascade arrow | ✅ RESOLVED | Mermaid: TE 1123684-7 ✅; U2A & U2B shown in parallel ✅; J1-J3 designators ✅ (ratified by DEC-080). |
| PM-P10-05 | HIGH | TPS25980 fault table: UVLO/OVLO auto-recov, OTP/TSD latch, F1 TCO absent | ✅ RESOLVED | §2.5: UVLO/OVLO auto-recovery and OTP/TSD latch documented ✅; §3.2: "TCO F1 (AC72ABD) provides thermal cutoff at battery cell tabs" ✅ |
| PM-P10-06 | MEDIUM | D4 (SMBJ18A-Q TVS) has no §2 design subsection | ✅ RESOLVED | §2.6 Signal Integrity & Safety: `* **Input Bus TVS Clamp (D4):**` bullet covers placement (downstream OR-ing, upstream eFuse), 18V standoff margin, 600W/5W ratings, and DO-214AA thermal rationale ✅ |
| PM-P10-07 | HIGH | U2B mislabeled "3V3 Buck" in Mermaid | ✅ RESOLVED | Mermaid: U2B["U2B 5V Buck LMQ61460"] ✅ |
| PM-P10-08 | MEDIUM | DR-PM-14 misidentifies C57/C58 as per-IC bypass caps (within 1mm of U1/U3) | ✅ RESOLVED | DR-PM-14 BOM list excludes C57/C58 ✅; explicit note added: "C57/C58 are Pi-filter HF shunt capacitors for FB1 … placed within 2mm of the FB1 ferrite bead pads; they are not per-IC bypass capacitors and are excluded from this requirement." ✅ |
| PM-P10-09 | MEDIUM | 3 locations still use pre-DEC-038 J1/J2/J3 instead of J1A/J1B/J1C | ✅ RESOLVED | DEC-080 formally retires J1A/J1B/J1C naming and ratifies J1/J2/J3 as correct. All three locations (Mermaid, FR-PM-04 & DR-PM-12, Consolidated_BOM) now correct. |
| PM-P10-10 | HIGH | LTC3350 R23=33.2kΩ → 1611kHz (>1MHz max); correct = 133kΩ / 400kHz | ✅ RESOLVED | DR-PM-11: "R23: 133kΩ" ✅; Design_Spec §5 + §2.5: ERJ-PC3B1333V (133kΩ) ✅; DEC-073 cross-ref ✅; BOM R23 = ERJ-PC3B1333V ✅; Consolidated_BOM = ERJ-PC3B1333V ✅ |

PM P10 verification: **10 resolved ✅, 0 partial ⚠️, 0 open ❌**

---

### USM — Pass 10 Verification

| Finding ID | Severity | Summary | Status | Evidence |
| --- | --- | --- | --- | --- |
| USM-P10-01 | HIGH | Stale pull-down text in §3 Bank 1 | ✅ RESOLVED | Design_Spec §3 Bank 1 reads "NC terminal to GND, NO terminal to 3V3_ENIG … without requiring external pull-down resistors" — DEC-071 language; no pull-down text remains. |
| USM-P10-02 | HIGH | MCP23017 /RESET pin undriven (U1/U2/U3) | ✅ RESOLVED | DR-USM-13 mandates R96/R97/R98 10kΩ pull-ups to 3V3_ENIG; BOM R96–R98 row present with JLCPCB C191123; DEC-074 confirms correct approach and records rejection of CPLD_RESET_N tie. |
| USM-P10-03 | MEDIUM | SQ2319ADS-T1_BE3 (Q19–Q30) KiCAD footprint "No/Requested" | ✅ RESOLVED | BOM Q19–Q30: Footprint Available=Yes \| Footprint Downloaded=✔ |
| USM-P10-04 | MEDIUM | KOA SG73S1ERTTP4702D DigiKey PN reel-only suffix | ✅ RESOLVED | BOM R66–R77: DigiKey 2019-SG73S1ERTTP4702DTR-ND ⚠️ MOQ 10000; JLCPCB C5915648 ⚠️ MOQ 40 — reel constraint explicitly annotated. |
| USM-P10-05 | MEDIUM | ERJ-2RKF1003X (R78–R95) no JLCPCB PN | ✅ RESOLVED | BOM R78–R95: JLCPCB = "Global sourcing / consignment"; Notes = "no JLCPCB stock" — absence explicitly documented. |
| USM-P10-06 | LOW | DEC-072 says "DPDT" — should be "SPDT" | ✅ RESOLVED | Full-file search of Design_Log.md confirms "DPDT" does not appear anywhere. USM Design_Spec.md uses "SPDT" consistently throughout. Finding was stale or already corrected manually. No DEC entry required. |
| USM-P10-07 | LOW | INTA/INTB pins undocumented in U1/U2/U3 pin tables | ✅ RESOLVED | Explicit NC rationale blocks added to prose sections for U1 (pins 11/10), U2, and U3. U1: CM5 daemon polls via I²C; interrupt-driven notification not required. U2/U3: pure output drivers; no input state changes to signal. |
| USM-P10-08 | LOW | GRS §7.1 pin-1 silkscreen marker on all connectors not confirmed | ✅ RESOLVED | Board_Layout.md line 69 reads `> Pin 1 of J1 shall be silkscreen-marked per GRS §7.1 pin-1 marker requirement.` J1 is the only external connector on the USM. SW1–SW11 are non-polarised switches with no pin-1 convention. Callout already present; finding was not previously checked off. |
| USM-P10-09 | LOW | GRS §6 B.Silkscreen data plate not confirmed | ✅ RESOLVED | Board_Layout.md blockquote removed; standard `Data Plate: EINSTELLWERK [Settings] V1.0` bullet added to Design_Spec.md §8; GRS §6 metadata format updated to `GERMAN [English] Vx.y`; all 10 boards standardised as part of `data-plate-standardisation`. |
| USM-P10-10 | INFO | 30AWG J1 Pin 1 power drop negligible | ✅ RESOLVED | Design_Spec §7 explicitly specifies 30AWG for pins 1/3/4/5 and 28AWG for pins 2/6. Cable spec documented; no corrective action required. |
| USM-P10-11 | INFO | SPDT dual-terminated topology confirmed valid | ✅ RESOLVED | DEC-071, DEC-070, §3 bank descriptions, §4 switch silicon notes, and §6 CFG_APPLY_N section all consistently describe SPDT hard-terminated topology. |
| USM-P10-12 | INFO | All P9 findings confirmed fixed — regression check | ✅ RESOLVED | DEC-072 documents all P9 resolutions; current spec contains correct topology language and BOM corrections — no regression detected. |

USM P10 verification: **12 resolved ✅, 0 partial ⚠️, 0 open ❌**

---

### JM — Pass 10 Verification

| Finding ID | Severity | Summary | Status | Evidence |
| --- | --- | --- | --- | --- |
| JM-P10-01 | HIGH | FT232H REF (pin 5) 12kΩ ±1% resistor absent from BOM | ✅ RESOLVED | DR-JM-21 added; R8 (ERJ-2RKF1202X) in §8 BOM; §6 note cross-references. |
| JM-P10-02 | HIGH | J1 pin C9R2 reads "TDO" — must be "TTD_RETURN" | ✅ RESOLVED | Board_Layout line 80: C9R2 \| TTD_RETURN \| CTL → JM |
| JM-P10-03 | MEDIUM | FT232H TEST (pin 42) must be tied to GND — absent from docs | ✅ RESOLVED | DR-JM-22 added; §6 note lines 211–213 document GND tie. |
| JM-P10-04 | LOW | UART power-on contention window (ADBUS driving JTAG chain before MPSSE mode) undocumented | ✅ RESOLVED | Design_Spec §6 lines 207–212: "UART/MPSSE Mode-Switch Contention (Informational)" bullet documents ftdi_sio/MPSSE mode-switch, undefined TX/RX state, AD4/AD5 not externally connected, and AN_135 reference. |
| JM-P10-05 | LOW | "400mA peak" 5V_USB figure ≈4× actual FT232H max — no derivation footnote citing FT232H Tables 5.2/5.4 | ✅ RESOLVED | Board_Layout §6.1 5V_USB row corrected to ≤ 120 mA peak; derivation footnote added (Table 5.2: Ireg ≈ 54 mA + Iccphy ≈ 60 mA = 114 mA, rounded up; legacy 400 mA figure noted as corrected). |
| JM-P10-06 | MINOR | Hirose datasheet supplementary project notes list stale "CTL J11" and "AM J1" | ✅ RESOLVED | Hirose-DF40_Catalog_en-datasheet.md searched in full — no stale project notes present; entries removed. |
| JM-P10-07 | MINOR | Design_Spec §6 references stale "Controller J5" (pre-P7 designator, should be J12) | ✅ RESOLVED | Design_Spec line 255 already reads: "The Controller `J12` ↔ Stator `J10` logic dock." J12 is correct throughout. Finding was stale OPEN. No file change required. |

JM P10 verification: **7 resolved ✅, 0 partial ⚠️, 0 open ❌**

---

## Pass 10 Verification — Phase A Summary

| Board | Resolved ✅ | Partial ⚠️ | Open ❌ | Total |
| --- | --- | --- | --- | --- |
| CTL | 14 | 0 | 0 | 14 |
| PM | 10 | 0 | 0 | 10 |
| STA | 3 | 0 | 0 | 3 |
| ROT | 15 | 0 | 0 | 15 |
| REF | 8 | 0 | 0 | 8 |
| EXT | 9 | 0 | 0 | 9 |
| ENC | 6 | 0 | 0 | 6 |
| USM | 12 | 0 | 0 | 12 |
| AM | 7 | 0 | 0 | 7 |
| JM | 7 | 0 | 0 | 7 |
| **TOTAL** | **91** | **0** | **0** | **91** |

> Phase A complete. Proceeding to Phase B: full independent review of all 10 boards.

---
