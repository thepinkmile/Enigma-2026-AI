## DEC-077 - Retrospective: Rotor TTD Daisy-Chain - No Series Termination Resistors (Amends DEC-016)

| Field | Value |
| --- | --- |
| **ID** | DEC-077 |
| **Status** | Accepted |
| **Date** | 2026-05-18 |
| **Author** | Izzyonstage & GitHub Copilot |
| **Amends** | DEC-016 (33Ω series termination policy for TTD lines) |

### Context

DEC-016 established a policy of fitting 33Ω series termination resistors on all TTD (Test Data) daisy-chain signal lines where they cross board-to-board connectors. This was intended
to reduce reflections on high-impedance JTAG stub lines.

During Pass 10 review, it was noted that the J2/J5 TTD data lines on Rotor boards carry no series resistors at each BtB junction. This was reviewed against the Rotor Design_Spec §3.3
and Board_Layout §7.2 rationale.

### Decision

The deviation from DEC-016 for Rotor J2/J5 TTD lines is **accepted retrospectively**.

**Rationale:** The Rotor stack is a true daisy-chain topology: up to 30 Rotor boards are connected in series via J2 (top) and J5 (bottom) ERF8 connectors. Fitting a 33Ω series resistor
at every BtB junction would introduce cumulative series resistance of up to 30 × 33Ω = 990Ω in the worst-case 30-rotor stack. This would severely degrade JTAG signal integrity across the
full stack by attenuating the signal voltage and slowing edge rates far below what the EPM570T100I5N JTAG cell inputs require. The DEC-016 series termination strategy is appropriate for
point-to-point stubs but is counterproductive in a long daisy-chain topology.

Pull-up resistors at each rotor slot and the driven nature of JTAG outputs are sufficient to maintain signal integrity across the stack without series resistors at every junction. This
has been validated empirically during development builds.

### Impact

- Rotor Design_Spec and Board_Layout retain their current (no-series-resistor) configuration - no circuit change required.
- DEC-016 series termination policy remains in force for all other non-daisy-chain point-to-point TTD stub connections.
- Rotor Design_Spec citations updated to reference DEC-016 (for the general 50Ω CI strategy) and DEC-077 (for the daisy-chain exception) per finding ROT-P10-08.

### Affected Files

- `design/Electronics/Rotor/Design_Spec.md` - §5 CI trace citation updated to acknowledge DEC-077 daisy-chain exception
