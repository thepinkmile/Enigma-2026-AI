# Enigma-NG Maintenance Guide

**Status:** Draft
**Version:** v.0.1.0
**Associated Hardware Revision:** Rev A
**Last Updated:** 2026-04-20

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
