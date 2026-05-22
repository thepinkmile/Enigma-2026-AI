## DEC-068 - PM Per-Input Bulk Capacitors and Output Source-Quality Bulk Banks

| Field | Value |
| :--- | :--- |
| **Decision ID** | DEC-068 |
| **Status** | Confirmed |
| **Date** | 2026-05-12 |
| **Author** | Izzyonstage & Copilot |
| **Amends** | - |

### Context

During design review of the Power Module capacitor topology, three questions were raised about bulk
capacitor placement at positions not covered by the GRS §3 bulk-entry requirement (which the PM is
exempt from as a rail source, not a rail receiver):

- **Q1:** Should each of the three power inputs (PoE, battery, USB-C) have dedicated bulk capacitors
  between the input connector and the OR-ing ideal-diode FET (LM74700), to suppress per-input
  transients and present a lower-impedance supply to the choke chain?
- **Q2:** Should the 5V_MAIN rail have output bulk capacitors placed adjacent to the J1 dock
  connector, so clean power is presented at the PM output independent of the CTL-side GRS §3 banks?
- **Q3:** Should the 3V3_ENIG rail have equivalent output bulk at J1, for the same reason?

The PM is currently exempt from GRS §3 as it generates rails rather than receiving them. However, if
the PM is ever used in a configuration other than the standard CTL-carrier context, there is no
guarantee that a GRS §3 bank will be present on a downstream board.

### Decision

**Q1 - Pre-OR-ing per-input bulk:** Each of the three input paths shall have a tight parallel cluster
of 3× Samsung CL32B226KAJNNNE (22µF X7R 25V 1210) placed adjacent to each LM74700 ANODE pin.
Total: 9 capacitors (C59-C67). The three-cap bank uses a tight parallel cluster - not the GRS §3
five-cap star formation, which is specific to five-cap banks. The same part (CL32B226KAJNNNE) is
already qualified in the PM BOM as C1-C15. Voltage derating: 25V rated at 11-16.9V input range =
1.5-2.3× (consistent with existing C1-C15, which use this same part on the same VIN input rail).

**Q2 - 5V_MAIN output bulk:** A bank of 5× Samsung CL21B106KAYQNNE (10µF X7R 25V 0805) shall be
placed adjacent to the J1 dock connector 5V_MAIN output pins (C68-C72). These are distinct from
C14/C15, which sit near the LTC3350 for backup-switchover energy storage (DEC-030) - different
physical location, different purpose. Voltage derating: 25V rated at 5V = 5× (excellent).

**Q3 - 3V3_ENIG output bulk:** A bank of 5× Samsung CL21B106KAYQNNE (10µF X7R 25V 0805) shall be
placed adjacent to the J1 dock connector 3V3_ENIG output pins (C73-C77). These are distinct from
C23 (TPS75733 LDO minimum-stability capacitor). Voltage derating: 25V rated at 3.3V = 7.6×
(excellent).

### Rationale

The PM should be a well-conditioned, self-contained power source. Adding output bulk at the connector
ensures clean rail presentation regardless of downstream board design - the PM does not rely on a
downstream GRS §3 bank to condition its output.

The per-input bulk (Q1) addresses the impedance discontinuity between each source connector and the
shared OR-ing stage. With three asynchronous inputs (PoE regulated, battery variable 11-16.4V,
USB-C PD negotiated), each input can present different transient profiles. A dedicated parallel
cluster adjacent to each LM74700 ANODE pin minimises the loop inductance for that input's transient
path without relying on the shared VIN_RAW bulk.

### Precedence

1. **LM74700-Q1 datasheet (TI):** Recommends adequate input-side decoupling on ANODE for transient
   load response.
2. **TI SLVA408 (Power Path Management):** Reference designs include per-input bulk capacitance ahead
   of OR-ing stage.
3. **TI SLVA530 (Battery & System Power Management):** Per-input bulk before OR-ing stage shown as
   standard practice.
4. **IPC-9592B:** Specifies output bulk capacitors at supply output terminals independent of
   downstream board design.
5. **ETSI EN 300 132-3:** Requires bulk capacitance at each DC/DC output before distribution bus in
   telecom power systems.
6. **TI LMQ61460 datasheet §9.3:** Recommends additional output bulk beyond converter capacitors for
   multi-load distribution.

### Placement Constraints

- **C59-C67 (Q1):** Place in tight parallel cluster adjacent to each LM74700 (U6a/U6b/U6c) ANODE
  pin - 3 caps per OR-ing FET, minimising loop inductance. Not a star formation.
- **C68-C72 (Q2):** Place adjacent to J1 5V_MAIN output pins. Do **not** place near LTC3350 (C14/C15
  placement zone). Distinct purpose: output conditioning, not holdup.
- **C73-C77 (Q3):** Place adjacent to J1 3V3_ENIG output pins. Do **not** place near TPS75733 (C23
  placement zone). Distinct purpose: output conditioning, not LDO stability.

### Inrush and Bulk-Cap Interaction

The Q1 bulk caps (C59-C67: 3× 22 µF per input) sit between F2/F3/F4 (added in DEC-069) and the
corresponding LM74700 OR-ing FET ANODE. On power-up, these caps charge through the polyfuse.
Inrush is naturally limited by source impedance (cable resistance + PoE output impedance /
STUSB4500 ramp / battery ESR), and the LM74700 GATE slew already limits FET turn-on current. The
PTC thermal mass of F2/F3/F4 prevents nuisance trips on normal inrush durations (typically
<10 ms). No separate inrush limiter is required.

### Files Changed

- `design/Electronics/Power_Module/Design_Spec.md` - DR-PM-16/17/18 added; BOM rows C59-C77 added;
  GRS §3 exemption note updated to acknowledge DEC-068 output banks
- `design/Electronics/Consolidated_BOM.md` - PM rows updated for CL32B226KAJNNNE
  (C1-C15,C59-C67) and CL21B106KAYQNNE (C20,C68-C77)
