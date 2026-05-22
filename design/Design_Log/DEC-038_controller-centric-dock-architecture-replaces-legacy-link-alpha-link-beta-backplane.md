## DEC-038 - Controller-Centric Dock Architecture Replaces Legacy Link-Alpha / Link-Beta Backplane

- **Status:** Decided
- **Date:** 2026-04-19
- **Category:** Mechanical / Electrical partitioning
- **Area:** Controller Board, Power Module, Stator, system interconnect architecture
- **Author:** Izzyonstage & GitHub Copilot

### Summary

Retire the legacy Samtec `LINK-ALPHA` and `LINK-BETA` board-to-board model for the Controller ↔ Power
Module and Controller ↔ Stator interfaces. The Controller becomes the fixed motherboard and enclosure-edge
I/O carrier; the Power Module and Stator become removable daughtercards docked into the Controller.

### Problem

The former dual-blind-mate Samtec architecture assumed the Power Module and Stator both attached directly
to the Controller through high-pin-count mezzanine connectors. That arrangement no longer matches the
enclosure-driven mechanical direction:

- the **Controller** now owns all external I/O placement
- the **Power Module** is a removable power cartridge rather than the I/O edge board
- the **Stator** is a removable vertical daughterboard that must be supported against rotor mass

The old Link-Alpha / Link-Beta definitions also forced low-current Samtec contacts to carry large grouped
power allocations and kept obsolete direct PM status GPIOs alive even though a shared `I2C-1` bus already
reaches the PM.

### Decision

#### 1. Controller owns RJ45 / Ethernet / PoE entry

The Controller Board now owns:

- RJ45 connector
- Ethernet ESD and magnetics handling
- PoE PD / ACF front-end
- the local cable-entry shield / chassis island for those connectors

The Power Module no longer carries RJ45, Ethernet LED return lines, or GbE MDI routing.

#### 2. Power Module becomes a power-conditioning / UPS cartridge

The Power Module now receives a **regulated PoE-derived auxiliary feed** from the Controller instead of
raw Ethernet-adjacent PoE circuitry. It continues to host:

- USB-C PD input
- smart-battery input
- OR-ing / filtering / eFuse
- supercap hold-up
- `5V_MAIN` and `3V3_ENIG` generation

#### 3. Controller ↔ Power Module dock is split into three TE connectors

Use three copies of the TE 10-position 2.5 mm board-to-board pair:

- Controller side receptacle: **`1-1674231-1`**
- Power Module side plug: **`1123684-7`**

Active partition:

| Link | Function | Allocation |
| :--- | :--- | :--- |
| `J1A` | main regulated rails | `3 x 5V_MAIN`, `2 x 3V3_ENIG`, `5 x GND` |
| `J1B` | PoE auxiliary handoff | `3 x VIN_POE_12V`, `7 x GND` |
| `J1C` | low-speed control / telemetry | `I2C1_SDA`, `I2C1_SCL`, `PM_IO_INT_N`, `PWR_GD`, `ROTOR_EN`, `PWR_BUT`, `4 x GND` |

#### 4. Controller ↔ Stator dock uses two Molex hybrid connectors

Use the Molex EXTreme Guardian HD pair:

- Controller receptacle: **`2195630015`**
- Stator plug: **`2195620015`**

Active partition:

- **5V dock (`J2A`)**: `4 x 5V_MAIN` power blades, `1 x GND` power blade, signal field used as extra
  `GND` returns / guards
- **3V3 / logic dock (`J2B`)**: `4 x 3V3_ENIG` power blades, `1 x GND` power blade, guarded signal field
  carrying `TCK`, `TMS`, `TDI`, `TTD_RETURN`, `I2C1_SDA`, and `I2C1_SCL`; all remaining signal contacts tied to `GND`

This retains the JTAG cluster on the `3V3_ENIG` / logic-biased connector and gives the Stator two
mechanical support points instead of one fine-pitch mezzanine connector.

#### 4a. Controller owns the local servo actuation interface

Because the Stator is now a removable **vertical** daughterboard, the servo motor and its home switch
must remain close to the mechanical depression-bar linkage rather than hanging off the Stator PCB.
The Controller therefore owns the full local servo electrical interface:

- **J11** on the Controller carries `5V_MAIN`, `GND`, and `SERVO_PWM`
- **SW3 / SERVO_HOME** is mounted on the Controller with a local pull-up and debounce network
- **CM5 GPIO 12** provides direct 50 Hz `SERVO_PWM`
- **CM5 GPIO 17** reads the active-low `SERVO_HOME` input

No I²C expander-owned servo GPIO and no standalone PCA9685 PWM driver are used in the active design.

#### 5. PM-local I2C expander replaces legacy direct PM status GPIOs

Add **`PCA9534APWR`** on the Power Module at **I2C address `0x3F`**. Use it for:

- **inputs:** `POE_STAT`, `SYS_FAULT`, `BATT_PRES_N`, `USB_STAT`
- **outputs:** `SW_LED_R`, `SW_LED_G`, `SW_LED_B`, `SW_LED_CTRL`

Retain only these direct PM lines:

- `PWR_BUT`
- `PWR_GD`
- `ROTOR_EN`

#### 6. PM RGB sink stage follows the Settings Board pattern

The PM runtime RGB path uses three low-side `BSS138` stages with `1kΩ` gate resistors and gate
pull-down resistors. The pre-boot hardware flash path remains **red + green only** via `Q4` and `D6/D7`;
blue is runtime-only.

#### 7. Grounding rule is unchanged

The **only** intentional DC bond between `GND` and `GND_CHASSIS` remains on the Power Module before the
eFuse. The Controller may host local shield/chassis handling for cable-entry hardware, but it must not
create a second galvanic bond to system ground.

### Rationale

- Matches the enclosure-driven mechanical architecture.
- Moves high-speed / external I/O ownership to the board that already carries the CM5 and user-facing ports.
- Replaces over-loaded fine-pitch Samtec power transport with dock connectors better suited to grouped power.
- Keeps PM-local housekeeping close to the PM circuits instead of wasting direct CM5 GPIOs on status lines
  that already terminate on the PM.
- Keeps PM devices clustered in `i2cdetect` by placing the expander at `0x3F`, adjacent to the PM INA219 at `0x40`.

### Supersession / Obsolescence

- **DEC-014** is obsolete as an active definition for Controller blind-mate BtB connectors.
- **DEC-015** and **DEC-037** are obsolete as active Controller ↔ Stator interface definitions.
- The names **`Link-Alpha`** and **`Link-Beta`** are retained only for historical traceability in older
  documents; the active architecture uses `J1A/J1B/J1C` and `J2A/J2B`.
- Rotor / Extension / Reflector Samtec Edge-Rate connectors are **not** affected by this decision.

### Impact

- Controller, Power Module, and Stator design specs must be updated to the new dock model.
- Controller PoE / Ethernet ownership moves out of the Power Module docs and BOM ownership.
- Servo motor electrical ownership moves from the Stator to the Controller so the actuation hardware
  remains co-located with the rotor depression bar in the vertical-Stator enclosure layout.
  The following Stator requirements were retired as a result (IDs at time of retirement; the active
  spec has since been renumbered to close the gaps):
  - **FR-STA-11** (servo PWM output, original numbering) - superseded by Controller-local direct CM5 GPIO PWM.
  - **FR-STA-12** (SERVO\_HOME sensing, original numbering) - superseded by Controller-local home-switch input.
  - **DR-STA-13** (I²C PWM driver, original numbering) - servo PWM generation moved to direct CM5 GPIO.
  - **DR-STA-14** (servo connector, original numbering) - connector ownership moved to the Controller.
  - **DR-STA-15** (SERVO\_HOME switch, original numbering) - home-switch ownership moved to the Controller.
- PM GPIO / SW1 RGB runtime control moves to `PCA9534APWR @ 0x3F`.
- Power-budget and overview documents must stop referencing Samtec Link-Alpha / Link-Beta as active
  PM/Stator bottlenecks.

### Cross-ref

DEC-014, DEC-015, DEC-031, DEC-034, DEC-037.
