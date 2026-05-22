## DEC-011 - All Power Rails on Power Module; 3V3_ENIG Serves Rotor Stack

- **Status:** ✔ RESOLVED
- **Date:** 2025
- **Category:** Electrical
- **Area:** Power Module islands, Controller Board routing, rotor stack power source

### Decision

All power rails are generated on the **Power Module**. The Controller Board's role is purely to **route** power rails onward to downstream boards - it does not generate any rails itself. The rotor
stack is powered by the existing **3V3_ENIG** rail (TPS75733KTTRG3 LDO, 3A). There is no separate Rotor Buck; the erroneous "3.3V/5A Rotor Buck" specification was a confusion with the 5V/5A CM5 rail and
has been removed.

### Rationale

- Centralising all power generation on the Power Module simplifies thermal management (all heat dissipation in one shielded enclosure with dedicated thermal zone).
- Reduces the risk of ground loops and cross-domain sequencing issues.
- The Controller Board as a routing layer keeps its design cleaner and easier to revise independently.
- 3V3_ENIG (3A) covers all 3.3V consumers: CPLDs, USB-JTAG, I2C logic, control signals, and the rotor stack.
- Settings Board RGB indicators are powered from 5V_MAIN via the Stator/Settings 6-pin harness; only
  their control logic remains on 3V3_ENIG.
- ROTOR_EN (CM5 GPIO 16) enables/disables the 3V3_ENIG LDO for sequenced rotor power-up - a control signal only.

### Architectural Rule (permanent)

> All power rails are generated on the Power Module. The Controller Board routes rails to downstream boards only. No buck converters, LDOs, or other power-generating components belong on the
> Controller Board.

### Impact

- `README.md`: Removed erroneous "Dedicated 3.3V/5A Buck" from Controller Board section; 3V3_ENIG correctly listed as Power Module output serving CPLDs, logic, and rotor stack.
- `Power_Module/Design_Spec.md`: 3V3_ENIG scope updated to include rotor stack; 3-island Power Plane retained.
- `Controller/Design_Spec.md`: ROTOR_EN clarified as LDO enable signal to Power Module.
- `Rotor/Design_Spec.md`: Power source updated from "Controller Board Island C" to "Power Module 3V3_ENIG rail".

### Previously Conflicting References (now corrected)

- `README.md` placed the Rotor Buck under the Controller Board section.
- `Rotor/Design_Spec.md` said "sourced from the Controller Board's Island C".
