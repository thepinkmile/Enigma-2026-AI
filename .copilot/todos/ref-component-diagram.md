# Todo: Reflector Board Component Diagram

**ID:** `ref-component-diagram`
**Status:** pending
**Category:** Documentation improvements
**Source:** Session decision — per-board circuit component diagrams
**Blocked by:** —

---

## Description

Add a Mermaid `block-beta` component diagram to the **top of §1** in
`design/Electronics/Reflector/Design_Spec.md`, immediately after the section heading, before
the existing overview prose and FR/DR tables.

## Target File

`design/Electronics/Reflector/Design_Spec.md`

Insert position: **top of §1 Overview**, after the heading and before the Functional &
Design Requirements heading.

## Blocks to Show

| Block | Description | Key Components |
|-------|-------------|---------------|
| `IN_CONN` | Input BtB connectors (from Rotor 30) | J1 (ERM8-005 JTAG in), J2 (ERM8-005 Power in), J3 (ERM8-010 ENC in) |
| `ESD_J1` | ESD array on J1 (JTAG input) | U1 (TPD4E05U06QDQARQ1 — covers TCK, TMS, TTD, SYS_RESET_N) |
| `ESD_J3` | ESD arrays on J3 (ENC input) | U2–U4 (3× TPD4E05U06QDQARQ1 — covers ENC_IN[5:0] + ENC_OUT[5:0]) |
| `TTD_DAMP` | End-of-chain JTAG signal damping resistor | R1 (22Ω 0603, on TDO line) |
| `SERVICE_PORT` | Reflector → Stator service port (TTD_RETURN path) | J4 (Adam Tech 2BHR-30-VUA 30-pin 2×15) |

## Connections / Edges

| Edge | Label |
|------|-------|
| IN_CONN → ESD_J1 | TCK, TMS, TTD, SYS_RESET_N |
| IN_CONN → ESD_J3 | ENC_IN[5:0], ENC_OUT[5:0] |
| ESD_J1 → TTD_DAMP | TDO (JTAG end-of-chain turnaround) |
| TTD_DAMP → SERVICE_PORT | TTD_RETURN (J4 pin 16 → Stator J10 pin 16) |
| IN_CONN → SERVICE_PORT | 3V3_ENIG (sole power entry; J4 pins 3-4/27-28) |

## Mermaid Type

Use `block-beta`. The board is intentionally minimal (passive turnaround — no CPLD). The
diagram should clearly show the passive nature: signals enter via IN_CONN, are ESD-clamped,
and the TDO/TTD_RETURN path feeds back to the Stator via SERVICE_PORT.

Suggested layout: IN_CONN on the left → ESD blocks centre → TTD_DAMP → SERVICE_PORT on the right.

## Notes

- Board stackup: 4-layer / 2oz (JLC04161H-7628).
- **No active logic** on this board — the reflector map is owned entirely by the Stator CPLD.
  The Reflector is purely a passive electrical turnaround. Make this explicit in the diagram
  (e.g. a note block: "Passive turnaround — no CPLD").
- 5V_MAIN pins on J4 are present for cable family compatibility only; they are not connected
  on this board — reflect this in the diagram or notes.
- Do NOT show individual pin assignments — block-level connections only.
- Verify all refdes against `Reflector/Design_Spec.md` BOM section before implementing.
