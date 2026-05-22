## DEC-081 - Retrospective: Rotor TTD No-Series-Resistor Policy (In Addition to DEC-016)

- **Status:** Decided
- **Date:** 2026-05-18
- **Category:** Electrical / Signal Integrity
- **Area:** Rotor Board (all variants) — TTD chain
- **Author:** Izzyonstage & GitHub Copilot

### Summary

Formally ratify that the Rotor Board TTD path carries no 33 Ω series resistor at each
board-to-board hop. The Rotor was originally omitted from DEC-016's scope; this entry
records the no-series-resistor policy as a deliberate architectural decision and explicitly
exempts the Rotor from DEC-016's 33 Ω BtB driving rule.

### Context

DEC-016 mandates 33 Ω series resistors at every intra-board or BtB-driving JTAG output to
match 50 Ω PCB trace impedance. Its Area list covers Controller, Stator, Encoder, Reflector,
Extension, and JDB. The Rotor Board was not included in DEC-016's scope — this was an omission
in the original DEC, not a deliberate exclusion. This entry is raised retrospectively to close
that gap and place the Rotor's TTD policy on the same formal footing as all other boards.

### Decision

The Rotor Board TTD path carries **no series resistor** at each rotor-hop BtB interface
(`TTD` exits the CPLD directly to J4 pin 6 with no intervening 33 Ω component). The Rotor
Board is explicitly **exempt** from DEC-016's 33 Ω BtB driving rule.

End-of-chain damping is provided exclusively by the **Reflector Board's single 22 Ω R1** on
`TTD_RETURN`, and cable-driving damping is reserved for the Stator and Encoder ribbon-port
interfaces as per DEC-016.

### Rationale

A full stack contains up to 30 Rotor boards in a direct-mated ERM8/ERF8 BtB chain. Applying
DEC-016's 33 Ω per-hop rule to this chain would introduce up to 30 × 33 Ω ≈ 990 Ω of
cumulative series impedance on the TTD signal path. This would severely degrade signal levels
at the chain terminus and render the JTAG path non-functional. End-of-chain damping at the
Reflector is the architecturally correct approach for a stacked direct-mated topology.

### In Addition To

- **DEC-016** — this entry extends DEC-016's coverage to explicitly include the Rotor Board
  with an exempt status. All other DEC-016 decisions and rules remain unaffected.
