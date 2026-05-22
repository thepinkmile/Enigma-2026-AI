## DEC-016 - JTAG Controlled Impedance and Series Termination

- **Status:** ✔ ADOPTED
- **Date:** 2026-04-05
- **Category:** Electrical
- **Area:** Controller Board, Stator Board, Encoder Board, Reflector Board (noted), Extension Board (noted)

### Decision

All JTAG signal traces on 4-layer and 6-layer PCBs are specified at **50 Ω controlled impedance**
(0.127 mm / 5 mil trace width on outer layers over a contiguous GND plane). Series termination
resistors are added at every cable-driving JTAG output using **75 Ω** (to match the ~100 Ω
impedance of alternating-GND IDC ribbon cable), and at every intra-board or BtB-driving JTAG output
using **33 Ω** (to match the 50 Ω PCB trace impedance).

Full signal-swing analysis confirms the destination CPLD receives full logic swing (3.3 V) in all
cases. The open-circuit reflection at the high-impedance CPLD input doubles the incoming wave back
to full voltage; the series resistor controls the return reflection, not the final voltage.

### Full analysis, all options considered, and trace width calculations

See `design/Electronics/Investigations/JTAG_Integrity.md`.

### Summary of additions per board

| Board | Refs | Value | Purpose |
| :--- | :--- | :--- | :--- |
| Controller | R4, R5, R6 | 33 Ω 0603 | ~~TCK / TMS / TDI series R after 74LVC2G125 buffer, before LINK-BETA~~ **Moved to JDB - see DEC-024** |
| Stator | R7-R9 | 75 Ω 0603 | TCK → J4 / J5 / J6 encoder port outputs |
| Stator | R10-R12 | 75 Ω 0603 | TMS → J4 / J5 / J6 encoder port outputs |
| Stator | R13-R15 | 75 Ω 0603 | TDI chain drive: Stator CPLD TDO→J4, J4 return→J5, J5 return→J6 |
| Encoder | R7 | 33 Ω 0402 | CPLD1 TDO → CPLD2 TDI (intra-board, match 50 Ω PCB trace) |
| Encoder | R8 | 75 Ω 0402 | CPLD2 TDO → J2 connector (ribbon cable drive back to Stator) |
| JDB | R6, R7, R8 | 33 Ω 0402 | TCK / TMS (after U5 buffer) / TDI series damping - before J2 JTAG header |

> **Update (detailed design):** U5 (SN74LVC2G125DCUR buffer) and series damping resistors relocated
> from Controller to JDB during detailed design. LINK-BETA is confirmed as a direct Board-to-Board
> connector (no cable), so 33 Ω series damping applies throughout (not 75 Ω cable-driving rule).
> Controller JTAG lines (TCK, TMS, TDI, TTD_RETURN, VREF) are pass-through - routed directly from
> JDB hat-header to LINK-BETA without active components. See DEC-024.

**Trace width rule added to all 4-layer and 6-layer boards:** 0.127 mm (5 mil) for all JTAG signal
traces on outer layers over a GND plane.

**2-layer boards (Reflector, Extension):** Controlled impedance not practical - 50 Ω would require
a 2.82 mm trace (see `design/Electronics/Investigations/JTAG_Integrity.md §4`). Series termination at cable-driving ends of adjacent
boards provides sufficient protection. Existing Reflector R1 (22 Ω) retained as end-of-chain damping.

> **Superseded (partial):** The Reflector and Extension 2-layer limitations above are superseded by
> DEC-017, which upgrades both boards to 4-Layer JLC04161H-7628. Both boards now have a solid L2 GND
> plane and route JTAG on L1 at 0.127 mm (50 Ω), consistent with all other 4-layer boards.

### Rationale

Achieving 100 Ω PCB traces (to perfectly match the IDC ribbon cable impedance) is physically
impossible on JLCPCB standard 4-layer/6-layer stackups - the required trace width is negative
(see calculation in `design/Electronics/Investigations/JTAG_Integrity.md §4`). The 50 Ω + 75 Ω hybrid approach provides the best
achievable impedance match to the cable while remaining within manufacturing design rules.

### Alternatives Considered

- **No termination (Option A):** Rejected - multiple re-reflections at 10 MHz risk false TCK edges.
- **50 Ω PCB + 33 Ω series R (Option B):** Acceptable but leaves 33% reflection at PCB-to-cable
  transition unabsorbed.
- **100 Ω PCB + 82 Ω series R (Option C, ideal):** Rejected - not achievable on standard stackup.

### Cost Impact

Additional BOM cost per full system < £0.05. No JLCPCB impedance certification required for
prototype; trace widths self-calculated and within ±10% of target. See `design/Electronics/Investigations/JTAG_Integrity.md §9`.
