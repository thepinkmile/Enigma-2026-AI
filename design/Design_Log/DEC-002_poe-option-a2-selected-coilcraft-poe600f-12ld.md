## DEC-002 - PoE Option A2 Selected: Coilcraft POE600F-12LD

- **Status:** Decided
- **Date:** 2025
- **Category:** Electrical
- **Area:** Power Module PoE subsystem, T2 transformer, TPS23730 feedback network

### Decision

The PoE transformer T2 uses a **Coilcraft POE600F-12LD** off-the-shelf ACF transformer (12V output, 60W, 200kHz, ≥1500Vrms isolation, SMT package). The remainder of the PoE chain uses TPS2372-4
(802.3bt Type 4 PD interface) and TPS23730 (ACF controller), with TPS23730 feedback resistors adjusted for the 12V output.

### Rationale

- Replaces a custom-wound transformer design (Option A: 15V, 8-16 week lead time, ~£35-46 BOM) with a catalogue part available from Coilcraft Direct.
- Off-the-shelf: **£3.54 qty-1, ~£1.86 volume**, in stock. Lead time: days not weeks.
- Same ACF topology as the custom design - only feedback resistors change. No PCB layout changes to high-current paths.
- 12V output falls within the TPS25980 eFuse UVLO/OVLO window (11V - 16.9V) with no additional buck stage needed.

### Alternatives Considered

- **Option A (Custom T2, 15V):** Higher voltage headroom. Rejected: custom winding, long lead time, cost.
- **Option C (Silvertel Ag59812-LPB integrated module):** Higher integration, 95% efficiency, ~£19-27. Rejected: higher cost, fixed form factor, less flexibility for thermal management, vendor

  lock-in.

- **Kinetic Technologies KPM5912:** 85W, 93% efficiency. Rejected: not stocked by any UK/EU distributor.

### Key Parameters

| Parameter | Value |
| --- | --- |
| Part | Coilcraft POE600F-12LD |
| Output | 12V nominal |
| Power | 60W (Type 4 PD, 72W class) |
| Isolation | ≥1500Vrms |
| Topology | Active Clamp Flyback (ACF) |
| Package | SMT |
| Price (qty-1) | ~£3.54 |
