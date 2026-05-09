# Todo: Controller Board Component Diagram

**ID:** `ctl-component-diagram`
**Status:** pending
**Category:** Documentation improvements
**Source:** Session decision — per-board circuit component diagrams
**Blocked by:** —

---

## Description

Add a Mermaid `block-beta` component diagram to the **top of §1** in
`design/Electronics/Controller/Design_Spec.md`, immediately after the opening title line
and before any prose. The diagram should show the major functional circuit blocks on the
Controller Board and their connections, giving the reader a visual overview before the
requirement tables.

## Target File

`design/Electronics/Controller/Design_Spec.md`

Insert position: **top of §1 Overview**, after the section heading and any subtitle/intro
line, but before the bullet list and FR/DR tables.

## Blocks to Show

| Block | Description | Key Components |
|-------|-------------|---------------|
| `CM5` | Raspberry Pi Compute Module 5 | U1 (CM5) — Amphenol connectors |
| `POE` | PoE front-end (GbE entry, magnetics, ESD, PoE converter) | J6 (RJ45), T1 (Wurth 750318938), ESD arrays |
| `PM_DOCK` | Power Module dock (Link-Alpha) | J1 (5V_MAIN/3V3_ENIG in), J2 (VIN_POE_12V out), J3 (I2C/control) |
| `STA_DOCK` | Stator dock (Link-Beta) | J4 (power/ENC), J5 (JTAG/I2C logic) |
| `JM_DOCK` | JTAG Module BtB dock | J10 (Hirose DF40C-20) |
| `AM_DOCK` | Actuation Module BtB dock | J11 (Hirose DF40HC-20) |
| `EXT_IO` | External I/O interfaces | J6 (RJ45/GbE), J7 (HDMI), J8 (USB 3.0) |
| `DSI` | DSI1 display FPC connector | J9 (DSI1 4-lane FPC) |
| `RTC` | RTC backup battery circuit | BT1 (CR2032), D1 (BAT54 protection diode) |

## Connections / Edges

| Edge | Label |
|------|-------|
| POE → PM_DOCK | VIN_POE_12V (J2) |
| PM_DOCK → CM5 | 5V_MAIN, 3V3_ENIG (J1) |
| CM5 → STA_DOCK | I²C-1, JTAG, ENC (J4/J5) |
| CM5 → JM_DOCK | USB 2.0, 3V3_ENIG (J10) |
| CM5 → AM_DOCK | ACTUATE_REQUEST_N, 5V_MAIN (J11) |
| CM5 → EXT_IO | GbE, HDMI, USB 3.0 |
| CM5 → DSI | DSI1 4-lane |
| RTC → CM5 | RTC I²C / VBAT |
| POE → EXT_IO | GbE (J6) |

## Mermaid Type

Use `block-beta`. Group left-hand side (external interfaces: EXT_IO, DSI, POE) → central CM5
block → right-hand side (docks: PM_DOCK, STA_DOCK, JM_DOCK, AM_DOCK) and bottom (RTC).

## Notes

- Board stackup: 6-layer / 2oz (JLC06161H-2116) — only board in the system on 6-layer.
- Do NOT show individual pin assignments — block-level connections only.
- Verify all refdes against `Controller/Design_Spec.md` BOM section before implementing.
- Reference `Controller/Board_Layout.md` for physical groupings.
