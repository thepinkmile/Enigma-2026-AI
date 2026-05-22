## DEC-013 - L3 EMI Inductor Changed to Bourns SRP1265A-100M

- **Status:** ✔ RESOLVED
- **Date:** 2026-04-03
- **Category:** Electrical
- **Area:** Power Module L3, PCB footprint

### Decision

Replace **Wurth 7447789100** with **Bourns SRP1265A-100M** as L3 (EMI DM Pi-filter inductor).

### Rationale

- Wurth 7447789100 is not available in any public distributor catalog (not found at DigiKey, Mouser, Farnell, or on the Wurth public website). Sourcing without a Wurth rep contact is not feasible.
- Bourns SRP1265A-100M is a direct functional equivalent: 10µH, **15.5A Isat** (exceeds 14.5A target with 21% headroom), DCR=16.5mΩ max (better than the original 20mΩ spec), shielded molded SMD.
- Widely stocked: Farnell ~2,741 pcs; Mouser (`652-SRP1265A-100M`); DigiKey (`SRP1265A-100MCT-ND`).

### Impact

- ⚠️ **Package footprint change**: SRP1265A-100M is 13.5x12.5x6.2mm vs 7447789100's 12.5x12.5x6.0mm. PCB land pattern for L3 must use the Bourns 13.5x12.5mm footprint. Clearance to adjacent

  components should be checked during layout.
