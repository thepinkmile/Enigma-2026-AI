# Todo: ascii-to-mermaid-diagrams

**Status:** pending  
**Blocked by:** none  
**Added:** 2026-05-09

---

## Summary

Replace ASCII art flow diagrams and block diagrams across `design/**/*.md` with native
Mermaid fenced blocks (` ```mermaid `). GitHub renders Mermaid natively in Markdown files,
so no tooling changes are required — the diagrams will render in the repository browser.

---

## Scope

Audit all `design/**/*.md` files for ASCII art diagrams. Convert any that represent:

- Flow diagrams (decision trees, process flows, signal flows)
- Block diagrams (system topology, power rails, connectivity overviews)
- Sequence diagrams (protocol or boot sequences)

Do **not** convert:

- Tables (these remain as standard Markdown tables)
- Pin or connector wiring diagrams where ASCII alignment aids readability and there is no
  Mermaid equivalent
- Short inline ASCII art that serves as a label or annotation rather than a diagram

---

## Approach

1. Search `design/**/*.md` for ASCII art patterns: boxes (`+--`, `|`, `+`), arrows (`->`, `<-`,
   `-->`, `<--`), and vertical separators used for diagram structure.
2. For each candidate, determine the appropriate Mermaid diagram type:
   - `flowchart TD` or `flowchart LR` — for flow/process diagrams
   - `block-beta` — for system block/topology diagrams
   - `sequenceDiagram` — for protocol or boot-sequence diagrams
3. Rewrite the diagram in Mermaid syntax within a ` ```mermaid ` fenced block.
4. Preserve all labels, signal names, and node relationships exactly — this is a
   representation change only, not a content change.
5. Update the "Last Updated" date in the file metadata for each changed file.
6. Do NOT update Version numbers.

---

## Known Candidate Files

Preliminary scan (to be confirmed during execution):

- `design/Electronics/Controller/Design_Spec.md` — Link-Alpha / Link-Beta topology
- `design/Electronics/Stator/Design_Spec.md` — routing matrix overview
- `design/Electronics/Power_Module/Design_Spec.md` — power rail flow
- `design/Software/Linux_OS/Power_Management.md` — shutdown sequence flow
- `design/Electronics/Boards_Overview.md` — system board topology

Confirm actual candidates by grep before converting.

---

## Acceptance Criteria

- All converted diagrams render correctly in GitHub's Markdown preview
- No content changes: labels, node names, and relationships are identical to the ASCII original
- ASCII original is removed and replaced entirely by the Mermaid block (no duplication)
- "Last Updated" updated in each modified file
- Version numbers unchanged
