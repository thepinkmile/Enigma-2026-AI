# Enigma-NG Session Plan

> Canonical state: `.copilot/plan.md` in the repository root (tracked in git).
> At the start of a new session, read this file, `.copilot/handoff.md`,
> `.copilot/agent-directives.md`, and the latest relevant checkpoint(s) in `.copilot/checkpoints/`.

---

## Current Status (as of checkpoint 160)

Review Pass 9 complete (checkpoint 159). Library import of official Hirose DF40 and TPS parts
complete (checkpoint 160): DF40C20DP04V51, DF40HC3520DS04V51, TPS23730RMTR, TPS25751DREFR,
TPS259804ONRGER all synced across STP / `.kicad_mod` / symbol / legacy SHAPE3D.

OCTONARY directive hardened: session DB seeding is now mandatory first action each session;
3-way sync (summary table + Agent SQL INSERT + session DB) required for all todo changes.

Session DB: 109 todos — 33 pending, 70 done, 6 blocked, 95 dependency rows.

33 parts still missing 3D model STP files — tracked in `download-missing-3d-models` todo.
`review-pass-10` is next unblocked review (54 deferred Pass 9 findings).

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

1. **Download remaining 3D models** (`download-missing-3d-models`)
   - 33 parts still need STP files; drop zips into `src\Electronics\Library\temp\` and import
   - See `.copilot/todos/download-missing-3d-models.md` for full part list

2. **Review Pass 10** (`review-pass-10`)
   - 54 deferred findings from Pass 9; unblocked now that `review-pass-9` is done
   - See `.copilot/todos/review-pass-10.md` for detail
   - ENC J1/J2 and 100nF cap review; see `.copilot/todos/enc-connector-review-pre-pcb.md`

3. **Consolidate design spec content** (`consolidate-design-spec-content`)
   - Blocked by `enc-connector-review-pre-pcb`
   - See `.copilot/todos/consolidate-design-spec-content.md` for detail

### Deferred / Blocked

- `battery-connector-final-review` — blocked: awaiting supplier response
- `connector-stacking-height-review` — deferred to prototype stage
- `jdb-ft232h-3v3-vregin` — blocked (v2.0), pending FT232H Rev C availability
- `display-addon-board`, `cpld-production-replacement`, `display-aperture` — blocked (v2.0)
- `ctl-t1-coilcraft-v2-review` — blocked (v2.0)
- `review-pass-11` — blocked by `download-missing-3d-models` and `review-pass-10`

## Key Design Decisions (recent)

| Entry | Summary |
|-------|---------|
| DEC-068 | PM bulk-cap placement (pre-OR-ing, 5V_MAIN, 3V3_ENIG) |
| DEC-069 | PM per-input polyfuse (F2/F3/F4) + UVLO recalculation (R1 → ERJ-3EKF2263V) |
| DEC-070 | MCP23017 GPA[7]/GPB[7] output-only restriction; CFG_APPLY_N reassigned USM U1 GPB[7]→GPA[6] |
| DEC-071 | USM switch topology: dual-terminated (NC→GND, NO→3V3_ENIG); R1–R10 removed |
| DEC-072 | Pass 9 resolutions (see Design_Log.md) |

## Library Status

| File | Status |
|------|--------|
| `SamacSys_Parts.kicad_sym` | 5 parts replaced this session; ~31,943+ lines |
| `SamacSys_Parts.mod` | SHAPE3D blocks added for all 5 parts ✅ |
| `SamacSys_Parts.3dshapes/` | 32 STP files; 33 additional parts still pending download |
| `src/Electronics/Library/temp/` | Empty — ready for next batch of zips |

## Critical Standing Rules

- **NEVER commit** without "Let's lock this in" or "Save state" from user
- **Design_Log.md is append-only** — next entry = DEC-073; never modify existing entries
- **PRIMARY DIRECTIVE**: Never modify any MPN/supplier part numbers
- **Last Updated** dates must be updated on every content change; **Version** is user-only
- All board statuses: "In Review" (EXT = "Draft")
- Move unwanted files to `.recycle-bin/`; never delete
- **OCTONARY**: Seed session DB from `todo-list.md` Agent SQL block as MANDATORY FIRST ACTION

## Next Session Start Point

Read these files in order:

1. `.copilot/agent-directives.md` (always first — then seed session DB immediately)
2. This `plan.md`
3. `.copilot/handoff.md` (latest section first)
4. `.copilot/checkpoints/index.md` → checkpoint 160
5. Relevant todos from `.copilot/todos/` (see Open Workstreams above)

