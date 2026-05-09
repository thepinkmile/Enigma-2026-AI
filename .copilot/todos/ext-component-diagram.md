# Todo: Extension Board Component Diagram

**ID:** `ext-component-diagram`
**Status:** pending
**Category:** Documentation improvements
**Source:** Session decision — per-board circuit component diagrams
**Blocked by:** —

---

## Description

Add a Mermaid `block-beta` component diagram to the **top of §1** in
`design/Electronics/Extension/Design_Spec.md`, immediately after the section heading, before
the existing overview prose and FR/DR tables.

## Target File

`design/Electronics/Extension/Design_Spec.md`

Insert position: **top of §1 Overview**, after the heading and role/capacity bullets.

## Blocks to Show

| Block | Description | Key Components |
|-------|-------------|---------------|
| `IN_CONN` | Input BtB connectors (from upstream rotor group) | J1 (ERM8-005 JTAG in), J2 (ERM8-005 Power in), J3 (ERM8-010 ENC in) |
| `JTAG_BUF` | JTAG signal re-buffer (TCK + TMS) | U1 (SN74LVC2G125DCUR VSSOP-8), C6 (100nF bypass) |
| `ESD_IN` | ESD arrays on input BtB connectors | U2–U5 (TPD4E05U06QDQARQ1) |
| `ESD_OUT` | ESD arrays on output BtB connectors | U6–U9 (TPD4E05U06QDQARQ1) |
| `OUT_CONN` | Output BtB connectors (to downstream rotor group) | J4 (ERF8-005 JTAG out), J5 (ERF8-005 Power out), J6 (ERF8-010 ENC out) |
| `EXT_PORT` | Extension service port (Adam Tech 30-pin) | J7 (input from upstream EXT/STA), J8 (output to downstream EXT/REF) |
| `AM_DOCK` | Actuation Module BtB dock | J9 (Hirose DF40HC-20) |

## Connections / Edges

| Edge | Label |
|------|-------|
| IN_CONN → JTAG_BUF | TCK, TMS (from upstream) |
| IN_CONN → OUT_CONN | TDI, TDO, 3V3_ENIG, ENC pass-through |
| JTAG_BUF → OUT_CONN | TCK_buffered, TMS_buffered (J4 pin 2 / pin 4) |
| EXT_PORT → OUT_CONN | 5V_MAIN power reinjection, TTD_RETURN bridge |
| EXT_PORT → AM_DOCK | ACTUATE_REQUEST_N |
| ESD_IN → IN_CONN | ESD clamping on J1/J3 |
| ESD_OUT → OUT_CONN | ESD clamping on J4/J6 |

## Mermaid Type

Use `block-beta`. Suggested layout: IN_CONN on the left → JTAG_BUF centre → OUT_CONN on
the right; EXT_PORT and AM_DOCK shown as lower blocks.

## Notes

- Board stackup: 4-layer / 2oz (JLC04161H-7628).
- TDI passes through unbuffered (only TCK and TMS are buffered by U1).
- The Extension board carries 3V3_ENIG transparently from J2 (power in) to J5 (power out);
  power reinjection from J7/J8 service port injects additional 5V_MAIN for local actuation.
- Do NOT show individual pin assignments — block-level connections only.
- Verify all refdes against `Extension/Design_Spec.md` BOM section before implementing.
