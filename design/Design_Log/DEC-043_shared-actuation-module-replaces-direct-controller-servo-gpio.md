## DEC-043 - Shared Actuation Module Replaces Direct Controller Servo GPIO

- **Status:** Decided
- **Date:** 2026-04-26
- **Category:** Mechanical / Electrical partitioning
- **Area:** Controller, Extension, rotor-group turnover, servo actuation
- **Author:** Izzyonstage & GitHub Copilot

### Summary

Replace the former direct Controller-local CM5 servo path with a reusable **Actuation Module (AM)**
that is hosted both by the Controller and by each Extension. The AM accepts power and a single
active-low `ACTUATE_REQUEST` line, then performs local homing, one-shot request capture, and servo
PWM generation autonomously.

To support Extension-local actuation power without inventing a second cable family, the
Reflector / Extension harness is widened from **16-pin BHR-16-VUA** to **20-pin BHR-20-VUA** while
preserving the existing reflector-boundary service bus on pins 1-16 and adding grouped `5V_MAIN`
plus returns on pins 17-20.

### Problem

The previously active design had two incompatible actuation assumptions:

- the **Controller** used a direct CM5 `SERVO_PWM` + `SERVO_HOME` interface
- the newly agreed **Extension** turnover architecture needed a completely local request-driven
  actuator with no live Controller PWM dependency

That mismatch would have created two different servo-control circuits, two software models, and no
clean way to propagate actuation across Extension boundaries.

### Decision

1. **Adopt one shared Actuation Module PCB everywhere servo stepping is required.**
   - Controller: one AM for the main depression-bar actuation path.
   - Each Extension: one AM for group-boundary carry regeneration.

2. **The host/AM electrical contract is reduced to:**
   - grouped `5V_MAIN`, `3V3_ENIG`, `GND`
   - one active-low `ACTUATE_REQUEST`
   - no host-visible `BUSY`, `HOMED`, or fault feedback pins

3. **The AM owns local servo behaviour.**
   - power-up homing
   - home-switch reading
   - request latching / one-shot behaviour
   - servo PWM generation
   - local LED diagnostics

4. **Controller direct servo ownership is retired.**
   - CM5 GPIO 8 becomes `ACTUATE_REQUEST`
   - the former direct `SERVO_PWM` / `SERVO_HOME` Controller path is no longer active

5. **Extension boundaries regenerate carry locally.**
   - carry remains mechanical within each contiguous 5-rotor group
   - at an Extension boundary, the mechanical carry event becomes a local `ACTUATE_REQUEST`
   - the Extension-hosted AM then actuates the next rotor group's first-step mechanism

6. **Promote the Reflector / Extension link from 16-pin to 20-pin.**
   - pins 1-16: unchanged legacy service bus
   - pin 17: `5V_MAIN`
   - pin 18: `GND`
   - pin 19: `5V_MAIN`
   - pin 20: `GND`

### Rationale

- Keeps the Controller and Extension actuation hardware on the **same electrical architecture**.
- Makes the actuation subsystem field-replaceable and easier to maintain.
- Preserves the mechanical carry principle while still crossing the electrically separated Extension
  boundary cleanly.
- Avoids overloading the AM host interface with software handshakes the user does not want.
- A reviewed standalone PWM driver such as the PCA9685 is **not sufficient by itself** because the AM
  also requires autonomous homing and request sequencing; a small local controller with native PWM is
  therefore preferred.

### Impact

- Add a new `design/Electronics/Actuation_Module/` design-doc set.
- Update `Controller/Design_Spec.md` and `Software/Linux_OS/Power_Management.md` to remove the direct
  CM5 servo model.
- Update `Extension/Design_Spec.md` to host the AM and define the local group-boundary actuation role.
- Update `Stator`, `Reflector`, and `System_Architecture` docs for the widened 20-pin
  Reflector / Extension harness.
- Update the mechanical actuation docs so carry is described as mechanical-within-group and
  Extension-regenerated across group boundaries.

### Cross-ref

DEC-038, `design/Electronics/Actuation_Module/Design_Spec.md`,
`design/Electronics/Controller/Design_Spec.md`,
`design/Electronics/Extension/Design_Spec.md`,
`design/Mechanical/Rotor_Actuation_Assembly/Design_Spec.md`.

> **QUE-002 supersession note:** DEC-043 supersedes the pin count stated in QUE-002 Question 3.
> QUE-002 Q3 referenced "Stator J10 (16-pin 2x8)" - that was the pre-DEC-043 connector width.
> J10 is now a **20-pin 2x10 BHR-20-VUA** shrouded box header. The mating connectors on Extension
> (J7/J8) and Reflector (J4) are identical 20-pin 2x10 BHR-20-VUA headers. Standard 20-wire 2.54mm
> IDC ribbon cable assemblies are suitable for all three; no break-off PCB coupons are required for
> these links (QUE-002 coupons apply only to Samtec ERF8/ERM8 0.8mm-pitch connectors).
