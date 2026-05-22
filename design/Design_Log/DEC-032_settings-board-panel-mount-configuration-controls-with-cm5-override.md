## DEC-032 - Settings Board: Panel-Mount Configuration Controls with CM5 Override

- **Status:** Decided
- **Date:** 2026-04-14
- **Category:** Electrical / HMI
- **Area:** Stator Board - Configuration Interface; new Settings Board PCB
- **Author:** Izzyonstage & GitHub Copilot

### Summary

Replace the Stator Board's DIP switches (routing + reflector map) with panel-mount toggle switches
plus discrete RGB indicators on a dedicated Settings Board PCB. The Settings Board connects to the
Stator via I²C only (no parallel signal wiring). A new MCP23017 expander (U8 @ 0x22) on the
Stator Board bridges the I²C configuration data to the CPLD config input pins and issues the
Stator-only `CFG_APPLY_N` reload pulse.

### Problem

The Stator's DIP switches (SW1, SW2) are internal PCB components, requiring the enclosure to be
opened to change the routing or reflector map configuration. This is inconvenient for regular use.
Additionally, the CM5 has no way to programmatically override the configuration.

### Decision

1. Remove SW1 and SW2 from the Stator Board.
2. Add a new Settings Board PCB (panel-mount, right side of enclosure top face near rotors) with:
   - 10 panel toggle switches plus 12 discrete RGB indicators (Bank 1 = 4 config toggles + 1 source-status LED, Bank 2 = 6 config toggles + 1 source-status LED)
   - 1 momentary active-low `CFG_APPLY_N` input; a board-mounted tactile switch actuated through the enclosure is acceptable
   - U1 (MCP23017 @ 0x23): reads the Settings Board user-intent config plus `CFG_APPLY_N`
   - U2 (MCP23017 @ 0x24): drives Bank 1 LED anodes + Bank 1 colour rails
   - U3 (MCP23017 @ 0x25): drives Bank 2 LED anodes + Bank 2 colour rails
3. Add U8 (MCP23017 @ 0x22) to the Stator Board. Its outputs drive the CPLD configuration
   input pins directly (`CFG_ROUTE[3:0]` and `CFG_REFMAP[5:0]`). Pull-downs R16-R26 are retained on the CPLD
   input pins to hold safe defaults (all-zero) at power-up before CM5 initialises U8.
4. CM5 firmware (enigma daemon):
   - Reads U1 to get user-intent config state
   - Decides in software whether each bank forwards user intent or uses a CM5-defined preset
   - Drives the bank source indicators via `CFG_ROUTE_CM5_ACTIVE` / `CFG_REFMAP_CM5_ACTIVE`
     (green = user intent forwarded, red = CM5-defined)
   - After writing final config to U8, pulses `CFG_APPLY_N` (U8 GPA[4]) LOW→HIGH to
     trigger a Stator-only configuration reload
5. Physical `CFG_APPLY_N` button on Settings Board: reads via U1 GPB[7]; CM5 daemon polls
   this and triggers the same U8 write + `CFG_APPLY_N` pulse when pressed. The switch may be
   a board-mounted tactile part with a simple actuator/plunger through the enclosure rather than a
   true panel-mount pushbutton.

### LED Colour Scheme

- **Green illumination:** Bank is forwarding Settings Board user intent; illuminated bits show the active forwarded configuration.
- **Red illumination:** Bank is in CM5-defined mode; illuminated bits show the CM5-programmed configuration.
- Per-bank shared colour rail: all switches in a bank share the same colour (green or red) while individual anode control shows which bits are set.

### I²C Address Assignments (new)

| Address | Device | Location |
| :--- | :--- | :--- |
| 0x22 | MCP23017 (U8) | Stator - CPLD config output driver |
| 0x23 | MCP23017 (U1) | Settings Board - switch input reader |
| 0x24 | MCP23017 (U2) | Settings Board - Bank 1 LED anode + colour rail driver |
| 0x25 | MCP23017 (U3) | Settings Board - Bank 2 LED anode + colour rail driver |

### Rationale

- Replacing DIP switches with panel toggles makes configuration user-accessible without opening the enclosure.
- I²C-centric wiring between Settings Board and Stator keeps the cable harness minimal vs 10+
  parallel signal wires; the active harness is now a 6-wire JST PH link carrying `3V3_ENIG`,
  `5V_MAIN`, `GND`, `SDA`, `SCL`, and a dedicated LED return GND.
- Retaining R16-R26 pull-downs ensures the CPLD receives a safe all-zero default at power-up
  (no plugboard insertion, physical reflector pass-through) before the CM5 writes the desired config.
- CM5 remains the single authority arbiter, allowing GUI presets to forward or override the Settings
  Board user-intent image while still exposing that authority state through the indicators.
- RGB illumination (green/red) provides immediate visual feedback on configuration source with no
  additional UI required.

> **Supersession note:** This decision records the original Settings Board migration intent. The
> active address map and harness definition were later refined by the post-audit cleanup:
> `U1 @ 0x23`, `U2 @ 0x24`, `U3 @ 0x25`, and a 6-wire JST PH harness carrying
> `3V3_ENIG`, `5V_MAIN`, `GND`, `SDA`, `SCL`, `GND`.

### Impact

- **Stator Board:** SW1 and SW2 removed; U8 and J13 added; `CFG_APPLY_N` added to the Stator-only reset/apply path
- **New Board:** Settings Board added to system BOM
- **Firmware:** enigma daemon startup sequence must: read U1, determine final applied config,
  write U8, pulse `CFG_APPLY_N`, update U2 / U3
- **CPLD / reset path:** the Stator-only `CFG_APPLY_N` pulse is combined with `SYS_RESET_N` so the
  Stator CPLD can be reloaded without forcing a global system reset; implemented with
  `SN74LVC1G08DBVR` on the Stator
