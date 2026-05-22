# Electrical Design Requirements

**Status:** Reference
**Version:** v.0.1.0
**Last Updated:** 2026-04-19

## 1. Component Rules (The "Museum-Grade" Standard)

* **Dielectric:** **X7R** for all ceramic capacitors (Strictly no Y5V or Z5U).
* **Derating:** **2.5x Voltage rating** for all power capacitors (e.g., 50V caps on 15V rails).
* **Tolerance:** **1% precision resistors** for eFuse ladders and INA219 current-sense shunts.
* **Vias:** **Teardrops** on all signal/power vias; **0.3mm drill** standard; **VIPPO (Via-In-Pad)** for high-density CM5/eFuse pads to prevent solder wicking.

## 2. I2C Bus Address Table

| I2C Address | Device | Module | Function |
| :--- | :--- | :--- | :--- |
| 0x09 | LTC3350 | Power Module | Supercap charger / health monitor |
| 0x0B | Smart Battery | Power Module | Smart battery / SMBus monitor |
| 0x28 | STUSB4500 | Power Module | USB-C PD Controller |
| 0x3F | PCA9534A | Power Module | PM-local GPIO expander (`POE_STAT`, `SYS_FAULT`, `BATT_PRES_N`, `USB_STAT`, SW1 RGB control) |
| 0x40 | INA219 | Power Module | 5V_MAIN current/power monitoring (10mΩ Kelvin-sense shunt R16) |
| 0x20 | MCP23017 | Stator | ENC monitor expander (`U6`) |
| 0x21 | MCP23017 | Stator | Virtual keypress / SOURCE_SEL / CPLD_RESET_N expander (`U7`) |
| 0x22 | MCP23017 | Stator | CPLD configuration output expander (`U8`) |
| 0x23 | MCP23017 | User Settings Module | Switch input expander (`U1`) |
| 0x24 | MCP23017 | User Settings Module | Bank 1 LED controller (`U2`) |
| 0x25 | MCP23017 | User Settings Module | Bank 2 LED controller (`U3`) |
| 0x45 | INA219 | Stator | Rotor stack power telemetry (CSS2H-2512R-R010ELF 10mΩ shunt R1) |

> **Note:** This document captures global electrical design rules. Board-specific design rules are in each board's Design_Spec.md.
> Full design decision history: See `design/Design_Log/index.md`.
