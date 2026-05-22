# Design Log Restructure

**ID:** `design-log-restructure`  
**Status:** pending  
**Category:** Documentation / Structure  
**Source:** User request 2026-05-22  
**Blocked by:** —  

---

## Description

Restructure `design/Design_Log.md` from a single flat file into a directory of per-decision files,
with an index file acting as the entry point.

Target structure:

```
design/Design_Log/
  index.md                        ← index table of all DEC entries (ID, title, date, status)
  DEC-001_{decision-title}.md     ← one file per decision (kebab-case title)
  DEC-002_{decision-title}.md
  ...
  DEC-083_{decision-title}.md
```

The `design/Design_Log/` directory should be the **first** entry in the GitHub Actions–generated
wiki navigation page (investigate current wiki nav structure before implementing).

## Notes

- **TERTIARY DIRECTIVE applies in full**: existing DEC entry content must not be modified during
  the restructure — content is moved verbatim into individual files.
- Naming convention: `DEC-NNN_{kebab-case-title}.md` (e.g. `DEC-082_10uf-bulk-cap-upgrade.md`).
- The `index.md` should contain a table: `| DEC | Title | Date | Status/Amends |`.
- `agent-directives.md` TERTIARY DIRECTIVE section must be updated to reference the new structure
  (append path and any new file-naming rules) once the restructure is complete.
- `plan.md` references to `design/Design_Log.md` must be updated to `design/Design_Log/index.md`
  (or the relevant per-DEC file) after restructure.
- The next new decision after restructure is **DEC-084** — it should be created as
  `DEC-084_{title}.md` in the new directory.
- Investigate: how the GitHub Actions wiki navigation is currently structured and where
  `design/Design_Log/` should be inserted as the first entry.
