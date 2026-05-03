# Enigma-NG - PoE Transformer Topology Investigation

**Date:** 2026-04-05
**Status:** ✔ Closed - Decision recorded in DEC-019
**Affects:** Power Module - T2 transformer, TPS23730 operating mode, input EMI filter

---

## 1. Background

The Power Module uses a discrete two-stage PoE architecture:

- **Stage 1 - PD Interface:** TPS2372-4 (IEEE 802.3bt Type 4, 72W class PD with external hotswap)
- **Stage 2 - DC-DC Converter:** TPS23730 ACF controller + T2 isolation transformer + synchronous rectifier

The TPS23730 supports two operating modes:

| Mode | Primary switch | Clamp | Efficiency | Thermal |
| :--- | :--- | :--- | :--- | :--- |
| **ACF (Active Clamp Flyback)** | Zero Voltage Switching (ZVS) | Active MOSFET + capacitor - energy recycled | 88-92% | Lower |
| **Flyback PSR** | Hard switching | RCD clamp - energy dissipated | 85-90% | Higher |

The original design specifies a **Coilcraft POE600F-12L** - an off-the-shelf ACF transformer
co-developed with TI for the TPS23730 reference design (12V out, 60W, 200kHz, ≥1500Vrms isolation,
SMT package). The `D` suffix seen in some references is packaging-only for pick-and-place handling.
This part is only available order-direct from Coilcraft; it is not stocked by DigiKey, Mouser, or
JLCPCB.

This investigation was opened to evaluate whether a standard-distributor alternative existed, and to
fully compare the EMI/EMC characteristics of both topologies to inform the decision.

---

## 2. Transformer Market Survey

### 2.1 Coilcraft POE600F family

All relevant variants in the POE600F product family (12L, 24L, 33L, 50L, etc.) were confirmed via
Octopart to be stocked exclusively at Coilcraft Direct or Worldway Electronics (grey market). No
authorised mainstream distributor (DigiKey, Mouser, Farnell, Arrow) stocks any member of this family.

**Why:** ACF PoE isolation transformers for 60W / 36-57V input are a niche product co-developed by
TI and Coilcraft specifically for the TPS23730 reference design. The transformer requires a primary
winding, secondary winding, PSR auxiliary winding (tuned for TPS23730 VS-pin feedback), and magnetic
parameters (Lm, Llk) optimised for ACF resonant operation at 200-250kHz. No other manufacturer has
a catalogued part meeting this specification.

### 2.2 Alternatives investigated

| Part | Manufacturer | Topology | Verdict |
| :--- | :--- | :--- | :--- |
| PDC060-FD20A12S | Bourns | Standard flyback | ✔ Available DigiKey/Arrow/Farnell - but topology mismatch (see §3) |
| WE-FB range | Wurth Elektronik | Flyback (LT-series) | ❌ Max input 36V - insufficient for PoE (36-57V required) |
| All others searched | - | - | ❌ No ACF-compatible result from DigiKey/Mouser/JLCPCB/Octopart |

The Wurth WE-FB range is keyed to Linear Technology LT-series controllers (LT3573, LT3748, etc.)
and its maximum input voltage across the entire range is 36V - making it inapplicable to PoE.

**Conclusion:** There is no ACF PoE transformer for 60W / 36-57V input available from any mainstream
authorised distributor. This is a structural market reality, not a search gap.

---

## 3. Option A - ACF Flyback (Coilcraft POE600F-12L, TPS23730 ACF mode)

### 3.1 Procurement

| Attribute | Value |
| :--- | :--- |
| Part number | Coilcraft POE600F-12L (`D` suffix = packaging only) |
| Availability | Coilcraft Direct only - `coilcraft.com` |
| Price (qty-1) | ~£3.54 |
| Price (volume) | ~£1.86 |
| Lead time | Days (in-stock) |
| Prototype path | Order direct from Coilcraft |
| Production path | Pre-order from Coilcraft; ship to JLCPCB as consignment |

### 3.2 Circuit configuration

- TPS23730 `ACF_GD` pin drives an external active clamp MOSFET (complementary to primary switch)
- Active clamp capacitor (Cclamp) stores and recycles leakage inductance energy
- Primary MOSFET turns on under Zero Voltage Switching (ZVS) conditions
- TPS23730 VS pin reads auxiliary winding for Primary-Side Regulation (PSR) output feedback
- Synchronous rectification (SR) on secondary driven by TPS23730 SR pin

### 3.3 EMI/EMC characteristics

#### Primary switching - ZVS

Before the primary MOSFET turns on each cycle, the clamp network causes the drain voltage to ring
down to near-zero (or slightly below, allowing the body diode to conduct briefly). The MOSFET turns
on into approximately 0V - **there is no hard dV/dt event on the primary drain.**

This eliminates the dominant EMI source in switched-mode converters. The drain voltage transitions
are sinusoidal (resonant LC ramp) rather than step transitions. The result:

- Differential mode (DM) conducted EMI at 200kHz and harmonics: **15-25dB lower** than equivalent
  hard-switching flyback (before any input filter).
- Common mode (CM) conducted EMI: The fast drain dV/dt couples through transformer interwinding
  capacitance (Cwinding) to the secondary/chassis. ZVS removes this coupling path.
- Radiated EMI from the power stage: Drain traces are not driven with fast edges - broadband
  radiation from the PoE circuitry area is dramatically reduced.

#### Drain spike - eliminated

In standard flyback, turn-off creates a drain voltage spike: Vin_max + Vreflected + Vleakage_spike
(can reach 150-180V at 57V input before RCD clamp conducts). In ACF, the leakage energy flows into
the clamp capacitor and is recycled. **There is no spike, no RCD clamp event, and no associated
broadband noise injection.**

#### Input EMI filter

Because both DM and CM emissions are lower at source, the input EMI filter (between PoE PD interface
and DC-DC converter) can be smaller:

- Fewer filter stages required to meet CISPR 32 Class B
- Lower inductance values and fewer capacitors
- Saves PCB area and BOM cost
- Easier to co-optimise filter characteristics for both EMI attenuation and IEEE 802.3bt MDI
  port impedance requirements (which impose their own constraints on the filter impedance)

#### Secondary side

TPS23730 synchronous rectification (supported in ACF mode) eliminates the secondary rectifier
reverse recovery current transient - a significant secondary-side EMI source in diode-rectified
designs.

#### Downstream rail cleanliness

Lower conducted noise at the converter input → less transformer coupling of switching artefacts
to the output → cleaner 5V and 3V3 rails feeding the CM5, CPLDs, and USB JTAG chip downstream.

### 3.4 Known EMI risks

| Risk | Mitigation |
| :--- | :--- |
| Clamp LC resonance (Cclamp + Llk tank) - can create MHz-range artefacts if clamp cap poorly chosen | Select Cclamp per TPS23730 reference design; verify clamp frequency in simulation |
| ZVS lost at light load (below minimum load threshold) - partial hard switching at idle | TPS23730 burst mode reduces switching at light load; acceptable for standby conditions |
| Two switching nodes (primary + clamp MOSFET) - both require tight PCB layout | Keep both MOSFETs close to transformer primary with short high-current loops |

### 3.5 Non-EMI properties

| Property | Value |
| :--- | :--- |
| Efficiency | 88-92% at full PoE load |
| Transformer losses (T2) | ~5.1W typical / 5.7W max at 51-57W PoE load |
| Board total dissipation | ~14.8W typical / 19.5W max |
| Primary MOSFET Vds rating | Controlled drain voltage - lower rating margin required |
| BOM change vs flyback | +1 clamp MOSFET, +1 clamp capacitor vs RCD (net neutral on count) |

---

## 4. Option B - Standard Flyback PSR (Bourns PDC060-FD20A12S, TPS23730 flyback mode)

### 4.1 Procurement

| Attribute | Value |
| :--- | :--- |
| Part number | Bourns PDC060-FD20A12S |
| Availability | DigiKey (`118-PDC060-FD20A12S-ND`), Arrow, Farnell |
| DigiKey stock | ~138 units (at time of survey) |
| Price | ~$5.27-$6.54 per unit |
| Lead time | Standard stock |
| Prototype path | Direct from DigiKey/Arrow/Farnell |
| Production path | Standard ordering - no consignment required |

### 4.2 Circuit configuration changes vs Option A

- TPS23730 `ACF_GD` pin tied to GND - disables active clamp gate drive
- Active clamp MOSFET removed from BOM
- Active clamp capacitor removed from BOM
- RCD clamp added to primary drain: clamp diode (D) + clamp capacitor (C) + clamp resistor (R)
  - 3 new SMD components
- Net BOM change: -2 components, +3 components = +1 component vs Option A
- Primary MOSFET Vds rating must be reviewed - drain spike voltage increases without active clamp
- Auxiliary winding PSR compatibility with TPS23730 VS pin must be verified against Bourns PDC060
  datasheet (turns ratio and voltage compliance)

### 4.3 EMI/EMC characteristics

#### Primary switching - hard switching

In a standard flyback, the primary MOSFET turns on hard - the drain steps from
(Vin + Vspike_residual) down to near-zero in nanoseconds. This is a fast dV/dt event generating:

- **DM conducted EMI:** Fast current edge charges input filter capacitors - a current pulse
  propagates back to the PoE port every switching cycle. DM emissions at 200kHz and harmonics
  are 15-25dB higher than ACF (before input filter).
- **CM conducted EMI:** The fast drain dV/dt couples through transformer interwinding capacitance
  (Cwinding) to the secondary and chassis, injecting CM current into the PoE port. CM emissions
  are significantly higher than ACF.

#### Drain spike at turn-off

At turn-off, the leakage inductance energy spikes the drain voltage:
Vspike = Vin_max + Vreflected + Vleakage ≈ 57V + 60V + 30-50V ≈ **147-167V** (pre-clamp peak).

The RCD clamp conducts when the spike reaches the clamp voltage - this clamp conduction event is
itself a fast, high-amplitude current pulse. Despite the clamp, residual drain ringing continues
during the off-time. Both the spike and the clamp conduction event contribute to broadband conducted
and radiated EMI.

#### Input EMI filter requirements

To meet the same CISPR 32 Class B conducted emissions limits as Option A, the input EMI filter
will need to be **more complex** (typically a second filter stage, higher inductance CM choke,
more DM capacitance). This means:

- More BOM components for the EMI filter
- More PCB area for the filter
- Greater difficulty co-optimising the filter for both EMI attenuation and IEEE 802.3bt MDI port
  impedance requirements simultaneously

#### RCD clamp as secondary EMI source

The RCD clamp loop (resistor + capacitor + diode) carries a fast current pulse each cycle. This
loop must be placed in an extremely tight PCB layout; if the loop area is large, it becomes a
radiating antenna. Even with good layout, the clamp resistor dissipates leakage energy as heat
rather than recycling it (as ACF does).

#### Drain ringing during on-time

Lm resonates with Coss and PCB parasitic capacitances during the primary on-time, creating
ringing on the drain waveform. This couples through the transformer to the secondary and also
radiates. A primary snubber network (RC snubber across the MOSFET or across the transformer
primary) may be required - adding further components and losses.

#### Secondary side noise

If synchronous rectification is used in flyback mode (TPS23730 supports this), the SR timing
must be carefully optimised for hard-switching flyback - the SR turn-on/turn-off timing is
different from ACF mode. Improperly timed SR in flyback can cause shoot-through or body diode
conduction, both of which generate additional switching noise.

#### Downstream rail cleanliness

Higher switching noise at source → greater potential for switching artefacts to appear on 5V and
3V3 output rails, particularly at high harmonics (1-30MHz). While adequate filtering can address
this, it requires more careful design of output filtering stages.

### 4.4 EMI advantages of Option B

| Advantage | Notes |
| :--- | :--- |
| Extensively documented problem | Decades of application notes, filter design guides, regulatory test reports. Any EMC engineer can address flyback EMI reliably. |
| Predictable harmonic locations | At fixed 200kHz switching frequency, conducted emissions peaks are at known frequencies - systematic filter design straightforward |
| No clamp resonance artefacts | ACF clamp network can create MHz-range artefacts if Cclamp is poorly chosen. Standard flyback with RCD clamp does not have this. |
| Single active switching node | One less switching node to manage in PCB layout (though RCD clamp introduces a secondary concern) |

### 4.5 Non-EMI properties

| Property | Value |
| :--- | :--- |
| Efficiency | 85-90% at full PoE load |
| Extra dissipation vs Option A | ~1-2W at full load |
| Board total dissipation (revised) | ~16-17W typical (vs 14.8W for Option A) - within 19.5W max |
| Primary MOSFET Vds rating | Must be rated ≥200V for this application (57V input + 167V spike) |
| Aux winding PSR compatibility | **Unverified** - must confirm Bourns PDC060 turns ratio vs TPS23730 VS pin voltage compliance |

---

## 5. Head-to-Head Comparison

| Criterion | Option A (ACF) | Option B (Flyback PSR) |
| :--- | :--- | :--- |
| Primary switching EMI | ✔ Very low (ZVS, no hard step) | ❌ High (hard switching) |
| Drain spike EMI | ✔ None | ❌ Present despite RCD clamp |
| CM conducted emissions | ✔ Low | ❌ Significantly higher |
| DM conducted emissions | ✔ Low | ❌ Significantly higher |
| Input EMI filter complexity | ✔ Smaller, simpler | ❌ Larger, more complex, more BOM |
| PoE port impedance co-optimisation | ✔ Easier | ❌ Harder |
| CISPR 32 Class B margin | ✔ Comfortable | ⚠️ Tight - may require design iteration |
| Secondary-side noise | ✔ Very low (ZVS + SR) | ⚠️ Higher; SR timing more critical |
| Downstream rail cleanliness | ✔ Excellent | ⚠️ Adequate with careful filter design |
| Radiated EMI from power stage | ✔ Low | ❌ Higher |
| EMI design complexity overall | ✔ Lower | ❌ Higher |
| PCB area for EMI filter | ✔ Less | ❌ More |
| Clamp resonance risk | ⚠️ Requires careful Cclamp selection | ✔ Not applicable |
| Light-load ZVS behaviour | ⚠️ ZVS may be lost below min load | ⚠️ DCM ringing at light load |
| Efficiency | ✔ 88-92% | ⚠️ 85-90% |
| Thermal dissipation | ✔ Lower | ⚠️ ~1-2W more |
| EMC industry knowledge base | ⚠️ More specialised | ✔ Extensive |
| Transformer availability | ❌ Coilcraft Direct only | ✔ DigiKey / Arrow / Farnell |
| Aux winding PSR verification | ✔ Confirmed (TI reference design) | ⚠️ Requires datasheet verification |

---

## 6. Decision

**Option A - ACF Flyback with Coilcraft POE600F-12L - selected.**

See `design/Design_Log.md - DEC-019` for the formal decision record.

**Rationale summary:**

Option A is technically superior for this application in every EMI/EMC dimension. The ACF topology
provides a cleaner switching environment, a smaller and simpler input EMI filter, and better
downstream rail quality for the noise-sensitive compute and logic loads (CM5, CPLDs, USB JTAG chip).

The Coilcraft procurement constraint (order-direct) is the sole reason Option B was seriously
considered. However:

1. Option B does not eliminate procurement complexity - it merely shifts it from the transformer
   to a larger, more complex EMI filter that must be designed and verified empirically.
2. The extra ~1-2W dissipation in Option B, while manageable on paper, adds thermal margin pressure
   in an already thermally constrained module.
3. The PSR auxiliary winding compatibility of the Bourns PDC060 with the TPS23730 VS pin was never
   confirmed, representing an additional design risk.
4. Coilcraft Direct ordering is a well-established procurement path for specialist magnetics; this
   is an accepted practice for catalogue transformers of this type.

---

*Investigation closed 2026-04-05.*
