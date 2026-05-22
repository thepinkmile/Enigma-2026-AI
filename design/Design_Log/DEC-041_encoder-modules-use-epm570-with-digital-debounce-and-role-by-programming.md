## DEC-041 - Encoder Modules Use EPM570 with Digital Debounce and Role-by-Programming

- **Status:** Decided
- **Date:** 2026-04-26
- **Category:** Electrical / Logic architecture
- **Area:** Encoder Module hardware, CPLD logic partitioning, manufacturing standardisation
- **Author:** Izzyonstage & GitHub Copilot

### Summary

Standardise all six Encoder Modules on the **Intel MAX II `EPM570T100I5N`** and move encode-role
input debouncing from external per-line RC networks into the CPLD logic. The Encoder PCB remains a
single universal board; role is selected by the programmed CPLD image rather than by role-specific
passive population or local switches.

### Problem

The prior Encoder direction left the active design in a fragmented state:

- Encoder boards were the only active MAX II boards still specified around the smaller `EPM240`
  device while Rotor and Stator already used `EPM570`
- encode-role boards required a large role-specific RC population (`64 x 10 kΩ` + `64 x 100 nF`)
  even though the same PCB was intended to stay generic
- role-identifying population differences made bulk manufacturing and board identification less
  robust than a single common programmable hardware standard
- the active docs described hardware debounce even though the new universal-board direction benefits
  from logic-side filtering and future LE headroom

That combination increased BOM complexity and left less architectural margin for future Encoder-side
logic work.

### Decision

1. **All Encoder Modules use `EPM570T100I5N`.**
   - The Encoder `U1` device is upgraded from `EPM240T100I5N` to `EPM570T100I5N`.
   - Encoder, Rotor, and Stator now share the same active MAX II CPLD part number.

2. **Encode-role debounce moves into CPLD logic.**
   - Active board designs must not rely on the former external per-line RC debounce network as the
     primary debounce method.
   - The active logic architecture uses sampled digital filtering of the 64-line input bank.
   - Debounce tuning is intentionally left prototype-adjustable in the logic specification until the
     first hardware is available for measurement.

3. **Role is selected by programming, not by board switches or role-only passives.**
   - The Encoder PCB remains physically generic.
   - Encode-vs-decode behaviour is selected by the CPLD image loaded onto the board based on its
     known JTAG-chain position.
   - No local role strap, DIP switch, jumper shunt, or role-specific RC population is part of the
     active design.

4. **One common on-board BOM applies to all six Encoder PCBs.**
   - Role-specific behaviour comes from the programmed image and the off-board assembly wiring only.
   - Keyboard switches and plugboard jacks remain assembly-level differences, but the fitted Encoder
     PCB itself is standardised.

5. **Detailed Encoder logic requirements are owned in software-side CPLD logic documentation.**
   - The functional requirements for sampled debounce, 64-to-6 encoding, and 6-to-64 decoding are
     captured in `design/Software/CPLD_Logic/Encoder_Logic.md`.
   - Board-level Encoder docs remain authoritative for interfaces, BOM, and physical architecture,
     while the new logic doc becomes the implementation reference for later VHDL work.

### Rationale

- Removes a large quantity of role-specific passives from the system BOM and assembly flow.
- Gives the Encoder design more LE margin for debounce, diagnostics, and later feature growth.
- Aligns all active MAX II boards to one stocked CPLD family member.
- Preserves the single-universal-board goal without needing field-settable switches on the PCB.
- Keeps prototype tuning in programmable logic rather than freezing debounce behavior in passives
  before first-board measurement exists.

### Supersession / Obsolescence

- Any active Encoder-board wording that defines **external per-line RC debounce** as the required
  debounce mechanism is superseded by this decision.
- Any active Encoder-board wording that defines **`EPM240T100I5N`** as the required Encoder CPLD is
  superseded by this decision.
- Earlier generic-board assumptions that implied role-specific fitted passive populations are
  obsolete as active manufacturing guidance.

### Impact

- Update `design/Electronics/Encoder/Design_Spec.md` and `design/Electronics/Encoder/Board_Layout.md`
  to replace the `EPM240` / external-RC assumptions with `EPM570` / digital-debounce wording.
- Add `design/Software/CPLD_Logic/Encoder_Logic.md` as the implementation-facing logic
  requirements document for later VHDL development.
- Update BOM, board overview, power-budget, certification, and GUI-planning docs so the Encoder
  boards are counted as `EPM570` devices and no longer imply a role-specific RC population.

### Cross-ref

DEC-016, DEC-035, `design/Electronics/Encoder/Design_Spec.md`,
`design/Electronics/Encoder/Board_Layout.md`,
`design/Software/CPLD_Logic/Encoder_Logic.md`.
