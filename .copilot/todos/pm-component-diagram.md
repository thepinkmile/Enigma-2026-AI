# Todo: Power Module Component Diagram

**ID:** `pm-component-diagram`
**Status:** pending
**Category:** Documentation improvements
**Source:** Session decision — per-board circuit component diagrams
**Blocked by:** —

---

## Description

Add a Mermaid `block-beta` component diagram to the **top of §1** in
`design/Electronics/Power_Module/Design_Spec.md`, immediately after the section heading,
so the diagram is the first thing seen in the Overview section.

## Target File

`design/Electronics/Power_Module/Design_Spec.md`

Insert position: **top of §1 Overview**, after the section heading, before the existing
bullet list and FR/DR tables.

## Blocks to Show

| Block | Description | Key Components |
|-------|-------------|---------------|
| `INPUT_OR` | 3-input OR-ing / UVLO (PoE, USB-C, battery) | U2A/U2B (LMQ61460 gate inputs), OR-ing FETs |
| `EFUSE` | eFuse / inrush / overcurrent protection | U1 (TPS259804ONRGER), R1 (232kΩ), R2 (28.7kΩ), R3 (210Ω) |
| `BUCK_5V` | Dual-phase interleaved 5V buck | U2A/U2B (LMQ61460AFSQRJRRQ1) |
| `LDO_3V3` | 3.3V LDO (3V3_ENIG) | U7 (TPS75733) |
| `SUPERCAP` | Supercapacitor charger / UPS core | U3 (LTC3350EUHF), C_SC1–C_SC8 (8× 25F/2.7V) |
| `POE_IN` | PoE auxiliary input connector | J2 (TE 10-pos, receives VIN_POE_12V from CTL) |
| `USB_PD` | USB-C PD input | J4, U6 (STUSB4500QTR) |
| `BATT_IN` | Smart-battery input | J5 |
| `INA_5V` | 5V_MAIN current/voltage telemetry | U10 (INA219AIDR @ 0x40), R16 (10mΩ shunt) |
| `I2C_EXP` | I²C GPIO expander (virtualised PM status) | U14 (PCA9534APWR @ 0x3F) |
| `MONO_TIMER` | Monostable shutdown timer | U13 (MIC1555), Q5, R21, R22, C36, C40 |
| `RAIL_SUP` | Rail supervisor (PWR_GD) | U8 (MCP121T-450E) |
| `SW2_BTN` | Manual CM5 power button | SW2 (PWR_BUT_N) |
| `CTL_DOCK` | Controller dock connectors | J1 (rails out), J2 (PoE aux in), J3 (I2C/control) |

## Connections / Edges

| Edge | Label |
|------|-------|
| POE_IN → INPUT_OR | VIN_POE_12V |
| USB_PD → INPUT_OR | VBUS (negotiated) |
| BATT_IN → INPUT_OR | VBATT |
| INPUT_OR → EFUSE | Protected VIN |
| EFUSE → BUCK_5V | VIN_CLEAN |
| EFUSE → LDO_3V3 | VIN_CLEAN |
| BUCK_5V → SUPERCAP | 5V_MAIN (charge path) |
| SUPERCAP → CTL_DOCK | 5V_MAIN (J1) |
| LDO_3V3 → CTL_DOCK | 3V3_ENIG (J1) |
| BUCK_5V → INA_5V | 5V_MAIN sense |
| INA_5V → CTL_DOCK | I²C telemetry (J3) |
| I2C_EXP → CTL_DOCK | I²C (J3) |
| MONO_TIMER → CTL_DOCK | PWR_BUT_N (J3) |
| RAIL_SUP → CTL_DOCK | PWR_GD (J3) |
| SW2_BTN → CTL_DOCK | PWR_BUT_N (J3) |
| SUPERCAP → MONO_TIMER | Backup-mode trigger |

## Mermaid Type

Use `block-beta`. Suggested layout: input sources on the left, power conditioning in the
centre, output/dock on the right, telemetry/control as a lower block.

## Notes

- Board stackup: 6-layer / 2oz (JLC06161H-2116).
- The PoE front-end is physically on the Controller Board, not the Power Module. The PM
  receives a regulated PoE-derived auxiliary feed from CTL via J2 — reflect this correctly.
- Do NOT show individual pin assignments — block-level connections only.
- Verify all refdes against `Power_Module/Design_Spec.md` BOM section before implementing.
