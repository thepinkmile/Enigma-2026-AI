## DEC-006 - STUSB4500 Negotiates 15V/5A (75W)

- **Status:** Decided
- **Date:** 2025
- **Category:** Electrical
- **Area:** Power Module USB-C PD handshake (STUSB4500), USB-C adapter requirement

### Decision

The STUSB4500 standalone PD sink is programmed to negotiate **15V/5A (75W)** from the wall adapter or USB-C PD source. Earlier documentation incorrectly stated 15V/3A.

### Rationale

- 3A (45W) is insufficient for worst-case system load (CM5 at 25W + rotors + supercap charging).
- 5A (75W) provides headroom and aligns with the 75% derating target at the eFuse.
- Users must use a USB-C PD adapter rated for at least 75W (15V/5A or 20V/5A with appropriate negotiation cap).
