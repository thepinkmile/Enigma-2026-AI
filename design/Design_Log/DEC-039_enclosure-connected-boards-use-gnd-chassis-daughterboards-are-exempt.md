## DEC-039 - Enclosure-Connected Boards Use GND_CHASSIS; Daughterboards Are Exempt

- **Status:** Decided
- **Date:** 2026-04-20
- **Category:** Electrical / EMC
- **Area:** All boards - grounding, mounting, and enclosure bonding
- **Author:** Izzyonstage & GitHub Copilot

### Summary

Standardise `GND_CHASSIS` across the enclosure-connected parts of the system: every
enclosure-connected board carries a local `GND_CHASSIS` net tied to its mounting holes and any
deliberate enclosure-contact or shield-contact features, while non-chassis-connected daughterboards
are exempt. The only galvanic `GND` ↔ `GND_CHASSIS` bond remains on the Power Module at the common
power-entry point immediately before the eFuse.

### Problem

The prior documentation mixed two different grounding models:

- some documents treated `GND_CHASSIS` as a board-specific feature used only on externally exposed
  boards
- other documents already relied on a shared chassis domain and a single Power Module bond point
- JDB-specific wording in DEC-023 needed to remain valid, but the prior update had over-corrected by
  requiring even non-chassis-connected daughterboards to implement `GND_CHASSIS`

That ambiguity makes isolated board review harder and risks future designs creating inconsistent
mounting-hole grounding or accidental secondary bond points.

### Decision

1. **Every enclosure-connected board implements `GND_CHASSIS`.**
   - Tie mounting holes and other defined enclosure-contact / shield-contact mechanical features to
     the local `GND_CHASSIS` net.
   - This applies to removable boards and fixed boards that bond into the enclosure structure.

2. **Non-chassis-connected daughterboards are exempt.**
   - Board-mounted daughterboards that do not connect directly to the enclosure do not need their own
     `GND_CHASSIS` net.
   - They are treated as electrical / mechanical extensions of the host board instead.
   - The JTAG Daughterboard (JDB) is the canonical example of this exception.

3. **The enclosure is the distributed chassis return path.**
   - The metal enclosure and bonded mounting hardware form one continuous chassis domain across the
     machine.
   - Transients and shield currents are intended to flow through that chassis domain toward the
     single galvanic bond instead of being dumped into local logic/power `GND` on intermediate boards.

4. **Only the Power Module may bond `GND` to `GND_CHASSIS`.**
   - The sole intentional galvanic bond is at the common power-entry point on the Power Module,
     immediately before the eFuse.
   - This location is downstream of the source-selection / OR-ing stage, so the bond point remains
     correct regardless of whether PoE, USB-C, or battery input is active.

5. **Local board restriction.**
   - All non-Power-Module boards that implement `GND_CHASSIS` must keep that local chassis net
     isolated from signal/power `GND`.
   - Local connector shields, EMI landing pads, and mounting features may join the chassis domain,
     but they must not create a second DC bond.

### Rationale

- Gives enclosure-connected boards the same grounding rule when viewed in isolation.
- Preserves the legitimate exemption for internal hat/daughterboard modules.
- Makes mounting-hole treatment consistent across all PCB designs.
- Preserves the EMC intent of using the enclosure as the transient/shield return path.
- Keeps the single-point bond at the best location for all input-source combinations.

### Supersession / Obsolescence

- **DEC-023** remains valid as the concrete JDB instance of the daughterboard exemption.
- Earlier wording in the Global Routing Spec that left the exemption implicit and under-specified is
  obsolete.

### Impact

- Update `design/Standards/Global_Routing_Spec.md` to make the enclosure-connected-board rule and
  daughterboard exemption explicit.
- Add or revise grounding cross-references in every board-level `Design_Spec.md` so the single-bond
  rule is visible even when a board spec is read on its own.
- Keep the Power Module documentation explicit that the single bond is located at the common
  power-entry point immediately before the eFuse.

### Cross-ref

DEC-020, DEC-023, DEC-038, `design/Standards/Global_Routing_Spec.md §4-§5`,
`design/Standards/Certification_Evidence.md §2.2`.
