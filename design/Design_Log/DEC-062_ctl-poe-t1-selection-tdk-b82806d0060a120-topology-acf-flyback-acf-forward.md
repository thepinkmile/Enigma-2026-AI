## DEC-062 - CTL PoE T1 Selection: TDK B82806D0060A120; Topology ACF Flyback → ACF Forward

| Field | Value |
| :--- | :--- |
| **Decision ID** | DEC-062 |
| **Status** | Confirmed |
| **Date** | 2025-07-10 |
| **Author** | Izzyonstage & Copilot (session e39f3cc4) |
| **Amends** | DEC-019 (ACF topology selection); supersedes Coilcraft POE600F-12L as T1 |

### Context

The original T1 selection (Coilcraft POE600F-12L) was rejected because JLCPCB cannot
machine-place the large-body 12-pin SMT package. A replacement search was conducted across
Coilcraft, Würth, Pulse, Bourns, and TDK. TDK B82806D0060A120 emerged as the preferred
candidate: 60W (PoE++ Class 8), 1500V isolation, 12-pin SMT (6+6 format), rated 36-57V
input, 2:1:1 turns ratio (Np:Ns:Naux), Lm=100µH, Llk=0.18µH, fsw_max=500kHz.

Investigation of topology compatibility (conducted with reference to TI PMP23253 reference
design - 49.5W, TPS23730RMTR, ACF Forward) confirmed that the TPS23730RMTR controller
supports ACF Forward operation natively. The TDK B82806D0060A120 is an ACF **Forward**
transformer (ungapped core, Np:Ns standard wound, energy transferred during switch ON),
which is fundamentally incompatible with the ACF Flyback topology previously specified.
The topology must therefore change from ACF Flyback to ACF Forward throughout.

Key design consequence: ACF Forward requires a buck-style LC output filter on the secondary
(inductor + capacitor), whereas ACF Flyback uses capacitor-only. A new output inductor
component (L1, 33µH) must be added to the CTL BOM and routed in the PCB layout.

### Decision

1. **T1 selection confirmed:** TDK B82806D0060A120 (ACF Forward PoE transformer, 60W,
   1500V isolation, 2:1:1 turns ratio, 12-pin SMT). DigiKey: 495-76653-1-ND;
   Mouser: 871-B82806D0060A120; JLCPCB: C7218686.

2. **Topology change:** CTL PoE power stage changes from **ACF Flyback** to **ACF Forward**
   throughout all design documentation. Controller U8 (TPS23730RMTR) configuration changes
   accordingly.

3. **New component L1 (output inductor):** 33µH shielded ferrite SMT power inductor, ≥6A
   Isat, DCR ≤50mΩ, 200kHz rated. Required by ACF Forward topology. Part selection pending
   (new DR-CTL-25 added). L1 + C20 form the buck-style output LC filter on VIN_POE_12V.

4. **C17 value update:** Clamp capacitor C17 increased from 10nF to 22nF per ACF Forward
   clamp calculation using TDK B82806D0060A120 Llk=0.18µH. MPN update pending (DR-CTL-18
   revised).

5. **Q1, Q2 unchanged:** STD25NF20 200V N-ch MOSFET remains correct for both ACF primary
   and clamp switch roles. Vds_peak in ACF Forward (≤108V at worst case Vin=36V) remains
   well within 200V rated device.

6. **C20 unchanged:** 4× TDK CGA9N3X7R1E476M230KB (188µF nominal) remains valid as the
   forward-converter output capacitor; massively oversized relative to ACF Forward minimum
   but electrically correct.

### Rationale

- TI PMP23253 reference design proves TPS23730RMTR + ACF Forward compatibility at 51W,
  functionally equivalent to the CTL 60W requirement.
- TDK B82806D0060A120 is the only evaluated part meeting all requirements: 60W, 12V,
  12-pin SMT, available via major distributors including JLCPCB.
- ACF Forward topology simplifies core-reset compared to flyback and eliminates the need
  for a high-magnetising-inductance gapped core.
- 33µH L1 selected for ≤30% peak-to-peak current ripple at all operating points; 200V-rated
  Q1/Q2 provides >84% Vds headroom at worst-case ACF Forward stress (108V).

### Files Changed

- `design/Electronics/Controller/Design_Spec.md`: T1 BOM row updated (POE600F-12L → B82806D0060A120 with supplier PNs).
  C17 BOM row updated (10nF → 22nF TBD). New L1 BOM row added. DR-CTL-18/22/23/24 updated for ACF Forward.
  New DR-CTL-25 (output inductor specification) added. §7.1 section updated throughout. Power table updated. BOM Notes updated.
- `design/Electronics/Consolidated_BOM.md`: CTL T1 row updated (POE600F-12L → B82806D0060A120). New CTL L1 row added (TBD).
- `README.md`: Lines 83 and 99 updated from POE600F-12LD to TDK B82806D0060A120.
- `.copilot/discussions/ctl-t1-poe-transformer-investigation.md`: Status banner updated UNDER EVALUATION → SELECTED. Topology references updated Flyback → Forward. Pending Actions resolved.
