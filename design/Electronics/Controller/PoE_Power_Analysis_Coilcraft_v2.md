# Enigma-NG — PoE Transformer: Coilcraft POE600F-12L Design (Deferred — v2)

> ⚠️ **DEFERRED — DO NOT IMPLEMENT**
>
> This document records the original ACF Flyback design using the Coilcraft POE600F-12L isolation
> transformer. This design was rejected for v1 production due to:
>
> 1. **JLCPCB assembly incompatibility:** JLCPCB machines cannot fit the Coilcraft POE600F-12L.
> 2. **Pre-production / limited availability status:** The part is available direct from Coilcraft
>    only (no Mouser, DigiKey, or JLCPCB supplier code). Production availability is unconfirmed.
>
> **This document must not be actioned until the `ctl-t1-coilcraft-v2-review` todo is worked.**
> That todo should be revisited when the Coilcraft POE600F-12L (or a pin-compatible successor)
> achieves production-ready status with mainstream distributor availability.
>
> All calculations and part selections below are preserved so the design can be reverted to this
> approach with minimal rework once the Coilcraft part becomes generally available.

---

**Date (deferred):** 2026-05-09
**Original analysis date:** 2026-04-05
**Status:** ⏸ DEFERRED — pending `ctl-t1-coilcraft-v2-review` todo
**Affects:** Controller Board — T1 transformer, TPS23730 operating mode
**Superseded by:** TDK B82806D0060A120 (ACF Forward) — see `design/Electronics/Controller/PoE_Power_Analysis.md` and DEC-062

---

## 1. Coilcraft Samples

Coilcraft samples for the POE600F-12L were ordered under reference **153954** before the JLCPCB
assembly constraint was identified. The samples have arrived and are available for laboratory
prototype testing.

**Important:** These are pre-production samples. They **cannot be used in the official v1 production
design**. They are suitable for bench validation, EMI characterisation, and topology verification only.

---

## 2. Coilcraft POE600F-12L — Part Details

| Parameter | Value |
| :--- | :--- |
| Manufacturer | Coilcraft |
| MPN | POE600F-12L (`D` suffix = packaging only; electrically identical) |
| Series | POE600F |
| Package | 12-pin SMT |
| Output voltage | 12V |
| Output current | 5A (60W) |
| Input voltage | 36–57V (PoE) |
| Switching frequency | ~250 kHz |
| Turns ratio | 1.71:1 (n ≈ 1.71; Np:Ns) |
| Auxiliary winding | ✔ Present (PSR auxiliary winding for TPS23730 VS pin) |
| Aux turns ratio | 1:1 (Naux:Ns) — **verify from Coilcraft datasheet when reverting** |
| Primary inductance (Lm) | 100µH |
| Leakage inductance (Llk) | Not published — **verify from Coilcraft; use ≤0.35µH as working limit** |
| Primary DCR | ~39mΩ |
| Secondary DCR | ~90mΩ |
| Aux DCR | ~12mΩ |
| Hipot (Pri–Sec) | 1500 Vac |
| JLCPCB assembly | ❌ Cannot machine-fit |

### 2.1 Procurement

| Channel | Status |
| :--- | :--- |
| Coilcraft Direct (`coilcraft.com`) | ✔ Available (in-stock) |
| DigiKey | ❌ Not stocked |
| Mouser | ❌ Not stocked |
| JLCPCB | ❌ Cannot machine-fit; no supplier code |
| Worldway Electronics | ⚠️ Listed (grey market; not authorised) |
| JLCPCB consignment (manual placement) | ⚠️ Theoretically possible; **not recommended for production** |

### 2.2 Footprint Note

The Coilcraft POE600F-12L uses a 12-pin SMT footprint that differs from the TDK B82806D0060A120
EFD20 gullwing footprint. If reverting to the Coilcraft design, a new footprint must be created or
sourced. A KiCAD footprint zip file is available in the repository temp folder. Schematic capture
had not begun when the Coilcraft design was superseded, so no PCB rework is required to revert.

---

## 3. Original ACF Flyback Design Analysis

The following is the complete original topology investigation and transformer selection analysis
carried out for the Coilcraft POE600F-12L. It is preserved verbatim for reference when actioning
the `ctl-t1-coilcraft-v2-review` todo. The decision recorded here (DEC-019) was subsequently
superseded by DEC-062 when the TDK B82806D0060A120 was adopted.

---

### 3.1. Background

The Power Module uses a discrete two-stage PoE architecture:

- **Stage 1 - PD Interface:** TPS2372-4 (IEEE 802.3bt Type 4, 72W class PD with external hotswap)
- **Stage 2 - DC-DC Converter:** TPS23730 ACF controller + T1 isolation transformer + synchronous rectifier

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

### 3.2. Transformer Market Survey

#### 3.2.1 Coilcraft POE600F family

All relevant variants in the POE600F product family (12L, 24L, 33L, 50L, etc.) were confirmed via
Octopart to be stocked exclusively at Coilcraft Direct or Worldway Electronics (grey market). No
authorised mainstream distributor (DigiKey, Mouser, Farnell, Arrow) stocks any member of this family.

**Why:** ACF PoE isolation transformers for 60W / 36-57V input are a niche product co-developed by
TI and Coilcraft specifically for the TPS23730 reference design. The transformer requires a primary
winding, secondary winding, PSR auxiliary winding (tuned for TPS23730 VS-pin feedback), and magnetic
parameters (Lm, Llk) optimised for ACF resonant operation at 200-250kHz. No other manufacturer has
a catalogued part meeting this specification.

#### 3.2.2 Alternatives investigated

| Part | Manufacturer | Topology | Verdict |
| :--- | :--- | :--- | :--- |
| PDC060-FD20A12S | Bourns | Standard flyback | ✔ Available DigiKey/Arrow/Farnell - but topology mismatch (see §3.4) |
| WE-FB range | Wurth Elektronik | Flyback (LT-series) | ❌ Max input 36V - insufficient for PoE (36-57V required) |
| All others searched | - | - | ❌ No ACF-compatible result from DigiKey/Mouser/JLCPCB/Octopart |

The Wurth WE-FB range is keyed to Linear Technology LT-series controllers (LT3573, LT3748, etc.)
and its maximum input voltage across the entire range is 36V - making it inapplicable to PoE.

**Conclusion:** There is no ACF PoE transformer for 60W / 36-57V input available from any mainstream
authorised distributor. This is a structural market reality, not a search gap.

---

### 3.3. Option A - ACF Flyback (Coilcraft POE600F-12L, TPS23730 ACF mode)

#### 3.3.1 Procurement

| Attribute | Value |
| :--- | :--- |
| Part number | Coilcraft POE600F-12L (`D` suffix = packaging only) |
| Availability | Coilcraft Direct only - `coilcraft.com` |
| Price (qty-1) | ~£3.54 |
| Price (volume) | ~£1.86 |
| Lead time | Days (in-stock) |
| Prototype path | Order direct from Coilcraft |
| Production path | Pre-order from Coilcraft; ship to JLCPCB as consignment |

#### 3.3.2 Circuit configuration

- TPS23730 `ACF_GD` pin drives an external active clamp MOSFET (complementary to primary switch)
- Active clamp capacitor (Cclamp) stores and recycles leakage inductance energy
- Primary MOSFET turns on under Zero Voltage Switching (ZVS) conditions
- TPS23730 VS pin reads auxiliary winding for Primary-Side Regulation (PSR) output feedback
- Synchronous rectification (SR) on secondary driven by TPS23730 SR pin

#### 3.3.3 EMI/EMC characteristics

##### Primary switching - ZVS

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

##### Drain spike - eliminated

In standard flyback, turn-off creates a drain voltage spike: Vin_max + Vreflected + Vleakage_spike
(can reach 150-180V at 57V input before RCD clamp conducts). In ACF, the leakage energy flows into
the clamp capacitor and is recycled. **There is no spike, no RCD clamp event, and no associated
broadband noise injection.**

##### Input EMI filter

Because both DM and CM emissions are lower at source, the input EMI filter (between PoE PD interface
and DC-DC converter) can be smaller:

- Fewer filter stages required to meet CISPR 32 Class B
- Lower inductance values and fewer capacitors
- Saves PCB area and BOM cost
- Easier to co-optimise filter characteristics for both EMI attenuation and IEEE 802.3bt MDI
  port impedance requirements (which impose their own constraints on the filter impedance)

##### Secondary side

TPS23730 synchronous rectification (supported in ACF mode) eliminates the secondary rectifier
reverse recovery current transient - a significant secondary-side EMI source in diode-rectified
designs.

##### Downstream rail cleanliness

Lower conducted noise at the converter input → less transformer coupling of switching artefacts
to the output → cleaner 5V and 3V3 rails feeding the CM5, CPLDs, and USB JTAG chip downstream.

#### 3.3.4 Known EMI risks

| Risk | Mitigation |
| :--- | :--- |
| Clamp LC resonance (Cclamp + Llk tank) - can create MHz-range artefacts if clamp cap poorly chosen | Select Cclamp per TPS23730 reference design; verify clamp frequency in simulation |
| ZVS lost at light load (below minimum load threshold) - partial hard switching at idle | TPS23730 burst mode reduces switching at light load; acceptable for standby conditions |
| Two switching nodes (primary + clamp MOSFET) - both require tight PCB layout | Keep both MOSFETs close to transformer primary with short high-current loops |

#### 3.3.5 Non-EMI properties

| Property | Value |
| :--- | :--- |
| Efficiency | 88-92% at full PoE load |
| Transformer losses (T1) | ~5.1W typical / 5.7W max at 51-57W PoE load |
| Board total dissipation | ~14.8W typical / 19.5W max |
| Primary MOSFET Vds rating | Controlled drain voltage - lower rating margin required |
| BOM change vs flyback | +1 clamp MOSFET, +1 clamp capacitor vs RCD (net neutral on count) |

---

### 3.4. Option B - Standard Flyback PSR (Bourns PDC060-FD20A12S, TPS23730 flyback mode)

#### 3.4.1 Procurement

| Attribute | Value |
| :--- | :--- |
| Part number | Bourns PDC060-FD20A12S |
| Availability | DigiKey (`118-PDC060-FD20A12S-ND`), Arrow, Farnell |
| DigiKey stock | ~138 units (at time of survey) |
| Price | ~$5.27-$6.54 per unit |
| Lead time | Standard stock |
| Prototype path | Direct from DigiKey/Arrow/Farnell |
| Production path | Standard ordering - no consignment required |

#### 3.4.2 Circuit configuration changes vs Option A

- TPS23730 `ACF_GD` pin tied to GND - disables active clamp gate drive
- Active clamp MOSFET removed from BOM
- Active clamp capacitor removed from BOM
- RCD clamp added to primary drain: clamp diode (D) + clamp capacitor (C) + clamp resistor (R)
  - 3 new SMD components
- Net BOM change: -2 components, +3 components = +1 component vs Option A
- Primary MOSFET Vds rating must be reviewed - drain spike voltage increases without active clamp
- Auxiliary winding PSR compatibility with TPS23730 VS pin must be verified against Bourns PDC060
  datasheet (turns ratio and voltage compliance)

#### 3.4.3 EMI/EMC characteristics

##### Primary switching - hard switching

In a standard flyback, the primary MOSFET turns on hard - the drain steps from
(Vin + Vspike_residual) down to near-zero in nanoseconds. This is a fast dV/dt event generating:

- **DM conducted EMI:** Fast current edge charges input filter capacitors - a current pulse
  propagates back to the PoE port every switching cycle. DM emissions at 200kHz and harmonics
  are 15-25dB higher than ACF (before input filter).
- **CM conducted EMI:** The fast drain dV/dt couples through transformer interwinding capacitance
  (Cwinding) to the secondary and chassis, injecting CM current into the PoE port. CM emissions
  are significantly higher than ACF.

##### Drain spike at turn-off

At turn-off, the leakage inductance energy spikes the drain voltage:
Vspike = Vin_max + Vreflected + Vleakage ≈ 57V + 60V + 30-50V ≈ **147-167V** (pre-clamp peak).

The RCD clamp conducts when the spike reaches the clamp voltage - this clamp conduction event is
itself a fast, high-amplitude current pulse. Despite the clamp, residual drain ringing continues
during the off-time. Both the spike and the clamp conduction event contribute to broadband conducted
and radiated EMI.

##### Input EMI filter requirements

To meet the same CISPR 32 Class B conducted emissions limits as Option A, the input EMI filter
will need to be **more complex** (typically a second filter stage, higher inductance CM choke,
more DM capacitance). This means:

- More BOM components for the EMI filter
- More PCB area for the filter
- Greater difficulty co-optimising the filter for both EMI attenuation and IEEE 802.3bt MDI port
  impedance requirements simultaneously

##### RCD clamp as secondary EMI source

The RCD clamp loop (resistor + capacitor + diode) carries a fast current pulse each cycle. This
loop must be placed in an extremely tight PCB layout; if the loop area is large, it becomes a
radiating antenna. Even with good layout, the clamp resistor dissipates leakage energy as heat
rather than recycling it (as ACF does).

##### Drain ringing during on-time

Lm resonates with Coss and PCB parasitic capacitances during the primary on-time, creating
ringing on the drain waveform. This couples through the transformer to the secondary and also
radiates. A primary snubber network (RC snubber across the MOSFET or across the transformer
primary) may be required - adding further components and losses.

##### Secondary side noise

If synchronous rectification is used in flyback mode (TPS23730 supports this), the SR timing
must be carefully optimised for hard-switching flyback - the SR turn-on/turn-off timing is
different from ACF mode. Improperly timed SR in flyback can cause shoot-through or body diode
conduction, both of which generate additional switching noise.

##### Downstream rail cleanliness

Higher switching noise at source → greater potential for switching artefacts to appear on 5V and
3V3 output rails, particularly at high harmonics (1-30MHz). While adequate filtering can address
this, it requires more careful design of output filtering stages.

#### 3.4.4 EMI advantages of Option B

| Advantage | Notes |
| :--- | :--- |
| Extensively documented problem | Decades of application notes, filter design guides, regulatory test reports. Any EMC engineer can address flyback EMI reliably. |
| Predictable harmonic locations | At fixed 200kHz switching frequency, conducted emissions peaks are at known frequencies - systematic filter design straightforward |
| No clamp resonance artefacts | ACF clamp network can create MHz-range artefacts if Cclamp is poorly chosen. Standard flyback with RCD clamp does not have this. |
| Single active switching node | One less switching node to manage in PCB layout (though RCD clamp introduces a secondary concern) |

#### 3.4.5 Non-EMI properties

| Property | Value |
| :--- | :--- |
| Efficiency | 85-90% at full PoE load |
| Extra dissipation vs Option A | ~1-2W at full load |
| Board total dissipation (revised) | ~16-17W typical (vs 14.8W for Option A) - within 19.5W max |
| Primary MOSFET Vds rating | Must be rated ≥200V for this application (57V input + 167V spike) |
| Aux winding PSR compatibility | **Unverified** - must confirm Bourns PDC060 turns ratio vs TPS23730 VS pin voltage compliance |

---

### 3.5. Head-to-Head Comparison

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

### 3.6. Original Decision (DEC-019 — Superseded by DEC-062)

**Option A - ACF Flyback with Coilcraft POE600F-12L - selected (original).**

See `design/Design_Log.md — DEC-019` for the formal original decision record.

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

**Why DEC-019 was later superseded:** The Coilcraft POE600F-12L is pre-production and JLCPCB
cannot machine-fit it, making volume assembly impractical. The TDK B82806D0060A120 was identified
as a JLCPCB-stocked ACF-compatible transformer. DEC-062 records the switch to TDK and the
transition from ACF Flyback to ACF Forward topology.

---

## 4. Supporting Component Requirements for Coilcraft Design

The following calculations are preserved so the design can be reverted cleanly. All values assume
n = 1.71 (Coilcraft POE600F-12L turns ratio), Lm = 100µH, fsw = 200kHz, Vout = 12V, Iout = 5A,
Vf = 0.4V (secondary rectifier).

### 4.1 Duty Cycle Analysis (n = 1.71)

Formula: `D = n × (Vout + Vf) / (Vin + n × (Vout + Vf))`

| Vin | D (n=1.71) | TPS23730 window (5–75%) |
| :--- | :--- | :--- |
| 36V (min) | 37.1% | ✔ |
| 48V (nom) | 30.7% | ✔ |
| 57V (max) | 27.1% | ✔ |

### 4.2 TPS23730 VCC (Auxiliary Winding)

Assuming Naux:Ns = 1:1 (same as TDK design — **verify from Coilcraft datasheet when reverting**):

```text
V_aux= Vout × (Naux/Ns) = 12 × 1.0 = 12.0V
VCC   = V_aux − Vf_aux   = 12.0 − 0.4 = 11.6V
```

Within TPS23730 VCC spec (7–20V) ✔ — **verify Naux:Ns ratio before confirming.**

### 4.3 MOSFET Vds Stress (Q1, Q2)

```text
Vds_peak= Vin_max + n × (Vout + Vf) = 57 + 1.71 × 12.4 = 78.2V
```

MOSFET class required: ≥150V; 200V with derating is recommended. The **STD25NF20** (200V Vds, 18A Id)
selected for the TDK design is equally compatible with the Coilcraft design — no MOSFET change
required when reverting.

### 4.4 C17 — Active Clamp Capacitor

Coilcraft does not publish Llk for the POE600F-12L. Two calculation paths:

| Llk assumption | I_pk (36V) | E_Ls | C17 | ΔV_clamp |
| :--- | :--- | :--- | :--- | :--- |
| 0.35µH (Bourns max — conservative proxy) | 3.26A | 1.86µJ | **47nF** | 6.3V (26%) ✔ |
| 0.18µH (TDK value — optimistic) | 3.26A | 0.96µJ | **22nF** | 6.7V (28%) ✔ |

**Recommended action when reverting:** Request Llk from Coilcraft for POE600F-12L and recalculate.
Use **47nF** as the safe conservative starting value until Llk is confirmed.

C17 specification at 47nF: **X7R, 100V, 0402** (or 0805 if 100V X7R 0402 not available at 47nF).

### 4.5 Output Filter — C_out (No L1 Required)

ACF Flyback does **not** require a separate output inductor. Lm provides the inductive energy
storage function. C20 is the only output filter element on `VIN_POE_12V`.

```text
Cout_min= Iout × D / (fsw × Vripple)
         = 5A × 37.1% / (200kHz × 0.12V) = 77µF
```

Standard value: **100µF / 25V**. The 4× TDK CGA9N3X7R1E476M230KB already in BOM (188µF nominal)
exceeds this requirement ✔. C20 BOM row is unchanged when reverting.

### 4.6 Conduction Losses (n = 1.71, Vin = 36V worst case)

```text
I_pri_RMS≈ Iout × (1−D) / (n × √D) = 5 × 0.629 / (1.71 × 0.609) = 3.145 / 1.041 = 2.83A
I_sec_RMS ≈ Iout / √(1−D)            = 5 / √0.629 = 5 / 0.793 = 6.31A
```

| Component | Value |
| :--- | :--- |
| Primary P_cu | 2.83² × 39mΩ = 0.313W |
| Secondary P_cu | 6.31² × 90mΩ = 3.583W |
| **Total winding loss** | **3.896W (6.49% of 60W)** |

**Note:** The high secondary DCR (90mΩ) is the principal inefficiency of this design. The TDK
B82806D0060A120 (8mΩ secondary DCR) saves approximately 3.3W over this design.

### 4.7 Clamp Energy

Using Bourns Llk proxy (0.35µH) and C17 = 47nF:

```text
P_clamp = E_Ls × fsw = 1.86µJ× 200kHz = 0.37W
```

### 4.8 ACF Flyback Design Equations Reference

```text
Duty cycle:D = n × (Vout + Vf) / (Vin + n × (Vout + Vf))
Vds stress:         Vds_peak = Vin_max + n × (Vout + Vf)
Aux winding VCC:    V_aux = Vout × (Naux/Ns);  VCC = V_aux − Vf_aux
Peak primary I:     I_pk = Iout/n + ΔI_Lm/2
Lm ripple current:  ΔI_Lm = Vin × D / (Lm × fsw)
Clamp energy:       E_Ls = ½ × Llk × I_pk²
Clamp voltage:      ΔV_clamp = E_Ls / (C17 × (Vout + Vf))
Output capacitor:   Cout_min = Iout × D / (fsw × Vripple)
Primary RMS I:      I_pri_RMS ≈ Iout × (1−D) / (n × √D)
Secondary RMS I:    I_sec_RMS ≈ Iout / √(1−D)
Conduction loss:    P_cu = I_RMS² × DCR
Snubber power:      P_clamp = E_Ls × fsw
```

---

## 5. Design Changes Required When Reverting to Coilcraft

When the `ctl-t1-coilcraft-v2-review` todo is actioned and the Coilcraft part is confirmed
production-ready, the following design changes are needed:

| Item | Current (TDK ACF Forward) | Required (Coilcraft ACF Flyback) |
| :--- | :--- | :--- |
| T1 MPN | TDK B82806D0060A120 | Coilcraft POE600F-12L (PRIMARY DIRECTIVE — explicit approval required) |
| T1 supplier PNs | DigiKey 495-76653-1-ND · Mouser 871-B82806D0060A120 · JLCPCB C7218686 | Coilcraft Direct only — update when mainstream distribution confirmed |
| Topology label | ACF Forward | ACF Flyback |
| C17 value | 22nF | 47nF (conservative; recalculate from confirmed Coilcraft Llk) |
| C17 MPN | Kemet C0805C223K2RACAUTO | Recalculate and reselect (X7R 47nF 100V, 0402 or 0805) |
| L1 | Yageo PA4343.333NLT (33µH) — **present** | **Remove** — ACF Flyback does not use an output inductor |
| DR-CTL-25 | Output inductor requirement | **Revise or deactivate** — no output inductor in ACF Flyback |
| PoE_Power_Analysis.md | TDK ACF Forward analysis (current) | Replace with this deferred file's content |
| Design Log | DEC-062 (TDK selection) | Append new DEC-xxx recording revert decision |
| T1 footprint | TDK EFD20 gullwing 12-pin | Coilcraft POE600F-12L footprint (KiCAD zip in temp folder) |
| Aux winding ratio | 2:1:1 confirmed | **Verify** Naux:Ns from Coilcraft datasheet before finalising VCC calculation |
| Llk | 0.18µH MAX (published) | **Obtain from Coilcraft** — not currently published; recalculate C17 when confirmed |

---

## 6. Related Files

- `design/Electronics/Controller/PoE_Power_Analysis.md` — Current TDK B82806D0060A120 ACF Forward analysis
- `design/Electronics/Controller/Design_Spec.md` — CTL BOM (T1, L1, C17, C20, Q1, Q2 rows)
- `design/Design_Log.md` — DEC-019 (original Coilcraft decision); DEC-062 (TDK selection)
- `design/Datasheets/TDK-B82806D-datasheet.md` — TDK B82806D series datasheet (markdown)
- `design/Datasheets/Bourns-POE_FD-datasheet.md` — Bourns POE-FD series datasheet (markdown)

---

*Original investigation closed 2026-04-05. Extracted to deferred file 2026-05-09.*
