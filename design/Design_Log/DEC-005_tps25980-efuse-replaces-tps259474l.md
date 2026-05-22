## DEC-005 - TPS25980 eFuse Replaces TPS259474L

- **Status:** Decided
- **Date:** 2025
- **Category:** Electrical
- **Area:** Power Module eFuse (U1)

### Decision

The input eFuse uses a **TPS25980** (7A ILIM, silicon-fixed 16.9V OVLO) rather than the originally considered TPS259474L (5.5A ILIM).

### Rationale

- TPS259474L 5.5A limit is insufficient for worst-case USB-C 15V path at 75W: 75W / 15V = 5.0A + 10% derating = 5.5A - already at the device limit with no headroom.
- TPS25980 (TPS259804ONRGER) provides 7A ILIM (programmed via R3 = 210 Ω) and silicon-fixed 16.9V OVLO, which neatly caps the battery charge voltage window.

### OVLO Constraint

- eFuse OVLO is **16.9V silicon-fixed** (TPS259804ONRGER - no external programming resistor).
- BMS must be configured for **4.1V/cell maximum charge (16.4V for 4S)** to maintain a ≥0.5V margin.
- BMS configurations using 4.2V/cell (16.8V) are not compatible with this eFuse and must not be used.

### ⚠️ Variant Lock - Do NOT change this MPN

The TPS25980 family uses a digit after `TPS25980` to select the OVLO behaviour:

| Variant | OVLO | Status |
| --- | --- | --- |
| **TPS259804ONRGER** | **16.9V silicon-fixed** | ✔ **CORRECT - use this** |
| TPS259807 | No OVLO feature | ❌ WRONG - do not use |
| TPS259803 | No OVLO feature | ❌ WRONG - do not use |

This variant has been erroneously swapped to TPS259807 in previous review rounds.
The `04` digit must not be changed without explicit documented justification.
