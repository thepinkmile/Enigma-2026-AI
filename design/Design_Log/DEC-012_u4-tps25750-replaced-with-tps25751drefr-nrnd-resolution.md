## DEC-012 - U4 TPS25750 Replaced with TPS25751DREFR (NRND Resolution)

- **Status:** ✔ RESOLVED
- **Date:** 2026-04-03
- **Category:** Electrical
- **Area:** Power Module U4, schematic, PCB footprint

### Decision

Replace **TPS25750** (NRND - Not Recommended for New Designs) with **TPS25751DREFR** (PD3.1 certified DRP controller, WQFN-38 6x4mm).

### Rationale

- PD emulation for U4 is required: the Raspberry Pi CM5 must negotiate a 5V/5A (25W) contract from the USB-C PD source to prevent the OS from issuing under-voltage warnings and throttling the system.
- The TPS25751D variant includes the integrated 20V/5A bi-directional power path and a 5V/3A source switch in one package - appropriate for DRP operation that can advertise and deliver the 5V/5A

  profile to the CM5.

- TPS25751 is USB-IF PD3.1 certified (TID#10306); TPS25750 was PD2.0 only and is NRND.
- STUSB4500 (U5) handles the USB-C sink path; TPS25751 (U4) handles the source/emulation path. These are separate and complementary roles.

### Impact

- **Package**: TPS25750 was QFN-28; TPS25751DREFR is WQFN-38 6x4mm. KiCad symbol and footprint to be created when schematic capture begins.
- Mouser: `595-TPS25751DREFR`; DigiKey: `296-TPS25751DREFRCT-ND`; JLCPCB: `C30169739`.
