## DEC-051 - Settings Board Renamed to User Settings Module (Board Code SBD → USM)

- **Status:** Active
- **Date:** 2026-05-02
- **Category:** Architecture
- **Area:** Settings Board / User Settings Module

### Decision

The `Settings Board` is renamed to `User Settings Module` throughout all active design
documentation, the consolidated BOM, and all mechanical and electrical cross-references.
The board code changes from `SBD` to `USM`. Historical decision log entries and checkpoint
files that use the name `Settings Board` are retained as-is; this entry supersedes the
naming used in those records.

### Rationale

The original name "Settings Board" described the hardware function but lacked the
module-level naming convention applied to all other boards in the system (e.g., Power
Module, Actuation Module). Aligning to the module naming scheme improves consistency
across design documents, BOM references, and future PCB silkscreen labelling, and avoids
ambiguity with the term "settings" as used in the GUI application.

### Alternatives Considered

- Retain "Settings Board" - rejected: inconsistent with module naming convention applied
  to all other subsystems.
- "Input Module" or "Panel Module" - considered but rejected: "User Settings Module" more
  precisely describes the function (user-facing configuration controls).

### Superseded Naming

The following historical design log entries use the old name "Settings Board". They are
retained as-is as a historical record; their naming is superseded by this decision:

- **DEC-032** - *Settings Board: Panel-Mount Configuration Controls with CM5 Override* -
  all "Settings Board" references in this entry now refer to the User Settings Module.
- **DEC-034** - *Switch Hardware Refresh: Settings Board Toggle + Discrete RGB LED,
  Ruggedized PM SW1* - all "Settings Board" references in this entry now refer to the
  User Settings Module.
- Other prior DEC entries and checkpoint files that mention "Settings Board" in prose or
  board-area fields retain their original wording as historical records.

### Impact

- `design/Electronics/Settings_Board/` directory renamed to
  `design/Electronics/User_Settings_Module/` (git history preserved via `git mv`).
- `design/Electronics/User_Settings_Module/Design_Spec.md` - title and all prose updated.
- `design/Electronics/User_Settings_Module/Board_Layout.md` - title and all prose updated.
- `design/Electronics/Consolidated_BOM.md` - board code `SBD` → `USM`; column header
  `SBD Qty` → `USM Qty`; all 18 `SBD:` RefDes prefixes updated to `USM:`.
- `design/Electronics/all_boards_bom.json` - all `"board": "Settings Board"` entries updated.
- `design/Electronics/Boards_Overview.md`, `Electrical_Design.md`, `System_Architecture.md`,
  `Power_Budgets.md`, `Controller/Design_Spec.md`, `Power_Module/Design_Spec.md`,
  `Reflector/Design_Spec.md`, `Stator/Design_Spec.md`, `Stator/Board_Layout.md` - prose
  and cross-references updated.
- `design/Mechanical/Complete_System_Assembly/Design_Spec.md`,
  `design/Mechanical/Main_Enclosure/Design_Spec.md` - prose references updated.
