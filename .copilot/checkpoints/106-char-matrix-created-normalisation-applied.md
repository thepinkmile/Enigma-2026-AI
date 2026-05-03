# Checkpoint 106 — Character matrix created, normalisation applied, lint fixes applied

## Summary

Completed the `char-normalise-directives` todo item in full:

**Character matrix and directives:**
- Scanned all `design/` and `.copilot/` markdown files; identified 63 distinct non-ASCII codepoints across 5 groups.
- Received user approval decisions for each group and documented in `.copilot/allowed-character-matrix.md`.
  - Engineering symbols (omega, micro, degree, etc.) approved as-is.
  - `x` replaces multiplication sign `x`; `-` replaces minus sign.
  - Navigation/typography: arrows, middle dot, dagger, pound sign approved; em/en dashes -> `-`; ellipsis -> `...`; umlaut -> `u`.
  - Status icons: `✔` (U+2714 HEAVY CHECK MARK) is the single approved tick; `✅` and `✓` deprecated.
  - Box-drawing characters approved exclusively in `Board_Layout.md` files.
  - Group D curly quotes replaced with ASCII equivalents throughout.
  - Historical `.copilot/checkpoints/` files exempt from normalisation.
- Added `## Character Usage Rules` section to `agent-directives.md` pointing to the matrix.

**Normalisation pass across 74 `design/` files:**
- Python normalisation script run; applied em/en dash -> `-`, `x` -> `x`, curly quotes -> `'`/`"`,
  `✅`/`✓` -> `✔`, `½` -> `1/2`, `″` -> `"`, `▼` -> `↓`, `▶` -> `->`, box-drawing in non-layout files -> ASCII art.
- UTF-8 BOM stripped from 3 files (`Design_Log.md`, `Extension/Design_Spec.md`, `Rotor/Design_Spec.md`).

**Lint fixes introduced by normalisation:**
- 4 files required additional edits to fix errors introduced by normalisation:
  - `design/Standards/Certification_Evidence.md` — 6 TOC anchor links updated (`--` -> `---`) because
    en-dash in headings was replaced with hyphen, changing anchor hash from `--` to `---`.
  - `design/Guides/User_Manual.md` — 1 TOC anchor link updated (`--` -> `---`) for same reason.
  - `design/Design_Log.md` — line 413-414 re-split at safe word boundary to avoid `- ` at line start
    (em-dash at wrapped line start became list bullet after replacement).
  - `design/Electronics/Power_Module/Design_Spec.md` — two locations fixed: lines 208-209 re-split
    into 3 lines to avoid `- ` at line start; lines 641-642 blockquote joined to avoid same issue.
- Final markdownlint run across all 74 modified `design/` files: zero errors.

**todo-list.md cleanup:**
- 5 description rows stripped of redundant `Done` / tick prefixes (status column already carries this).

**German display text exception added (post-normalisation):**
- User clarified that German technical terms appearing as ALL-CAPITALS display/printed text (e.g.
  Enigma machine panel labels, procedure headings) must retain correct German spelling with umlauts.
- Added `Ä`, `Ö`, `Ü` (ALL-CAPS only) to the approved characters with a dedicated exception block
  in `allowed-character-matrix.md`.
- Restored `GRENZFLÄCHE` (was incorrectly stripped to `GRENZFLACHE`) in `design/Procedures/PAS_PowerModule_V1.md`.
- Lower-case umlauts and mixed-case accented letters in running text and manufacturer names (e.g. Würth)
  remain NOT permitted; ASCII equivalents must be used.

## Files changed

- `.copilot/allowed-character-matrix.md` — created (canonical approved character list)
- `.copilot/agent-directives.md` — curly quotes fixed; `## Character Usage Rules` section added
- `.copilot/todo-list.md` — `✅` (U+2705) replaced with `✔`; description column cleaned
- 74 `design/**/*.md` files — non-ASCII normalisation applied
  - Key files: `Design_Log.md`, `Electronics/Power_Module/Design_Spec.md`,
    `Standards/Certification_Evidence.md`, `Guides/User_Manual.md` (also received lint fixes)

## Prior checkpoint

105 — DR cleanup and datasheets added
