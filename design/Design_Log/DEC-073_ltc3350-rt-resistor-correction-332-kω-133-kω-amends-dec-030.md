## DEC-073 - LTC3350 RT Resistor Correction: 33.2 kΩ → 133 kΩ (Amends DEC-030)

**Date:** 2026-05-15
**Status:** Accepted
**Author:** Izzyonstage & GitHub Copilot
**Amends:** DEC-030

### Decision

R23 (LTC3350 RT frequency-setting resistor) is changed from **33.2 kΩ** to **133 kΩ** (E96 nearest value to 133.75 kΩ).
BOM part changed from ERA-2AEB3322X (33.2 kΩ, Panasonic ERA-2, 0.1%, 0402) to ERJ-PC3B1333V (133 kΩ, Panasonic ERJ-PC3, 0.1% thick-film, 0603).

### Rationale

DEC-030 stated that R23 = 33.2 kΩ sets the LTC3350 switching frequency to 400 kHz. This was an arithmetic error.

**Formula (from LTC3350 datasheet RT programming table):** SW(kHz) = 53,500 / RT(kΩ)

Verification at datasheet calibration points:

| RT (kΩ) | Calculated fSW | Datasheet typical |
| :-------- | :-------------- | :----------------- |
| 267 | 53,500 / 267 = 200 kHz | 200 kHz ✓ |
| 107 | 53,500 / 107 = 500 kHz | 500 kHz ✓ |
| 53.6 | 53,500 / 53.6 = 998 kHz | 1 MHz ✓ |

**Error in DEC-030:** 33.2 kΩ → 53,500 / 33.2 = **1,611 kHz** (61% over the rated 1 MHz maximum frequency).
Operating the LTC3350 switching converter above its rated maximum frequency is out-of-spec and risks
converter instability, elevated losses, and component damage.

**Correct calculation for 400 kHz target:**

- Required: RT = 53,500 / 400 = 133.75 kΩ
- Nearest E96 standard value: **133 kΩ**
- Actual fSW: 53,500 / 133 = **402 kHz** (within 0.5% of target) ✔
- Package/footprint: 0603 thick-film — footprint change from 0402 required.

The 400 kHz switching frequency target (≥4 switching cycles within the 10.2µs backup switchover window) is unchanged from DEC-030. Only the resistor value and MPN are corrected.

### Files Changed

- design/Electronics/Power_Module/Design_Spec.md - DR-PM-11 updated: 33.2 kΩ → 133 kΩ; formula added with calculation; BOM R23 MPN updated; Last Updated 2026-05-15
