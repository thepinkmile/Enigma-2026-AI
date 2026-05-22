## DEC-009 - Legacy Controller Probe-Access Pin 14 Reassigned to SW_LED_CTRL

- **Status:** Decided
- **Date:** 2025 (GND); superseded by final design (SW_LED_CTRL)
- **Category:** Electrical
- **Area:** Historical Controller bring-up probe-access concept

> **Supersession note:** Historical-only. See **DEC-040** for the current rule that all Diagnostics
> Banks are removed from the active design specs and will only be reconsidered later during the
> coupon implementation review.

### Decision

The legacy Controller probe-access concept pin 14 was initially reassigned from `3V3_SYSTEM` to
**GND**, following the removal of the `3V3_SYSTEM` rail from all BtB interconnects (see DEC-001).
In the subsequent design pass that added `SW_LED_CTRL` (GPIO 20) to the Link-Alpha signal set,
pin 14 was reallocated to **SW_LED_CTRL** to expose the LED-arbitration handshake at the historical
bring-up probe point.

**Final assignment:** Legacy Controller probe-access concept pin 14 = `SW_LED_CTRL` (GPIO 20, CTRL
→ PM, HIGH = CM5 in control of SW1 RGB LED).

### Rationale

- `3V3_SYSTEM` is no longer available at the Power Module side of this debug header.
- `SW_LED_CTRL` is a useful bring-up observation point - it shows whether the CM5 has taken control
  of the RGB LED from the hardware oscillator fallback path.
- GND is freely available on pins 19-20; a redundant GND at pin 14 added no diagnostic value.
