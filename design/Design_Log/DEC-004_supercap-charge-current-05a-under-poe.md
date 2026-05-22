## DEC-004 - Supercap Charge Current 0.5A Under PoE

- **Status:** Superseded by DEC-029 (cell specification updated; 0.5A charge current constraint retained)
- **Date:** 2025
- **Category:** Electrical
- **Area:** LTC3350 supercap charger, PoE power budget

### Decision

When running on PoE (802.3bt Type 4, 72W budget), the supercap charge current is reduced to **0.5A** (vs. up to 2A on USB-C/Battery).
This limits peak PoE utilisation to 73.9% (53.2W / 72W) - within the 75% design rule ✔ (see Certification_Evidence §3.5).

### Rationale

- Full 2A supercap charging on PoE would push utilisation to ~98%, leaving <2W margin for transient loads.
- 0.5A charge current charges the **8x 25F** supercap bank (2S4P, 50F total - Abracon ADCR-T02R7SA256MB) in approximately 9 minutes from depleted.
- Normal system usage is expected to exceed 30-45 minutes per session (startup + configuration + use), making a 2-minute charge time acceptable.
- This limitation should be documented in the User Manual with guidance that maximum system load is not recommended during the initial PoE power-up window.

### Constraints

- Steady-state PoE load (after caps charged): 50.3W / 72W = **69.9%** utilisation ✔
