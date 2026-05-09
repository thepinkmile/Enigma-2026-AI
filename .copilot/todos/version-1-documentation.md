# version-1-documentation

## Goal

Ensure all version 1 design documentation is complete and up-to-date, with all
Mermaid diagrams authored and included in the relevant design specs. This todo
gates the formal testing phase — no compliance, EMC, environmental, or security
testing should begin until documentation is verified complete.

## Scope

All of the following diagram todos must be **done** before this todo is closed:

- `board-interconnect-diagram` — boards overview system component diagram
- `system-config-variants-diagrams` — system config and rotor-stack variant diagrams
- `ctl-component-diagram` — Controller Board circuit component diagram
- `pm-component-diagram` — Power Module circuit component diagram
- `sta-component-diagram` — Stator circuit component diagram
- `rotor-component-diagram` — Rotor Board circuit component diagram
- `ext-component-diagram` — Extension Board circuit component diagram
- `ref-component-diagram` — Reflector circuit component diagram
- `enc-component-diagram` — Encoder Module circuit component diagram
- `jm-component-diagram` — JTAG Module circuit component diagram
- `usm-component-diagram` — User Settings Module circuit component diagram
- `am-component-diagram` — Actuation Module circuit component diagram

## Acceptance Criteria

- All diagrams listed above are authored in Mermaid `block-beta` or `flowchart` format
- Each diagram appears in the first descriptive section of its respective Design Spec
- No ASCII-art placeholder block diagrams remain in any v1 design spec
- All design specs have been through at least `review-pass-10` and the interim reviews

## Dependencies

All diagram todos listed above must be `done`.

## Blockers

None currently.
