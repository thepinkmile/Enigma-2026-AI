# Todo: Rotor Board Component Diagram

**ID:** `rotor-component-diagram`
**Status:** pending
**Category:** Documentation improvements
**Source:** Session decision — per-board circuit component diagrams
**Blocked by:** —

---

## Description

Add a Mermaid `block-beta` component diagram to the **top of §1** in
`design/Electronics/Rotor/Design_Spec.md`, immediately after the section heading, before
the existing overview prose and variant references.

The Rotor is a two-PCB assembly (Board A + Board B), so the diagram must clearly show both
boards and how they connect via the inter-board headers.

## Target File

`design/Electronics/Rotor/Design_Spec.md`

Insert position: **top of §1 Overview**, after the heading.

## Blocks to Show

**Board A (input side):**

| Block | Description | Key Components |
|-------|-------------|---------------|
| `CPLD_A` | Encryption CPLD — scrambling/de-scrambling logic | U1 (EPM570T100I5N or EPM240T100) |
| `ENC_TRACK_A` | Track A capacitive encoder (Ø92mm PCB face) | U2 (FDC2114), 3 sense electrodes |
| `SW_RING` | Ring setting DIP switch | SW1 |
| `SW_FWD` | Forward map select DIP switch | SW2 |
| `IN_CONN` | Input BtB connectors from Stator / upstream | J1 (ERM8-005 JTAG in), J2 (ERM8-005 Power in), J3 (ERM8-010 ENC in) |
| `INTER_HDR` | Inter-board headers (Board A → Board B) | J7 (1×5), J8 (1×5), J9 (1×5), J10 (1×7) |

**Board B (output side):**

| Block | Description | Key Components |
|-------|-------------|---------------|
| `ENC_TRACK_B` | Track B capacitive encoder (64-char variant only) | U11B (FDC2114, DNF for 26-char variant) |
| `SW_RET` | Return map select DIP switch | SW3 |
| `OUT_CONN` | Output BtB connectors to next rotor / Extension / Reflector | J4 (ERF8-005 JTAG out), J5 (ERF8-005 Power out), J6 (ERF8-010 ENC out) |

## Connections / Edges

| Edge | Label |
|------|-------|
| IN_CONN → CPLD_A | JTAG, ENC_IN[5:0], TTD |
| IN_CONN → ENC_TRACK_A | 3V3_ENIG (power) |
| CPLD_A → OUT_CONN | ENC_OUT[5:0], JTAG passthrough, TTD |
| ENC_TRACK_A → CPLD_A | Gray code position [5:0] |
| INTER_HDR → ENC_TRACK_B | I²C, 3V3_ENIG (Board A → Board B) |
| ENC_TRACK_B → INTER_HDR | Gray code position (return) |
| SW_RING → CPLD_A | Ring offset setting |
| SW_FWD → CPLD_A | Forward map select |
| SW_RET → OUT_CONN (via INTER_HDR) | Return map select |
| INTER_HDR → OUT_CONN | JTAG chain, ENC signals |

## Mermaid Type

Use `block-beta` with two sub-groups: one for Board A and one for Board B, connected by
the inter-board header block.

```
block-beta
  block boardA["Board A (Input)"]
    IN_CONN
    CPLD_A
    ENC_TRACK_A
    SW_RING
    SW_FWD
    INTER_HDR
  end
  block boardB["Board B (Output)"]
    ENC_TRACK_B
    SW_RET
    OUT_CONN
  end
  INTER_HDR --> ENC_TRACK_B
  ...
```

## Notes

- Board stackup: 4-layer / 2oz (JLC04161H-7628) for both Board A and Board B.
- The aluminium shroud is **electrically floating** — do NOT show it in the diagram.
- 26-char variant: U11B (Track B FDC2114) is DNF; 64-char variant: U11B populated.
  The diagram should show ENC_TRACK_B with a note `(64-char only, DNF on 26-char)`.
- Do NOT show individual pin assignments — block-level connections only.
- Verify all refdes against `Rotor/Design_Spec.md` and the variant sub-specs before implementing.
- See also: `Rotor/Rotor_26_Char_Design.md` and `Rotor/Rotor_64_Char_Design.md`.
