## DEC-019 - PoE Transformer Topology: ACF (Option A) Selected

- **Status:** ✔ Adopted
- **Date:** 2026-04-05
- **Category:** Electrical
- **Area:** Power Module - T2 transformer, TPS23730 operating mode, input EMI filter

### Decision

The Power Module retains the **Active Clamp Flyback (ACF)** topology with the **Coilcraft POE600F-12LD**
transformer. The TPS23730 operates in ACF mode, driving an external active clamp MOSFET complementary
to the primary switch. The Coilcraft transformer is procured order-direct from `coilcraft.com` and
supplied to JLCPCB as a consignment part.

No change is made to the T2 transformer, the TPS23730 mode configuration, or the active clamp circuit.

**Full investigation detail:** `design/Electronics/Investigations/PoE_Investigation.md`

### Rationale

A thorough search confirmed that **no ACF PoE isolation transformer for 60W / 36-57V input is stocked
by any mainstream authorised distributor** (DigiKey, Mouser, Farnell, Arrow). The Coilcraft POE600F
family was co-developed with TI specifically for the TPS23730 reference design; no competing catalogue
part exists.

The only standard-distributor alternative identified was the **Bourns PDC060-FD20A12S** - a standard
flyback transformer available from DigiKey. Switching to this part (Option B) would have required:

- Disabling TPS23730 `ACF_GD` (ACF gate drive pin)
- Removing the active clamp MOSFET and capacitor
- Adding an RCD clamp (3 SMD components)
- Verifying PSR auxiliary winding compatibility (unconfirmed)

After detailed EMI/EMC analysis, Option B was rejected on technical grounds. Key findings:

| Criterion | Option A (ACF) | Option B (Flyback) |
| :--- | :--- | :--- |
| Primary switching | ZVS - no hard dV/dt event | Hard switching - fast dV/dt |
| Drain spike at turn-off | None - energy recycled by clamp | Present - RCD clamp clips but does not eliminate |
| CM/DM conducted EMI | Low | 15-25 dB higher before input filter |
| Input EMI filter size | Smaller / fewer components | Larger / more complex |
| CISPR 32 Class B margin | Comfortable | Tight - may require design iteration |
| Efficiency | 88-92% | 85-90% |
| Extra dissipation | - | ~1-2W at full load |
| PSR aux winding verified | ✔ TI reference design | ⚠️ Unverified for Bourns PDC060 |

The Coilcraft direct-order model is accepted as a specialist procurement path, consistent with
industry practice for catalogue magnetics.

### Alternatives Considered

- **Bourns PDC060-FD20A12S (Option B - flyback PSR):** Rejected - hard-switching topology causes
  significantly higher conducted and radiated EMI, requires a larger input EMI filter, does not
  eliminate procurement complexity (shifts effort from transformer sourcing to filter design),
  and adds ~1-2W thermal load to an already thermally constrained module.
- **Wurth WE-FB range:** Rejected - entire range has a maximum input voltage of 36V (insufficient
  for PoE 36-57V input) and is keyed to Linear Technology LT-series controllers.
- **Change PoE controller ecosystem:** Not evaluated - would constitute a major redesign and is
  out of scope.
