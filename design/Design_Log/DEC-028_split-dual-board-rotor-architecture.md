## DEC-028 - Split dual-board rotor architecture

- **Status:** Accepted
- **Date:** 2026-04-14
- **Category:** Hardware
- **Area:** Rotor Board - Physical Architecture; PCB Assembly; Position Encoder

### Decision

The rotor is split into two circular PCBs (Board A input side, Board B output side), each
Ø92mm, connected by four single-row 2.54mm THT headers (H_SW3 1x7, H_PWR 1x5, H_JTAG 1x5,
H_SENS 1x5; 22 pins total; mixed gender for physical keying). This resolves the
JLCPCB single-side SMT assembly constraint and simultaneously defines the rotor physical
thickness (~15mm with an 11.8mm board gap). Board A carries the CPLD (U1 EPM570T100I5N),
FDC2114 U2 (Track A encoder, bits[5:3] for N=64 or all 5 sensors for N=26), SW1 (ring
setting DIP), SW2 (forward map select DIP), and J1-J3 (ERM8 male, input side). Board B
carries FDC2114 U3 (Track B, bits[2:0], N=64 only - not populated for N=26), SW3 (return
map select DIP), and J4-J6 (ERF8 female, output side). These internal headers are manually
assembled post-JLCPCB SMT pick-and-place.

The aluminium shroud (Ø100mm outer, 4mm radial wall → Ø92mm inner) floats electrically,
retained by rolling-pin style cylindrical bearings with ceramic or nylon rolling elements for
electrical isolation. Gray code position slots are milled into the inner faces of the shroud
flanges (dish side for Track A / Board A; cover side for Track B / Board B). Bare copper
electrode pads on the PCB flat face at r≈44mm sense the pattern capacitively via FDC2114.

For N=64 the encoder is a dual-track 3+3 bit standard reflected Gray code (6-bit), giving
zero multi-bit transitions including wrap-around (position 63→0). The CPLD decodes via XOR
chain (G2B). For N=26 all 5 STGC sensor electrodes remain on Board A; U4 on Board B is not
populated.

### Rationale

- JLCPCB only performs SMT assembly on one side per PCB; splitting the board places all SMT
  components on the outward-facing side of each board, making both boards fully JLCPCB
  assemblable without manual rework of back-side SMT.
- The ~15mm rotor thickness matches original Enigma rotor proportions.
- The split enables a dual-track capacitive encoder (3+3 bits), achieving a perfect 6-bit
  reflected Gray code for N=64 with zero multi-bit transitions at any rotor position including
  the 63→0 wrap. This replaces the de Bruijn STGC approach (which required a lookup table and
  had no wrap-around guarantee).
- The aluminium shroud is passive: no conductive ink, no embedded magnets. Gray code slots are
  milled CNC features on a standard turned-aluminium part. Bearing isolation keeps the shroud
  electrically floating, preventing ground loops and capacitive coupling errors.

### Alternatives Considered

- **Single-board with back-side hand-soldering:** rejected - complex, unreliable, not
  consistent with high-volume JLCPCB assembly.
- **Magnetic encoder on shroud:** rejected - adds active or passive magnetic components to
  the shroud, increasing mechanical complexity and cost.
- **Optical encoder:** rejected - requires more complex shroud features (apertures or
  reflective strips) and additional LED/photodiode components on the PCB inner face.

### Impact

- `design/Electronics/Rotor/Design_Spec.md`: §1 (two-board architecture, Ø92mm PCBs, shroud
  description), §2.1 (rewritten for capacitive encoder with milled shroud flanges), §3.4
  (J_INT internal headers H_SW3/H_PWR/H_JTAG/H_SENS added), BOM split into Board A / Board B, FR/DR updated.
- `design/Electronics/Rotor/Board_Layout.md`: rewritten for Board A and Board B with
  stacking cross-section; all Ø100mm references updated to Ø92mm.
- `design/Electronics/Rotor/Rotor_64_Char_Design.md`: de Bruijn track replaced by 3+3
  dual-track reflected Gray code; XOR-chain decode; geometry updated to r=44mm / Ø92mm.
- `design/Electronics/Rotor/Rotor_26_Char_Design.md`: single-track all-on-Board-A confirmed;
  geometry updated to r=44mm / Ø92mm; U3 not-populated note added.
- `design/Electronics/Consolidated_BOM.md`: J_INT internal headers (H_SW3 PH1-07-UA/RS1-07-G, H_PWR PH1-05-UA/RS1-05-G, H_JTAG PH1-05-UA/RS1-05-G, H_SENS PH1-05-UA/RS1-05-G) added,
  4 headers per rotor assembly (120 total for 30 rotors).
