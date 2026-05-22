## DEC-024 - JDB is Complete JTAG Master; Controller JTAG Lines Are Pass-Through

- **Status:** Decided
- **Date:** 2026-04-06
- **Category:** Electrical
- **Area:** JTAG Architecture - Controller and JTAG Daughterboard

### Decision

The JTAG Daughterboard (JDB) is the complete JTAG master. The SN74LVC2G125DCUR dual-channel
buffer (U5) for TCK and TMS, and all 33 Ω series damping resistors (R6 TCK after U5, R7 TMS after
U5, R8 TDI direct from FT232H) are located on the JDB, before the J2 JTAG header. The Controller
board routes JTAG lines (TCK, TMS, TDI, TTD_RETURN, VREF) as pass-through from the JDB hat-header
to the LINK-BETA BtB connector without any active components.

LINK-BETA is a direct Board-to-Board connector (no cable). Therefore 33 Ω series damping (matched
to 50 Ω PCB trace impedance) applies throughout - not the 75 Ω cable-driving resistors specified
for ribbon cable connections. See DEC-016 for the full 75 Ω / 33 Ω rationale.

### Rationale

- **Simpler Controller BOM:** Removing U5, R4, R5, R6 from the Controller reduces complexity and
  potential assembly errors on the main board.
- **Cohesive JTAG subsystem:** All JTAG active components and termination are co-located on the JDB,
  which is the natural owner of the JTAG function.
- **BtB confirmation:** LINK-BETA is a Samtec ERF8-020 / ERM8-020 direct board-to-board stack (no
  ribbon cable). The 33 Ω source termination after U5 is the correct value for 50 Ω PCB traces.

### Impact

- `Controller/Design_Spec.md`: U5 removed from BOM; R4, R5, R6 removed; §3 updated to reflect
  pass-through routing; DR-CTL-05 updated; FR-CTL-04 reference to U5 removed.
- `JTAG_Daughterboard/Design_Spec.md`: U5 added to BOM; R6, R7, R8 (33 Ω 0402) added.
- `Electronics/Consolidated_BOM.md`: SN74LVC2G125DCUR moved from CTL column to JDB column;
  33 Ω 0402 count increased in JDB; 33 Ω 0603 row removed from CTL.
- `Electronics/Investigations/JTAG_Integrity.md`: §7.4 and §8 updated to reflect JDB location.
- `Design_Log.md DEC-016`: Update note added.
