# Enigma-NG Session Plan

> Canonical state: `.copilot/plan.md` in the repository root (tracked in git).
> At the start of a new session, read this file, `.copilot/handoff.md`,
> `.copilot/agent-directives.md`, and the latest relevant checkpoint(s) in `.copilot/checkpoints/`.

---

## Current Status (as of checkpoint 162)

Pass 10 complete and all 38 findings resolved (commit `75b3707`). C20 upgraded to TDK
CGA9N1X7R1V476M230KC (47µF 35V). Library imported. Temp directory cleaned.

This session focused on todo dependency restructuring:
- `review-clean-passes-gate` added — aggregates all review-pass-x; manually closed when 2 consecutive clean passes achieved
- `review-pass-12` added (pass 10 was not clean; two more passes needed)
- `bom-pre-prototype-check` now also gates on `consolidate-design-spec-content`
- `bom-pre-production-check` now also gates on all four testing todos
- `consolidate-design-spec-content` deps on `review-clean-passes-gate` (not interim-electronics-review-3)
- `system-config-variants-diagrams` now gates on `prototype-pcb-manufacturing`
- `interim-electronics-review-1` restored dep on `consolidate-design-spec-content` (safe: circular dep resolved)

Session DB: 113 todos — 34 pending, 72 done, 7 blocked (seeded from todo-list.md Agent SQL block).

## Board Design Status

| Board | Status | Notes |
|-------|--------|-------|
| Power Module (PM) | In Review | |
| Controller Board (CTL) | In Review | T1 decision complete (DEC-067) |
| Stator | In Review | |
| Rotor (26-char) | In Review | |
| Rotor (64-char) | In Review | |
| Reflector | In Review | |
| Extension Board (EXT) | Draft | consolidate-design-spec-content todo pending |
| JTAG Module (JM) | In Review | |
| User Settings Module (USM) | In Review | |
| Encoder (ENC) | In Review | |
| Actuation Module (AM) | In Review | |

## Open Workstreams

### Immediate (next session start)

1. **Download remaining 3D models** (`download-missing-3d-models`) — READY
   - 33 parts still need STP files; drop zips into `src\Electronics\Library\temp\` and import
   - See `.copilot/todos/download-missing-3d-models.md` for full part list (13 generic IPC + 20 part-specific)
   - Generic IPC models (13): use KiCAD standard library refs; part-specific (20): need SamacSys zips from user

2. **Extension interconnect architecture review** (`extension-mechanical-usage`) — READY
   - See `.copilot/todos/extension-mechanical-usage.md`

3. **Review Pass 11** (`review-pass-11`) — blocked by `download-missing-3d-models`
   - Once pass 11 and pass 12 are both clean → `review-clean-passes-gate` can be closed
   - See `.copilot/todos/review-pass-11.md`

### Deferred / Blocked

- `battery-connector-final-review` — blocked: awaiting supplier response
- `jdb-ft232h-3v3-vregin` — blocked (v2.0), pending FT232H Rev C availability
- `display-addon-board`, `cpld-production-replacement`, `display-aperture` — blocked (v2.0)
- `ctl-t1-coilcraft-v2-review` — blocked (v2.0)

## Key Design Decisions (recent)

| Entry | Summary |
|-------|---------|
| DEC-068 | PM bulk-cap placement (pre-OR-ing, 5V_MAIN, 3V3_ENIG) |
| DEC-069 | PM per-input polyfuse (F2/F3/F4) + UVLO recalculation (R1 → ERJ-3EKF2263V) |
| DEC-070 | MCP23017 GPA[7]/GPB[7] output-only restriction; CFG_APPLY_N reassigned USM U1 GPB[7]→GPA[6] |
| DEC-071 | USM switch topology: dual-terminated (NC→GND, NO→3V3_ENIG); R1–R10 removed |
| DEC-072 | Pass 9 resolutions (see Design_Log.md) |
| DEC-073 | LTC3350 RT resistor correction (R23 → ERA-2AEB1333X 133kΩ; fSW = 402kHz) |
| DEC-074 | Rename CPLD reset signal SYS_RESET_N → CPLD_RESET_N across all boards |
| DEC-075 | TPS25751 Option C: SafeMode + M24512 EEPROM U18 + J6 I2Ct debug header on PM |
| DEC-076 | TPS25751 I2C address conflict resolution (I2C1 address 0x20; EEPROM U18 at 0x50 on isolated I2Cc) |

## Library Status

| File | Status |
|------|--------|
| `SamacSys_Parts.kicad_sym` | CGA9N1X7R1V476M230KC added (commit 75b3707) |
| `SamacSys_Parts.mod` | CGA9N1X7R1V476M230KC SHAPE3D added ✅ |
| `SamacSys_Parts.3dshapes/` | 33 STP files; 33 additional parts still pending download |
| `src/Electronics/Library/temp/` | Empty — ready for next batch of zips |

## Critical Standing Rules

- **NEVER commit** without "Let's lock this in" or "Save state" from user
- **Design_Log.md is append-only** — next entry = DEC-077; never modify existing entries
- **PRIMARY DIRECTIVE**: Never modify any MPN/supplier part numbers
- **Last Updated** dates must be updated on every content change; **Version** is user-only
- All board statuses: "In Review" (EXT = "Draft")
- Move unwanted files to `.recycle-bin/`; never delete
- **OCTONARY**: Seed session DB from `todo-list.md` Agent SQL block as MANDATORY FIRST ACTION
- **review-clean-passes-gate**: when adding a new `review-pass-x`, add it as a dep on the gate in todo-list.md AND the gate detail file AND session DB

## Next Session Start Point

Read these files in order:

1. `.copilot/agent-directives.md` (always first — then seed session DB immediately)
2. This `plan.md`
3. `.copilot/handoff.md` (latest section first)
4. `.copilot/checkpoints/index.md` → checkpoint 162
5. Relevant todos from `.copilot/todos/` (see Open Workstreams above)

