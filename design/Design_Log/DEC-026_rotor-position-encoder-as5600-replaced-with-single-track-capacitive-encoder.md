## DEC-026 - Rotor Position Encoder: AS5600 Replaced with Single-Track Capacitive Encoder

> ⚠️ Partially superseded by DEC-028 for dual-track N=64 architecture, Ø92mm PCB diameter, and aluminium shroud milled slots. Retained for historical context.

- **Status:** Accepted
- **Date:** 2026-04-12
- **Category:** Hardware
- **Area:** Rotor Board - Position Sensing (§2.1)

### Decision

The AMS AS5600 magnetic encoder (originally specified in DR-ROT-03) is replaced with a
**single-track absolute capacitive encoder** implemented entirely on the rotor PCB. The rotating
shroud flanges carry milled aluminium slots (air gap = low capacitance); K capacitive sensor pads on the PCB read the track
as a K-bit code. A combinational lookup table in the CPLD VHDL maps the raw sensor code to a
binary rotor position (0 to N-1). The SW1 modulo-N adder (ring setting) operates on the decoded
binary value. No external adder hardware is required - the decode and add are pure CPLD logic.

Three **Texas Instruments FDC2114RGHR** footprints are defined across the split rotor pair;
each rotor variant populates two of them:

- U2 (address 0x2A): Track A - bits[5:3] (N=64) or STGC bits[3:0] (N=26).
- U3 (address 0x2B): Board A STGC bit[4] (N=26 only). NOT POPULATED for N=64.
- U4 (address 0x2B): Track B - bits[2:0] (N=64 only). NOT POPULATED for N=26.
- CPLD implements I²C master to read pad states.

#### Track patterns (verified - all N codes unique)

- **26-char (K=5, N=26):** `00000100011001010011101111`
  Sensors at 0°, 13.846°, 27.692°, 41.538°, 55.385° from reference; arc/segment ≈ 10.63mm at r=44mm.
  Invalid codes (between-character / jam): 11, 13, 21, 22, 26, 31.
- **64-char (K=6, N=64):** Replaced by dual-track 3+3 reflected binary Gray code - see `Rotor_64_Char_Design.md §7` and DEC-028.
  Sensors at 0°, 5.625°, 11.25°, 16.875°, 22.5°, 28.125° from reference; arc/segment ≈ 4.32mm at r=44mm.
  All 64 six-bit codes are valid (standard 6-bit reflected binary Gray code; XOR-chain decode; no invalid-code jam detection required).

PCB outer diameter Ø92mm (inside Ø100mm aluminium shroud) - per DEC-028

### Rationale

- **AS5600 incompatible with single-track Gray code intent:** AS5600 is a single-magnet absolute
  angle sensor - it requires a single magnet on the rotating part and returns a 12-bit angle value.
  It does not implement Gray code sensing and was architecturally inconsistent with the original
  design intent stated in §1 ("single-track grey encoder").
- **No magnet pocket on shroud:** The AS5600 requires a diametrically magnetised magnet (~6mm dia)
  embedded in or attached to the rotating shroud, adding manufacturing complexity. The capacitive
  approach requires only milled aluminium slot patterns on the rotating shroud - no embedded components.
- **All sensing electronics on PCB:** Capacitive pads and FDC2114 ICs are standard PCB components.
  The shroud is a passive mechanical part.
- **Reliable at slow rotation rates:** The rotors step at human-typing speed (≤10 char/s). The
  FDC2114 conversion time (~1ms/channel at default rate) is well within the inter-step interval.
- **STGC lookup table consistent across variants:** Both 26-char and 64-char rotors use the
  identical CPLD decode mechanism; only table contents and modulus differ. No firmware
  architecture difference between variants.

### Impact

- `design/Electronics/Rotor/Design_Spec.md`: FR-ROT-02, FR-ROT-08, DR-ROT-03, DR-ROT-09, §1,
  §2.1 (full rewrite), §3.2 I²C note, BOM U2 → FDC2114RGHR, U3 added.
- `design/Electronics/Rotor/Rotor_26_Char_Design.md`: §5 ring setting updated; §6 added
  (geometry, track pattern, STGC→position lookup table).
- `design/Electronics/Rotor/Rotor_64_Char_Design.md`: §5 ring setting updated; §7 added
  (geometry, track pattern, STGC→position lookup table).
- `design/Electronics/Rotor/Board_Layout.md`: ASCII diagram updated; PCB Ø92mm (per DEC-028).
- `design/Electronics/Consolidated_BOM.md`: AS5600 row replaced with 2x FDC2114RGHR per rotor
  (60 units total across 30 rotors).
- `design/Electronics/Reflector/STGC_Generator.py`: Original script location noted - should be
  relocated to `design/Electronics/Rotor/` in a future tidy-up commit.
