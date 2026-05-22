## DEC-017 - Minimum 4-Layer Stackup for All Non-Controller Boards

- **Status:** ✔ ADOPTED
- **Date:** 2026-04-05
- **Category:** Electrical
- **Area:** Reflector Board, Extension Board (all other boards already compliant)

### Decision

All PCBs in the Enigma-NG system shall use a minimum of **4-layer stackup** (JLCPCB
JLC04161H-7628). The Controller Board and the Power Module Board are the only exceptions
and retain their 6-layer JLC06161H-2116 stackup: the Controller for high-speed 5 Gbps
differential pair requirements, and the Power Module for high-current power delivery.

### Standard 4-layer layer mapping for all non-Controller boards

| Layer | Function |
| :--- | :--- |
| L1 | Signal (JTAG, data routing) - top |
| L2 | GND plane - solid contiguous copper |
| L3 | 3V3_ENIG power plane |
| L4 | Signal (data routing, branding data plate) - bottom |

> **Exception - JTAG Daughterboard:** The JDB uses an inverted stackup: L1=GND plane + SMT
> component pads (component side, faces Controller), L2=signal traces, L3=power pours,
> L4=GND shield (exterior face). This inversion places components on the face that mates
> with the Controller Board hat-headers, consistent with single-side JLCPCB assembly.
> See `JTAG_Daughterboard/Design_Spec.md §4`.

### Boards affected (updated)

| Board | Previous | New |
| :--- | :--- | :--- |
| Reflector | 2-Layer 1.6mm FR4 / 1oz | 4-Layer JLC04161H-7628 / 2oz |
| Extension | Layer count unspecified | 4-Layer JLC04161H-7628 / 2oz |

### Boards already compliant (no change)

| Board | Stackup | Notes |
| :--- | :--- | :--- |
| Stator | 4-Layer JLC04161H-7628 | ✔ Unchanged |
| Encoder | 4-Layer JLC04161H-7628 | ✔ Unchanged |
| Rotor | 4-Layer JLC04161H-7628 | ✔ Unchanged |
| Controller | 6-Layer JLC06161H-2116 | ✔ Exception - high-speed stackup retained |
| Power Module | 6-Layer JLC06161H-2116 | ✔ Exception - high-current power delivery stackup retained |

### Impact

The "2-layer uncontrolled impedance" notes for Reflector and Extension in DEC-016 are superseded.
Both boards now have a solid L2 GND plane and can route JTAG on L1 at 0.127 mm (50 Ω controlled
impedance), consistent with all other 4-layer boards. `design/Electronics/Investigations/JTAG_Integrity.md §3.1`, `§3.3` (now
historical), and `§8` trace table have been updated accordingly.

### Rationale

1. **Uniform stackup:** Consistent JLC04161H-7628 across all non-Controller boards eliminates
   stackup-dependent trace impedance variation, reducing signal behaviour differences between boards.
2. **Solid GND on every board:** All boards now have a contiguous L2 GND plane, enabling 50 Ω
   controlled impedance JTAG routing across the entire system.
3. **EMC/EMI improvement:** Solid GND and power planes on all boards reduce radiated emissions and
   improve common-mode noise rejection across the rotor stack and encoder cabling.
4. **Manufacturing speed:** JLC04161H-7628 is JLCPCB's most common 4-layer stackup, with higher
   stock availability and faster turnaround than 2-layer special orders or less common stackups.
5. **Cost:** Marginal price difference between 2-layer and 4-layer at JLCPCB prototype quantities;
   outweighed by signal integrity and EMC benefits.

### Alternatives Considered

- **Retain 2-layer Reflector/Extension:** Rejected - inconsistent stackup creates impedance
  discontinuities in the JTAG chain and leaves an uncontrolled segment at the reflector end.
- **Use different 4-layer stackup per board:** Rejected - non-uniform dielectric parameters would
  require separate trace width calculations per board and add unnecessary design complexity.
