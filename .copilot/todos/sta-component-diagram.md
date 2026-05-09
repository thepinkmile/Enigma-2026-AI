# Todo: Stator Board Component Diagram

**ID:** `sta-component-diagram`
**Status:** pending
**Category:** Documentation improvements
**Source:** Session decision — per-board circuit component diagrams
**Blocked by:** —

---

## Description

Add a Mermaid `block-beta` component diagram to the **top of §1** in
`design/Electronics/Stator/Design_Spec.md`, immediately after the section heading, before
the existing prose and FR/DR tables.

## Target File

`design/Electronics/Stator/Design_Spec.md`

Insert position: **top of §1 Overview**, after the heading and introductory sentence.

## Blocks to Show

| Block | Description | Key Components |
|-------|-------------|---------------|
| `CPLD` | Stator CPLD — routing matrix + reflector map registers | U1 (EPM570T100I5N TQFP-100) |
| `PWR_MON` | Power telemetry (3V3_ENIG rail) | U2 (INA219AIDR @ 0x45), R1 (KRL 10mΩ shunt) |
| `EXP_U6` | MCP23017 GPIO expander — keyboard inject / HID activity | U6 (MCP23017 @ address per CTL Design_Spec §4.1) |
| `EXP_U7` | MCP23017 GPIO expander — ENC bus monitoring / SYS_RESET_N | U7 (MCP23017) |
| `EXP_U8` | MCP23017 GPIO expander — CPLD config driving (CFG_ROUTE / CFG_REFMAP) | U8 (MCP23017) |
| `ROTOR_SLOTS` | 30 rotor BtB connector slots (ERF8) | J1/J2/J3 (per slot × 30) |
| `ENC_PORTS` | 6 Encoder IDC ports (3 banks of 2) | J4/J5 (Bank1 KBD/LBD), J6/J7 (Bank2 PLG_PASS1), J8/J9 (Bank3 PLG_PASS2) |
| `USM_PORT` | User Settings Module I²C connector | J13 (6-pin JST PH 2.0mm) |
| `REF_EXT_PORT` | Reflector / Extension service port | J10 (Adam Tech 2BHR-30-VUA 30-pin) |
| `CTL_DOCK` | Controller dock (Link-Beta) | J11 (power dock), J12 (JTAG/I2C logic dock) |
| `ESD_ARRAYS` | ESD protection on rotor-facing BtB connectors | U9–U12 (TPD4E05U06QDQARQ1) |

## Connections / Edges

| Edge | Label |
|------|-------|
| CTL_DOCK → CPLD | JTAG chain, I²C-1 (J12) |
| CTL_DOCK → ROTOR_SLOTS | 3V3_ENIG, 5V_MAIN (J11) |
| CPLD → ROTOR_SLOTS | ENC_IN/ENC_OUT, TTD |
| CPLD → REF_EXT_PORT | TTD_RETURN, ENC bus (J10) |
| CPLD → EXP_U8 | CFG_ROUTE, CFG_REFMAP, CFG_APPLY_N |
| EXP_U6 → CPLD | CM5_KEY_DATA, KEY_CM5_ACTIVE |
| EXP_U7 → CPLD | SYS_RESET_N, ENC_ACTIVE_N |
| ENC_PORTS → CPLD | ENC_DATA[5:0], ENC_ACTIVE_N |
| USM_PORT → EXP_U6 | I²C-1 (shares Stator bus) |
| PWR_MON → CTL_DOCK | I²C telemetry (J12) |
| ESD_ARRAYS → ROTOR_SLOTS | ESD clamping on J1/J3 |

## Mermaid Type

Use `block-beta`. Suggested layout: CTL_DOCK on the left → CPLD centre → ROTOR_SLOTS on
the right; encoder ports on the bottom-left; USM and REF_EXT ports on the bottom.

## Notes

- Board stackup: 4-layer / 2oz (JLC04161H-7628).
- I²C address assignments are owned by `Controller/Design_Spec.md §4.1` — reference there.
- Do NOT show individual pin assignments — block-level connections only.
- Verify all refdes against `Stator/Design_Spec.md` BOM section before implementing.
