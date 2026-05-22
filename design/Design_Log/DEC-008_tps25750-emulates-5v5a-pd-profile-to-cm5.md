## DEC-008 - TPS25750 Emulates 5V/5A PD Profile to CM5

> ⚠️ **Superseded by DEC-012** - TPS25750 replaced with TPS25751DREFR. See DEC-012.

- **Status:** Superseded by DEC-012
- **Date:** 2025
- **Category:** Electrical
- **Area:** CM5 USB-C PD emulator (TPS25750)

### Decision

The TPS25750 PD emulator advertises a **5V/5A** profile to the CM5 internal USB-C port.

### Rationale

- The CM5 Linux OS will generate a "low power" warning if PD negotiation does not complete at or above 5V/5A (25W).
- 5V/5A is the minimum advertisement to suppress this warning and allow unrestricted CPU/GPU boost operation.
