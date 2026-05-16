# TODO: tps25751-i2c-review

**ID:** `tps25751-i2c-review`
**Status:** blocked
**Blocked By:** architectural decision required (see Options below)
**Must resolve before:** `interim-electronics-review-1`

---

## Summary

The TPS25751 (Power Module U4) currently operates in **passive NVM mode** with no I2C host-controller (I2Ct) connection. A design review (Pass 10, INT-P10-001) raised the question of whether runtime I2C access for PDO profile adjustment is needed and whether the design correctly accommodates it.

---

## Background

The TPS25751 has **two I2C ports**:

| Port | Role | Default Address |
|:-----|:-----|:----------------|
| **I2Ct** (target) | Host MCU reads status / adjusts PDOs at runtime | Configurable via ADCIN1/ADCIN2 dividers |
| **I2Cc** (controller) | TPS25751 talks to external EEPROM (0x50) and optional battery charger | Fixed 0x50 for EEPROM |

### Current design state

- NVM passive mode: I2Cc drives an external EEPROM at 0x50 (pre-programmed with USB-C PD profile via TI Web Configuration Tool).
- I2Ct pins are **not connected** — TPS25751 is absent from the CTL I2C-1 bus (confirmed DEC-012).

---

## Problem: Address conflict if I2Ct ever needed

TPS25751 I2Ct supports **only 4 selectable addresses** (TPS25751 datasheet Table 8-5, SLVSH93A):

| ADCIN config index | I2Ct address | System bus conflict |
|:-------------------|:-------------|:--------------------|
| #1 | **0x20** | STA U6 (MCP23017) |
| #2 | **0x21** | STA U7 (MCP23017) |
| #3 | **0x22** | STA U8 (MCP23017) |
| #4 | **0x23** | USM U1 (MCP23017) |

**All four possible I2Ct addresses conflict with existing system I2C-1 bus devices.**

### Chicken-and-egg problem

Even if a free address were available:
- The TPS25751 provides 5V USB-C PD power that boots the CM5.
- The CM5 I2C-1 bus is only available **after** CM5 has booted.
- Therefore the CM5 cannot configure the TPS25751 via I2Ct before it has received power from the TPS25751.
- Solution would require connecting I2Ct to a **dedicated CM5 I2C bus** (e.g., I2C-0 or I2C-3), completely separate from the shared system I2C-1 bus.

---

## Options to Evaluate

### Option A: Keep passive NVM mode (current approach)
- PDO profile burned to EEPROM via TI Web Configuration Tool.
- No I2Ct connection needed.
- No address conflict.
- Changing PD profile requires EEPROM re-programming or board rework.
- **Simpler; no wiring changes needed.**

### Option B: Connect I2Ct on a dedicated CM5 I2C bus
- Route a dedicated I2C pair (e.g., CM5 I2C-0) from Controller board to Power Module via PM dock connectors (J1/J2/J3).
- TPS25751 I2Ct address set to whichever of 0x20–0x23 is chosen (all conflict with I2C-1 but are irrelevant on a separate bus).
- CM5 Linux driver (or user-space tool) can adjust PDOs at runtime after boot.
- Requires checking spare wire capacity on J1/J2/J3 dock connectors (currently defined in PM and CTL Design_Specs).
- **More flexible; more complex; connector constraint TBD.**

### Option C: EEPROM pre-config with field-update path
- Retain NVM mode but document a formal EEPROM update procedure (TI Web Tool + SPI/I2C programmer).
- Suitable if PDO profiles are static for the product lifetime.
- **Minimal design change; acceptable for v1.0 if PDO is fixed.**

---

## Actions Required

1. **Decide**: static EEPROM config vs runtime I2C access vs EEPROM with field-update path?
2. If Option B: check spare wire count on J1/J2/J3 PM dock connectors; assign dedicated I2C bus pin assignments.
3. If Option A or C: confirm that the I2Cc EEPROM circuit is fully specified in PM Design_Spec (address 0x50, part number, BOM row).
4. Update PM Design_Spec §5 and CTL §4.1 I2C address table with the chosen approach.
5. Update `INT-P10-001` in `.copilot/review-report.md` from "false positive" to "design decision pending / resolved" status.
6. Add a DEC entry to `design/Design_Log.md` documenting the decision.

---

## References

- TPS25751 datasheet: `design/Datasheets/tps25751-datasheet.md`
  - §8.3.11: I2C interface description
  - Table 8-5 (line ~3611): I2Ct address selection
  - Table 8-6 (line ~3754): ADCIN1/ADCIN2 configuration
- CTL Design_Spec §4.1: I2C address map (note about TPS25751 absence already added)
- DEC-012: original decision to use NVM passive mode
