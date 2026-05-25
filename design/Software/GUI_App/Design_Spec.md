# Enigma-NG Software Design: C# GUI Application

**Status:** Draft
**Version:** v.0.1.0
**Associated Hardware Revision:** Rev A
**Last Updated:** 2026-05-27

## 1. Core Framework

* **Version:** .NET 10.0 (C#)
* **UI Library:** Avalonia UI (for hardware-accelerated Skia rendering on Linux/CM5).
* **Architecture:** MVVM (Model-View-ViewModel) for clean separation between hardware I/O and the display.

## 2. Aesthetic (The "Digital Museum" Look)

* **Font:** Authentic "Typewriter" monospaced font for all data readouts.
* **Colour Palette:** "Enigma Green" (#004D40), Slate Grey, and Amber highlights.
* **Bilingual Toggle:** A one-click switch to toggle all UI text between **DEUTSCH** and **ENGLISH**.

## 3. Primary Dashboard Features

* **The Virtual Enigma:** A 3D or high-res 2D representation of the 30-rotor stack.
* **Live Power Telemetry:** Real-time Gauges for Voltage, Current (mA), and Power (W) sourced from the INA219.
  * **Rotor stack monitor:** INA219 at I²C address **0x45** (on Stator board), R_SHUNT = 0.010Ω (10mΩ CSS2H-2512R-R010ELF), calibration register CAL = 0x0400;
    current formula: I = V_shunt / 0.010, range 0-3A, typical 1-2.05A; Current_LSB = 4mA.
  * **Power Module monitor:** INA219 at I²C address **0x40** (on Power Module board), monitors 5V_MAIN rail.
  * See Software/Linux_OS/Power_Management.md §INA219 for full driver code and register setup.
* **Source Indicators:** Dynamic icons for PoE+, USB-C, and Battery (with "Time-to-Empty" countdown).
* **Thermal Monitor:** CPU and eFuse temperature tracking with bilingual "HOT" alerts.
* **The "Daily Key":** Ability to export/import the machine configuration (Rotor order, Ring settings, Plugboard patches) as a "Codebook" PDF or JSON file.

## 4. Cryptographic Visualization

* **Signal Path Trace:** A "light-trail" animation showing the 12-bit signal traveling from the Keyboard, through the Plugboard,
  through the 30 rotors, hitting the Reflector, and returning to the Lampboard.
* **Rotor Configurator:** Drag-and-drop interface to "program" historical wiring (I-VIII) into the CPLDs/FPGAs.

---

## 5. Educational View — Timeline Tab

The Timeline tab displays historical cryptography events grouped into three force-aligned bands (German, Asian/Pacific, Allied) on a horizontally scrollable canvas.

### 5.1 Zoom Control

A **Zoom** control is located in the filter bar at the right-hand side. It provides 7 discrete zoom levels that expand or compress the horizontal time scale:

| Level | px / year | Typical view |
| ------- | ----------- | ---------------------------------------------- |
| 1 (min) | 20 | Full era overview; cards may overlap (user-accepted) |
| 2 | 30 | Compressed |
| 3 | 45 | Slightly compressed |
| **4 (default)** | **60** | **Design reference spacing; comfortable reading** |
| 5 | 90 | Expanded |
| 6 | 180 | Wide spacing; ~3–4 events visible per band |
| 7 (max) | 600 | Very wide; ~1–2 events per band visible at once |

**Behaviour:**

* Zoom anchors on the **horizontal centre-point** of the currently visible range — the point under the centre of the viewport remains fixed as scale changes.
* The **[−]** button is disabled (visually dimmed) when the minimum level is active.
* The **[+]** button is disabled (visually dimmed) when the maximum level is active.
* Zoom state is **per-session only** and resets to level 4 (60 px/yr) on navigation away from the tab.

### 5.2 Filter Bar

The filter bar sits between the tab strip and the timeline content area. It contains:

* MD-style toggle checkboxes for each band: **All**, **German**, **Asian/Pacific**, **Allied**, **Other** — each checkbox uses the corresponding band colour.
* The **Zoom** control (§5.1) on the right side of the filter bar.

### 5.3 Bottom Axis Footer

Two rows appear below the content bands:

1. **Detail date row** — shows the start and end years of the currently visible range.
2. **Overview bar** — full era span (1918–1952) with a green indicator showing the current visible window position.
3. **Scroll thumb** — drag to pan the timeline.

### 5.4 Details Pane and Resize Bar

A **Details Pane** appears on the right side of the content view when a timeline event card is selected. It shows:

* A photo (if available), event title, band, and date range in the header.
* A scrollable body with further descriptive content.
* A vertical scroll bar on the right edge of the pane.

A **12 px resize bar** separates the timeline canvas from the Details Pane. It is always rendered at the highest
z-order so it is never obscured. The user may drag it horizontally to adjust the pane width within the following
bounds:

| Bound | Width (% of full content width) |
| --------- | ------------------------------- |
| Minimum | 25 % |
| Maximum | 50 % |

When no event is selected the Details Pane is hidden and the timeline canvas occupies the full content width.

---

## 6. Educational View — Map Tab

The Map tab displays the geographic locations of historically significant events, using the same colour scheme and pin style as the Timeline tab.

### 6.1 Map Visual Style

The map is presented as a **parchment / rolled-map** artefact:

* **Background:** Cream/parchment (#D4C4A0) land with antiqued ocean (#B8C9D4).
* **Borders:** Outer frame rendered with sketch=1;roughness=3 to simulate torn / rolled paper edges.
* **Graticule:** Faint dotted lines (strokeColor=#8B6914;opacity=30;dashed=1) indicating latitude/longitude.
* **Drop shadow:** Offset 4 px dark rectangle at 60 % opacity beneath the parchment frame.

### 6.2 Geographic Zoom Levels

The map supports 7 discrete zoom levels that scale the rendered geographic area:

| Level | Approximate extent | Typical pins visible |
| ------- | ------------------------------ | -------------------- |
| 1 (min) | World view | All; dense clusters grouped |
| 2 | Continental (Europe + Pacific) | Clusters begin to separate |
| 3 | European + North African theater | Most clusters resolved |
| **4 (default)** | **European theater (28 °N–67 °N, 15 °W–45 °E)** | **All European pins individually** |
| 5 | Regional (e.g. Western Europe) | ~10–15 pins visible |
| 6 | Sub-regional (e.g. Germany + neighbours) | 4–8 pins visible |
| 7 (max) | City-level detail | 1–4 pins visible |

**Behaviour mirrors §5.1:**

* The **[−]** button is disabled when at level 1; the **[+]** button is disabled when at level 7.
* Zoom anchors on the **geographic centre** of the currently visible map region.
* Zoom state resets to level 4 on navigation away from the tab.

### 6.3 Scroll and Pan

The map canvas is larger than the visible viewport. Two scroll bars allow panning:

* **Horizontal scroll bar** — below the parchment frame, same visual style as the timeline overview bar.
* **Vertical scroll bar** — right edge of the parchment frame, same style.

### 6.4 Pin Clustering

When the current zoom level would cause two or more pins to overlap:

* They are replaced by a **single numbered cluster pin** (same diamond shape; colour determined by the dominant band of the contained events).
* The cluster badge shows the count of grouped locations.
* Clicking a cluster pin zooms the map to the next level, centred on that cluster, to resolve it.
* At zoom level 7 all pins are always shown individually; no clustering occurs.

### 6.5 Filter Bar

Identical in layout and style to the Timeline filter bar (§5.2):

* MD-style toggle checkboxes for **All**, **German**, **Asian/Pacific**, **Allied**, **Other** using band colours.
* **Zoom** control on the right side (§6.2).

### 6.6 Location Details Pane

When a map pin is selected a **Details Pane** opens on the right side of the content view (same resize bar behaviour as §5.4). It shows:

* Location name and primary category in the header.
* A **scrollable chronological event list** — one card per event that occurred at that location, ordered by date:
  * Date in amber bold.
  * Event title in white bold.
  * Short description in italic muted text.
* A vertical scroll bar on the right edge of the pane.

When multiple events share the same geographic location they all appear in this single pane; **no duplicate pins are placed at the same map coordinate**.

When no pin is selected the Details Pane is hidden and the map fills the full content width.

### 6.7 Legend

A **Legend** is pinned to the **bottom-left** of the content viewport, **8 px from the left edge and 8 px above the status bar**. It lists all five pin categories with their diamond icons and colour keys:

* German Occupation
* Allied Operations
* Asia / Pacific
* Other / Neutral
* Selected Location (amber highlight)

---

## 7. GUI Implementation Checklist

* [x] Setup Avalonia .NET 10.0 Project Template.
* [ ] Implement I2C Wrapper for INA219 (Telemetry) - address 0x45 (rotor stack), 0x40 (power module); R_SHUNT=0.010Ω (CSS2H 10mΩ); CAL=0x0400; see Power_Management.md for driver code.
  * [ ] Decide if OS systems should be a separate software stack with Rest-API for this app to call, instead of local implementation.
* [ ] Create the "Enigma Path" SVG animation logic.
* [ ] Integrate JTAG programming library for Intel MAX II EPM570T100I5N CPLDs across Encoder (x6), Rotor (x30), and Stator (x1).
* [ ] Design the Bilingual "Typewriter" UI Theme.
* [ ] Finalize the "Time-to-Empty" Battery algorithm.
