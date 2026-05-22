## DEC-035 - HID Keyboard and Lightboard Use a 40-Position QWERTY-Derived Layout for the 64-Character Code Space

- **Status:** Decided
- **Date:** 2026-04-17
- **Category:** HMI / Mechanical interface / HID logic
- **Area:** HID Assembly; Encoder Board; Rotor actuation interface
- **Author:** Izzyonstage & GitHub Copilot

### Summary

Freeze the HID operator interface as a **40-position physical layout** rather than a 64-key physical
array. The printable positions are `[a-z0-9+=]`, with **Left Shift** and **Right Shift** on the
bottom row to access uppercase alphabetic codes. The machine still retains its full 64-character
logical alphabet.

### Problem

Older docs had drifted toward describing the HID assembly as a literal 64-key keyboard, which no
longer matched the intended operator experience. That made the purchased keyboard-switch quantity,
mechanical lever count, and Encoder input mapping ambiguous, and risked re-introducing separate
uppercase-only key positions that were never part of the intended user-facing layout.

### Decision

1. **Physical keyboard layout:** Use **40 total switch positions** in the HID keyboard.
   - 26 lowercase alphabetic keycaps: `a-z`
   - 10 numeric keycaps: `0-9`
   - 2 symbol keycaps: `+` and `=`
   - 2 modifier keycaps: **Left Shift** and **Right Shift**
2. **Logical 64-character repertoire:** Preserve the full 64-character code space in Encoder logic.
   - Unshifted alphabetic keys emit `a-z`
   - Shifted alphabetic keys emit `A-Z`
   - Digits and `+` / `=` are unchanged by Shift
   - Therefore the HID path still covers 26 lowercase + 26 uppercase + 10 digits + 2 symbols = 64
     unique character codes
3. **Physical lightboard layout:** Mirror the same QWERTY-derived printable positions on the
   lightboard instead of introducing dedicated uppercase-only legends or lamp locations.
4. **Mechanical interface:** The rotor actuation mechanism shall therefore be designed around
   **40 physical key levers**, not 64.

### Rationale

- This matches the intended operator experience of a keyboard-like panel instead of an abstract
  64-button matrix.
- It preserves the full 64-character cipher alphabet without wasting front-panel area on
  duplicated uppercase-only key positions.
- It aligns the purchased custom keyboard switch count and the HID mechanical packaging with a more
  realistic enclosure layout.

### Impact

- **HID Assembly Design_Spec:** layout, key count, and purchased switch definition fixed at 40
  positions
- **Encoder Design_Spec:** HID mapping clarified as 40 physical inputs projected into a 64-code
  logical space
- **Rotor Actuation Assembly:** lever count reduced from 64 to 40
- **Consolidated BOM / component tracking:** keyboard switch quantity updated to 40 and tied to the
  pseudo datasheet for the purchased marketplace part
