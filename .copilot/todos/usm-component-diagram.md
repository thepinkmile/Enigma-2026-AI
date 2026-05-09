# Todo: User Settings Module Component Diagram

**ID:** `usm-component-diagram`
**Status:** pending
**Category:** Documentation improvements
**Source:** Session decision — per-board circuit component diagrams
**Blocked by:** —

---

## Description

Add a Mermaid `block-beta` component diagram to the **top of §1** in
`design/Electronics/User_Settings_Module/Design_Spec.md`, immediately after the section
heading, before the existing overview prose and FR/DR tables.

## Target File

`design/Electronics/User_Settings_Module/Design_Spec.md`

Insert position: **top of §1 Overview**, after the heading and the opening paragraph.

## Blocks to Show

| Block | Description | Key Components |
|-------|-------------|---------------|
| `SWITCHES` | 10 SPDT toggle switches + CFG_APPLY_N momentary button | SW1–SW10, SW_APPLY |
| `EXP_U1` | MCP23017 switch input expander (reads switches + button) | U1 (MCP23017 @ 0x23) |
| `EXP_U2` | MCP23017 LED driver — Bank 1 (1 source LED + 4 config LEDs + RGB rail switches) | U2 (MCP23017 @ 0x24) |
| `EXP_U3` | MCP23017 LED driver — Bank 2 (1 source LED + 6 config LEDs + RGB rail switches) | U3 (MCP23017 @ 0x25) |
| `LED_BANK1` | Bank 1 RGB status LEDs | 5 RGB LEDs (or discrete LED bank) |
| `LED_BANK2` | Bank 2 RGB status LEDs | 7 RGB LEDs (or discrete LED bank) |
| `I2C_CONN` | I²C harness connector to Stator Board | J1 (6-pin JST PH 2.0mm → Stator J13) |

## Connections / Edges

| Edge | Label |
|------|-------|
| I2C_CONN → EXP_U1 | I²C-1 (SDA/SCL), 3V3_ENIG, GND |
| I2C_CONN → EXP_U2 | I²C-1 (shared bus) |
| I2C_CONN → EXP_U3 | I²C-1 (shared bus) |
| SWITCHES → EXP_U1 | Switch states, CFG_APPLY_N |
| EXP_U2 → LED_BANK1 | LED anode drive + RGB rail low-side |
| EXP_U3 → LED_BANK2 | LED anode drive + RGB rail low-side |

## Mermaid Type

Use `block-beta`. Suggested layout: SWITCHES on the left → EXP_U1 centre-left → I2C_CONN
on the right; EXP_U2/U3 centre with LED_BANK1/LED_BANK2 on the right.

## Notes

- Board stackup: 4-layer / 2oz (JLC04161H-7628).
- No JTAG chain on this board — all configuration is via I²C to Stator.
- I²C address assignments: U1 @ 0x23, U2 @ 0x24, U3 @ 0x25 (per Design_Spec.md overview).
  Cross-reference Controller/Design_Spec.md §4.1 for system-wide I²C address map.
- Physical location: panel-mounted, right side of enclosure top face near rotors.
- Do NOT show individual pin assignments — block-level connections only.
- Verify all refdes against `User_Settings_Module/Design_Spec.md` BOM section before implementing.
