# Checkpoint 114 — DEC-057 consolidated; Pass 6 implementation locked

**Session:** a38ceaab-453d-429a-b9a2-f597295a7147
**Date:** 2026-05-05

## Overview

Pass 6 review implementation complete and user-reviewed. DEC-057/058 consolidated into a single authoritative mounting hole policy. MH RefDes standardisation scheme finalised. All deferred items converted to tracked todos. Changes committed to repository.

## Work Done This Session

### Pass 6 implementation (batches 1–4)
- All Pass 6 review findings implemented across all boards (AM, CTL, EXT, JDB, ROT, STA, USM, ENC, PM, REF)
- Key fixes: ROT JTAG inter-device net named TTD; ENC not a daughterboard; JDB-P6-14/15 cross-refs and stackup text; USM GRS section re-order; RESET_N board-local note on JDB matching AM
- Pass 6 high-findings and CTL-specific findings resolved (checkpoints 111, 112, 113)

### DEC-057/058 consolidation
- DEC-057 rewritten as single fully declarative mounting hole policy (supersedes DEC-039/023 for those topics)
- EXT explicitly recognised as AM co-carrier (has standoff BOM entries)
- ENC explicitly noted as NOT a daughterboard (M3 chassis mounting per GRS)
- CTL MH13-MH16 (JDB dock) added to DEC-057 special-case table
- All "RefDes TBD" occurrences replaced with MH13-MH16
- Rationale cleaned — historical error reference removed (old decisions were replaced, not amended)
- DEC-058 skeleton fully removed from Design_Log.md

### MH RefDes standardisation scheme (agreed, not yet applied)
- MH1-MH4 = chassis mounting holes (all chassis-mounted boards)
- MH5-MH8 = AM dock standoffs (CTL, EXT)
- MH9-MH12 = CM5 SoM mounting holes (CTL only)
- MH13-MH16 = JDB dock standoffs (CTL only)
- CTL current assignment is inverted vs. scheme — corrected by `mh-refdes-standardise` todo

### New todos created
- `jdb-standoff-height` — research RS1-05-G + PH1-05-UA stacking height; consider connector upgrade; determine standoff PN for MH13-MH16
- `mh-refdes-standardise` — blocked on `jdb-standoff-height`
- Dependency chain: `jdb-standoff-height` → `mh-refdes-standardise` → `review-pass-7`

### Agent directives updated
- `## SECONDARY DIRECTIVE — Git Commits` strengthened: agents must NEVER run `git add`, `git stage`, or `git restore --staged`. Git staging is solely the user's action.

### Housekeeping
- `reset-n-prefix-decision` marked done
- Two `pass6-*.md` files moved to `.recycle-bin/`
- DEC-058 removed from Design_Log.md

## Todo Status
- Done: 27 | Pending: 49 | Blocked: 5

## Files Changed (31 files)
- `.copilot/agent-directives.md` — git staging ban added
- `.copilot/todo-list.md` — new todos; dependencies; reset-n done
- `.copilot/checkpoints/111, 112, 113` and index.md
- `.copilot/plan.md`, `.copilot/review-report.md`
- `design/Design_Log.md` — DEC-057 consolidated; DEC-058 removed
- All board Design_Spec.md and Board_Layout.md files (Pass 6 fixes)
- `design/Electronics/Consolidated_BOM.md`
- `design/Standards/Global_Routing_Spec.md`
- `design/Software/` files

## Next Steps
1. `jdb-standoff-height` — look up RS1-05-G + PH1-05-UA stacking height; connector upgrade review; select standoff PN
2. `mh-refdes-standardise` (blocked on above) — rename MH RefDes across all boards
3. `review-pass-7` (blocked on above) — post-pass-6 implementation check
