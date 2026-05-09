# Full supplier PN sweep pre-schematic

**ID:** `full-pn-review`
**Status:** pending
**Category:** Electronics
**Source:** 2026-05-02 supplier PN audit
**Blocked by:** `connector-thermal-verification` (done), `extension-mechanical-usage`, `battery-connector-final-review`, `ctlh1-deferred` (done), `rotor-esd-tvs` (done), `coupon-testing-review`

---

## Description

Full supplier PN review of all BOM entries before schematic capture — a prior session that reduced component package sizes appears to have corrupted supplier PNs on at least two components (ERJ-2RKF1001X, CL05B104KB5NNNC), substituting codes pointing to entirely different parts. A sweep of all DigiKey / Mouser / JLCPCB PNs against their MPNs is required before KiCAD work begins. Depends on: connector-thermal-verification, extension-mechanical-usage, battery-connector-final-review, ctlh1-deferred, rotor-esd-tvs, coupon-testing-review

## Notes

No additional notes.
