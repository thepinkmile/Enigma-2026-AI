## DEC-078 - CPLD_RESET_N Stator Buffer: BSS138 N-Channel MOSFET (New Decision; References DEC-077)

| Field | Value |
| --- | --- |
| **ID** | DEC-078 |
| **Status** | Accepted |
| **Date** | 2026-05-18 |
| **Author** | Izzyonstage & GitHub Copilot |
| **References** | DEC-077 (Rotor daisy-chain topology) |

### Context

The `CPLD_RESET_N` signal is driven by Stator U7 (MCP23017) GPA[7] and propagates to all 30 Rotor boards via the daisy-chain topology described in DEC-077. Each Rotor board has a
10kΩ pull-up resistor on its local `CPLD_RESET_N` line to `3V3_ENIG`.

With up to 30 pull-up resistors in parallel on the same net, the total sink current the MCP23017 GPA[7] GPIO output must absorb when asserting `CPLD_RESET_N` LOW scales linearly with
the number of installed rotors:

| Rotors | Pull-up current per rotor | Total GPIO sink current |
| --- | --- | --- |
| 5 | 3.3V / 10kΩ = 330µA | 1.65 mA |
| 10 | 330µA | 3.30 mA |
| 15 | 330µA | 4.95 mA |
| 20 | 330µA | 6.60 mA |
| 25 | 330µA | 8.25 mA |
| 30 | 330µA | 9.90 mA |

The MCP23017 datasheet specifies an IOL (output low sink current) of 8 mA per I/O pin (MCP23017 datasheet §1.0 Electrical Characteristics, IOL parameter). A 30-rotor full stack would
therefore require 9.90 mA - exceeding the per-pin IOL specification by 24%. This is an overload condition that could damage U7 GPA[7] or produce an unreliable reset assertion (Vout(L)
rising above the guaranteed LOW threshold).

### Decision

A BSS138 N-channel MOSFET buffer is added to the Stator board as new reference designator **Q1** on the `CPLD_RESET_N` line:

- **Gate:** Connected to Stator U7 GPA[7] via a 100Ω gate resistor (new reference designator **R39**).
- **Drain:** Connected to the `CPLD_RESET_N` net (which routes to all Rotor boards via J10 pin 15).
- **Source:** Connected to GND.
- **Operation:** When GPA[7] drives HIGH, Q1 turns ON and pulls `CPLD_RESET_N` LOW (asserted). When GPA[7] drives LOW, Q1 turns OFF; the 10kΩ pull-ups on each Rotor board pull `CPLD_RESET_N` HIGH (deasserted).
- **GPIO current:** With the buffer, GPA[7] drives only the gate of Q1 - gate leakage < 1µA, well within MCP23017 IOL specification regardless of stack size.
- **MOSFET selection:** BSS138 (Nexperia) - already in the Enigma-NG library and used on Power Module (Q4-Q11) and User Settings Module (Q1-Q18). VGS(th) = 0.8-1.5V; RDS(on) = 3.5Ω
  at VGS = 1.8V. With a 3.3V gate drive the device is fully enhanced; VDS(on) at 9.9 mA = 9.9mA × 3.5Ω ≈ 35mV - well within logic LOW threshold for all downstream CPLD inputs.

Each Rotor board retains its existing 10kΩ pull-up resistor on `CPLD_RESET_N`. No change to Rotor boards is required.

### Impact

- `design/Electronics/Stator/Design_Spec.md` - Add new DR for Q1 buffer; add Q1 and R39 to BOM; update U7 GPA[7] usage note.
- `design/Electronics/Stator/Board_Layout.md` - Add Q1/R39 placement note.

### Affected Files

- `design/Electronics/Stator/Design_Spec.md` - Q1 (BSS138), R39 (100Ω gate resistor) added; new DR; U7 GPA[7] note updated
- `design/Electronics/Stator/Board_Layout.md` - Q1/R39 placement and routing note added
