#!/usr/bin/env python3
"""
sym_sync_lib_to_kicad_sym.py

Syncs missing symbols from SamacSys_Parts.lib (legacy KiCAD 5/6 format) to
SamacSys_Parts.kicad_sym (KiCAD 7+ format) using kicad-cli sym upgrade.

Usage:
    "C:\Program Files\KiCad\10.0\bin\python.exe" sym_sync_lib_to_kicad_sym.py
"""

import subprocess
import re
import tempfile
import os
import shutil

KICAD_CLI = r"C:\Program Files\KiCad\9.0\bin\kicad-cli.exe"

SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
REPO_ROOT = os.path.normpath(os.path.join(SCRIPT_DIR, "..", ".."))
LIB_ROOT = os.path.join(REPO_ROOT, "src", "Electronics", "Library")
LIB_FILE = os.path.join(LIB_ROOT, "SamacSys_Parts.lib")
SYM_FILE = os.path.join(LIB_ROOT, "SamacSys_Parts.kicad_sym")


def get_symbol_names_from_lib(lib_path):
    """Extract symbol names from legacy .lib file (DEF lines)."""
    names = set()
    with open(lib_path, 'r', encoding='utf-8', errors='replace') as f:
        for line in f:
            m = re.match(r'^DEF\s+(\S+)', line)
            if m:
                names.add(m.group(1))
    return names


def get_symbol_names_from_kicad_sym(sym_path):
    """Extract top-level symbol names from .kicad_sym file."""
    names = set()
    with open(sym_path, 'r', encoding='utf-8', errors='replace') as f:
        content = f.read()
    for m in re.finditer(r'\(symbol\s+"([^"]+)"', content):
        name = m.group(1)
        # Sub-unit symbols end in _N_N — skip them
        if not re.search(r'_\d+_\d+$', name):
            names.add(name)
    return names


def extract_symbol_blocks(content, names_to_extract):
    """
    Extract full (symbol "NAME" ...) top-level blocks for the given names.
    Returns dict {name: block_text}.
    Handles quoted strings to avoid false parenthesis depth counts.
    """
    result = {}
    pos = 0
    n = len(content)

    while pos < n:
        idx = content.find('(symbol "', pos)
        if idx == -1:
            break

        name_start = idx + 9
        name_end = content.find('"', name_start)
        if name_end == -1:
            pos = idx + 1
            continue
        name = content[name_start:name_end]

        # Skip sub-unit symbols
        if re.search(r'_\d+_\d+$', name):
            pos = idx + 1
            continue

        # Walk forward tracking paren depth, respecting quoted strings
        depth = 0
        i = idx
        in_string = False
        block_end = -1
        while i < n:
            ch = content[i]
            if in_string:
                if ch == '\\' and i + 1 < n:
                    i += 2
                    continue
                if ch == '"':
                    in_string = False
            else:
                if ch == '"':
                    in_string = True
                elif ch == '(':
                    depth += 1
                elif ch == ')':
                    depth -= 1
                    if depth == 0:
                        block_end = i + 1
                        break
            i += 1

        if block_end == -1:
            pos = idx + 1
            continue

        block = content[idx:block_end]
        if name in names_to_extract:
            result[name] = block
        pos = block_end

    return result


def main():
    print(f"Repo root : {REPO_ROOT}")
    print(f"LIB file  : {LIB_FILE}")
    print(f"SYM file  : {SYM_FILE}")
    print()

    if not os.path.exists(LIB_FILE):
        print(f"ERROR: .lib not found: {LIB_FILE}")
        return
    if not os.path.exists(SYM_FILE):
        print(f"ERROR: .kicad_sym not found: {SYM_FILE}")
        return

    lib_names = get_symbol_names_from_lib(LIB_FILE)
    sym_names = get_symbol_names_from_kicad_sym(SYM_FILE)

    print(f"Symbols in .lib       : {len(lib_names)}")
    print(f"Symbols in .kicad_sym : {len(sym_names)}")

    missing = lib_names - sym_names
    if not missing:
        print("\nAll symbols already present in .kicad_sym — nothing to do.")
        return

    print(f"\nMissing from .kicad_sym ({len(missing)}):")
    for nm in sorted(missing):
        print(f"  - {nm}")

    with tempfile.TemporaryDirectory() as tmpdir:
        temp_sym = os.path.join(tmpdir, "upgraded.kicad_sym")

        cmd = [KICAD_CLI, "sym", "upgrade", LIB_FILE, "-o", temp_sym]
        print(f"\nRunning: {' '.join(cmd)}")
        result = subprocess.run(cmd, capture_output=True, text=True)
        print(f"Return code: {result.returncode}")
        if result.stdout.strip():
            print(f"stdout: {result.stdout.strip()}")
        if result.stderr.strip():
            print(f"stderr: {result.stderr.strip()}")

        if result.returncode != 0:
            print("ERROR: kicad-cli returned non-zero exit code — aborting")
            return

        if not os.path.exists(temp_sym):
            print(f"ERROR: expected output not found at {temp_sym}")
            return

        with open(temp_sym, 'r', encoding='utf-8', errors='replace') as f:
            temp_content = f.read()

        blocks = extract_symbol_blocks(temp_content, missing)
        print(f"\nExtracted {len(blocks)}/{len(missing)} symbol blocks from upgraded file")

        if not blocks:
            print("ERROR: failed to extract any symbol blocks — aborting")
            return

        if len(blocks) < len(missing):
            not_found = missing - set(blocks.keys())
            print(f"WARNING: could not extract blocks for: {sorted(not_found)}")

        # Append extracted blocks to existing .kicad_sym
        with open(SYM_FILE, 'r', encoding='utf-8', errors='replace') as f:
            sym_content = f.read()

        stripped = sym_content.rstrip()
        if not stripped.endswith(')'):
            print("ERROR: .kicad_sym does not end with ')' — aborting")
            return

        insertion = ""
        for nm in sorted(blocks.keys()):
            insertion += "\n" + blocks[nm] + "\n"

        new_content = stripped[:-1] + insertion + ")\n"

        backup = SYM_FILE + ".bak"
        shutil.copy2(SYM_FILE, backup)
        print(f"\nBackup: {backup}")

        with open(SYM_FILE, 'w', encoding='utf-8') as f:
            f.write(new_content)

        # Verify
        updated_names = get_symbol_names_from_kicad_sym(SYM_FILE)
        added = updated_names - sym_names
        still_missing = missing - updated_names

        print(f"\n{'='*50}")
        print(f"Added {len(added)} symbol(s):")
        for nm in sorted(added):
            print(f"  + {nm}")

        if still_missing:
            print(f"\nWARNING: {len(still_missing)} symbol(s) still missing:")
            for nm in sorted(still_missing):
                print(f"  ! {nm}")
        else:
            print("\nSync complete — all symbols are now present in .kicad_sym")

        print(f"\nFinal count: {len(updated_names)} symbols in .kicad_sym")


if __name__ == '__main__':
    main()
