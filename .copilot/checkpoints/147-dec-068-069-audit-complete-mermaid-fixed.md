# Checkpoint 147 — DEC-068/069 audit complete, Mermaid fixed

## Overview

Three post-implementation fixes applied to close the DEC-068/069 workstream completely:
PM Design_Spec.md Mermaid diagram had all four J4/J5 and F3/F4 node labels swapped;
DEC-069 was missing a `### Voltage Rating Selection` section; DEC-068 was missing the Q1
voltage derating note. All three fixed, lint-clean, and a third full audit pass of the
discussion file confirmed no remaining content gaps. DEC-068/069 workstream is now fully closed.

## Work Done

- **Mermaid diagram bug fixed (PM Design_Spec.md ~lines 75–130):**
  - `J4["J4 USB-C PD"]` → `J4["J4 Battery"]`
  - `J5["J5 Battery"]` → `J5["J5 USB-C PD"]`
  - `F3["F3 Polyfuse 0ZRB (USB-C)"]` → `F3["F3 Polyfuse 0ZRB (Battery)"]`
  - `F4["F4 Polyfuse 0ZRB (Battery)"]` → `F4["F4 Polyfuse 0ZRB (USB-C)"]`
  - Authority: BOM (J4=Molex/Battery, J5=USB4135-GF-A/USB-C), body text, DR-PM-19
  - `Last Updated` set to `2026-05-12`

- **DEC-069 `### Voltage Rating Selection` section added (before `### Thermal Derating`):**
  - STUSB4500 cannot negotiate EPR → max PDO = 15V
  - Battery max = 4.1V/cell × 4 = 16.4V; +20% transient = 19.7V → 20V absolute minimum
  - 24V selected (4.3V headroom); 0ZRB0600FF1A at 30VDC satisfies with 6V additional margin
  - Notes original 33V proposal and why it was revised
  - Explains why no qualifying SMD was found (THT justified)

- **DEC-068 Q1 voltage derating note added (Decision section, Q1 paragraph):**
  - CL32B226KAJNNNE: 25V rated, 11–16.9V input range → 1.5–2.3× derating
  - Consistent with C1–C15 (same part, same VIN rail)

- **Lint clean:** markdownlint exit 0 on PM Design_Spec.md and Design_Log.md

- **Third full audit pass of `.copilot/discussions/pm-bulk-caps-and-per-input-protection.md`:**
  - All technical content confirmed mirrored in DEC-068 and DEC-069
  - No remaining gaps found — audit complete

## Files Modified

- `design/Electronics/Power_Module/Design_Spec.md` — 4 Mermaid node labels corrected; Last Updated set to 2026-05-12
- `design/Design_Log.md` — DEC-068 Q1 derating sentence added; DEC-069 `### Voltage Rating Selection` section inserted

## Technical Details

**Correct PM connector/fuse assignments (authority: BOM + DR-PM-19 + body text):**
- J4 = Battery (Molex 43650-0519, 5-pin Micro-Fit THT)
- J5 = USB-C (GCT USB4135-GF-A)
- F2 = PoE path, F3 = Battery path, F4 = USB-C path

**Voltage rating derivation (DEC-069):**
- Max PDO = 15V (STUSB4500 no EPR); battery max transient = 19.7V → 20V hard floor
- 24V selected; 0ZRB at 30VDC gives 6V margin; no AEC-Q200 SMD at these specs → THT

**Q1 derating (DEC-068):**
- 25V rated ÷ 16.9V OVLO = 1.5×; 25V ÷ 11V UVLO = 2.3×
- Consistent with C1–C15 on same VIN rail

**Open action (not tracked in todos):**
- Confirm PM enclosure maximum sustained ambient temperature for thermal derating validation
  (0ZRB0600FF1A at 85°C: 44% derating → I_H_eff = 2.64A, below 5.35A worst-case)

## Next Workstreams

1. `jtag-integrity-resistor-value-reconcile` — pending, no blockers
2. `mcp23017-gpb7-silicon-fixed-review` — pending, no blockers
3. `usm-spdt-switch-floating-review` — pending, no blockers
4. `consolidate-design-spec-content` — pending, blocked by `enc-connector-review-pre-pcb`
