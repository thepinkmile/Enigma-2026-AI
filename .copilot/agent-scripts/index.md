# Agent Scripts — Index

Scripts in this folder are used by Copilot agents to automate KiCAD library management and documentation generation for the Enigma-NG project.

---

## convert_mod_to_pretty.py

**Purpose:** Converts a KiCAD legacy `.mod` footprint library into individual `.kicad_mod` files inside a `.pretty` directory, using KiCAD's `pcbnew` LEGACY plugin. Also provides backport mode to re-append `.kicad_mod` files back into a `.mod` file (Step 3 of the library upgrade workflow).

**Usage:**

```powershell
# Forward conversion: .mod → .pretty
python convert_mod_to_pretty.py <input.mod> <output.pretty/>

# Backport mode (Step 3): .kicad_mod → appended to .mod
python convert_mod_to_pretty.py --backport <source.pretty/> <output.mod>
```

**Notes:**
- Requires KiCAD 10.0 Python at `C:\Program Files\KiCad\10.0\bin\python.exe`
- `FootprintSave` on SEXP-loaded footprints hangs in both KiCAD 9.0 and 10.0 (known bug). Use pure text extraction for backports instead.
- `backport_kicad_mod_to_legacy()` at line 94 is broken due to this hang; use `fp_backport_step3.py` or direct text manipulation as the workaround.

---

## fp_backport_step3.py

**Purpose:** Step 3 helper — backports specific named footprints from `SamacSys_Parts.pretty/` into `SamacSys_Parts.mod` by saving each to a fresh temp `.mod` file, extracting the resulting `$MODULE` block as text, and appending it to the main `.mod`. Avoids the legacy plugin hang on the `7448031002` entry.

**Usage:**

```powershell
python fp_backport_step3.py
```

**Notes:**
- Hardcoded paths point to the repo's `SamacSys_Parts.mod` and `.pretty/`
- Requires KiCAD 10.0 `pcbnew` module accessible on the Python path
- This script was superseded by direct text extraction from SamacSys zip files once the root issue (LEGACY plugin hang on SEXP-loaded footprints) was confirmed. Kept for reference.

---

## fp_convert_one.py

**Purpose:** Single-footprint subprocess converter. Loads one named footprint from a `.mod` file and saves it as a `.kicad_mod` file in a `.pretty` directory. Runs as a child process so that a KiCAD plugin crash or hang only kills the child, not the calling batch process.

**Usage:**

```powershell
python fp_convert_one.py <mod_path> <footprint_name> <pretty_dir>
```

**Exit codes:**

| Code | Meaning |
|------|---------|
| 0    | Success — prints `OK` |
| 1    | Unhandled exception |
| 2    | `FootprintLoad` returned `None` |
| 3    | Footprint name not found in the `.mod` |

**Notes:**
- Requires KiCAD 10.0 Python and `pcbnew`
- Called by the batch conversion workflow. Can also be run manually to convert a single entry.

---

## generate_markdown_datasheets.py

**Purpose:** Generates structured Markdown datasheet files from component PDF datasheets. Reads PDFs from `design/Datasheets/`, extracts key content using `pdfplumber`/`pypdf`, and writes/updates the inventory at `design/Datasheets/_generated_markdown_inventory.json`.

**Usage:**

```powershell
python generate_markdown_datasheets.py
```

**Notes:**
- Requires `pdfplumber` and `pypdf` Python packages
- Hardcoded paths use the repo root at `C:\_DATA_\Repositories\github\Enigma-NG`
- `_generated_markdown_inventory.json` is the full datasheet index — do not delete or truncate it
- Manual PDF-to-MD mappings are defined near the top of the script for multi-catalogue PDFs (e.g. Glenair 807)
- When searching for part details, prefer: markdown datasheet → local PDF → online (in that order)
