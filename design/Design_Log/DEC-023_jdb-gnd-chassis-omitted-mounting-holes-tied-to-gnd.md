## DEC-023 - JDB GND_CHASSIS Omitted; Mounting Holes Tied to GND

- **Status:** Decided
- **Date:** 2026-04-06
- **Category:** Electrical
- **Area:** JTAG Daughterboard - Grounding & EMC

### Decision

The JTAG Daughterboard (JDB) does **not** implement a `GND_CHASSIS` net. Mounting holes are included
for mechanical stability via conductive standoffs to the Controller board; the copper pours around
those mounting holes are tied to **GND** (circuit return). No dedicated chassis bond pad, stitching
via, or `GND_CHASSIS` net is present on the JDB.

> Cross-reference: DEC-039 keeps the single Power Module bond rule but now makes this JDB treatment
> the generic exception for non-chassis-connected daughterboards.

### Rationale

`GND_CHASSIS` exists to bond a PCB to the metal enclosure for EMC shielding, ESD protection, and safety earth. None of those functions apply to the JDB because:

1. **No chassis surface** - the JDB is an internal daughterboard that floats above the Controller
   board on hat-header pins and conductive standoffs. It has no metal enclosure surface it can
   directly bond to.
2. **EMC envelope already provided** - the Controller board beneath it carries a correctly implemented `GND_CHASSIS` net bonded to the system enclosure. The JDB sits entirely within that envelope.
3. **No external connections** - the JDB has no cables or connectors that exit the enclosure, so there are no ESD entry points that would require chassis bonding at the JDB level.
4. **Low-EMI device** - the FT232H operates at USB 2.0 speeds on an internal point-to-point link. It generates no significant conducted or radiated emissions that would require additional chassis shielding.
5. **Daisy-chaining adds no value** - connecting JDB `GND_CHASSIS` via standoffs to Controller
   `GND_CHASSIS` would create an additional path to chassis earth but no new bond point, adding
   PCB complexity for zero measurable EMC benefit.

### Implementation

- Include **mounting holes** on the JDB for mechanical stability.
- Standoffs are conductive (metal); this incidentally bonds the JDB mounting hole copper pours to the Controller board mechanically.
- Mounting hole copper pours connect to **GND** (circuit return) - not to a separate `GND_CHASSIS` net.
- This is consistent with standard practice for small internal sub-modules (e.g. Arduino shields, FPGA daughter cards).

### Alternatives Considered

- **Standoff bonding to Controller GND_CHASSIS:** Technically implementable but adds a separate net, a copper pour, and design rules for no measurable EMC gain on a low-EMI internal board. Rejected.
- **No mounting holes at all:** Rejected - mechanical retention via standoffs is required to prevent the board from flexing on the hat-headers during connector insertion/removal.
