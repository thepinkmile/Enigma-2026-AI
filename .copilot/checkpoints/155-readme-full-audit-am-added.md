# Checkpoint 155 — README full-board audit complete; AM section added

## Status
Complete

## What was done

Full comparative audit of README.md against all 10 Design_Spec.md files. All discrepancies found
and corrected:

### README.md corrections applied (this session)
1. **JTAG attribution** — Removed "Embedded FT232H" language from Controller section; correctly
   attributes FT232H to the JTAG Module via J12 internal BtB connector.
2. **Toggle count** — "12 panel-mount toggles" → "10 panel-mount toggles" (per DR-USM-02).
3. **Signal name** — `CFG_APPLY` → `CFG_APPLY_N` (active-low signal).
4. **ENC bit-order convention** — `ENC_IN[0:5]`/`ENC_OUT[0:5]` → `ENC_IN[5:0]`/`ENC_OUT[5:0]`
   (MSB:LSB convention used throughout all design docs).
5. **Reflector connector** — "16-pin reflector ribbon" → "30-pin reflector ribbon connector (J4)"
   (per DR-REF-03).
6. **Development Roadmap** — refreshed to reflect current open workstreams.
7. **Core Component Overview** — Added Actuation Module (AM) bullet after JTAG Module entry.
8. **Board Status Snapshot** — Added `| Actuation Module | In Review |` row.
9. **Encoder CPLD model** — `EPM240T100I5N` → `EPM570T100I5N` (per DR-ENC-02; EPM240 is not used
   anywhere in this system).
10. **Misplaced buffer bullet removed** — `SN74LVC2G125DCUR buffer on each Extension Board` bullet
    was incorrectly placed under Rotor Module section; removed from Rotor and correctly described
    only in the Extension Board section.
11. **New `### 4. Actuation Module (AM)` Hardware Architecture section** — Written from
    AM Design_Spec; covers STM32G071K8T3TR MCU, servo PWM, homing, local LED diagnostics,
    SWD/UART service headers, DF40C BtB mounting, two system placements.
12. **Section renumbering** — Stator (4→5), Encoder (5→6), Settings (6→7), Rotor (7→8),
    Extension (8→9), Reflector (9→10).
13. **AM hosting note in Extension section** — Added bullet describing J9 DF40HC dock and
    group-boundary carry actuation role of the hosted AM.

### Other files updated
- `.copilot/todos/extension-mechanical-usage.md` — Rewritten with Category = Electronics; full
  scope including Stator/Reflector merge proposal, Extension A/B split, IDC replacement.
- `.copilot/todo-list.md` — SQL title updated: "Extension mechanical linkage spec" →
  "Extension interconnect architecture review".

## Key facts confirmed
- **Actuation Module**: STM32G071K8T3TR, 4-layer inverted stackup (GRS §2.3.2), two instances:
  Controller + each Extension Board.
- **All CPLDs in this system are EPM570T100I5N** — EPM240 is NOT used anywhere.
- **Power Module and Controller Board are both 6-layer/2oz**; all other electronics boards are
  4-layer/2oz.
- **USM has 10 SPDT toggles and 12 RGB LEDs** (the 12 figure is LEDs only).

## Open todos
- `usm-spdt-switch-floating-review` — SPDT switch GPIO expander pin mapping + pull-up/down check
- `enc-connector-review-pre-pcb` — ENC J1/J2 connector and 100nF cap review
- `review-pass-8` — formal clean-run verification

## Next checkpoint number
152
