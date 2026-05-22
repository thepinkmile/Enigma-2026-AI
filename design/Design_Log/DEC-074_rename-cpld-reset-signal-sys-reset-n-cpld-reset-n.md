## DEC-074 - Rename CPLD Reset Signal: SYS_RESET_N → CPLD_RESET_N

**Date:** 2026-05-16
**Status:** Accepted
**Author:** Izzyonstage & GitHub Copilot
**Amends:** DEC-031 (historical migration note only; DEC-031 content unchanged)

### Decision

The active-low CPLD reset signal previously named SYS_RESET_N is renamed to CPLD_RESET_N across all design documentation.

### Rationale

The name SYS_RESET_N implied a system-wide reset capability. In practice the signal:

- Is driven exclusively by Stator U7 (MCP23017) GPA[7]
- Resets only the Stator CPLD (EPM570T100I5N U1) via AND gate U3 combined with CFG_APPLY_N
- Is distributed to Rotor, Encoder, and Reflector boards only as a CPLD DEV_CLR_N input
- Does **not** reset the CM5, any MCP23017 expander IC, the FT232H, or any other system IC
- Is not valid until after CM5 boot (driven from I²C-controlled expander U7)

The misleading name caused a review finding (Pass 10) suggesting USM MCP23017 /RESET pins be connected to this signal - which would have been incorrect and was explicitly rejected (DR-USM-13,
DR-STA-12). The correct approach (power-gated 3V3_ENIG pull-ups) was already established on both the Stator and USM boards.

CPLD_RESET_N accurately scopes the signal to the Stator CPLD reset path only.

### Scope of Rename

All references in active design documentation updated. Historical DEC entries referencing the old name are preserved unchanged (DEC-031, DEC-032, DEC-033, DEC-053, DEC-059).

### Files Changed

- design/Electronics/Stator/Design_Spec.md - all signal table entries and silicon notes
- design/Electronics/Stator/Board_Layout.md - connector pin tables, routing notes
- design/Electronics/Controller/Design_Spec.md - I²C address table U7 description
- design/Electronics/Encoder/Design_Spec.md - block diagram, pull-up note
- design/Electronics/Encoder/Board_Layout.md - J1 pin 18, IC pin table
- design/Electronics/Extension/Design_Spec.md - block diagram, pin description, ESD table
- design/Electronics/Extension/Board_Layout.md - connector table, trace width table
- design/Electronics/Reflector/Design_Spec.md - block diagram, connector pin table, ESD notes
- design/Electronics/Reflector/Board_Layout.md - J1 pin 15, trace width table
- design/Electronics/Rotor/Design_Spec.md - JTAG pin tables, connector tables, ESD tables
- design/Electronics/Rotor/Board_Layout.md - IC pin table, trace width table
- design/Electronics/JTAG_Module/Design_Spec.md - TRST/reset signal note
- design/Electronics/JTAG_Module/JTAG_Integrity.md - signal integrity table entries
- design/Electronics/User_Settings_Module/Design_Spec.md - DR-USM-13
- design/Electronics/Actuation_Module/Design_Spec.md - reset pin note (clarifying CPLD_RESET_N not connected to STM32 NRST)
- design/Electronics/Boards_Overview.md - I²C address map entry
- design/Electronics/Electrical_Design.md - I²C address table
- design/Electronics/System_Architecture.md - pull-up table, I²C map
- design/Software/Linux_OS/Power_Management.md - U7 initialisation sequence note
