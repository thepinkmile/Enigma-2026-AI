## DEC-031 - CM5 Virtual Keyboard (Key Injection) Feature Architecture

- **Status:** Decided
- **Date:** 2026-04-14
- **Category:** Electrical / Firmware
- **Area:** Stator Board - I²C Expanders, Servo, External Keyboard Source Mux
- **Author:** Izzyonstage & GitHub Copilot

### Summary

Design decision for enabling the CM5 to autonomously inject virtual keypresses into the Enigma
cipher pipeline, enabling automated rotor configuration testing and fully autonomous cipher operation.

### Problem

The Enigma machine requires a physical keypress to advance rotors and inject input into the cipher
pipeline. For autonomous CM5 operation (testing, remote cipher operation), a mechanism is needed to
inject keypresses without human intervention.

### Decision

Add three I²C expanders to the Stator board on the shared I²C-1 bus:

1. **MCP23017 @ 0x20 (U6):** 16-bit GPIO expander for ENC_IN/ENC_OUT monitoring. Replaces
   CM5 GPIO 4-15 (12 pins freed).
   - GPA[5:0] = ENC_IN[5:0] monitor (inputs)
   - GPB[5:0] = ENC_OUT[5:0] monitor (inputs)
   - GPA[6:7], GPB[6:7] = spare

2. **MCP23017 @ 0x21 (U7):** 16-bit GPIO expander for virtual key data injection, external
    keyboard-source mux control, and SYS_RESET_N (replaces CM5 GPIO 26 - 1 pin freed).
    - GPA[5:0] = CM5_KEY_DATA[5:0] (outputs - 6-bit virtual key data bus)
    - GPA[6] = KEY_CM5_ACTIVE (output - mux select: 0=physical keyboard, 1=CM5 virtual)
    - GPA[7] = SYS_RESET_N (output - system-wide CPLD reset)
    - GPB[7:0] = spare / reserved

### Rationale for MCP23017 (x2)

- 32 GPIO total provides headroom for future I/O expansion.
- SYS_RESET_N migration to expander reduces LINK-BETA pin count and frees CM5 GPIO 26.
- All keyboard-source mux and reset control signals remain co-located with the Stator CPLD.
- Only 2 wires (I²C SDA/SCL) needed on LINK-BETA instead of 13 discrete signal pins.

### External Keyboard Source Mux

- GPA[6] on U7 drives `KEY_CM5_ACTIVE` for the external keyboard-source mux at the Stator
  keyboard-source entry point.
- `KEY_CM5_ACTIVE=0`: the physical keyboard 6-bit source bus is forwarded to the encryption pipeline.
- `KEY_CM5_ACTIVE=1`: `CM5_KEY_DATA[5:0]` is forwarded instead.
- The selected implementation uses `U4` and `U5`, both `74HC157PW-Q100,118` quad 2:1 mux devices,
  to cover the 6-bit path, with both `E` pins tied to GND so the mux is always enabled while the
  board is powered.
- GPA[7] now carries `SYS_RESET_N`, fully populating the U7 GPA port and leaving U7 GPB
  completely spare / reserved for future use.

### Net Effect on LINK-BETA

- **Freed (13 pins):** ENC_IN[5:0] (x6), ENC_OUT[5:0] (x6), SYS_RESET_N (x1).
- **Freed:** pins 8 (SYS_RESET_N), 12-17 (ENC_IN[5:0]), and 19-24 (ENC_OUT[5:0]) were freed by this decision.
- **Later reuse:** DEC-036 reallocated the former monitor block into grouped LINK-BETA power rails
  (5V_MAIN, 3V3_ENIG, and GND) once the Stator-side 5V needs were formalised.
- R6 pull-up (10kΩ to 3V3_ENIG) on Stator keeps SYS_RESET_N HIGH at power-up (CPLDs out of reset).

### Net Effect on CM5 GPIO

- **Freed (13 pins):** GPIO 4-15 (ENC monitoring), GPIO 26 (SYS_RESET_N).
- No new CM5 GPIO assignments required.

### I²C Bus Address Map (no conflicts)

| Address | Device | Location |
| :--- | :--- | :--- |
| 0x09 | LTC3350 | Power Module |
| 0x0B | Smart Battery | Power Module |
| 0x20 | MCP23017 (U6) | Stator |
| 0x21 | MCP23017 (U7) | Stator |
| 0x22 | MCP23017 (U8) | Stator |
| 0x23 | MCP23017 (U1) | Settings Board |
| 0x24 | MCP23017 (U2) | Settings Board |
| 0x25 | MCP23017 (U3) | Settings Board |
| 0x28 | STUSB4500 | Power Module |
| 0x40 | INA219 (U12) | Power Module |
| 0x45 | INA219 (U2) | Stator |
