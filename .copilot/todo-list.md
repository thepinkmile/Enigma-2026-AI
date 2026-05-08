# Enigma-NG Project Todo List

> **Canonical deferred-work and open-action reference.** Updated as work progresses.
> See also `.copilot/plan.md` for current workstream status and `.copilot/agent-directives.md` for operational rules.
>
> **Design Log Open Questions** are tracked separately in `design/Design_Log.md` under `## Open Questions`.
> Do not duplicate them here — that file is the authoritative source for formally raised design questions.
>
> **SQL tracking:** At the start of each session, populate the local SQLite `todos` and `todo_deps` tables
> from the SQL Reconstruction Reference section at the bottom of this file. That section is the authoritative
> dependency source; the in-session SQL is a convenience tracker only and does not persist across sessions.

Last updated: 2026-05-08

---

## Open Workstreams (Plan-Level)

Long-running workstreams; tracked in `.copilot/plan.md` Current Open Workstreams table.

| ID | Description | Status | Source |
| --- | --- | --- | --- |
| `extension-mechanical-usage` | Detailed switch/linkage geometry for Extension boundary carry is still needed; architectural answer (shared AM) is locked but physical linkage spec is not | pending | `plan.md` |
| `coupon-testing-review` | Add and review board-level coupons and PAS-oriented test coverage so production boards do not retain test-only hardware. Depends on: `extension-mechanical-usage` (connector changes likely) | pending | `plan.md` |
| `battery-connector-final-review` | Re-confirm Glenair `807-216-00ZNU6-6DY` contact assignment, `BATT_PRES_N` position, reserved-contact behaviour, cable selection, and interposer fit; check ODU AMC NP lead before closing | **🔒 blocked** — awaiting external supplier response | `plan.md` |
| ~~`general-pin-mapping-schematic-capture`~~ | ~~Footprints now available in KiCAD library; schematic capture can begin~~ | ~~done~~ | ~~`plan.md`~~ |
| `rerun-deep-reviews` | Final pre-V1 cross-discipline deep-review cycle — run only once electrical, mechanical, and software work are complete and each board has a full KiCAD project with exported production Gerbers | pending | `plan.md` |

---

## Electronics Deferrals

| ID | Description | Status | Ref | Source |
| --- | --- | --- | --- | --- |
| ~~`ctlh1-deferred`~~ | ~~Controller CTL-H1 finding: explicitly deferred by user during Pass 2 review cycle~~ | ~~✔ DONE~~ | ~~—~~ | ~~Resolved checkpoint 076: R1/R2 stale placeholders removed; R3–R6 renumbered R1–R4~~ |
| ~~`rotor-power-analysis-ministack`~~ | ~~Recalculate Rotor `Board_Layout.md §7` power analysis for mini-stack architecture. Currently assumes a single daisy-chain of 30 rotors (worst-case J2 input 1.65 A at Rotor 1). Architecture uses mini-stacks of max 5 rotors with an Extension Board re-introducing clean 3V3_ENIG at each mini-stack start — worst case is now 5 × 55 mA = 275 mA. Update: worked example, inline table (Rotor 1/15/30 rows), trace width table §7.1, and §7.2 notes. Also verify Extension Board power re-injection connector sizing.~~ | ~~✔ DONE~~ | ~~DEC-053~~ | ~~Checkpoint 098: power analysis rewritten for mini-stack; Extension connector under-spec discovered and resolved in checkpoint 099 (BHR-20-VUA → 2BHR-30-VUA)~~ |
| ~~`rotor-esd-tvs`~~ | ~~PRTR5V0U10AZ placeholder superseded; TPD4E05U06QDQARQ1 selected (reused from PM/CTL — no new part). U5–U12 fully defined in Design_Spec.md §6 and Board_Layout.md. All supplier PNs in Consolidated BOM.~~ | ~~✔ DONE~~ | ~~—~~ | ~~Resolved prior session; confirmed 2026-05-03~~ |
| ~~`rotor-variant-refdes-schematic`~~ | ~~Rotor variant A/B suffix convention agreed and implemented: U3→U3A, U4→U3B; all associated bypass caps (C16A/C17A/C16B/C17B) and resonant-tank components (C22A–C25A/C22B–C25B, L5A–L8A/L5B–L8B) renamed throughout Design_Spec.md, Board_Layout.md, Rotor_26_Char_Design.md, Rotor_64_Char_Design.md, and Consolidated_BOM.md. DEC-052 logged. KiCAD schematic will use U3A/U3B as unique RefDes with N26/N64 project variants selecting DNP flags.~~ | ~~✔ DONE~~ | ~~DEC-052~~ | ~~This session (2026-05-01); deferred until schematic capture~~ |
| `display-addon-board` | 🚫 **DEFERRED TO V2.0.** Display add-on board design: J9 (Amphenol F52Q) on Controller is the only fixed connector; display power, touch wiring, and auxiliary harness remain deferred with the add-on board definition | blocked | DEC-033 | `design/Electronics/Controller/Design_Spec.md §8` |
| `cpld-production-replacement` | 🚫 **DEFERRED TO V2.0.** Review replacement CPLD for production stage (current MAX II EPM570 is a prototype-grade selection); update Certification Evidence §7.1 when confirmed | blocked | OA-04 | `design/Standards/Certification_Evidence.md` |
| ~~`connector-thermal-verification`~~ | ~~Thermal / current-capacity verification of active PM and Stator dock connectors (TE `1-1674231-1` / `1123684-7` and Molex `2195630015` / `2195620015`); full derating analysis documented in Certification Evidence §5.1. Temperature exception noted for TE connector (−20°C continuous vs DEFSTAN −40°C target); thermal shock test to −40°C cited as supporting evidence. Formal TE confirmation recommended before DEFSTAN submission.~~ | ~~done~~ | ~~OA-05~~ | ~~`design/Standards/Certification_Evidence.md §5.1`~~ |
| ~~`rotor-refdes-reallocate`~~ | ~~Rotor board RefDes gap removal: BOM previously ran R2–R7 (no R1). Reallocated to R1–R6 with matching updates to `Design_Spec.md` BOM table, `Board_Layout.md` references, and `Consolidated_BOM.md` Rotor rows. Completed checkpoint 165.~~ | ~~✔ DONE~~ | ~~—~~ | ~~2026-05-03~~ |
| `full-pn-review` | Full supplier PN review of all BOM entries before schematic capture — a prior session that reduced component package sizes appears to have corrupted supplier PNs on at least two components (ERJ-2RKF1001X, CL05B104KB5NNNC), substituting codes pointing to entirely different parts. A sweep of all DigiKey / Mouser / JLCPCB PNs against their MPNs is required before KiCAD work begins. Depends on: `connector-thermal-verification`, `extension-mechanical-usage`, `battery-connector-final-review`, `ctlh1-deferred`, `rotor-esd-tvs`, `coupon-testing-review` | pending | — | 2026-05-02 supplier PN audit |
| `footprint-requests-pending` | Footprints requested but not yet received; update BOM and library when each arrives: **BAT54** (Diotec SOT-23) — requested, **AC72ABD** (72°C SMD thermal cutoff) — requested, **BMC-Q2AY0600M** (TE 600Ω 0805 AEC-Q200 ferrite bead) — requested, **2BHR-30-VUA** (Adam Tech 30-pin 2×15 IDC box header, JLCPCB C17346400; used at STA:J10, REF:J4, EXT:J7/J8) — requested, **TPS75733KTTRG3** (Texas Instruments 3.3V LDO TO-263-5) — ⚠️ footprint ready, no 3D model yet — download on next session, **MCP121T-450E/LB** (Microchip 4.5V supervisor SC70-3) — ⚠️ footprint ready, no 3D model yet — download on next session. Add further pending requests here as they arise. Depends on: `full-pn-review` | pending | — | 2026-05-02 |
| ~~`bom-func-notes-sweep`~~ | ~~Remove function descriptions from all BOM tables across ALL design files. BOM may only contain RefDes / MPN / Manufacturer / Spec / Supplier PNs / Qty / procurement Notes. Pre-condition: new BOM Content directive committed. Deferred per user instruction (F-PM-09/F-PM-10). Depends on: all board Design_Spec.md files stable.~~ | ~~✔ DONE~~ | ~~All boards swept; PM calc equations added to spec body~~ | ~~2026-05-08~~ |
| ~~`m25-m3-dec-exception`~~ | ~~Record DEC exception for M2.5 mounting holes on daughterboards: AM, ENC, and ROT boards use M2.5 (not M3 per GRS §4) because they mount to other PCBs rather than chassis. MH must tie to GND (not GND_CHASSIS). Covered by GRS §5 (Daughterboard exception) and DEC-057.~~ | ~~✔ DONE~~ | ~~DEC-057, GRS §5~~ | ~~2026-05-06~~ |
| ~~`jdb-standoff-height`~~ | ~~Determine JDB hat-header stacking height and select correct M2.5 SMT standoff PN; review whether a DF40 BtB connector upgrade (same as AM) was appropriate. Resolved: upgraded to Hirose DF40C-20DP BtB connector (DEC-058); MH13–MH16 on CTL use Wurth 9774035151R (same as AM dock). BOM entries added to CTL Design_Spec.md.~~ | ~~✔ DONE~~ | ~~DEC-057, DEC-058~~ | ~~2026-05-07~~ |
| ~~`mh-refdes-standardise`~~ | ~~Standardise mounting hole RefDes across all boards per DEC-057/DEC-058. Canonical scheme: MH1–4 = chassis/module holes (Pattern A/B, no BOM), MH5–8 = AM dock standoffs, MH9–12 = JM dock standoffs, MH13–16 = CM5 SoM standoffs. CTL renumbered: chassis MH9–12→MH1–4, JM dock MH13–16→MH9–12, CM5 MH1–4→MH13–16. EXT already correct (MH1–4=chassis, MH5–8=AM). GRS §4.3 Named Exceptions CTL row updated. JM Design_Spec/Board_Layout CTL-ref standoffs updated to MH9–12. Consolidated_BOM updated.~~ | ~~✔ DONE~~ | ~~CTL renumbered this session; GRS §4.3, JM docs, CBOM all updated~~ | ~~2026-05-08~~ |
| ~~`jdb-fr-renumber`~~ | ~~JDB Design_Spec.md deferred cleanup: FR-JDB-02 and FR-JDB-03 were collapsed into a single requirement; renumber remaining FRs consecutively. Broadened audit of all 22 Design_Spec.md files confirmed **no gaps** in any owning spec. JDB FR-JDB-01/02 already consecutive after collapse. All apparent gaps were cross-references to other boards' IDs.~~ | ~~✔ DONE~~ | ~~—~~ | ~~2026-05-07~~ |
| `jdb-ft232h-3v3-vregin` | 🚫 **DEFERRED TO V2.0.** FT232H Rev C supports 3.0–3.6V VREGIN, which would allow JDB to run entirely from 3V3\_ENIG and eliminate the 5V\_USB pin from the DF40 connector. Defer until Rev C availability is confirmed. Same priority as `display-addon-board`. | blocked | DEC-058 | 2026-05-07 |

---

## Mechanical Deferrals

Depends on: `prototype-pcb-manufacturing`, `ltc3350-telemetry`, `cpld-timing-load` (all three must be done before any mechanical work can be closed).

| ID | Description | Status | Source |
| --- | --- | --- | --- |
| `rotor-shaft-diameter` | Central shaft hole diameter for Rotor PCBs: Ø10mm nominal; final size TBD once Rotor Actuation Assembly shaft diameter is fixed (8–12mm range) | pending | `design/Mechanical/Rotor/Design_Spec.md`; `design/Electronics/Rotor/Board_Layout.md` |
| `rotor-rolling-element` | Rolling element diameter: TBD; matched set required for even load (±0.01mm) | pending | `design/Mechanical/Rotor/Design_Spec.md` |
| `rotor-alloy-grade` | Rotor disc aluminium alloy grade: TBD — 6061-T6 suggested for machinability; confirm before manufacture | pending | `design/Mechanical/Rotor/Design_Spec.md` |
| `rotor-shaft-mechanism` | Rotor shaft retention mechanism: TBD — pending Rotor Actuation Assembly spec | pending | `design/Mechanical/Rotor/Design_Spec.md` |
| `display-aperture` | 🚫 **DEFERRED TO V2.0.** Main enclosure display aperture dimensions: TBD pending display size selection (up to 10" supported via DSI1); deferred display auxiliary hinge space also unresolved | blocked | `design/Mechanical/Main_Enclosure/Design_Spec.md` |
| `system-assembly-harnesses` | Complete System Assembly cable harness definitions: TBD — 20-pin encoder IDC ribbons, reflector cable, fan cable, User Settings Module I²C ribbon, switch / battery harnesses | pending | `design/Mechanical/Complete_System_Assembly/Design_Spec.md` |
| `system-assembly-connectors` | Document inter-board connections from an assembly perspective in `Complete_System_Assembly/Design_Spec.md`: describe which boards mate to which (PM dock cluster J1/J2/J3 ↔ CTL J1/J2/J3; Stator dock pair CTL J4/J5 ↔ STA J11/J12; rotor-family BtB; servo/fan harnesses; encoder IDC), noting enclosure constraints (e.g. blind-mate requirements, cable routing, access for post-assembly removal). Connector part numbers are already specified in the board-level Design_Spec files — this task is assembly description only. | pending | `design/Mechanical/Complete_System_Assembly/Design_Spec.md` |

---

## Software Deferrals

Depends on: `rerun-deep-reviews` + `prototype-pcb-manufacturing` (both required before SW deferrals can be actioned).

| ID | Description | Status | Ref | Source |
| --- | --- | --- | --- | --- |
| `ltc3350-telemetry` | LTC3350 I²C telemetry support in Linux OS power-management driver: deferred to Software PoC stage, pending hardware availability | pending | DEC-025 | `design/Software/Linux_OS/Power_Management.md §2` |
| `cpld-timing-load` | CPLD Encoder Logic timing and electrical load characterisation (propagation delays, fanout, drive current): deferred until first prototype boards exist for measurement | pending | — | `design/Software/CPLD_Logic/Encoder_Logic.md §2` |

---

## Standards & Certification Actions

Items from `design/Standards/Certification_Evidence.md §8`. All depend on `prototype-system-complete`.

| SQL ID | DA Ref | Description | Priority | Status |
| --- | --- | --- | --- | --- |
| ~~`da-01`~~ | ~~DA-01~~ | ~~If coupon-based diagnostic access is introduced, exposed ENIG pads require dedicated ESD protection or documented justification before production release and classroom deployment~~ | ~~Post-coupon design~~ | ~~✔ DONE — Coupons are break-off PAS bringup features only; not present on final product; ESD protection moot~~ |
| ~~`da-02`~~ | ~~DA-02~~ | ~~ESD policy for classroom deployment variant: define which internal BtB-accessible connections require additional ESD protection in educational / student-access configuration~~ | ~~Pre-production~~ | ~~✔ DONE — `design/Guides/Classroom_Guide.md` created: documents ESD PPE requirements, H&S Lab context, and two deployment modes~~ |
| ~~`naming-convention-sweep`~~ | ~~DA-03~~ | ~~Full consistency documentation pass: legacy Link-Alpha / Link-Beta references must remain historical-only after DEC-038; verify any new docs added use PM dock / Stator dock naming~~ | ~~Ongoing~~ | ~~✔ DONE — Fixed `Certification_Evidence.md` (4 occurrences) and `Complete_System_Assembly/Design_Spec.md` (2 occurrences); all active docs now use PM dock / Stator dock~~ |
| ~~`da-04`~~ | ~~DA-04~~ | ~~Update Consolidated BOM with all locked Power Module components *(may be superseded by the 2026-05 BOM restructure — verify against current `Consolidated_BOM.md` before actioning)*~~ | ~~Post-eFuse lock~~ | ~~✔ DONE — Superseded by `bom-pre-prototype-check` and `bom-pre-production-check` explicit BOM verification gates~~ |
| `compliance-testing` | — | Sending final review prototype for Environmental and EMC testing to get required certification documentation | Pre-production | pending |

---

## Project Milestones

Top-level milestones that gate v1.0 release. Descriptions TBD — to be confirmed with user before closing.

| ID | Description | Status | Depends on |
| --- | --- | --- | --- |
| `review-mounting-holes` | Verify mounting hole count and board-specific location for every board during schematic capture and PCB layout stage. Cannot be fully defined until KiCAD layout is complete. Known placements: USM = 4 corners; Extension = bottom corners + middle-centre + top-centre. Extension AM standoff holes (quantity/position/part TBD). Hole type and pad spec per GRS §4.2. | pending | `interim-electronics-review-1`, `coupon-testing-review` |
| `interim-electronics-review-1` | **Review gate 1 — Pass 3 fixes verified.** All pass-3 fix todos (fix1–fix19) and `rotor-refdes-reallocate` must be complete. Verify no RefDes gaps on any board, all pass-3 findings resolved, and documentation consistent before proceeding to schematic capture / footprint work. | pending | All fix1–fix19 + `rotor-refdes-reallocate` |
| `interim-electronics-review-2` | **Review gate 2 — Post-coupon review.** Coupon strategy verified, all mounting hole locations finalised, BOM ready for full PN review. | pending | `interim-electronics-review-1`, `coupon-testing-review`, `review-mounting-holes` |
| `interim-electronics-review-3` | **Review gate 3 — Post-schematic / pre-prototype manufacturing.** Schematic capture, footprint assignment, and full PN review complete. Final electronics design gate before committing to prototype PCB manufacturing. | pending | `interim-electronics-review-2`, `full-pn-review`, `footprint-requests-pending` |
| `interim-electronics-review-4` | **Review gate 4 — Pre-production run.** Prototype system testing complete and all prototype-phase findings resolved. Final gate before releasing to production manufacturing. | pending | `prototype-system-complete`, `compliance-testing` |
| `bom-pre-prototype-check` | **BOM verification gate 1 — Before prototype PCB manufacturing.** Verify Consolidated BOM completeness and correctness: all RefDes present, all MPNs valid, all supplier PNs verified against MPN. Must pass before submitting JLCPCB prototype order. | pending | `full-pn-review`, `interim-electronics-review-3` |
| `bom-pre-production-check` | **BOM verification gate 2 — Before production manufacturing.** Final BOM verification: confirm all prototype-stage changes have been incorporated, check all supplier PNs are still active, and verify quantities. Must pass before submitting production order. | pending | `bom-pre-prototype-check`, `prototype-system-complete` |
| `prototype-pcb-manufacturing` | Process prototype PCB manufacturing through JLCPCB: (1) Generate manufacturing pack (gerber, pick & place, LCSC BOM); (2) Global Sourcing Part Order; (3) Consignment Parts Order; (4) Board Orders (one per board); (5) Receive Boards and Inspect; (6) Run Board PAS Testing. **Note:** CoilCraft samples ordered for CTL T1 (POE600F-12L) — Ref: 153954. | pending | `rerun-deep-reviews`, `review-mounting-holes`, `interim-electronics-review-3`, `bom-pre-prototype-check` |
| `prototype-system-complete` | Verification of full system and issuing all design documents, test procedures and guides as version 1.0 complete | pending | All SW & Mech deferrals, `rerun-deep-reviews` |
| `release-candidate-production` | Process final draft design for production testing (via PCBWay or JLCPCB). Same subtasks as `prototype-pcb-manufacturing`: (1) Generate manufacturing pack; (2) Global Sourcing Part Order; (3) Consignment Parts Order; (4) Board Orders (one per board); (5) Receive Boards and Inspect; (6) Run Board PAS Testing | pending | `prototype-system-complete`, `compliance-testing`, `interim-electronics-review-4` |
| `version-one-complete` | All version 1.0 documents issued. Conduct lessons learned from v1.0 and create a new todo-list to refine the design for a version 2.0 machine | pending | `naming-convention-sweep` (done), `release-candidate-production` |

---

## Dependency Overview

```text
fix1-fix19 + rotor-refdes-reallocate
  --> interim-electronics-review-1
        --> interim-electronics-review-2 (also needs: coupon-testing-review, review-mounting-holes)
              --> interim-electronics-review-3 (also needs: full-pn-review, footprint-requests-pending)
                    --> bom-pre-prototype-check (also needs: full-pn-review, interim-electronics-review-3)
                          --> prototype-pcb-manufacturing (also needs: rerun-deep-reviews, review-mounting-holes)

rotor-variant-refdes-schematic
  --> rotor-esd-tvs
        --> full-pn-review (also needs: extension-mechanical-usage,
              |              battery-connector-final-review [blocked - awaiting supplier],
              |              ctlh1-deferred, coupon-testing-review,
              |              connector-thermal-verification)
              --> footprint-requests-pending
                    --> rerun-deep-reviews --+
                          |                  |
                          |--> ltc3350-telemetry (also needs: prototype-pcb-manufacturing)
                          --> cpld-timing-load  (also needs: prototype-pcb-manufacturing)
                                --> [all mechanical deferrals] (also need: prototype-pcb-manufacturing)
                                      --> prototype-system-complete
                                            --> bom-pre-production-check (also needs: bom-pre-prototype-check)
                                                  --> release-candidate-production (also needs: compliance-testing, interim-electronics-review-4)
                                                        --> version-one-complete

DONE (no longer gate anything):
  da-01, da-02 (done: classroom guide created)
  naming-convention-sweep / da-03 (done: PM dock / Stator dock sweep complete)
  da-04 (done: superseded by bom-pre-prototype-check + bom-pre-production-check)

v2.0 deferred (blocked): display-addon-board, display-aperture, cpld-production-replacement, jdb-ft232h-3v3-vregin
Currently ready (no pending deps): connector-thermal-verification, ctlh1-deferred,
  extension-mechanical-usage, rotor-variant-refdes-schematic, mh-refdes-standardise, jdb-fr-renumber
  [coupon-testing-review depends on extension-mechanical-usage]
  [battery-connector-final-review excluded -- blocked awaiting supplier response]
  [prototype-pcb-manufacturing excluded -- depends on rerun-deep-reviews + interim-electronics-review-3 + bom-pre-prototype-check]
  [release-candidate-production excluded -- depends on compliance-testing + interim-electronics-review-4]
```

---

## SQL Reconstruction Reference

At session start, run these INSERT statements to reconstruct the `todos` and `todo_deps` tracking tables.
Use `INSERT OR IGNORE` to make the script idempotent (re-runnable without error).

### Todos

```sql
INSERT OR IGNORE INTO todos (id, title, status) VALUES
-- Open Workstreams
('extension-mechanical-usage',        'Extension mechanical linkage spec',             'pending'),
('coupon-testing-review',             'Board-level coupon & PAS test coverage',        'pending'),
('battery-connector-final-review',    'Battery connector final review',                'blocked'),
('general-pin-mapping-schematic-capture', 'General pin mapping / schematic capture',  'done'),
('rerun-deep-reviews',                'Final pre-V1 deep review cycle',               'pending'),
-- Electronics Deferrals
('ctlh1-deferred',                    'Controller CTL-H1 deferred finding',           'done'),
('rotor-power-analysis-ministack',    'Recalculate Rotor Board_Layout §7 power analysis for mini-stack (max 5 rotors per stack)', 'done'),
('rotor-esd-tvs',                     'Rotor ESD TVS (PRTR5V0U10AZ) sourcing',       'done'),
('rotor-variant-refdes-schematic',    'Rotor variant U3/U4 KiCAD DNF approach',       'done'),
('rotor-refdes-reallocate',           'Rotor RefDes gap removal: R2-R7 -> R1-R6',    'done'),
('production-folder',                 'Create design/Production/ folder with JLCPCB constraints doc',  'done'),
('grs-production-link',               'Update GRS to reference design/Production/ folder',             'done'),
('display-addon-board',               'Display add-on board (v2.0)',                  'blocked'),
('cpld-production-replacement',       'CPLD production replacement review (v2.0)',    'blocked'),
('connector-thermal-verification',    'Connector thermal/current derating',           'done'),
('full-pn-review',                    'Full supplier PN sweep pre-schematic',         'pending'),
('footprint-requests-pending',        'Outstanding footprint requests / downloads',   'pending'),
('bom-func-notes-sweep',              'BOM function notes conformity sweep: remove function descriptions from all BOM tables across ALL design files. Deferred per user instruction (F-PM-09/F-PM-10).', 'done'),
('m25-m3-dec-exception',              'Record DEC exception for M2.5 mounting holes on daughterboards (AM, ENC, ROT): not M3 per GRS because they mount to PCBs not chassis; MH ties to GND not GND_CHASSIS. Covered by GRS §5 and DEC-057.', 'done'),
-- Mechanical Deferrals
('rotor-shaft-diameter',              'Rotor PCB shaft hole diameter',                'pending'),
('rotor-rolling-element',             'Rotor rolling element diameter spec',          'pending'),
('rotor-alloy-grade',                 'Rotor disc alloy grade selection',             'pending'),
('rotor-shaft-mechanism',             'Rotor shaft retention mechanism',              'pending'),
('display-aperture',                  'Main enclosure display aperture (v2.0)',       'blocked'),
('system-assembly-harnesses',         'System Assembly harness definitions',          'pending'),
('system-assembly-connectors',        'System Assembly connector list',               'pending'),
-- Software Deferrals
('ltc3350-telemetry',                 'LTC3350 I2C telemetry Linux driver',           'pending'),
('cpld-timing-load',                  'CPLD timing & load characterisation',          'pending'),
-- Standards & Certification
('da-01',                             'DA-01: Coupon ESD protection requirement',     'done'),
('da-02',                             'DA-02: Classroom deployment ESD policy',       'done'),
('naming-convention-sweep',           'Naming consistency sweep: PM dock / Stator dock across active docs', 'done'),
('da-04',                             'DA-04: Consolidated BOM PM component update',  'done'),
('compliance-testing',               'Sending final review prototype for Environmental and EMC testing to get required certification documentation.', 'pending'),
('bom-pre-prototype-check',           'BOM completeness and correctness check before prototype PCB manufacturing', 'pending'),
('bom-pre-production-check',          'Final BOM verification before production manufacturing', 'pending'),
-- Pass 6 Deferred Items
('jdb-board-rename',                  'Review JDB board name — rename to JTAG Module to align with system naming scheme', 'done'),
('bypass-cap-audit-100nf',            'System-wide audit: verify all 100nF bypass cap DigiKey PNs after GRS §3.2 PN correction', 'done'),
('reset-n-prefix-decision',           'Decide whether RESET_N net name needs board-specific prefix before schematic capture begins', 'done'),
('connector-stacking-height-review',  'Review ERF8/ERM8 stacking heights against enclosure and rotating shroud clearance — deferred to mechanical stage when prototype boards are available', 'pending'),
('plugboard-assembly-spec',           'Create Plugboard Assembly specification including J1 6.35mm mono jack socket pin mapping table; ENC J1 connector delegation pending this spec', 'done'),
('enc-connector-review-pre-pcb',      'Review ENC connector and bypass cap placement before prototype PCB manufacturing; ensure ENC J1/J2 placement and 100nF caps are correct', 'pending'),
('bom-system-qty-audit',              'Audit and correct all System Qty values in Consolidated_BOM.md against the documented base-system convention (1× PM/CTL/STA/REF/EXT/JDB/USM/ENC/AM + 5× ROT of single variant). Focus: TPD4E05 row (currently may double-count both ROT variants); variant-specific rotor components (C16A/C16B, U3A/U3B — confirm C16A/C16B are 100nF bypass caps in ROT Design_Spec.md); all ROT-only rows.', 'done'),
('mh-refdes-standardise',            'Standardise mounting hole RefDes across all boards per DEC-057/DEC-058. CTL correctly assigned: MH1-4=CM5, MH5-8=AM dock, MH9-12=chassis (no BOM, GRS plain holes), MH13-16=JDB dock. EXT correct (MH1-4=chassis, MH5-8=AM dock). Verify remaining boards follow applicable scheme. Update any cross-references in Design_Spec.md, Board_Layout.md, Consolidated_BOM.md, Design_Log.md citing specific MH numbers.', 'pending'),
('jdb-standoff-height',             'Determine JDB hat-header stacking height and select correct M2.5 SMT standoff PN; review whether a DF40 BtB connector upgrade (same as AM) was appropriate. Resolved: upgraded to Hirose DF40C-20DP BtB connector (DEC-058); MH13-MH16 on CTL use Wurth 9774035151R. BOM entries added to CTL Design_Spec.md.', 'done'),
('jdb-fr-renumber',                  'JDB Design_Spec.md deferred cleanup: FR-JDB-02 and FR-JDB-03 were collapsed into a single requirement; renumber remaining FRs consecutively. Low-priority; deferred to next JDB spec revision.', 'done'),
('jdb-ft232h-3v3-vregin',           'FT232H Rev C supports 3.0-3.6V VREGIN; would allow JDB to run entirely from 3V3_ENIG and eliminate 5V_USB from DF40 connector. Defer until Rev C availability confirmed. Same priority as display-addon-board.', 'blocked'),
-- Project Milestones
('review-mounting-holes',             'Verify mounting hole count and board-specific location for every board during schematic capture and PCB layout stage. Cannot be fully defined until KiCAD layout is complete.', 'pending'),
('interim-electronics-review-1',      'Review gate 1: pass 3 fixes + rotor-refdes-reallocate complete; no RefDes gaps; all pass-3 findings resolved.', 'pending'),
('interim-electronics-review-2',      'Review gate 2: post-coupon review; mounting holes finalised; BOM ready for full PN review.', 'pending'),
('interim-electronics-review-3',      'Review gate 3: post-schematic / pre-prototype; schematic, footprints, full PN review complete.', 'pending'),
('interim-electronics-review-4',      'Review gate 4: pre-production; prototype testing complete; final electronics gate before production run.', 'pending'),
('prototype-pcb-manufacturing','Process prototype PCB manufacturing through JLCPCB: (1) Generate manufacturing pack (gerber, pick & place, LCSC BOM); (2) Global Sourcing Part Order; (3) Consignment Parts Order; (4) Board Orders (one per board); (5) Receive Boards and Inspect; (6) Run Board PAS Testing. CoilCraft samples ordered for CTL T1 (POE600F-12L) Ref: 153954.',        'pending'),
('prototype-system-complete',         'Verification of full system and issuing all design documents, test procedures and guides as version 1.0 complete.',          'pending'),
('release-candidate-production',      'Process final draft design for production testing (via PCBWay or JLCPCB). Same subtasks as prototype-pcb-manufacturing: (1) Generate manufacturing pack (gerber, pick & place, BOM); (2) Global Sourcing Part Order; (3) Consignment Parts Order; (4) Board Orders (one per board); (5) Receive Boards and Inspect; (6) Run Board PAS Testing.',       'pending'),
('version-one-complete',              'All version 1.0 documents issued. Conduct lessons learned from v1.0 and create a new todo-list to refine the design for a version 2.0 machine.',              'pending'),
('review-pass-7',         'Design review pass 7: post-pass-6 implementation check confirming all pass-6 findings are resolved', 'pending');
```

### Dependencies

```sql
INSERT OR IGNORE INTO todo_deps (todo_id, depends_on) VALUES
-- rotor chain
('rotor-power-analysis-ministack',  'rotor-variant-refdes-schematic'),
('rotor-esd-tvs',                   'rotor-variant-refdes-schematic'),
-- full-pn-review prerequisites (all 6 must complete first)
('full-pn-review',              'connector-thermal-verification'),
('full-pn-review',              'extension-mechanical-usage'),
('full-pn-review',              'battery-connector-final-review'),
('full-pn-review',              'ctlh1-deferred'),
('full-pn-review',              'rotor-esd-tvs'),
('full-pn-review',              'coupon-testing-review'),
-- footprint gated by full-pn-review
('footprint-requests-pending',  'full-pn-review'),
-- deep reviews gated by footprints
('rerun-deep-reviews',          'footprint-requests-pending'),
-- software deferrals need deep reviews + prototype hardware
('ltc3350-telemetry',           'rerun-deep-reviews'),
('ltc3350-telemetry',           'prototype-pcb-manufacturing'),
('cpld-timing-load',            'rerun-deep-reviews'),
('cpld-timing-load',            'prototype-pcb-manufacturing'),
-- mechanical deferrals need prototype hardware + both SW deferrals
('rotor-shaft-diameter',        'prototype-pcb-manufacturing'),
('rotor-shaft-diameter',        'ltc3350-telemetry'),
('rotor-shaft-diameter',        'cpld-timing-load'),
('rotor-rolling-element',       'prototype-pcb-manufacturing'),
('rotor-rolling-element',       'ltc3350-telemetry'),
('rotor-rolling-element',       'cpld-timing-load'),
('rotor-alloy-grade',           'prototype-pcb-manufacturing'),
('rotor-alloy-grade',           'ltc3350-telemetry'),
('rotor-alloy-grade',           'cpld-timing-load'),
('rotor-shaft-mechanism',       'prototype-pcb-manufacturing'),
('rotor-shaft-mechanism',       'ltc3350-telemetry'),
('rotor-shaft-mechanism',       'cpld-timing-load'),
('system-assembly-harnesses',   'prototype-pcb-manufacturing'),
('system-assembly-harnesses',   'ltc3350-telemetry'),
('system-assembly-harnesses',   'cpld-timing-load'),
('system-assembly-connectors',  'prototype-pcb-manufacturing'),
('system-assembly-connectors',  'ltc3350-telemetry'),
('system-assembly-connectors',  'cpld-timing-load'),
-- prototype-system-complete needs all SW and Mech deferrals + deep reviews
('prototype-system-complete',   'rerun-deep-reviews'),
('prototype-system-complete',   'ltc3350-telemetry'),
('prototype-system-complete',   'cpld-timing-load'),
('prototype-system-complete',   'rotor-shaft-diameter'),
('prototype-system-complete',   'rotor-rolling-element'),
('prototype-system-complete',   'rotor-alloy-grade'),
('prototype-system-complete',   'rotor-shaft-mechanism'),
('prototype-system-complete',   'system-assembly-harnesses'),
('prototype-system-complete',   'system-assembly-connectors'),
-- DA actions depend on prototype-system-complete
('da-01',                       'prototype-system-complete'),
('da-02',                       'prototype-system-complete'),
('naming-convention-sweep',     'prototype-system-complete'),
('da-04',                       'prototype-system-complete'),
-- compliance-testing depends on all DA actions (all done, kept for reference)
('compliance-testing',          'da-01'),
('compliance-testing',          'da-02'),
('compliance-testing',          'naming-convention-sweep'),
('compliance-testing',          'da-04'),
-- bom-pre-prototype-check gates
('bom-pre-prototype-check',     'full-pn-review'),
('bom-pre-prototype-check',     'interim-electronics-review-3'),
-- prototype-pcb-manufacturing depends on rerun-deep-reviews, review-mounting-holes, interim-electronics-review-3, and bom-pre-prototype-check
('prototype-pcb-manufacturing', 'rerun-deep-reviews'),
('review-mounting-holes',       'rerun-deep-reviews'),
('prototype-pcb-manufacturing', 'review-mounting-holes'),
('prototype-pcb-manufacturing', 'interim-electronics-review-3'),
('prototype-pcb-manufacturing', 'bom-pre-prototype-check'),
-- bom-pre-production-check gates
('bom-pre-production-check',    'bom-pre-prototype-check'),
('bom-pre-production-check',    'prototype-system-complete'),
-- release-candidate-production depends on bom-pre-production-check
('release-candidate-production', 'bom-pre-production-check'),
-- interim-electronics-review-1 gates (fix1-fix19 listed individually + rotor-refdes-reallocate)
-- Note: fix1-fix19 are session-transient pass-3 fix todos and not reconstructed here;
-- add them manually per session. The structural dep is rotor-refdes-reallocate.
('interim-electronics-review-1', 'rotor-refdes-reallocate'),
-- interim-electronics-review-2 gates
('interim-electronics-review-2', 'interim-electronics-review-1'),
('interim-electronics-review-2', 'coupon-testing-review'),
('interim-electronics-review-2', 'review-mounting-holes'),
-- interim-electronics-review-3 gates
('interim-electronics-review-3', 'interim-electronics-review-2'),
('interim-electronics-review-3', 'full-pn-review'),
('interim-electronics-review-3', 'footprint-requests-pending'),
-- interim-electronics-review-4 gates
('interim-electronics-review-4', 'prototype-system-complete'),
('interim-electronics-review-4', 'compliance-testing'),
-- release-candidate-production depends on prototype-system-complete + compliance-testing + interim-electronics-review-4
('release-candidate-production', 'prototype-system-complete'),
('release-candidate-production', 'compliance-testing'),
('release-candidate-production', 'interim-electronics-review-4'),
-- version-one-complete needs naming-convention-sweep (done) + release candidate
('version-one-complete',        'naming-convention-sweep'),
('version-one-complete',        'release-candidate-production'),
-- Pass 6 deferred items → review-pass-7
('review-pass-7', 'jdb-board-rename'),
('review-pass-7', 'bypass-cap-audit-100nf'),
('review-pass-7', 'connector-stacking-height-review'),
-- prototype-system-complete blocked by plugboard-assembly-spec
('prototype-system-complete',   'plugboard-assembly-spec'),
-- prototype-pcb-manufacturing blocked by enc-connector-review-pre-pcb
('prototype-pcb-manufacturing', 'enc-connector-review-pre-pcb'),
-- bom-system-qty-audit blocks review-pass-7
('review-pass-7', 'bom-system-qty-audit'),
-- mh-refdes-standardise blocks review-pass-7
('review-pass-7', 'mh-refdes-standardise'),
-- jdb-fr-renumber blocks review-pass-7
('review-pass-7', 'jdb-fr-renumber'),
-- review-pass-7 → interim-electronics-review-1
('interim-electronics-review-1', 'review-pass-7');
```
