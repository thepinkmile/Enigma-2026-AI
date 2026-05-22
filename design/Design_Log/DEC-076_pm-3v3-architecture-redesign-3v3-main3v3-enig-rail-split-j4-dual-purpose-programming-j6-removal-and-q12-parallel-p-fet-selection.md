## DEC-076 - PM 3V3 Architecture Redesign: 3V3_MAIN/3V3_ENIG Rail Split, J4 Dual-Purpose Programming, J6 Removal, and Q12 Parallel P-FET Selection

**Date:** 2026-05-16
**Status:** Accepted
**Author:** Izzyonstage & GitHub Copilot
**Amends:** DEC-075 (supersedes J6 design; I2Ct pull-up reference changed from LDO_3V3 to 3V3_MAIN; adds parallel Q12 gate-switch sub-circuit)

### Context

Following DEC-075, a chicken-and-egg boot dependency was identified in the Power Module 3V3 architecture:

- U4 (TPS25751) must read its PD profile from U18 (M24512 EEPROM) at power-on to present the correct CC power contract to the CM5.
- U4 and U18 are powered from 3V3_ENIG.
- 3V3_ENIG was previously controlled by ROTOR_EN_N (CM5 GPIO, active-LOW), meaning it is only active after the CM5 has fully booted.
- The CM5 cannot boot fully without the correct PD power contract from U4.
- This creates an unresolvable circular dependency: CM5 needs U4 active → U4 needs 3V3_ENIG → 3V3_ENIG needs CM5 to assert ROTOR_EN_N.

Additionally, the DEC-075 J6 I2Ct programming header pulled up I2Ct SCL/SDA to LDO_3V3, which is gated by the same ROTOR_EN_N signal. Programming the TPS25751 EEPROM therefore
required a fully powered, CM5-active system - impractical for factory initial programming and field service.

### Decision

A four-part redesign resolves both issues.

#### 1. 3V3 Rail Split: 3V3_MAIN (always-on) and 3V3_ENIG (CM5-gated)

The U7 TPS75733 LDO output is renamed **3V3_MAIN**. It becomes active as soon as PWR_GD fires (eFuse protection active, 5V_MAIN stable), independent of CM5 boot state. U4 (TPS25751)
and U18 (M24512 EEPROM) are powered from 3V3_MAIN. R47/R48 (I2Cc pull-ups) and R49/R50 (I2Ct pull-ups, repositioned per §2 below) reference 3V3_MAIN instead of LDO_3V3.

**U7 enable path redesign:** Previously ROTOR_EN_N drove U7 EN directly (both active-LOW - compatible). ROTOR_EN_N must no longer gate U7. Instead, Q11 (BSS138 N-FET, existing BOM part
used for Q4-Q10) is inserted: gate = PWR_GD (active-HIGH), drain = U7 EN. PWR_GD HIGH → Q11 ON → U7 EN pulled LOW → LDO active. R8 (10 kΩ pull-up to 5V_MAIN) remains on U7 EN as a
default-disable pull-up.

**3V3_ENIG** remains the output rail to external boards (J1 3V3_ENIG pins) and remains CM5-controlled via ROTOR_EN_N, but is now switched by Q12 (parallel P-FET pair, see §4 below)
rather than being the LDO output directly. External boards see no architectural change.

#### 2. J6 Removal and I2Ct Pull-up Repositioning

The DEC-075 J6 I2Ct debug header (Würth 61300511121) is **removed entirely**. TPS25751 EEPROM programming is now handled through J4 (see §3). R49/R50 (4.7 kΩ I2Ct SCL/SDA pull-ups,
previously on J6) are repositioned to the I2Ct bus and reference 3V3_MAIN. DR-PM-21 (dedicated J6 programming header requirement) is removed.

#### 3. J4 Dual-Purpose SmartBattery / Programming Connector with PROG_EN_N

J4 is upgraded from 5-pin to **6-pin Molex Micro-Fit 3.0** (0436500519 → 0436500619). Pin 6 carries **PROG_EN_N** - an active-LOW programming enable signal with a 10 kΩ pull-up to 3V3_MAIN.

- **Normal SmartBattery operation:** Pin 6 = NC on a standard battery cable → pull-up holds PROG_EN_N HIGH → U19 MUX routes J4 SMBUS pins to I2C-1 (SmartBattery). System operates normally.
- **EEPROM programming mode:** Programming cable shorts pin 6 to GND → PROG_EN_N LOW → U19 MUX routes J4 SMBUS pins to I2Ct (TPS25751 programming port). External I2C programmer
  connects via J4. Programming cable also supplies power via the existing VIN pin, enabling standalone programming without a running system.

PROG_EN_N active-LOW with pull-up is fail-safe: NC on a standard cable = programming disabled. A standard SmartBattery with NC on pin 6 is completely unaffected.

Note: MPN 0436500619 is a temporary replacement pending resolution of the battery connector todo (awaiting supplier responses). The 6-pin upgrade is architecturally binding; the final MPN
may change when that decision is resolved.

#### 4. U19 Dual SPDT I2C MUX

U19 (Nexperia 74LVC2G3157DP-Q10J, dual 2:1 SPDT I2C MUX, TSSOP-10, AEC-Q100) routes the J4 SMBUS pins based on PROG_EN_N. The 74LVC2G3157 has independent 1S/2S select pins; both are
tied together and driven by PROG_EN_N for simultaneous SCL/SDA switching. Ron = 7.8 Ω at 3.3V supply (acceptable for I2C).

- **nS = HIGH (normal):** J4 SMBUS → I2C-1 (SmartBattery)
- **nS = LOW (programming):** J4 SMBUS → I2Ct (TPS25751 I2Ct port)

### Q12 Component Selection - P-FET Gate Switch for 3V3_ENIG

Q12 gates 3V3_MAIN to the J1 3V3_ENIG output pins. Gate = ROTOR_EN_N (CM5 GPIO, active-LOW). ROTOR_EN_N LOW → Q12 ON → 3V3_ENIG present to external boards.

**Binding constraint:** DR-PM-03 specifies 3V3_ENIG at 3.3V ±3%, max 3.0A. At full 3A load with VGS = −3.3V (gate driven to 0V, source at 3.3V), maximum allowed RDS(on) = 33mΩ (99mV drop limit).

**Key challenge:** Most logic-level P-FETs are characterised at VGS = −4.5V and −10V, not at −3.3V. Achieving ≤33mΩ at −3.3V gate drive with a single FET proved unachievable with every candidate evaluated.

#### Single-FET Candidates Evaluated

| Candidate | Package | VGS(th) max | VGS max | RDS(on) max @ −4.5V | RDS(on) est. @ −3.3V | TJ @ 3A (std) | Outcome |
| --- | --- | --- | --- | --- | --- | --- | --- |
| Vishay SI2323CDS-T1-BE3 | SOT-23 | −1.0V | ±8V ⚠️ | 39mΩ | ~48mΩ | 145°C ⚠️ | Rejected - TJ at 150°C limit; VGS max only ±8V |
| Vishay SQ3419CEV-T1_GE3 | TSOP-6 | −2.5V | ±20V | **92mΩ** | >>92mΩ | >>175°C | Rejected - RDS(on) disqualifying |
| Nexperia PMV28XPEAR | SOT-23 | −1.3V | ±12V | 38mΩ | ~53mΩ | **189°C ❌** | Rejected - TJ exceeds 175°C max at std footprint; viable only with 6cm² drain copper pour but ID at 100°C = 3.2A (below 3.5A min requirement) |
| Diodes Inc DMP3028LK3Q-13 | TO-252 | −2.4V | ±20V | 38mΩ | ~47mΩ | 107°C ✓ | Good thermal but estimated drop ~141mV at 3A worst case - fails DR-PM-03 ±3% as single device |

All single-FET candidates fail DR-PM-03 ±3% at maximum 3A load when driven from a −3.3V gate.

#### Parallel Dual-FET Topology

Two identical P-FETs wired in parallel (gates tied → ROTOR_EN_N; sources tied → 3V3_MAIN; drains tied → 3V3_ENIG) halve the effective RDS(on) and current per device. P-channel MOSFETs
have a positive temperature coefficient for RDS(on), providing inherently self-balancing current sharing without additional components.

- Effective RDS(on) = RDS(on)/2 → ~23mΩ estimated
- Voltage drop at 3A = ~70mV - within DR-PM-03 ±3% budget (99mV)
- Current per FET = 1.5A → power per FET ≈ (1.5)² × 47mΩ = 106mW
- TJ per FET (std footprint, 77°C/W) = 70 + 8°C = 78°C - 72°C margin to TJ max 150°C

#### Parallel-FET Candidates Compared

| Option | VGS(th) max | RDS(on) eff. est. @ −3.3V | Drop @ 3A | TJ per FET (std) | AEC-Q10x | Verdict |
| --- | --- | --- | --- | --- | --- | --- |
| 2× SI2323CDS-T1-BE3 | −1.0V | ~24mΩ | ~72mV ✓ | 88°C | Q101 | Pass - VGS ±8V limit minor concern |
| **2× DMP3028LK3Q-13** | **−2.4V** | **~23mΩ** | **~70mV ✓** | **78°C** | **Q101 + PPAP** | **Selected** |
| 2× PMV28XPEAR | −1.3V | ~27mΩ | ~81mV ✓ | 88°C | Q101 | Pass - slightly higher drop; TO-252 preferred |

#### Selected: 2× Diodes Inc DMP3028LK3Q-13 (Q12a + Q12b)

DMP3028LK3Q-13 wins on lowest effective RDS(on) (~23mΩ), lowest estimated voltage drop (~70mV, 29% inside DR-PM-03 budget), lowest TJ per device (78°C, 72°C margin), and TO-252 package
with 45°C/W thermal characteristic when combined with a 1 inch square copper pour (per datasheet Note 7; pour style to match established supercapacitor treatment on the Power Module).
AEC-Q101 qualified with PPAP support.

### Rationale

The 3V3_MAIN/3V3_ENIG split resolves the boot chicken-and-egg dependency: U4 and U18 are powered as soon as 5V_MAIN is stable, independent of CM5 state. External boards continue to see
3V3_ENIG only when the CM5 asserts readiness via ROTOR_EN_N - no behaviour change visible to downstream boards. The J4 dual-purpose scheme eliminates J6 entirely, reducing connector count
and BOM complexity. The parallel P-FET topology achieves the DR-PM-03 ±3% specification that no single reviewed logic-level P-FET could meet at −3.3V gate drive.

### Affected Files

- `design/Electronics/Power_Module/Design_Spec.md` - U7 EN path redesign, 3V3_MAIN rename, Q11 (BSS138 inverter, existing BOM part), Q12a/Q12b (DMP3028LK3Q-13 × 2),
  U19 (74LVC2G3157DP-Q100J), J4 upgrade (0436500519 → 0436500619, 5-pin → 6-pin), J6 removed, DR-PM-21 removed, new DRs for J4 dual-purpose and 3V3_MAIN gating, BOM updates,
  R47-R50 pull reference changed from LDO_3V3 to 3V3_MAIN, PROG_EN_N pull-up resistor added
- `design/Guides/Maintenance_Guide.md` - §5 rewrite: J6 pinout procedure → J4 dual-purpose programming cable procedure with PROG_EN_N instructions
- `design/Datasheets/DiodesInc-DMP3028LK3Q-datasheet.md` - Q12a/Q12b selected part datasheet
- `design/Datasheets/Nexperia-74LVC2G3157_Q100-datasheet.md` - U19 selected part datasheet
- Rejected candidate datasheets moved to `.recycle-bin/`: `vishay-si2323cds-datasheet.md`, `Vishay-sq3419cev-datasheet.md`, `Neperia-PMV28XPEA-datasheet.md`
