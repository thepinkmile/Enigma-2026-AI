# Todo: Encoder Module Component Diagram

**ID:** `enc-component-diagram`
**Status:** pending
**Category:** Documentation improvements
**Source:** Session decision — per-board circuit component diagrams
**Blocked by:** —

---

## Description

Add a Mermaid `block-beta` component diagram to the **top of §1** in
`design/Electronics/Encoder/Design_Spec.md`, immediately after the section heading, before
the existing overview prose and role list.

## Target File

`design/Electronics/Encoder/Design_Spec.md`

Insert position: **top of §1 Overview**, after the heading and before the role bullet list.

## Blocks to Show

| Block | Description | Key Components |
|-------|-------------|---------------|
| `CPLD` | Encryption/IO CPLD — role-specific image determines board function | U1 (EPM570T100I5N TQFP-100) |
| `IDC_CONN` | 20-pin IDC data-link connector (shared data + JTAG + power) | J1 (20-pin 2×10 IDC) |
| `SPADE_BANK` | 64-line passive spade terminal bank | 64 spade terminals |
| `PULL_NETS` | Pull-up / pull-down configuration network | Resistor network per variant |

## Connections / Edges

| Edge | Label |
|------|-------|
| IDC_CONN → CPLD | ENC_DATA[5:0], ENC_ACTIVE_N, JTAG chain, 3V3_ENIG |
| CPLD → SPADE_BANK | 64 logic lines (encoded/decoded character mapping) |
| PULL_NETS → CPLD | Role-select pull-ups / pull-downs |
| SPADE_BANK → SPADE_BANK | NC contact (identity map when no patch cable) |

## Mermaid Type

Use `block-beta`. The board is simple: IDC_CONN on the left, CPLD centre, SPADE_BANK on
the right. PULL_NETS shown as a small block below CPLD.

## Notes

- Board stackup: 4-layer / 2oz (JLC04161H-7628).
- The same PCB is reused in six system roles (`KBD_ENC`, `LBD_DEC`, `PLG_PASS1_DEC`,
  `PLG_PASS1_ENC`, `PLG_PASS2_DEC`, `PLG_PASS2_ENC`). Role is determined by the CPLD
  image, not by connector rewiring. Include a note: "Board role = programmed CPLD image."
- For plugboard use: a PLG_DEC and PLG_ENC module pair are connected via the 64-spade
  banks with patch cables. Without a cable, normally-closed spade contacts preserve identity
  mapping. Show this in a note if the diagram permits.
- Do NOT show individual pin assignments — block-level connections only.
- Verify all refdes against `Encoder/Design_Spec.md` BOM section before implementing.
