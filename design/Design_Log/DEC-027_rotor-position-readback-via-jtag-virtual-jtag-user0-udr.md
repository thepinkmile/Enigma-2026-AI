## DEC-027 - Rotor Position Readback via JTAG Virtual JTAG (USER0 UDR)

- **Status:** Accepted
- **Date:** 2026-04-12
- **Category:** Hardware / Firmware
- **Area:** Rotor Board CPLD - JTAG Interface; GUI App position display

### Decision

The CPLD on each rotor must expose the **effective rotor position** (STGC-decoded position +
SW1 ring offset, mod N) via **Intel Virtual JTAG** (Altera `VIRTUAL_JTAG` megafunction,
USER0 instruction) over the existing JTAG serial chain. This allows the CM5/JDB to read back
all 30 rotor positions in a single JTAG scan pass without consuming any additional PCB pins or
signal routing.

The effective position register is 6 bits wide (covers both variants; 26-char variant uses
bits [4:0], bit [5] = 0). The CPLD VHDL must instantiate the `VIRTUAL_JTAG` megafunction and
connect the effective position register to the user data register (UDR). Cipher substitution
operates continuously and independently of JTAG state.

### Rationale

- **Standard IEEE 1149.1 BSCAN cannot access internal registers:** Boundary scan (EXTEST/SAMPLE)
  captures I/O pin states only. The effective position is an internal CPLD register result and
  would require dedicated output pins to be visible via standard BSCAN.
- **Virtual JTAG avoids pin consumption:** The existing JTAG chain (TCK, TMS, TDI, TDO/TTD)
  is already routed through all 30 rotors. No additional pins, traces, or connectors are needed.
- **FT232H on JDB supports arbitrary JTAG instructions:** The JDB FT232H (in MPSSE mode) can
  issue the USER0 JTAG instruction to any device in the chain and clock out the UDR contents.
  The CM5 software can therefore poll all 30 positions by iterating through the chain.
- **GUI App feedback requires position data:** The GUI App Design_Spec requires real-time display
  of rotor positions. Virtual JTAG is the only defined data path from rotor CPLDs to the CM5 for
  this purpose - no I²C, SPI, or dedicated signal lines exist between the rotors and the CM5.
- **Non-intrusive to cipher operation:** The `VIRTUAL_JTAG` megafunction is fully synchronous
  with the JTAG clock domain and does not gate or interrupt the cipher substitution logic running
  on the CPLD system clock.

### Impact

- `design/Electronics/Rotor/Design_Spec.md`: FR-ROT-09 to be added (CPLD exposes effective
  position via JTAG USER0 UDR; 6-bit register; readable without interrupting cipher function).
  Note to be added in §2.2 or §3.3 cross-referencing Virtual JTAG and GUI App.
- `design/Software/GUI_App/Design_Spec.md`: Cross-reference to DEC-027 and JTAG readback path
  to be added when GUI App position-display feature is specified.
- CPLD VHDL (future): Must instantiate `VIRTUAL_JTAG` megafunction and connect effective
  position register. Scan sequence: JDB issues USER0; shifts 6-bit UDR from each of 30 rotors
  serially (180 bits total per full scan).
- `design/Electronics/JTAG_Daughterboard/Design_Spec.md`: FT232H MPSSE mode already specified;
  no hardware change required. Software driver must add USER0 scan sequence.
