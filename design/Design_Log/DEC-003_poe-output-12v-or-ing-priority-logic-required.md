## DEC-003 - PoE Output 12V; OR-ing Priority Logic Required

- **Status:** Decided
- **Date:** 2025
- **Category:** Electrical
- **Area:** Power Module PoE output, OR-ing diode (LM74700-Q1), eFuse input

### Decision

PoE outputs 12V (not 15V) into the OR-ing stage. Because 12V < 15V USB-C input, passive OR-ing would always prefer USB-C and ignore PoE. Active enable logic is implemented: the TPS2372-4 `/PG` signal
drives the LM74700-Q1 gate control low when PoE is live, disabling the USB-C path.

### Rationale

- PoE is the primary field power source when no USB-C adapter is connected. It must not be silently overridden by USB-C passthrough.
- TPS2372-4 `/PG` (power good, active low) is a clean indicator of a live 802.3bt PoE session.
- LM74700-Q1 already provides the USB-C ideal diode function; gating its enable is a minimal-change approach.

### Constraints

- PoE UVLO: 11V. eFuse UVLO: 11V. No margin at UVLO floor - PoE cable must be within 1V drop budget.
- eFuse ILIM utilisation at 12V worst case: 4.67A / 7A = **66.7%** ✔ (within 75% derating target).
