# Enigma-NG — GUI Application Wireframes

This directory contains draw.io wireframe and workflow diagrams for the Enigma-NG Avalonia desktop application.
All wireframes target a **1920 × 1080 landscape** canvas using **Material Design 3 (MD3)** component conventions
and the **"Digital Museum" theme** (Enigma Green #004D40, Slate Grey, Amber #FFB300 accents).

## Files

| File | Description | Renders |
| --- | --- | --- |
| `00-app-navigation-flow.drawio` | Full application navigation flowchart — startup flow, hardware detection, all screens, modal flows, and nav rail transitions | `renders/00-app-navigation-flow.png` |
| `00-app-shell.drawio` | App shell — nav rail collapsed and expanded states, header bar, status bar, content area placeholder | `renders/00-app-shell-collapsed.png`, `renders/00-app-shell-expanded.png` |
| `01-main-dashboard.drawio` | Main Dashboard — virtual Enigma machine panel, live telemetry cards, power source indicators, connection status | `renders/01-main-dashboard.png` |
| `02-hardware-history.drawio` | Hardware History tab — session history list, encryption log table, export controls | `renders/02-hardware-history.png` |
| `03-hardware-configuration.drawio` | Hardware Configuration tab — Historical mode (read-only saved config) and Custom mode with Saved Components drawer | `renders/03-hardware-configuration-historical.png`, `renders/03-hardware-configuration-custom.png` |
| `04-hardware-live-model.drawio` | Hardware Live Model tab — live rotor position display, signal path visualisation, current settings summary | `renders/04-hardware-live-model.png` |
| `05-educational-timeline.drawio` | Educational Timeline tab — scrollable chronological timeline with era bands, event cards, filter bar, and resizable detail pane | `renders/05-timeline-start.png`, `renders/05-timeline-middle.png`, `renders/05-timeline-end.png` |
| `06-educational-map.drawio` | Educational Map tab — map tile placeholder, location pins, detail pane in no-selection and selected states | `renders/06-map-no-selection.png`, `renders/06-map-selected.png` |
| `07-educational-profiles.drawio` | Educational Profiles tab — profile card grid, filter/search bar, inline detail panel | `renders/07-profiles.png` |
| `08-educational-configurations.drawio` | Educational Configurations tab — configuration list with column headers, status chips, filter bar, inline detail panel | `renders/08-configurations.png` |

## Component Conventions

| Component | Style |
| --- | --- |
| Navigation Rail | 80px wide, Enigma Green (#004D40) background; active item Amber (#FFB300) |
| MD3 Card | Rounded rectangle, #FAFAFA fill, #CCCCCC border |
| Primary Button | #004D40 fill, white label, rounded |
| FAB | Amber (#FFB300) fill, rounded |
| Status OK chip | #d5e8d4 / #82b366 |
| Status Warning chip | #fff2cc / #d6b656 |
| Status Error chip | #f8cecc / #b85450 |

## Viewing

Open any `.drawio` file in [draw.io Desktop](https://github.com/jgraph/drawio-desktop/releases) or at
[app.diagrams.net](https://app.diagrams.net). Pre-rendered PNGs are in the `renders/` subdirectory.
