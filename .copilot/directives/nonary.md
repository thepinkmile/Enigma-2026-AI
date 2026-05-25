# NONARY DIRECTIVE — KiCAD Library Component Import

> ⚠️ **CRITICAL LIBRARY INTEGRITY RULE** — The project uses a single unified KiCAD library with
> four parallel formats that must remain in sync. Partial imports leave the library in a broken
> state where legacy KiCAD users and CI/export pipelines cannot resolve references.

## Library File Locations (`src/Electronics/Library/`)

| Format | File |
| :--- | :--- |
| New-format symbol | `SamacSys_Parts.kicad_sym` |
| Legacy symbol | `SamacSys_Parts.lib` |
| Legacy component descriptions | `SamacSys_Parts.dcm` |
| Legacy footprint library | `SamacSys_Parts.mod` (has `$INDEX` section + `$MODULE` blocks) |
| New-format footprint directory | `SamacSys_Parts.pretty/` (one `.kicad_mod` per footprint) |
| 3D model (footprint ref) | `SamacSys_Parts.3dshapes/` — use `.stp` extension |
| 3D model (reference copy) | `3D_Models/` — use `.step` extension, same base name |

Source zips arrive in `src/Electronics/Library/temp/`. Each zip typically contains:
`KiCad/<PARTNAME>.kicad_sym`, `KiCad/<PARTNAME>.kicad_mod`, `3D/<PARTNAME>.stp`.

## Import Workflow

**STEP A — Extract** to `src/Electronics/Library/temp/_<source>_extracted/<ZIPNAME>/`.
Do not flatten the extracted structure.

**STEP B — Check existing** — does a symbol exist in `.kicad_sym` and `.lib`?
Does a footprint exist in `.pretty/`?

**STEP C — 3D model (always required):**

1. Copy `.stp` → `SamacSys_Parts.3dshapes/<FILENAME>.stp`
2. Copy `.stp` → `3D_Models/<FILENAME>.step` (same base name, `.step` extension)
3. If footprint exists without a model ref, add one (unquoted filename, legacy style):

   ```text
     (model <FILENAME>.stp
       (at (xyz 0 0 0))
       (scale (xyz 1 1 1))
       (rotate (xyz 0 0 0))
     )
   ```

   Insert immediately before the final closing `)` of the `.kicad_mod` file.

**STEP D — Symbol (conditional):**

- Symbol exists in **both** `.kicad_sym` and `.lib` → do **not** import.
- New part → add to `SamacSys_Parts.kicad_sym`, `SamacSys_Parts.lib`, and `SamacSys_Parts.dcm`.

**STEP E — Footprint (conditional):**

- Footprint exists in `.pretty/` → do **not** replace (pad-position changes break PCB layouts).
  Add model ref only (STEP C).
- New footprint → import `.kicad_mod` to `.pretty/`; add to `SamacSys_Parts.mod` (index entry +
  `$MODULE` block); update footprint property in symbol files to `SamacSys_Parts:<FOOTPRINTNAME>`.

### Legacy `.mod` pad syntax

SMD rectangular pad:

```text
$PAD
Po <x> <y>
Sh "<num>" R <width> <height> 0 0 0
At SMD N 00888000
Ne 0 ""
$EndPAD
```

NPTH drill hole:

```text
$PAD
Po <x> <y>
Sh "" C <diam> <diam> 0 0 900
Dr <diam> 0 0
At HOLE N 00E0FFFF
$EndPAD
```

## Naming Conventions

- Footprint filenames: canonical part name, no vendor prefix
  (e.g. `ERM8-005-XX.X-X-DV-K-TR.kicad_mod`).
- Zip filenames sometimes use dashes where the library uses concatenated names
  (e.g. `LIB_10164227-1004A1RLF.zip` → part `101642271004A1RLF`). Search with normalised (no-dash) form.
- `fp_text value` inside `.kicad_mod` must match the file's base name.

## Completeness Gate

An import is complete when **all** are true:

1. Symbol in `SamacSys_Parts.kicad_sym` and `SamacSys_Parts.lib` / `.dcm`.
2. Footprint `.kicad_mod` in `SamacSys_Parts.pretty/` with valid `(model …)` ref.
3. Footprint module in `SamacSys_Parts.mod` (index entry + `$MODULE` block).
4. Both `SamacSys_Parts.3dshapes/<NAME>.stp` and `3D_Models/<NAME>.step` exist.
5. `src/Electronics/Library/LIBRARY_NOTES.md` updated — component inventory (§3) and naming
   equivalences (§2) reflect the new part.

Only after all conditions are verified: move source zip and extracted files from `temp/` to
`.recycle-bin/library-retired-YYYYMMDD/` (QUATERNARY DIRECTIVE).

> ⚠️ Never remove the `temp/` directory itself. Only move its contents.

If a condition cannot be satisfied (e.g. no 3D model in zip), document the gap and do not retire
the zip until resolved.

## Sub-Agent Prompts

Every sub-agent prompt for a library import task **must** start with the SEPTENARY DIRECTIVE
preamble (from `.copilot/directives/septenary.md`), followed by:

```text
Also read and apply .copilot/directives/nonary.md — KiCAD Library Import — before importing any part.
All four library formats must remain in sync. Source files are retired to .recycle-bin/ only after
a complete verified import.
```
