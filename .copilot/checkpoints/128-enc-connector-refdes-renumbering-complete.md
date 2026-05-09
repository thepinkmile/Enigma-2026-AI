# Checkpoint 128 — ENC Connector RefDes Renumbering Complete

**Date:** 2026-05-08
**Status:** Committed (`224b664`)

## What Was Done

Completed the `enc-connector-review-pre-pcb` todo. Removed the off-board panel-mount jack
socket from the ENC PCB BOM entirely; renumbered the remaining PCB connectors; propagated
changes to all affected files; added plugboard jack assembly detail to the Plugboard Assembly
spec.

### Changes

- **J1 (panel-mount 6.35mm jacks) — removed from PCB BOM entirely.**
  These have no PCB footprint and are assembly-level parts only. Canonical home is now
  `design/Mechanical/Plugboard_Assembly/Design_Spec.md §7`.
- **J2 (20-pin IDC Stator interconnect) → J1.** Primary board-to-board connector.
- **J3–J66 (PCB spade blade terminals) → J2–J65.** 64 × single-terminal parts.

### ENC connector numbering after this commit

| RefDes | Part | Notes |
| :--- | :--- | :--- |
| J1 | BHR-20-VUA 20-pin IDC | Stator ribbon interconnect |
| J2–J65 | PCB spade blade terminals | 64 signal lines to plugboard |

### Plugboard Assembly additions

- New §7 Assembly BOM: 64 (per pass) / 128 (system total) panel-mount 6.35mm mono jack
  sockets; sourced eBay SaiBuy.Ltd; **no PCB RefDes**.
- §5 Physical Harness rewritten: explicit 1:1 mapping — each jack's Tip+Switch wired to
  the decode ENC board spade terminal J(N+1); Sleeve to the encode ENC board J(N+1).
- DR-PLG-01 cross-reference updated to §7.
- `Last Updated` set to 2026-05-08; `Version` left at v0.1.0 (version bumps are user-only).

### Lint

MD013 line-length violation on ENC Design_Spec.md line 265 resolved before commit.

### Todo status updates at this commit

- `enc-connector-review-pre-pcb` → ✔ DONE

## Files Changed

| File | Change |
| :--- | :--- |
| `design/Electronics/Encoder/Design_Spec.md` | J1 row removed; J2→J1, J3-J66→J2-J65; body text and quantity notes updated |
| `design/Electronics/Consolidated_BOM.md` | ENC J1 row deleted; J3-J66→J2-J65; J2→J1 |
| `design/Electronics/Stator/Board_Layout.md` | §4.3 cross-ref J2→J1 for ENC_ACTIVE_N pin |
| `design/Mechanical/Plugboard_Assembly/Design_Spec.md` | §7 Assembly BOM added; §5 harness rewritten; DR-PLG-01 updated; Last Updated 2026-05-08 |

## Key Rule Confirmed

**Metadata update rule:** Always update the `Last Updated` date when making content changes
to any design spec. Never update the `Version` field — version bumps are the user's
responsibility when the design is finalised.

## Next Work

- `review-pass-7` — Post-Pass-6 design verification review (now unblocked)
- `da-01`–`da-04` — Pre-production tasks; details in `todo-list.md`; status `blocked`
  (pending user decision on when to schedule)
