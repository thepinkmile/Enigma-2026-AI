# Enigma-NG Session Plan

> Canonical state: `.copilot/plan.md` in the repository root (tracked in git).
> At the start of a new session, read this file, `.copilot/handoff.md`,
> `.copilot/agent-directives.md`, and the latest relevant checkpoint(s) in `.copilot/checkpoints/`.

---

## Overview

The repository is now in an updated repo-local handoff state after the latest documentation cleanup
phase.

The current active design docs now reflect:

- board-local ownership cleanup between Controller, Stator, and User Settings Module
- removal of stale diagnostics / probe wording from active design specs and board layouts
- normalized board-layout heading numbering so `§` is reserved for cross-document references
- Reflector simplified-layout cleanup, including removal of the duplicate Data Plate label
- Stator User Settings Module connector normalization from `J_CFG` to `J13`
- wiki-sync exclusion of `design/Datasheets`
- numeric component refdes normalization across active design docs and the consolidated BOM
- document metadata version headers reset to `v.0.1.0` because the project is still in design phase
- local PDF datasheets now have markdown companions under `design/Datasheets/`, with reviewed
  design-doc references retargeted from PDF links to the markdown versions
- Encoder Modules now target the common `EPM570T100I5N`, with encode-role debounce moved into CPLD
  logic and detailed logic requirements captured in `design/Software/CPLD_Logic/Encoder_Logic.md`
- the Encoder board split review is now closed around the `EPM570` / weak-pull-up /
  programming-defined-role baseline, with the rationale captured in the active design docs and
  `DEC-041`
- the Stator ↔ Encoder 20-pin contract now assigns **pin 8** to the HID-local active-low
  `ENC_ACTIVE_N` sideband, with `KBD_ENC` driving activity, `LBD_DEC` using it for blanking, and
  the Stator muxing / monitoring the selected activity source under `DEC-042`
- the Power Module battery-connector review now has a dedicated candidate-note document at
  `design/Electronics/Power_Module/Millitary_Battery_Connection_Option.md`, capturing the
  Glenair `807-216-00ZNU6-6DY` / Heilind / consignment-only option plus the preferred PM interposer
  and prototype-adapter-board direction pending connector confirmation
- the Glenair drawing PDF and 807 NW catalogue PDF now have a combined markdown extraction at
  `design/Datasheets/Glenair-807-216-datasheet.md`, linked from the Power Module battery option note
- the Glenair candidate's `Y` keying is now treated as confirmed standard battery keying for the
  connector family rather than as an open question
- the battery-connector review workstream is now closed at the candidate-document stage; the chosen
  connector still requires explicit confirmation during the final deep-dive and manual review before
  the design is treated as a complete Version 1 release
- the battery connector option note now also records the ODU AMC NP family as an alternate
  military-style connector lead pending sales feedback and further review
- the former direct Controller servo path has now been replaced in the active docs by a shared
  **Actuation Module (AM)** architecture: one AM on the Controller plus one on each Extension
- Extension-boundary carry is now documented as **mechanical within a 5-rotor group** and
  **locally regenerated across each Extension boundary** via active-low `ACTUATE_REQUEST`
- the Reflector / Extension service harness has been widened from **16-pin** to **20-pin**
  `BHR-20-VUA` so grouped `5V_MAIN` can reach Extension-local actuation hardware
- `design/Design_Log.md` now records this architecture as **DEC-043**

Recent locked work:

- `7829f8a` — `Normalize design document refdes`
- `1c2a505` — `Reset doc metadata versions`
- `4e36234` — `Close encoder split review`
- **Pass 1 review cycle complete** — 42 findings resolved across all 11 boards + integration;
  all user decisions D-1 through D-7 actioned; new datasheets for Bourns SMBJ18A-Q and
  CTS 435F12012IET generated; all files lint-clean
- **Pass 2 review cycle complete** — all findings F-42–F-66 resolved; audit trail in
  `.copilot/review-report.md`
- **Pass 3 review cycle complete** — 19 fixes (F-67–F-87) across 15 files; signal renames,
  new DRs, Mouser PNs corrected; audit trail appended to review-report.md
- **Rotor RefDes renames and reallocate** — variant A/B suffix convention (U3A/U3B, etc.),
  consecutive renumber (R1-R6 gap closed), all design docs and BOM updated; DEC-052 logged
- **Pass 4 review cycle complete** — 10 fixes (F-88–F-97) + EXT-P4-2 standoffs applied; DF40
  connector swap across AM/CTL/EXT (ERM8/ERF8 retired for AM attachment); DR-EXT-10 retired;
  new datasheets: Hirose DF40, Würth 9774035151R, TE 1-1674231-1, TI CSD17578Q5A; all lint-clean
- **Pass 5 review cycle complete** — 12 fixes (F-98–F-110) across 21 files; PWR_BUT_N/USB_FAULT_N
  signal renames, mounting hole DRs + Board_Layout sections, bypass cap attribution, global pin-1
  silkscreen rule (GRS §7.1), Production folder for JLCPCB constraints; DEC-054 logged;
  F-108 (DR-EXT-10 gap + RefDes cleanup) deferred, blocks Pass 6 launch

---

## Current Open Workstreams

| ID | Status | Scope |
| ---- | -------- | ------- |
| `review-cycle-pass3` | **done** | Pass 3 electronics review fixes complete and committed; all 19 fixes (F-67–F-87) applied; audit trail in review-report.md |
| `review-cycle-pass4` | **done** | Pass 4 electronics review fixes complete and committed; 10 fixes (F-88–F-97) + EXT-P4-2 standoffs; DF40 swap; audit trail in review-report.md |
| `char-normalise-directives` | **done** | Approved character matrix created; 74 design files normalised; German ALL-CAPS umlaut exception documented; committed `d226689` |
| `bom-description-strip` | **done** | All 11 board spec Component columns stripped; Consolidated_BOM.md rebuilt; all files lint-clean |
| `review-cycle-pass5` | **in progress** | Pass 5 review complete. Commit 1 (F-98–F-107, F-109, F-110, Production folder) pending user go-ahead. Commit 2 (F-108 RefDes review) blocked until user releases F-108 block. |
| `extension-mechanical-usage` | pending | Detailed switch/linkage geometry for Extension boundary carry still needed; architectural answer (shared AM) is locked but physical linkage spec is not |
| `coupon-testing-review` | pending | Add and review board-level coupons and PAS-oriented test coverage so production boards do not retain test-only hardware |
| `battery-connector-final-review` | **blocked** | Re-confirm Glenair `807-216-00ZNU6-6DY` contact assignment, `BATT_PRES_N` position, cable, and interposer fit; check ODU AMC NP lead — awaiting supplier response |
| `rerun-deep-reviews` | pending | Final pre-V1 cross-discipline deep-review — run only once electrical, mechanical, and software work are complete and each board has a full KiCAD project with exported production Gerbers |

---

## Board Design Status

| Board | Status |
| ------- | -------- |
| Power Module | In Review (Pass 5 fixes applied) |
| Stator | In Review (Pass 5 fixes applied) |
| Reflector | In Review (Pass 3 fixes applied; no Pass 4/5 changes) |
| Extension | In Review (Pass 4 fixes applied; F-108 deferred) |
| JDB | In Review (Pass 2 fixes applied; no Pass 3–5 changes) |
| Controller | In Review (Pass 5 fixes applied) |
| Encoder | In Review (Pass 3 fixes applied; no Pass 4/5 changes) |
| Rotor | In Review (Pass 5 fixes applied) |
| User Settings Module | In Review (Pass 5 fixes applied) |
| Actuation Module | In Review (Pass 4/5 fixes applied) |

---

## Next Session Start Point

Start the next clean session by reading **in this order**:

1. `.copilot/agent-directives.md` — **load every directive as a standing memory rule before any other work**
2. `.copilot/plan.md`
3. `.copilot/handoff.md`
4. `.copilot/todo-list.md` — populate the in-session SQL `todos`/`todo_deps` tables from the
   "SQL Reconstruction Reference" section at the bottom of that file
5. `.copilot/checkpoints/027-pass-5-fixes-complete.md` (latest checkpoint)
6. `.copilot/review-report.md` (for full Pass 1–4 audit trail)

### Ordered work for next session

#### Step 1 — Verify Pass 3 fixes and Rotor RefDes changes

Read `.copilot/checkpoints/100-pass3-electronics-review-fixes-complete.md`.
Check that every fix F-67–F-87 is present in the current design files:

- Signal renames: `LED_nPWR`→`LED_PWR_N`, `I2C1`→`I2C-1`, `DEV_CLRN`→`DEV_CLR_N`,
  `ACTUATE_REQUEST`→`ACTUATE_REQUEST_N`, `FR-SBD-`/`DR-SBD-`→`FR-USM-`/`DR-USM-`
- New DRs: DR-EXT-14/15, DR-PM-14, DR-CTL-17, DR-ENC-05, DR-USM-11
- Mouser PNs corrected in 3 files

Then read checkpoints 096, 097, 102 and confirm Rotor RefDes state:

- U3A/U3B variant naming, C16A/B C17A/B C22A-C25A/B L5A-L8A/B throughout
  `Design_Spec.md`, `Board_Layout.md`, `Rotor_26_Char_Design.md`, `Rotor_64_Char_Design.md`, `Consolidated_BOM.md`
- R1–R6 gap-free numbering (no R2–R7 gap); confirmed in all three files

#### Step 2 — Verify Pass 4 fixes

Read `.copilot/checkpoints/103-pass4-wrap-up-complete-ext-p4-2-unblocked.md`
and `.copilot/checkpoints/104-df40-swap-all-files-complete.md`.
Check that every fix F-88–F-97 plus EXT-P4-2 standoffs and the DF40 swap are present:

- F-88: `I2C1_SDA/SCL`→`I2C_SDA/SCL` in CTL Board_Layout
- F-89: `6.0 mil`→`0.20 mm (7.87 mil)` in CTL Design_Spec
- F-90: DR-EXT-13 pin 2→pin 15 in EXT Design_Spec
- F-91: PM BOM note range rewritten
- F-93: `KEY_CM5_ACTIVE_N`→`KEY_CM5_ACTIVE` in STA Board_Layout
- F-94: DR-STA-12/15 pull-ups + §3 bullets in STA Design_Spec
- F-95: `ACTUATION_HOME`→`ACTUATION_HOME_N` in AM Board_Layout
- F-96: C4 BOM note + DEC-046 cross-ref in AM Design_Spec
- F-97: `ROTOR_EN`→`ROTOR_EN_N` in System_Architecture
- EXT-P4-2: `Wurth 9774040151R` standoffs BOM row in EXT Design_Spec
- DF40 swap: AM J1 (DF40C plug), EXT J9 / CTL J11 (DF40HC receptacles), retired J10/J16;
  standoffs 9774035151R (3.5mm) on EXT MH5-8 / CTL MH5-8; BOM updated

#### Step 3 — Run Review Pass 5

Launch Pass 5 using the multi-agent review process defined in `agent-directives.md`.
Load all 10 board specs + integration doc fresh; apply all current agent directives as memories.
Target: identify any remaining inconsistencies after Passes 1–4 and the RefDes/DF40 changes.
Append findings to `.copilot/review-report.md` as F-98 onwards.

Mark `interim-electronics-review-1` done after Steps 1-2 verify clean.
Mark `review-cycle-pass5` in-progress before launching the review agents.

---

## Critical Notes

> Standing operational rules (PRIMARY DIRECTIVE, data-lookup order, version-metadata policy,
> BOM authority, review suppression) are in `.copilot/agent-directives.md`. Read that file at
> session start.
>
> All deferred items, TBDs, and open certification actions are tracked in `.copilot/todo-list.md`.
> Do not re-derive them from a repo grep — update that file when new items are found or items are closed.

### Documentation policy

- Use the active `design/` documents as the source of truth for design state.
- `.copilot/` files are session/handoff artifacts only; they are not design documents.
- Do not change document `Version` metadata unless the user explicitly requests it.
- The current metadata baseline for active docs is `v.0.1.0`.
- Design-doc datasheet references should point at the reviewed markdown datasheets, while each
  generated datasheet markdown file keeps its own source-PDF link.
- Active Encoder baseline: `EPM570T100I5N`, digital debounce in CPLD logic, and role selected by
  programming rather than role-specific RC population.
- Active HID-side Encoder connector contract: pin 8 is `ENC_ACTIVE_N`, idle state is HIGH, and the
  signal is intentionally local to the keyboard / lightboard path rather than the wider cipher path.
- Active PM battery review state: Glenair `807-216-00ZNU6-6DY` is the documented candidate path,
  `Y` keying is confirmed standard battery keying, ODU AMC NP is logged as an alternate vendor lead,
  and the remaining connector questions must be rechecked during the final deep-dive and manual
  review before the design is marked complete V1.
- Active actuation baseline: use the shared **Actuation Module (AM)** on the Controller and on each
  Extension; CM5 GPIO 8 is now `ACTUATE_REQUEST_N`, the Controller no longer owns direct servo PWM,
  and the Reflector / Extension link is now a 20-pin `BHR-20-VUA` service harness so `5V_MAIN` can
  feed Extension-local actuation.
- The AM now reserves separate local **J5 SWD** and **J6 UART/bootloader** headers plus local **SW1
  NRST** and **SW2 BOOT0** tactile buttons so the final MCU can be programmed before first use without
  depending on the host board.
- AM layout visual now uses separate TOP (L1 enclosed/component side) and BOTTOM (L4 service/exterior
  side) views. AM decoupling now follows a reduced daughterboard pattern: STM32 local 100nF decouplers,
  4.7uF on `3V3_ENIG`, and 10uF on `5V_MAIN` near the servo path, rather than a full 5x bulk-entry bank.
- BOM audit: active board BOMs currently show no open `TBD` / empty-supplier placeholders apart from the
  intentional CM5 distributor-only row; the consolidated BOM AM section now includes explicit per-board
  and Rev A total counts for the current two-module design.
- The non-mechanical Extension notch pass-through review is now considered closed in repo-local state:
  the architectural answer is the shared AM baseline, and only later mechanical linkage/detail work remains.
- The AM firmware specification now lives under
  `design/Software/Actuation_Module/Design_Spec.md`; the electronics AM spec keeps only a brief
  cross-reference to that software document.
- Pass 3 electronics review complete. All 19 fixes (F-67–F-87) applied across 15 files; all lint-clean.
  Signal renames: `LED_nPWR`→`LED_PWR_N`, `I2C1`→`I2C-1`, `DEV_CLRN`→`DEV_CLR_N`,
  `ACTUATE_REQUEST`→`ACTUATE_REQUEST_N`, `FR-SBD-`/`DR-SBD-`→`FR-USM-`/`DR-USM-`.
  New DRs: DR-EXT-14/15, DR-PM-14, DR-CTL-17, DR-ENC-05, DR-USM-11. Mouser PNs corrected in 3 files.
  PM-MIN-1 carry-forward dismissed as false positive. SET-MAJ-2 still deferred.
- This does **not** close the repo-local `rerun-deep-reviews` workstream. That workstream remains the
  final pre-V1 cross-discipline review gate to be rerun only after electrical, mechanical, and software
  work are complete and each board has a full KiCAD project plus exported production Gerbers.
- A later shared schematic-capture workstream still needs to lock exact package pin/pad assignments for
  the AM STM32, Stator mux U7, and the Encoder / Stator / Rotor CPLD parts; treat that as one combined
  pin-mapping task so it can align with the planned KiCAD project and shared component-library setup.

### Refdes / naming state

- Controller internal connectors are now normalized to numeric refs (`J9`-`J15`) in the active docs.
- Stator User Settings Module connector refdes is `J13`.
- User Settings Module component refs are now numeric in the active docs and BOM (`J1`, `U1`-`U3`,
  `Q1`-`Q6`, `SW1`-`SW11`, `D1`-`D12`, `R1`-`R53`, `C1`-`C4`).

### Repo-local state rules

- `.copilot/` is tracked in git and must be kept in sync with meaningful design-state changes.
- Every checkpoint must update the checkpoint file, `.copilot/checkpoints/index.md`,
  `.copilot/plan.md`, and any related handoff content together.

