# USM SPDT Switch Floating Pin Review

**ID:** `usm-spdt-switch-floating-review`
**Status:** pending
**Category:** Electronics
**Source:** Pass 8 review — floating throw terminal concern
**Blocked by:** —

---

## Description

Review the SPDT switch input configuration for the User Settings Module to confirm:

1. **Terminal wiring** — which of the three SPDT terminals (common / throw A / throw B) connects to each MCP23017 GPIO input pin, and which terminal connects to the pull-down rail.
2. **Pull-down vs pull-up** — verify that 10kΩ pull-downs (DR-USM-09, R1–R10) are the correct topology for the E-Switch 200MSP1T2B4M2QE SPDT latching toggle switch. Check the datasheet to confirm the switch does not present an internal connection to VCC in either position (which would create a shoot-through path with a pull-down).
3. **Floating throw** — confirm the unconnected throw terminal of the SPDT does not float in a way that causes indeterminate logic levels. If the GPIO input is connected to the common pin (centre terminal), only one throw is used; the other floats harmlessly. If an input is connected to a throw pin, the common floats when the switch moves to the other throw — this needs the pull-down to hold the GPIO at a known level.

## Context

- Switch: 10× E-Switch 200MSP1T2B4M2QE SPDT latching toggle
- GPIO expander: U1 = MCP23017T-E/SO @ 0x23
- Pin mapping:
  - GPA[0:3] → CFG_ROUTE[0:3] (SW1–SW4)
  - GPB[0:5] → CFG_REFMAP[0:5] (SW5–SW10)
- DR-USM-09 specifies 10× 10kΩ 0603 pull-down resistors (R1–R10) on all switch GPIO inputs; reads HIGH when switch is closed.
- DR-USM-08 specifies the MCP23017 GPB[0:5] pins handle the six reflector-map switches; note GPB7 is a silicon-fixed output-only pin (DEC-070) — the switch assignments already avoid GPB7.

## Notes

- Reference: `design/Electronics/User_Settings_Module/Design_Spec.md` §DR-USM-09 and U1 pin table.
- Reference: E-Switch 200MSP1T2B4M2QE datasheet for switch contact topology.
- If pull-ups are required (e.g. active-low switch), DR-USM-09 and the MCP23017 GPA/GPB pull-up enable configuration must both be updated.
