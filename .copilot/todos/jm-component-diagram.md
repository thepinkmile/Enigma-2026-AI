# Todo: JTAG Module Component Diagram

**ID:** `jm-component-diagram`
**Status:** pending
**Category:** Documentation improvements
**Source:** Session decision — per-board circuit component diagrams
**Blocked by:** —

---

## Description

Add a Mermaid `block-beta` component diagram to the **top of §1** in
`design/Electronics/JTAG_Module/Design_Spec.md`, immediately after the section heading,
before the existing overview prose and FR/DR tables.

## Target File

`design/Electronics/JTAG_Module/Design_Spec.md`

Insert position: **top of §1 Overview**, after the heading.

## Blocks to Show

| Block | Description | Key Components |
|-------|-------------|---------------|
| `BTB_DOCK` | BtB dock connector to Controller Board | J1 (Hirose DF40C-20DP-0.4V(51)) |
| `FT232H` | USB-to-JTAG bridge (USB Blaster II equivalent) | U1 (FT232HL LQFP-48) |
| `CRYSTAL` | 12 MHz USB reference crystal | Y1 (12MHz crystal) |
| `JTAG_BUF` | TCK/TMS output buffer | U2 (SN74LVC2G125DCUR VSSOP-8) |
| `DAMP_R` | Series damping resistors (TDI, TCK, TMS, pre-chain TDI) | R1–R4 (4× 33Ω 0402) |
| `JTAG_HDR` | JTAG output header to Stator JTAG chain entry | J2 (JTAG header) |
| `BYPASS_C` | Per-IC bypass capacitor bank | C1–C9 (8× 100nF + 1× 4.7µF) |

## Connections / Edges

| Edge | Label |
|------|-------|
| BTB_DOCK → FT232H | USB 2.0 D+/D-, 5V_USB, 3V3_ENIG |
| FT232H → CRYSTAL | 12MHz reference |
| FT232H → DAMP_R | TDI (R1 series damp) |
| FT232H → JTAG_BUF | TCK, TMS |
| JTAG_BUF → DAMP_R | TCK (R2), TMS (R3) series damp |
| DAMP_R → JTAG_HDR | TCK, TMS, TDI (series-damped), TDO return, pre-chain TDI (R4) |
| BYPASS_C → FT232H | Decoupling (per supply pin) |

## Mermaid Type

Use `block-beta`. Suggested layout: BTB_DOCK on the left → FT232H centre → JTAG_BUF →
DAMP_R → JTAG_HDR on the right. CRYSTAL and BYPASS_C shown below FT232H.

## Notes

- Board stackup: 4-layer / 2oz (JLC04161H-7628).
- GND_CHASSIS exemption: JM uses M2.5 NPTH clearance holes tied to GND (not GND_CHASSIS)
  per DEC-057. Do not show GND_CHASSIS in the diagram.
- USB is received from the Controller Board via J1 (BtB), not from an external USB connector
  on the JM itself.
- Bulk cap entry bank exemption (GRS §3) applies — JM has per-IC decoupling only.
- The JTAG_HDR output (J2) connects to the Stator J12 (Link-Beta logic dock) JTAG chain.
- Do NOT show individual pin assignments — block-level connections only.
- Verify all refdes against `JTAG_Module/Design_Spec.md` BOM section before implementing.
