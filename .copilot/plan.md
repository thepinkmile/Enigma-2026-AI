# Enigma-NG Session Plan

> Canonical state: `.copilot/plan.md` in the repository root (tracked in git).
> At the start of a new session, read this file, `.copilot/handoff.md`,
> `.copilot/agent-directives.md`, and the latest relevant checkpoint(s) in `.copilot/checkpoints/`.

---

## Current Status (as of checkpoint 165 — 2026-05-21)

Pass-10 findings resolution in progress. 6 findings remain open across AM, USM, and JM.
**Next immediate task: AM-P10-03** — add GRS §7.1 pin-1 marker callout for J2–J5 in
`design/Electronics/Actuation_Module/Board_Layout.md` §2 (J1 already has the callout).

Samsung CL31B106KBK6PJE selected as the standard 10µF 50V 1206 AEC-Q200 bulk reservoir cap for
all boards (DEC-082). All 87 placements updated across 11 boards. KiCAD library import complete in
all 4 formats. `all_boards_bom.json` retired (DEC-083) — it had completely diverged and was never
actively used.

## Board Design Status

| Board | Status | Notes |
|-------|--------|-------|
| Power Module (PM) | In Review | All P10 findings closed |
| Controller Board (CTL) | In Review | T1 decision complete (DEC-067); all P10 closed |
| Stator | In Review | All P10 findings closed |
| Rotor (26-char) | In Review | All P10 findings closed |
| Rotor (64-char) | In Review | All P10 findings closed |
| Reflector | In Review | All P10 findings closed |
| Extension Board (EXT) | In Review | All P10 findings closed |
| JTAG Module (JM) | In Review | 2 findings open (P10-04, P10-05) |
| User Settings Module (USM) | In Review | 3 findings open (P10-06, P10-08, P10-09) |
| Encoder (ENC) | In Review | All P10 findings closed |
| Actuation Module (AM) | In Review | 1 finding open (P10-03) |

## Open Pass-10 Findings (6 remaining — do in order)

| # | Finding | Board | File | Action |
|---|---------|-------|------|--------|
| 1 | AM-P10-03 | AM | `Board_Layout.md` §2 | Add GRS §7.1 pin-1 marker callout for J2–J5 — **NEXT UP** |
| 2 | USM-P10-06 | USM | `Design_Spec.md` + `Design_Log.md` | Append DEC-084 amending DEC-080: "DPDT" → "SPDT" |
| 3 | USM-P10-08 | USM | `Board_Layout.md` | Add/confirm GRS §7.1 pin-1 marker compliance note |
| 4 | USM-P10-09 | USM | `Board_Layout.md` | Add GRS §6 data plate entry |
| 5 | JM-P10-04 | JM | `Design_Spec.md` §6 | Document UART power-on contention window |
| 6 | JM-P10-05 | JM | `Board_Layout.md` §5 | Add derivation footnote for 5V_USB 80–110mA figure |

## Open Workstreams

### Immediate (resume here)

1. **Finish remaining 6 P10 findings** — see table above
2. **Review Pass 11** (`review-pass-11`) — blocked by `data-plate-standardisation` (pending)
   - Once pass 11 and pass 12 are both clean → `review-clean-passes-gate` can be closed

### Deferred / Blocked

- `data-plate-standardisation` — blocking review-pass-11; no ETA
- `battery-connector-final-review` — blocked: awaiting supplier response
- `jdb-ft232h-3v3-vregin` — blocked (v2.0), pending FT232H Rev C availability
- `display-addon-board`, `cpld-production-replacement`, `display-aperture` — blocked (v2.0)
- `ctl-t1-coilcraft-v2-review` — blocked (v2.0)

## Key Design Decisions (recent)

| Entry | Summary |
|-------|---------|
| DEC-076 | TPS25751 I2C address conflict resolution (I2C1 0x20; EEPROM U18 at 0x50 on isolated I2Cc) |
| DEC-077 | CPLD_RESET_N renamed SYS_RESET_N across all boards |
| DEC-078 | Trace-width convention: GRS §6 standardised |
| DEC-079 | data-plate-standardisation (pending) |
| DEC-080 | SPDT/DPDT terminology correction for USM SW1–SW10 (amends DEC-072) |
| DEC-081 | SPDT formalisation (2026-05-18) |
| DEC-082 | 10µF bulk cap upgrade: 25V 0805 → 50V 1206 AEC-Q200; Samsung CL31B106KBK6PJE adopted |
| DEC-083 | `all_boards_bom.json` retired; BOM authority = Consolidated_BOM.md + board Design_Spec.md |

## Library Status

| File | Status |
|------|--------|
| `SamacSys_Parts.kicad_sym` | CL31B106KBK6PJE appended ✅ |
| `SamacSys_Parts.lib` / `.dcm` | CL31B106KBK6PJE appended ✅ |
| `SamacSys_Parts.pretty/` | `CAPC3216X190N.kicad_mod` added ✅ |
| `SamacSys_Parts.mod` | `CAPC3216X190N` in `$INDEX` + `$MODULE` ✅ |
| `SamacSys_Parts.3dshapes/` | `CL31B106KBK6PJE.stp` added ✅ |
| `3D_Models/` | `CL31B106KBK6PJE.stp` added ✅ |
| `src/Electronics/Library/temp/` | LIB_CL31B106KBK6PJE extracted; safe to clean after user review |

## Critical Standing Rules

- **NEVER commit** without "Let's lock this in" or "Save state" from user in live session
- **Design_Log.md is append-only** — next entry = **DEC-084**; never modify existing entries
- **PRIMARY DIRECTIVE**: Never modify any MPN/supplier part numbers without explicit user confirmation
- **Last Updated** dates must be updated on every content change; **Version** is user-only
- Move unwanted files to `.recycle-bin/`; never delete permanently
- **OCTONARY**: Seed session DB from `todo-list.md` Agent SQL block as MANDATORY FIRST ACTION
- **review-clean-passes-gate**: when adding a new `review-pass-x`, add it as a dep on the gate
- **Board_Layout.md files are visualisation-only** — no design narrative or spec prose
- **BOM Notes are procurement-only** — no function descriptions, signal names, or design rationale
- **BOM authority**: `Consolidated_BOM.md` = system; board `Design_Spec.md` = board (per DEC-083)

## Next Session Start Point

Read these files in order:

1. `.copilot/agent-directives.md` (always first — then seed session DB immediately)
2. This `plan.md`
3. `.copilot/handoff.md` (latest section first)
4. `.copilot/checkpoints/165-samsung-50v-cap-complete-bom-json-retired.md`
5. `.copilot/review-report.md` (open findings: AM lines ~2137, USM/JM lines ~2172)

