# Enigma-NG Design Decision Log

**Status:** Active
**Project:** Enigma-NG
**Author:** Izzyonstage & GitHub Copilot
**Version:** v.0.1.0
**Associated Hardware Revision:** Rev A
**Last Updated:** 2026-05-11

This file records key architectural and component decisions made during the design of the Enigma-NG system. Each entry captures the decision taken, the rationale behind it, the alternatives that were
considered, and any constraints or caveats that future designers should be aware of.

Entries are numbered sequentially as **DEC-NNN**. Where a decision supersedes a previous one, the earlier entry is updated with a cross-reference.

---

## DEC-001 - 3V3_ENIG Used Throughout; 3V3_SYSTEM Removed from BtB Interconnect

- **Status:** Obsolete - superseded by DEC-037
- **Date:** 2025
- **Category:** Electrical
- **Area:** Power Module, Controller Board, Link-Alpha connector

### Decision

The `3V3_SYSTEM` rail (sourced from the CM5 on the Controller Board) is **not** routed to the Power Module over the Link-Alpha BtB connector. All 3.3V logic within the Power Module (RJ45 LED anodes,
I2C pull-ups, BATT_PRES_N pull-up, reset pull-up) is powered by `3V3_ENIG`, generated locally by the Power Module LDO (U7).

### Rationale

- `3V3_SYSTEM` is a CM5-derived rail intended only for external peripheral interfaces (Ethernet, HDMI, USB 3.0 ports). Using it to power internal power-module logic would create a cross-domain

  dependency and complicate sequencing.

- Generating `3V3_ENIG` locally on the Power Module gives a clean, independently-controlled 3.3V supply that is always present when the Power Module is powered, regardless of CM5 boot state.
- Removing `3V3_SYSTEM` from the Link-Alpha connector freed pins 21-24, which were reallocated to extend the 5V_MAIN delivery cluster and GND return path.

### Alternatives Considered

- Route `3V3_SYSTEM` from CM5 over Link-Alpha and use it for RJ45 logic. Rejected: cross-domain dependency, sequencing risk, wasted connector pins.
- Use a second small LDO on the Controller Board to produce a local 3.3V for CM5-adjacent logic. Rejected: unnecessary complexity given `3V3_ENIG` already exists.

### Impact

- Pins 21-22: Reassigned from 3V3_SYSTEM → **5V_MAIN** (supplemental power pins)
- Pins 23-24: Reassigned from 3V3_SYSTEM → **GND** (supplemental return path)
- Combined 5V_MAIN capacity: 18 pins x 0.5A = **9A** (was 16 pins = 8A)
- Legacy Controller probe-access concept Pin 14: Reassigned from 3V3_SYSTEM → **SW_LED_CTRL (GPIO 20)** (subsequently updated; see DEC-009)

---

## DEC-002 - PoE Option A2 Selected: Coilcraft POE600F-12LD

- **Status:** Decided
- **Date:** 2025
- **Category:** Electrical
- **Area:** Power Module PoE subsystem, T2 transformer, TPS23730 feedback network

### Decision

The PoE transformer T2 uses a **Coilcraft POE600F-12LD** off-the-shelf ACF transformer (12V output, 60W, 200kHz, ≥1500Vrms isolation, SMT package). The remainder of the PoE chain uses TPS2372-4
(802.3bt Type 4 PD interface) and TPS23730 (ACF controller), with TPS23730 feedback resistors adjusted for the 12V output.

### Rationale

- Replaces a custom-wound transformer design (Option A: 15V, 8-16 week lead time, ~£35-46 BOM) with a catalogue part available from Coilcraft Direct.
- Off-the-shelf: **£3.54 qty-1, ~£1.86 volume**, in stock. Lead time: days not weeks.
- Same ACF topology as the custom design - only feedback resistors change. No PCB layout changes to high-current paths.
- 12V output falls within the TPS25980 eFuse UVLO/OVLO window (11V - 16.9V) with no additional buck stage needed.

### Alternatives Considered

- **Option A (Custom T2, 15V):** Higher voltage headroom. Rejected: custom winding, long lead time, cost.
- **Option C (Silvertel Ag59812-LPB integrated module):** Higher integration, 95% efficiency, ~£19-27. Rejected: higher cost, fixed form factor, less flexibility for thermal management, vendor

  lock-in.

- **Kinetic Technologies KPM5912:** 85W, 93% efficiency. Rejected: not stocked by any UK/EU distributor.

### Key Parameters

| Parameter | Value |
| --- | --- |
| Part | Coilcraft POE600F-12LD |
| Output | 12V nominal |
| Power | 60W (Type 4 PD, 72W class) |
| Isolation | ≥1500Vrms |
| Topology | Active Clamp Flyback (ACF) |
| Package | SMT |
| Price (qty-1) | ~£3.54 |

---

## DEC-003 - PoE Output 12V; OR-ing Priority Logic Required

- **Status:** Decided
- **Date:** 2025
- **Category:** Electrical
- **Area:** Power Module PoE output, OR-ing diode (LM74700-Q1), eFuse input

### Decision

PoE outputs 12V (not 15V) into the OR-ing stage. Because 12V < 15V USB-C input, passive OR-ing would always prefer USB-C and ignore PoE. Active enable logic is implemented: the TPS2372-4 `/PG` signal
drives the LM74700-Q1 gate control low when PoE is live, disabling the USB-C path.

### Rationale

- PoE is the primary field power source when no USB-C adapter is connected. It must not be silently overridden by USB-C passthrough.
- TPS2372-4 `/PG` (power good, active low) is a clean indicator of a live 802.3bt PoE session.
- LM74700-Q1 already provides the USB-C ideal diode function; gating its enable is a minimal-change approach.

### Constraints

- PoE UVLO: 11V. eFuse UVLO: 11V. No margin at UVLO floor - PoE cable must be within 1V drop budget.
- eFuse ILIM utilisation at 12V worst case: 4.67A / 7A = **66.7%** ✔ (within 75% derating target).

---

## DEC-004 - Supercap Charge Current 0.5A Under PoE

- **Status:** Superseded by DEC-029 (cell specification updated; 0.5A charge current constraint retained)
- **Date:** 2025
- **Category:** Electrical
- **Area:** LTC3350 supercap charger, PoE power budget

### Decision

When running on PoE (802.3bt Type 4, 72W budget), the supercap charge current is reduced to **0.5A** (vs. up to 2A on USB-C/Battery).
This limits peak PoE utilisation to 73.9% (53.2W / 72W) - within the 75% design rule ✔ (see Certification_Evidence §3.5).

### Rationale

- Full 2A supercap charging on PoE would push utilisation to ~98%, leaving <2W margin for transient loads.
- 0.5A charge current charges the **8x 25F** supercap bank (2S4P, 50F total - Abracon ADCR-T02R7SA256MB) in approximately 9 minutes from depleted.
- Normal system usage is expected to exceed 30-45 minutes per session (startup + configuration + use), making a 2-minute charge time acceptable.
- This limitation should be documented in the User Manual with guidance that maximum system load is not recommended during the initial PoE power-up window.

### Constraints

- Steady-state PoE load (after caps charged): 50.3W / 72W = **69.9%** utilisation ✔

---

## DEC-005 - TPS25980 eFuse Replaces TPS259474L

- **Status:** Decided
- **Date:** 2025
- **Category:** Electrical
- **Area:** Power Module eFuse (U1)

### Decision

The input eFuse uses a **TPS25980** (7A ILIM, silicon-fixed 16.9V OVLO) rather than the originally considered TPS259474L (5.5A ILIM).

### Rationale

- TPS259474L 5.5A limit is insufficient for worst-case USB-C 15V path at 75W: 75W / 15V = 5.0A + 10% derating = 5.5A - already at the device limit with no headroom.
- TPS25980 (TPS259804ONRGER) provides 7A ILIM (programmed via R3 = 210 Ω) and silicon-fixed 16.9V OVLO, which neatly caps the battery charge voltage window.

### OVLO Constraint

- eFuse OVLO is **16.9V silicon-fixed** (TPS259804ONRGER - no external programming resistor).
- BMS must be configured for **4.1V/cell maximum charge (16.4V for 4S)** to maintain a ≥0.5V margin.
- BMS configurations using 4.2V/cell (16.8V) are not compatible with this eFuse and must not be used.

### ⚠️ Variant Lock - Do NOT change this MPN

The TPS25980 family uses a digit after `TPS25980` to select the OVLO behaviour:

| Variant | OVLO | Status |
| --- | --- | --- |
| **TPS259804ONRGER** | **16.9V silicon-fixed** | ✔ **CORRECT - use this** |
| TPS259807 | No OVLO feature | ❌ WRONG - do not use |
| TPS259803 | No OVLO feature | ❌ WRONG - do not use |

This variant has been erroneously swapped to TPS259807 in previous review rounds.
The `04` digit must not be changed without explicit documented justification.

---

## DEC-006 - STUSB4500 Negotiates 15V/5A (75W)

- **Status:** Decided
- **Date:** 2025
- **Category:** Electrical
- **Area:** Power Module USB-C PD handshake (STUSB4500), USB-C adapter requirement

### Decision

The STUSB4500 standalone PD sink is programmed to negotiate **15V/5A (75W)** from the wall adapter or USB-C PD source. Earlier documentation incorrectly stated 15V/3A.

### Rationale

- 3A (45W) is insufficient for worst-case system load (CM5 at 25W + rotors + supercap charging).
- 5A (75W) provides headroom and aligns with the 75% derating target at the eFuse.
- Users must use a USB-C PD adapter rated for at least 75W (15V/5A or 20V/5A with appropriate negotiation cap).

---

## DEC-007 - Dual Interleaved LMQ61460-Q1 5V Buck (12A)

- **Status:** Decided
- **Date:** 2025
- **Category:** Electrical
- **Area:** Power Module 5V Buck (U2A/U2B)

### Decision

Two **LMQ61460-Q1** buck regulators are used in a **dual interleaved** configuration, providing a combined **12A** output at 5V. Earlier documentation referenced a single LM61460-Q1 (6A).

### Rationale

- Single 6A device is insufficient for CM5 at 25W (5A) + other 5V loads.
- Interleaved dual phase reduces input/output ripple and distributes thermal load.
- 12A capacity aligns with the 9A+ delivery capability of the updated Link-Alpha pin cluster.

---

## DEC-008 - TPS25750 Emulates 5V/5A PD Profile to CM5

> ⚠️ **Superseded by DEC-012** - TPS25750 replaced with TPS25751DREFR. See DEC-012.

- **Status:** Superseded by DEC-012
- **Date:** 2025
- **Category:** Electrical
- **Area:** CM5 USB-C PD emulator (TPS25750)

### Decision

The TPS25750 PD emulator advertises a **5V/5A** profile to the CM5 internal USB-C port.

### Rationale

- The CM5 Linux OS will generate a "low power" warning if PD negotiation does not complete at or above 5V/5A (25W).
- 5V/5A is the minimum advertisement to suppress this warning and allow unrestricted CPU/GPU boost operation.

---

## DEC-009 - Legacy Controller Probe-Access Pin 14 Reassigned to SW_LED_CTRL

- **Status:** Decided
- **Date:** 2025 (GND); superseded by final design (SW_LED_CTRL)
- **Category:** Electrical
- **Area:** Historical Controller bring-up probe-access concept

> **Supersession note:** Historical-only. See **DEC-040** for the current rule that all Diagnostics
> Banks are removed from the active design specs and will only be reconsidered later during the
> coupon implementation review.

### Decision

The legacy Controller probe-access concept pin 14 was initially reassigned from `3V3_SYSTEM` to
**GND**, following the removal of the `3V3_SYSTEM` rail from all BtB interconnects (see DEC-001).
In the subsequent design pass that added `SW_LED_CTRL` (GPIO 20) to the Link-Alpha signal set,
pin 14 was reallocated to **SW_LED_CTRL** to expose the LED-arbitration handshake at the historical
bring-up probe point.

**Final assignment:** Legacy Controller probe-access concept pin 14 = `SW_LED_CTRL` (GPIO 20, CTRL
→ PM, HIGH = CM5 in control of SW1 RGB LED).

### Rationale

- `3V3_SYSTEM` is no longer available at the Power Module side of this debug header.
- `SW_LED_CTRL` is a useful bring-up observation point - it shows whether the CM5 has taken control
  of the RGB LED from the hardware oscillator fallback path.
- GND is freely available on pins 19-20; a redundant GND at pin 14 added no diagnostic value.

---

## DEC-010 - INC-14 DEFERRED: Legacy Probe-Access ESD Protection (Post-Prototype)

- **Status:** Deferred - Accepted risk for prototype stage
- **Date:** 2025
- **Category:** Electrical
- **Area:** Historical Controller bring-up probe-access concept

> **Supersession note:** Historical-only. See **DEC-040** for the current rule that all Diagnostics
> Banks are removed from the active design specs and will only be reconsidered later during the
> coupon implementation review.

### Decision

ESD protection on the historical probe-access concept is **deferred** to post-prototype evaluation.
No TVS diodes or series resistors are added to those bring-up-only signals at this stage.

### Rationale

- The probe-access concept was internal, accessed only by engineers with ESD precautions during
  development.
- Adding ESD protection to every bring-up-only signal adds cost, board space, and complexity before
  there is validated evidence that it is needed.
- Risk accepted for prototype: controlled lab environment, trained operators, no field exposure.

### Post-Prototype Action Required

- During first prototype test phase, evaluate signal integrity and ESD sensitivity on any temporary
  bring-up probe lines.
- If any such lines are exposed to field conditions (e.g., external test connectors), add series
  33Ω + TVS per line.
- Document findings and update this log with the final resolution.

---

## DEC-011 - All Power Rails on Power Module; 3V3_ENIG Serves Rotor Stack

- **Status:** ✔ RESOLVED
- **Date:** 2025
- **Category:** Electrical
- **Area:** Power Module islands, Controller Board routing, rotor stack power source

### Decision

All power rails are generated on the **Power Module**. The Controller Board's role is purely to **route** power rails onward to downstream boards - it does not generate any rails itself. The rotor
stack is powered by the existing **3V3_ENIG** rail (TPS75733KTTRG3 LDO, 3A). There is no separate Rotor Buck; the erroneous "3.3V/5A Rotor Buck" specification was a confusion with the 5V/5A CM5 rail and
has been removed.

### Rationale

- Centralising all power generation on the Power Module simplifies thermal management (all heat dissipation in one shielded enclosure with dedicated thermal zone).
- Reduces the risk of ground loops and cross-domain sequencing issues.
- The Controller Board as a routing layer keeps its design cleaner and easier to revise independently.
- 3V3_ENIG (3A) covers all 3.3V consumers: CPLDs, USB-JTAG, I2C logic, control signals, and the rotor stack.
- Settings Board RGB indicators are powered from 5V_MAIN via the Stator/Settings 6-pin harness; only
  their control logic remains on 3V3_ENIG.
- ROTOR_EN (CM5 GPIO 16) enables/disables the 3V3_ENIG LDO for sequenced rotor power-up - a control signal only.

### Architectural Rule (permanent)

> All power rails are generated on the Power Module. The Controller Board routes rails to downstream boards only. No buck converters, LDOs, or other power-generating components belong on the
> Controller Board.

### Impact

- `README.md`: Removed erroneous "Dedicated 3.3V/5A Buck" from Controller Board section; 3V3_ENIG correctly listed as Power Module output serving CPLDs, logic, and rotor stack.
- `Power_Module/Design_Spec.md`: 3V3_ENIG scope updated to include rotor stack; 3-island Power Plane retained.
- `Controller/Design_Spec.md`: ROTOR_EN clarified as LDO enable signal to Power Module.
- `Rotor/Design_Spec.md`: Power source updated from "Controller Board Island C" to "Power Module 3V3_ENIG rail".

### Previously Conflicting References (now corrected)

- `README.md` placed the Rotor Buck under the Controller Board section.
- `Rotor/Design_Spec.md` said "sourced from the Controller Board's Island C".

---

## DEC-012 - U4 TPS25750 Replaced with TPS25751DREFR (NRND Resolution)

- **Status:** ✔ RESOLVED
- **Date:** 2026-04-03
- **Category:** Electrical
- **Area:** Power Module U4, schematic, PCB footprint

### Decision

Replace **TPS25750** (NRND - Not Recommended for New Designs) with **TPS25751DREFR** (PD3.1 certified DRP controller, WQFN-38 6x4mm).

### Rationale

- PD emulation for U4 is required: the Raspberry Pi CM5 must negotiate a 5V/5A (25W) contract from the USB-C PD source to prevent the OS from issuing under-voltage warnings and throttling the system.
- The TPS25751D variant includes the integrated 20V/5A bi-directional power path and a 5V/3A source switch in one package - appropriate for DRP operation that can advertise and deliver the 5V/5A

  profile to the CM5.

- TPS25751 is USB-IF PD3.1 certified (TID#10306); TPS25750 was PD2.0 only and is NRND.
- STUSB4500 (U5) handles the USB-C sink path; TPS25751 (U4) handles the source/emulation path. These are separate and complementary roles.

### Impact

- **Package**: TPS25750 was QFN-28; TPS25751DREFR is WQFN-38 6x4mm. KiCad symbol and footprint to be created when schematic capture begins.
- Mouser: `595-TPS25751DREFR`; DigiKey: `296-TPS25751DREFRCT-ND`; JLCPCB: `C30169739`.

---

## DEC-013 - L3 EMI Inductor Changed to Bourns SRP1265A-100M

- **Status:** ✔ RESOLVED
- **Date:** 2026-04-03
- **Category:** Electrical
- **Area:** Power Module L3, PCB footprint

### Decision

Replace **Wurth 7447789100** with **Bourns SRP1265A-100M** as L3 (EMI DM Pi-filter inductor).

### Rationale

- Wurth 7447789100 is not available in any public distributor catalog (not found at DigiKey, Mouser, Farnell, or on the Wurth public website). Sourcing without a Wurth rep contact is not feasible.
- Bourns SRP1265A-100M is a direct functional equivalent: 10µH, **15.5A Isat** (exceeds 14.5A target with 21% headroom), DCR=16.5mΩ max (better than the original 20mΩ spec), shielded molded SMD.
- Widely stocked: Farnell ~2,741 pcs; Mouser (`652-SRP1265A-100M`); DigiKey (`SRP1265A-100MCT-ND`).

### Impact

- ⚠️ **Package footprint change**: SRP1265A-100M is 13.5x12.5x6.2mm vs 7447789100's 12.5x12.5x6.0mm. PCB land pattern for L3 must use the Bourns 13.5x12.5mm footprint. Clearance to adjacent

  components should be checked during layout.

---

## DEC-014 - Controller Board Uses ERF8 (Female) on Both BtB Connectors for Blind-Mate Assembly

- **Status:** ✔ RESOLVED
- **Date:** 2026-04-04
- **Category:** Electrical
- **Area:** Controller J1 (Link-Alpha), Controller J2 (Link-Beta), Consolidated BOM connector inventory

### Decision

Both BtB connectors on the Controller Board use the ERF8 female socket: J1 (Link-Alpha) uses **ERF8-040-05.0-S-DV-K-TR** and J2 (Link-Beta) uses **ERF8-020-05.0-S-DV-K-TR**.
The mating male plugs are fitted to the Power Module (J1, ERM8-040) and the Stator Board (J8, ERM8-020-05.0-S-DV-K-TR) respectively.

### Rationale

During mechanical assembly, the Controller Board slides into the enclosure and must simultaneously engage
with two boards along its back edge - the Power Module (J1) to one side and the Stator (J2) to the other.
Using female sockets on the Controller allows guided blind-mate engagement in a single insertion motion,
with the mating male pins on the peripheral boards providing positive alignment.
Placing male headers on the Controller would require both peripheral boards to be precisely pre-positioned before the Controller could be inserted,
significantly complicating assembly.

### Connector Assignment Summary

| Board | Connector | Gender | Part |
| :--- | :--- | :--- | :--- |
| Controller | J1 (Link-Alpha, from Power Module) | Female | ERF8-040-05.0-S-DV-K-TR |
| Controller | J2 (Link-Beta, to Stator Board) | Female | ERF8-020-05.0-S-DV-K-TR |
| Power Module | J1 (Link-Alpha plug) | Male | ERM8-040-05.0-S-DV-K-TR |
| Stator Board | J8 (Link-Beta plug) | Male | ERM8-020-05.0-S-DV-K-TR |

### Impact

- Controller BOM J2 updated from ERM8 (male) to ERF8 (female); JLCPCB C-number to be verified.
- Controller §2 narrative updated to reflect ERF8 on Link-Beta.
- No electrical impact - connector is signal-transparent; pin assignments unchanged.

---

## DEC-015 - LINK-BETA Connector Reduced from 80-pin to 40-pin (ERF8-020 / ERM8-020)

- **Status:** ✔ RESOLVED
- **Date:** 2026-04-04
- **Category:** Electrical
- **Area:** Controller Board (J2), Stator Board (J8), Consolidated BOM
- **Amended by:** DEC-036 (2026-04-18), DEC-037 (2026-04-18)

### Decision

The LINK-BETA Board-to-Board connector is reduced from 80-pin (ERF8-040 / ERM8-040) to **40-pin
(ERF8-020-05.0-S-DV-K-TR / ERM8-020-05.0-S-DV-K-TR)**. The table below records the original
post-reduction allocation; the current active allocation is defined by **DEC-037**.

| Pin | Signal | Direction | Notes |
| :--- | :--- | :--- | :--- |
| 1 | GND | - | JTAG leading shield |
| 2 | TCK | CTRL→Stator | JTAG clock |
| 3 | GND | - | TCK/TMS inter-pin shield |
| 4 | TMS | CTRL→Stator | JTAG mode select |
| 5 | GND | - | TMS/TDI inter-pin shield |
| 6 | TDI | CTRL→Stator | JTAG data in |
| 7 | GND | - | TDI/SPARE inter-pin shield |
| 8 | SPARE | - | Freed by DEC-031 (was SYS_RESET_N - migrated to I²C U7 GPA[7] @ 0x21) |
| 9 | GND | - | JTAG trailing shield |
| 10 | GND | - | Isolation moat pin 1 |
| 11 | GND | - | Isolation moat pin 2 |
| 12 | SPARE | - | Freed by DEC-031 (was ENC_IN[0] - migrated to I²C U6 @ 0x20) |
| 13 | SPARE | - | Freed by DEC-031 (was ENC_IN[1]) |
| 14 | SPARE | - | Freed by DEC-031 (was ENC_IN[2]) |
| 15 | SPARE | - | Freed by DEC-031 (was ENC_IN[3]) |
| 16 | SPARE | - | Freed by DEC-031 (was ENC_IN[4]) |
| 17 | SPARE | - | Freed by DEC-031 (was ENC_IN[5]) |
| 18 | GND | - | Inter-group shield |
| 19 | SPARE | - | Freed by DEC-031 (was ENC_OUT[0] - migrated to I²C U6 @ 0x20) |
| 20 | SPARE | - | Freed by DEC-031 (was ENC_OUT[1]) |
| 21 | SPARE | - | Freed by DEC-031 (was ENC_OUT[2]) |
| 22 | SPARE | - | Freed by DEC-031 (was ENC_OUT[3]) |
| 23 | SPARE | - | Freed by DEC-031 (was ENC_OUT[4]) |
| 24 | SPARE | - | Freed by DEC-031 (was ENC_OUT[5]) |
| 25 | GND | - | ENC_OUT / TTD_RETURN shield |
| 26 | TTD_RETURN | Stator→CTRL | JTAG TDO short-path return (bypasses rotor stack) |
| 27 | GND | - | TTD_RETURN shield |
| 28-35 | 3V3_ENIG | PM→Stator | Power pass-through from Link-Alpha; 8 pins x 0.5A = 4.0A |
| 36-40 | GND | - | Power return (5 pins) |

### Rationale

Logic boards downstream of the Stator (Encoder, Reflector, Extension) are 3V3-only - they require
no 5V_MAIN rail. Removing 5V_MAIN from LINK-BETA and rationalising the signal set results in exactly
40 signals. The JTAG block has 5 internal GND shield pins (self-shielded at low-moderate MHz), so only
a 2-pin GND moat is needed between JTAG and the data zone. 8 x 3V3_ENIG pins deliver 4.0A - adequate
for the worst-case 30-rotor stack (2.11 A per Power_Budgets.md). 5 GND return pins plus the 10 other GND pins throughout the
connector provide adequate return paths.

### Poka-Yoke Safety Note

The 80-pin LINK-ALPHA (ERF8-040) and 40-pin LINK-BETA (ERF8-020) on the Controller Board are
**physically incompatible** - the mating connectors cannot be inserted into the wrong socket. This
provides a mechanical safeguard against mismating during prototype bring-up.

### Alternatives Considered

Keeping 80-pin connector with unused pins. Rejected: unnecessary connector cost and PCB area; larger
connector on the Stator increases stack height with no benefit.

### Impact

- Controller J2: ERF8-040 → ERF8-020-05.0-S-DV-K-TR (female, 40-pin)
- Stator J8: ERM8-040 → ERM8-020-05.0-S-DV-K-TR (male, 40-pin)
- DEC-014 connector table updated (see cross-ref below).

### Cross-ref

DEC-014 (gender assignment rationale remains valid; part numbers updated). DEC-031
(pins 8, 12-17, and 19-24 freed - SYS_RESET_N and ENC_IN/OUT migrated to I²C).
DEC-036 (freed monitor block reallocated into grouped 5V_MAIN / 3V3_ENIG / GND rails).

---

## DEC-016 - JTAG Controlled Impedance and Series Termination

- **Status:** ✔ ADOPTED
- **Date:** 2026-04-05
- **Category:** Electrical
- **Area:** Controller Board, Stator Board, Encoder Board, Reflector Board (noted), Extension Board (noted)

### Decision

All JTAG signal traces on 4-layer and 6-layer PCBs are specified at **50 Ω controlled impedance**
(0.127 mm / 5 mil trace width on outer layers over a contiguous GND plane). Series termination
resistors are added at every cable-driving JTAG output using **75 Ω** (to match the ~100 Ω
impedance of alternating-GND IDC ribbon cable), and at every intra-board or BtB-driving JTAG output
using **33 Ω** (to match the 50 Ω PCB trace impedance).

Full signal-swing analysis confirms the destination CPLD receives full logic swing (3.3 V) in all
cases. The open-circuit reflection at the high-impedance CPLD input doubles the incoming wave back
to full voltage; the series resistor controls the return reflection, not the final voltage.

### Full analysis, all options considered, and trace width calculations

See `design/Electronics/Investigations/JTAG_Integrity.md`.

### Summary of additions per board

| Board | Refs | Value | Purpose |
| :--- | :--- | :--- | :--- |
| Controller | R4, R5, R6 | 33 Ω 0603 | ~~TCK / TMS / TDI series R after 74LVC2G125 buffer, before LINK-BETA~~ **Moved to JDB - see DEC-024** |
| Stator | R7-R9 | 75 Ω 0603 | TCK → J4 / J5 / J6 encoder port outputs |
| Stator | R10-R12 | 75 Ω 0603 | TMS → J4 / J5 / J6 encoder port outputs |
| Stator | R13-R15 | 75 Ω 0603 | TDI chain drive: Stator CPLD TDO→J4, J4 return→J5, J5 return→J6 |
| Encoder | R7 | 33 Ω 0402 | CPLD1 TDO → CPLD2 TDI (intra-board, match 50 Ω PCB trace) |
| Encoder | R8 | 75 Ω 0402 | CPLD2 TDO → J2 connector (ribbon cable drive back to Stator) |
| JDB | R6, R7, R8 | 33 Ω 0402 | TCK / TMS (after U5 buffer) / TDI series damping - before J2 JTAG header |

> **Update (detailed design):** U5 (SN74LVC2G125DCUR buffer) and series damping resistors relocated
> from Controller to JDB during detailed design. LINK-BETA is confirmed as a direct Board-to-Board
> connector (no cable), so 33 Ω series damping applies throughout (not 75 Ω cable-driving rule).
> Controller JTAG lines (TCK, TMS, TDI, TTD_RETURN, VREF) are pass-through - routed directly from
> JDB hat-header to LINK-BETA without active components. See DEC-024.

**Trace width rule added to all 4-layer and 6-layer boards:** 0.127 mm (5 mil) for all JTAG signal
traces on outer layers over a GND plane.

**2-layer boards (Reflector, Extension):** Controlled impedance not practical - 50 Ω would require
a 2.82 mm trace (see `design/Electronics/Investigations/JTAG_Integrity.md §4`). Series termination at cable-driving ends of adjacent
boards provides sufficient protection. Existing Reflector R1 (22 Ω) retained as end-of-chain damping.

> **Superseded (partial):** The Reflector and Extension 2-layer limitations above are superseded by
> DEC-017, which upgrades both boards to 4-Layer JLC04161H-7628. Both boards now have a solid L2 GND
> plane and route JTAG on L1 at 0.127 mm (50 Ω), consistent with all other 4-layer boards.

### Rationale

Achieving 100 Ω PCB traces (to perfectly match the IDC ribbon cable impedance) is physically
impossible on JLCPCB standard 4-layer/6-layer stackups - the required trace width is negative
(see calculation in `design/Electronics/Investigations/JTAG_Integrity.md §4`). The 50 Ω + 75 Ω hybrid approach provides the best
achievable impedance match to the cable while remaining within manufacturing design rules.

### Alternatives Considered

- **No termination (Option A):** Rejected - multiple re-reflections at 10 MHz risk false TCK edges.
- **50 Ω PCB + 33 Ω series R (Option B):** Acceptable but leaves 33% reflection at PCB-to-cable
  transition unabsorbed.
- **100 Ω PCB + 82 Ω series R (Option C, ideal):** Rejected - not achievable on standard stackup.

### Cost Impact

Additional BOM cost per full system < £0.05. No JLCPCB impedance certification required for
prototype; trace widths self-calculated and within ±10% of target. See `design/Electronics/Investigations/JTAG_Integrity.md §9`.

---

## DEC-017 - Minimum 4-Layer Stackup for All Non-Controller Boards

- **Status:** ✔ ADOPTED
- **Date:** 2026-04-05
- **Category:** Electrical
- **Area:** Reflector Board, Extension Board (all other boards already compliant)

### Decision

All PCBs in the Enigma-NG system shall use a minimum of **4-layer stackup** (JLCPCB
JLC04161H-7628). The Controller Board and the Power Module Board are the only exceptions
and retain their 6-layer JLC06161H-2116 stackup: the Controller for high-speed 5 Gbps
differential pair requirements, and the Power Module for high-current power delivery.

### Standard 4-layer layer mapping for all non-Controller boards

| Layer | Function |
| :--- | :--- |
| L1 | Signal (JTAG, data routing) - top |
| L2 | GND plane - solid contiguous copper |
| L3 | 3V3_ENIG power plane |
| L4 | Signal (data routing, branding data plate) - bottom |

> **Exception - JTAG Daughterboard:** The JDB uses an inverted stackup: L1=GND plane + SMT
> component pads (component side, faces Controller), L2=signal traces, L3=power pours,
> L4=GND shield (exterior face). This inversion places components on the face that mates
> with the Controller Board hat-headers, consistent with single-side JLCPCB assembly.
> See `JTAG_Daughterboard/Design_Spec.md §4`.

### Boards affected (updated)

| Board | Previous | New |
| :--- | :--- | :--- |
| Reflector | 2-Layer 1.6mm FR4 / 1oz | 4-Layer JLC04161H-7628 / 2oz |
| Extension | Layer count unspecified | 4-Layer JLC04161H-7628 / 2oz |

### Boards already compliant (no change)

| Board | Stackup | Notes |
| :--- | :--- | :--- |
| Stator | 4-Layer JLC04161H-7628 | ✔ Unchanged |
| Encoder | 4-Layer JLC04161H-7628 | ✔ Unchanged |
| Rotor | 4-Layer JLC04161H-7628 | ✔ Unchanged |
| Controller | 6-Layer JLC06161H-2116 | ✔ Exception - high-speed stackup retained |
| Power Module | 6-Layer JLC06161H-2116 | ✔ Exception - high-current power delivery stackup retained |

### Impact

The "2-layer uncontrolled impedance" notes for Reflector and Extension in DEC-016 are superseded.
Both boards now have a solid L2 GND plane and can route JTAG on L1 at 0.127 mm (50 Ω controlled
impedance), consistent with all other 4-layer boards. `design/Electronics/Investigations/JTAG_Integrity.md §3.1`, `§3.3` (now
historical), and `§8` trace table have been updated accordingly.

### Rationale

1. **Uniform stackup:** Consistent JLC04161H-7628 across all non-Controller boards eliminates
   stackup-dependent trace impedance variation, reducing signal behaviour differences between boards.
2. **Solid GND on every board:** All boards now have a contiguous L2 GND plane, enabling 50 Ω
   controlled impedance JTAG routing across the entire system.
3. **EMC/EMI improvement:** Solid GND and power planes on all boards reduce radiated emissions and
   improve common-mode noise rejection across the rotor stack and encoder cabling.
4. **Manufacturing speed:** JLC04161H-7628 is JLCPCB's most common 4-layer stackup, with higher
   stock availability and faster turnaround than 2-layer special orders or less common stackups.
5. **Cost:** Marginal price difference between 2-layer and 4-layer at JLCPCB prototype quantities;
   outweighed by signal integrity and EMC benefits.

### Alternatives Considered

- **Retain 2-layer Reflector/Extension:** Rejected - inconsistent stackup creates impedance
  discontinuities in the JTAG chain and leaves an uncontrolled segment at the reflector end.
- **Use different 4-layer stackup per board:** Rejected - non-uniform dielectric parameters would
  require separate trace width calculations per board and add unnecessary design complexity.

---

## DEC-018 - Connector Pinout Ownership Model

- **Status:** Adopted
- **Date:** 2026-04-05
- **Category:** Electrical
- **Area:** All Boards - Documentation Architecture

### Decision

Each multi-board connector interface shall have a single **Definition Owner** - the board whose
`Board_Layout.md` (or `Design_Spec.md` where no Board_Layout exists) contains the authoritative
pin-by-pin table for that interface. All other boards that mate with that connector must
**not** duplicate the pin table; instead they include a short cross-reference note of the form:

> **Connector Definition Owner:** `[OwnerBoard]/Board_Layout.md - [Section]`. This board uses the
> mating connector. See BOM for part number.

This rule prevents the class of drift errors where two boards define the same connector differently
(e.g. Pin 2 = GND on one board, SYS_RESET_N on another). When a conflict is found, the owner's
definition is authoritative.

### Ownership Register

| Interface | Connector(s) | Definition Owner | Authoritative Section |
| :--- | :--- | :--- | :--- |
| **LINK-ALPHA** | PM J1 ↔ Controller J1 (80-pin ERM8/ERF8) | **Power Module** | `Power_Module/Board_Layout.md - LINK-ALPHA` |
| **LINK-BETA** | Controller J2 ↔ Stator J8 (40-pin ERM8/ERF8) | **Controller** | `Controller/Board_Layout.md - LINK-BETA` |
| **Reflector/Extension Link** | Stator J10 ↔ Extension J7/J8 ↔ Reflector J4 (16-pin 2x8) | **Stator** | `Stator/Board_Layout.md - J10` |
| **Encoder Ports** | Stator J4/J5/J6/J7/J8/J9 ↔ Encoder J2 (20-pin 2x10) | **Stator** | `Stator/Board_Layout.md - J4-J9` |
| **Rotor Interface** | Stator J1-J3 ↔ Rotor 1 → ... → Rotor 30 → Reflector J1-J3 (serial chain; Extension J1-J6 at group boundaries) | **Rotor** | `Rotor/Design_Spec.md §3.4` |
| **JTAG Daughterboard headers** | JDB J1 (USB 5-pin) + J2 (JTAG 10-pin) | **JTAG Daughterboard** | `JTAG_Daughterboard/Board_Layout.md` |

### Rationale

- **LINK-ALPHA → Power Module:** The Power Module is the upstream power provider; it defines what
  rails and signals it places on the cable. The Controller is the downstream consumer.
- **LINK-BETA → Controller:** The Controller is the JTAG chain master. It originates TCK, TMS, TDI,
  SYS_RESET_N, and the ENC data bus. The Stator is the passive backplane receiver.
- **Reflector/Extension Link → Stator:** The Stator is the signal origin for all ENC data, power,
  and TTD_RETURN carried on this cable. Extension and Reflector are passive pass-throughs or endpoints.
- **Encoder Ports → Stator:** The Stator drives all three encoder cables and has the complete chain
  routing logic for TDI/TDO sequencing across J4/J5/J6. The Encoder boards are the downstream receivers.
- **Rotor Interface → Rotor:** The Rotor defines its own physical interface - both the connector
  type (mechanical) and the signal mapping. Stator, Extension, and Reflector must comply with the
  Rotor's mechanical interface, not the other way round.
- **JTAG Daughterboard → itself:** Self-contained module with no cross-board mating conflicts.

### Alternatives Considered

- **Central `Interfaces.md` document:** Rejected - separates pin definitions from the board they belong
  to, making it harder to keep in sync during incremental design changes. Per-board ownership with
  cross-references is more maintainable.
- **Both sides document the full table:** Rejected - this is the exact pattern that caused the REF-03
  Pin 2 conflict and the REF-01 16/20-pin mismatch found in the April 2026 deep-dive review.

---

## DEC-019 - PoE Transformer Topology: ACF (Option A) Selected

- **Status:** ✔ Adopted
- **Date:** 2026-04-05
- **Category:** Electrical
- **Area:** Power Module - T2 transformer, TPS23730 operating mode, input EMI filter

### Decision

The Power Module retains the **Active Clamp Flyback (ACF)** topology with the **Coilcraft POE600F-12LD**
transformer. The TPS23730 operates in ACF mode, driving an external active clamp MOSFET complementary
to the primary switch. The Coilcraft transformer is procured order-direct from `coilcraft.com` and
supplied to JLCPCB as a consignment part.

No change is made to the T2 transformer, the TPS23730 mode configuration, or the active clamp circuit.

**Full investigation detail:** `design/Electronics/Investigations/PoE_Investigation.md`

### Rationale

A thorough search confirmed that **no ACF PoE isolation transformer for 60W / 36-57V input is stocked
by any mainstream authorised distributor** (DigiKey, Mouser, Farnell, Arrow). The Coilcraft POE600F
family was co-developed with TI specifically for the TPS23730 reference design; no competing catalogue
part exists.

The only standard-distributor alternative identified was the **Bourns PDC060-FD20A12S** - a standard
flyback transformer available from DigiKey. Switching to this part (Option B) would have required:

- Disabling TPS23730 `ACF_GD` (ACF gate drive pin)
- Removing the active clamp MOSFET and capacitor
- Adding an RCD clamp (3 SMD components)
- Verifying PSR auxiliary winding compatibility (unconfirmed)

After detailed EMI/EMC analysis, Option B was rejected on technical grounds. Key findings:

| Criterion | Option A (ACF) | Option B (Flyback) |
| :--- | :--- | :--- |
| Primary switching | ZVS - no hard dV/dt event | Hard switching - fast dV/dt |
| Drain spike at turn-off | None - energy recycled by clamp | Present - RCD clamp clips but does not eliminate |
| CM/DM conducted EMI | Low | 15-25 dB higher before input filter |
| Input EMI filter size | Smaller / fewer components | Larger / more complex |
| CISPR 32 Class B margin | Comfortable | Tight - may require design iteration |
| Efficiency | 88-92% | 85-90% |
| Extra dissipation | - | ~1-2W at full load |
| PSR aux winding verified | ✔ TI reference design | ⚠️ Unverified for Bourns PDC060 |

The Coilcraft direct-order model is accepted as a specialist procurement path, consistent with
industry practice for catalogue magnetics.

### Alternatives Considered

- **Bourns PDC060-FD20A12S (Option B - flyback PSR):** Rejected - hard-switching topology causes
  significantly higher conducted and radiated EMI, requires a larger input EMI filter, does not
  eliminate procurement complexity (shifts effort from transformer sourcing to filter design),
  and adds ~1-2W thermal load to an already thermally constrained module.
- **Wurth WE-FB range:** Rejected - entire range has a maximum input voltage of 36V (insufficient
  for PoE 36-57V input) and is keyed to Linear Technology LT-series controllers.
- **Change PoE controller ecosystem:** Not evaluated - would constitute a major redesign and is
  out of scope.

---

## DEC-020 - GND_CHASSIS Rib Clearway ENIG Bond

- **Status:** Accepted - 2026-04-08
- **Date:** 2026-04-08
- **Category:** Electrical
- **Area:** Power Module - Supercap Block Assembly & Board Layout
- **References:** QUE-001, Certification_Evidence.md §2.2

### Decision

The 3.0mm rib clearway gaps between supercap cells shall have:

1. **Exposed ENIG strip (L1):** Solder mask opened in the rib clearway gap on the top copper layer (L1),
   connected to the GND_CHASSIS net. Minimum strip width 1.5mm, running the full depth of the rib contact zone.
   The aluminium enclosure rib makes direct electrical contact with the PCB GND_CHASSIS copper, providing a
   distributed HF chassis ground bond at the supercap block location.

2. **Polyimide (Kapton) tape on supercap bodies:** Each supercap cell shall be wrapped with a minimum of
   one layer of 2-mil (50µm) polyimide tape prior to installation, to electrically insulate the cell body
   from the aluminium compression ribs and prevent short circuits.

3. **Conductive elastomer gasket strip:** A self-adhesive conductive elastomer or conductive foam gasket strip
   (≤3mm wide, full rib contact depth) shall be applied to the rib face or PCB contact zone to accommodate
   manufacturing tolerances and ensure positive, reliable electrical contact under compression.
   Part to be selected at mechanical design phase when rib geometry is confirmed.

### Rationale

The combined structure - aluminium Can lid, compression ribs, conductive gasket, PCB ENIG strip, and
GND_CHASSIS copper pour - forms a near-complete Faraday cage around the supercap block, improving
shielding of the high-capacitance energy storage element from the rest of the board.

### Compatibility with single-point GND_CHASSIS bond rule

The single-point rule governs signal GND → GND_CHASSIS crossings. Rib contact bonds are
enclosure-to-GND_CHASSIS connections - both within the chassis domain - and do not create additional
signal-to-chassis bonds. The rule is maintained.

### Other boards

Deferred pending mechanical design documentation. Controller Board Mechanical_Design.md §3 notes the
prototype uses a 3D-printed chassis (no conductive rib contact); this decision will be revisited when
metal chassis dimensions are finalised. Stator/Encoder/Rotor mechanical designs are not yet written.

---

## DEC-021 - Supercapacitor Bank Upgrade: 2x2 2S2P → 2x3 2S3P

- **Status:** Superseded by DEC-029 (arrangement 2S3P retained; cell capacitance updated 22F → 25F Abracon)
- **Date:** 2026-04-08
- **Category:** Electrical
- **Area:** Power Module - Supercap Bank, Board Layout, Hold-up Specification
- **References:** DR-PM-07, DR-PM-09, DEC-020

### Decision

The supercapacitor bank is upgraded from a 2x2 (4-cell, 2S2P) to a **2x3 (6-cell, 2S3P)** arrangement,
with the inter-cell air gap increased from 2.0mm to **3.0mm**.

| Parameter | Previous | New |
| :--- | :--- | :--- |
| Cell count | 4 (C_SC1-4) | 6 (C_SC1-6) |
| Arrangement | 2x2 | 2x3 |
| Configuration | 2S2P | 2S3P |
| Inter-cell gap | 2.0mm | 3.0mm |
| Cell pitch | 14mm | 15mm |
| Block footprint | 28mm x 28mm | 30mm x 45mm |
| Shadow zone | 32mm x 32mm | 34mm x 49mm |
| Effective capacitance | 22F at 5.4V | 33F at 5.4V |
| Hold-up energy | 72.4J | 108.6J |
| Hold-up duration @ 5W | ≥14.5s | ≥21.7s |
| Charge time (depleted) | ~2 min | ~3 min |

### Rationale

- **50% more hold-up:** 33F vs 22F provides ≥21.7 seconds at 5W - a more comfortable shutdown window
  and headroom for higher CM5 load profiles at prototype bring-up.
- **LTC3350 compatibility:** No IC change required. LTC3350 is configured for 2 cells in series;
  each series position now has 3x22F in parallel (66F per position). CELLS register unchanged.
  RICHARGE (0.5A charge current limit) unchanged; charge time increases ~3 minutes from depleted.
- **Wider gap (3mm):** The increased inter-cell gap from 2.0mm to 3.0mm provides adequate clearance
  for the 2-mil Kapton tape wrap (DEC-020), the conductive elastomer gasket strip, and the aluminium
  enclosure compression ribs, while maintaining margin for manufacturing tolerances.
- **Board space:** The Power Module board dimensions are not yet fixed; the design is being built
  around this component block. The increased footprint (30mm x 45mm vs 28mm x 28mm) is accepted.

> **Post-decision update (2026-04-08, checkpoint 025):** The 22F generic cells specified above
> were subsequently replaced with **Abracon ADCR-T02R7SA256MB (25F/2.7V)** when a verified in-stock
> THT radial supercap was sourced. The 2S3P arrangement and all mechanical dimensions are unchanged.
> Effective capacitance increases from 33F to **37.5F**; hold-up increases from 21.7 s to **≥24.8 s**.
> The values **22F / 33F / 21.7 s** are historical and must not be restored.

---

## DEC-022 - JDB FT232H Clock Source: Dedicated 12MHz SMD Crystal Selected

- **Status:** Obsolete - superseded by DEC-037
- **Date:** 2026-04-06
- **Category:** Electrical
- **Area:** JTAG Daughterboard - Clock Source (FT232H)

### Decision

Dedicated 12MHz SMD passive crystal (Y1) on the JDB PCB. CM5 GPCLK0 option rejected.

### Context

During JDB detailed design review, two issues were identified:

1. The original design incorrectly specified a **24MHz HC-49 through-hole crystal**. The FT232H datasheet requires a **12MHz**
   reference - its internal PLL multiplies 12MHz x 40 to generate 480MHz for USB Hi-Speed operation. 24MHz is outside specification.
2. An alternative was considered: routing a clock from the **CM5 GPCLK0 output (GPIO4)** to the FT232H OSCI pin instead of a dedicated on-board crystal.

### Options Considered

| Option | Description | Verdict |
| :--- | :--- | :--- |
| A | CM5 GPCLK0 (GPIO4) routed through Controller hat-header to FT232H OSCI | **Rejected** |
| B | Dedicated 12MHz passive SMD crystal (Y1) on JDB PCB | **Selected** |

**Option A - Rejected reasons:**

- Signal path: CM5 GPIO4 → Controller board → hat-header pin → JDB OSCI is long and noise-prone
- GPIO clock jitter from BCM is unsuitable as a USB PLL reference clock
- Creates a CM5 boot-order dependency - FT232H cannot enumerate on USB until CM5 configures GPCLK0
- Adds routing and firmware complexity with no benefit over a $0.07 crystal

**Option B - Selected:**

- Standard FTDI reference design approach; clean stable clock source
- No boot dependency; FT232H enumerates immediately on USB connect
- Component: **YXC X322512MSB4SI** (JLCPCB C9002), SMD3225-4P, 12MHz, 20pF, ±20ppm, Basic part
- Crystal load capacitors: C10-C11 = 33pF C0G 0402 (sets 20pF load capacitance)

### Impact

- `design/Electronics/JTAG_Daughterboard/Design_Spec.md`: Y1 corrected to 12MHz SMD3225-4P (C9002); C10-C11 added; text references updated.

---

## DEC-023 - JDB GND_CHASSIS Omitted; Mounting Holes Tied to GND

- **Status:** Decided
- **Date:** 2026-04-06
- **Category:** Electrical
- **Area:** JTAG Daughterboard - Grounding & EMC

### Decision

The JTAG Daughterboard (JDB) does **not** implement a `GND_CHASSIS` net. Mounting holes are included
for mechanical stability via conductive standoffs to the Controller board; the copper pours around
those mounting holes are tied to **GND** (circuit return). No dedicated chassis bond pad, stitching
via, or `GND_CHASSIS` net is present on the JDB.

> Cross-reference: DEC-039 keeps the single Power Module bond rule but now makes this JDB treatment
> the generic exception for non-chassis-connected daughterboards.

### Rationale

`GND_CHASSIS` exists to bond a PCB to the metal enclosure for EMC shielding, ESD protection, and safety earth. None of those functions apply to the JDB because:

1. **No chassis surface** - the JDB is an internal daughterboard that floats above the Controller
   board on hat-header pins and conductive standoffs. It has no metal enclosure surface it can
   directly bond to.
2. **EMC envelope already provided** - the Controller board beneath it carries a correctly implemented `GND_CHASSIS` net bonded to the system enclosure. The JDB sits entirely within that envelope.
3. **No external connections** - the JDB has no cables or connectors that exit the enclosure, so there are no ESD entry points that would require chassis bonding at the JDB level.
4. **Low-EMI device** - the FT232H operates at USB 2.0 speeds on an internal point-to-point link. It generates no significant conducted or radiated emissions that would require additional chassis shielding.
5. **Daisy-chaining adds no value** - connecting JDB `GND_CHASSIS` via standoffs to Controller
   `GND_CHASSIS` would create an additional path to chassis earth but no new bond point, adding
   PCB complexity for zero measurable EMC benefit.

### Implementation

- Include **mounting holes** on the JDB for mechanical stability.
- Standoffs are conductive (metal); this incidentally bonds the JDB mounting hole copper pours to the Controller board mechanically.
- Mounting hole copper pours connect to **GND** (circuit return) - not to a separate `GND_CHASSIS` net.
- This is consistent with standard practice for small internal sub-modules (e.g. Arduino shields, FPGA daughter cards).

### Alternatives Considered

- **Standoff bonding to Controller GND_CHASSIS:** Technically implementable but adds a separate net, a copper pour, and design rules for no measurable EMC gain on a low-EMI internal board. Rejected.
- **No mounting holes at all:** Rejected - mechanical retention via standoffs is required to prevent the board from flexing on the hat-headers during connector insertion/removal.

---

## DEC-024 - JDB is Complete JTAG Master; Controller JTAG Lines Are Pass-Through

- **Status:** Decided
- **Date:** 2026-04-06
- **Category:** Electrical
- **Area:** JTAG Architecture - Controller and JTAG Daughterboard

### Decision

The JTAG Daughterboard (JDB) is the complete JTAG master. The SN74LVC2G125DCUR dual-channel
buffer (U5) for TCK and TMS, and all 33 Ω series damping resistors (R6 TCK after U5, R7 TMS after
U5, R8 TDI direct from FT232H) are located on the JDB, before the J2 JTAG header. The Controller
board routes JTAG lines (TCK, TMS, TDI, TTD_RETURN, VREF) as pass-through from the JDB hat-header
to the LINK-BETA BtB connector without any active components.

LINK-BETA is a direct Board-to-Board connector (no cable). Therefore 33 Ω series damping (matched
to 50 Ω PCB trace impedance) applies throughout - not the 75 Ω cable-driving resistors specified
for ribbon cable connections. See DEC-016 for the full 75 Ω / 33 Ω rationale.

### Rationale

- **Simpler Controller BOM:** Removing U5, R4, R5, R6 from the Controller reduces complexity and
  potential assembly errors on the main board.
- **Cohesive JTAG subsystem:** All JTAG active components and termination are co-located on the JDB,
  which is the natural owner of the JTAG function.
- **BtB confirmation:** LINK-BETA is a Samtec ERF8-020 / ERM8-020 direct board-to-board stack (no
  ribbon cable). The 33 Ω source termination after U5 is the correct value for 50 Ω PCB traces.

### Impact

- `Controller/Design_Spec.md`: U5 removed from BOM; R4, R5, R6 removed; §3 updated to reflect
  pass-through routing; DR-CTL-05 updated; FR-CTL-04 reference to U5 removed.
- `JTAG_Daughterboard/Design_Spec.md`: U5 added to BOM; R6, R7, R8 (33 Ω 0402) added.
- `Electronics/Consolidated_BOM.md`: SN74LVC2G125DCUR moved from CTL column to JDB column;
  33 Ω 0402 count increased in JDB; 33 Ω 0603 row removed from CTL.
- `Electronics/Investigations/JTAG_Integrity.md`: §7.4 and §8 updated to reflect JDB location.
- `Design_Log.md DEC-016`: Update note added.

---

## DEC-025 - CM5 Shutdown Mechanism: Hardware-Driven; LTC3350 Software Support Deferred

- **Status:** Deferred - Software PoC Stage
- **Date:** 2026-04-09
- **Category:** Software
- **Area:** Software / Linux OS - CM5 Power Management Shutdown Path

### Decision

The final implementation of the CM5 graceful shutdown mechanism is **hardware-driven** via the
LTC3350 `/INTB` -> MIC1555 U15 -> Q5 BSS138 -> `PWR_BUT` one-shot path. Any LTC3350 software
support is deferred to the **Software PoC stage**, pending hardware availability for integration
testing, and is limited to I2C telemetry / LED-state handling rather than a dedicated interrupt pin.

The PWR_GD GPIO (GPIO 27, MCP121T-450E output) is rail-health telemetry only and does NOT trigger shutdown. It is a CM5 input that reads HIGH while 5V_MAIN ≥ 4.50V.

### Rationale

- The shutdown path is already covered by hardware, so no Linux interrupt path or device-tree
  mapping is required for safe power-off behaviour.
- Any future software support can read LTC3350 status over I2C without consuming another
  dedicated CM5 GPIO.
- Driver or service development still requires the physical hardware to be available for testing
  and validation.
- The system is designed for operational sessions of 15-30 minutes or longer. The hold-up window
  (≥33.5 s) is a generous safety margin; an unplanned shutdown from a fully-charged state is expected
  to be harmless. Deferring the driver to the PoC stage does not create a risk for hardware bring-up.
- Placeholder notes in design/Software/Linux_OS/Power_Management.md document the intended
  telemetry behaviour for reference; they are not a binding software specification.

### Impact

- design/Software/Linux_OS/Power_Management.md keeps the deferred LTC3350 telemetry notes but
  removes any requirement for a dedicated `/INTB` GPIO or device-tree interrupt mapping.
- The active hardware protection path is the LTC3350 /INTB → MIC1555 U15 → Q5 BSS138 →
  PWR_BUT one-shot circuit (3.01 s LOW pulse), which requires no software driver.

---

## DEC-026 - Rotor Position Encoder: AS5600 Replaced with Single-Track Capacitive Encoder

> ⚠️ Partially superseded by DEC-028 for dual-track N=64 architecture, Ø92mm PCB diameter, and aluminium shroud milled slots. Retained for historical context.

- **Status:** Accepted
- **Date:** 2026-04-12
- **Category:** Hardware
- **Area:** Rotor Board - Position Sensing (§2.1)

### Decision

The AMS AS5600 magnetic encoder (originally specified in DR-ROT-03) is replaced with a
**single-track absolute capacitive encoder** implemented entirely on the rotor PCB. The rotating
shroud flanges carry milled aluminium slots (air gap = low capacitance); K capacitive sensor pads on the PCB read the track
as a K-bit code. A combinational lookup table in the CPLD VHDL maps the raw sensor code to a
binary rotor position (0 to N-1). The SW1 modulo-N adder (ring setting) operates on the decoded
binary value. No external adder hardware is required - the decode and add are pure CPLD logic.

Three **Texas Instruments FDC2114RGHR** footprints are defined across the split rotor pair;
each rotor variant populates two of them:

- U2 (address 0x2A): Track A - bits[5:3] (N=64) or STGC bits[3:0] (N=26).
- U3 (address 0x2B): Board A STGC bit[4] (N=26 only). NOT POPULATED for N=64.
- U4 (address 0x2B): Track B - bits[2:0] (N=64 only). NOT POPULATED for N=26.
- CPLD implements I²C master to read pad states.

#### Track patterns (verified - all N codes unique)

- **26-char (K=5, N=26):** `00000100011001010011101111`
  Sensors at 0°, 13.846°, 27.692°, 41.538°, 55.385° from reference; arc/segment ≈ 10.63mm at r=44mm.
  Invalid codes (between-character / jam): 11, 13, 21, 22, 26, 31.
- **64-char (K=6, N=64):** Replaced by dual-track 3+3 reflected binary Gray code - see `Rotor_64_Char_Design.md §7` and DEC-028.
  Sensors at 0°, 5.625°, 11.25°, 16.875°, 22.5°, 28.125° from reference; arc/segment ≈ 4.32mm at r=44mm.
  All 64 six-bit codes are valid (standard 6-bit reflected binary Gray code; XOR-chain decode; no invalid-code jam detection required).

PCB outer diameter Ø92mm (inside Ø100mm aluminium shroud) - per DEC-028

### Rationale

- **AS5600 incompatible with single-track Gray code intent:** AS5600 is a single-magnet absolute
  angle sensor - it requires a single magnet on the rotating part and returns a 12-bit angle value.
  It does not implement Gray code sensing and was architecturally inconsistent with the original
  design intent stated in §1 ("single-track grey encoder").
- **No magnet pocket on shroud:** The AS5600 requires a diametrically magnetised magnet (~6mm dia)
  embedded in or attached to the rotating shroud, adding manufacturing complexity. The capacitive
  approach requires only milled aluminium slot patterns on the rotating shroud - no embedded components.
- **All sensing electronics on PCB:** Capacitive pads and FDC2114 ICs are standard PCB components.
  The shroud is a passive mechanical part.
- **Reliable at slow rotation rates:** The rotors step at human-typing speed (≤10 char/s). The
  FDC2114 conversion time (~1ms/channel at default rate) is well within the inter-step interval.
- **STGC lookup table consistent across variants:** Both 26-char and 64-char rotors use the
  identical CPLD decode mechanism; only table contents and modulus differ. No firmware
  architecture difference between variants.

### Impact

- `design/Electronics/Rotor/Design_Spec.md`: FR-ROT-02, FR-ROT-08, DR-ROT-03, DR-ROT-09, §1,
  §2.1 (full rewrite), §3.2 I²C note, BOM U2 → FDC2114RGHR, U3 added.
- `design/Electronics/Rotor/Rotor_26_Char_Design.md`: §5 ring setting updated; §6 added
  (geometry, track pattern, STGC→position lookup table).
- `design/Electronics/Rotor/Rotor_64_Char_Design.md`: §5 ring setting updated; §7 added
  (geometry, track pattern, STGC→position lookup table).
- `design/Electronics/Rotor/Board_Layout.md`: ASCII diagram updated; PCB Ø92mm (per DEC-028).
- `design/Electronics/Consolidated_BOM.md`: AS5600 row replaced with 2x FDC2114RGHR per rotor
  (60 units total across 30 rotors).
- `design/Electronics/Reflector/STGC_Generator.py`: Original script location noted - should be
  relocated to `design/Electronics/Rotor/` in a future tidy-up commit.

---

## DEC-027 - Rotor Position Readback via JTAG Virtual JTAG (USER0 UDR)

- **Status:** Accepted
- **Date:** 2026-04-12
- **Category:** Hardware / Firmware
- **Area:** Rotor Board CPLD - JTAG Interface; GUI App position display

### Decision

The CPLD on each rotor must expose the **effective rotor position** (STGC-decoded position +
SW1 ring offset, mod N) via **Intel Virtual JTAG** (Altera `VIRTUAL_JTAG` megafunction,
USER0 instruction) over the existing JTAG serial chain. This allows the CM5/JDB to read back
all 30 rotor positions in a single JTAG scan pass without consuming any additional PCB pins or
signal routing.

The effective position register is 6 bits wide (covers both variants; 26-char variant uses
bits [4:0], bit [5] = 0). The CPLD VHDL must instantiate the `VIRTUAL_JTAG` megafunction and
connect the effective position register to the user data register (UDR). Cipher substitution
operates continuously and independently of JTAG state.

### Rationale

- **Standard IEEE 1149.1 BSCAN cannot access internal registers:** Boundary scan (EXTEST/SAMPLE)
  captures I/O pin states only. The effective position is an internal CPLD register result and
  would require dedicated output pins to be visible via standard BSCAN.
- **Virtual JTAG avoids pin consumption:** The existing JTAG chain (TCK, TMS, TDI, TDO/TTD)
  is already routed through all 30 rotors. No additional pins, traces, or connectors are needed.
- **FT232H on JDB supports arbitrary JTAG instructions:** The JDB FT232H (in MPSSE mode) can
  issue the USER0 JTAG instruction to any device in the chain and clock out the UDR contents.
  The CM5 software can therefore poll all 30 positions by iterating through the chain.
- **GUI App feedback requires position data:** The GUI App Design_Spec requires real-time display
  of rotor positions. Virtual JTAG is the only defined data path from rotor CPLDs to the CM5 for
  this purpose - no I²C, SPI, or dedicated signal lines exist between the rotors and the CM5.
- **Non-intrusive to cipher operation:** The `VIRTUAL_JTAG` megafunction is fully synchronous
  with the JTAG clock domain and does not gate or interrupt the cipher substitution logic running
  on the CPLD system clock.

### Impact

- `design/Electronics/Rotor/Design_Spec.md`: FR-ROT-09 to be added (CPLD exposes effective
  position via JTAG USER0 UDR; 6-bit register; readable without interrupting cipher function).
  Note to be added in §2.2 or §3.3 cross-referencing Virtual JTAG and GUI App.
- `design/Software/GUI_App/Design_Spec.md`: Cross-reference to DEC-027 and JTAG readback path
  to be added when GUI App position-display feature is specified.
- CPLD VHDL (future): Must instantiate `VIRTUAL_JTAG` megafunction and connect effective
  position register. Scan sequence: JDB issues USER0; shifts 6-bit UDR from each of 30 rotors
  serially (180 bits total per full scan).
- `design/Electronics/JTAG_Daughterboard/Design_Spec.md`: FT232H MPSSE mode already specified;
  no hardware change required. Software driver must add USER0 scan sequence.

---

## DEC-028 - Split dual-board rotor architecture

- **Status:** Accepted
- **Date:** 2026-04-14
- **Category:** Hardware
- **Area:** Rotor Board - Physical Architecture; PCB Assembly; Position Encoder

### Decision

The rotor is split into two circular PCBs (Board A input side, Board B output side), each
Ø92mm, connected by four single-row 2.54mm THT headers (H_SW3 1x7, H_PWR 1x5, H_JTAG 1x5,
H_SENS 1x5; 22 pins total; mixed gender for physical keying). This resolves the
JLCPCB single-side SMT assembly constraint and simultaneously defines the rotor physical
thickness (~15mm with an 11.8mm board gap). Board A carries the CPLD (U1 EPM570T100I5N),
FDC2114 U2 (Track A encoder, bits[5:3] for N=64 or all 5 sensors for N=26), SW1 (ring
setting DIP), SW2 (forward map select DIP), and J1-J3 (ERM8 male, input side). Board B
carries FDC2114 U3 (Track B, bits[2:0], N=64 only - not populated for N=26), SW3 (return
map select DIP), and J4-J6 (ERF8 female, output side). These internal headers are manually
assembled post-JLCPCB SMT pick-and-place.

The aluminium shroud (Ø100mm outer, 4mm radial wall → Ø92mm inner) floats electrically,
retained by rolling-pin style cylindrical bearings with ceramic or nylon rolling elements for
electrical isolation. Gray code position slots are milled into the inner faces of the shroud
flanges (dish side for Track A / Board A; cover side for Track B / Board B). Bare copper
electrode pads on the PCB flat face at r≈44mm sense the pattern capacitively via FDC2114.

For N=64 the encoder is a dual-track 3+3 bit standard reflected Gray code (6-bit), giving
zero multi-bit transitions including wrap-around (position 63→0). The CPLD decodes via XOR
chain (G2B). For N=26 all 5 STGC sensor electrodes remain on Board A; U4 on Board B is not
populated.

### Rationale

- JLCPCB only performs SMT assembly on one side per PCB; splitting the board places all SMT
  components on the outward-facing side of each board, making both boards fully JLCPCB
  assemblable without manual rework of back-side SMT.
- The ~15mm rotor thickness matches original Enigma rotor proportions.
- The split enables a dual-track capacitive encoder (3+3 bits), achieving a perfect 6-bit
  reflected Gray code for N=64 with zero multi-bit transitions at any rotor position including
  the 63→0 wrap. This replaces the de Bruijn STGC approach (which required a lookup table and
  had no wrap-around guarantee).
- The aluminium shroud is passive: no conductive ink, no embedded magnets. Gray code slots are
  milled CNC features on a standard turned-aluminium part. Bearing isolation keeps the shroud
  electrically floating, preventing ground loops and capacitive coupling errors.

### Alternatives Considered

- **Single-board with back-side hand-soldering:** rejected - complex, unreliable, not
  consistent with high-volume JLCPCB assembly.
- **Magnetic encoder on shroud:** rejected - adds active or passive magnetic components to
  the shroud, increasing mechanical complexity and cost.
- **Optical encoder:** rejected - requires more complex shroud features (apertures or
  reflective strips) and additional LED/photodiode components on the PCB inner face.

### Impact

- `design/Electronics/Rotor/Design_Spec.md`: §1 (two-board architecture, Ø92mm PCBs, shroud
  description), §2.1 (rewritten for capacitive encoder with milled shroud flanges), §3.4
  (J_INT internal headers H_SW3/H_PWR/H_JTAG/H_SENS added), BOM split into Board A / Board B, FR/DR updated.
- `design/Electronics/Rotor/Board_Layout.md`: rewritten for Board A and Board B with
  stacking cross-section; all Ø100mm references updated to Ø92mm.
- `design/Electronics/Rotor/Rotor_64_Char_Design.md`: de Bruijn track replaced by 3+3
  dual-track reflected Gray code; XOR-chain decode; geometry updated to r=44mm / Ø92mm.
- `design/Electronics/Rotor/Rotor_26_Char_Design.md`: single-track all-on-Board-A confirmed;
  geometry updated to r=44mm / Ø92mm; U3 not-populated note added.
- `design/Electronics/Consolidated_BOM.md`: J_INT internal headers (H_SW3 PH1-07-UA/RS1-07-G, H_PWR PH1-05-UA/RS1-05-G, H_JTAG PH1-05-UA/RS1-05-G, H_SENS PH1-05-UA/RS1-05-G) added,
  4 headers per rotor assembly (120 total for 30 rotors).

---

## DEC-029 - Supercapacitor Hold-Up Specification: 25F Abracon Cells, 2S4P, ≥20 s at 15W

- **Status:** Accepted - 2026-04-14
- **Date:** 2026-04-14
- **Category:** Electrical
- **Area:** Power Module - Supercap Bank, Hold-up Specification
- **Supersedes:** DEC-004 (cell reference), DEC-021 (cell capacitance and count)
- **References:** DR-PM-07, DR-PM-09, BOM C_SC1-8

### Decision

The supercapacitor hold-up **minimum requirement is ≥20 seconds** at a **15W shutdown load**
(CM5 typical operating current: 5V x 3A = 15W). The confirmed cell selection (Abracon
ADCR-T02R7SA256MB, 25F/2.7V) in a **2S4P (8-cell)** arrangement provides ≥33.5 seconds.

> ⚠️ **Cell lock:** Cells are **Abracon ADCR-T02R7SA256MB, 25F/2.7V** in **2S4P (8 cells)**.
> Stale values **22F**, **33F**, **37.5F**, **21.7 s**, and **24.8 s** must never reappear.
> Any proposed cell or configuration change requires recalculating hold-up against the ≥20 s
> rule below using the **15W** load figure.

### Correct Load Figure

> ⚠️ The CM5 draws **5V x 3A = 15W** during typical operation. When a power-loss event
> occurs, the CM5 is running at this load and continues to draw it throughout the OS shutdown
> sequence (~10-15 s). Earlier documents used 5W (1A) which significantly overstated margin.
> **All hold-up calculations must use 15W** as the minimum design load.

### Configuration

| Parameter | Value |
| :--- | :--- |
| Cell part number | Abracon ADCR-T02R7SA256MB |
| Cell capacitance | 25F / 2.7V each |
| Configuration | 2S4P - 8 cells total (C_SC1-C_SC8) |
| Effective capacitance | 50F at 5.4V |
| Charge voltage (2S) | 5.4V |
| Block footprint | 37mm x 77mm (2 columns x 4 rows, 20mm pitch) |
| Shadow zone | 41mm x 81mm |

### Hold-Up Calculation

Usable energy from a capacitor bank discharged from V\_hi to V\_lo:

> **E = 1/2 x C x (V\_hi² - V\_lo²)**

Load power during shutdown: **P = 15W** (CM5 at 5V x 3A typical).

Hold-up duration: **t = E x η / P**

#### Conservative model (pure-buck - LTC3350 loses regulation at V\_lo ≈ 4.75V)

| Step | Calculation | Result |
| :--- | :--- | :--- |
| Usable energy | 1/2 x 50 x (5.4² - 4.75²) | 164.9J |
| Hold-up @ 15W | 164.9J / 15W | **11.0 s ❌** |

This model is unrealistic - the LTC3350 is a 4-switch synchronous buck-boost, not a simple
buck. It is shown here only to illustrate that relying on the cap voltage staying above the
output voltage is not sufficient at this load.

#### Realistic model (LTC3350 boost mode, V\_lo = 2.0V, η = 80%)

The LTC3350 actively boosts the supercap voltage to maintain 5V output in backup mode.
Minimum practical V\_CAP of ~2.0V protects cells from over-discharge (1.0V/cell for 2S).

| Step | Calculation | Result |
| :--- | :--- | :--- |
| Stored energy (V\_lo = 2.0V) | 1/2 x 50 x (5.4² - 2.0²) | 629J |
| Delivered (η = 80%) | 629J x 0.80 | **503J** |
| Hold-up @ 15W | 503J / 15W | **≥33.5 s ✔** |

#### Sensitivity to LTC3350 efficiency at 15W load

| Efficiency | Delivered energy | Hold-up | Pass ≥20 s? |
| :--- | :--- | :--- | :--- |
| 85% | 535J | 35.6 s | ✔ |
| 80% | 503J | 33.5 s | ✔ |
| 75% | 472J | 31.5 s | ✔ |
| 67% | 421J | 28.1 s | ✔ |
| 48% (minimum) | 302J | 20.1 s | ✔ (edge) |

The ≥20 s rule is satisfied even if converter efficiency degrades to ~48%, which is far below
any credible operating point for a synchronous buck-boost at these voltages and currents.

### Rationale

- **Why 2S4P (8 cells) and not 2S3P (6 cells)?** At 15W, 2S3P (37.5F) delivers 377J at 80%
  efficiency → 25.2 s. This passes the 20 s rule but leaves only 26% margin. 2S4P (50F)
  delivers 503J → 33.5 s, a 68% margin, providing meaningful headroom against LTC3350
  efficiency variation, higher CM5 loads during bring-up, and supercap aging.
- **Why 15W?** The CM5 module draws 5V x 3A under typical operating load. When power is lost,
  the OS shutdown sequence takes ~10-15 s during which the CM5 continues at near-full load.
  Using 5W (1A) as the design load significantly understates the required hold-up margin and
  was an error in DEC-004 and DEC-021.
- **0.5A PoE charge current (from DEC-004) retained:** charge power = 5.4V x 0.5A = 2.7W,
  unaffected by the cell count increase. Charge time from fully depleted ≈ **9 minutes**
  (100F per series position x 2.7V / 0.5A = 540 s). PoE utilisation calculations in
  Certification\_Evidence are unaffected.

### Constraints

- Do not change the cell MPN, cell count, or configuration without re-running the hold-up
  calculation at **15W** against the ≥20 s rule and updating DR-PM-07, DR-PM-09, and this DEC.
- LTC3350 CELLS register must remain configured for 2 series cells (CELLS = 0x01).
- PCB shadow zone: 41mm x 81mm. No traces on L1-L6 within this zone (enclosure rib clearway).

---

## DEC-030 - 5V_MAIN Backup Switchover Transient Fix (R14, R30, C35)

- **Status:** Accepted
- **Date:** 2026-04-14
- **Category:** Electrical
- **Area:** Power Module - LTC3350 Backup Switchover, 5V_MAIN Bulk Capacitance

### Issue

At 3A load (CM5 typical draw), the existing 5V_MAIN bulk capacitance (C9=22µF + C10=22µF +
C13=10µF = 54µF total) provides only 2.59µs before PWR_GD deasserts
(54µF x 144mV / 3A). The LTC3350 at default 200kHz (5µs/cycle) gets only 0.52 cycles
to complete backup switchover - INSUFFICIENT.

### Root Cause Analysis

- Old R14 = 28.7kΩ → backup threshold = 4.644V; PWR_GD deassert = 4.50V; gap = 144mV
- LTC3350 RT=INTVCC (no resistor) = 200kHz → 5µs/cycle
- 54µF x 144mV / 3A = 2.59µs = 0.52 cycles → FAILS

### Fix (three combined changes)

1. **R14: 28.7kΩ → 30.1kΩ** - raises backup threshold to 4.812V; new gap = 312mV
2. **R30: new 33.2kΩ resistor** (LTC3350 RT pin to GND) - sets switching frequency to 400kHz (2.5µs/cycle)
3. **C35: 2x Samsung CL32B226KAJNNNE** (22µF 25V X7R 1210) in parallel = 44µF additional bulk on 5V_MAIN

### Result with Fix

- Total bulk = 54µF + 44µF = 98µF
- Time window = 98µF x 312mV / 3A = **10.2µs**
- Cycles at 400kHz = 10.2µs / 2.5µs = **4.1 cycles ✔**
- False-trigger headroom: 5Vx0.98 - 4.812V = 88mV (LTC3350 ~12µs deglitch filters brief dips)

### Component Selection Rationale for C35

- **Selected: 2x Samsung CL32B226KAJNNNE** (22µF 25V X7R 1210, existing BOM part)
  - ESR ≈ 10mΩ (negligible, stable -55°C to +125°C)
  - Uses existing qualified BOM part - no new component qualification needed
  - 4.1 cycles margin at all operating temperatures
- Evaluated and rejected: HZA107M025X16T-F (CDE hybrid polymer-Al, 30mΩ ESR, 4.56 cycles at
  +20°C but marginal 2.1 cycles at -40°C - not selected as existing BOM part is sufficient)
- Evaluated and rejected: KEMET T495X107K025ATA150 (MnO₂ tantalum, 150mΩ ESR - V_ESR = 450mV
  at 3A, EXCEEDS entire 312mV budget; also MnO₂ tantalum short-circuit failure mode is unsafe
  in low-impedance power supply)

### No Change Required To

- eFuse (HV input side)
- LDO TPS75733 (stays in regulation)
- MIC1555/R28/C32 (3.01s timing unchanged)

---

## DEC-031 - CM5 Virtual Keyboard (Key Injection) Feature Architecture

- **Status:** Decided
- **Date:** 2026-04-14
- **Category:** Electrical / Firmware
- **Area:** Stator Board - I²C Expanders, Servo, External Keyboard Source Mux
- **Author:** Izzyonstage & GitHub Copilot

### Summary

Design decision for enabling the CM5 to autonomously inject virtual keypresses into the Enigma
cipher pipeline, enabling automated rotor configuration testing and fully autonomous cipher operation.

### Problem

The Enigma machine requires a physical keypress to advance rotors and inject input into the cipher
pipeline. For autonomous CM5 operation (testing, remote cipher operation), a mechanism is needed to
inject keypresses without human intervention.

### Decision

Add three I²C expanders to the Stator board on the shared I²C-1 bus:

1. **MCP23017 @ 0x20 (U6):** 16-bit GPIO expander for ENC_IN/ENC_OUT monitoring. Replaces
   CM5 GPIO 4-15 (12 pins freed).
   - GPA[5:0] = ENC_IN[5:0] monitor (inputs)
   - GPB[5:0] = ENC_OUT[5:0] monitor (inputs)
   - GPA[6:7], GPB[6:7] = spare

2. **MCP23017 @ 0x21 (U7):** 16-bit GPIO expander for virtual key data injection, external
    keyboard-source mux control, and SYS_RESET_N (replaces CM5 GPIO 26 - 1 pin freed).
    - GPA[5:0] = CM5_KEY_DATA[5:0] (outputs - 6-bit virtual key data bus)
    - GPA[6] = KEY_CM5_ACTIVE (output - mux select: 0=physical keyboard, 1=CM5 virtual)
    - GPA[7] = SYS_RESET_N (output - system-wide CPLD reset)
    - GPB[7:0] = spare / reserved

### Rationale for MCP23017 (x2)

- 32 GPIO total provides headroom for future I/O expansion.
- SYS_RESET_N migration to expander reduces LINK-BETA pin count and frees CM5 GPIO 26.
- All keyboard-source mux and reset control signals remain co-located with the Stator CPLD.
- Only 2 wires (I²C SDA/SCL) needed on LINK-BETA instead of 13 discrete signal pins.

### External Keyboard Source Mux

- GPA[6] on U7 drives `KEY_CM5_ACTIVE` for the external keyboard-source mux at the Stator
  keyboard-source entry point.
- `KEY_CM5_ACTIVE=0`: the physical keyboard 6-bit source bus is forwarded to the encryption pipeline.
- `KEY_CM5_ACTIVE=1`: `CM5_KEY_DATA[5:0]` is forwarded instead.
- The selected implementation uses `U4` and `U5`, both `74HC157PW-Q100,118` quad 2:1 mux devices,
  to cover the 6-bit path, with both `E` pins tied to GND so the mux is always enabled while the
  board is powered.
- GPA[7] now carries `SYS_RESET_N`, fully populating the U7 GPA port and leaving U7 GPB
  completely spare / reserved for future use.

### Net Effect on LINK-BETA

- **Freed (13 pins):** ENC_IN[5:0] (x6), ENC_OUT[5:0] (x6), SYS_RESET_N (x1).
- **Freed:** pins 8 (SYS_RESET_N), 12-17 (ENC_IN[5:0]), and 19-24 (ENC_OUT[5:0]) were freed by this decision.
- **Later reuse:** DEC-036 reallocated the former monitor block into grouped LINK-BETA power rails
  (5V_MAIN, 3V3_ENIG, and GND) once the Stator-side 5V needs were formalised.
- R6 pull-up (10kΩ to 3V3_ENIG) on Stator keeps SYS_RESET_N HIGH at power-up (CPLDs out of reset).

### Net Effect on CM5 GPIO

- **Freed (13 pins):** GPIO 4-15 (ENC monitoring), GPIO 26 (SYS_RESET_N).
- No new CM5 GPIO assignments required.

### I²C Bus Address Map (no conflicts)

| Address | Device | Location |
| :--- | :--- | :--- |
| 0x09 | LTC3350 | Power Module |
| 0x0B | Smart Battery | Power Module |
| 0x20 | MCP23017 (U6) | Stator |
| 0x21 | MCP23017 (U7) | Stator |
| 0x22 | MCP23017 (U8) | Stator |
| 0x23 | MCP23017 (U1) | Settings Board |
| 0x24 | MCP23017 (U2) | Settings Board |
| 0x25 | MCP23017 (U3) | Settings Board |
| 0x28 | STUSB4500 | Power Module |
| 0x40 | INA219 (U12) | Power Module |
| 0x45 | INA219 (U2) | Stator |

---

## DEC-032 - Settings Board: Panel-Mount Configuration Controls with CM5 Override

- **Status:** Decided
- **Date:** 2026-04-14
- **Category:** Electrical / HMI
- **Area:** Stator Board - Configuration Interface; new Settings Board PCB
- **Author:** Izzyonstage & GitHub Copilot

### Summary

Replace the Stator Board's DIP switches (routing + reflector map) with panel-mount toggle switches
plus discrete RGB indicators on a dedicated Settings Board PCB. The Settings Board connects to the
Stator via I²C only (no parallel signal wiring). A new MCP23017 expander (U8 @ 0x22) on the
Stator Board bridges the I²C configuration data to the CPLD config input pins and issues the
Stator-only `CFG_APPLY_N` reload pulse.

### Problem

The Stator's DIP switches (SW1, SW2) are internal PCB components, requiring the enclosure to be
opened to change the routing or reflector map configuration. This is inconvenient for regular use.
Additionally, the CM5 has no way to programmatically override the configuration.

### Decision

1. Remove SW1 and SW2 from the Stator Board.
2. Add a new Settings Board PCB (panel-mount, right side of enclosure top face near rotors) with:
   - 10 panel toggle switches plus 12 discrete RGB indicators (Bank 1 = 4 config toggles + 1 source-status LED, Bank 2 = 6 config toggles + 1 source-status LED)
   - 1 momentary active-low `CFG_APPLY_N` input; a board-mounted tactile switch actuated through the enclosure is acceptable
   - U1 (MCP23017 @ 0x23): reads the Settings Board user-intent config plus `CFG_APPLY_N`
   - U2 (MCP23017 @ 0x24): drives Bank 1 LED anodes + Bank 1 colour rails
   - U3 (MCP23017 @ 0x25): drives Bank 2 LED anodes + Bank 2 colour rails
3. Add U8 (MCP23017 @ 0x22) to the Stator Board. Its outputs drive the CPLD configuration
   input pins directly (`CFG_ROUTE[3:0]` and `CFG_REFMAP[5:0]`). Pull-downs R16-R26 are retained on the CPLD
   input pins to hold safe defaults (all-zero) at power-up before CM5 initialises U8.
4. CM5 firmware (enigma daemon):
   - Reads U1 to get user-intent config state
   - Decides in software whether each bank forwards user intent or uses a CM5-defined preset
   - Drives the bank source indicators via `CFG_ROUTE_CM5_ACTIVE` / `CFG_REFMAP_CM5_ACTIVE`
     (green = user intent forwarded, red = CM5-defined)
   - After writing final config to U8, pulses `CFG_APPLY_N` (U8 GPA[4]) LOW→HIGH to
     trigger a Stator-only configuration reload
5. Physical `CFG_APPLY_N` button on Settings Board: reads via U1 GPB[7]; CM5 daemon polls
   this and triggers the same U8 write + `CFG_APPLY_N` pulse when pressed. The switch may be
   a board-mounted tactile part with a simple actuator/plunger through the enclosure rather than a
   true panel-mount pushbutton.

### LED Colour Scheme

- **Green illumination:** Bank is forwarding Settings Board user intent; illuminated bits show the active forwarded configuration.
- **Red illumination:** Bank is in CM5-defined mode; illuminated bits show the CM5-programmed configuration.
- Per-bank shared colour rail: all switches in a bank share the same colour (green or red) while individual anode control shows which bits are set.

### I²C Address Assignments (new)

| Address | Device | Location |
| :--- | :--- | :--- |
| 0x22 | MCP23017 (U8) | Stator - CPLD config output driver |
| 0x23 | MCP23017 (U1) | Settings Board - switch input reader |
| 0x24 | MCP23017 (U2) | Settings Board - Bank 1 LED anode + colour rail driver |
| 0x25 | MCP23017 (U3) | Settings Board - Bank 2 LED anode + colour rail driver |

### Rationale

- Replacing DIP switches with panel toggles makes configuration user-accessible without opening the enclosure.
- I²C-centric wiring between Settings Board and Stator keeps the cable harness minimal vs 10+
  parallel signal wires; the active harness is now a 6-wire JST PH link carrying `3V3_ENIG`,
  `5V_MAIN`, `GND`, `SDA`, `SCL`, and a dedicated LED return GND.
- Retaining R16-R26 pull-downs ensures the CPLD receives a safe all-zero default at power-up
  (no plugboard insertion, physical reflector pass-through) before the CM5 writes the desired config.
- CM5 remains the single authority arbiter, allowing GUI presets to forward or override the Settings
  Board user-intent image while still exposing that authority state through the indicators.
- RGB illumination (green/red) provides immediate visual feedback on configuration source with no
  additional UI required.

> **Supersession note:** This decision records the original Settings Board migration intent. The
> active address map and harness definition were later refined by the post-audit cleanup:
> `U1 @ 0x23`, `U2 @ 0x24`, `U3 @ 0x25`, and a 6-wire JST PH harness carrying
> `3V3_ENIG`, `5V_MAIN`, `GND`, `SDA`, `SCL`, `GND`.

### Impact

- **Stator Board:** SW1 and SW2 removed; U8 and J13 added; `CFG_APPLY_N` added to the Stator-only reset/apply path
- **New Board:** Settings Board added to system BOM
- **Firmware:** enigma daemon startup sequence must: read U1, determine final applied config,
  write U8, pulse `CFG_APPLY_N`, update U2 / U3
- **CPLD / reset path:** the Stator-only `CFG_APPLY_N` pulse is combined with `SYS_RESET_N` so the
  Stator CPLD can be reloaded without forcing a global system reset; implemented with
  `SN74LVC1G08DBVR` on the Stator

---

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

---

## DEC-034 - Switch Hardware Refresh: Settings Board Toggle + Discrete RGB LED, Ruggedized PM SW1

- **Status:** Decided
- **Date:** 2026-04-16
- **Category:** Electrical / HMI / Mechanical interface
- **Area:** Settings Board; Power Module front-panel switchgear
- **Author:** Izzyonstage & GitHub Copilot

### Summary

Replace the old unified Marquardt rocker-switch assumption with two purpose-specific solutions:
E-Switch 200-series toggle switches plus discrete RGB LEDs on the Settings Board, and the Adafruit
4660 rugged metal RGB latching switch for Power Module SW1.

### Problem

The previous design direction forced the Settings Board and Power Module onto one shared switch
family even though the two locations serve different aesthetic, mechanical, and service roles. The
Settings Board benefits from classic toggle controls with separate indicators, while the Power Module
benefits from a sealed, rugged metal power switch with a more robust panel interface and
spade-terminal wiring.

### Decision

1. **Settings Board switch selection:** Use `200MSP1T2B4M2QE` for the 10 configuration toggles
   (`SW_B1[3:0]`, `SW_B2[5:0]`).
2. **Settings Board LED selection:** Use `WP154A4SEJ3VBDZGW/CA` for all 12 Settings Board indicators
   (10 config-bit indicators + 2 source-status indicators).
   - Kingbright 5mm common-anode RGB through-hole LED
   - Full RGB operation is available under CM5 control
   - Separate red, green, and blue series resistors per switch allow colour balancing under nominal 5V operation
3. **Settings Board LED topology update:** Change the indicator drive from the previous
   common-cathode / PNP sourcing concept to:
   - individual LED anode drive from `U2` / `U3`
   - per-bank red / green / blue shared cathode rails
   - low-side BSS138 sink devices on each bank colour rail
4. **Power Module switch selection:** Use Adafruit `4660` for `SW1`.
   - Latching rugged metal power switch
   - RGB ring illumination
   - 16mm panel cutout
   - 2.8mm pin terminals routed to PCB-mounted 2.8mm male spade tabs for serviceable harnessing

### Rationale

- The Settings Board now matches the machine's more period-correct control aesthetic better than a
  rocker-based panel.
- Separate LEDs give more freedom over indicator placement and future panel detailing than
  integrated illuminated switches.
- The Power Module switch benefits from a tougher sealed metal body and clearer power-switch
  identity than the previous shared-family concept.
- Breaking the false BOM unification removes a mechanical compromise that was not buying any real
  electrical simplification.

### Impact

- **Settings Board Design_Spec / Board_Layout:** switch type, LED type, and LED driver polarity all
  change
- **Consolidated BOM:** split the old shared rocker line into distinct Settings Board and Power
  Module entries
- **Power Module Design_Spec:** SW1 selection and harnessing updated to the rugged metal switch
- **Copilot handoff / component tracking:** the old Marquardt-all-13-switches assumption is retired

---

## DEC-035 - HID Keyboard and Lightboard Use a 40-Position QWERTY-Derived Layout for the 64-Character Code Space

- **Status:** Decided
- **Date:** 2026-04-17
- **Category:** HMI / Mechanical interface / HID logic
- **Area:** HID Assembly; Encoder Board; Rotor actuation interface
- **Author:** Izzyonstage & GitHub Copilot

### Summary

Freeze the HID operator interface as a **40-position physical layout** rather than a 64-key physical
array. The printable positions are `[a-z0-9+=]`, with **Left Shift** and **Right Shift** on the
bottom row to access uppercase alphabetic codes. The machine still retains its full 64-character
logical alphabet.

### Problem

Older docs had drifted toward describing the HID assembly as a literal 64-key keyboard, which no
longer matched the intended operator experience. That made the purchased keyboard-switch quantity,
mechanical lever count, and Encoder input mapping ambiguous, and risked re-introducing separate
uppercase-only key positions that were never part of the intended user-facing layout.

### Decision

1. **Physical keyboard layout:** Use **40 total switch positions** in the HID keyboard.
   - 26 lowercase alphabetic keycaps: `a-z`
   - 10 numeric keycaps: `0-9`
   - 2 symbol keycaps: `+` and `=`
   - 2 modifier keycaps: **Left Shift** and **Right Shift**
2. **Logical 64-character repertoire:** Preserve the full 64-character code space in Encoder logic.
   - Unshifted alphabetic keys emit `a-z`
   - Shifted alphabetic keys emit `A-Z`
   - Digits and `+` / `=` are unchanged by Shift
   - Therefore the HID path still covers 26 lowercase + 26 uppercase + 10 digits + 2 symbols = 64
     unique character codes
3. **Physical lightboard layout:** Mirror the same QWERTY-derived printable positions on the
   lightboard instead of introducing dedicated uppercase-only legends or lamp locations.
4. **Mechanical interface:** The rotor actuation mechanism shall therefore be designed around
   **40 physical key levers**, not 64.

### Rationale

- This matches the intended operator experience of a keyboard-like panel instead of an abstract
  64-button matrix.
- It preserves the full 64-character cipher alphabet without wasting front-panel area on
  duplicated uppercase-only key positions.
- It aligns the purchased custom keyboard switch count and the HID mechanical packaging with a more
  realistic enclosure layout.

### Impact

- **HID Assembly Design_Spec:** layout, key count, and purchased switch definition fixed at 40
  positions
- **Encoder Design_Spec:** HID mapping clarified as 40 physical inputs projected into a 64-code
  logical space
- **Rotor Actuation Assembly:** lever count reduced from 64 to 40
- **Consolidated BOM / component tracking:** keyboard switch quantity updated to 40 and tied to the
  pseudo datasheet for the purchased marketplace part

---

## DEC-036 - LINK-BETA Former Monitor Pins Reallocated as Grouped Power Rails

- **Status:** Decided
- **Date:** 2026-04-18
- **Category:** Electrical / Power distribution
- **Area:** Controller Board J2 (LINK-BETA), Stator Board J8, Settings/Servo 5V branch
- **Author:** Izzyonstage & GitHub Copilot

### Summary

Keep LINK-BETA as the 40-pin Samtec ERF8/ERM8 pair from DEC-015, but stop carrying a large legacy
spare block. Reallocate the former ENC monitor positions into grouped power rails: **4 contiguous
5V_MAIN pins**, **3 additional 3V3_ENIG pins**, and **3 additional GND return pins**.

### Problem

After DEC-031 migrated ENC_IN/ENC_OUT monitoring and SYS_RESET_N to Stator-side I²C expanders, a
large section of LINK-BETA remained unused. That left the connector under-utilised while the
Stator-side 5V branch had only 2 pins (1.0A connector capacity) available for the servo and the
Settings Board indicator rail.

### Decision

Retain the 40-pin LINK-BETA connector and apply this active allocation:

| Pin | Signal | Direction | Notes |
| :--- | :--- | :--- | :--- |
| 1 | GND | - | JTAG leading shield |
| 2 | TCK | CTRL→Stator | JTAG clock |
| 3 | GND | - | TCK/TMS inter-pin shield |
| 4 | TMS | CTRL→Stator | JTAG mode select |
| 5 | GND | - | TMS/TDI inter-pin shield |
| 6 | TDI | CTRL→Stator | JTAG data in |
| 7 | GND | - | TDI/GND inter-pin shield |
| 8 | GND | - | Extra JTAG trailing/guard ground |
| 9 | GND | - | JTAG trailing shield |
| 10 | GND | - | Isolation moat pin 1 |
| 11 | GND | - | Isolation moat pin 2 |
| 12 | I2C1_SDA | Bidir | Shared Stator/Settings I²C-1 data extension |
| 13 | I2C1_SCL | Bidir | Shared Stator/Settings I²C-1 clock extension |
| 14 | 5V_MAIN | PM→Stator | Grouped 5V_MAIN feed |
| 15 | 5V_MAIN | PM→Stator | Grouped 5V_MAIN feed |
| 16 | 5V_MAIN | PM→Stator | Grouped 5V_MAIN feed |
| 17 | 5V_MAIN | PM→Stator | Grouped 5V_MAIN feed |
| 18 | GND | - | 5V_MAIN return moat |
| 19 | 3V3_ENIG | PM→Stator | Additional 3V3_ENIG feed |
| 20 | 3V3_ENIG | PM→Stator | Additional 3V3_ENIG feed |
| 21 | 3V3_ENIG | PM→Stator | Additional 3V3_ENIG feed |
| 22 | GND | - | Grouped return for the mixed-power block |
| 23 | GND | - | Grouped return for the mixed-power block |
| 24 | GND | - | Grouped return for the mixed-power block |
| 25 | GND | - | TTD_RETURN leading shield |
| 26 | TTD_RETURN | Stator→CTRL | JTAG TDO short-path return |
| 27 | GND | - | TTD_RETURN trailing shield |
| 28-35 | 3V3_ENIG | PM→Stator | Existing 3V3_ENIG pass-through block |
| 36-40 | GND | - | Main power return block |

### Rationale

- The connector footprint, mating safety, and stack geometry from DEC-015 stay unchanged.
- Grouping all four 5V_MAIN pins together simplifies routing and clearly separates the 5V branch
  from the I²C and JTAG regions.
- 4 x 5V_MAIN pins provide **2.0A connector capacity**, giving ample headroom above the current
  0.74A downstream budget (Settings Board indicators + servo).
- The extra 3V3_ENIG pins make LINK-BETA electrically overprovisioned, so the upstream 3.0A LDO
  remains the only practical 3V3 limit.

### Impact

- Controller / Stator LINK-BETA tables updated to grouped 5V_MAIN, 3V3_ENIG, and GND allocations
- Settings Board and Stator docs updated to source `5V_MAIN` from LINK-BETA pins **14-17**
- Historical Controller probe-access concept repurposed from unused spare pads to power/I²C
  bring-up probes

### Cross-ref

DEC-015 (40-pin connector retained). DEC-031 (freed the former monitor pins). DEC-034
(Settings Board full-RGB 5V indicator branch creates a standing Stator-side 5V load). DEC-040
(all Diagnostics Banks removed from active specs; revisit only during coupon review).

---

## DEC-037 - LINK-BETA Pin Map Regrouped Around Dedicated JTAG and I2C Guard Bands

- **Status:** Decided
- **Date:** 2026-04-18
- **Category:** Electrical / Interconnect definition
- **Area:** Controller Board J2 (LINK-BETA), Stator Board J8, historical Controller bring-up probe concept
- **Author:** Izzyonstage & GitHub Copilot

### Summary

Retain the 40-pin LINK-BETA connector from DEC-015, but replace the DEC-036 allocation with a cleaner
rail-and-guard arrangement: front power cluster, front 3V3 cluster, dedicated guarded JTAG block,
guarded I2C pair, then a rear power cluster. This becomes the only active LINK-BETA pin-definition
table.

### Problem

DEC-036 solved the spare-pin problem, but the resulting active map split `3V3_ENIG` into a small
middle block plus a rear block and left the overall pin order harder to reason about in board docs
and bring-up references. The design intent now is to preserve a dedicated guarded JTAG region, keep
`TTD_RETURN` near that JTAG region, keep I2C shielded, and make the remaining rails cleaner to read
without relying on historical "additional" or "pass-through" distinctions.

### Decision

Adopt this LINK-BETA allocation as the active mapping:

| Pin | Signal | Direction | Notes |
| :--- | :--- | :--- | :--- |
| 1 | GND | - | Front power return / guard |
| 2 | GND | - | Front power return / guard |
| 3 | 5V_MAIN | PM→Stator | Grouped 5V_MAIN feed |
| 4 | 5V_MAIN | PM→Stator | Grouped 5V_MAIN feed |
| 5 | GND | - | Front power return / guard |
| 6 | 3V3_ENIG | PM→Stator | Grouped 3V3_ENIG feed |
| 7 | 3V3_ENIG | PM→Stator | Grouped 3V3_ENIG feed |
| 8 | 3V3_ENIG | PM→Stator | Grouped 3V3_ENIG feed |
| 9 | 3V3_ENIG | PM→Stator | Grouped 3V3_ENIG feed |
| 10 | 3V3_ENIG | PM→Stator | Grouped 3V3_ENIG feed |
| 11 | 3V3_ENIG | PM→Stator | Grouped 3V3_ENIG feed |
| 12 | 3V3_ENIG | PM→Stator | Grouped 3V3_ENIG feed |
| 13 | GND | - | Front 3V3 return / guard |
| 14 | GND | - | Front 3V3 return / guard |
| 15 | TCK | CTRL→Stator | JTAG clock |
| 16 | GND | - | TCK/TMS guard |
| 17 | TMS | CTRL→Stator | JTAG mode select |
| 18 | GND | - | TMS/TDI guard |
| 19 | TDI | CTRL→Stator | JTAG data in |
| 20 | GND | - | TDI/TTD_RETURN guard |
| 21 | TTD_RETURN | Stator→CTRL | JTAG TDO short-path return |
| 22 | GND | - | TTD_RETURN trailing guard |
| 23 | GND | - | JTAG/I2C isolation ground |
| 24 | I2C1_SDA | Bidir | Shared Stator/Settings I²C-1 data extension |
| 25 | GND | - | SDA/SCL guard |
| 26 | I2C1_SCL | Bidir | Shared Stator/Settings I²C-1 clock extension |
| 27 | GND | - | I2C/rear-power isolation ground |
| 28 | GND | - | Rear power guard |
| 29 | 3V3_ENIG | PM→Stator | Grouped 3V3_ENIG feed |
| 30 | 3V3_ENIG | PM→Stator | Grouped 3V3_ENIG feed |
| 31 | 3V3_ENIG | PM→Stator | Grouped 3V3_ENIG feed |
| 32 | 3V3_ENIG | PM→Stator | Grouped 3V3_ENIG feed |
| 33 | 3V3_ENIG | PM→Stator | Grouped 3V3_ENIG feed |
| 34 | 3V3_ENIG | PM→Stator | Grouped 3V3_ENIG feed |
| 35 | 3V3_ENIG | PM→Stator | Grouped 3V3_ENIG feed |
| 36 | GND | - | Rear 3V3 return / guard |
| 37 | 5V_MAIN | PM→Stator | Grouped 5V_MAIN feed |
| 38 | 5V_MAIN | PM→Stator | Grouped 5V_MAIN feed |
| 39 | GND | - | Rear power return / guard |
| 40 | GND | - | Rear power return / guard |

### Rationale

- Preserves a dedicated guarded JTAG block and keeps `TTD_RETURN` adjacent to the other JTAG nets.
- Preserves a separately guarded I2C pair instead of burying it inside a mixed power cluster.
- Keeps **4 x `5V_MAIN` pins = 2.0A connector capacity**, which remains above the current
  **0.74A** downstream Stator-side 5V budget.
- Expands LINK-BETA to **14 x `3V3_ENIG` pins = 7.0A connector capacity**, so the connector remains
  comfortably above the upstream **3.0A** LDO limit.
- Removes active-doc wording distinctions like "additional" or "pass-through" from the pin map; the
  table is now a straightforward interface definition.

### Supersession / Obsolescence

- **DEC-036 is obsolete** and retained only as historical traceability for the prior grouped-rail map.
- The **pin-allocation tables** recorded in **DEC-015** and **DEC-036** are obsolete as active
  interface definitions; DEC-037 is now the sole authority for LINK-BETA pin placement.
- **DEC-031** remains valid as the historical migration of `SYS_RESET_N` and `ENC_IN/ENC_OUT` off the
  connector, but it no longer defines the active pin order.

### Impact

- Controller and Stator LINK-BETA tables updated to the DEC-037 map.
- Power-budget docs updated to the new **7.0A** LINK-BETA `3V3_ENIG` connector capacity.
- Stator/Settings power-feed references updated to the new `5V_MAIN` pins **3, 4, 37, 38**.
- Historical Controller bring-up probe concept remapped to the new LINK-BETA rail and control-pin
  positions.

### Cross-ref

DEC-015 (40-pin connector retained), DEC-031 (functions moved off the connector), DEC-034
(Stator-side 5V indicator load), DEC-036 (obsolete prior grouped-rail map), DEC-040
(all Diagnostics Banks removed from active specs; revisit only during coupon review).

---

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

---

## DEC-039 - Enclosure-Connected Boards Use GND_CHASSIS; Daughterboards Are Exempt

- **Status:** Decided
- **Date:** 2026-04-20
- **Category:** Electrical / EMC
- **Area:** All boards - grounding, mounting, and enclosure bonding
- **Author:** Izzyonstage & GitHub Copilot

### Summary

Standardise `GND_CHASSIS` across the enclosure-connected parts of the system: every
enclosure-connected board carries a local `GND_CHASSIS` net tied to its mounting holes and any
deliberate enclosure-contact or shield-contact features, while non-chassis-connected daughterboards
are exempt. The only galvanic `GND` ↔ `GND_CHASSIS` bond remains on the Power Module at the common
power-entry point immediately before the eFuse.

### Problem

The prior documentation mixed two different grounding models:

- some documents treated `GND_CHASSIS` as a board-specific feature used only on externally exposed
  boards
- other documents already relied on a shared chassis domain and a single Power Module bond point
- JDB-specific wording in DEC-023 needed to remain valid, but the prior update had over-corrected by
  requiring even non-chassis-connected daughterboards to implement `GND_CHASSIS`

That ambiguity makes isolated board review harder and risks future designs creating inconsistent
mounting-hole grounding or accidental secondary bond points.

### Decision

1. **Every enclosure-connected board implements `GND_CHASSIS`.**
   - Tie mounting holes and other defined enclosure-contact / shield-contact mechanical features to
     the local `GND_CHASSIS` net.
   - This applies to removable boards and fixed boards that bond into the enclosure structure.

2. **Non-chassis-connected daughterboards are exempt.**
   - Board-mounted daughterboards that do not connect directly to the enclosure do not need their own
     `GND_CHASSIS` net.
   - They are treated as electrical / mechanical extensions of the host board instead.
   - The JTAG Daughterboard (JDB) is the canonical example of this exception.

3. **The enclosure is the distributed chassis return path.**
   - The metal enclosure and bonded mounting hardware form one continuous chassis domain across the
     machine.
   - Transients and shield currents are intended to flow through that chassis domain toward the
     single galvanic bond instead of being dumped into local logic/power `GND` on intermediate boards.

4. **Only the Power Module may bond `GND` to `GND_CHASSIS`.**
   - The sole intentional galvanic bond is at the common power-entry point on the Power Module,
     immediately before the eFuse.
   - This location is downstream of the source-selection / OR-ing stage, so the bond point remains
     correct regardless of whether PoE, USB-C, or battery input is active.

5. **Local board restriction.**
   - All non-Power-Module boards that implement `GND_CHASSIS` must keep that local chassis net
     isolated from signal/power `GND`.
   - Local connector shields, EMI landing pads, and mounting features may join the chassis domain,
     but they must not create a second DC bond.

### Rationale

- Gives enclosure-connected boards the same grounding rule when viewed in isolation.
- Preserves the legitimate exemption for internal hat/daughterboard modules.
- Makes mounting-hole treatment consistent across all PCB designs.
- Preserves the EMC intent of using the enclosure as the transient/shield return path.
- Keeps the single-point bond at the best location for all input-source combinations.

### Supersession / Obsolescence

- **DEC-023** remains valid as the concrete JDB instance of the daughterboard exemption.
- Earlier wording in the Global Routing Spec that left the exemption implicit and under-specified is
  obsolete.

### Impact

- Update `design/Standards/Global_Routing_Spec.md` to make the enclosure-connected-board rule and
  daughterboard exemption explicit.
- Add or revise grounding cross-references in every board-level `Design_Spec.md` so the single-bond
  rule is visible even when a board spec is read on its own.
- Keep the Power Module documentation explicit that the single bond is located at the common
  power-entry point immediately before the eFuse.

### Cross-ref

DEC-020, DEC-023, DEC-038, `design/Standards/Global_Routing_Spec.md §4-§5`,
`design/Standards/Certification_Evidence.md §2.2`.

---

## DEC-040 - Diagnostics Banks Removed from Active Design Specs Pending Coupon Review

- **Status:** Decided
- **Date:** 2026-04-25
- **Category:** Documentation / Test-access strategy
- **Area:** All boards - active design specs, board layouts, and future coupon planning
- **Author:** Izzyonstage & GitHub Copilot

### Summary

All Diagnostics Banks have been removed from all design specs, as these are not production board
components and will be re-addressed later when reviewing the coupon implementations TODO item.

### Problem

The documentation had drifted into an inconsistent state:

- some active `Design_Spec.md` and `Board_Layout.md` files still described Diagnostics Banks or
  related future test-access details
- the finished machine is not intended to carry permanent Diagnostics Bank hardware
- the coupon strategy is already tracked separately as future work, so embedding those details into
  current board specs makes the active design harder to review

That mixed future test-access planning into documents that are supposed to define the current
production-board design.

### Decision

1. **Remove all Diagnostics Bank details from active board specs/layouts.**
   - No active `Design_Spec.md` or `Board_Layout.md` should describe Diagnostics Banks as if they are
     present on the current production boards.
   - Future test-access features must not appear as active board content before they are actually
     designed.

2. **Keep historical traceability in the Design Log only.**
   - Older Diagnostics Bank discussions remain in this log as historical context.
   - Where needed, those older entries are treated as superseded historical material rather than
     active design definition.

3. **Revisit test-access details only during the coupon work item.**
   - Any future removable coupon implementation is to be reviewed later under **OWI-001 - Test
     Coupons per Board**.
   - Per-board coupon signal selection, geometry, connector choices, and any related probe-access
     strategy are deferred until that dedicated review.

4. **Require a fresh review before any reintroduction.**
   - If test-access features are reintroduced later, they require a new explicit design update and
     the appropriate ESD / certification review at that time.

### Rationale

- Keeps active board docs focused on the actual production-board design.
- Avoids presenting future bring-up hardware as though it were already approved.
- Preserves the test-coverage intent without prematurely freezing implementation details.
- Makes the separation between **current design** and **future TODO work** explicit.

### Supersession / Obsolescence

- **DEC-009** and **DEC-010** remain historical traceability for the old Controller probe-access
  concept, but they are superseded as active board-definition guidance by this decision.
- Any historical references to Diagnostics Banks or equivalent fixed bring-up probe features in the
  active board specs/layouts are obsolete.

### Impact

- Active board `Design_Spec.md` and `Board_Layout.md` files must omit Diagnostics Bank content until
  the coupon work is actually designed.
- Future test-access planning stays in the Design Log / work-item tracking rather than in current
  board specs.
- Later coupon implementation work must decide the real test-access architecture per board instead of
  inheriting outdated fixed-bank assumptions.

### Cross-ref

DEC-009, DEC-010, QUE-002, OWI-001, OWI-002, `design/Standards/Certification_Evidence.md §8`
(DA-01).

---

## DEC-041 - Encoder Modules Use EPM570 with Digital Debounce and Role-by-Programming

- **Status:** Decided
- **Date:** 2026-04-26
- **Category:** Electrical / Logic architecture
- **Area:** Encoder Module hardware, CPLD logic partitioning, manufacturing standardisation
- **Author:** Izzyonstage & GitHub Copilot

### Summary

Standardise all six Encoder Modules on the **Intel MAX II `EPM570T100I5N`** and move encode-role
input debouncing from external per-line RC networks into the CPLD logic. The Encoder PCB remains a
single universal board; role is selected by the programmed CPLD image rather than by role-specific
passive population or local switches.

### Problem

The prior Encoder direction left the active design in a fragmented state:

- Encoder boards were the only active MAX II boards still specified around the smaller `EPM240`
  device while Rotor and Stator already used `EPM570`
- encode-role boards required a large role-specific RC population (`64 x 10 kΩ` + `64 x 100 nF`)
  even though the same PCB was intended to stay generic
- role-identifying population differences made bulk manufacturing and board identification less
  robust than a single common programmable hardware standard
- the active docs described hardware debounce even though the new universal-board direction benefits
  from logic-side filtering and future LE headroom

That combination increased BOM complexity and left less architectural margin for future Encoder-side
logic work.

### Decision

1. **All Encoder Modules use `EPM570T100I5N`.**
   - The Encoder `U1` device is upgraded from `EPM240T100I5N` to `EPM570T100I5N`.
   - Encoder, Rotor, and Stator now share the same active MAX II CPLD part number.

2. **Encode-role debounce moves into CPLD logic.**
   - Active board designs must not rely on the former external per-line RC debounce network as the
     primary debounce method.
   - The active logic architecture uses sampled digital filtering of the 64-line input bank.
   - Debounce tuning is intentionally left prototype-adjustable in the logic specification until the
     first hardware is available for measurement.

3. **Role is selected by programming, not by board switches or role-only passives.**
   - The Encoder PCB remains physically generic.
   - Encode-vs-decode behaviour is selected by the CPLD image loaded onto the board based on its
     known JTAG-chain position.
   - No local role strap, DIP switch, jumper shunt, or role-specific RC population is part of the
     active design.

4. **One common on-board BOM applies to all six Encoder PCBs.**
   - Role-specific behaviour comes from the programmed image and the off-board assembly wiring only.
   - Keyboard switches and plugboard jacks remain assembly-level differences, but the fitted Encoder
     PCB itself is standardised.

5. **Detailed Encoder logic requirements are owned in software-side CPLD logic documentation.**
   - The functional requirements for sampled debounce, 64-to-6 encoding, and 6-to-64 decoding are
     captured in `design/Software/CPLD_Logic/Encoder_Logic.md`.
   - Board-level Encoder docs remain authoritative for interfaces, BOM, and physical architecture,
     while the new logic doc becomes the implementation reference for later VHDL work.

### Rationale

- Removes a large quantity of role-specific passives from the system BOM and assembly flow.
- Gives the Encoder design more LE margin for debounce, diagnostics, and later feature growth.
- Aligns all active MAX II boards to one stocked CPLD family member.
- Preserves the single-universal-board goal without needing field-settable switches on the PCB.
- Keeps prototype tuning in programmable logic rather than freezing debounce behavior in passives
  before first-board measurement exists.

### Supersession / Obsolescence

- Any active Encoder-board wording that defines **external per-line RC debounce** as the required
  debounce mechanism is superseded by this decision.
- Any active Encoder-board wording that defines **`EPM240T100I5N`** as the required Encoder CPLD is
  superseded by this decision.
- Earlier generic-board assumptions that implied role-specific fitted passive populations are
  obsolete as active manufacturing guidance.

### Impact

- Update `design/Electronics/Encoder/Design_Spec.md` and `design/Electronics/Encoder/Board_Layout.md`
  to replace the `EPM240` / external-RC assumptions with `EPM570` / digital-debounce wording.
- Add `design/Software/CPLD_Logic/Encoder_Logic.md` as the implementation-facing logic
  requirements document for later VHDL development.
- Update BOM, board overview, power-budget, certification, and GUI-planning docs so the Encoder
  boards are counted as `EPM570` devices and no longer imply a role-specific RC population.

### Cross-ref

DEC-016, DEC-035, `design/Electronics/Encoder/Design_Spec.md`,
`design/Electronics/Encoder/Board_Layout.md`,
`design/Software/CPLD_Logic/Encoder_Logic.md`.

---

## DEC-042 - Encoder Port Pin 8 Carries HID-Local `ENC_ACTIVE_N`

- **Status:** Decided
- **Date:** 2026-04-26
- **Category:** Electrical / Interface architecture
- **Area:** Stator ↔ Encoder connector contract, HID source selection, lightboard blanking
- **Author:** Izzyonstage & GitHub Copilot

### Summary

Revise the 20-pin Stator ↔ Encoder connector so **pin 8** carries a generic active-low
`ENC_ACTIVE_N` sideband. The signal is used only on the HID bank:

- `J4` / `KBD_ENC` drives keyboard activity into the Stator
- the Stator source-select path chooses between physical `ENC_ACTIVE_KBD_N` and
  `CM5_KEY_ACTIVE_N`
- `J5` / `LBD_DEC` receives the selected `ENC_ACTIVE_LBD_N` so the lightboard can blank when idle

The signal is **not** propagated through the plugboard, rotor, reflector, or extension interfaces.

### Problem

The 6-bit `ENC_DATA[5:0]` path uses the entire 64-code space, so there is no spare "idle" code that
cleanly distinguishes "no key is currently active" from "a valid key code is present." Without a
separate activity indication:

- `LBD_DEC` cannot reliably blank the lightboard when the keyboard is idle
- CM5 GUI / telemetry cannot observe the selected keyboard-source activity state cleanly
- physical-keyboard and CM5-virtual key injection risk diverging in behaviour if only the data bus is
  muxed

### Decision

1. **Pin 8 on the generic 20-pin Encoder connector is reassigned to `ENC_ACTIVE_N`.**
   - Pins 2-7 remain `ENC_DATA[5:0]`.
   - Pins 8-18 shift by one position relative to the previous shield/JTAG allocation so
     `SYS_RESET_N` moves to pin 18.

2. **`ENC_ACTIVE_N` is active-low and defaults HIGH / inactive.**
   - HIGH = idle / no active HID event
   - LOW = active HID event present
   - Unused roles shall leave the signal HIGH via the MAX II weak pull-up behaviour or an equivalent
     schematic bias method.

3. **The signal is HID-local, not cipher-path-global.**
   - `KBD_ENC` drives `ENC_ACTIVE_N` to indicate a debounced keypress is active.
   - `LBD_DEC` consumes `ENC_ACTIVE_N` and must blank all outputs when the signal is HIGH.
   - Plugboard encoder / decoder roles do not use the signal in the active design and should hold or
     treat it as inactive.

4. **Physical and CM5 virtual keyboard sources must stay aligned.**
   - The Stator keyboard-source mux path must switch both the 6-bit source bus and the active-low
     activity sideband together.
   - The selected activity state must be monitored on the Stator for GUI / telemetry use.

### Rationale

- Preserves the full 64-code space without sacrificing any character value to represent idle.
- Gives the lightboard an explicit blanking control tied to real key activity.
- Keeps the extra signal local to the HID bank instead of widening the larger rotor / reflector /
  plugboard interface contract.
- Reuses spare mux and GPIO capacity already present on the Stator rather than introducing new active
  parts.

### Impact

- Update `design/Electronics/Stator/Board_Layout.md` and `design/Electronics/Stator/Design_Spec.md`
  to revise the 20-pin port pin table and document the HID-local source-select / monitoring flow.
- Update `design/Electronics/Encoder/Design_Spec.md` and
  `design/Electronics/Encoder/Board_Layout.md` to add `ENC_ACTIVE_N` to the generic module
  interface.
- Update `design/Software/CPLD_Logic/Encoder_Logic.md` so `KBD_ENC` and `LBD_DEC` define the
  required `ENC_ACTIVE_N` behaviour.

### Cross-ref

DEC-041, `design/Electronics/Stator/Design_Spec.md`,
`design/Electronics/Stator/Board_Layout.md`,
`design/Electronics/Encoder/Design_Spec.md`,
`design/Electronics/Encoder/Board_Layout.md`,
`design/Software/CPLD_Logic/Encoder_Logic.md`.

---

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

---

## DEC-044- FDC2114 Internal Oscillator Selected (CLKIN → GND)

- **Status:** Decided
- **Date:** 2026-04-26
- **Category:** Electrical / Component configuration
- **Area:** Rotor Board, capacitive position sensing, FDC2114 clock source
- **Author:** Izzyonstage & GitHub Copilot

### Summary

The FDC2114 on every Rotor Board uses its **internal oscillator** as the conversion clock.
The `CLKIN` pin is tied permanently to GND on the PCB. The `CHx_FIN_SEL` field in each channel's
`SETTLECOUNT` register is set to `0b10` (internal oscillator reference).

### Problem

The FDC2114 supports two clock sources: an external crystal/oscillator on CLKIN, or the internal
~43.35 MHz oscillator activated when CLKIN is tied to GND. A decision was required on which to
use for the Rotor sensing application.

### Decision

Use the FDC2114 internal oscillator (CLKIN → GND). This means:

1. No external crystal or oscillator component on the Rotor PCB.
2. `CHx_FIN_SEL = 0b10` in all active channel `SETTLECOUNT` registers.
3. Conversion reference clock frequency ≈ 43.35 MHz (internal specification).
4. CPLD I²C master (VHDL bitstream) configures this field at power-up.

### Rationale

- Avoids an external crystal BOM cost and the associated PCB footprint on a space-constrained
  circular board (Ø92mm with CPLD, FDC2114, sensor electrodes, DIP switches, and connectors).
- The internal oscillator frequency (~43.35 MHz) is well above the ~6.5 MHz nominal resonant
  frequency of the LC tank (18 µH + 33 pF), satisfying the FDC2114 requirement for the
  conversion clock to be >4x the sensor resonant frequency.
- Absolute frequency accuracy of the conversion clock is not critical for this application.
  Gray-code position detection requires only relative threshold crossing detection (presence or
  absence of an aluminium shroud slot), not absolute frequency measurement.
- Confirmed viable by TI FDC2114 datasheet §8 (internal oscillator specification) and TI
  FDC2114 application note guidance.

### Alternatives Considered

| Alternative | Reason rejected |
| :--- | :--- |
| External crystal on CLKIN | Additional BOM line, PCB footprint, and layout complexity; not needed for this sensing application |
| External clock oscillator module | Same objections as crystal; adds cost and board area |

### Impact

- Rotor Board PCB: CLKIN tied to GND; no crystal footprint required.
- CPLD VHDL: set `CHx_FIN_SEL = 0b10` in `SETTLECOUNT` register for all active channels at
  power-up initialisation.
- `design/Electronics/Rotor/Design_Spec.md`: Resonant Front-End Topology subsection updated.
- `design/Software/CPLD_Logic/Rotor_Logic.md`: FDC2114 register map documents this setting.

### Cross-ref

`design/Electronics/Rotor/Design_Spec.md`,
`design/Software/CPLD_Logic/Rotor_Logic.md`,
`design/Procedures/Lab_Tests.md` (LT-001, LT-002).

---

## DEC-045 - Rotor Samtec ERM8/ERF8 Connectors Require ESD Protection

- **Status:** Decided
- **Date:** 2026-04-28
- **Category:** Electrical / ESD Protection
- **Area:** Rotor Board, ERM8/ERF8 BtB connectors
- **Author:** Izzyonstage & GitHub Copilot

### Summary

The Samtec ERM8/ERF8 board-to-board connectors on the Rotor Boards are designated as
requiring TVS/ESD protection, as an exception to Global_Routing_Spec.md §9, which otherwise
exempts internal BtB connectors from ESD protection requirements.

### Problem

Global_Routing_Spec.md §9 exempts Samtec ERM8/ERF8 BtB connectors from ESD protection on the
basis that they are internal board-to-board connectors. However, the Rotor Boards are hot-swappable
by design: individual rotors are inserted and removed from the live stack without tools. This makes
the ERM8/ERF8 mating faces accessible during servicing, exposing them to ESD events from operator
handling.

The Samtec connectors were originally specified for the PM/Stator interconnect (an internal,
non-hot-swappable path) - this was incorrect. They are now correctly used for rotor external
connections (between individually removable/serviceable rotor modules).

### Decision

Add TVS/ESD protection to all Samtec ERM8/ERF8 connector interfaces on the Rotor Board.
Update Global_Routing_Spec.md §9 with a servicing-access exception clause covering hot-swappable
connector families.

### Rationale

- Rotors are explicitly designed to be hot-swappable (Samtec ERM8/ERF8 rated for high mating cycles - §2.3).
- ESD events at the mating face during live insertion are a realistic threat to CPLD, FDC2114, and JTAG chain integrity.
- The relevant boundary for ESD protection is "accessible during servicing" not merely "external to the enclosure at all times."
- This is consistent with the §9 principle extended to servicing access rather than just permanent physical exposure.

### Alternatives Considered

| Alternative | Reason rejected |
| :--- | :--- |
| No ESD protection (rely on enclosure shielding) | Enclosure is open during rotor swap; ESD from operator handling is a real threat |
| Per-rotor deviation note only (no §9 update) | Modifying §9 is cleaner and prevents future designs from missing the same requirement |

### Impact

- `design/Standards/Global_Routing_Spec.md §9`: Added hot-swappable/service-accessible connector clause.
- `design/Electronics/Rotor/Design_Spec.md §6`: ESD arrays documented. Selected device: TPD4E05U06QDQARQ1 (U5-U12);
  U5-U8 protect Board A connectors J1 and J3; U9-U12 protect Board B connectors J4 and J6. 8 per rotor pair x 30 = 240 system total.
  JTAG signals corrected: J1 Board A = TDI/TMS/TCK (3 lines, 1 spare); J4 Board B = TDO/TMS/TCK (3 lines, 1 spare); nTRST not routed.
  Encoder signals corrected: J3/J6 carry ENC_IN[5:0] + ENC_OUT[5:0] (12 lines) - phantom signals ENC_ACTIVE_N and ENC_CLK removed.
- `design/Electronics/Consolidated_BOM.md`: TPD4E05U06QDQARQ1 row updated - ROT (x1) = 8, ROT Total (x30) = 240, System Total = 244.

### Cross-ref

`design/Standards/Global_Routing_Spec.md §9`,
`design/Electronics/Rotor/Design_Spec.md §6`.

---

## DEC-046 - Bypass/Decoupling Capacitor Voltage Rating: 50V Retained on All Non-PM Boards

- **Status:** Decided
- **Date:** 2026-04-29
- **Category:** Component Selection / Passive Derating
- **Area:** All boards (Rotor, Stator, Controller, Extension, JDB, Encoder, AM, Settings Board)
- **Author:** Izzyonstage & GitHub Copilot

### Summary

Standard bypass and decoupling capacitors across all non-PM boards are retained at their current
50V voltage rating. No down-specification to 25V is required or warranted.

### Problem

A design review (CTL-L2) flagged that bulk reservoir caps on some boards were specified at 50V while
the highest non-PM rail is 5V_MAIN (5V). Bulk reservoir caps were subsequently down-specced to 25V
(Samsung CL21B106KAYQNNE). The question then arose: should the smaller bypass and decoupling
capacitors also be down-specced for cost savings?

### Decision

Retain 50V-rated bypass and decoupling capacitors as the approved standard across all non-PM boards.
The Power Module retains 50V for all capacitors on its input/battery path, which sees up to 16.9V.

### Rationale

**Power Module (input-side caps):** 50V is required. The PM input rail reaches ~16.9V; 50V provides
>3x voltage margin, meeting the X7R DC bias derating requirement. A 25V cap would give only 1.5x
margin - insufficient for X7R ceramics.

**All other boards (bypass/decoupling caps):** 25V is technically sufficient (5V_MAIN gives 5x
margin at 25V). However:

1. The standard approved parts (`CL05B104KB5NNNC` 100nF 0402, `C0805C105K5RACTU` 1µF 0805) are
   already approved, priced, and used consistently across every board. Changing them requires
   sourcing and approving new part numbers.
2. No existing approved 25V part matches these capacitance values - the approved 25V parts
   (`CL21B106KAYQNNE` 10µF 0805, `CL32B226KAJNNNE` 22µF 1210, etc.) are all different values used
   for bulk/reservoir purposes.
3. The 100nF 0402 bypass cap is one of the cheapest passive components in the design (~£0.002-0.003
   each at JLCPCB volumes). The cost delta between 25V and 50V variants is negligible - fractions of
   a penny per unit - and the total BOM saving across even a 500-unit build would be immaterial.
4. Consistency across the design has positive value: a single approved bypass cap part used
   everywhere reduces procurement complexity and qualification overhead.

### Alternatives Considered

| Alternative | Reason rejected |
| :--- | :--- |
| Down-spec 100nF 0402 to 25V across all boards | Requires new part approval; cost saving negligible; no existing approved 25V equivalent at this value |
| Down-spec 1µF 0805 to 25V on non-PM boards | Same reasoning; only ~10 placements total, saving immaterial |
| Mixed 25V/50V bypass depending on board | Creates two approved bypass cap standards; procurement complexity outweighs any saving |

### Impact

No document changes required. This decision records the rationale for the existing 50V specification
to prevent future reviews from re-raising it as an issue.

- `design/Electronics/Consolidated_BOM.md`: No change - existing 50V parts remain the standard.
- `design/Standards/Global_Routing_Spec.md`: No change.

### Cross-ref

`design/Electronics/Power_Module/Design_Spec.md §7.4` (50V derating note for PM input rails),
`design/Electronics/Consolidated_BOM.md` (approved 50V bypass/decoupling cap parts).

---

## DEC-047 - OR-ing MOSFET Corrected to CSD17578Q5A

- **Status:** Decided
- **Date:** 2025-07-05
- **Category:** Component Selection / Part Number Correction
- **Area:** Power Module (Q1, Q2, Q3)
- **Author:** Izzyonstage & GitHub Copilot

### Summary

The OR-ing MOSFET for the Power Module ideal-diode circuit was incorrectly specified as CSD17483F4T.
This has been corrected to **CSD17578Q5A**.

### Problem

Q1, Q2, and Q3 (LM74700-Q1 ideal-diode OR-ing MOSFETs) were listed as CSD17483F4T with a
description of "30V 10A SON-8". The local datasheet (`csd17483f4-datasheet.md`) confirmed this part
is actually a 1.5A / 260mΩ / PICOSTAR YJC 3-pin FemtoFET - completely unsuitable for an OR-ing
application handling multi-ampere input currents.

### Decision

Replace CSD17483F4T with **CSD17578Q5A** (TI NexFET N-channel MOSFET):

- V_DSS: 30V
- I_D: 25A continuous (package limited), 59A (silicon limited)
- R_DS(on): 5.9mΩ @ V_GS = 10V; 7.9mΩ @ V_GS = 4.5V
- Package: SON 5x6mm
- DigiKey: `296-48512-1-ND` | Mouser: `595-CSD17578Q5A` | JLCPCB: `C2871447`

### Rationale

CSD17578Q5A is designed specifically for point-of-load and OR-ing converter applications. Its 5.9mΩ
R_DS(on) provides extremely low conduction losses, and 25A package rating gives adequate headroom
above the expected OR-ing path current. The LM74700-Q1 gate-drive requirements (charge-pump +7V above
source) are fully compatible with this device's ±20V V_GS limit.

### Alternatives Considered

| Alternative | Reason rejected |
| :--- | :--- |
| Retain CSD17483F4T | Incorrect part - 1.5A FemtoFET cannot handle OR-ing path currents |
| Other SON-8 OR-ing MOSFETs | CSD17578Q5A already approved and datasheet verified; no need to evaluate alternatives |

### Impact

- `design/Electronics/Power_Module/Design_Spec.md`: Q1/Q2/Q3 MPN, PNs, and specs updated.
- `design/Electronics/Consolidated_BOM.md`: CSD17578Q5A row replaces CSD17483F4T.
- `design/Electronics/all_boards_bom.json`: Updated accordingly.

### Cross-ref

`design/Electronics/Power_Module/Design_Spec.md §5` (Q1, Q2, Q3 BOM row),
`design/Datasheets/TI-csd17578q5a-datasheet.pdf`.

---

## DEC-048 - ESD Protection Extended to Host-Side Rotor-Facing BtB Connectors

- **Status:** Approved
- **Date:** 2026-04-30
- **Category:** ESD / Protection Strategy
- **Area:** Stator, Extension, Reflector - Rotor-Facing BtB Connectors
- **Author:** Izzyonstage & GitHub Copilot

### Summary

ESD protection requirement (DEC-045) has been extended from the Rotor board to all host-side boards that present rotor-facing
BtB connector faces during live rotor swap. Any exposed Samtec ERM8/ERF8 connector face that is accessible when a rotor is
being inserted or removed must carry TVS protection.

### Problem

DEC-045 mandated TPD4E05U06QDQARQ1 ESD arrays on the Rotor board side of each BtB interface. However, when a rotor is
extracted, both the rotor-side connectors and the host-side (Stator / Extension / Reflector) socket faces become simultaneously
exposed to operator handling. An ESD event from operator touch to the host-side socket during live swap would propagate
directly into the host board with no protection.

### Decision

All Samtec ERM8/ERF8 connector faces on host boards that are exposed during live rotor swap require a TPD4E05U06QDQARQ1
4-channel bidirectional ESD array within 3mm of the connector mating edge. Only JTAG and ENC signal connectors are in scope;
Power connectors (power-only BtB pairs) and all internal IDC/ribbon/harness/dock connectors are explicitly excluded.

Board-level implementation:

- **Stator:** U9 (J1 JTAG), U10-U12 (J3 ENC) - 4 arrays total.
- **Extension:** U2 (J1 JTAG in), U3-U5 (J3 ENC in), U6 (J4 JTAG out), U7-U9 (J6 ENC out) - 8 arrays total.
- **Reflector:** U1 (J1 JTAG), U2-U4 (J3 ENC) - 4 arrays total.

Internal connectors explicitly excluded from this decision:

- All power-only BtB connector pairs on any board.
- Stator J4-J13 (IDC encoder ports, Extension Port ribbon, Controller docks, Settings harness).
- Extension J7/J8 (Extension Port BHR-20-VUA ribbons) and J9/J10 (AM service docks).
- Reflector J4 (TTD_RETURN ribbon).

### Rationale

Rotors are a user-handled, hot-swappable component. During installation or removal, both sides of the connector interface are
simultaneously accessible. Protecting only the rotor side is insufficient - a real ESD event from an operator to an unprotected
host socket would destroy the host board as readily as a rotor. Extending the same TPD4E05U06QDQARQ1 device used on rotors
to the host-side connector faces closes the remaining ESD risk at minimal BOM cost (16 additional arrays across 3 boards).

### Impact

- `design/Electronics/Stator/Design_Spec.md`: Added FR-STA-13, DR-STA-16; §8 ESD section rewritten; BOM U9-U12 added.
- `design/Electronics/Extension/Design_Spec.md`: Added FR-EXT-07, DR-EXT-13; §5 ESD section rewritten; BOM U2-U9 added.
- `design/Electronics/Reflector/Design_Spec.md`: Added FR-REF-05, DR-REF-06; §5 renamed to Thermal & ESD; BOM U1-U4 added.
- `design/Electronics/Consolidated_BOM.md`: Section 1 and Section 2 updated.

### Cross-ref

DEC-045 (Rotor ESD), `design/Electronics/Stator/Design_Spec.md §8`,
`design/Electronics/Extension/Design_Spec.md §5`, `design/Electronics/Reflector/Design_Spec.md §5`.

---

## DEC-049 - Rotor Internal Headers Renamed to J-Convention; Connector Count Updated to 8; BOM Unified

- **Status:** Accepted
- **Date:** 2026-05-01
- **Category:** Hardware
- **Area:** Rotor Board - Internal Interconnect; BOM Structure
- **Amends:** DEC-028 (original internal header definition)

### Decision

The four internal rotor interconnect headers previously designated H_SW3, H_PWR, H_JTAG, and
H_SENS are renamed to J7-J14 to follow the established J-prefix convention for all connectors
across the project. The configuration is updated to **eight connectors** (four per board face):
Board A J7/J8 1x5 female RS1-05-G, J11 1x5 male PH1-05-UA, J14 1x7 male PH1-07-UA;
Board B J9 1x5 female RS1-05-G, J10 1x7 female RS1-07-G, J12/J13 1x5 male PH1-05-UA;
**44 pins total**. The Rotor BOM is unified into a single table (rather than split Board A /
Board B) to reflect that rotor boards are manufactured as a single v-scored panel.

### Rationale

- H_SW3/H_PWR/H_JTAG/H_SENS naming was functional rather than positional and inconsistent with all other connector RefDes conventions in the project.
- Enumerating connectors as J7-J14 aligns with the J-prefix standard and makes RefDes unambiguous in BOMs and schematics.
- The connector count of 8 (4 per board face) correctly reflects the physical geometry: each board face independently connects to its mating face, requiring its own set of male/female headers.
- A unified BOM table accurately represents the manufacturing reality: the two halves are produced as a single v-scored panel at JLCPCB, separated only during mechanical assembly.

### Impact

- `design/Electronics/Rotor/Design_Spec.md`: §3.4 J_INT headers updated from H_SW3/H_PWR/H_JTAG/H_SENS to J7-J14 with revised pinouts; BOM unified into single table, FR/DR updated.
- `design/Electronics/Consolidated_BOM.md`: Internal headers updated to J7/J8 RS1-05-G female
  (Board A), J11 PH1-05-UA male, J14 PH1-07-UA male, J9 RS1-05-G female (Board B),
  J10 RS1-07-G female, J12/J13 PH1-05-UA male; 8 headers per rotor assembly (240 total for
  30 rotors).

### Cross-ref

DEC-028 (original split-board architecture and header definition).

---

## DEC-050 - Encoder Blade Terminal RefDes Corrected from BT to J Convention

- **Status:** Active
- **Date:** 2026-05-01
- **Category:** Electrical
- **Area:** Encoder Board

### Decision

The 64 PCB spade blade terminals (Keystone 1285-ST) on the Encoder board have been
renamed from `BT1`-`BT64` to `J3`-`J66`.

### Rationale

`BT` is the IPC/EDA standard reference designator prefix for **batteries**. Using it for
PCB-mount blade/spade terminals was non-standard and created ambiguity with the Controller
board's `BT1` (CR2032 holder). All connectors and interface terminals in this project use
the `J` prefix (connector/jack convention). J1 and J2 are already assigned on the Encoder
board (J1 = plugboard jack sockets off-board, J2 = IDC service connector), so the blade
terminal bank begins at J3.

### Alternatives Considered

- `XT` (external terminal) - used by some EDA conventions but `J` is more widely recognised
  and consistent with all other connector RefDes in this project.
- Retain `BT` - rejected: collides with the IPC battery prefix and conflicts with `BT1` on
  the Controller board.

### Impact

- `design/Electronics/Encoder/Design_Spec.md` - BOM row and §4 interconnects text updated.
- `design/Electronics/Encoder/Board_Layout.md` - signal group table updated.
- `design/Software/CPLD_Logic/Encoder_Logic.md` - all `BT1`-`BT64` references updated.
- `design/Electronics/Consolidated_BOM.md` - Encoder row RefDes updated.
- `design/Datasheets/SaiBuy_Ltd_6p35mm_Mono_Jack_Pseudo_Datasheet.md` - system-level
  wiring notes updated; decode-half now references `J3`-`J66` on the decode Encoder board
  and encode-half references `J3`-`J66` on the encode Encoder board.

---

## DEC-051 - Settings Board Renamed to User Settings Module (Board Code SBD → USM)

- **Status:** Active
- **Date:** 2026-05-02
- **Category:** Architecture
- **Area:** Settings Board / User Settings Module

### Decision

The `Settings Board` is renamed to `User Settings Module` throughout all active design
documentation, the consolidated BOM, and all mechanical and electrical cross-references.
The board code changes from `SBD` to `USM`. Historical decision log entries and checkpoint
files that use the name `Settings Board` are retained as-is; this entry supersedes the
naming used in those records.

### Rationale

The original name "Settings Board" described the hardware function but lacked the
module-level naming convention applied to all other boards in the system (e.g., Power
Module, Actuation Module). Aligning to the module naming scheme improves consistency
across design documents, BOM references, and future PCB silkscreen labelling, and avoids
ambiguity with the term "settings" as used in the GUI application.

### Alternatives Considered

- Retain "Settings Board" - rejected: inconsistent with module naming convention applied
  to all other subsystems.
- "Input Module" or "Panel Module" - considered but rejected: "User Settings Module" more
  precisely describes the function (user-facing configuration controls).

### Superseded Naming

The following historical design log entries use the old name "Settings Board". They are
retained as-is as a historical record; their naming is superseded by this decision:

- **DEC-032** - *Settings Board: Panel-Mount Configuration Controls with CM5 Override* -
  all "Settings Board" references in this entry now refer to the User Settings Module.
- **DEC-034** - *Switch Hardware Refresh: Settings Board Toggle + Discrete RGB LED,
  Ruggedized PM SW1* - all "Settings Board" references in this entry now refer to the
  User Settings Module.
- Other prior DEC entries and checkpoint files that mention "Settings Board" in prose or
  board-area fields retain their original wording as historical records.

### Impact

- `design/Electronics/Settings_Board/` directory renamed to
  `design/Electronics/User_Settings_Module/` (git history preserved via `git mv`).
- `design/Electronics/User_Settings_Module/Design_Spec.md` - title and all prose updated.
- `design/Electronics/User_Settings_Module/Board_Layout.md` - title and all prose updated.
- `design/Electronics/Consolidated_BOM.md` - board code `SBD` → `USM`; column header
  `SBD Qty` → `USM Qty`; all 18 `SBD:` RefDes prefixes updated to `USM:`.
- `design/Electronics/all_boards_bom.json` - all `"board": "Settings Board"` entries updated.
- `design/Electronics/Boards_Overview.md`, `Electrical_Design.md`, `System_Architecture.md`,
  `Power_Budgets.md`, `Controller/Design_Spec.md`, `Power_Module/Design_Spec.md`,
  `Reflector/Design_Spec.md`, `Stator/Design_Spec.md`, `Stator/Board_Layout.md` - prose
  and cross-references updated.
- `design/Mechanical/Complete_System_Assembly/Design_Spec.md`,
  `design/Mechanical/Main_Enclosure/Design_Spec.md` - prose references updated.

---

## DEC-052 - Variant-Specific FDC2114 RefDes Use A/B Suffix Convention

- **Status:** Active
- **Date:** 2025-07-10
- **Category:** Architecture
- **Area:** Rotor Board - Position Sensing (FDC2114 sensor ICs and associated passives)

### Decision

Variant-specific FDC2114 sensor components on the Rotor board are assigned RefDes with an A or B
suffix to indicate which PCB sub-board they are physically located on:

- **Board A (N=26 variant):** `U3A`, `C16A`, `C17A`, `C22A`-`C25A`, `L5A`-`L8A`
- **Board B (N=64 variant):** `U3B`, `C16B`, `C17B`, `C22B`-`C25B`, `L5B`-`L8B`

The B-suffix base numbers mirror the A-suffix base numbers exactly, making the pairing
immediately readable. The always-fitted sensor (`U2`) and its bypass and resonant front-end
components (`C14`, `C15`, `C18`-`C21`, `L1`-`L4`) retain plain RefDes with no suffix as they
are fitted on all variants.

In KiCAD the A and B suffixes are unique RefDes. Two project variants are defined:

- **N26:** U3A fitted; U3B (and associated B-suffix passives) marked DNP.
- **N64:** U3B fitted; U3A (and associated A-suffix passives) marked DNP.

The Consolidated BOM System Qty column counts only the components fitted in a single variant:
each mutually-exclusive sensor row carries qty **1** per rotor.

### Rationale

KiCAD does not support duplicate RefDes within a single project. Using A/B suffixes allows
both Board A and Board B sensor circuits to coexist in the same schematic and PCB layout file
while remaining unique. Mirroring the base number across A and B (e.g. `C16A` / `C16B`) makes
the pairing unambiguous without a separate mapping table. The overall capacitor and inductor
sequence is kept consecutive with no gaps.

### Alternatives Considered

- **U3 / U4 (no suffix):** Used prior to this decision. Abandoned because schematic and PCB
  layout tools require unique RefDes; U3 and U4 appeared confusingly similar to Controller
  Board RefDes (U4-U6) documented elsewhere.
- **Separate schematic/layout per variant:** Rejected; doubles maintenance burden and makes
  shared JTAG and data routing harder to manage.

### Impact

- `design/Electronics/Rotor/Design_Spec.md` - all occurrences of `U3`/`U4` for the Rotor
  board updated to `U3A`/`U3B`; bypass and tank passive RefDes updated throughout.
- `design/Electronics/Rotor/Board_Layout.md` - Board A and Board B tables updated.
- `design/Electronics/Rotor/Rotor_26_Char_Design.md` - variant spec updated.
- `design/Electronics/Rotor/Rotor_64_Char_Design.md` - variant spec updated.
- `design/Electronics/Consolidated_BOM.md` - rows for C16/C17, C18-C21, C22-C25, L5-L8,
  and U3/U4 updated; System Qty corrected for mutually-exclusive rows.

---

## DEC-053 - Extension Port Connector Upgraded from BHR-20-VUA (20-pin) to 2BHR-30-VUA (30-pin)

- **Status:** Active
- **Date:** 2025-07-10
- **Category:** Electrical / Connector Selection
- **Area:** Extension Port - Stator J10, Reflector J4, Extension J7/J8

### Decision

Replace the Adam Tech BHR-20-VUA (20-pin 2x10) with the Adam Tech 2BHR-30-VUA (30-pin 2x15) on
all Extension Port instances (Stator J10, Reflector J4, Extension J7, Extension J8). The approved
30-pin pinout is symmetric end-to-end:

| Pin | Signal | Pin | Signal |
| --- | ------ | --- | ------ |
| 1 | 5V_MAIN | 2 | 5V_MAIN |
| 3 | 3V3_ENIG | 4 | 3V3_ENIG |
| 5 | GND | 6 | GND |
| 7 | ENC_OUT_REF[0] | 8 | ENC_OUT_REF[1] |
| 9 | ENC_OUT_REF[2] | 10 | ENC_OUT_REF[3] |
| 11 | ENC_OUT_REF[4] | 12 | ENC_OUT_REF[5] |
| 13 | GND | 14 | GND |
| 15 | SYS_RESET_N | 16 | TTD_RETURN |
| 17 | GND | 18 | GND |
| 19 | ENC_IN_REF[0] | 20 | ENC_IN_REF[1] |
| 21 | ENC_IN_REF[2] | 22 | ENC_IN_REF[3] |
| 23 | ENC_IN_REF[4] | 24 | ENC_IN_REF[5] |
| 25 | GND | 26 | GND |
| 27 | 3V3_ENIG | 28 | 3V3_ENIG |
| 29 | 5V_MAIN | 30 | 5V_MAIN |

The layout is symmetric: columns 1↔15, 2↔14, 3↔13 are identical; the signal blocks
(ENC_OUT pins 7-12, ENC_IN pins 19-24) are positionally mirrored about the centre pair
(pins 15-16). A keyed (polarised) variant is retained. The connector is from the same Adam Tech
BHR/2BHR series as the previous BHR-20-VUA (same 3 A/pin contact rating, same housing family).

### Rationale

Current-capacity analysis of the 20-pin connector revealed three worst-case violations at full system
build (30 rotors, 5 Extension boards) against the IPC-2221 28 AWG IDC ribbon limit of ~1 A/conductor:

- `3V3_ENIG`: 30 x 55 mA = **1.65 A** via a single pin → 1.65 A/conductor - exceeds limit.
- `5V_MAIN`: 5 extensions x 500 mA = **2.50 A** via 2 pins → 1.25 A/conductor - exceeds limit.
- `GND` return: 4.15 A total via 2 dedicated GND pins → 2.08 A/conductor - exceeds limit.

The 30-pin connector resolves all three:

- `3V3_ENIG`: 1.65 A ÷ 4 pins = **0.41 A/conductor** ✔
- `5V_MAIN`: 2.50 A ÷ 4 pins = **0.63 A/conductor** ✔
- `GND` return: 4.15 A ÷ 8 pins = **0.52 A/conductor** ✔

All rails are within the 1 A/conductor 28 AWG IDC ribbon limit. The 2BHR-30-VUA connector pin rating
(3 A/pin) is not the binding constraint; the IDC ribbon cable is. The symmetric, mirrored layout
satisfies an aesthetic consistency preference.

### Approved Part Numbers - 2BHR-30-VUA

| Supplier | Part Number |
| --- | --- |
| DigiKey | `2057-2BHR-30-VUA-ND` |
| Mouser | `737-2BHR-30-VUA` |
| JLCPCB | `C17346400` |

### Impact

- `design/Electronics/Stator/Board_Layout.md §1 J10` - authoritative pinout rewritten to 30-pin; pending-review note removed.
- `design/Electronics/Stator/Design_Spec.md` - FR-STA-04, DR-STA-05, §4 Interconnects, §8 ESD, BOM updated.
- `design/Electronics/Extension/Board_Layout.md` - §2/§3 section headings, cross-reference notes, §5/§5.2 power notes, §7 ESD reference updated.
- `design/Electronics/Extension/Design_Spec.md` - DR-EXT-08, DR-EXT-12, §2 Connectivity pin references, §5 ESD reference, BOM J7/J8 updated.
- `design/Electronics/Reflector/Design_Spec.md` - DR-REF-03, §2/§3 connector descriptions, JTAG warning block pin references, §4 power entry note, BOM J4 updated.
- `design/Electronics/Consolidated_BOM.md` - BHR-20-VUA row split; new 2BHR-30-VUA row added.
- `design/Electronics/System_Architecture.md` - JTAG chain diagram pin references updated.
- `design/Electronics/Investigations/JTAG_Integrity.md` - TTD_RETURN ribbon diagram pin references updated.
- `design/Electronics/Rotor/Board_Layout.md` - TTD_RETURN routing note updated.

---

## Open Questions

Questions raised during design review that are deferred pending further investigation or a future decision.

---

## QUE-001 - Exposed ENIG on Rib Clearway for GND_CHASSIS EMI Bonding

- **Status:** Closed - resolved by DEC-020 (2026-04-08)
- **Raised:** 2026-04-04
- **Area:** Power Module / All Boards - PCB Finish & EMC

### Background

The Power Module enclosure uses internal aluminium compression ribs that locate the PCB within the "Power Can".
The supercap block §4 defines a **2.0mm rib clearway** (14mm pitch, 12mm cell body) as a no-fly zone for traces on all layers.
A separate GND_CHASSIS copper pour already exists in the supercap shadow zone beneath the cells (§5).

The question is whether the rib clearway should have an **explicit solder mask opening (exposed ENIG)** on the top copper layer, connected to the GND_CHASSIS net,
so that when the PCB seats in the enclosure the aluminium ribs make direct electrical contact with the board's chassis ground.
This is a standard EMC bonding technique used in Eurocard/VME card-cage designs.

### What the change would involve

If accepted, the following updates would be made:

1. **Power Module Design_Spec.md §4** - Add bullet:
   > - **Rib Clearway ENIG Bond:** A solder mask opening (exposed ENIG) is placed in the 2.0mm rib clearway gap on the top copper layer, connected to GND_CHASSIS.
   >   Contact with the aluminium enclosure rib creates a distributed chassis ground bond at the supercap block location.

2. **Power Module Board_Layout.md** - Add keepout note:
   > Rib clearway gap: solder mask open, GND_CHASSIS copper strip, min 1.5mm wide x full rib depth.

3. **All other boards (Controller, Stator, Encoder)** - Assess whether their enclosure ribs also warrant the same treatment and add matching callouts if so.

4. **DEC-020** - Create a decision entry recording the EMC rationale, referencing the single-point GND_CHASSIS bond rule in Certification_Evidence.md §2.2.

### Considerations

| Factor | Note |
| ------ | ---- |
| Contact reliability | ENIG is ideal - hard, oxidation-resistant, consistent contact resistance |
| Enclosure material | Aluminium - no galvanic corrosion risk with ENIG |
| GND_CHASSIS topology | Single-point bond already defined (Cert_Evidence §2.2); rib contact adds distributed HF bond - compatible if star-point rule maintained for DC |
| Mechanical tolerance | Rib must be tight-fitting or spring-loaded to ensure reliable electrical contact |
| Other boards | Only applies where enclosure ribs contact the PCB - needs mechanical review per board |

### Resolution

Accepted. See DEC-020. Decision: expose ENIG on rib clearway zones, add minimum 2-mil polyimide (Kapton)
tape on supercap bodies, and add conductive elastomer gasket strip at the rib-to-PCB contact interface.
Other boards deferred pending mechanical design documentation (rib presence unconfirmed for Stator/Encoder/Rotor;
Controller noted as using 3D-printed prototype chassis with future metal chassis EMI gaskets per Mechanical_Design.md §3).

---

## QUE-002 - Prototype Bench-Testing Cable Strategy for Rotor Stack Connectors

- **Status:** CLOSED - 2026-04-08
- **Raised:** 2026-04-05
- **Area:** All Boards - Rotor Interface Connectors (ERF8/ERM8 0.8mm pitch) & Extension/Reflector Links

### Resolution

**Break-off PCB coupons** are to be included on the Rotor, Stator, Extension, and Reflector boards.
Each coupon is a small PCB tab attached to the main board by mousebite perforations. One coupon per
ERx8 connector. Each coupon fans out the 0.8mm pitch Samtec ERx8 pads to a standard **2.54mm pitch
shrouded IDC box header**, allowing standard ribbon cable assemblies to be used for initial bench
testing without full stack assembly.

**Coupon types required:**

| ERx8 Connector | Pins | IDC Header |
| :--- | :---: | :--- |
| ERM8-005 / ERF8-005 | 10 (2x5) | 2x5 IDC box header, 2.54mm pitch |
| ERM8-010 / ERF8-010 | 20 (2x10) | 2x10 IDC box header, 2.54mm pitch |
| ERM8-020 / ERF8-020 | 40 (2x20) | 2x20 IDC box header, 2.54mm pitch |

**Per-board coupon provision:**

- **Rotor:** 6 coupons - J1 (ERM8-005), J2 (ERM8-005), J3 (ERM8-010), J4 (ERF8-005), J5 (ERF8-005), J6 (ERF8-010)
- **Stator:** 4 coupons - J8 (ERM8-020) + J1/J2/J3 for Slot 1 test (ERF8-005 x2, ERF8-010 x1)
- **Extension:** 6 coupons - J1 (ERM8-005), J2 (ERM8-005), J3 (ERM8-010), J4 (ERF8-005), J5 (ERF8-005), J6 (ERF8-010)
- **Reflector:** 3 coupons - J1 (ERM8-005), J2 (ERM8-005), J3 (ERM8-010)

For final assembly the coupons are snapped off at the mousebite perforations and the ERx8 connectors mate
directly board-to-board. Coupon IDC connector selection (shrouded box header part numbers) and exact
PCB fanout geometry to be defined at schematic/layout phase.

Where early board concepts currently show permanent probe pads or other test-only breakout features,
that access should be reviewed for migration onto the removable coupons during schematic/layout
finalisation so the finished machine does not carry unnecessary permanent diagnostic hardware.

### Background

The rotor-to-rotor, rotor-to-Stator, and rotor-to-Reflector/Extension connections all use the Samtec
Edge-Rate ERF8/ERM8 0.8mm pitch family, which are direct board-to-board connectors with no off-the-shelf
cable assembly equivalent at standard distributors. During prototype bench testing it will not always be
practical to have all boards physically stacked.

The Extension/Reflector link (J7 on Stator, J7/J8 on Extension, J4 on Reflector) and the Encoder ports
(Stator J4-J6) use 2.54mm pitch shrouded IDC headers for which standard ribbon cable assemblies are
readily available.

### Questions to Resolve Before Prototype Build

1. **ERF8/ERM8 0.8mm pitch:** Are Samtec ERCD/ERCC cable assemblies available and stocked at DigiKey
   or Mouser for the ERF8-005 and ERF8-010 series? If not, what is the preferred bench-testing strategy
   (e.g., small bridge PCBs, short rigid extender boards, or FPC/FFC with pitch adapter)?
2. **Connector selection review:** Confirm that ERF8/ERM8 is still the correct family for the final
   design before committing to prototype PCB orders - alternative connector families may offer
   cable-assembly options without changing the electrical design.
3. **2.54mm IDC cables:** Confirm standard IDC ribbon cable lengths and sources for Stator J10
   (16-pin 2x8) and Stator J4-J9 encoder ports (20-pin 2x10).

### Note

This question was deferred to prioritise getting the connector definitions consolidated. The connector
designators and signal assignments are considered stable (pending QUE-002 resolution). If a connector
family change is required for prototype cabling, the affected documents are:
`Stator/Design_Spec.md`, `Extension/Design_Spec.md`, `Reflector/Design_Spec.md`, `Rotor/Design_Spec.md`,
`Consolidated_BOM.md`, and the Design_Log connector inventory.

> **Amendment - DEC-043:** Question 3 referenced "Stator J10 (16-pin 2x8)" - this is stale.
> J10 was widened to **20-pin 2x10 BHR-20-VUA** by DEC-043. The Reflector/Extension link connectors
> (Stator J10, Extension J7/J8, Reflector J4) are all 2.54mm-pitch shrouded IDC BHR-20-VUA headers
> for which standard 20-wire IDC ribbon cable assemblies are commercially available. These connectors
> are **not** Samtec ERF8/ERM8 0.8mm-pitch connectors; they do **not** require break-off PCB coupons
> and are outside the scope of the ERF8/ERM8 bench-test coupon strategy. Cable lengths and sourcing
> for these links can be confirmed at prototype procurement - no design-phase action required.

---

## INC Review History

This section records all INC (inconsistency) items tracked during the design process. Each item was identified during design review, verified, and resolved. All items are closed.

| INC | Area | Description | Original Value | Corrected Value | Status |
| ----- | ------ | ------------- | ---------------- | ----------------- | -------- |
| INC-01 | Power Module eFuse | UVLO/OVLO thresholds inconsistent between README and Design_Spec | README: 12V UVLO / 16V OVP | 11.0V UVLO / 16.9V OVLO (per Design_Spec §5) | ✔ Resolved - README corrected |
| INC-02 | Power Module eFuse | eFuse current limit insufficient for 75W USB-C path. TPS259474L max 5.5A with no headroom at 5.0A worst case | TPS259474L (5.5A ILIM) | TPS25980 (7A ILIM, 16.9V OVLO, VQFN-24). See DEC-005 | ✔ Resolved - DEC-005 |
| INC-03 | Power Module 5V Buck | Single buck insufficient for CM5 25W + other loads | LM61460-Q1 (6A) | Dual LMQ61460-Q1 interleaved (12A total). See DEC-007 | ✔ Resolved - DEC-007 |
| INC-04 | Power Module PD Emulator | TPS25750 PDO listed as "5V/6A" - not a valid USB-C PD current at 5V | "5V/6A" (invalid) | 5V/5A (25W maximum at 5V per USB-C PD spec). See DEC-008 | ✔ Resolved - DEC-008 |
| INC-05 | Link-Alpha BtB Connector | 3V3_SYSTEM routed from CM5 to Power Module on pins 21-24 for RJ45 LED anodes - cross-domain dependency | 3V3_SYSTEM on pins 21-24 (input from CM5) | Removed. 3V3_ENIG generated locally on Power Module. Pins 21-22 → 5V_MAIN; pins 23-24 → GND. See DEC-001 | ✔ Resolved - DEC-001 |
| INC-06 | Power Module PoE | Ag5300 PoE module only supports 802.3at (25.5W PD) - insufficient for full system load ~42W | Ag5300 (802.3at, 25.5W) | Discrete: TPS2372-4 + TPS23730 + Coilcraft POE600F-12LD (802.3bt Type 4 / Class 8, 72W system; T2 transformer = 60W). See DEC-002 | ✔ Resolved - DEC-002 |
| INC-07 | Power Module / Controller | "3.3V/5A Rotors Buck" placed on Controller Board in README; contradicts central power generation principle | README: Rotor Buck on Controller Board | All rails on Power Module. Rotor stack uses 3V3_ENIG. See DEC-011 | ✔ Resolved - DEC-011 |
| INC-08 | Power Module I2C | I2C pull-ups (SDA/SCL 4.7kΩ) tied to 3V3_SYSTEM - invalid once 3V3_SYSTEM removed from Power Module | Pull-ups to 3V3_SYSTEM | Pull-ups moved to 3V3_ENIG | ✔ Resolved |
| INC-09 | Power Module Design_Spec | Internal conflict: §1 stated "16.5V OVP"; §5 stated "17V OVLO" - two different values in same document | §1: 16.5V OVP | 16.9V OVLO (consistent with TPS25980 fixed OVLO variant; §1 corrected) | ✔ Resolved - auto-resolved (16.5V reference not found in any current file) |
| INC-10 | Power Module BOM | Reference designator collision: R1-R3 used for both eFuse ladder resistors AND I2C/reset pull-ups in the same document | R1-R3 dual-use | eFuse ladder: R1/R2/R3. I2C pull-ups: R7/R8. Reset pull-up: R9 | ✔ Resolved - designators renamed |
| INC-11 | Power Module Battery | BATT_PRES_N pull-up R6 tied to 3V3_SYSTEM - invalid once 3V3_SYSTEM removed | R6 pull-up to 3V3_SYSTEM | R6 pull-up moved to 3V3_ENIG | ✔ Resolved |
| INC-12 | Link-Alpha BtB Connector | Power cluster labelled "6A Delivery Cluster" - outdated after dual 12A buck upgrade and pin reallocation | "6A Delivery Cluster" (16 pins) | 9A delivery (18 pins x 0.5A/pin after reallocation). Label updated | ✔ Resolved |
| INC-13 | Power Module USB-C | STUSB4500 specified to negotiate 15V/3A (45W) - only 56.7% eFuse utilisation violation at worst-case 42.5W load | STUSB4500: 15V/3A (45W) | STUSB4500: 15V/5A (75W). See DEC-006 | ✔ Resolved - DEC-006 |
| INC-14 | Controller probe-access concept | Historical Controller bring-up probe pads had no ESD protection while exposed ENIG pads were still present in the concept design | No ESD on bring-up probe pads | Fixed probe-access pads removed from the active board design; any future coupon-based probe access will need a new ESD review | ✔ Resolved - pads removed from active design |
| INC-15 | Controller/Power Module | Internal conflict in Board_Layout.md: bullet list said I2C=pins 35-40, 3V3_ENIG=pins 41-44; ASCII diagram said I2C=35-38, 3V3_ENIG=39-44 | Bullets: I2C 35-40; 3V3_ENIG 41-44 | ASCII diagram authoritative: I2C 35-38, 3V3_ENIG 39-44 (6 pins at 51.4% utilisation) | ✔ Resolved - ASCII diagram is authoritative |
| INC-16 | Board_Layout.md ETH LED diagram | ETH LED diagram showed PIN 27 = ETH_LED_ACT; main pin map shows pins 27-30 = GND Isolation Moat | Diagram: PIN 27 = ETH_LED_ACT | Correct: PIN 26 = ETH_LED_ACT; PIN 27 = GND Moat | ✔ Resolved |
| INC-17 | Power Module Battery | eFuse OVLO margin: with 16.9V OVLO and 4.2V/cell BMS (16.8V max), only 0.1V margin - risk of nuisance trips | BMS max 4.2V/cell (16.8V); OVLO 16.9V; margin 0.1V | BMS must use 4.1V/cell max (16.4V total for 4S), giving 0.5V margin. Added to Design_Spec §2. See DEC-005 | ✔ Resolved |
| INC-18 | Power Module Design_Spec | Battery BMS charge voltage not specified in design spec - required to protect against OVLO nuisance trips | No BMS charge spec | Added: "BMS max charge voltage = 4.1V/cell (16.4V for 4S)" to Power Module §2 Battery Interface | ✔ Resolved |
| INC-19 | Power Module PoE | Ag5300/Ag53000 is 802.3at only (25.5W PD). No 802.3bt Type 4 PCB module found. Architecture change required: Type 3 (51W) insufficient; Type 4 (72W) required | Ag5300/Ag53000 (802.3at SIL module) | Discrete two-stage: TPS2372-4 (PD) + TPS23730 + POE600F-12LD (ACF transformer). See DEC-002 | ✔ Resolved - DEC-002 |
| INC-20 | Power Module Supercap | Supercap charge path had no current limiting - would cause excessive inrush and violate 75% utilisation rule under PoE | Supercap directly on 5V_MAIN bus | LTC3350 soft-charge via RICHARGE resistor; 0.5A limit under PoE. See DEC-004 | ✔ Resolved - DEC-004 |
| INC-21 | Power Module J2 | Component selection locked: RJ45 MagJack | - | Wurth 7499111121A (SMT, shielded, 2-LED, 10/100/1000) | ✔ Locked |
| INC-22 | Power Module ESD | Component selection locked: Ethernet ESD arrays | - | 2x TI TPD4E05U06QDQARQ1 (0.8pF, ±15kV, -40°C to +125°C, U-DFN-10). DigiKey: 296-40696-1-ND; Mouser: 595-PD4E05U06QDQARQ1; JLCPCB: C81353 | ✔ Locked |
| INC-23 | Power Module Bob Smith | Component selection locked: Bob Smith termination network | - | 4x 75Ω 0402 ±1% resistors + 1x 10nF Y1-class capacitor to GND_CHASSIS | ✔ Locked |
| INC-24 | All Boards | Encoder detailed design review phase complete. Two consecutive clean passes (R56 + R57) achieved across all 24 design documents. Key corrections during cycle: GPIO 20/24 swap propagated to all files (R50/R55); LDO load 2.20A→2.11A propagated to all files (R50-R53); Power_Budgets.md CSS2H build qty corrected to 3; JTAG topology (BtB vs ribbon) documented in JTAG_Integrity.md, Extension Design_Spec, Reflector Design_Spec. Extension U1 buffer (SN74LVC2G125DCUR) confirmed correct and intentional. | - | - | ✔ Phase complete |

---

## Board Connector Inventory

The following table lists all physical connectors across every board in the Enigma-NG system. This list should be manually verified against the original intended design to confirm no specification
changes have inadvertently altered connector placement, orientation, or mating requirements.

### Power Module

| Ref | Description | Part / Series | MPN | Mouser PN | DigiKey PN | Notes |
| ----- | ------------- | --------------- | ----- | ----------- | ------------ | ------- |
| J1 | Link-Alpha BtB - 80-pin socket to Controller Board | Samtec ERM8-040-05.0-S-DV-K-TR | ERM8-040 | 200-ERM8040050SDVKTR | SAM8613CT-ND | Male header (ERM8). Mating female on Controller (ERF8). Gold-plated, 0.5A/pin |
| J2 | RJ45 MagJack with integrated magnetics | Wurth 7499111121A | 7499111121A | 710-7499111121A | 1297-1070-5-ND | SMT, shielded, 2 integrated LEDs (green/yellow), 10/100/1000 PoE compatible |
| J3 | Battery connector - 5-pin Micro-Fit 3.0 THT vertical | Molex 43650-0519 | 43650-0519 | 538-43650-0519 | WM14587-ND | 5-circuit, 1-row, gold contacts, board lock, 3mm pitch. ⚠️ MPN corrected (43045-0512 does not exist) |

### Controller Board

| Ref | Description | Part / Series | MPN | Mouser PN | DigiKey PN | Notes |
| ----- | ------------- | --------------- | ----- | ----------- | ------------ | ------- |
| J1 | Link-Alpha BtB - 80-pin socket to Power Module | Samtec ERF8-040-05.0-S-DV-K-TR | ERF8-040 | 200-ERF8040050SDVKTR | SAM8621CT-ND | Female socket (ERF8). Mating male on Power Module (ERM8) |
| J2 | Link-Beta BtB - 40-pin socket to Stator Board | Samtec ERF8-020-05.0-S-DV-K-TR | ERF8-020 | 200-ERF8020050SDVKTR | SAM8619CT-ND | Female socket (ERF8). Mating male on Stator (ERM8-020). 40-pin per DEC-015 |
| J3 | USB 3.0 - Dual-stacked Type-A port | Molex 48406-0003 | 48406-0003 | 538-0484060003 | WM1394-ND | Dual-stack Type-A, 5.0mm protrusion through chassis |
| J4 | HDMI - Full-size Type-A | TE Connectivity 2007435-1 | 2007435-1 | 571-2007435-1 | A125057-ND | Full-size HDMI Type-A, 5.0mm protrusion through chassis |
| - | JTAG Daughterboard link (to FT232H board) | 1x5 INPUT header + 1x10 JTAG header | - | - | - | 2.54mm ENIG male headers on Controller. JDB female headers mate here. USB 2.0 to CM5 internally |

### Stator Board

| Ref | Description | Part / Series | MPN | Mouser PN | DigiKey PN | Notes |
| ----- | ------------- | --------------- | ----- | ----------- | ------------ | ------- |
| J1-J3 | Rotor 1 interface sockets (1 slot x 3 connectors: JTAG ERF8-005, Power ERF8-005, ENC ERF8-010) - cross-ref Rotor/Design_Spec.md §3.4 | ERF8-005 (J1+J2) / ERF8-010 (J3) | 200-ERF8005050SDVKTR (J1+J2) / 200-ERF8010050SDVKTR (J3) | SAM13517CT-ND (J1+J2 CT) / SAM8618CT-ND (J3 CT) | C7273978 (J1+J2) / C3646170 (J3) | ERF8 0.8mm pitch female sockets. Rotor 1 input side only (serial chain - not 30 slots). J1 pin 6 = TTD (outgoing TDI). |
| J4-J9 | Encoder port headers (x6: `KBD_ENC`, `LBD_DEC`, `PLG_PASS1_DEC`, `PLG_PASS1_ENC`, `PLG_PASS2_DEC`, `PLG_PASS2_ENC`) - 20-pin 2x10 shrouded box header | Adam Tech BHR-20-VUA / 2BHR-20-VUA (2x10, 2.54mm) | BHR-20-VUA | 737-BHR-20-VUA | 2057-BHR-20-VUA-ND | THT, shrouded, keyed. Pinout definition owner - see Stator/Board_Layout.md J4-J9. JLCPCB C17340054 uses 2BHR-20-VUA MPN. |
| J10 | Extension/Reflector Link - 16-pin shrouded box header | Adam Tech BHR-16-VUA (2x8, 2.54mm) | BHR-16-VUA | 737-BHR-16-VUA | 2057-BHR-16-VUA-ND | THT, shrouded. Power, reflector-boundary aliases, TTD_RETURN (pin 15). Pinout definition owner - see Stator/Board_Layout.md J10. JLCPCB C17692295 |
| J8 | Link-Beta BtB - 40-pin plug to Controller Board | Samtec ERM8-020-05.0-S-DV-K-TR | ERM8-020 | 200-ERM8020050SDVKTR | SAM8611CT-ND | Male plug (ERM8). Mating female on Controller (ERF8-020). 40-pin per DEC-015 |
| - | JTAG Aux header | 2x5 2.54mm shrouded | - | - | - | Pin pattern: GND\|TCK\|GND\|TMS\|GND\|TDI\|GND\|SYS_RESET_N\|GND |

### Rotor Board (x30)

| Ref | Description | Part / Series | MPN | Mouser PN | DigiKey PN | JLCPCB Part # | Notes |
| ----- | ------------- | --------------- | ----- | ----------- | ------------ | ------- | ------- |
| J1 | JTAG input - ERM8 male header (input side; plugs into Stator J1 ERF8 or Extension J4 ERF8) | Samtec ERM8-005-05.0-S-DV-K-TR (10-pin, 0.8mm pitch) | ERM8-005 | 200-ERM8005050SDVKTR | 612-ERM8-005-05.0-S-DV-K-TRCT-ND | C3649741 | Male (ERM8). Input side. Authority: Rotor/Design_Spec.md §3.4 |
| J2 | Power input - ERM8 male header (3V3_ENIG x5, GND x5) | Samtec ERM8-005-05.0-S-DV-K-TR (10-pin, 0.8mm pitch) | ERM8-005 | 200-ERM8005050SDVKTR | 612-ERM8-005-05.0-S-DV-K-TRCT-ND | C3649741 | Male (ERM8). Input power side |
| J3 | ENC Data input - ERM8 male header (ENC_IN/ENC_OUT + GND) | Samtec ERM8-010-05.0-S-DV-K-TR (20-pin, 0.8mm pitch) | ERM8-010 | 200-ERM8010050SDVKTR | SAM8610CT-ND | C374877 | Male (ERM8). Input ENC data |
| J4 | JTAG output - ERF8 female socket (output side; receives next Rotor J1, Reflector J1, or Extension J1 ERM8 male) | Samtec ERF8-005-05.0-S-DV-K-TR (10-pin, 0.8mm pitch) | ERF8-005 | 200-ERF8005050SDVKTR | SAM13517CT-ND | C7273978 | Female (ERF8). Output side. R1 (75Ω) in TTD output path |
| J5 | Power output - ERF8 female socket (3V3_ENIG x5, GND x5) | Samtec ERF8-005-05.0-S-DV-K-TR (10-pin, 0.8mm pitch) | ERF8-005 | 200-ERF8005050SDVKTR | SAM13517CT-ND | C7273978 | Female (ERF8). Output power side |
| J6 | ENC Data output - ERF8 female socket (ENC_IN/ENC_OUT + GND) | Samtec ERF8-010-05.0-S-DV-K-TR (20-pin, 0.8mm pitch) | ERF8-010 | 200-ERF8010050SDVKTR | SAM8618CT-ND | C3646170 | Female (ERF8). Output ENC data |

### Encoder Board

| Ref | Description | Part / Series | MPN | Mouser PN | DigiKey PN | Notes |
| ----- | ------------- | --------------- | ----- | ----------- | ------------ | ------- |
| J1 (x64) | Plugboard cipher jack sockets (one per key/lamp position) | 6.35mm (¼") mono switched panel-mount jack socket - already purchased (eBay: SaiBuy.Ltd item 334364197440) | - | - | - | THT panel-mount. 64x per board (26 input + 26 output + 10 plugboard positions + 2 spare). Purchased. |
| J2 | Data link to Stator - 20-pin 2x10 shrouded box header | Adam Tech BHR-20-VUA / 2BHR-20-VUA (2x10, 2.54mm) | BHR-20-VUA | 737-BHR-20-VUA | 2057-BHR-20-VUA-ND | Mating connector for Stator J4-J9. Cross-ref: Stator/Board_Layout.md J4-J9. JLCPCB C17340054 uses 2BHR-20-VUA MPN. |

### Reflector Board

| Ref | Description | Part / Series | MPN | Mouser PN | DigiKey PN | JLCPCB Part # | Notes |
| ----- | ------------- | --------------- | ----- | ----------- | ------------ | ------- | ------- |
| J1 | Rotor 30 output - JTAG (ERM8-005, 10-pin **male**, 0.8mm pitch) | Samtec ERM8-005-05.0-S-DV-K-TR | ERM8-005-05.0-S-DV-K-TR | 200-ERM8005050SDVKTR | 612-ERM8-005-05.0-S-DV-K-TRCT-ND | C3649741 | Plugs into Rotor 30 J4 (ERF8-005 female). Definition owner: Rotor/Design_Spec.md §3.4 |
| J2 | Rotor 30 output - Power (ERM8-005, 10-pin **male**, 0.8mm pitch) | Samtec ERM8-005-05.0-S-DV-K-TR | ERM8-005-05.0-S-DV-K-TR | 200-ERM8005050SDVKTR | 612-ERM8-005-05.0-S-DV-K-TRCT-ND | C3649741 | Plugs into Rotor 30 J5 (ERF8-005 female). Definition owner: Rotor/Design_Spec.md §3.4 |
| J3 | Rotor 30 output - ENC Data (ERM8-010, 20-pin **male**, 0.8mm pitch) | Samtec ERM8-010-05.0-S-DV-K-TR | ERM8-010-05.0-S-DV-K-TR | 200-ERM8010050SDVKTR | SAM8610CT-ND | C374877 | Plugs into Rotor 30 J6 (ERF8-010 female). Definition owner: Rotor/Design_Spec.md §3.4 |
| J4 | Interconnect to Stator/Extension - 16-pin shrouded box header | Adam Tech BHR-16-VUA (2x8, 2.54mm) | BHR-16-VUA | 737-BHR-16-VUA | 2057-BHR-16-VUA-ND | JLCPCB C17692295 | Mating connector for **Stator J10** (or Extension J7/J8). Carries TTD_RETURN on pin 15. |

### Extension Board

| Ref | Description | Part / Series | MPN | Mouser PN | DigiKey PN | JLCPCB Part # | Notes |
| ----- | ------------- | --------------- | ----- | ----------- | ------------ | ------- | ------- |
| J1 | Rotor group input - JTAG (ERM8-005, 10-pin **male**, 0.8mm pitch) | Samtec ERM8-005-05.0-S-DV-K-TR | ERM8-005-05.0-S-DV-K-TR | 200-ERM8005050SDVKTR | 612-ERM8-005-05.0-S-DV-K-TRCT-ND | C3649741 | Plugs into previous rotor group's last rotor J4 (ERF8-005 female). Cross-ref: Rotor/Design_Spec.md §3.4 |
| J2 | Rotor group input - Power (ERM8-005, 10-pin **male**, 0.8mm pitch) | Samtec ERM8-005-05.0-S-DV-K-TR | ERM8-005-05.0-S-DV-K-TR | 200-ERM8005050SDVKTR | 612-ERM8-005-05.0-S-DV-K-TRCT-ND | C3649741 | Plugs into previous rotor group's last rotor J5 (ERF8-005 female). |
| J3 | Rotor group input - ENC Data (ERM8-010, 20-pin **male**, 0.8mm pitch) | Samtec ERM8-010-05.0-S-DV-K-TR | ERM8-010-05.0-S-DV-K-TR | 200-ERM8010050SDVKTR | SAM8610CT-ND | C374877 | Plugs into previous rotor group's last rotor J6 (ERF8-010 female). |
| J4 | Rotor group output - JTAG (ERF8-005, 10-pin female, 0.8mm pitch) | Samtec ERF8-005-05.0-S-DV-K-TR | ERF8-005-05.0-S-DV-K-TR | 200-ERF8005050SDVKTR | SAM13517CT-ND | C7273978 | Receives next rotor group's first rotor J1 (ERM8-005 male). Cross-ref: Rotor/Design_Spec.md §3.4 |
| J5 | Rotor group output - Power (ERF8-005, 10-pin female, 0.8mm pitch) | Samtec ERF8-005-05.0-S-DV-K-TR | ERF8-005-05.0-S-DV-K-TR | 200-ERF8005050SDVKTR | SAM13517CT-ND | C7273978 | Receives next rotor group's first rotor J2 (ERM8-005 male). |
| J6 | Rotor group output - ENC Data (ERF8-010, 20-pin female, 0.8mm pitch) | Samtec ERF8-010-05.0-S-DV-K-TR | ERF8-010-05.0-S-DV-K-TR | 200-ERF8010050SDVKTR | SAM8618CT-ND | C3646170 | Receives next rotor group's first rotor J3 (ERM8-010 male). |
| J7 | Extension Port IN - 16-pin 2x8 shrouded box header | Adam Tech BHR-16-VUA (2x8, 2.54mm) | BHR-16-VUA | 737-BHR-16-VUA | 2057-BHR-16-VUA-ND | JLCPCB C17692295 | Mating connector for Stator J10 (or previous Extension J8). Cross-ref: Stator/Board_Layout.md J10 |
| J8 | Extension Port OUT - 16-pin 2x8 shrouded box header | Adam Tech BHR-16-VUA (2x8, 2.54mm) | BHR-16-VUA | 737-BHR-16-VUA | 2057-BHR-16-VUA-ND | JLCPCB C17692295 | Feeds next Extension J7 or Reflector J4. Cross-ref: Stator/Board_Layout.md J10 |

### JTAG Daughterboard (FT232H)

| Ref | Description | Part / Series | Notes |
| ----- | ------------- | --------------- | ------- |
| J1 | INPUT header - 5V_USB, 3V3_ENIG, D+, D-, GND | 1x5 2.54mm female IDC | Power in (5V_USB + 3V3_ENIG) + internal USB 2.0 to CM5 via hat-header |
| J2 | JTAG OUTPUT header (10-pin interleaved GND) | 1x10 2.54mm female IDC | TCK/GND/TDI/GND/TDO/GND/TMS/GND/VREF/GND |

---

> **Note for manual review:** Items marked `???` or `⚠️ verify` require confirmation before the BOM is finalised for procurement. In particular: Encoder J1 plug/jack type has not been selected;
> Controller J1 (ERF8) DigiKey PN SAM8621CT-ND (confirmed); Power Module J3 (43650-0519) DigiKey WM14587-ND (confirmed).

---

## Open Work Items

The following items have been identified as future tasks. They are not yet scheduled but must not be forgotten.

### OWI-001 - Test Coupons per Board

Add test coupon footprints to each board design to simplify manufacturing test and functional verification.
Each board must be specified independently, as the relevant test signals and accessible nets will differ per board.
Diagnostic-bank style bring-up access should be relocated onto these removable coupons wherever practical,
so full prototype and service test coverage is retained without carrying extra test-only hardware into the
final assembled machine.

### OWI-002 - PAS Definitions per Board

Define Provisional Acceptance Specifications (PAS) for each board, covering:

- **Basic board testing** - power-on checks, continuity, short detection.
- **Functional testing via coupons** - using coupon connections to real external devices to verify board functionality
  end-to-end (e.g. JTAG chain continuity, signal integrity, CPLD programming verification).
- **Bring-up access strategy** - PAS definitions should prefer removable coupon-based access for
  bring-up probes, rather than requiring permanent on-board probe features in the finished product.

Each board must be specified independently.

### OWI-003 - VHDL Pseudo-Code and CPLD Configuration Plans

For each CPLD in the system, create:

- A configuration plan describing the intended logical function, I/O assignments, and state machine behaviour.
- Pseudo-code or annotated VHDL stubs ready for handoff to software development.
- Notes on how the VHDL can be exercised during PAS testing (OWI-002) to verify functional correctness.

Boards with CPLDs requiring this work: Encoder (x2), Stator (x1), Rotor (x1 per rotor, x30 total).

---

## DEC-054 - Signal Net Renamed: PWR_BUT → PWR_BUT_N (Active-Low Suffix Conformance)

- **Status:** Active
- **Date:** 2026-07-11
- **Category:** Electrical / Net Naming
- **Area:** Power Module, Controller Board, System Architecture, Software

### Decision

The signal net `PWR_BUT` (the power key line from the Power Module to the CM5 PMIC dedicated
hardware input) is renamed to `PWR_BUT_N` to conform with the Enigma-NG active-low suffix
convention (`_N`) defined in `design/Standards/Global_Routing_Spec.md §10`.

### Rationale

- The MIC1555 U15 monostable circuit and Q5 BSS138 N-FET on the Power Module pull this signal
  **LOW** to assert a 3.01 s power key event; SW2 also pulls it LOW on manual press.
- The CM5 PMIC receives the signal on its dedicated hardware power-key input pin, which has an
  internal 10 kΩ pull-up and interprets a brief LOW pulse as an orderly shutdown event.
- FR-PM-07 (`design/Electronics/Power_Module/Design_Spec.md`) explicitly states
  "pulse CM5 PWR_BUT LOW" — active-LOW signal.
- The `_N` suffix unambiguously documents the active polarity for future reviewers.

### Alternatives Considered

- Keeping `PWR_BUT` without a suffix — rejected; no suffix creates ambiguity and does not conform
  to the GRS §10 naming standard applied to all other active-low signals in this design.

### Impact

- Net rename applied in: `Power_Module/Design_Spec.md`, `Power_Module/Board_Layout.md`,
  `Controller/Design_Spec.md`, `Controller/Board_Layout.md`, `System_Architecture.md`,
  `Software/Linux_OS/Power_Management.md`, `Datasheets/RPi-cm5-datasheet.md`.
- `Controller/Design_Spec.md §6.1` updated to document the CM5 PMIC pin mapping and active-LOW
  polarity explicitly.
- No electrical change; net renaming only.

---

## DEC-055 — F-108 System-Wide Reference Designator and Requirement ID Consecutive Renumbering

**Date:** 2026-05-05
**Author:** Izzyonstage & GitHub Copilot
**Status:** Accepted

### Context

Pass 5 design review (finding F-108) identified non-consecutive reference designator (RefDes) and
requirement ID (FR/DR) numbering sequences in multiple board Design_Spec.md files. Gaps arose from
components and requirements retired during earlier design iterations. Consecutive numbering is
required for clean BOM grouping during Schematic Capture and PCB Layout.

### Decision

Renumber all affected component RefDes and FR/DR requirement IDs consecutively across all impacted
board Design_Spec files. No electrical change; documentation renaming only.

### Scope and Complete Renaming Mapping

#### JTAG Daughterboard (JDB)

**Component RefDes changes:**

| Old RefDes | New RefDes | Value / Type | Notes |
| --- | --- | --- | --- |
| R2 | R1 | 33 Ω 0402 | TDI series damping at FT232H |
| R6 | R2 | 33 Ω 0402 | TCK series damping after U2 buffer |
| R7 | R3 | 33 Ω 0402 | TMS series damping after U2 buffer |
| R8 | R4 | 33 Ω 0402 | TDI series damping before J2 |
| R3 | R5 | 10 kΩ 0402 | FT232H RESET_N pull-up |
| R4 | R6 | 10 kΩ 0402 | TMS pull-up near J2 |
| R5 | R7 | 10 kΩ 0402 | TCK pull-down near J2 |
| U5 | U2 | SN74LVC2G125DCUR | Dual 3-state JTAG buffer (U2–U4 were gaps) |

**FR/DR IDs:** Already consecutive DR-JDB-01 through DR-JDB-17; no ID renumbering required.
Cross-references within FR/DR cells updated to reflect new component RefDes above.

**Files updated:** `JTAG_Daughterboard/Design_Spec.md`, `Investigations/JTAG_Integrity.md`

---

#### Actuation Module (AM)

**Component RefDes changes:**

| Old RefDes | New RefDes | Value / Type | Notes |
| --- | --- | --- | --- |
| J2 | — | (retired) | Removed from sequence; was a gap entry |
| J3 | J2 | 1×5 2.54mm header | Programming header |
| J4 | J3 | 1×5 2.54mm header | |
| J5 | J4 | 1×5 2.54mm header | |
| J6 | J5 | 1×5 2.54mm header | |

**FR/DR IDs:** No renumbering required.

**Files updated:** `Actuation_Module/Design_Spec.md`

---

#### Power Module (PM)

**Component RefDes changes:**

| Old RefDes | New RefDes | Value / Type | Notes |
| --- | --- | --- | --- |
| D5 | — | (removed) | Invalid component; gap removed |
| D6 | D5 | BAT54 Schottky SOT-23 | |
| D7 | D6 | BAT54 Schottky SOT-23 | |

**FR/DR IDs:** No renumbering required.

**Files updated:** `Power_Module/Design_Spec.md`, `Power_Module/Board_Layout.md`

---

#### Rotor Board (ROT, ROT-26, ROT-64)

**Component RefDes changes:**

| Old RefDes | New RefDes | Value / Type | Notes |
| --- | --- | --- | --- |
| C14 | C9 | 100 nF X7R 50V 0402 | Moved into the contiguous 100nF group C1–C9 |
| C9 | C10 | 10 µF X7R 25V 0805 | Shifted +1 to make room for new C9 |
| C10 | C11 | 10 µF X7R 25V 0805 | |
| C11 | C12 | 10 µF X7R 25V 0805 | |
| C12 | C13 | 10 µF X7R 25V 0805 | |
| C13 | C14 | 10 µF X7R 25V 0805 | |

Result: C1–C9 all 100 nF 0402; C10–C14 all 10 µF 0805. Variant-specific refs (C16A/B, C17A/B,
C18–C21, C22A/B–C25A/B) unchanged.

**FR/DR IDs:** No renumbering required.

**Files updated:** `Rotor/Design_Spec.md`, `Rotor/Rotor_26_Char_Design.md`,
`Rotor/Rotor_64_Char_Design.md`, `Rotor/Board_Layout.md`

---

#### Controller Board (CTL)

**Component RefDes changes:**

| Old RefDes | New RefDes | Value / Type | Notes |
| --- | --- | --- | --- |
| C24 | C18 | 100 nF 0402 | PoE auxiliary bypass cap |
| C28 | C19 | 100 nF 0402 | PoE auxiliary bypass cap |
| U9 | U7 | TPS2372-4RGWR VQFN-24 | PoE PD interface (U7–U8 were gaps) |
| U10 | U8 | TPS23730RMTR WSON-10 | PoE auxiliary controller |

**FR/DR ID changes:**

DR-CTL-13 was retired (removed gap):

| Old ID | New ID |
| --- | --- |
| DR-CTL-14 | DR-CTL-13 |
| DR-CTL-15 | DR-CTL-14 |
| DR-CTL-16 | DR-CTL-15 |
| DR-CTL-17 | DR-CTL-16 |

**Files updated:** `Controller/Design_Spec.md`

---

#### Stator Board (STA)

**Component RefDes changes (shift −3 to fill gap at R13–R15):**

| Old Range | New Range | Value / Type |
| --- | --- | --- |
| R16–R43 | R13–R40 | Various 0402 resistors (28 components, all shifted −3) |

Detailed per-resistor mapping (old → new):
R16→R13, R17→R14, R18→R15, R19→R16, R20→R17, R21→R18, R22→R19, R23→R20, R24→R21, R25→R22,
R26→R23, R27→R24, R28→R25, R29→R26, R30→R27, R31→R28, R32→R29, R33→R30, R34→R31, R35→R32,
R36→R33, R37→R34, R38→R35, R39→R36, R40→R37, R41→R38, R42→R39, R43→R40.

**FR/DR IDs:** No renumbering required.

**Files updated:** `Stator/Design_Spec.md`

---

#### User Settings Module (USM)

**Component RefDes changes (shift −3 to fill gap at R78–R80):**

| Old Range | New Range | Value / Type |
| --- | --- | --- |
| R81–R98 | R78–R95 | 100 kΩ 1% 0402 (18 components, all shifted −3) |

**FR/DR IDs:** No renumbering required.

**Files updated:** `User_Settings_Module/Design_Spec.md`

---

#### Extension Module (EXT)

**Component RefDes changes:** None.

**FR/DR ID changes:**

DR-EXT-10 was retired (removed gap):

| Old ID | New ID |
| --- | --- |
| DR-EXT-11 | DR-EXT-10 |
| DR-EXT-12 | DR-EXT-11 |
| DR-EXT-13 | DR-EXT-12 |
| DR-EXT-14 | DR-EXT-13 |
| DR-EXT-15 | DR-EXT-14 |

**Files updated:** `Extension/Design_Spec.md`

---

### Consolidated BOM Updates

`design/Electronics/Consolidated_BOM.md` updated to reflect all renaming above. Additionally, a
pre-existing BOM error was corrected: `USM: R78-R80` (listed as 10 kΩ 0402 with count 3) was
removed from the 10 kΩ row. These components do not exist in USM Design_Spec.md; the entry was a
historic BOM artefact. The USM count in that row changed from 3 to `—` and the row total from 48
to 45.

### Alternatives Considered

- **Leave gaps:** Rejected. Schematic capture tools auto-increment RefDes; gaps cause annotation
  confusion and complicate BOM grouping.
- **Renumber variants separately from main:** Rejected for Rotor. Variant components now continue
  from the end of the main list (C10–C14) to preserve clarity and avoid dual-sequence confusion.

### Impact

- No electrical change; all renaming is documentation only.
- All cross-references within affected Design_Spec files (FR/DR cells, prose, BOM tables) updated.
- Consolidated BOM aligned with current Design_Spec state across all boards.
- JTAG_Integrity.md JDB-scoped references updated; Stator and Encoder references in that file
  intentionally left unchanged.

---

## DEC-056 — Relocate Investigation Documents to Board-Owned Folders

| Field | Value |
| --- | --- |
| **ID** | DEC-056 |
| **Status** | Accepted |
| **Date** | 2026-05-04 |
| **Author** | Design team |
| **Affects** | Repository structure; cross-references in multiple board files |

### Decision

Move the two investigation documents out of `design/Electronics/Investigations/` and into the
folders of the boards that own those topics. Rename the PoE document to match the content style
of other design artefacts.

| Old Path | New Path | Rationale |
| --- | --- | --- |
| `design/Electronics/Investigations/JTAG_Integrity.md` | `design/Electronics/JTAG_Daughterboard/JTAG_Integrity.md` | JTAG chain master is the JDB; document belongs with the board that owns the topic |
| `design/Electronics/Investigations/PoE_Investigation.md` | `design/Electronics/Controller/PoE_Power_Analysis.md` | PoE front-end is Controller-owned; rename reflects content (analysis, not open investigation) |

The `Investigations/` folder is removed entirely as it is now empty.

### Rationale

Placing investigation documents alongside the board that owns the topic makes it easier to
maintain them as part of the board review scope (as already practised for JTAG_Integrity — it was
reviewed with JDB in previous passes). The PoE document is likewise Controller-owned and was
always referenced from the Controller Design_Spec. The `Investigations/` folder name implied
open/unresolved work; moving the documents removes that ambiguity.

### Cross-references updated

All living design files referencing the old paths were updated:

- `.copilot/agent-directives.md` — integration review scope list updated
- `design/Electronics/Controller/Design_Spec.md` — PoE power table note
- `design/Electronics/Encoder/Design_Spec.md` — JTAG trace width rule
- `design/Electronics/Extension/Design_Spec.md` (×2) — JTAG trace width and stackup rules
- `design/Electronics/Extension/Board_Layout.md` — JTAG CI trace note
- `design/Electronics/JTAG_Daughterboard/Design_Spec.md` (×2) — termination and pull resistor notes
- `design/Electronics/JTAG_Daughterboard/Board_Layout.md` — impedance calculation note
- `design/Electronics/Reflector/Design_Spec.md` — JTAG trace width rule
- `design/Electronics/Reflector/Board_Layout.md` — JTAG CI trace note
- `design/Electronics/Rotor/Design_Spec.md` — JTAG trace width rule
- `design/Electronics/Rotor/Board_Layout.md` — JTAG CI trace note
- `design/Electronics/Stator/Design_Spec.md` — JTAG trace width rule

**Not updated (audit history — append-only):** All prior DEC entries in this log that reference the
old `Investigations/` paths remain as written; they record the historical file location at the time
of each decision.

---

## DEC-057 — Daughterboard Mounting Hole Specification and Standoff BOM Ownership

**Date:** 2026-05-05
**Status:** Accepted
**Amends:** DEC-039, DEC-023

### Decision

This is the single authoritative reference for mounting hole specification and standoff BOM
ownership across all boards in the Enigma-NG system.

#### 1. Daughterboard Classification

Only the following boards are classified as **daughterboards** (host-mounted via standoffs onto a
carrier board):

| Board | Carrier Board(s) | Attachment Method |
| :--- | :--- | :--- |
| Actuation Module (AM) | CTL, EXT | M2.5×3.5mm SMT standoffs (MH5-MH8 on each carrier) |
| JTAG Daughterboard (JDB) | CTL | M2.5 standoffs (MH13-MH16 on CTL — to be created at CTL schematic capture) |

All other boards (PM, CTL, STA, REF, EXT, ROT, USM, ENC) are **chassis-mounted** boards and are
**not** daughterboards. The Encoder Module (ENC) is explicitly **not** a daughterboard; it uses
standard M3 chassis mounting per GRS §4 and DEC-039.

#### 2. Mounting Hole Specification by Board Category

**Daughterboards (AM, JDB):**

- Mounting holes: **M2.5 NPTH**, pads connected to local **`GND`** net (not `GND_CHASSIS`).
- Rationale: Daughterboards share their ground reference with the carrier via the board-to-board
  connector. Tying mounting holes to `GND_CHASSIS` would create an unintended second galvanic
  chassis-bond point, violating the single-point chassis ground topology defined in DEC-039.

**Chassis-mounted boards (all others):**

- Mounting holes: **M3 PTH**, pads connected to **`GND_CHASSIS`** per
  `design/Standards/Global_Routing_Spec.md §4` and DEC-039.

**CTL special case (carries both categories):**

| Holes | Size / Type | Net | Purpose |
| :--- | :--- | :--- | :--- |
| MH1–MH4 | M2.5 4mm standoffs | `GND` | CM5 SoM mounting |
| MH5–MH8 | M2.5 3.5mm SMT standoffs | `GND` | AM daughterboard dock |
| MH9–MH12 | M3 PTH | `GND_CHASSIS` | Chassis mounting |
| MH13–MH16 | M2.5 | `GND` | JDB daughterboard dock |

JDB dock standoffs on CTL are assigned RefDes MH13-MH16 — to be created at CTL schematic capture stage.

#### 3. Standoff BOM Ownership

The **carrier (host) board** is solely responsible for specifying and sourcing the standoffs used
to attach a daughterboard. The **daughterboard itself shall not contain standoff BOM entries** for
its own attachment points.

| Carrier Board | Standoff Entries Owned | Qty per Board |
| :--- | :--- | :--- |
| CTL | AM dock standoffs (MH5-MH8, 9774035151R, M2.5×3.5mm SMT) | 4 |
| CTL | JDB dock standoffs (MH13-MH16, M2.5 — to be created at CTL schematic capture) | 4 |
| EXT | AM dock standoffs (MH5-MH8, 9774035151R, M2.5×3.5mm SMT) | 4 |

The AM and JDB Design_Specs shall each include an explicit note that their mounting standoffs are
defined and sourced on their respective carrier board(s), with a cross-reference to those carrier
boards' Design_Specs.

#### 4. Summary Table — All Boards

| Board | Category | Hole Size | Net | Standoffs in BOM? | Carrier |
| :--- | :--- | :--- | :--- | :--- | :--- |
| PM | Chassis | M3 PTH | `GND_CHASSIS` | N/A | — |
| CTL MH1-4 | SoM dock | M2.5 | `GND` | Yes (CM5 screws) | — |
| CTL MH5-8 | Daughterboard dock | M2.5 SMT | `GND` | Yes (AM standoffs) | — |
| CTL MH9-12 | Chassis | M3 PTH | `GND_CHASSIS` | N/A | — |
| CTL (JDB dock) | Daughterboard dock | M2.5 | `GND` | Yes (JDB standoffs, MH13-MH16) | — |
| STA | Chassis | M3 PTH | `GND_CHASSIS` | N/A | — |
| REF | Chassis | M3 PTH | `GND_CHASSIS` | N/A | — |
| EXT MH1-4 | Chassis | M3 PTH | `GND_CHASSIS` | N/A | — |
| EXT MH5-8 | Daughterboard dock | M2.5 SMT | `GND` | Yes (AM standoffs) | — |
| ROT | Chassis | M3 PTH | `GND_CHASSIS` | N/A | — |
| USM | Chassis | M3 PTH | `GND_CHASSIS` | N/A | — |
| ENC | Chassis | M3 PTH | `GND_CHASSIS` | N/A | — |
| AM | Daughterboard | M2.5 NPTH | `GND` | No — on CTL and EXT | CTL, EXT |
| JDB | Daughterboard | M2.5 NPTH | `GND` | No — on CTL | CTL |

### Rationale

A single, fully declarative decision removes ambiguity and provides a canonical single-document
reference for reviewers and future design agents.

### Impact

- `design/Electronics/Actuation_Module/Design_Spec.md`: DR-AM-03 — cite DEC-057 for both CTL and EXT
  as carrier boards in the standoff ownership note.
- `design/Electronics/Extension/Design_Spec.md`: DR-EXT-10 and BOM MH5-MH8 already correct; add
  cross-reference to this DEC-057 standoff ownership note.
- `design/Electronics/JTAG_Daughterboard/Design_Spec.md`: Mounting note — cite DEC-057 for standoff
  ownership rule.
- `design/Electronics/Controller/Design_Spec.md`: Confirm CTL BOM contains standoff rows for AM dock
  (MH5-MH8) and JDB dock (MH13-MH16) — to be verified at schematic capture stage.
- `design/Standards/Global_Routing_Spec.md §4`: No change — this DEC supplements rather than
  contradicts GRS; cross-reference may be added at GRS maintenance time.

---

## DEC-058 — JDB Connector Upgrade: Hat-Headers to DF40C-20 BtB

| **ID** | DEC-058 |
| --- | --- |
| **Status** | Accepted |
| **Date** | 2026-05-15 |
| **Author** | Izzyonstage & GitHub Copilot |
| **Associated Hardware Revision** | Rev A |

### Context

The JTAG Daughterboard (JDB) originally used two separate 2.54mm pin-header connectors: J1 (1×5 POWER INPUT) and J2 (1×10 JTAG OUTPUT).
These hat-style connectors produced a tall board-to-board stack of approximately 12–15mm, with no mechanical keying to prevent incorrect installation.
The JTAG signals were routed on separate pins with no differential-pair adjacency for the USB lines.
Following the AM daughterboard BtB upgrade pattern (DEC-057), a parallel upgrade was evaluated for the JDB.

### Decision

Replace J1 + J2 hat-header connectors with a single Hirose DF40C-20DP-0.4V(51) 20-pin board-to-board plug on the JDB,
mating with a Hirose DF40HC(3.5)-20DS-0.4V(51) receptacle (J12) on the CTL board.
The CTL board carries four M2.5×3.5mm Würth 9774035151R standoffs at MH13–MH16 to establish the 3.5mm stack height and provide mechanical support for the JDB.

### Rationale

- **Stack height**: 3.5mm vs ~12–15mm hat — significant reduction in mechanical profile within the chassis.
- **Positional keying**: Asymmetric mounting hole pattern (MH1/MH2 at corners top edge; MH3/MH4 inset bottom edge)
  combined with bottom-centre connector placement prevents incorrect orientation and rules out accidental mating with the AM dock location on the CTL board.
- **USB differential pair integrity**: USB+ (C5R2) and USB− (C6R2) are placed adjacent on the connector, forming a proper USB 2.0 FS differential pair as required.
- **Pattern consistency**: Matches the AM daughterboard BtB approach, standardising the daughterboard interface across the system.
- **VREF removal**: With 3V3_ENIG available directly on pin C7R1, a separate VREF pin is redundant; removing it simplifies the pinout.

### Finalised 20-Pin Pinout

```text
      C1     C2     C3     C4     C5     C6     C7     C8     C9    C10
 R1:  TCK    GND    GND    5V_U   GND    GND    3V3    GND    GND   TDI
 R2:  GND    TMS    GND    GND    USB+   USB-   GND    GND    TDO   GND
```

- R1 = outer (bottom) edge of JDB; when mounted on CTL, R1 must face toward LINK-BETA (J4/J5) to minimise JTAG trace length into the Stator.
- Abbreviations: 5V_U = 5V_USB, 3V3 = 3V3_ENIG, USB+/USB− = USB 2.0 FS differential pair.

### Connector Parts

| Board | RefDes | MPN | DigiKey | Mouser | JLCPCB |
| --- | --- | --- | --- | --- | --- |
| JDB | J1 | DF40C-20DP-0.4V(51) | H11618CT-ND | 798-DF40C20DP0.4V51 | C424637 |
| CTL | J12 | DF40HC(3.5)-20DS-0.4V(51) | 26-DF40HC(3.5)-20DS-0.4V(51)CT-ND | 798-DF40HC3520DS04V5 | C3644774 |
| CTL | MH13–MH16 | 9774035151R | 732-9774035151RCT-ND | 710-9774035151R | C22367582 |

### Deferred

- **FT232H 3.3V operation** (`jdb-ft232h-3v3-vregin`, v2.0): FT232H Rev C supports 3.0–3.6V on VREGIN,
  which would eliminate the 5V_USB pin from the connector entirely.
  Deferred pending Rev C availability confirmation; same timeline as display screen deferred todo.

### Files Affected

- `design/Electronics/JTAG_Daughterboard/Design_Spec.md`: DR-JDB-18/19/20 added; §3 pinout replaced with DF40 20-pin table; BOM rows updated.
- `design/Electronics/JTAG_Daughterboard/Board_Layout.md`: §1–§4 connector and ASCII art updated; §7.1 trace pin references updated; §8 Mounting Holes section added.
- `design/Electronics/Controller/Design_Spec.md`: DR-CTL-19/20 added; §8.3 replaced with DF40HC section and 20-pin pinout table; BOM J12/J13 hat-header rows removed, J12 DF40HC and MH13–MH16 rows added.
- `design/Electronics/Controller/Board_Layout.md`: ASCII art updated (`[ JDB DF40 dock ]`).
- `design/Electronics/Consolidated_BOM.md`: RS1-05-G CTL row removed (CTL no longer uses);
  RS1-10-G row removed (CTL J13 eliminated); PH1-05-UA JDB row removed; PH1-10-UA row removed;
  DF40HC CTL qty 1→2; DF40C-20DP JDB qty 0→1; 9774035151R CTL qty 4→8.

---

## DEC-059 — ERM8/ERF8 Stacking Height Confirmed; Rotor Stack Assembly Specification Created

| Field | Value |
| :--- | :--- |
| **Decision ID** | DEC-059 |
| **Status** | Confirmed |
| **Date** | 2026-05-28 |
| **Author** | Copilot (session a38ceaab) |
| **Amends** | — |

### Context

The ERM8/ERF8 rotor-interconnect connector stacking height was previously recorded as
approximately 5mm but was disputed (see checkpoint 154). A systematic re-read of both
Samtec datasheets was performed to establish the definitive value.

### Decision

The `-05.0-` lead style designation in the selected parts:

- `ERM8-005-05.0-S-DV-K-TR` (male, rotor Board A)
- `ERF8-005-05.0-S-DV-K-TR` (female, rotor Board B)

denotes a **5 mm per-connector** standing height above each PCB surface. Because
the two connectors mate end-to-end, the total PCB-to-PCB inter-rotor gap is:

> **5 mm (ERM8) + 5 mm (ERF8) = 10 mm**

This was independently verified against the Samtec published stack-height range for
the ERM8/ERF8 family (7 mm – 18 mm): the minimum of 7 mm = ERM8 -02.0 (2 mm) +
ERF8 -05.0 (5 mm), confirming the additive model.

The 1.5 mm contact-wipe figure stated in the ERM8 datasheet is a spring-travel
specification and does **not** reduce the board-separation distance.

The **-05.0/-05.0 pairing is the minimum achievable stacking height** for the
current connector selection. Taller variants are available:

| ERM8 lead | ERF8 lead | Total |
| :--- | :--- | :--- |
| -02.0 (2 mm) | -05.0 (5 mm) | 7 mm |
| -03.0 (3 mm) | -05.0 (5 mm) | 8 mm |
| **-05.0 (5 mm) [current]** | **-05.0 (5 mm) [current]** | **10 mm** |
| -05.0 (5 mm) | -07.0 (7 mm) | 12 mm |
| -08.0 (8 mm) | -05.0 (5 mm) | 13 mm |
| -08.0 (8 mm) | -07.0 (7 mm) | 15 mm |
| -09.0 (9 mm) | -07.0 (7 mm) | 16 mm |
| -09.0 (9 mm) | -09.0 (9 mm) | 18 mm |

Any change to stacking height requires a **DEFECT-DEC** and must update the
affected MPN(s) in all board Design_Spec BOMs and the Consolidated BOM.

### New documentation

`design/Mechanical/Rotor_Stack_Assembly/Design_Spec.md` was created to formally
capture:

- The mini-stack concept (5 rotors + boundary boards)
- The 10 mm inter-rotor gap derivation and source
- The full achievable stack-height options table
- Mechanical clearance requirements (TBD — pending prototyping)
- Indicative mini-stack depth calculation (~115 mm PCB-only, 5 rotors)

### Files Changed

- `design/Mechanical/Rotor_Stack_Assembly/Design_Spec.md`: NEW — full specification created.
- `design/Mechanical/Rotor/Design_Spec.md`: §7 design intent bullets updated; §7 cross-reference block updated; §9 cross-ref table updated.
- `design/Mechanical/Rotor_Actuation_Assembly/Design_Spec.md`: §8 cross-ref table updated; new Rotor_Stack_Assembly row added.
- `design/Mechanical/Complete_System_Assembly/Design_Spec.md`: Component Index (§2) updated; Sub-Assembly Reference Table (§3) updated.

---

## DEC-060 — JTAG Daughterboard Renamed to JTAG Module; JDB Prefix Replaced with JM

| Field | Value |
| :--- | :--- |
| **Decision ID** | DEC-060 |
| **Status** | Confirmed |
| **Date** | 2026-05-07 |
| **Author** | Izzyonstage & Copilot (session a38ceaab) |
| **Amends** | — |

### Context

The board previously known as the "JTAG Daughterboard" (abbreviated "JDB") mounts on
the Controller Board (CTL) via the DF40C-20 board-to-board connector introduced in
DEC-058. As a module that physically attaches to a carrier board (CTL) and operates
as a discrete, self-contained functional unit, the "Daughterboard" designation is
both imprecise and inconsistent with the rest of the system naming convention.

In addition, the Global Routing Specification (GRS) defines a specific mounting hole
ownership model for **Modules** — boards that mount on a carrier — governing standoff
BOM ownership and mounting hole RefDes conventions. Renaming this board to "JTAG
Module" ensures it is correctly classified under the GRS Module definition, tying
together design specification body text, BOM ownership rules, and component naming
convention in a consistent way.

### Decision

The board is renamed from **JTAG Daughterboard** to **JTAG Module** with immediate
effect:

| Old | New |
| :--- | :--- |
| JTAG Daughterboard | JTAG Module |
| JTAG_Daughterboard | JTAG_Module |
| JDB (prefix/abbreviation) | JM |

Historical audit entries (Design_Log.md DEC-001 through DEC-059 and all committed
session checkpoints) retain the original terminology as an accurate record of the
decisions made at the time. All live design documents use the new naming.

### Rationale

- The board mounts on CTL via DF40C BtB connector — it is a module on a carrier,
  not a daughter to a motherboard in the traditional sense.
- "JTAG Module" aligns with the project's module/carrier vocabulary used for the
  Encoder, User Settings Module, and Actuation Module.
- Adopting the Module classification brings the board under the GRS Module mounting
  hole rules (DEC-057), ensuring BOM ownership and standoff conventions are applied
  consistently without a bespoke carve-out.
- "JM" is unambiguous within the system; no other board or assembly uses this prefix.

### Files Changed

- `design/Electronics/JTAG_Module/` (folder): renamed from `JTAG_Daughterboard/`.
- `design/Electronics/JTAG_Module/Design_Spec.md`: all JDB/JTAG Daughterboard references updated.
- `design/Electronics/JTAG_Module/Board_Layout.md`: all JDB/JTAG Daughterboard references updated.
- `design/Electronics/JTAG_Module/JTAG_Integrity.md`: all JDB/JTAG Daughterboard references updated.
- `design/Electronics/Controller/Design_Spec.md`: cross-references updated.
- `design/Electronics/Controller/Board_Layout.md`: cross-references updated.
- `design/Electronics/Consolidated_BOM.md`: all JDB column references updated to JM.
- `design/Electronics/Boards_Overview.md`, `System_Architecture.md`, `Power_Budgets.md`: references updated.
- `design/Electronics/Actuation_Module/`, `Encoder/`, `Extension/`, `Reflector/`, `Rotor/`, `Stator/` Design_Spec and Board_Layout files: cross-references updated.
- `design/Mechanical/Complete_System_Assembly/Design_Spec.md`: references updated.
- `design/Standards/Global_Routing_Spec.md`: references updated.
- `README.md`: references updated.

---

## DEC-061 — Pass 7 Review Corrections: CTL/STA/ROT/ENC/AM/GRS/Status Updates

| Field | Value |
| :--- | :--- |
| **Decision ID** | DEC-061 |
| **Status** | Confirmed |
| **Date** | 2026-05-08 |
| **Author** | Izzyonstage & Copilot (session a38ceaab) |
| **Amends** | See also: DEC-057 |

### Context

A targeted review pass (Pass 7) of the active design documents identified a set of
minor but precise corrections required across several boards and the Global Routing
Specification. These are copy/accuracy issues rather than design intent changes:

1. **CTL Design_Spec §3:** A stale reference to `J13` appeared alongside `J12` in the
   JTAG pass-through description. The Controller Board carries a single JM BtB
   connector (`J12`); `J13` does not exist on this board.

2. **CTL Board_Layout §6:** Three cross-references to the Actuation Module design
   specification used an abbreviated filename (`AM Design_Spec.md`) rather than the
   full repo-relative path. Abbreviated paths are ambiguous in a multi-board repo and
   violate the cross-reference convention established in GRS §7.

3. **STA Design_Spec DR-STA-12:** The I²C address strapping for U6 and U7 was omitted
   from the Design Requirement row. DR-STA-13 already captured U8's strapping
   (`A2=LOW, A1=HIGH, A0=LOW`); DR-STA-12 required the same level of detail for U6
   (`0x20`) and U7 (`0x21`) to be complete and unambiguous.

4. **ROT Variant BOMs (N=26 and N=64):** The Notes fields for C20A/C21A and C20B/C21B
   contained variant-specific IC designators (`U11A`/`U11B`) and a design cross-reference
   (`see GRS §3.2`). BOM Notes must be factual component descriptions only; design intent
   and cross-references belong in the body text or Design Requirements.

5. **ENC Board_Layout §4.1, §4.2, §5.1/§5.2:** The 20-pin data-link connector was
   originally designated J2; it has since been renumbered to J1 (with the 64-line spade
   terminal bank now starting at J2). Several sections of the Board_Layout still used the
   old J2 and J3–J66 designators.

6. **AM Design_Spec BOM:** The Footprint Available column used the string `Yes` instead
   of the project-standard checkmark `✔`. All other board BOMs use `✔`; the AM BOM
   was inconsistent.

7. **GRS §4.3 Named Exceptions table — JM row:** The JM standoff range was listed as
   `MH13–MH16`, which is the CM5 SoM standoff group on the Controller Board. The JM
   dock standoffs are `MH9–MH12` per `Controller/Design_Spec.md §8` and `DR-CTL-21`.

8. **Status headers:** All board Design_Spec and Board_Layout files that had advanced
   past initial drafting were updated from `**Status:** Draft` to `**Status:** In Review`,
   consistent with the Pass 7 review milestone. The Extension Board files remain at
   `Draft` as that board has not entered review. `Boards_Overview.md` was updated from
   `Reference` to `In Review`, and the Extension Board row in its status table was
   corrected from `**In Review**` to `**Draft**`.

### Decision

Apply all eight corrections as described above. These are accuracy fixes only; no design
intent is changed. The JTAG pass-through topology, I²C address map, BOM MPNs/part
numbers, routing rules, and mounting hole patterns are unaltered.

### Rationale

- Accurate cross-references are required for document traceability and tooling that parses
  design files by path.
- I²C address strapping must be captured in the Design Requirement (not inferred) to
  prevent assembly errors.
- BOM Notes must be factual component descriptions to remain valid across variant and
  common BOMs without variant-specific assumptions.
- RefDes consistency between schematic, layout, and documentation is mandatory to avoid
  assembly and test errors.
- The footprint availability checkmark convention (`✔`) is used uniformly across all
  other board BOMs and must be consistent for BOM tooling.
- Correct MH range in GRS §4.3 prevents confusion between the JM standoff group and the
  CM5 SoM standoff group during assembly.

### Files Changed

- `design/Electronics/Controller/Design_Spec.md`: §3 J13 stale reference removed; J12 described as JM BtB connector. Status updated to In Review.
- `design/Electronics/Controller/Board_Layout.md`: §6 three abbreviated `AM Design_Spec.md` cross-references expanded to full repo-relative paths. Status updated to In Review.
- `design/Electronics/Stator/Design_Spec.md`: DR-STA-12 U6 and U7 I²C address strapping added. Status updated to In Review.
- `design/Electronics/Stator/Board_Layout.md`: Status updated to In Review.
- `design/Electronics/Rotor/Design_Spec.md`: Status updated to In Review.
- `design/Electronics/Rotor/Rotor_26_Char_Design.md`: C20A and C21A BOM Notes corrected. Status updated to In Review.
- `design/Electronics/Rotor/Rotor_64_Char_Design.md`: C20B and C21B BOM Notes corrected. Status updated to In Review.
- `design/Electronics/Encoder/Board_Layout.md`: §4.1, §4.2, §5.1, §5.2 RefDes updated: J2→J1 (data connector), J3–J66→J2–J65 (64-line bank). Status updated to In Review.
- `design/Electronics/Encoder/Design_Spec.md`: Status updated to In Review.
- `design/Electronics/Actuation_Module/Design_Spec.md`: BOM Footprint Available column `Yes` → `✔`. Status updated to In Review.
- `design/Electronics/Actuation_Module/Board_Layout.md`: Status updated to In Review.
- `design/Electronics/Power_Module/Design_Spec.md`: Status updated to In Review.
- `design/Electronics/Power_Module/Board_Layout.md`: Status updated to In Review.
- `design/Electronics/JTAG_Module/Design_Spec.md`: Status updated to In Review.
- `design/Electronics/JTAG_Module/Board_Layout.md`: Status updated to In Review.
- `design/Electronics/User_Settings_Module/Design_Spec.md`: Status updated to In Review.
- `design/Electronics/User_Settings_Module/Board_Layout.md`: Status updated to In Review.
- `design/Electronics/Reflector/Design_Spec.md`: Status updated to In Review.
- `design/Electronics/Reflector/Board_Layout.md`: Status updated to In Review.
- `design/Electronics/Boards_Overview.md`: Status header updated Reference → In Review; Extension Board table row corrected In Review → Draft.
- `design/Standards/Global_Routing_Spec.md`: §4.3 JM Named Exception row MH13–MH16 corrected to MH9–MH12.

---

## DEC-062 — CTL PoE T1 Selection: TDK B82806D0060A120; Topology ACF Flyback → ACF Forward

| Field | Value |
| :--- | :--- |
| **Decision ID** | DEC-062 |
| **Status** | Confirmed |
| **Date** | 2025-07-10 |
| **Author** | Izzyonstage & Copilot (session e39f3cc4) |
| **Amends** | DEC-019 (ACF topology selection); supersedes Coilcraft POE600F-12L as T1 |

### Context

The original T1 selection (Coilcraft POE600F-12L) was rejected because JLCPCB cannot
machine-place the large-body 12-pin SMT package. A replacement search was conducted across
Coilcraft, Würth, Pulse, Bourns, and TDK. TDK B82806D0060A120 emerged as the preferred
candidate: 60W (PoE++ Class 8), 1500V isolation, 12-pin SMT (6+6 format), rated 36–57V
input, 2:1:1 turns ratio (Np:Ns:Naux), Lm=100µH, Llk=0.18µH, fsw_max=500kHz.

Investigation of topology compatibility (conducted with reference to TI PMP23253 reference
design — 49.5W, TPS23730RMTR, ACF Forward) confirmed that the TPS23730RMTR controller
supports ACF Forward operation natively. The TDK B82806D0060A120 is an ACF **Forward**
transformer (ungapped core, Np:Ns standard wound, energy transferred during switch ON),
which is fundamentally incompatible with the ACF Flyback topology previously specified.
The topology must therefore change from ACF Flyback to ACF Forward throughout.

Key design consequence: ACF Forward requires a buck-style LC output filter on the secondary
(inductor + capacitor), whereas ACF Flyback uses capacitor-only. A new output inductor
component (L1, 33µH) must be added to the CTL BOM and routed in the PCB layout.

### Decision

1. **T1 selection confirmed:** TDK B82806D0060A120 (ACF Forward PoE transformer, 60W,
   1500V isolation, 2:1:1 turns ratio, 12-pin SMT). DigiKey: 495-76653-1-ND;
   Mouser: 871-B82806D0060A120; JLCPCB: C7218686.

2. **Topology change:** CTL PoE power stage changes from **ACF Flyback** to **ACF Forward**
   throughout all design documentation. Controller U8 (TPS23730RMTR) configuration changes
   accordingly.

3. **New component L1 (output inductor):** 33µH shielded ferrite SMT power inductor, ≥6A
   Isat, DCR ≤50mΩ, 200kHz rated. Required by ACF Forward topology. Part selection pending
   (new DR-CTL-25 added). L1 + C20 form the buck-style output LC filter on VIN_POE_12V.

4. **C17 value update:** Clamp capacitor C17 increased from 10nF to 22nF per ACF Forward
   clamp calculation using TDK B82806D0060A120 Llk=0.18µH. MPN update pending (DR-CTL-18
   revised).

5. **Q1, Q2 unchanged:** STD25NF20 200V N-ch MOSFET remains correct for both ACF primary
   and clamp switch roles. Vds_peak in ACF Forward (≤108V at worst case Vin=36V) remains
   well within 200V rated device.

6. **C20 unchanged:** 4× TDK CGA9N3X7R1E476M230KB (188µF nominal) remains valid as the
   forward-converter output capacitor; massively oversized relative to ACF Forward minimum
   but electrically correct.

### Rationale

- TI PMP23253 reference design proves TPS23730RMTR + ACF Forward compatibility at 51W,
  functionally equivalent to the CTL 60W requirement.
- TDK B82806D0060A120 is the only evaluated part meeting all requirements: 60W, 12V,
  12-pin SMT, available via major distributors including JLCPCB.
- ACF Forward topology simplifies core-reset compared to flyback and eliminates the need
  for a high-magnetising-inductance gapped core.
- 33µH L1 selected for ≤30% peak-to-peak current ripple at all operating points; 200V-rated
  Q1/Q2 provides >84% Vds headroom at worst-case ACF Forward stress (108V).

### Files Changed

- `design/Electronics/Controller/Design_Spec.md`: T1 BOM row updated (POE600F-12L → B82806D0060A120 with supplier PNs).
  C17 BOM row updated (10nF → 22nF TBD). New L1 BOM row added. DR-CTL-18/22/23/24 updated for ACF Forward.
  New DR-CTL-25 (output inductor specification) added. §7.1 section updated throughout. Power table updated. BOM Notes updated.
- `design/Electronics/Consolidated_BOM.md`: CTL T1 row updated (POE600F-12L → B82806D0060A120). New CTL L1 row added (TBD).
- `README.md`: Lines 83 and 99 updated from POE600F-12LD to TDK B82806D0060A120.
- `.copilot/discussions/ctl-t1-poe-transformer-investigation.md`: Status banner updated UNDER EVALUATION → SELECTED. Topology references updated Flyback → Forward. Pending Actions resolved.

---

## DEC-063 — CTL PoE L1 Selection: Yageo PA4343.333NLT (ACF Forward Output Inductor)

| Field | Value |
| :--- | :--- |
| **Decision ID** | DEC-063 |
| **Status** | Confirmed |
| **Date** | 2026-05-09 |
| **Author** | Izzyonstage & Copilot (session e39f3cc4) |
| **Amends** | DEC-062 (L1 "part selection pending" resolved) |

### Context

The ACF Forward topology change (DEC-062) introduced L1 as a new output inductor requirement (DR-CTL-25). Three candidates were evaluated:

- **Würth 74436413300**: Eliminated — oversized body, non-standard 3-pin configuration, and marginal saturation current.
- **Bourns SRP1265A-330M**: Eliminated — carbonyl powder (iron) core. At 200kHz switching frequency, iron-powder cores exhibit
  unacceptable core loss. Hard disqualified by DR-CTL-25 (ferrite only, no iron-powder cores).
- **Yageo PA4343.333NLT**: Only viable option. 33µH ±20%, Isat=11A @30% inductance drop, DCR typ 48mΩ / max 58mΩ, Irms 8A, 13.5×12.5×6.2mm, shielded ferrite SMT, AEC-Q200.

### Decision

**L1 selected: Yageo PA4343.333NLT.** DigiKey: 553-3457-1-ND; Mouser: 673-PA4343.333NLT; JLCPCB: C2453886.
KiCAD footprint downloaded (zip in temp folder, pending library addition at schematic capture stage).

### Rationale

- All three candidates share the same inductance value and nominal Isat figure, but the Würth part has procurement and pin-count drawbacks, and the Bourns part is disqualified on core material grounds.
- Yageo PA4343.333NLT is the only candidate meeting the ferrite core, Isat (≥6A), and form-factor requirements of DR-CTL-25.

### DCR Compliance Note

DR-CTL-25 specifies DCR ≤50mΩ. The Yageo PA4343.333NLT has a typical DCR of 48mΩ (compliant) but a
manufacturer maximum of 58mΩ (non-compliant). This is the best available option at current procurement time;
accepted as a qualified exception. The DR limit is retained at ≤50mΩ and this entry documents the exception.

### Files Changed

- `design/Electronics/Controller/Design_Spec.md`: DR-CTL-25 updated (part selected, DCR exception noted). BOM L1 row updated with MPN and supplier PNs.
- `design/Electronics/Consolidated_BOM.md`: CTL L1 row updated (TBD → PA4343.333NLT with supplier PNs).

---

## DEC-064 — CTL PoE C17 Final Part Selection: Kemet C0805C223K2RACAUTO (22nF 200V X7R 0805)

| Field | Value |
| :--- | :--- |
| **Decision ID** | DEC-064 |
| **Status** | Confirmed |
| **Date** | 2026-05-09 |
| **Author** | Izzyonstage & Copilot (session e39f3cc4) |
| **Amends** | DEC-062 (C17 MPN "update pending" resolved); DR-CTL-18 package and voltage updated |

### Context

DEC-062 updated C17 value from 10nF to 22nF but deferred MPN selection.
Worst-case Vclamp = Vin×D/(1−D) = 36×0.667/0.333 = 72V.
A 100V-rated 22nF X7R MLCC in 0402 package was initially specified in DR-CTL-18; two problems emerged:

1. **Package constraint:** 22nF at 100V+ cannot fit in 0402 — 0603 is the minimum practical package for this voltage/capacitance combination in X7R.
2. **DC bias derating:** At 72V/100V = 72% of rating, X7R capacitance degrades by approximately 25–35%,
   leaving effective capacitance of only 15–18nF — significantly below the 22nF target and approaching the 19.9nF minimum from DR-CTL-18.

A 200V-rated 0805 part resolves both issues: at 72V/200V = 36% of rating, DC bias derating is only ~5%, giving effective capacitance of ~21nF — compliant with DR-CTL-18.

### Decision

**C17 selected: Kemet C0805C223K2RACAUTO** (22nF, 200V, X7R, 0805, ±10%, AEC-Q200). DigiKey: 399-17630-1-ND; Mouser: 80-C0805C223K2RAUTO; JLCPCB: C3843023.

Package and voltage rating in DR-CTL-18 updated from `100V 0402` to `200V 0805`.

The Open Mode (J-series, FO-CAP) variant (C0805J223K2RACAUTO) was considered — it provides fail-open behaviour
as a reliability enhancement — but is not stocked at JLCPCB.
The standard C-series hard-termination part (C0805C223K2RACAUTO) satisfies all electrical requirements;
Open Mode is a desirable reliability enhancement but not an electrical necessity for this application.

### Rationale

- 200V rating eliminates meaningful DC bias derating and ensures the part operates within its characterised range at all PoE operating points.
- 0805 package is a standard JLCPCB machine-placeable size with excellent availability.
- Kemet C-series X7R is a well-characterised commodity MLCC; AEC-Q200 automotive qualification maintained.
- JLCPCB LCSC number C3843023 confirmed as in-stock.

### Files Changed

- `design/Electronics/Controller/Design_Spec.md`: DR-CTL-18 package/voltage updated (100V 0402 → 200V 0805). BOM C17 row updated (TBD → C0805C223K2RACAUTO with supplier PNs and corrected spec).
- `design/Electronics/Consolidated_BOM.md`: CTL C17 row updated (C0402C103K1RACAUTO → C0805C223K2RACAUTO with supplier PNs).

---

## DEC-065 — System-Wide Stackup Code Correction and JLCPCB-Authoritative Impedance Values

| Field | Value |
| :--- | :--- |
| **Decision ID** | DEC-065 |
| **Status** | Confirmed |
| **Date** | 2026-07-13 |
| **Author** | Izzyonstage & Copilot (session e39f3cc4) |
| **Amends** | All prior board Design_Spec.md files referencing stackup codes; DEC-016 (CI trace widths updated); DEC-017 (Extension stackup code corrected) |

### Context

All board Design_Spec.md files, the JLCPCB Manufacturing Specification, and the Global Routing
Specification were written using stackup codes `JLC04161H-7628` (4-layer) and `JLC06161H-2116`
(6-layer). These codes were incorrect interpretations of the JLCPCB stackup naming scheme and did
not correspond to any real JLCPCB stackup offering.

Additionally, all controlled-impedance trace widths across board specs and the GRS were estimated
using IPC-2141A rather than the JLCPCB impedance calculator. IPC-2141A estimates were found to be
significantly inaccurate for these stackups, deviating by −9% to +21% from JLCPCB calculator values.

### Decision

**Correct 4-layer stackup code:** `JLC041621-3313`
**Correct 6-layer stackup code:** `JLC061621-3313`

Code structure: `JLC` + `0N` (layer count) + `16` (1.6mm thickness) + `21` (2oz outer / 1oz inner) + `-3313` (primary prepreg type).

**JLCPCB-authoritative controlled-impedance trace widths (non-coplanar):**

| Target | Type | JLC041621-3313 (4L) | JLC061621-3313 (6L) | Spacing |
| :--- | :--- | :--- | :--- | :--- |
| 50Ω SE | Microstrip (L1 outer) | 0.1425 mm / 5.61 mil | 0.1425 mm / 5.61 mil | — |
| 50Ω SE | Stripline (inner) | 0.1478 mm / 5.82 mil | 0.1387 mm / 5.46 mil | — |
| 90Ω diff | Diff microstrip (L1 outer) | 0.1468 mm / 5.78 mil | 0.1468 mm / 5.78 mil | 0.2032 mm / 8.00 mil |
| 100Ω diff | Diff stripline (inner) | 0.1128 mm / 4.44 mil | 0.1123 mm / 4.42 mil | 0.2032 mm / 8.00 mil |

**IPC-2141A accuracy finding:**

| Estimate | IPC value | JLCPCB value | Error |
| :--- | :--- | :--- | :--- |
| Outer 50Ω microstrip | ~0.130 mm | 0.1425 mm | −9% (IPC too low) |
| Inner 50Ω stripline (4L) | ~0.167 mm | 0.1478 mm | +13% (IPC too high) |
| Inner 50Ω stripline (6L) | ~0.167 mm | 0.1387 mm | +21% (IPC too high) |

IPC-2141A shall not be used for CI trace width calculation in this design. All CI trace widths must
use the JLCPCB impedance calculator for the assigned stackup code.

**Physical stackup — JLC041621-3313 (4-layer):**

- L1/L4: 2oz outer copper = 0.070 mm; Prepreg: 3313 RC57% = 0.092 mm (h = 0.092 mm, Eᵣ = 4.2)
- L2/L3: 1oz inner copper = 0.030 mm; Core (1/1oz without copper) ≈ 1.231 mm
- Total ≈ 1.6 mm ✓

**Physical stackup — JLC061621-3313 (6-layer):**

- L1/L6: 2oz outer copper = 0.070 mm; Outer prepreg: 3313 RC57% = 0.092 mm
- L2–L5: 1oz inner copper = 0.030 mm each
- Core L2–L3 and L4–L5: 0.450 mm each; Mid prepreg: 2× 2116 RC54% = 0.109 mm each
- Total ≈ 1.6 mm ✓

**JTAG Module inverted stackup note (DEC-016):** JM uses L1=GND, L2=signals, L3=power, L4=GND
(intentionally inverted per DEC-016). JM CI trace width uses the 4-layer inner stripline value
(0.1478 mm), not the outer microstrip value.

**Controlled impedance service requirement:**

- Controller Board: CI service **required** — USB 3.0 SS, USB 2.0, HDMI, and Ethernet BI_D diff pairs on inner signal layers require TDR-verified trace widths.
- Power Module: CI service **not required** — power-dominated board; no high-speed differential pairs. 6-layer layer count was already correct; only the stackup code was wrong.

### Rationale

- JLCPCB impedance calculator results are authoritative for the fab process and supersede any
  IPC-formula estimates for this design.
- Correcting the stackup codes ensures future ordering and fab review match what is actually
  specified; incorrect codes would cause JLCPCB to use a different prepreg, invalidating all CI
  trace widths.
- The Rotor, Stator, Extension, Reflector, Encoder, JTAG Module, Actuation Module, and USM are
  all 4-layer 2oz designs; the Controller and Power Module are 6-layer 2oz designs.

### Files Changed

- `design/Electronics/Rotor/Design_Spec.md`: DR-ROT-01, §3.3 physical params (h/t/Eᵣ corrected), §4 stackup code
- `design/Electronics/Stator/Design_Spec.md`: Line 14 stackup code, DR-STA-01, §7 stackup code; bug fix §7 "0.5oz inner" → "1oz inner"
- `design/Electronics/Extension/Design_Spec.md`: DR-EXT stackup code, §4 trace width → 0.1425 mm
- `design/Electronics/Reflector/Design_Spec.md`: DR-REF-01, §2 heading, §6 stackup code
- `design/Electronics/Encoder/Design_Spec.md`: DR-ENC-01, §9 stackup code, §5 trace width → 0.1425 mm
- `design/Electronics/JTAG_Module/Design_Spec.md`: §5 stackup code, §6 trace width → 0.1478 mm (inner stripline)
- `design/Electronics/Actuation_Module/Design_Spec.md`: DR-AM-01 stackup code
- `design/Electronics/User_Settings_Module/Design_Spec.md`: overview, DR-USM-01, §8 stackup code; copper weight description corrected
- `design/Electronics/Power_Module/Design_Spec.md`: DR-PM-13 stackup code, §1 stackup text (CI not required clarified)
- `design/Electronics/Controller/Design_Spec.md`: Overview, DR-CTL-01, §9.1–§9.4 (full rewrite: layer assignments, physical stackup, authoritative trace widths, via design rules)
- `design/Production/JLCPCB_Manufacturing.md`: Full §1 rewrite (naming convention added, §1.0–§1.3; §4 cross-refs corrected)
- `design/Standards/Global_Routing_Spec.md`: §1 CI exception updated to per-stackup table reference; GRS trace width table Signal/CI row updated

---

## DEC-066 — GRS Canonical PCB Stackup Authority (Consolidation)

| Field | Value |
| :--- | :--- |
| **Decision ID** | DEC-066 |
| **Status** | Confirmed |
| **Date** | 2026-05-11 |
| **Author** | Izzyonstage & Copilot |
| **Amends** | DEC-065 (stackup authority consolidated into GRS §2.3); DEC-016 (inverted stackup extended to Actuation Module) |

### Context

Following the stackup code correction in DEC-065, the JLCPCB identifiers and layer assignments were
still duplicated across all 10 board Design_Spec.md files. Each board contained its own stackup
section with the code, layer assignment table, and rationale — multiple sources of truth that would
need to be kept in sync independently for any future change.

Additionally, DEC-065 documented the JTAG Module inverted stackup note but the Actuation Module —
which also mounts upside-down on the carrier board — was missing an equivalent inverted stackup note.

### Decision

Stackup definitions are consolidated into the Global Routing Specification as new section
**§2.3 PCB Stackup Definitions**, with three named subsections:

- **§2.3.1** — Standard 4-layer (JLC041621-3313): Rotor (A+B), Stator, Extension, Reflector, Encoder, USM
- **§2.3.2** — Inverted 4-layer (JLC041621-3313): JTAG Module, Actuation Module (upside-down mounting; DEC-016)
- **§2.3.3** — Six-layer (JLC061621-3313): Controller Board, Power Module (board-specific layer signal assignments remain in respective board specs)

`JLCPCB_Manufacturing.md §1` remains the physical authority (prepreg thicknesses, CI trace widths).
GRS §2.3 is the logical layer assignment authority.

All 10 board Design_Spec.md stackup sections are simplified to a single GRS §2.3.x reference.
Two stale DR table stackup codes — JM DR-JM-01 and EXT DR-EXT-01 still showing old `JLC04161H-7628`
(missed in DEC-065 workstream) — are corrected as part of this work.

### Rationale

A single source of truth in the GRS eliminates duplication and ensures future stackup or layer
assignment changes propagate from one location only. Board specs retain only board-specific
operational content (CI routing rules, layer signal assignments for CTL §9.2).

### Files Changed

- `design/Standards/Global_Routing_Spec.md`: New §2.3 PCB Stackup Definitions (three subsections)
- `design/Production/JLCPCB_Manufacturing.md`: §1.1 and §1.2 design rule cross-refs updated to GRS §2.3
- `design/Electronics/JTAG_Module/Design_Spec.md`: DR-JM-01 stale code corrected; §5 simplified to GRS §2.3.2 reference
- `design/Electronics/Actuation_Module/Design_Spec.md`: DR-AM-01 and DR-AM-09 simplified; inverted stackup blockquote removed; content moved to GRS §2.3.2
- `design/Electronics/Extension/Design_Spec.md`: DR-EXT-01 stale code corrected; §4 simplified to GRS §2.3.1 reference
- `design/Electronics/Controller/Design_Spec.md`: §9.2 physical stackup table removed
  (duplicate of JLCPCB_Manufacturing.md §1.2); GRS §2.3.3 reference added; layer signal assignment table and CI routing table retained
- `design/Electronics/Power_Module/Design_Spec.md`: §1 PCB Architecture and DR-PM-13 updated with GRS §2.3.3 reference
- `design/Electronics/Rotor/Design_Spec.md`: DR-ROT-01 and §4 simplified to GRS §2.3.1 reference
- `design/Electronics/Stator/Design_Spec.md`: DR-STA-01 and §7 simplified to GRS §2.3.1 reference
- `design/Electronics/Reflector/Design_Spec.md`: DR-REF-01 and §6 simplified to GRS §2.3.1 reference
- `design/Electronics/Encoder/Design_Spec.md`: DR-ENC-01 and §9 simplified to GRS §2.3.1 reference
- `design/Electronics/User_Settings_Module/Design_Spec.md`: DR-USM-01 and §8 simplified to GRS §2.3.1 reference
