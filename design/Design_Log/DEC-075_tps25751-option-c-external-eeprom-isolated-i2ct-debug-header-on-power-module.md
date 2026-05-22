## DEC-075 - TPS25751 Option C: External EEPROM + Isolated I2Ct Debug Header on Power Module

**Date:** 2026-05-16
**Status:** Accepted
**Author:** Izzyonstage & GitHub Copilot
**Amends:** PM Design_Spec §5 U4 note (replaces "fixed passive PD emulator / internal NVM" description with SafeMode + external EEPROM architecture)

### Context

The TPS25751 (U4, PM) was previously specified to operate in fixed passive PD emulator mode with no I²C connection, relying on internal ROM default behaviour. This prevented any field
update of the PD source profile and did not use the part's EEPROM-boot capability. Review Pass 10 (INT-P10-001) identified that all four TPS25751 I2Ct addresses (0x20-0x23) conflict with
system I2C-1 bus devices, and that a chicken-and-egg boot dependency would exist if I2Ct were connected to system I2C-1 (the CM5 must boot before it can configure TPS25751, but TPS25751
must present a PD contract before the CM5 can boot).

Three options were evaluated:

- **Option A:** Retain passive mode (no EEPROM, no I²C) - prevents field update; reviewed and rejected.
- **Option B:** Connect I2Ct to system I2C-1 - boot dependency problem; address conflict; reviewed and rejected.
- **Option C (selected):** SafeMode with external EEPROM on isolated I2Cc bus + isolated I2Ct debug header for programming - resolves both issues.

### Decision

Implement **Option C**:

- **ADCIN configuration:** ADCIN1 tied directly to LDO_3V3 (decoded value 7); ADCIN2 tied directly to GND (decoded value 0). This selects **SafeMode** startup with I2Ct address Index #1 = 0x20,
  per TPS25751 §8.3.6 Tables 8-2, 8-5, 8-6. No resistor dividers required. SafeMode is the TI-recommended mode when EEPROM is present (Table 8-6 note); it places TPS25751 in source-only mode
  until configuration is loaded from EEPROM.
- **External EEPROM (U18):** M24512-RDW6TP (STMicroelectronics, 512-Kbit / 64 KB, SO8N, 1.8-5.5V) on U4 I2Cc bus at address 0x50 (E2=E1=E0=GND per M24512 DS6520 §2.3/Table 3). The 64 KB
  capacity satisfies the TPS25751 minimum EEPROM requirement of 36 KB (§8.3.11). Pull-ups R47/R48 (4.7 kΩ to LDO_3V3) on I2Cc SCL/SDA. WC pin tied to GND. 100 nF decoupling C78 per
  DS6520 §2.6.1. **The I2Cc bus is internal to the PM (U4 ↔ U18 only) and is not connected to system I2C-1.**
- **I2Ct debug header (J6):** Würth 61300511121 (5-pin 2.54 mm single-row THT male header) exposing I2Ct_SCL (pin 3), I2Ct_SDA (pin 4), I2Ct_IRQ (pin 5), LDO_3V3 sense/reference
  (pin 2, do not source current), GND (pin 1, square pad). Pull-ups R49/R50 (4.7 kΩ to LDO_3V3) on I2Ct SCL/SDA. **J6 is not connected to system I2C-1** - the I2Ct address 0x20
  conflict with system I2C-1 is irrelevant by design. U4 remains absent from the system I2C-1 address map.
- **Boot behaviour:** On power-up, TPS25751 loads PD configuration from U18 via I2Cc and enters APP source-only mode. I2Ct is accessible only via J6 for factory initial programming and field profile updates.

### Rationale

SafeMode with external EEPROM provides a field-updateable PD profile without any boot dependency on the CM5 or system I2C-1 bus integrity. The isolated J6 header resolves the address
conflict by design: the programming interface is a physically separate, maintenance-only interface. Factory initial NVM programming via J6 is required before first use in a system.

### Affected Files

- `design/Electronics/Power_Module/Design_Spec.md` - U4 note updated; DR-PM-20/21/22 added; BOM: U18 (M24512-RDW6TP), J6 (61300511121), R47-R50 (ERJ-3EKF4701V, extends existing row),
  C78 (CL05B104KB5NNNC, extends existing row)
- `design/Guides/Maintenance_Guide.md` - §5 added (TPS25751 field programming procedure placeholder)
- `design/Datasheets/STM-M24512-RDW6TP-datasheet.md` - new markdown datasheet generated (DS6520 Rev 31, 47 pages)
