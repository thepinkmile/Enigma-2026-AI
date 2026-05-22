## DEC-042 - Encoder Port Pin 8 Carries HID-Local `ENC_ACTIVE_N`

- **Status:** Decided
- **Date:** 2026-04-26
- **Category:** Electrical / Interface architecture
- **Area:** Stator ↔ Encoder connector contract, HID source selection, lightboard blanking
- **Author:** Izzyonstage & GitHub Copilot

### Summary

Revise the 20-pin Stator ↔ Encoder connector so **pin 8** carries a generic active-low
`ENC_ACTIVE_N` sideband. The signal is used only on the HID bank:

- `J4` / `KBD_ENC` drives keyboard activity into the Stator
- the Stator source-select path chooses between physical `ENC_ACTIVE_KBD_N` and
  `CM5_KEY_ACTIVE_N`
- `J5` / `LBD_DEC` receives the selected `ENC_ACTIVE_LBD_N` so the lightboard can blank when idle

The signal is **not** propagated through the plugboard, rotor, reflector, or extension interfaces.

### Problem

The 6-bit `ENC_DATA[5:0]` path uses the entire 64-code space, so there is no spare "idle" code that
cleanly distinguishes "no key is currently active" from "a valid key code is present." Without a
separate activity indication:

- `LBD_DEC` cannot reliably blank the lightboard when the keyboard is idle
- CM5 GUI / telemetry cannot observe the selected keyboard-source activity state cleanly
- physical-keyboard and CM5-virtual key injection risk diverging in behaviour if only the data bus is
  muxed

### Decision

1. **Pin 8 on the generic 20-pin Encoder connector is reassigned to `ENC_ACTIVE_N`.**
   - Pins 2-7 remain `ENC_DATA[5:0]`.
   - Pins 8-18 shift by one position relative to the previous shield/JTAG allocation so
     `SYS_RESET_N` moves to pin 18.

2. **`ENC_ACTIVE_N` is active-low and defaults HIGH / inactive.**
   - HIGH = idle / no active HID event
   - LOW = active HID event present
   - Unused roles shall leave the signal HIGH via the MAX II weak pull-up behaviour or an equivalent
     schematic bias method.

3. **The signal is HID-local, not cipher-path-global.**
   - `KBD_ENC` drives `ENC_ACTIVE_N` to indicate a debounced keypress is active.
   - `LBD_DEC` consumes `ENC_ACTIVE_N` and must blank all outputs when the signal is HIGH.
   - Plugboard encoder / decoder roles do not use the signal in the active design and should hold or
     treat it as inactive.

4. **Physical and CM5 virtual keyboard sources must stay aligned.**
   - The Stator keyboard-source mux path must switch both the 6-bit source bus and the active-low
     activity sideband together.
   - The selected activity state must be monitored on the Stator for GUI / telemetry use.

### Rationale

- Preserves the full 64-code space without sacrificing any character value to represent idle.
- Gives the lightboard an explicit blanking control tied to real key activity.
- Keeps the extra signal local to the HID bank instead of widening the larger rotor / reflector /
  plugboard interface contract.
- Reuses spare mux and GPIO capacity already present on the Stator rather than introducing new active
  parts.

### Impact

- Update `design/Electronics/Stator/Board_Layout.md` and `design/Electronics/Stator/Design_Spec.md`
  to revise the 20-pin port pin table and document the HID-local source-select / monitoring flow.
- Update `design/Electronics/Encoder/Design_Spec.md` and
  `design/Electronics/Encoder/Board_Layout.md` to add `ENC_ACTIVE_N` to the generic module
  interface.
- Update `design/Software/CPLD_Logic/Encoder_Logic.md` so `KBD_ENC` and `LBD_DEC` define the
  required `ENC_ACTIVE_N` behaviour.

### Cross-ref

DEC-041, `design/Electronics/Stator/Design_Spec.md`,
`design/Electronics/Stator/Board_Layout.md`,
`design/Electronics/Encoder/Design_Spec.md`,
`design/Electronics/Encoder/Board_Layout.md`,
`design/Software/CPLD_Logic/Encoder_Logic.md`.
