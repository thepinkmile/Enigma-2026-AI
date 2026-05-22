## DEC-033 - DSI1 Display Connector Provision for Optional Lid Touchscreen

- **Status:** Decided
- **Date:** 2026-04-14
- **Category:** Electrical / HMI
- **Area:** Controller Board - CM5 display interface; Main Enclosure lid
- **Author:** Izzyonstage & GitHub Copilot

### Summary

Add a DSI1 4-lane FPC connector (J9) to the Controller Board to provision for an optional
lid-mounted touchscreen display, enabling the Enigma-NG to operate as a self-contained machine
without an external monitor. The Display Add-on Board design is deferred.

### Problem

The Enigma-NG currently relies on an external HDMI monitor and USB HID devices for system
management and GUI display. With the CM5 virtual keyboard injection (DEC-031) and Settings Board
(DEC-032) features, the machine is capable of autonomous operation. Adding a lid-mounted touchscreen
completes the self-contained package - the only remaining external peripheral would be a keyboard
and mouse for system administration tasks.

### Decision

1. Add J9 (Amphenol F52Q-1A7H1-11015, 15-pin 1.0mm pitch ZIF/FPC connector) to the Controller Board to expose
   the CM5 DSI1 4-lane interface (CLK +/-, D0-D3 +/-).
2. Route DSI1 differential pairs on L3 (100 Ω differential stripline - same rule as HDMI/USB).
   Traces run from CM5 mezzanine connector pins to J9 near the CM5 socket.
3. Touch I²C (capacitive touch controller SDA/SCL) is routed via the I²C-1 bus already present
   on the Controller Board.
4. `J9` is the only Controller-side display connector fixed in the current scope. Any future
   display power or auxiliary touch wiring remains deferred with the display add-on board definition.
5. The HDMI port (J4) is retained and unaffected - J9 is additive.
6. Display Add-on Board design (lid mounting frame, FPC cable assembly, backlight driver if
   required, touch controller interface) is **deferred** to a future design phase.

### Display Interface

- **Interface:** MIPI DSI1 (4-lane)
- **Differential impedance:** 100 Ω (same as HDMI - no new routing rules)
- **Connector:** Amphenol F52Q-1A7H1-11015 - 15-pin 1.0mm pitch right-angle ZIF/FPC
- **Cable:** Thin FPC routed through lid hinge area (far superior to HDMI cable for hinge flexing)
- **Touch input:** Capacitive touch controller I²C on I²C-1 bus (existing bus, no new wires required)
- **Supported sizes:** DSI1 4-lane supports displays up to 10" at full resolution (e.g., RPi official 10" touchscreen)

### Rationale

- DSI1 FPC cable is thin and flexible - ideal for routing through a lid hinge without fatigue.
- Retaining HDMI preserves external monitor compatibility for development and maintenance.
- The 100 Ω differential rule is already established on L3 for HDMI - no new stackup or impedance work needed.
- Provisioning the connector now (no extra cost, trivial PCB area) avoids a board revision later if the display add-on is adopted.
- I²C-1 bus already has spare address space for a touch controller (e.g., FT5426 at 0x38 or similar).

### Impact

- **Controller Board:** J9 added; ~10 new 100 Ω diff traces on L3; small ZIF footprint on L1 near CM5
- **Main Enclosure:** Lid requires provision for display mounting and FPC hinge routing (see `Main_Enclosure/Design_Spec.md`)
- **Display Add-on Board:** Deferred - to be designed as a separate optional add-on
- **Firmware / OS:** Standard RPi DSI1 display driver; no custom firmware changes needed for basic display output
