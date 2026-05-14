# Checkpoint 158 — ENC connector review complete; review-pass-8 corrected

## Overview

Closed out `enc-connector-review-pre-pcb` and corrected the stale `review-pass-8` tracking error left by checkpoint 152's audit.

## Work Done

### review-pass-8 tracking error corrected
- Checkpoint 136 confirmed review-pass-8 was done; checkpoint 152 incorrectly reset it to pending.
- `todo-list.md` table: status `pending` → `done`, file link removed.
- `todo-list.md` SQL INSERT: `'pending'` → `'done'`.
- `.copilot/todos/review-pass-8.md` moved to `.recycle-bin/`.
- Session SQL updated: `UPDATE todos SET status = 'done' WHERE id = 'review-pass-8'`.
- `review-pass-9` unblocked (its only dep was review-pass-8).

### enc-connector-review-pre-pcb closed
Two findings investigated:

1. **J2 → J1 typo** in `design/Electronics/Encoder/Design_Spec.md` §9 (placement note):
   - "J2 kept on the service edge for direct ribbon access" → **J1** (J1 is the 20-pin IDC header; J2 is the first of the 64 spade terminals).
   - Last Updated updated: `2026-05-12` → `2026-05-14`.

2. **Bypass cap placement guidance**: GRS §3 (CPLD: 8× 100nF within 2mm per VCC pin) and GRS §3.2 (per-IC: 100nF within 1mm) already fully cover the requirement. No changes to GRS or Encoder Design_Spec needed.

### Todo housekeeping
- `enc-connector-review-pre-pcb` marked done in `todo-list.md` (table + SQL INSERT).
- `.copilot/todos/enc-connector-review-pre-pcb.md` moved to `.recycle-bin/`.
- `todo-list.md` Last Updated note appended.

## Files Updated

- `design/Electronics/Encoder/Design_Spec.md` — §9 J2→J1; Last Updated 2026-05-14
- `.copilot/todo-list.md` — review-pass-8 and enc-connector-review-pre-pcb marked done; Last Updated appended
- `.copilot/todos/review-pass-8.md` — moved to `.recycle-bin/`
- `.copilot/todos/enc-connector-review-pre-pcb.md` — moved to `.recycle-bin/`

## State After This Checkpoint

- review-pass-9: **unblocked** (next review pass)
- review-pass-10: blocked by review-pass-9
- enc-connector-review-pre-pcb: **done**
- Next DEC entry: DEC-072
- Next checkpoint: 159
