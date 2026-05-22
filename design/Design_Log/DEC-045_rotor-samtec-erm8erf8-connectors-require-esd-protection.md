## DEC-045 - Rotor Samtec ERM8/ERF8 Connectors Require ESD Protection

- **Status:** Decided
- **Date:** 2026-04-28
- **Category:** Electrical / ESD Protection
- **Area:** Rotor Board, ERM8/ERF8 BtB connectors
- **Author:** Izzyonstage & GitHub Copilot

### Summary

The Samtec ERM8/ERF8 board-to-board connectors on the Rotor Boards are designated as
requiring TVS/ESD protection, as an exception to Global_Routing_Spec.md §9, which otherwise
exempts internal BtB connectors from ESD protection requirements.

### Problem

Global_Routing_Spec.md §9 exempts Samtec ERM8/ERF8 BtB connectors from ESD protection on the
basis that they are internal board-to-board connectors. However, the Rotor Boards are hot-swappable
by design: individual rotors are inserted and removed from the live stack without tools. This makes
the ERM8/ERF8 mating faces accessible during servicing, exposing them to ESD events from operator
handling.

The Samtec connectors were originally specified for the PM/Stator interconnect (an internal,
non-hot-swappable path) - this was incorrect. They are now correctly used for rotor external
connections (between individually removable/serviceable rotor modules).

### Decision

Add TVS/ESD protection to all Samtec ERM8/ERF8 connector interfaces on the Rotor Board.
Update Global_Routing_Spec.md §9 with a servicing-access exception clause covering hot-swappable
connector families.

### Rationale

- Rotors are explicitly designed to be hot-swappable (Samtec ERM8/ERF8 rated for high mating cycles - §2.3).
- ESD events at the mating face during live insertion are a realistic threat to CPLD, FDC2114, and JTAG chain integrity.
- The relevant boundary for ESD protection is "accessible during servicing" not merely "external to the enclosure at all times."
- This is consistent with the §9 principle extended to servicing access rather than just permanent physical exposure.

### Alternatives Considered

| Alternative | Reason rejected |
| :--- | :--- |
| No ESD protection (rely on enclosure shielding) | Enclosure is open during rotor swap; ESD from operator handling is a real threat |
| Per-rotor deviation note only (no §9 update) | Modifying §9 is cleaner and prevents future designs from missing the same requirement |

### Impact

- `design/Standards/Global_Routing_Spec.md §9`: Added hot-swappable/service-accessible connector clause.
- `design/Electronics/Rotor/Design_Spec.md §6`: ESD arrays documented. Selected device: TPD4E05U06QDQARQ1 (U5-U12);
  U5-U8 protect Board A connectors J1 and J3; U9-U12 protect Board B connectors J4 and J6. 8 per rotor pair x 30 = 240 system total.
  JTAG signals corrected: J1 Board A = TDI/TMS/TCK (3 lines, 1 spare); J4 Board B = TDO/TMS/TCK (3 lines, 1 spare); nTRST not routed.
  Encoder signals corrected: J3/J6 carry ENC_IN[5:0] + ENC_OUT[5:0] (12 lines) - phantom signals ENC_ACTIVE_N and ENC_CLK removed.
- `design/Electronics/Consolidated_BOM.md`: TPD4E05U06QDQARQ1 row updated - ROT (x1) = 8, ROT Total (x30) = 240, System Total = 244.

### Cross-ref

`design/Standards/Global_Routing_Spec.md §9`,
`design/Electronics/Rotor/Design_Spec.md §6`.
