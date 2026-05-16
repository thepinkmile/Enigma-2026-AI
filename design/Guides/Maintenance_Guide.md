# Enigma-NG Maintenance Guide

**Status:** Draft
**Version:** v.0.1.0
**Associated Hardware Revision:** Rev A
**Last Updated:** 2026-05-16

## 1. Safety Procedures

* **Safety Glow (Amber):** If the external Amber LED is lit, the Supercapacitors are discharging (>5.1V). Do not open the machine.
* **Residual Voltage Test:** After the Amber LED extinguishes, use a multimeter on the 'SICHERHEITS-PROBE' (V+) and 'ERDE-PROBE' (GND) pads.
* **Touch-Safe Threshold:** Only begin work when the multimeter reads <2V.

### RTC Battery Safety

The Controller board contains an RTC backup battery (ML2032/CR2032 coin cell).

> ⚠️ **Battery Safety Warning:** The RTC backup battery (ML2032/CR2032 coin cell) is a lithium cell.
> Do not short-circuit, incinerate, disassemble, or expose to temperatures above 60°C. Replace only with the same or equivalent approved type. Dispose of in accordance with local regulations.

* **CR2032 (non-rechargeable):** Standard fit. The BAT54 protection diode (D1) must remain in circuit.
* **ML2032 (rechargeable):** Only if D1 is removed and the Linux OS `dtparam=rtc_bbat_vchg` parameter is enabled. See `design/Software/Linux_OS/` for software configuration.
* **Service interval:** >25 years under normal use. Battery replacement is a service-by-disassembly task - not field-replaceable in situ.

## 2. Internal Indicators

* **LOGIK-BEREIT (Green):** Located on the Power Module near the Controller dock edge. Indicates stable internal logic rails.

## 3. Power Module Fault Recovery

### eFuse Latch-Off Recovery

The Power Module TPS25980 eFuse may latch OFF under the following fault conditions:

* **Overvoltage (OV):** Input > 16.9V (OVLO threshold).
* **Overcurrent (OC):** Output > 7A (ILIM threshold).
* **Thermal (TCO F1):** TCO opens at 72°C board temperature.

**Recovery procedure:**

1. Identify and resolve the root fault (e.g., faulty PSE port, overcurrent load, ambient overtemperature).
2. Remove **all** input sources (PoE cable, USB-C, battery).
3. Wait at least 3 seconds for the input bulk capacitors to fully discharge.
4. Re-apply a single known-good source.
5. The eFuse will re-enable automatically if the input voltage is within the UVLO-OVLO window and no fault condition is present.

> ⚠️ If the eFuse repeatedly latches, do not continue cycling power. Diagnose with a bench power supply
> and current meter before reconnecting the system.

## 4. Future Coupon Access

Any future bring-up or service probe access should be implemented on removable coupons rather than
as permanent features on the production boards.

## 5. TPS25751 PD Profile Field Reprogramming

The TPS25751 (U4) on the Power Module reads its USB-C PD source profile (5V/5A, 25W) from the
M24512-RDW6TP EEPROM (U18) at start-up. The profile stored in U18 can be updated in the field
via the dual-purpose battery connector J4 (6-pin Molex Micro-Fit 3.0) on the PM board.

> ⚠️ **Factory requirement:** U18 must be programmed with the correct PD profile before the PM is
> installed into a system for the first time. An unprogrammed EEPROM will prevent the TPS25751
> from negotiating a PD contract with the CM5, potentially causing CM5 throttling or failure to boot.

### How J4 Dual-Purpose Switching Works

J4 carries both SmartBattery and TPS25751 programming traffic on pins 2 and 3, switched by the
U19 dual SPDT I2C MUX (74LVC2G3157DP-Q10J). The active path is selected by `PROG_EN_N` on J4 pin 6:

| `PROG_EN_N` state | J4 pin 6 | U19 routing | Result |
| :--- | :--- | :--- | :--- |
| **HIGH** (normal) | NC on standard battery cable; 10 kΩ pull-up to 3V3\_MAIN holds HIGH | J4 SMBUS\_SCL/SDA → I2C-1 | Normal SmartBattery operation |
| **LOW** (programming) | Programming cable shorts pin 6 to GND | J4 SMBUS\_SCL/SDA → TPS25751 I2Ct (0x20) | EEPROM programming mode |

A standard battery cable with pin 6 unconnected is completely unaffected.

### J4 Connector Pinout (Molex Micro-Fit 3.0, 6-pin, 3.00 mm pitch)

| Pin | Signal | Programming cable connection |
| :---: | :--- | :--- |
| 1 | `VBATT+` | Optional: bench supply V+ for standalone programming (see note below) |
| 2 | `SMBUS_SCL` | I²C adapter SCL |
| 3 | `SMBUS_SDA` | I²C adapter SDA |
| 4 | `BATT_PRES_N` | Leave unconnected |
| 5 | `VBATT-` | Optional: bench supply GND for standalone programming; also I²C adapter GND |
| 6 | `PROG_EN_N` | **Short to GND** (activates programming path via U19) |

> **Standalone programming:** The programming cable may supply power to the PM via pins 1
> (VBATT+, 14.4 V nominal) and 5 (VBATT−/GND), allowing EEPROM programming without a running
> system or J1–J3 connected. When powered this way, the 5V bucks, LDO (U7), and 3V3_MAIN rail
> all come up normally, enabling U19 and TPS25751 to function.

> **I2Ct address:** 0x20 (fixed by ADCIN1 = 3V3\_MAIN, ADCIN2 = GND per TPS25751 datasheet
> §8.3.6 Table 8-6; see DEC-076).

### Required Tools

> ⚠️ **TODO:** Software tool and programming cable specification to be confirmed. See
> `.copilot/todos/tps25751-i2c-review.md` for investigation notes.

- **Software:** TI USB-C Configuration Tool (TBD — download from ti.com for TPS25751/TPS25750EVM)
- **Hardware:** USB-to-I²C adapter compatible with the TI tool (TBD — candidate: Total Phase Aardvark or FT232H-based adapter)
- **Cable:** Custom 6-pin Micro-Fit 3.0 programming harness with pin 6 shorted to GND (TBD — full specification to be defined once software tool and adapter are confirmed)

### Programming Procedure (Placeholder)

> ⚠️ **TODO:** Full programming procedure to be documented once tool and cable are confirmed.

1. Prepare the programming cable: 6-pin Micro-Fit 3.0 plug with pin 6 shorted to GND, I²C adapter wired to pins 2 (SCL) and 3 (SDA), GND reference on pin 5.
2. Power the PM board — either via J1–J3 (normal system connection) or via the programming cable itself (bench supply on pins 1 and 5, 14.4 V).
3. Connect the programming cable to J4. Pin 6 LOW → U19 switches SMBUS\_SCL/SDA to TPS25751 I2Ct port.
4. Connect the I²C adapter to the host PC.
5. Launch the TI USB-C Configuration Tool on the connected PC.
6. Configure the desired PD source profile (5V/5A fixed source, no battery charger role).
7. Write the configuration to EEPROM via the tool — TPS25751 receives config over I2Ct (0x20) and writes it to U18 via I2Cc.
8. Disconnect the programming cable and refit a standard battery cable (pin 6 = NC → PROG\_EN\_N returns HIGH → U19 reverts to SmartBattery path).
9. Power-cycle the PM board and verify the CM5 USB-C port negotiates the correct PD contract.

> **Cross-reference:** PM Design_Spec.md §5 (U4/U18/U19 description); DEC-076.
> Datasheet refs: TPS25751 §8.3.11 Tables 8-4/8-5; M24512 DS6520 §2.3/Table 3;
> 74LVC2G3157-Q100 Table 10.
