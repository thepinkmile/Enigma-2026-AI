## DEC-020 - GND_CHASSIS Rib Clearway ENIG Bond

- **Status:** Accepted - 2026-04-08
- **Date:** 2026-04-08
- **Category:** Electrical
- **Area:** Power Module - Supercap Block Assembly & Board Layout
- **References:** QUE-001, Certification_Evidence.md §2.2

### Decision

The 3.0mm rib clearway gaps between supercap cells shall have:

1. **Exposed ENIG strip (L1):** Solder mask opened in the rib clearway gap on the top copper layer (L1),
   connected to the GND_CHASSIS net. Minimum strip width 1.5mm, running the full depth of the rib contact zone.
   The aluminium enclosure rib makes direct electrical contact with the PCB GND_CHASSIS copper, providing a
   distributed HF chassis ground bond at the supercap block location.

2. **Polyimide (Kapton) tape on supercap bodies:** Each supercap cell shall be wrapped with a minimum of
   one layer of 2-mil (50µm) polyimide tape prior to installation, to electrically insulate the cell body
   from the aluminium compression ribs and prevent short circuits.

3. **Conductive elastomer gasket strip:** A self-adhesive conductive elastomer or conductive foam gasket strip
   (≤3mm wide, full rib contact depth) shall be applied to the rib face or PCB contact zone to accommodate
   manufacturing tolerances and ensure positive, reliable electrical contact under compression.
   Part to be selected at mechanical design phase when rib geometry is confirmed.

### Rationale

The combined structure - aluminium Can lid, compression ribs, conductive gasket, PCB ENIG strip, and
GND_CHASSIS copper pour - forms a near-complete Faraday cage around the supercap block, improving
shielding of the high-capacitance energy storage element from the rest of the board.

### Compatibility with single-point GND_CHASSIS bond rule

The single-point rule governs signal GND → GND_CHASSIS crossings. Rib contact bonds are
enclosure-to-GND_CHASSIS connections - both within the chassis domain - and do not create additional
signal-to-chassis bonds. The rule is maintained.

### Other boards

Deferred pending mechanical design documentation. Controller Board Mechanical_Design.md §3 notes the
prototype uses a 3D-printed chassis (no conductive rib contact); this decision will be revisited when
metal chassis dimensions are finalised. Stator/Encoder/Rotor mechanical designs are not yet written.
