# Enigma-NG Handoff

This file is the generic repo-local handoff note for session-to-session context that is useful to
keep near the design docs but is **not** itself a source of design truth.

## Canonical design sources

Use the active `design/` documents as the authoritative record:

- `design/Design_Log.md`
- `design/Electronics/Consolidated_BOM.md`
- board-level `design/Electronics/*/Design_Spec.md`
- board-level `design/Electronics/*/Board_Layout.md`
- relevant mechanical and software `Design_Spec.md` files
- `design/Datasheets/` for preserved vendor and project-side reference material

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
