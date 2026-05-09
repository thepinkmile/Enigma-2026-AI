# Todo: System Configuration Variants Diagrams

**ID:** `system-config-variants-diagrams`
**Status:** pending
**Category:** Documentation improvements
**Source:** Session decision — UML/Mermaid diagram enhancement
**Blocked by:** —

---

## Description

Add three Mermaid `flowchart TD` diagrams to `design/Electronics/System_Architecture.md`
showing the three supported system configuration variants: Minimum, Mini-Stack, and Full.
Each diagram is separate and self-contained.

## Target File

`design/Electronics/System_Architecture.md`

Add as a **new named section** (e.g. `## N. System Configuration Variants`) near the top of
the file, so it is among the first things seen. The three diagrams should appear together
in that section, each preceded by a short label (e.g. `### Minimum Configuration (5 rotors)`).

## Three Diagrams

### 1. Minimum Configuration (5 rotors)

Chain: `PM` → `CTL` → `STA` → `R1` → `R2` → `R3` → `R4` → `R5` → `REF`

Side nodes:
- `JM` attached to `CTL`
- `AM` attached to `CTL`
- `USM` attached to `STA`
- 6× `ENC` attached to `STA`

No Extension boards.

### 2. Mini-Stack Configuration (10 rotors, 1 Extension)

Chain: `PM` → `CTL` → `STA` → `[R1–R5]` → `EXT1` → `[R6–R10]` → `REF`

Side nodes same as Minimum plus:
- `AM_EXT` attached to `EXT1` (Extension-local Actuation Module)

Represent each 5-rotor sub-group as a single compressed node labelled `[R1–R5]` and `[R6–R10]`.

### 3. Full Configuration (30 rotors, 5 Extensions)

Chain: `PM` → `CTL` → `STA` → `[R1–R5]` → `EXT1` → `[R6–R10]` → `EXT2` → `[R11–R15]`
→ `EXT3` → `[R16–R20]` → `EXT4` → `[R21–R25]` → `EXT5` → `[R26–R30]` → `REF`

Side nodes same as Mini-Stack but with AM on each of the 5 EXT boards.

Add a note below the diagram: "Full build = 30 rotors, 5 Extensions. Power budget limit for Rev A."

## Mermaid Type

`flowchart TD` for all three. Each diagram is in its own fenced block.

Use subgraphs or node groups where helpful to visually cluster rotor sub-groups:
```
subgraph group1["Group 1 (Rotors 1–5)"]
  R1 --> R2 --> R3 --> R4 --> R5
end
```

## Notes

- These diagrams are schematic — labels like `[R1–R5]` are acceptable shorthand for sub-groups.
- Connector labels are NOT needed on these diagrams (the board interconnect diagram covers that).
- These diagrams show operational configuration variants, not circuit detail.
- Reference `design/Electronics/System_Architecture.md` for existing content structure.
- Do NOT duplicate diagrams already present in System_Architecture.md (the file already has
  Mermaid flowcharts in §1, §3, §4 — check for overlap before inserting).
