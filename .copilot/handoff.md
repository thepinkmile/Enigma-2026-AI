# Enigma-NG Handoff

This file is the generic repo-local handoff note for session-to-session context that is useful to
keep near the design docs but is **not** itself a source of design truth.

## 2026-05-22 session result (data-plate-standardisation complete; checkpoint 167)

### What happened

`data-plate-standardisation` workstream completed. All 10 board Design_Spec.md files now carry a
standard Data Plate bullet. GRS §6 metadata format formalised. USM Board_Layout.md errant blockquote
removed. USM-P10-09 closed RESOLVED.

German board names agreed and applied:

| Board | Revision Block Text | Layer |
|-------|---------------------|-------|
| Rotor | `WALZE-{variant} [Rotor] V1.0` | L4 |
| Reflector | `REFLEKTOR [Reflector] V1.0` | L4 |
| Controller | `LEITWERK [Controller] V1.0` | L6 |
| Extension | `ERWEITERUNG [Extension] V1.0` | L4 |
| Stator | `STATOR [Stator] V1.0` | L4 |
| Power Module | `STROMVERSORGUNG [Power Module] V1.0` | L4 |
| Actuation Module | `STELLWERK [Actuation Module] V1.0` | L4 |
| User Settings Module | `EINSTELLWERK [Settings] V1.0` | L4 |
| JTAG Module | `PROGRAMMIERWERK [JTAG Module] V1.0` | L4 |
| Encoder | `KODIERWERK [Encoder] V1.0` | L4 |

Also fixed CTL §10.2 orphaned continuation line (duplicate GRS §6 reference from old Branding bullet).

### Key numbers

- **Next checkpoint = 168**
- **Next DEC = DEC-084**
- **Pass-10:** 91/91 board findings resolved ✅; all INT MINOR/MEDIUM findings closed ✅
- **review-pass-11** blocked by: `design-log-restructure`, `copilot-dir-restructure` (both pending)

### Files changed this session

**Design files:** `design/Standards/Global_Routing_Spec.md` (§6 metadata format) · all 10 board
`Design_Spec.md` files (Data Plate bullets) · `User_Settings_Module/Board_Layout.md` (blockquote
removed) · All Last Updated → 2026-05-22

**Session tracking:** `.copilot/review-report.md` (USM-P10-09 RESOLVED) · `.copilot/plan.md` ·
`.copilot/handoff.md` (this entry) · `.copilot/todos/data-plate-standardisation.md` (status → done)



### What happened

Closed all 5 remaining tracked INT MINOR and INT MEDIUM findings:

- **INT-P10-040** ✅ RESOLVED — T1 confirmed TDK B82806D0060A120 in both `Controller/Design_Spec.md`
  and `Consolidated_BOM.md`; Bourns reference is gone post-DEC-062. No file change needed.
- **INT-P10-006** ✅ RESOLVED — `CTL Design_Spec.md §4.1` already contains the current-generation
  I²C bus map (all boards, single I²C-1 bus, GPIO 2/3). TPS25751 correctly absent — it is on a
  dedicated manufacturing programming path via J4 (battery connector) `PROG_EN_N` + U19 MUX
  (DR-PM-21). No new DEC entry needed.
- **INT-P10-010** ❌ INVALID — Design_Log.md is append-only; Board Connector Inventory cannot
  and should not be updated in-place. Board Design_Specs are the authoritative connector reference.
- **INT-P10-041** ❌ INVALID — PRIMARY DIRECTIVE: Mouser `595-PD4E05U06QDQARQ1` is the correct
  abbreviated PN (Mouser drops leading letters from TI MPNs). Should never have been raised.
- **INT-P10-043** ❌ INVALID — "Superseded by" banners in living docs violate both the append-only
  Design_Log policy and the no-history-in-design-files policy.

Also confirmed full parallel audit of all 91 Phase A board findings (7 agents) — all cleanly applied
in design files.

### Key numbers

- **Next checkpoint = 167**
- **Next DEC = DEC-084**
- **Pass-10:** 91/91 board findings resolved ✅; all INT MINOR/MEDIUM findings closed ✅
- **review-pass-11** blocked by: `data-plate-standardisation`, `design-log-restructure`, `copilot-dir-restructure`

### Files changed this session

`.copilot/review-report.md` (INT-P10-040/006 RESOLVED; INT-P10-010/041/043 INVALID; Remaining Open Items INT line cleared) ·
`.copilot/plan.md` (Current Status updated; Next Session Start Point item 5 updated) ·
`.copilot/handoff.md` (this entry)

---



### What happened

Verified JM-P10-04 and JM-P10-05 were already applied in a prior session:

- **JM-P10-04** — `Design_Spec.md` §6 lines 207–212 contain the "UART/MPSSE Mode-Switch Contention
  (Informational)" bullet. No file change required.
- **JM-P10-05** — `Board_Layout.md` §6.1 5V_USB row already corrected to ≤ 120 mA peak with full
  derivation footnote (Table 5.2: Ireg ≈ 54 mA + Iccphy ≈ 60 mA = 114 mA). No file change required.

Closed **REF-P10-05** (previously the sole remaining partial):
- `SamacSys_Parts.kicad_sym` already has `Connector_IDC:IDC-Header_2x15_P2.54mm_Vertical` assigned
  to the 2BHR-30-VUA symbol — standard KiCAD built-in generic IDC header; no supplier library required.
- Both `Reflector/Design_Spec.md` and `Consolidated_BOM.md` already show Footprint Downloaded ✔.
- Supplier request is now moot; tracking updated to RESOLVED.

Tracking updated: review-report.md Phase A Summary now reads **91 resolved, 0 partial, 0 open** (91 total).
`plan.md` updated. Pass-10 is 100% clean.

### Key numbers

- **Next checkpoint = 167**
- **Next DEC = DEC-084**
- **Pass-10:** 91/91 resolved ✅ — zero partials, zero open
- **review-pass-11** blocked by: `data-plate-standardisation`, `design-log-restructure`, `copilot-dir-restructure`

### Files changed this session

`.copilot/review-report.md` (JM-P10-04/05 closed; REF-P10-05 closed; Phase A TOTAL updated to 91/0/0) ·
`.copilot/plan.md` (Pass-10 status updated; all partials cleared) ·
`.copilot/handoff.md` (this entry)

---



### What happened

Session added two new structural todos (`design-log-restructure`, `copilot-dir-restructure`) as
blockers for `review-pass-11`, then resolved the four remaining AM and USM Pass-10 findings — all
of which were stale or had already been applied manually:

- **AM-P10-03** — callouts already present in `Board_Layout.md` lines 56/61; not checked off
- **USM-P10-06** — "DPDT" absent from entire `Design_Log.md`; user confirmed already fixed manually; no DEC entry required or created
- **USM-P10-08** — J1 pin-1 callout already present at `Board_Layout.md` line 69; not checked off
- **USM-P10-09** — deferred to `data-plate-standardisation`; full corrective actions documented in that todo's detail file

Full audit of the Phase A Summary table in `review-report.md` found 5 stale rows (STA, EXT, ENC
were significantly out of sync; REF summary line also wrong). All corrected. Phase A total now
correctly reads: **88 resolved, 1 partial, 2 open** out of 91 total findings.

`plan.md` DEC-080/081 descriptions corrected (agent error in prior session — descriptions did not
match actual Design_Log entries).

### Key numbers

- **Next checkpoint = 167**
- **Next DEC = DEC-084**
- **Pass-10 open findings: 2** (JM-P10-04, JM-P10-05 only)
- **review-pass-11** blocked by: `data-plate-standardisation`, `design-log-restructure`, `copilot-dir-restructure`

### Pass-10 open findings (2 remaining)

| Finding | Sev | Board | Summary |
|---------|-----|-------|---------|
| JM-P10-04 | LOW | JM | `Design_Spec.md` §6: UART power-on contention window undocumented — **next up** |
| JM-P10-05 | LOW | JM | `Board_Layout.md` §5: "400mA peak" 5V_USB ≈4× actual; no derivation footnote |

### Files changed this session

`.copilot/plan.md` · `.copilot/todo-list.md` · `.copilot/review-report.md` ·
`.copilot/todos/design-log-restructure.md` (created) · `.copilot/todos/copilot-dir-restructure.md` (created) ·
`.copilot/todos/data-plate-standardisation.md` (§4 expanded) ·
`.copilot/checkpoints/166-am-usm-p10-closed-report-audit-corrected.md` (created) ·
`.copilot/checkpoints/index.md`

---



### What happened

This session continued Pass-10 findings resolution (EXT fully closed 9/9; STA closed 3/3; AM
partially closed 2/3) then branched into two significant side-tasks:

1. **Samsung CL31B106KBK6PJE standardisation (DEC-082)** — 87 bulk reservoir cap placements across
   11 boards upgraded from 25V 0805 to 50V 1206 AEC-Q200. Full KiCAD library import in all 4
   formats + 3D models completed. Supplier PNs (`DigiKey: 1276-CL31B106KBK6PJECT-ND`,
   `Mouser: 187-CL31B106KBK6PJE`, `JLCPCB: C43935922`) propagated to all 13 BOM rows,
   `Consolidated_BOM.md`, and `Global_Routing_Spec.md` §3.2. `DR-PM-17/18` updated with new
   derating figures.

2. **`all_boards_bom.json` retired (DEC-083)** — full audit revealed 43 missing entries, ~60
   RefDes mismatches, 11 wrong MPNs. File moved to `.recycle-bin/`; `agent-directives.md` BOM
   Authority Rules updated. `bom_audit_report.md` also retired.

Checkpoint 165 written. `todo-list.md` synced (INSERTs corrected for `download-missing-3d-models`
→ `done` and `tps25751-i2c-review` → `done`).

### Key numbers

- **Next checkpoint = 166**
- **Next DEC = DEC-084**
- **Review pass 10 fully closed.** Review pass 11 blocked by `data-plate-standardisation` (pending).

### Pass-10 open findings (6 remaining)

| Finding | Sev | Board | Summary |
|---------|-----|-------|---------|
| AM-P10-03 | LOW | AM | Board_Layout §2: J2–J5 missing GRS §7.1 pin-1 marker callout — **next up** |
| USM-P10-06 | LOW | USM | DEC-072 says "DPDT" — correct = SPDT; append DEC-084 (amends DEC-080) |
| USM-P10-08 | LOW | USM | Board_Layout: GRS §7.1 pin-1 marker compliance not confirmed |
| USM-P10-09 | LOW | USM | Board_Layout: GRS §6 data plate not mentioned |
| JM-P10-04 | LOW | JM | Design_Spec §6: UART power-on contention window undocumented |
| JM-P10-05 | LOW | JM | Board_Layout §5: "400mA peak" 5V_USB ≈4× actual; no derivation footnote |

### Files changed this session

`design/Design_Log.md` (DEC-082, DEC-083 appended) ·
`design/Datasheets/Samsung-CL31B106KBK6PJ-datasheet.md` (created) ·
`design/Electronics/Consolidated_BOM.md` · `design/Standards/Global_Routing_Spec.md` §3.2 ·
All 11 board `Design_Spec.md` BOM tables · `src/Electronics/Library/` (all 4 KiCAD formats + 3D) ·
`.copilot/agent-directives.md` · `.copilot/todo-list.md` ·
`.copilot/checkpoints/165-samsung-50v-cap-complete-bom-json-retired.md` ·
`.copilot/checkpoints/index.md`

Retired: `design/Electronics/all_boards_bom.json` · `.copilot/bom_audit_report.md`

---

## 2026-05-18 session result (P10 Recovery: all findings applied — checkpoint 163)

### All 54 remaining P10 findings applied across 11 boards + BOM

Phase A verification (prior session) found 37/91 Pass 10 findings resolved after commit `75b3707`,
8 partial, 46 open. This session resolved all remaining 54 findings.

**Boards updated:** CTL, ROT, STA, ENC, REF, EXT, JM, PM, AM, USM, Consolidated BOM.  
**DEC-080 appended** — SPDT/DPDT terminology correction for USM SW1–SW10 (amends DEC-072).  
**ERM8-010** in BOM corrected from `Yes|✔` → `No|Pending` (library gap: footprint absent).

Key technical facts:
- AM path: `design/Electronics/Actuation_Module/`; USM path: `design/Electronics/User_Settings_Module/`
- JLC041621-3313 = correct 4-layer stackup for ROT and ENC
- ERA-2AEB1333X (0402 133kΩ) was the **wrong** MPN in DEC-073 — corrected in-place to ERJ-PC3B1333V (0603 133kΩ thick-film) this session
- Permanent library gaps carried to Pass 11: `1.5SMBJ36CA` (CTL D2), `2BHR-30-VUA` (REF J4/EXT J7-J8), `ERM8-010` footprint (REF/EXT/ROT J3)
- JM §6 connector correction: "Controller J12 ↔ Stator J10" (was J5/J12 error)

**Key numbers: Next checkpoint = 165. Next DEC = DEC-082.**

---

## 2026-05-17 session result (Todo restructuring and review-pass gate — checkpoint 162)

### Pass 10 closed; C20 upgraded; library import complete (committed 75b3707)

All 38 Pass 10 findings resolved and committed in the previous part of this session.
C20 upgraded to TDK CGA9N1X7R1V476M230KC (47µF 35V X7R 2220 AEC-Q200); library imported to all 4 formats.
Temp library directory cleaned to `.recycle-bin/library-temp-20260517/`.

### Todo dependency restructuring

Six todo dependency changes applied this session (DB + todo-list.md kept in sync):

| Todo | Change |
|---|---|
| `bom-pre-prototype-check` | Added dep on `consolidate-design-spec-content` |
| `bom-pre-production-check` | Added deps on `compliance-testing`, `emc-testing`, `environmental-testing`, `security-testing` |
| `consolidate-design-spec-content` | Replaced dep on `interim-electronics-review-3` with dep on new `review-clean-passes-gate` |
| `system-config-variants-diagrams` | Added dep on `prototype-pcb-manufacturing` |
| `interim-electronics-review-1` | Restored dep on `consolidate-design-spec-content` (re-added after circular dep was resolved) |

Circular dependency resolved: the old `interim-electronics-review-1 → consolidate-design-spec-content` dep caused a loop via `interim-electronics-review-3`. Now that consolidation deps on the gate (not on gate 3), the cycle is broken and the dep is safe to restore.

### New todos added

| ID | Title | Blocked by |
|---|---|---|
| `review-clean-passes-gate` | Gate: two consecutive clean review passes achieved | all `review-pass-x` todos (7–12) |
| `review-pass-12` | Design review pass 12 | `review-pass-11` |

`review-clean-passes-gate` is the canonical aggregator for all review passes. It must be **manually** closed when 2 consecutive clean passes are confirmed. Any new `review-pass-x` must be added as a dep here. `consolidate-design-spec-content` gates on this instead of individual passes.

### 3-way sync state

- Session SQL DB: fully seeded from updated `todo-list.md` Agent SQL block — 113 todos total (34 pending, 72 done, 7 blocked)
- `todo-list.md` summary table and SQL block: in sync with session DB
- Detail files: `todos/review-clean-passes-gate.md` and `todos/review-pass-12.md` created

### Open items entering next session

- `download-missing-3d-models` — READY (0 unmet deps); 33 parts still need STP; drop zips into `src\Electronics\Library\temp\` and import
- `extension-mechanical-usage` — READY (0 unmet deps)
- `review-pass-11` — blocked by `download-missing-3d-models`
- Uncommitted disk changes: `.copilot/todo-list.md`, `.copilot/todos/review-clean-passes-gate.md`, `.copilot/todos/review-pass-12.md` (staged but not committed — await "Let's lock this in")

**Key numbers:** Next checkpoint = 163. Next DEC = DEC-077. Session DB: 34 pending, 72 done, 7 blocked.

---



### tps25751-i2c-review resolved (DEC-075)

Option C selected and fully implemented:
- **ADCIN config:** ADCIN1=LDO_3V3 (decoded 7), ADCIN2=GND (decoded 0) → SafeMode + I2Ct address 0x20 (no resistors needed; direct ties only)
- **U18 M24512-RDW6TP** (64KB SO8N EEPROM) added to PM BOM at I2C address 0x50 on isolated I2Cc bus; E2=E1=E0=GND per DS6520 §2.3/Table 3
- **J6** 5-pin 2.54mm THT header (61300511121) added to PM BOM for I2Ct field programming; isolated from system I2C-1
- **R47/R48** (I2Cc pull-ups), **R49/R50** (I2Ct pull-ups) — all 4.7kΩ ERJ-3EKF4701V; extend existing R5/R6 row (qty 2→6)
- **C78** 100nF CL05B104KB5NNNC decoupling for U18 VCC; extends existing 100nF group (qty 24→25)
- **DR-PM-20/21/22** added to PM requirements table
- **DEC-075** appended to Design_Log.md
- **Maintenance_Guide §5** added as placeholder (programming procedure + required tools TBD)
- STM-M24512-RDW6TP-datasheet.md generated (DS6520 Rev 31, 47 pages)
- M24512-RDW6TP and 61300511121 added to footprint-requests-pending.md

### Open items from this session
- `INT-P10-001` in `.copilot/review-report.md` still marked "false positive" — update to "resolved: DEC-075" (still outstanding)
- Maintenance_Guide.md §5 programming procedure is placeholder — tool and cable spec TBD
- U18/J6 footprints + 3D models pending download (user rate-limited)
- DigiKey PN `497-2700-1-ND` for M24512 should be verified before ordering

**Key numbers:** Next checkpoint = 162. Next DEC = DEC-076.

---

## 2026-05-16 session result (Library import, todo sync, directives hardened — checkpoint 160)

### Library: 5 official parts imported and fully synchronised

Official Hirose DF40 and TPS component files imported from Mouser/SamacSys zips and fully
synchronised across STP, `.kicad_mod`, symbol, and legacy `.mod` SHAPE3D.

| MPN | STP | kicad_mod | kicad_sym | legacy SHAPE3D |
|-----|-----|-----------|-----------|----------------|
| DF40C20DP04V51 | ✔ replaced | ✔ replaced | ✔ replaced | ✔ added |
| DF40HC3520DS04V51 | ✔ new | ✔ new | ✔ replaced | ✔ added |
| TPS23730RMTR | ✔ new | ✔ replaced | ✔ replaced | ✔ added |
| TPS25751DREFR | ✔ new | ✔ replaced | ✔ replaced | ✔ added |
| TPS259804ONRGER | ✔ new | ✔ replaced | ✔ replaced | ✔ added |

DF40C procurement note (Mouser MPN quirk: `DF40C-20DP-0.4V(51)` vs `DF40C20DP04V51`) added to
`Consolidated_BOM.md`, `Actuation_Module/Design_Spec.md`, `JTAG_Module/Design_Spec.md`.

### Todo system updates

- `download-missing-3d-models` — 33 parts still needing STP; user hit daily download limit;
  resume next session by dropping zips into `src\Electronics\Library\temp\`
- `review-pass-11` — added; blocked by `download-missing-3d-models` AND `review-pass-10`
- `review-pass-9` — marked done (all three layers)
- `board-interconnect-diagram` — status corrected `pending` → `done` in SQL block + session DB
- Session DB seeded from full `todo-list.md` Agent SQL block: 109 todos, 95 deps

### OCTONARY directive hardened

- **SESSION START — MANDATORY FIRST ACTION**: seed session DB before any other work
- **3-way sync rule**: all status/new-todo/dep changes must update summary table + Agent SQL INSERT + session DB together
- "Delete detail file on close" corrected → "archive to `.recycle-bin/`"

**Next:** drop remaining 3D model zips into `temp\`, import, mark `download-missing-3d-models`
done, then run `review-pass-10`.

**Key numbers:** Next checkpoint = 161. Next DEC = DEC-073. Session DB: 33 pending, 70 done, 6 blocked.

---

## 2026-05-15 session result (DIRECTIVE_VIOLATION_FIX commit — checkpoint 159 merged)

### Post-Pass-9 housekeeping and DIRECTIVE_VIOLATION_FIX commit

A prior agent had made an unauthorized git commit (SECONDARY directive violation). This session completed all outstanding working-copy fixes and then committed them as `DIRECTIVE_VIOLATION_FIX: Pass 9 review fixes; library imports; all-board BOM ticks` (commit `5cd847a`).

**Changes included in this session's commit:**
- `JTAG_Module/Design_Spec.md` — code block column alignment + table Signal column widened for `TDD_RETURN`; Last Updated → 2026-05-15
- `Controller/Design_Spec.md` — D2 (1.5SMBJ36CA) footprint Pending → ✔; +28 further BOM ticks; Last Updated → 2026-05-15
- `USM/Design_Spec.md` — 16 BOM ticks; Last Updated corrected 2026-05-27 → 2026-05-15
- All 10 board Design_Spec files — ~179 total footprint-status ticks (Pending → ✔)
- `SamacSys_Parts.lib` / `.dcm` / `.kicad_sym` — 21 new parts added
- `SamacSys_Parts.pretty/` — 12 new `.kicad_mod` footprints
- `SamacSys_Parts.3dshapes/` — 19 new `.stp` 3D models
- `.copilot/checkpoints/` — 159 + 160 merged into single checkpoint 159; old files recycled
- `.copilot/todos/review-pass-9.md` — removed (todo already marked done)

**New parts imported:** ERJ-2RKF3300X, ERJ-2RKF1003X, WP154A4SEJ3VBDZGW/CA, BSS138LT1G, SQ2319ADS-T1_BE3, ERF8-010-05.0-S-DV-K-TR, BHR-20-VUA, 0436500519 (=43650-0519), CWF1610A-180K, 219-6LPSTR, PH1-07-UA, ERM8-005-05.0-S-DV-K-TR, + 9 ERJ supporting variants.

**Remaining Pending BOM rows (no downloads yet available):**
| Board | RefDes | MPN | Reason |
|-------|--------|-----|--------|
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

**Next:** `review-pass-10` is unblocked (54 deferred Pass 9 findings). Other unblocked: `extension-mechanical-usage`, `system-config-variants-diagrams`, `consolidate-design-spec-content`, `footprint-requests-pending` (remaining rows above).

**Key numbers:** Next checkpoint = 160 (when user approves). Next DEC = DEC-073. `review-report.md` ≈ 1487 lines, complete through Pass 9.

---

## 2026-05-14 session result (Review Pass 9 complete — checkpoint 159)

### Review Pass 9: all fixes applied

75 findings reviewed; 16 fixed, 5 closed, 54 deferred to Pass 10.

**Design file changes:**
- `Power_Module/Design_Spec.md` — R8/R22 net 3V3_ENIG → 5V_MAIN (MIC1555 must be active at power-on)
- `Controller/Design_Spec.md` — Phantom PRTR5V0U2X removed; D2 1.5SMBJ36CA ESD section added; VREF phantom removed; CM5 socket wording generalised
- `Controller/Board_Layout.md` — J14→J13, J15→J14 throughout §7
- `JTAG_Module/Design_Spec.md` — TTD_RETURN propagated; USB trace width → GRS §2.3 cross-ref
- `JTAG_Module/Board_Layout.md` — USB trace width → GRS §2.3 cross-ref
- `USM/Design_Spec.md` — R2–R11 330Ω series resistors added; R11→R1 CFG_APPLY_N pull-up renumber
- `Consolidated_BOM.md` — 9 BOM corrections; ERJ-2RKF3300X and 1.5SMBJ36CA rows added
- `Global_Routing_Spec.md` — §3.2 bypass cap proximity wording
- `Datasheets/Bourns-1-5smbj-datasheet.md` — H1 title fix
- `Design_Log.md` — DEC-072 appended; next = DEC-073
- `SamacSys_Parts.kicad_sym` — 1.5SMBJ36CA symbol inserted (30532 lines)
- `SamacSys_Parts.pretty/DIONM5436X244N.kicad_mod` — DO-214AA footprint created

**Housekeeping:** `review-report.md` now complete through Pass 9 (Pass 6 Fix Status + full Pass 7/8/9 sections); `review-pass-9` todo closed.

**New parts:** ERJ-2RKF3300X (330Ω 0402), 1.5SMBJ36CA (36V TVS DO-214AA/SMB).

**Next:** `review-pass-10` is now unblocked (54 deferred Pass 9 findings). Other unblocked: `extension-mechanical-usage`, `system-config-variants-diagrams`, `consolidate-design-spec-content`.

---

## 2026-05-14 session result (ENC connector review complete — checkpoint 158)

### enc-connector-review-pre-pcb closed

- **J2 → J1 typo** fixed in `Encoder/Design_Spec.md` §9: placement note for the 20-pin IDC header incorrectly referenced J2 (a spade terminal); corrected to J1.
- **Bypass cap placement**: GRS §3 (CPLD: within 2mm) and §3.2 (per-IC: within 1mm) confirmed adequate — no additional DR needed.
- `review-pass-8` tracking error corrected (checkpoint 152 had incorrectly reset it to pending; checkpoint 136 confirms it was done).

**Files updated:** `Encoder/Design_Spec.md`, `.copilot/todo-list.md`.

Next unblocked todos: `review-pass-9`, `extension-mechanical-usage`, `system-config-variants-diagrams`.

---



### USM SPDT switch topology resolved — R1-R10 removed, R11 → R1, DEC-071 appended

Switch wiring changed from pull-down resistor topology to dual-terminated scheme:
NC → GND, NO → 3V3_ENIG, COM → CFG_* GPIO (U1). Both throws hard-terminated; no pull resistors needed.
R1–R10 (switch pull-downs) removed. R11 (CFG_APPLY_N pull-up) renumbered R1.
LED architecture confirmed independent (U2/U3 under software control only).

**Files updated:** `USM/Design_Spec.md`, `USM/Board_Layout.md`, `Consolidated_BOM.md`, `Design_Log.md` (DEC-071).

Next unblocked todos: `enc-connector-review-pre-pcb`.

---


### README.md system architecture diagram finalised

A `flowchart BT` Mermaid diagram was added to `README.md` under
`## 🗺️ System Architecture`. The diagram represents all boards, their subgraph
groupings, and directional signal connections at a high level.

**Subgraphs:** PWR · CTRL · ENCS · STATOR · RSTACK (Group 1 only) · EXTRSTACK ·
REF standalone

**Key edges:**
- `PWR --> CTRL` Link-Alpha (5V_MAIN · 3V3_ENIG)
- `CTRL --> STATOR` Link-Beta (ENC_DATA · JTAG · I²C)
- `KBD --> STA` ENC_IN[5:0]; `STA --> LBD` ENC_OUT[5:0]; `PLG <--> STA` bidirectional
- `STA --> ROT` Tri-connector Bus (Power · JTAG · ENC_DATA)
- `ROT --> REF` ENC_DATA; `ROT <---> EXT` bidirectional
- `REF --> STA` TTD_RETURN; `STA --> REF` ENC_IN + 5V_MAIN · 3V3_ENIG via ribbon
- Invisible rank hints: `REF ~~~ RSTACK ~~~ STATOR ~~~ PWR`; `ENCS ~~~ CTRL`; `EXTRSTACK ~~~ RSTACK`

**Confirmed:** Power to Reflector and Extension is delivered directly from the
Stator via ribbon cable — NOT via the rotor chain. `STA --> REF` edge is
intentional.

**Groups 2–6 omitted** pending `extension-mechanical-usage` architecture review.
Note added to that todo to reinstate in diagram after review.

Also this session:
- `ctl-t1-coilcraft-v2-review.md` status → blocked (v2.0 item)
- `todo-list.md` updated accordingly
- Checkpoint 155 internal header corrected (was labelled "151")

Next workstreams (unblocked): `usm-spdt-switch-floating-review`,
`enc-connector-review-pre-pcb`.

---

## Canonical design sources

Use the active `design/` documents as the authoritative record:

- `design/Design_Log.md`
- `design/Electronics/Consolidated_BOM.md`
- board-level `design/Electronics/*/Design_Spec.md`
- board-level `design/Electronics/*/Board_Layout.md`
- relevant mechanical and software `Design_Spec.md` files
- `design/Datasheets/` for preserved vendor and project-side reference material

## 2026-05-13 session result (post-reboot cleanup — checkpoint 152)

Todo-list full audit and cleanup completed.

**Corrections applied to `.copilot/todo-list.md` (12 edits):**
- 10 component diagram todos corrected `done` → `pending` (grep confirmed zero `block-beta` hits
  across all Design_Spec.md files)
- Stale file links cleared to `—` for 9 done todos (bulk-caps, ctl-l02-refdes-gap,
  enc-cpld-spare-pins-rule, jtag-pin1-silkscreen-grs, jtag-integrity-resistor-value-reconcile,
  mcp23017-gpb7-silicon-fixed-review, rot-i2c-residual-removal, am-button-review-production,
  ctl-t1-tdk-a120-component-analysis)
- `ctl-t1-tdk-topology-confirm` and `ctl-t1-tdk-library-import` changed `pending` → `done`
  (user confirmed both complete)
- Blocked By cleaned for: `interim-electronics-review-1` (trimmed to 3 relevant blockers),
  `interim-electronics-review-2`, `prototype-pcb-manufacturing`, `full-pn-review`,
  `ctl-t1-coilcraft-v2-review` (was blocked by now-done `ctl-t1-transformer-decision`)
- SQL section: `mcp23017-gpb7-silicon-fixed-review`, `ctl-t1-tdk-library-import`,
  `ctl-t1-tdk-topology-confirm` all updated `'pending'` → `'done'`

**Missing detail files created:**
- `.copilot/todos/usm-spdt-switch-floating-review.md` — SPDT switch pin mapping + pull-down check
- `.copilot/todos/consolidate-design-spec-content.md` — Design_Spec.md simplification (blocked by
  `enc-connector-review-pre-pcb`)
- `.copilot/todos/ctl-t1-coilcraft-v2-review.md` — v2.0 Coilcraft review (now unblocked)

All changes written to disk; user to review and commit ("Let's lock this in").

Next workstreams (unblocked): `usm-spdt-switch-floating-review`, `enc-connector-review-pre-pcb`.

## 2026-05-13 session result (CFG_APPLY_N correction — checkpoint 153)

Corrected the `CFG_APPLY_N` Stator U8 pin assignment error introduced in DEC-032 (GPA[4] was
wrong; correct pin is GPA[6]). All affected design files updated.

**Files corrected:**
- `design/Electronics/Stator/Design_Spec.md` — user manually fixed (DR-STA-13, DR-STA-15, U8
  pin table, note block all now show GPA[6])
- `design/Electronics/User_Settings_Module/Design_Spec.md` — §6 step 4: "U8 GPA[4]" → "U8 GPA[6]"
- `design/Electronics/User_Settings_Module/Board_Layout.md` — U1 pin table `GPB[7]` → `GPA[6]`;
  signal table `U1.GPB[7]` → `U1.GPA[6]`; Last Updated 2026-05-13
- `design/Design_Log.md` — DEC-070 updated in-place (user-authorised, not yet locked in):
  Amends field updated; D6 added; Files Changed updated; DEC-071 (written in error) removed

## 2026-05-13 session result

Two workstreams completed across this session date.

### JTAG integrity resistor value reconcile (checkpoint 148)

All JTAG series termination and line-length data updated to match the new 6-layer 2oz Controller
Board stackup (JLC061621-3313). Four Design_Spec files updated (CTL, EXT, JM, AM) and
`Global_Routing_Spec.md` §8 updated with correct propagation velocity and length values.
Discussion and todo files moved to `.recycle-bin/`.

### MCP23017 GPA[7]/GPB[7] silicon restriction review (checkpoints 149–151)

**Root cause:** MCP23017 I²C variant (DS20001952D) pins GPA[7] and GPB[7] are output-only;
restriction is silicon-level, present in all die revisions, applies to pin 7 of each port only.

**Violation found and resolved:**
- USM U1 GPB[7] was assigned `CFG_APPLY_N` (Input) — silicon violation
- Resolved: `CFG_APPLY_N` moved from USM U1 GPB[7] → GPA[6] (per DEC-070 D1)
- GPA[7] and GPB[7] on all six MCP23017 instances are now spare/NC or correctly output-assigned

**DEC-070 enriched with four supplemental points:**
- D1: CFG_APPLY_N reassignment to GPA[6]
- D2: all USM and Stator MCP23017 pin tables documented with directional details
- D3: all GPA[7]/GPB[7] cells confirmed output-only with silicon restriction note
- D4: no part replacement needed — restriction is pin-7 only; 14 other GPIO fully bidirectional;
  SPI variant (MCP23S17) would remove restriction but requires SPI bus wiring — not warranted
- D5: U6 (Stator 0x20) function clarified as ENC service-bus monitoring — read-only telemetry;
  monitors ENC_IN[5:0] + ENC_ACTIVE_KBD_N + ENC_OUT[5:0] + ENC_ACTIVE_LBD_N via Stator CPLD;
  all 14 active pins are inputs (GPA[0:6], GPB[0:6]) — no silicon violation on U6

**Design files updated (all Last Updated: 2026-05-13):**
- `design/Design_Log.md` — DEC-070 date corrected; Context/Decision/Rationale/Files Changed
  sections enriched with all four supplemental points; DS20001952D citations added
- `design/Electronics/User_Settings_Module/Design_Spec.md` — FR-USM-04, DR-USM-07, pin tables,
  §4.2, §6 Operation updated; U1/U2/U3 silicon restriction note blocks added; DS20001952D §1
  citation on all six GPA[7]/GPB[7] inline cells
- `design/Electronics/Stator/Design_Spec.md` — U6 pin table added; U7/U8 pin tables added;
  all tables include directional details; silicon note blocks updated with pin-7-only scope;
  DS20001952D §1 citation on all six GPA[7]/GPB[7] inline cells

**Bookkeeping:** `.copilot/todos/mcp23017-gpb7-silicon-fixed-review.md` → `.recycle-bin/`;
`.copilot/todo-list.md` Last updated: 2026-05-13. Checkpoint 151 created.

All changes are written to disk; user to review and commit ("Let's lock this in").

Next workstreams: `usm-spdt-switch-floating-review`, `enc-connector-review-pre-pcb`,
`consolidate-design-spec-content` (blocked by enc-connector-review-pre-pcb).

## 2026-05-12 session result (follow-up)

DEC-068/069 workstream fully closed. Three post-implementation fixes applied:

- **Mermaid diagram bug (PM Design_Spec.md):** All four J4/J5 and F3/F4 node labels were swapped.
  Corrected to: J4=Battery, J5=USB-C, F3=Battery path, F4=USB-C path.

- **DEC-069 `### Voltage Rating Selection` added:** Documents 24V derivation (EPR unavailable,
  battery max transient 19.7V → 20V floor, 24V chosen, 0ZRB at 30VDC gives 6V margin, THT
  justified as no AEC-Q200 SMD part exists at 6A/12A/≥24V spec).

- **DEC-068 Q1 voltage derating added:** CL32B226KAJNNNE 25V rated at 11–16.9V input = 1.5–2.3×
  derating, consistent with C1–C15 on same rail.

- **Third full audit pass** of discussion file confirmed all technical content mirrored in DECs.
  No remaining gaps — discussion file status confirmed Closed/Implemented.

Lint: markdownlint exit 0 on both files.

Open action (not in todos): Confirm PM enclosure max sustained ambient temperature — 0ZRB at 85°C
derated to 2.64A hold, below 5.35A worst-case system load.

## 2026-05-14 session result

PM per-input polyfuse protection + UVLO recalculation (DEC-069) fully applied across all design
files. KiCAD libraries updated for both new parts in prior sessions.

Main outcomes:

- **PM polyfuse protection (DEC-069):** Bel Fuse 0ZRB0600FF1A polyfuses (F2/F3/F4) added
  upstream of each LM74700 OR-ing FET (PoE, USB-C, Battery inputs). CE/UKCA compliance
  requirement. THT package forced — no qualifying SMD part (6A hold/12A trip, AEC-Q200, ≥24V)
  exists.

- **UVLO recalculation:** R1 changed 232kΩ → 226kΩ (ERJ-3EKF2263V) to account for polyfuse
  hold-state drop (≤40 mΩ × 5.35A = 0.214V) so eFuse EN_UVLO threshold remains at ≈11V source.
  OVLO silicon-fixed at 16.9V — unaffected.

- **Design files updated:**
  - `design/Electronics/Power_Module/Design_Spec.md` — DR-PM-06, DR-PM-19 added; mermaid
    rebuilt; protection description, R1 body, startup timeline, BOM all updated (Last Updated: 2026-05-14)
  - `design/Electronics/Consolidated_BOM.md` — F2/F3/F4 row inserted; R1 row updated
  - `design/Design_Log.md` — DEC-069 appended

- **Discussion closed:** `.copilot/discussions/pm-bulk-caps-and-per-input-protection.md` status
  set to "Closed / Implemented (DEC-068, DEC-069; all design file changes applied 2026-05-14)"

- **Lint clean:** markdownlint exit 0 on all three design files after two MD013 line-wrap fixes.

- **KiCAD library imports (earlier in session thread):** `SamacSys_Parts.kicad_sym` and
  `SamacSys_Parts.lib` / `.dcm` updated with 0ZRB0600FF1A and ERJ-3EKF2263V.

All changes are written to disk; user to review and commit ("Let's lock this in").

Next workstreams: `jtag-integrity-resistor-value-reconcile`, `mcp23017-gpb7-silicon-fixed-review`,
`usm-spdt-switch-floating-review`, `consolidate-design-spec-content`.

## 2026-05-11 session result

The latest repository state includes the completed stackup workstream (DEC-065) and the document
header metadata policy clarification.

Main outcomes:

- **Stackup workstream complete (DEC-065):** All 10 board Design_Spec.md files updated with correct
  JLCPCB stackup codes (`JLC041621-3313` for 4-layer boards, `JLC061621-3313` for the Controller),
  authoritative JLCPCB-calculator impedance values, and correct `§9` Board_Layout sections for the
  Controller. `JLCPCB_Manufacturing.md` and `Global_Routing_Spec.md` fully rewritten for the new
  stackup codes. `Design_Log.md` has DEC-065 appended. `stackup-impedance-analysis.md` moved to
  `.recycle-bin/`.

- **Metadata policy clarified:** `agent-directives.md` now has an unambiguous "Document Header
  Metadata" section. Rule: `Last Updated` **must** be updated on every content change. `Version`
  and all other header fields (`Status`, `Author`, `Associated Hardware Revision`) are the user's
  responsibility only and must never be touched by agents.

- **Last Updated date sweep:** All 13 files modified during the stackup workstream had their
  `Last Updated` corrected to `2026-05-11`. `JLCPCB_Manufacturing.md` also had an anomalous future
  date (`2026-07-11`) corrected to `2026-05-11`.

- **Molex USB connector drawing markdown:** Generated from the user's downloaded Molex drawings;
  inventory JSON updated accordingly.

All changes are written to disk; user to review and commit ("Let's lock this in").

## 2026-04-26 session result

The latest repository state now includes the Encoder CPLD consolidation and logic-spec capture,
the battery-connector candidate note, and the new shared Actuation Module architecture for
Controller + Extension actuation.

Main outcomes:

- stale `probe` / `diagnostic` wording was removed from active design specs and board layouts
- board-layout headings were normalized so section numbering is file-local and `§` stays reserved
  for cross-document references
- the Reflector simplified layout was corrected to remove the duplicate Data Plate label
- Controller / Stator / Settings wording was cleaned up so I2C ownership, pass-through behavior,
  and servo ownership live in the correct documents
- the Stator Settings-board connector refdes was normalized from `J_CFG` to `J13`
- `.github/workflows/wiki-sync.yml` was updated to exclude `design/Datasheets`
- active component refdes were normalized to numeric refs across the design docs and consolidated
  BOM; this was committed as `7829f8a` (`Normalize design document refdes`)
- all markdown document metadata `Version` headers were reset to `v.0.1.0` by explicit user
  direction because the project is still in design phase
- local datasheet PDFs under `design/Datasheets/` now have generated markdown companions, those
  markdown datasheets were reviewed in category batches, and design-doc references were migrated
  from `.pdf` links to the corresponding `.md` datasheets
- Encoder Modules now use the common `EPM570T100I5N` part, external per-line debounce RC networks
  were retired from the active design, and role is selected by programming rather than by
  role-specific PCB population
- a new logic-spec document now exists at `design/Software/CPLD_Logic/Encoder_Logic.md` covering
  sampled 64-bit debounce, 64-to-6 encode, and 6-to-64 decode requirements for later VHDL work
- `design/Design_Log.md` now records this as **DEC-041**, which supersedes active Encoder-board
  assumptions around `EPM240T100I5N` and external RC debounce
- the active Encoder baseline now also explicitly records:
  - MAX II **weak pull-up** as the intended input-bias baseline for encode-role pins
  - internal/UFM oscillator use as the preferred debounce timebase
  - 64-character keyboard mapping as the primary `KBD_ENC` definition, with 26-character and custom
    educational keyboard mappings acknowledged as variant/follow-on work
  - generic `ENCODER MODULE` board-identification silkscreen only; role-specific silkscreen labels
    are no longer required
- the active HID connector contract now also records:
  - generic Encoder connector **pin 8 = `ENC_ACTIVE_N`**
  - `KBD_ENC` drives `ENC_ACTIVE_N` LOW only while a debounced keypress is active
  - the Stator source-select path switches both `ENC_DATA[5:0]` and the activity sideband so the
    physical keyboard and `CM5_KEY_DATA[5:0]` / `CM5_KEY_ACTIVE_N` stay aligned
  - `LBD_DEC` uses `ENC_ACTIVE_N` to blank all outputs when the selected keyboard source is idle
  - `design/Design_Log.md` records this connector and HID-blanking update as **DEC-042**
- the Power Module battery-connector review now has a dedicated candidate-note document,
  `design/Electronics/Power_Module/Millitary_Battery_Connection_Option.md`, which captures:
  - Glenair candidate `807-216-00ZNU6-6DY`
  - ODU AMC NP as an alternate military circular-connector lead pending sales-team feedback
  - a newly noted ODU advantage: panel-mount connector plus wiring-harness availability may avoid a
    custom PM interposer and may also simplify the prototype battery-pack / adapter build
  - Heilind-only sourcing with JLCPCB **consignment-only** assembly expectation
  - the provisional 6-pin vs 5-signal mapping caution
  - confirmed `Y` keying as the standard battery keying intended to prevent mating with data-only
    ports on standard in-service devices such as STAR-PAN and STAR-PAN NG
  - the preferred PM-side **interposer / daughterboard** integration approach
  - a separate prototype-only adapter board direction using the same female receptacle
  - a linked combined markdown datasheet extraction at `design/Datasheets/Glenair-807-216-datasheet.md`
    generated from the Glenair drawing PDF and the 807 NW catalogue PDF
  - closure of the battery-connector review workstream at the candidate-document stage, with the
  remaining connector specifics to be rechecked during the final deep-dive and manual review
  before the design is considered a complete Version 1 release
- the old direct Controller-local servo model has now been retired from the active docs in favour
  of a shared **Actuation Module (AM)** service board:
  - one AM is hosted on the Controller for the main depression-bar actuation path
  - each Extension hosts one AM to regenerate group-boundary carry into the next 5-rotor group
  - the host/AM contract is intentionally minimal: grouped `5V_MAIN`, `3V3_ENIG`, `GND`, and one
    active-low `ACTUATE_REQUEST`
  - the AM owns local servo homing, one-shot request capture, servo PWM generation, and local
    `PWR` / `HOMED` / `ACT` LEDs
- the AM now reserves separate local **J5 SWD** and **J6 UART/bootloader** service headers plus local
  **SW1 NRST** and **SW2 BOOT0** tactile buttons so the selected MCU can be programmed before first use
  with either path
- the AM board-layout note now uses separate TOP / BOTTOM views to make the fitted-side versus
  manual-fit-side intent explicit
- the AM now documents a reduced daughterboard decoupling scheme rather than a full 5x bulk-entry bank:
  C2-C3 = local STM32 100nF decouplers, C4 = 4.7uF on `3V3_ENIG`, C5 = 10uF on `5V_MAIN` near the
  servo power path; this is derived from the JTAG Module decoupling precedent but strengthened for the servo load
- BOM audit pass: active board design-spec BOMs currently show no open `TBD` / empty-supplier placeholder
  rows apart from the intentional CM5 distributor-only entry, and the consolidated AM section now carries
  explicit per-board and Rev A total counts for the current two-module design
- Pass 2 electronics review is complete. All findings F-42–F-66 have been resolved, applied, or
  deferred per user decisions. The fix agent applied the bulk of changes; the orchestrator corrected
  a critical agent error (SET-MAJ-1: bulk caps mis-specified as bypass caps) and three findings that
  were missed (PM-MAJ-2, PM-MIN-2, REF-MIN-1). Audit trail (F-42–F-66) appended to
  `.copilot/review-report.md`. All Pass 2 design changes remain uncommitted, awaiting user "Let's lock
  this in."
- this does **not** close the repo-local `rerun-deep-reviews` workstream; that remains the final
  pre-V1 cross-discipline review gate after electrical, mechanical, and software work are complete and
  each board has a full KiCAD project with exported production Gerbers

## 2025-05 size-down pass (checkpoint 073)

Size-down pass from the electronics deep-review cycle is fully implemented and committed (`9927b8d`).

Key changes:

- All 1206 50V 10µF bulk caps (CL31B106KBHNNNE) replaced with 0805 25V equivalents
  (Samsung CL21B106KAYQNNE) across AM, CTL, ENC, EXT, REF, ROT, STA
  — voltage margins: 7.6× on 3V3\_ENIG, 5.0× on 5V\_MAIN (both exceed 2× mandatory derating)
- Stator 0603 10kΩ resistors (R2–R41, ERJ-3EKF1002V) consolidated to 0402 ERJ-2RKF1002X
- Stator 0603 75Ω resistors (R7–R38, ERJ-3EKF75R0V) consolidated to 0402 ERJ-2RKF75R0X;
  ERJ-3EKF75R0V eliminated from system entirely
- Consolidated BOM fully updated with corrected counts and supplier codes
- `design/Standards/Global_Routing_Spec.md` §3 updated to 25V/0805 as standard bulk cap rule
  with voltage margin notes
- Samsung CL21B106KAYQNNE markdown datasheet generated and committed:
  `design/Datasheets/Samsung-1276_CL21B1-datasheet.md`
- D1/D2/D3 fixes committed (`da3df20`): AM GND ring retained (no isolation), ESD removed from
  all internal connectors, switch debounce time set to 10ms

## 2025-05 datasheet hygiene pass (checkpoint 074)

Datasheet coverage audit and hygiene pass completed and committed.

Key changes:

- `design/Electronics/Consolidated_BOM.md` §11 Samtec links fixed:
  `samtec-erm8-erf8-datasheet.md` (combined, non-existent) replaced with
  `erf8-xxx-xx.x-xxx-dv-xxxx-xx-mkt-datasheet.md` and
  `erm8-xxx-xx.x-xxx-dv-xxxx-xx-mkt-datasheet.md` (both confirmed present)
- BOM §11: 5 new entries added: Samsung CL21B106KAYQNNE, KAM05CR71A105KH,
  CC1206KKX7R8BB106, TDK CGA9N3X7R1E476M230KB, TDK CGA6P3X7R1H475K250AD
- `design/Datasheets/_generated_markdown_inventory.json`: 7 new `pdf_to_markdown` entries
- Orphaned `Kyocera-AVX-KGP-datasheet.{md,pdf}` deleted (KGP stack cap, zero BOM references)
- `.copilot/checkpoints/057-size-down-pass-complete.md` fully removed from git index

## 2025-05 electronics deep-review cycle complete (checkpoint 075)

All accumulated electronics deep-review findings committed as one coherent set (`41b6d07`).

Key changes:

- **Power Module:** ROTOR\_EN→ROTOR\_EN\_N rename; TPS25751/PD topology note added;
  C53–C57 internal-reg bypass caps added (LTC3350 INTVCC/DRVCC/VCC2P5,
  STUSB4500 VREG\_1V2/VREG\_2V7); BOM note updated to C21–C57;
  Consolidated BOM: PM 1µF 0805 count 3→7, PM 10µF 1206 count 1→2
- **Controller:** U5/U6 GbE ESD arrays (TPD4E05U06QDQARQ1, pair AB + pair CD)
  added — same part as U4, placed before J8 magnetics; resolves CTL-M2
- **Rotor:** Section 6 Thermal & ESD added; DEC-042 unshielded variant confirmed;
  ROT-04 header pin descriptions corrected
- **Settings Board:** R81–R98 (18× 1kΩ gate pull-downs), C5/C6 (2× 10µF 0805) added
- **Stator:** J5–J12 connector name fixes applied
- **Extension:** FR-EXT-06 ACTUATE\_REQUEST pull-up corrected to 3V3\_ENIG
- **Design Log:** DEC-045 (Samtec ERM8/ERF8 ESD for external rotor connectors)
- **Standards:** Global\_Routing\_Spec §9 hot-swap ESD exception clause added
- **Consolidated BOM:** CL21B106KAYQNNE SBD +2; ERJ-2RKF1003X SBD +18;
  330Ω JLCPCB part corrected to C278592; TPD4E05U06 note updated with U4/U5/U6 roles

Open items not yet actioned:

- **CTL-H1:** explicitly deferred by user
- **Rotor ESD TVS (PRTR5V0U10AZ):** pending final sourcing; Section 6 placeholder retained
- **Category C:** battery connector sourcing (awaiting supplier email responses)

## 2026-04-29 second deep-review cycle resolved (checkpoint 076)

All outstanding findings from the second electronics deep-review cycle resolved and committed.

Key changes:

- **DEC-046** written: 50V bypass/decoupling cap rating retained on all non-PM boards (no approved
  25V equivalents; cost delta negligible; PM input-side caps require 50V for derating margin)
- **Controller:** R1 (stale reset pull-up) and R2 (stale 100Ω differential termination) removed;
  R3–R6 renumbered to R1–R4 with no gaps
- **Rotor:** ESD section rewritten — phantom signals removed; U5–U12 array count corrected;
  `ENC_IN[5:0]` / `ENC_OUT[5:0]` now correctly listed
- **Power Module:** PM-H5 removed from spec body (not a design item; review suppression in handoff);
  ODU added as alternate military battery socket supplier alongside Glenair
- **Encoder:** "no longer a silkscreen requirement" → "is not a silkscreen requirement"
- **Stator:** retired servo requirements removed; FR-STA-13 typo fixed; requirements renumbered
- **Consolidated BOM:** 100Ω CTL termination row removed; 10kΩ CTL count 5→4 (total 22→21)

## 2025-07-05 BOM rebuild and part correction (checkpoint 077)

Consolidated BOM fully rebuilt from individual board Design_Spec.md files and CSD17578Q5A part
correction committed.

Key changes:

- **`design/Electronics/Consolidated_BOM.md`**: Completely rebuilt from `all_boards_bom.json`
  (sourced from all 10 board specs). 200 component rows, 115 unique MPNs. Both Section 1 (full
  table with all supplier PNs) and Section 2 (MPN quantity summary) present. Passes lint clean.
- **CSD17483F4T → CSD17578Q5A correction**: Q1/Q2/Q3 on Power Module were incorrectly specified
  as CSD17483F4T (1.5A FemtoFET PICOSTAR 3-pin). Correct part is CSD17578Q5A (30V/25A/5.9mΩ
  SON 5×6mm). DigiKey `296-48512-1-ND`, Mouser `595-CSD17578Q5A`, JLCPCB `C2871447`.
- **`design/Electronics/Power_Module/Design_Spec.md`**: Q1/Q2/Q3 row and design notes updated.
- **`design/Electronics/all_boards_bom.json`**: CSD17483F4T → CSD17578Q5A row corrected.
- **`design/Design_Log.md`**: DEC-047 written for CSD17578Q5A correction.
- Nexperia vs NXP: `74HC157PW-Q100,118` now correctly shows **Nexperia** in the consolidated BOM.
- LMQ61460AFSQRJRRQ1 Mouser PN `595-Q61460AFSQRJRRQ1` confirmed correct (Mouser drops "LM" prefix).

## 2026-05-xx Pass 3 electronics review complete (checkpoints 100–101)

19 findings (F-67–F-87) resolved across 15 files. Key changes:

- Signal renames: `LED_nPWR`→`LED_PWR_N`, `I2C1`→`I2C-1`, `DEV_CLRN`→`DEV_CLR_N`,
  `ACTUATE_REQUEST`→`ACTUATE_REQUEST_N`; requirement-ID prefix `FR/DR-SBD-`→`FR/DR-USM-`
- New DRs: DR-EXT-14/15 (connector locking + keying), DR-PM-14 (rail sequencing),
  DR-CTL-17 (DF40 insertion force), DR-ENC-05 (FDC pull-up), DR-USM-11 (debounce)
- 5 new deferred todos added to `todo-list.md`

## 2026-05-xx Rotor RefDes renames (checkpoints 096–097, 102)

- Variant suffix convention: `U3`→`U3A` (Board A), `U3`→`U3B` (Board B); bypass caps and
  all associated refs (C16A/B, C17A/B, C22A-C25A/B, L5A-L8A/B) renamed throughout
- Consecutive renumber: former R2–R7 gap closed → R1–R6; all BOM and design files updated
- DEC-052 logged in `design/Design_Log.md`
- Files updated: `Rotor/Design_Spec.md`, `Rotor/Board_Layout.md`, `Rotor_26_Char_Design.md`,
  `Rotor_64_Char_Design.md`, `Consolidated_BOM.md`

## 2026-05-xx Pass 4 electronics review complete (checkpoints 103–105)

10 findings (F-88–F-97) + additional EXT-P4-2 standoffs + DF40 connector swap:

- F-88: CTL `I2C1_SDA/SCL`→`I2C_SDA/SCL`; F-89: CTL trace-width note mm/mil corrected
- F-90: EXT DR-EXT-13 pin 2→pin 15; F-91: PM BOM note range rewritten
- F-93: STA `KEY_CM5_ACTIVE_N`→`KEY_CM5_ACTIVE` ×2; F-94: STA DR-STA-12/15 pull-up docs
- F-95: AM `ACTUATION_HOME`→`ACTUATION_HOME_N`; F-96: AM C4 BOM note + DEC-046 cross-ref
- F-97: System_Architecture `ROTOR_EN`→`ROTOR_EN_N`
- EXT-P4-2: Würth `9774040151R` M2.5×4.0mm SMT standoffs BOM row added
- **DF40 swap:** Samtec ERM8/ERF8 replaced across AM/CTL/EXT with Hirose DF40C-20DP-0.4V(51)
  (plug on AM J1) and DF40HC(3.5)-20DS-0.4V(51) (receptacle on EXT J9, CTL J11). AM J2, EXT J10,
  CTL J16 retired. M2.5×3.5mm Würth `9774035151R` standoffs on CTL MH5-8 / EXT MH5-8.
  DR-EXT-10 retired connector row removed.
- New datasheets: Hirose DF40 catalog, Würth 9774035151R, TE 1-1674231-1, TI CSD17578Q5A

## 2026-05-xx Character normalisation complete (checkpoint 106, commit d226689)

- Approved character matrix created: `.copilot/allowed-character-matrix.md`
- 74 `design/` files normalised; em/en dashes→`-`, curly quotes→ASCII, `✅`/`✓`→`✔`,
  `×`→`x`, `½`→`1/2`, `″`→`"`
- German ALL-CAPS umlaut exception: `Ä`, `Ö`, `Ü` permitted in display-label strings
  (e.g. `GRENZFLÄCHE`); documented in character matrix
- Box-drawing characters permitted in `Board_Layout.md` files only
- `.copilot/checkpoints/` files exempt from normalisation rules
- New directive added to `agent-directives.md` pointing to character matrix

## Next return summary

When resuming, read `.copilot/checkpoints/107-session-state-sync-pre-reboot.md` for current state.

Next checkpoint will be **108**.

**Immediate next action:** Verify Pass 3, Rotor RefDes changes, and Pass 4 fixes against current
design files (Steps 1–2 of the plan), then run Review Pass 5 (Step 3). See plan.md §Next Session
Start Point for the full ordered work plan.

## 2026-05-xx Pass 1 review cycle complete (checkpoint 081)

Full electronics deep-review Pass 1 is complete. 42 findings resolved across all 11 boards
plus integration. All user decisions D-1 through D-7 actioned. No uncommitted design debt.

Key changes (summary — see checkpoint 081 for full detail):

- **Agent directives:** SECONDARY DIRECTIVE; review cycle process; global read-first rule;
  general MOQ blanket suppression rule added
- **Standards:** `Global_Routing_Spec.md` §3.2 Per-IC Bypass Capacitors rule added
  (100nF Samsung CL05B104KB5NNNC / JLCPCB C1525 as standard)
- **Power Module:** D4 TVS added — Bourns SMBJ18A-Q (DO-214AA; 18V standoff; 600W;
  Mouser `652-SMBJ18A-Q`; DigiKey `118-SMBJ18A-QCT-ND`; JLCPCB `C1979859` Extended)
- **Controller:** DR-CTL-16 added; C26/C27 100nF bypass caps for U2/U3 (CL05B104KB5NNNC)
- **JTAG Module:** Y1 crystal changed to CTS 435F12012IET (12MHz, 20pF, ±20ppm,
  −40 to +85°C; DigiKey `110-435F12012IETTR-ND`; Mouser `774-435F12012IET`; JLCPCB `C19766404`)
- **JTAG Module:** RESET# → RESET_N throughout; DR-JM IDs renumbered 01–16; ESD statement fixed;
  inverted stackup cross-reference note added
- **Actuation Module:** DR-AM-18 removed; R6 BOM row removed; ACTUATE_REQUEST_N/ACTUATION_HOME_N
  signal renames; Thermal & ESD §7 added; no-external-pull-up note added to firmware spec
- **Rotor Board_Layout:** U5–U8 (Board A) and U9–U12 (Board B) ESD array entries added
- **Extension / Reflector / Settings Board:** DEC-045 cross-refs; stackup strings standardised;
  Thermal & ESD sections added; structural section renumbering for Settings Board
- **Stator Board_Layout:** U5/U6 mux, U7 I²C, U8 JTAG header sections added as functional entries
- **Design_Log:** DEC-043 supersession note; QUE-002 amended to record supersession
- **New datasheets:** `bourns-smbj-q-datasheet.md` and `CTS-crystals-435-datasheet.md`
- **Consolidated BOM:** D4 TVS, C26/C27 bypass, Y1 crystal, AM R4/R5 range, and other row
  corrections applied


## Standing Directives

All standing operational rules, the PRIMARY DIRECTIVE on part number protection, data-lookup order,
version-metadata policy, BOM authority rules, and review suppression notes are consolidated in
`.copilot/agent-directives.md`. Read that file at session start — it takes precedence over any
general defaults.

All deferred work items, TBDs, and open certification actions are tracked in `.copilot/todo-list.md`.
Consult that file rather than re-scanning the repo. Update it when new items are identified or
existing items are closed.

**SQL todo tracking:** At the start of each session, the in-session SQLite database (`todos`,
`todo_deps`) must be populated from `todo-list.md`. Use the INSERT statements in the
"SQL Reconstruction Reference" section at the bottom of that file. Use `INSERT OR IGNORE` so the
script is safe to re-run. This session SQL is ephemeral (does not survive across sessions); the
`todo-list.md` file is the canonical record and must be updated whenever statuses or dependencies
change.

## Remaining follow-up work

These are still open design review items, but they are not yet committed design decisions:

1. Review how Extensions should be used mechanically, including whether interconnect choices for the
   Stator / Reflector / Extension chain should change.
2. Add and review board-level coupons and PAS-oriented test coverage.
3. During later schematic capture, treat the remaining exact package pin/pad assignment work as one
   combined pin-mapping task across the AM STM32, Stator mux U7, and the Encoder / Stator / Rotor CPLD
   parts, aligned with the planned KiCAD project and shared component-library setup; this same
   workstream also preserves the chosen external `J5` / `J6` pinouts, the local `SW1` / `SW2`
   tactile pair on `NRST` / `BOOT0`, and the agreed logical signal roles while locking the exact
   STM32 pad assignment and default `BOOT0` bias network behind them.
4. During the final deep-dive and manual review before declaring Version 1 complete, re-confirm the
   chosen military battery connector details, especially the remaining 6-pin contact assignment,
   `BATT_PRES_N` position, reserved/unused contact behaviour, cable selection, and interposer fit.

---

## Post-2026-04-26 sessions (checkpoint 209 state save)

This section covers all design review work completed between the 2026-04-26 handoff and the
pre-shutdown state save at checkpoint 209.

### Pass 5 electronics review

Pass 5 was a full electronics review across all boards. All findings F-98–F-110 were triaged and
resolved:

- **F-98**: `PWR_BUT` renamed to `PWR_BUT_N` (active-low confirmed); propagated to CTL, PM,
  System_Architecture.md, Software/Linux_OS/Power_Management.md, RPi-cm5-datasheet.md,
  CTL/Board_Layout.md; `DEC-054` appended to Design_Log.md
- **F-99**: `USB_FAULT` renamed to `USB_FAULT_N` (TPS2065C open-drain, active-low)
- **F-100**: MH1–MH4 notes corrected (chassis mounting holes — no standoffs, no BOM row)
- **F-101**: Stator mounting hole spec added (DR-STA-17); Board_Layout §12 added
- **F-102/103**: Rotor Board A and Board B mounting holes specified; Board_Layout §9 added
- **F-104**: Rotor 100nF bypass cap BOM notes corrected
- **F-105/106/107**: Rotor_64_Char and Rotor_26_Char variant C16/C17 notes corrected
- **F-108**: DF40 connector swap deferred; became its own workstream (DEC-059 / later DEC-058)
- **F-109**: Silkscreen rule review completed and appended to Global_Routing_Spec.md
- **F-110**: USM mounting hole section added to Board_Layout.md
- `design/Production/JLCPCB_Manufacturing.md` created; link added from Global_Routing_Spec.md
- DEC-054 appended (signal polarity naming convention)

### Pass 5 supplementary work

- **RefDes audit** across all boards: FR/DR identifiers audited; consecutive renumbering applied;
  committed as a batch
- **Consolidated BOM F-108 updates**: DF40 connector swap applied to Consolidated_BOM.md (DEC-055,
  DEC-056)
- **DEC-056**: Board-level DF40 swaps committed — all boards upgraded from their previous BtB
  connector to Hirose DF40C series
- **DEC-057**: Mounting hole RefDes standardisation rules formalised and applied across all boards;
  GRS §4.3 added
- **DEC-058**: JTAG Module BtB connector upgraded to Hirose DF40C-20DP; JDB renamed to JTAG Module
  (JM) throughout all design docs — all occurrences of `JDB` updated to `JM`
- **DEC-059**: (see Design_Log.md for full entry)
- **DEC-060**: JTAG Daughterboard officially renamed to JTAG Module; all cross-references updated

### Pass 6 electronics review

Pass 6 ran across all boards and produced 101 findings. HIGH findings were triaged first:

- CTL-P6-03/04/05: R4 pull-up network and PoE passive documentation corrected
- JM (JDB) BtB connector: DF40 upgrade validated; connector pinout confirmed
- `bom-func-notes-sweep` done: PM equations added to spec body; all BOM functional notes normalized
- Board statuses: All boards confirmed "In Review" post-Pass 6 (EXT remained "Draft")
- MH RefDes standardisation (`mh-refdes-standardise` todo) completed and committed (checkpoint 127)
- ENC connector RefDes renumbering completed (checkpoint 128)

### Pass 7 electronics review

Pass 7 was the most recent completed review pass. Key items from Pass 7:

- **NEW-GRS-7-01**: Global_Routing_Spec.md §3.2 JLCPCB PN for the 10µF 0805 bulk cap corrected
  from stale value to `C960916` (Samsung CL21B106KAYQNNE); user verified before change
- **NEW-STA-01**: Stator DR-STA-12 updated to specify I²C address pin configuration for the
  onboard mux IC (was unspecified)
- **NEW-BO-7-01**: Board statuses audited; all boards set to "In Review" except EXT which stays
  "Draft" pending outstanding todo; EXT board status confirmed by user
- **DEC-061** appended to Design_Log.md covering all Pass 7 resolutions
- Board status table updated in Boards_Overview.md / each Design_Spec.md header

### KiCAD library work

- **Library migration**: All SamacSys component libraries migrated from legacy KiCAD 5 format
  (`.lib`/`.dcm`/`.mod`) to modern KiCAD 6+ format (`.kicad_sym`/`.kicad_mod`). Both formats
  are retained for compatibility
- **3034TR symbol**: Symbol gap identified in `SamacSys_Parts.kicad_sym` — 3034TR was present in
  legacy formats but absent from the modern `.kicad_sym` file. Symbol added manually:
  - 3 pins: `+_1` (pin 1), `-` (pin 3), `+_2` (pin 2)
  - Reference prefix corrected from SamacSys default `U` to `BT` (battery holders)
  - Body polyline rectangle added; all 12 standard KiCAD properties set
  - File grew from 29,614 → 29,848 lines
  - Modern footprint `3034TR.kicad_mod` added by user to `SamacSys_Parts.pretty/`
- **SG73S1ERTTP4702D**: Placeholder entry in BOM — footprint download still pending

### T1 transformer investigation (CTL)

T1 on the Controller Board is the PoE flyback transformer. Current BOM entry (Coilcraft POE600F-12L)
was rejected because JLCPCB **cannot machine-fit** that part. Three candidates investigated:

| Part | Status | Notes |
|------|--------|-------|
| Coilcraft POE600F-12L | ❌ Rejected | JLCPCB cannot machine-fit |
| Bourns POE060-FD20120S | ⚠️ Candidate | JLCPCB consignment; 1.71:1 turns ratio; 250 kHz; 1875 Vac hipot; DCR 39/90/12 mΩ |
| Würth 750318938 | ✅ Preferred | TI TIDA-050045 reference design uses TPS23730 ACF (same IC as CTL); validated at 5V — CTL uses 12V |

- Aux/secondary winding swap rejected: aux winding wire gauge not rated for 5 A
- **Würth 750318938 datasheet PDF** at `design/Datasheets/Wurth-750318938-datasheet.pdf`
- **Markdown datasheet not yet generated** — generate at next session using agent script in
  `.copilot/agent-scripts/`
- **No BOM change until user explicitly confirms (PRIMARY DIRECTIVE)**
- Next action: generate Würth markdown, complete side-by-side comparison, present to user

### Design_Log.md state

- Last appended entry: **DEC-061** (Pass 7 resolutions)
- **Next entry: DEC-062** — do NOT use any lower number; append-only

### Board status summary (checkpoint 209)

| Board | Status |
|-------|--------|
| PM | In Review |
| CTL | In Review (T1 pending) |
| Stator | In Review |
| Rotor (26-char) | In Review |
| Rotor (64-char) | In Review |
| Reflector | In Review |
| EXT | Draft |
| JM (JTAG Module) | In Review |
| USM | In Review |
| ENC | In Review |
| AM | In Review |

### Pending todos (checkpoint 209)

- `review-pass-8`: pending — clean review after all Pass 7 changes
- `connector-stacking-height-review`: pending (deferred to prototype)
- `enc-connector-review-pre-pcb`: pending (pre-PCB gate)
- `jdb-ft232h-3v3-vregin`: blocked (FT232H Rev C availability)

---

## 2026-05-10 Stackup / Impedance-Recalc work (checkpoint 090 state)

Active todo: `stackup-impedance-recalc` — **in progress, not yet committed**.

All current boards specify stackups where the impedance-controlled prepreg dielectric height
makes the GRS-specified 5 mil / 50 ohm trace width geometrically impossible. This workstream
replaces all board stackup codes and CI trace width rules with verified values.

### Decisions confirmed (user, 2026-05-10)

- **All 4-layer boards**: `JLC041621-3313` (2oz outer / 1oz inner / 3313 prepreg)
  - W50_outer approx 5.1 mil, W50_inner approx 6.6 mil, margin +3.1 mil above 3.5 mil floor
  - CI service required

- **CTL (6-layer)**: `JLC061621-3313` (2oz outer / 1oz inner / 3313 prepreg)
  - Same trace widths as 4-layer; CI service required
  - Two independent justifications: Ethernet BI_DB crossover (pins 3 and 6) cannot be routed on
    a single inner layer; USB 3.0 Molex 48406-0003 SS pairs require separate inner layers per port

- **PM (6-layer)**: `JLC061621-3313` (same physical stackup as CTL)
  - CI service NOT required (PM carries zero CI signals — no USB data, no GbE MDI, no HDMI)
  - Justified independently: 2oz outer for fills; 1oz inner preferred over H/HOZ for current capacity
  - 41mm x 81mm supercap shadow zone, Type VII thermal vias, GND_CHASSIS ring all compatible

Net result: one stackup per layer-count group; no mixed variants.

### Pending before any design file changes

1. **JLCPCB calculator verification** — user must manually run the JLCPCB impedance calculator for
   both stackups and record authoritative trace widths. See `.copilot/discussions/stackup-impedance-analysis.md`
   Section 20 for exact inputs required (50 ohm microstrip/stripline, 90 ohm diff microstrip, 100 ohm
   diff stripline; both stackup codes). IPC-2141A estimates in the analysis file are for reference only.

2. After calculator results are in hand and user approves, **SENARY approval required per file**:
   - `design/Production/JLCPCB_Manufacturing.md`
   - `design/Standards/Global_Routing_Spec.md`
   - All 10 board `Design_Spec.md` files (separate approval each)
   - `design/Design_Log.md` (append-only; check last DEC number — currently DEC-061, next is DEC-062)

3. **Open question still pending**: JM / AM layer order convention (GND as bottom layer for carrier-
   mounted boards).

### Archive

Full analysis in `.copilot/discussions/stackup-impedance-analysis.md` (approx 830 lines):
- All six JLCPCB copper weight combination stackup data
- 10-option comparison table with eliminations
- RJ45 THT and USB 3.0 connector routing analysis
- Calibrated IPC-2141A formula and calibration point
- PM analysis
- JLCPCB calculator guide

