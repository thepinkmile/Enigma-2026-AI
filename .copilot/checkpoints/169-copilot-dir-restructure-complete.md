# Checkpoint 169 — Copilot Directory Restructure Complete

**Date:** 2026-05-25
**Status:** Complete
**Closes todo:** `copilot-dir-restructure`
**Unblocks todo:** `review-pass-11`

---

## Overview

Completed the `copilot-dir-restructure` workstream. The two monolithic `.copilot/` files
(`agent-directives.md` ~38 KB and `todo-list.md` ~37 KB) were split into small, focused files to
reduce context pressure and prevent directives from being silently dropped mid-session.

---

## New Structure

### `.copilot/directives/` (14 files)

| File | Contents |
| :--- | :--- |
| `index.md` | Master summary table — session loads this first |
| `primary.md` | MPN/PN protection · BOM authority · BOM content rules · banned manufacturers |
| `secondary.md` | Git staging/commit prohibition · approval rules |
| `tertiary.md` | Design Log integrity — append-only per-DEC files |
| `quaternary.md` | No permanent file deletion — use `.recycle-bin/` |
| `quinary.md` | Review sub-agent READ-ONLY constraint · deep-dive review cycle · review suppression |
| `senary.md` | Implementation authorisation — one scope at a time |
| `septenary.md` | Mandatory sub-agent prompt preamble (verbatim block) |
| `octonary.md` | Todo tracking — seed DB from `todos/todos.sql` + `todos/deps.sql` |
| `nonary.md` | KiCAD library import workflow + completeness gate |
| `component-lookup.md` | Component data lookup order; no web search |
| `document-rules.md` | Document header rules + design doc content rules |
| `character-usage.md` | Non-ASCII character approval requirement |
| `repo-state.md` | `.copilot/` git tracking · checkpoint rules · path sanitisation |

### `.copilot/todos/` (restructured)

| File | Contents |
| :--- | :--- |
| `index.md` | Summary table only — replaces todo-list.md prose + SQL |
| `todos.sql` | All todo INSERT statements (idempotent, `INSERT OR IGNORE`) |
| `deps.sql` | All dependency INSERT statements (`PRAGMA foreign_keys OFF/ON` wrapper) |

### `.copilot/SESSION_START.md`

Generic session bootstrap — single authoritative entry point for every new session:

1. Load all directives from `.copilot/directives/` → store as persistent memories
2. Seed session DB from `todos/todos.sql` + `todos/deps.sql`
3. Read `plan.md` → `handoff.md` → relevant checkpoints

---

## Files Changed

**Created:**

- `.copilot/directives/` — all 14 files (index + 13 topic files)
- `.copilot/todos/index.md`
- `.copilot/todos/todos.sql`
- `.copilot/todos/deps.sql`
- `.copilot/SESSION_START.md`

**Updated:**

- `.copilot/plan.md` — "Next Session Start Point" and standing rules reference new structure
- `.copilot/handoff.md` — session entry added
- `.github/copilot-instructions.md` — Initialization section now references `SESSION_START.md`

**Moved to `.recycle-bin/`:**

- `.copilot/agent-directives.md` (original ~38 KB monolith)
- `.copilot/todo-list.md` (original ~37 KB monolith)
- `.copilot/todos/copilot-dir-restructure.md` (detail file, now done)

---

## Key Design Decisions

- **BOM rules merged into `primary.md`** — they are an extension of PRIMARY, not a separate directive.
- **Review cycle + suppression merged into `quinary.md`** — they clarify QUINARY, not independent rules.
- **`todos/` mirrors `.copilot/checkpoints/`** — `index.md` is the lightweight summary; SQL files are
  self-contained for session DB seeding.
- **Directive files written from scratch** (not copy-edited) — eliminated repetition and
  over-qualification present in the original monolith while preserving all rules.
- **Conciseness pass performed during authoring** — critical `⚠️` blocks retained; verbose
  justification prose trimmed.

---

## State After This Checkpoint

- **Next checkpoint:** 170
- **Next DEC:** DEC-084
- **`copilot-dir-restructure`:** done ✅
- **`review-pass-11`:** pending (now unblocked)
- **Pass-10:** fully resolved; all 91 findings closed
