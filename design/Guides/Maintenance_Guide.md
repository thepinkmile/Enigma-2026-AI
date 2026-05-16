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
via the I2Ct debug header J6 (5-pin, 2.54 mm) on the PM board.

> ⚠️ **Factory requirement:** U18 must be programmed with the correct PD profile before the PM is
> installed into a system for the first time. An unprogrammed EEPROM will prevent the TPS25751
> from negotiating a PD contract with the CM5, potentially causing CM5 throttling or failure to boot.

### J6 Header Pinout (2.54 mm, 5-pin, single-row)

| Pin | Signal | Notes |
| :--- | :--- | :--- |
| 1 (square pad) | GND | Reference ground |
| 2 | LDO_3V3 | 3.3 V sense / reference — **do NOT source current into this pin** |
| 3 | I2Ct_SCL | TPS25751 I²C target clock |
| 4 | I2Ct_SDA | TPS25751 I²C target data |
| 5 | I2Ct_IRQ | TPS25751 interrupt (optional) |

> **I2Ct address:** 0x20 (fixed by ADCIN1=LDO_3V3, ADCIN2=GND per TPS25751 datasheet §8.3.6
> Table 8-6; see DEC-075 and DR-PM-22).

### Required Tools

> ⚠️ **TODO:** Software tool and programming cable specification to be confirmed. See
> `.copilot/todos/tps25751-i2c-review.md` for investigation notes.

- **Software:** TI USB-C Configuration Tool (TBD — download from ti.com for TPS25751/TPS25750EVM)
- **Hardware:** USB-to-I²C adapter compatible with the TI tool (TBD — candidate: Total Phase Aardvark or FT232H-based adapter)
- **Cable:** Custom 5-pin IDC-to-J6 harness (TBD — specification to be defined once software tool and adapter are confirmed)

### Programming Procedure (Placeholder)

> ⚠️ **TODO:** Full programming procedure to be documented once tool and cable are confirmed.

1. Power the PM board (all I/O through J1–J3 connected, or bench supply on VIN_BUS/GND).
2. Connect the programming cable to J6 (pin 1 = GND, square pad).
3. Launch the TI USB-C Configuration Tool on the connected PC.
4. Configure the desired PD source profile (5V/5A fixed source, no battery charger).
5. Write the configuration to EEPROM via the tool — TPS25751 uses I2Ct to receive config and writes it to U18 via I2Cc.
6. Power-cycle the PM board and verify the CM5 USB-C port negotiates the correct PD contract.

> **Cross-reference:** PM Design_Spec.md §5 (U4/U18 description), DR-PM-20, DR-PM-21, DR-PM-22; DEC-075.
> Datasheet refs: TPS25751 §8.3.11 Table 8-4; M24512 DS6520 §2.3/Table 3.
