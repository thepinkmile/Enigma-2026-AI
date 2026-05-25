# Document Rules

## Header Fields

Design document headers contain `Status`, `Version`, `Author`, `Last Updated`,
`Associated Hardware Revision`, and similar fields.

- **`Last Updated`** — **ALWAYS update** to the current date on any content change. Mandatory.
- **`Version`** — **NEVER update**. Version bumps are user-only. Current baseline: `v.0.1.0`.
- **All other fields** — **NEVER update**. User responsibility only.

## Design Document Content

- Design specs contain **current design only**. No superseded values, prior rationale, correction
  notes, or historical detail of any kind.
- History belongs exclusively in `.copilot/checkpoints/` and `design/Design_Log/` (per-DEC files).
- Do not change a component MPN without a corresponding local datasheet review in `design/Datasheets/`.
- Do not raise package-family or footprint-size differences as blocking issues until the user
  confirms schematic capture and layout have started.
- Connector and mechanical-drawing datasheet markdowns can remain lightweight — full detail can wait
  until KiCAD library generation or mechanical modelling phases.
