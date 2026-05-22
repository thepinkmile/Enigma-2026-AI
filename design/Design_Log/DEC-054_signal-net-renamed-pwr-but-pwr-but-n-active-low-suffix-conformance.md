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
  "pulse CM5 PWR_BUT LOW" - active-LOW signal.
- The `_N` suffix unambiguously documents the active polarity for future reviewers.

### Alternatives Considered

- Keeping `PWR_BUT` without a suffix - rejected; no suffix creates ambiguity and does not conform
  to the GRS §10 naming standard applied to all other active-low signals in this design.

### Impact

- Net rename applied in: `Power_Module/Design_Spec.md`, `Power_Module/Board_Layout.md`,
  `Controller/Design_Spec.md`, `Controller/Board_Layout.md`, `System_Architecture.md`,
  `Software/Linux_OS/Power_Management.md`, `Datasheets/RPi-cm5-datasheet.md`.
- `Controller/Design_Spec.md §6.1` updated to document the CM5 PMIC pin mapping and active-LOW
  polarity explicitly.
- No electrical change; net renaming only.
