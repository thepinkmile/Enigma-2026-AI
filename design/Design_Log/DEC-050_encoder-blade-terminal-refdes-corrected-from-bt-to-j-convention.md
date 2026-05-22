## DEC-050 - Encoder Blade Terminal RefDes Corrected from BT to J Convention

- **Status:** Active
- **Date:** 2026-05-01
- **Category:** Electrical
- **Area:** Encoder Board

### Decision

The 64 PCB spade blade terminals (Keystone 1285-ST) on the Encoder board have been
renamed from `BT1`-`BT64` to `J3`-`J66`.

### Rationale

`BT` is the IPC/EDA standard reference designator prefix for **batteries**. Using it for
PCB-mount blade/spade terminals was non-standard and created ambiguity with the Controller
board's `BT1` (CR2032 holder). All connectors and interface terminals in this project use
the `J` prefix (connector/jack convention). J1 and J2 are already assigned on the Encoder
board (J1 = plugboard jack sockets off-board, J2 = IDC service connector), so the blade
terminal bank begins at J3.

### Alternatives Considered

- `XT` (external terminal) - used by some EDA conventions but `J` is more widely recognised
  and consistent with all other connector RefDes in this project.
- Retain `BT` - rejected: collides with the IPC battery prefix and conflicts with `BT1` on
  the Controller board.

### Impact

- `design/Electronics/Encoder/Design_Spec.md` - BOM row and §4 interconnects text updated.
- `design/Electronics/Encoder/Board_Layout.md` - signal group table updated.
- `design/Software/CPLD_Logic/Encoder_Logic.md` - all `BT1`-`BT64` references updated.
- `design/Electronics/Consolidated_BOM.md` - Encoder row RefDes updated.
- `design/Datasheets/SaiBuy_Ltd_6p35mm_Mono_Jack_Pseudo_Datasheet.md` - system-level
  wiring notes updated; decode-half now references `J3`-`J66` on the decode Encoder board
  and encode-half references `J3`-`J66` on the encode Encoder board.
