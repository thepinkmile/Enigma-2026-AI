# Checkpoint 135: Mermaid diagram todos created

**Date:** 2025-07-15
**Session phase:** Mermaid diagram todo creation + registry update

---

## Overview

Created 12 detailed Mermaid diagram todo files covering: 2 system-level diagrams
(board interconnect and system configuration variants) and 10 per-board circuit
component diagrams (one per board Design_Spec.md). All todos note that diagrams
must appear at the top of §1 in their target file. Updated todo-list.md summary
table and Agent SQL block. Moved done `ascii-to-mermaid-diagrams.md` to
`.recycle-bin/todos/` per QUATERNARY DIRECTIVE.

---

## Work Done

- Moved `.copilot/todos/ascii-to-mermaid-diagrams.md` → `.recycle-bin/todos/ascii-to-mermaid-diagrams.md`
- Created 12 todo detail files in `.copilot/todos/`:
  - `board-interconnect-diagram.md` (block-beta, Boards_Overview.md §1)
  - `system-config-variants-diagrams.md` (3× flowchart TD, System_Architecture.md §1)
  - `ctl-component-diagram.md` (block-beta, Controller/Design_Spec.md §1)
  - `pm-component-diagram.md` (block-beta, Power_Module/Design_Spec.md §1)
  - `sta-component-diagram.md` (block-beta, Stator/Design_Spec.md §1)
  - `rotor-component-diagram.md` (block-beta, Rotor/Design_Spec.md §1 — Board A + B)
  - `ext-component-diagram.md` (block-beta, Extension/Design_Spec.md §1)
  - `ref-component-diagram.md` (block-beta, Reflector/Design_Spec.md §1 — passive board)
  - `enc-component-diagram.md` (block-beta, Encoder/Design_Spec.md §1 — 6-role shared)
  - `jm-component-diagram.md` (block-beta, JTAG_Module/Design_Spec.md §1)
  - `usm-component-diagram.md` (block-beta, User_Settings_Module/Design_Spec.md §1)
  - `am-component-diagram.md` (block-beta, Actuation_Module/Design_Spec.md §1)
- Updated `.copilot/todo-list.md`:
  - Summary table: fixed `ascii-to-mermaid-diagrams` link → `—` (file recycled) + added 12 new rows
  - Agent SQL: replaced closing semicolon entry with new `-- Mermaid Diagrams` block (12 inserts)
- Inserted 12 todos into session SQL (`INSERT OR IGNORE INTO todos`)

---

## Technical Decisions

- **Mermaid type per diagram:**
  - `block-beta` for all board component diagrams and board interconnect diagram
  - `flowchart TD` for system configuration variant diagrams (hierarchy/flow, not topology)
- **Placement:** all diagrams go at the **top of §1 Overview** in their target file,
  before prose and requirement tables — so it is the first thing the reader sees
- **Detail level:** block-level connections only — no individual pin assignments
- **Reflector:** clearly marked "Passive turnaround — no CPLD" in its todo notes
- **Rotor:** two-PCB assembly shown as two sub-groups (Board A + Board B) in one diagram
- **Encoder:** shared 6-role board; note "Role = programmed CPLD image" in diagram

---

## Important Files

- `.copilot/todos/board-interconnect-diagram.md`
- `.copilot/todos/system-config-variants-diagrams.md`
- `.copilot/todos/ctl-component-diagram.md`
- `.copilot/todos/pm-component-diagram.md`
- `.copilot/todos/sta-component-diagram.md`
- `.copilot/todos/rotor-component-diagram.md`
- `.copilot/todos/ext-component-diagram.md`
- `.copilot/todos/ref-component-diagram.md`
- `.copilot/todos/enc-component-diagram.md`
- `.copilot/todos/jm-component-diagram.md`
- `.copilot/todos/usm-component-diagram.md`
- `.copilot/todos/am-component-diagram.md`
- `.copilot/todo-list.md` (updated — summary table + Agent SQL)
- `.recycle-bin/todos/ascii-to-mermaid-diagrams.md` (recycled, not deleted)

---

## Next Steps

1. User reviews existing Mermaid diagrams (System_Architecture.md, Power_Module/Board_Layout.md)
2. Trigger `review-pass-8` — set status `in_progress`, begin review per `.copilot/todos/review-pass-8.md`
