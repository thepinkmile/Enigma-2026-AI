# Controller Board Layout Visualisations

**Status:** In Review
**Project:** Enigma-NG
**Author:** Izzyonstage & GitHub Copilot
**Version:** v.0.1.0
**Associated Hardware Revision:** Rev A
**Last Updated:** 2026-05-09

---

## 1. Rear Dock Interfaces

The Controller is the fixed motherboard of the enclosure and carries both removable-board docks:

- **J1 / J2 / J3** - three TE 10-position connectors to the Power Module
- **J4 / J5** - two Molex EXTreme Guardian HD hybrid connectors to the Stator

```text
rear edge of Controller

 [ J4 ] [ J5 ]   [ J1 ] [ J2 ] [ J3 ]
  to Stator          to Power Module
```

---

## 2. Controller ↔ Power Module Dock

### 2.1 J1 - Main Regulated Rails

| Allocation | Notes |
| :--- | :--- |
| `3 x 5V_MAIN` | Primary regulated 5V feed from PM to Controller |
| `2 x 3V3_ENIG` | Clean logic rail feed from PM to Controller |
| `5 x GND` | Shared return path |

**Connector family:** TE `1-1674231-1` (Controller receptacle) ↔ `1123684-7` (PM plug), 10 positions,
2.5 mm pitch, 6 A/contact.

**Reference datasheets:** [`TE-1-1674231-1-datasheet.md`](../../Datasheets/TE-1-1674231-1-datasheet.md),
[`TE-1123684-7-datasheet.md`](../../Datasheets/TE-1123684-7-datasheet.md)

### 2.2 J2 - PoE Auxiliary Feed

| Allocation | Notes |
| :--- | :--- |
| `3 x VIN_POE_12V` | Regulated PoE-derived 12V-class auxiliary feed from Controller PoE front-end into PM OR-ing stage |
| `7 x GND` | Shared return path |

### 2.3 J3 - Low-Speed Control / Telemetry

| Signal | Direction | Notes |
| :--- | :--- | :--- |
| `I2C_SDA` | Bidir | Shared PM telemetry and PM-local GPIO-expander bus |
| `I2C_SCL` | Bidir | Shared PM telemetry and PM-local GPIO-expander bus |
| `PM_IO_INT_N` | PM -> CTRL | Active-low interrupt from PM `PCA9534APWR` |
| `PWR_GD` | PM -> CTRL | Direct rail-health telemetry from MCP121T |
| `ROTOR_EN_N` | CTRL -> PM | Direct 3V3_ENIG LDO enable control |
| `PWR_BUT_N` | PM -> CTRL | Direct CM5 PMIC power-button path |
| `LED_PWR_N` | CTRL -> PM | Direct CM5 power-state indication for the SW2 hardware LED logic |
| `3 x GND` | - | Guards / return path |

---

## 3. Controller ↔ Stator Dock

### 3.1 J4 - 5V_MAIN-Biased Hybrid Dock

| Contact group | Allocation |
| :--- | :--- |
| Power blades | `4 x 5V_MAIN`, `1 x GND` |
| Signal field | additional `GND` guards / returns |

### 3.2 J5 - 3V3_ENIG + JTAG / I2C Hybrid Dock

| Contact group | Allocation |
| :--- | :--- |
| Power blades | `4 x 3V3_ENIG`, `1 x GND` |
| Signal field | guarded `TCK`, `TMS`, `TDI`, `TTD_RETURN`, `I2C_SDA`, `I2C_SCL`, remaining signal contacts = `GND` |

**Connector family:** Molex `2195630015` receptacle on Controller ↔ `2195620015` plug on Stator.

**Reference datasheets:** [`Molex-2195630015-datasheet.md`](../../Datasheets/Molex-2195630015-datasheet.md),
[`Molex-2195630015-drawings.md`](../../Datasheets/Molex-2195630015-drawings.md),
[`Molex-2195620015-datasheet.md`](../../Datasheets/Molex-2195620015-datasheet.md),
[`Molex-2195620015-drawings.md`](../../Datasheets/Molex-2195620015-drawings.md),
[`Molex-ExtremeGuardianHD-2141130000-PS-000-specification.md`](../../Datasheets/Molex-ExtremeGuardianHD-2141130000-PS-000-specification.md)

The `J5` logic connector deliberately groups the JTAG cluster and `TTD_RETURN` with the `3V3_ENIG`
feed. The `J4` connector is reserved for 5V delivery and return-current support.

---

## 4. External I/O Placement

```text
right edge of Controller

 [ RJ45 + PoE front-end ]
 [ USB 3.0 stacked Type-A ]
 [ HDMI ]
```

- The Controller owns the **RJ45, Ethernet ESD, magnetics, and PoE PD / ACF front-end**.
  The PoE front-end passes its regulated auxiliary feed into the Power Module over `J2`.
- `J9` and `J10` are internal-only connectors and are not part of the external I/O edge.
  `J9` sits between `J5` and the Power Module mounting area so it can route by ribbon cable into
  the future in-lid touchscreen assembly, while `J10` serves the CM5 active-cooler heatsink fan.

---

## 5. Placement Summary

```text
rear / dock edge
 ________________________________________________________________________
|     [J4] [J5]             [J9]               | (Power Module mounting) |
|                          _________________   | [J1]               [J3] |
|  [ JM DF40 dock ]       |                 |  |          [J2]           |
|                         |      CM5        |  |_________________________|
|                         |     Module      |                            |
|                         | [ Low-Profile ] |                     [RJ45] |
|                         | [    Area     ] |                     [USB3] |
| [ ACTUATION MODULE ]    |_________________|                     [HDMI] |
|________________________________________________________________________|
left side / internal                                            right side
```

The Controller is the only board that must be inserted as the enclosure reference part.
The Power Module and Stator then dock into it as mechanically independent service modules.

For the shared **Actuation Module**, the Controller shall reserve the mounted-module shadow as a
**no-component placement zone** except for J11, MH5-MH8, and the routing / copper needed to reach them.
See **§6** for connector ownership, net-to-net mapping, standoff GND net, and PCB layout dependency.

---

## 6. J11 - Actuation Module Host Dock

> **Connector Definition Owner:** `design/Electronics/Actuation_Module/Design_Spec.md §3.1`.
> This board provides the mating receptacle (J11). Full connector pinout is defined and owned by
> the Actuation Module. Net connections from this board to the mounted AM:
>
> | CTL Net | AM Net |
> | --- | --- |
> | `5V_MAIN` | `5V_MAIN` |
> | `3V3_ENIG` | `3V3_ENIG` |
> | `GND` | `GND` |
> | `ACTUATE_REQUEST_N` | `ACTUATE_REQUEST_N` |
>
> `ACTUATE_REQUEST_N` is sourced from CM5 GPIO 8 as an active-low output pulse.
>
> **⚠ PCB Layout Dependency:** J11 and MH5-MH8 positions cannot be finalised until AM schematic
> capture and PCB layout are complete. MH5-MH8 shall mirror `design/Electronics/Actuation_Module/Design_Spec.md DR-AM-03` and
> connect to `GND`.

- **J11:** Single 20-pin Hirose DF40HC(3.5)-20DS-0.4V(51) AM host socket (stacking height = 3.5mm).
  A silkscreen pin-1 marker is required on both the Controller and AM boards (per
  `design/Standards/Global_Routing_Spec.md §7.1`).
- **MH5-MH8:** Four M2.5x3.5mm SMT standoffs (9774035151R); positions mirror `design/Electronics/Actuation_Module/Design_Spec.md
  DR-AM-03`; pads connected to `GND`; no-component placement zone (except J11, MH5-MH8, and routing).

---

## 7. CM5 Module Carrier (J14, J15, MH13–MH16)

The CM5 Compute Module 5 mounts on the Controller via two Amphenol `10164227-1004A1RLF` carrier
sockets (J14, J15) and four SMT standoffs (MH13–MH16).

### 7.1 J14 and J15 — CM5 Module Carrier Connectors

- **Part:** Amphenol `10164227-1004A1RLF` — CM5 carrier socket, 4.0mm stack height.
- **Placement:** J14 and J15 are placed in the central board region beneath the CM5 module
  footprint. Both connectors must be positioned to align with the CM5 module edge connector
  interface per the Raspberry Pi CM5 mechanical drawing. Trace routing and copper fills are
  permitted in the CM5 shadow area; active or tall components are not (see §7.2 height rule).
- **Stack height:** 4.0mm from Controller PCB surface to the underside of the CM5 module PCB.
- **Cross-ref:** `design/Electronics/Controller/Design_Spec.md §2.3`; BOM J14, J15.

### 7.2 MH13–MH16 — CM5 Carrier Standoffs

- **Part:** Wurth Elektronik `9774040151R` — M2.5×4.0mm SMT standoff; four instances.
- **Function:** Mechanical standoffs that set the 4.0mm stack height for J14/J15 and provide
  rigidity under the CM5 module.
- **GND:** MH13–MH16 pads shall be connected to `GND` — **not** `GND_CHASSIS`. See
  `design/Standards/Global_Routing_Spec.md` for module mounting hole grounding rules.
- **Placement:** Four corners of the CM5 module footprint shadow; exact XY positions TBD at PCB
  layout, must mirror the CM5 module mechanical reference pattern.
- **Component height rule:** Maximum installed component height within the CM5 shadow area is
  2.0mm above the Controller PCB surface. Only low-profile passive components are permitted
  beneath the CM5; active ICs, connectors, test points, and exposed via pads are prohibited.
- **Cross-ref:** `design/Electronics/Controller/Design_Spec.md §2.3`; BOM MH13–MH16.

---

## 8. PoE ACF Front-End Placement (T1, Q1, Q2, L1, C17, C20)

The PoE ACF Forward front-end occupies the right-edge zone of the board, clustered around the
RJ45 magnetics jack and the two PoE ICs (U7 TPS2372-4RGWR, U8 TPS23730RMTR). GbE ESD arrays
U5 and U6 are also in this zone.

### 8.1 Component Summary

| RefDes | Part | Role |
| :--- | :--- | :--- |
| T1 | TDK B82806D0060A120 | ACF Forward PoE PD transformer |
| U7 | TPS2372-4RGWR | PoE PD interface controller |
| U8 | TPS23730RMTR | ACF Forward gate-drive controller |
| Q1 | STD25NF20 | ACF primary switch (GATE_P), DPAK |
| Q2 | STD25NF20 | ACF active clamp switch (GATE_C), DPAK |
| L1 | PA4343.333NLT | 33µH ACF forward output inductor |
| C17 | C0805C223K2RACAUTO | 22nF 200V 0805 ACF primary-side clamp capacitor (Cclamp) |
| C20 (×4) | CGA9N3X7R1E476M230KB | 47µF 25V 2220 ACF output filter capacitors (4× in parallel) |

### 8.2 Placement Notes

- **Zone:** Right edge of the Controller PCB directly adjacent to the RJ45 magnetics jack. U7
  and U8 shall be placed as close as practical to T1 to minimise the primary-side switching loop
  area.
- **Q1 and Q2 (DPAK):** Both DPAK exposed tabs shall be tied to `GND` with a copper pour and
  via stitching for thermal dissipation. Q1 and Q2 shall be placed on the primary side of T1 to
  keep the primary-side switching loop compact. Gate-drive traces from U8 GATE_P to Q1 and from
  U8 GATE_C to Q2 shall be as short and direct as practical.
- **T1 solder bridge note:** The TDK B82806D0060A120 datasheet permits optional solder bridges
  between pins 1–2 and between pins 7–8 to parallel primary-side winding pairs for lower
  resistance. Confirm at schematic capture whether the ACF Forward circuit uses those pins
  separately before deciding whether to apply the solder bridges in the PCB layout.
- **L1 (PA4343.333NLT):** 13.5mm × 12.5mm × 6.2mm shielded ferrite SMT inductor. Place on
  the secondary side of T1 on the `VIN_POE_12V` output rail, between T1 and C20. Orient the
  winding terminals toward T1 to minimise secondary-side loop length.
- **C17 (0805):** Place in the U8 primary-side active-clamp loop between the clamp switch node
  and GND, within 5mm of U8. 200V rating is required for the primary-side environment.
- **C20 (4× 2220):** Four CGA9N3X7R1E476M230KB in parallel on `VIN_POE_12V` at the LC filter
  output. Arrange in a 2×2 grid on the secondary side of L1 with a common pour to `VIN_POE_12V`.
- **Cross-ref:** `design/Electronics/Controller/Design_Spec.md §7.1`; DR-CTL-18 to DR-CTL-25;
  `design/Electronics/Controller/PoE_Power_Analysis.md`.
