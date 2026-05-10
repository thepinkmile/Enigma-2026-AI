# Molex 48406-0003 — Mechanical Drawing Reference

## Source Reference

- Source PDF: [Molex-48406-0003-drawing.pdf](Molex-48406-0003-drawing.pdf)
- Source path: `design\Datasheets\Molex-48406-0003-drawing.pdf`
- Generated markdown: `Molex-48406-0003-drawing.md`
- Drawing number: SD-48406-001, document part 001, revision B1
- Release date: 2021-07-05
- Extraction method: pdfplumber text extraction + manual decode of rotated dimension text
- Related datasheet markdown: [Molex-48406-0003-datasheet.md](Molex-48406-0003-datasheet.md)

> **Extraction note:** Engineering drawings print many dimension labels at 90° rotation.
> The PDF extractor reads these right-to-left, producing reversed digit strings. Where a
> reversed reading produces a value consistent with another known dimension (e.g., the
> part description or datasheet), it is decoded and marked *(decoded)*. Values that cannot
> be unambiguously decoded are flagged *(verify from PDF)*.

---

## 1. Part Identification

| Field | Value |
|---|---|
| Molex part number | 48406-0003 / 484060003 |
| Series | 48406 |
| Drawing | SD-48406-001 rev B1 |
| Product spec | PS-48406-001 |
| Package spec | PK-48406-001 |
| Test summary | TS-48406-001 |
| EC number | 667388 |
| PCN | 508521 (obsoleted prior part numbers) |
| Status | Active |
| Description | USB 3.0 A-type, through-hole, double-stack, right-angle, contact height 4.13 mm |

---

## 2. Pin Assignment Table

18 signal pins total (9 per port). Port 1 = pins 1–9; Port 2 = pins 10–18.

| Pin(s) | Signal Name | Type | Description |
|---|---|---|---|
| 1, 10 | VBUS | Power | Bus power |
| 2, 11 | D− | USB 2.0 signal | USB 2.0 differential pair, negative |
| 3, 12 | D+ | USB 2.0 signal | USB 2.0 differential pair, positive |
| 4, 13 | GND | Power return | Ground for power return |
| 5, 14 | StdA_SSRX− | USB 3.0 SuperSpeed | SuperSpeed receiver differential pair, negative |
| 6, 15 | StdA_SSRX+ | USB 3.0 SuperSpeed | SuperSpeed receiver differential pair, positive |
| 7, 16 | GND_DRAIN | Signal return | Ground for signal return (drain wire) |
| 8, 17 | StdA_SSTX− | USB 3.0 SuperSpeed | SuperSpeed transmitter differential pair, negative |
| 9, 18 | StdA_SSTX+ | USB 3.0 SuperSpeed | SuperSpeed transmitter differential pair, positive |
| Shell | Shield | Mechanical | Connector metal shell to chassis/PCB ground |

**Pin numbering layout (viewed from PCB component side, top port = Port 1):**

```
Port 1 (top):    1   2   3   4   5   6   7   8   9
Port 2 (bottom): 10  11  12  13  14  15  16  17  18
```

---

## 3. PCB Drill / Through-Hole Layout

Taken directly from the "RECOMMEND P.C.B LAYOUT" section of the drawing.

| Feature | Quantity | Diameter | Notes |
|---|---|---|---|
| Pin through-holes | 18 | ⌀ 0.70 mm | Signal and power pins |
| Mounting / locator holes | 2 | ⌀ 2.30 mm | PCB polarisation and mechanical retention |
| PCB thickness (specified) | — | 1.2 mm | Drawing specifies 1.2 mm; see §7 for 1.6 mm note |
| PCB layout tolerance | — | ±0.05 mm | Global tolerance on PCB layout dimensions |

---

## 4. Key Dimensions

All dimensions in mm unless noted. Dimensions marked *(decoded)* were extracted from rotated
text in the drawing and decoded by digit-reversal, cross-checked against the part datasheet.
Dimensions marked *(verify from PDF)* could not be decoded unambiguously and must be confirmed
by viewing the drawing visually.

### 4.1 Overall Connector Envelope

| Dimension | Value (mm) | Tolerance | Notes |
|---|---|---|---|
| Overall width (horizontal) | 17.46 | ±0.25 | Directly readable from drawing |
| Overall height | 14.50 | ±0.25 | *(decoded from "52.0±05.41")* |
| Body depth (PCB face to front) | 18.70 | ±0.25 | *(decoded from "52.0±07.81")* |
| Shell height | 13.80 | ±0.20 | *(decoded from "02.0±08.31")* |

### 4.2 PCB Footprint / Pin Layout Dimensions

| Dimension | Value (mm) | Tolerance | Notes |
|---|---|---|---|
| Pin row span (horizontal) | 15.60 | ±0.35 | PCB footprint |
| Pin row span (horizontal) | 15.50 | ±0.10 | *(decoded from "51.0±05.51")* — second reference |
| Mounting hole centre-to-centre | 11.10 | ±0.10 | Horizontal separation of the two ⌀2.30 holes |
| Mounting hole to pin edge | 9.44 | ±0.30 | |
| Pin offset A | 5.68 | ±0.20 | |
| Pin offset B | 5.68 | — | Nominal |
| Mounting hole to board edge | 12.50 | ±0.10 | |
| Board edge to connector face | 15.60 | ±0.25 | *(decoded from "52.0±06.51")* |

### 4.3 Vertical / Height Dimensions

| Dimension | Value (mm) | Tolerance | Notes |
|---|---|---|---|
| Contact height (above PCB) | 4.13 | — | From part description; *(decoded confirmation: "31.4" reversed)* |
| PC tail length (below PCB) | 2.67 | ±0.30 | From datasheet; *(decoded confirmation: "03.0±76.2" reversed)* |
| Dimension C | 5.12 | ±0.10 | *(decoded from "01.0±21.5")* — probable vertical offset |
| Dimension D | 1.84 | ±0.05 | *(decoded from "50.0±48.1")* — probable small vertical offset |
| Dimension E | 13.14 | — | *(decoded from "41.31")* — probable shell/body height |

### 4.4 Pitch / Spacing Dimensions

| Feature | Value (mm) |
|---|---|
| Pin pitch — USB 2.0 contacts | 2.50 |
| Pin pitch — USB 3.0 contacts | 2.00 |
| Port pitch (row-to-row) | 6.70 |
| Sub-spacing A | 5.20 |
| Sub-spacing B | 3.50 |
| Sub-spacing C | 2.00 |
| Sub-spacing D | 1.00 |
| Sub-spacing E | 4.00 |
| Sub-spacing F | 7.00 |
| Sub-spacing G | 8.00 |

---

## 5. Materials

| Component | Material | Additional |
|---|---|---|
| Housing | Thermoplastic, glass-fibre filled | Halogen-free, UL94-HB, colour: Blue |
| Cover | Thermoplastic, glass-fibre filled | Halogen-free, UL94-HB, colour: Blue |
| USB 2.0 contacts (short & long pin) | Copper alloy | — |
| USB 3.0 contacts (short & long pin) | Copper alloy | — |
| Main shell | Stainless steel | — |
| Inner clip shell | Stainless steel | — |
| Back shell | Stainless steel | — |

---

## 6. Finish / Plating

| Surface | Finish | Thickness | Notes |
|---|---|---|---|
| Contact mating area | Selective gold (Au) | **15 μin (0.38 μm)** | 48406-0003 specification |
| Solder tail area | Selective matte tin (Sn) alloy | 120 μin minimum | — |
| Contact nickel underplate | Nickel (Ni) | 80 μin minimum | — |
| Main shell | Nickel (Ni) | 30 μin minimum | — |
| Back shell | Cleaned | — | — |

**Part number vs. plating thickness:**

| Molex P/N | Gold plating |
|---|---|
| 48406-0001 | 30 μin Au |
| **48406-0003** | **15 μin Au** |

---

## 7. General Tolerances

Unless otherwise specified on the drawing:

| Places | Tolerance |
|---|---|
| Angular | ±3.0° |
| 2 decimal places | ±0.20 mm |
| 1 decimal place | ±0.25 mm |

Projection: First angle.

---

## 8. Referenced Documents

| Document | Number |
|---|---|
| Product specification | PS-48406-001 |
| Package specification | PK-48406-001 |
| Test summary | TS-48406-001 |
| Customer drawing | SD-48406-001 rev B1 |

---

## 9. Design Notes for Enigma-NG CTL Board

### PCB thickness vs. tail length

The drawing specifies a 1.2 mm PCB. The CTL board is a 6-layer design with a finished
thickness of approximately 1.6 mm (JLC061621-3313 stackup).

| Value | Dimension |
|---|---|
| PC tail length (nominal) | 2.67 mm |
| PC tail length (minimum, −0.30) | 2.37 mm |
| CTL board thickness | ~1.60 mm |
| Tail protrusion below board (nominal) | 2.67 − 1.60 = **1.07 mm** |
| Tail protrusion below board (minimum) | 2.37 − 1.60 = **0.77 mm** |

IPC-A-610 minimum THT protrusion = 0.50 mm. Both nominal and minimum are above this
threshold; wave solder or selective solder is feasible on the 1.6 mm CTL board. ✅

### Mounting holes

The two ⌀2.30 mm mounting holes provide polarisation and mechanical retention. On a 6-layer
board these pass through all layers and must be kept clear of any inner-layer routing (no CI
signal routing within ≥0.5 mm of mounting hole edge).

### Signal integrity context

- Pin-hole diameter ⌀0.70 mm: drill the PCB to at least ⌀0.70 mm (finished). Typical annular
  ring = pad diameter − drill = 1.0 mm − 0.70 mm = 0.30 mm each side (to be confirmed at
  layout against JLCPCB minimum annular ring rule).
- For CI signals (D+/D−, SSRX±, SSTX±), route from the THT pad down to L2 via a standard
  through via. Anti-pad (clearance in L1 GND pour) around each via barrel prevents capacitive
  loading. Keep differential pair vias symmetrically placed.
- ESD TVS devices must be placed on the line side (between the connector and any isolation
  transformer) for PoE++ compliance.
