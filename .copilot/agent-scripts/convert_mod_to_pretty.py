#!/usr/bin/env python3
"""
convert_mod_to_pretty.py

Converts a KiCAD legacy .mod footprint library to individual .kicad_mod files
in a .pretty directory, using pcbnew's LEGACY plugin.

Usage:
    python convert_mod_to_pretty.py <input.mod> <output.pretty/>

Also supports backport mode (Step 3): appending individual .kicad_mod files
from a .pretty directory back into a legacy .mod file.

Usage (backport):
    python convert_mod_to_pretty.py --backport <source.pretty/> <output.mod>
"""

import sys
import os
import re

KICAD_PYTHON = r"C:\Program Files\KiCad\10.0\bin\python.exe"


def parse_mod_index(mod_path):
    """Extract footprint names from the $INDEX block."""
    with open(mod_path, 'r', encoding='utf-8') as f:
        content = f.read()
    m = re.search(r'\$INDEX\s*(.*?)\s*\$EndINDEX', content, re.DOTALL)
    if not m:
        return []
    return [n.strip() for n in m.group(1).splitlines() if n.strip()]


def extract_module_blocks(mod_path):
    """Extract all $MODULE...$EndMODULE blocks as a dict {name: block_text}."""
    with open(mod_path, 'r', encoding='utf-8') as f:
        content = f.read()
    blocks = {}
    for m in re.finditer(r'(\$MODULE\s+(\S+).*?\$EndMODULE\s+\S+)', content, re.DOTALL):
        name = m.group(2)
        blocks[name] = m.group(1)
    return blocks


def write_temp_lib(name, block, temp_dir):
    """Write a minimal single-footprint legacy .mod file to temp_dir."""
    path = os.path.join(temp_dir, f"{name}.mod")
    with open(path, 'w', encoding='utf-8') as f:
        f.write("PCBNEW-LibModule-V1\n")
        f.write("# encoding utf-8\n")
        f.write("Units mm\n")
        f.write(f"$INDEX\n{name}\n$EndINDEX\n")
        f.write(block)
        f.write("\n$EndLIBRARY\n")
    return path


def convert_mod_to_pretty(mod_path, pretty_dir):
    """Step 2: Convert all footprints in .mod to individual .kicad_mod files."""
    import pcbnew
    import tempfile

    os.makedirs(pretty_dir, exist_ok=True)
    blocks = extract_module_blocks(mod_path)
    names = list(blocks.keys())
    print(f"Found {len(names)} footprints in {mod_path}")

    legacy_plugin = pcbnew.PCB_IO_MGR.FindPlugin(pcbnew.PCB_IO_MGR.LEGACY)
    sexp_plugin = pcbnew.PCB_IO_MGR.FindPlugin(pcbnew.PCB_IO_MGR.KICAD_SEXP)

    with tempfile.TemporaryDirectory() as temp_dir:
        ok = 0
        fail = 0
        for name in names:
            try:
                temp_lib = write_temp_lib(name, blocks[name], temp_dir)
                fp = legacy_plugin.FootprintLoad(temp_lib, name, False, pcbnew.str_utf8_Map())
                if fp is None:
                    print(f"  SKIP (None): {name}")
                    fail += 1
                    continue
                sexp_plugin.FootprintSave(pretty_dir, fp)
                ok += 1
                print(f"  OK: {name}")
            except Exception as e:
                print(f"  FAIL: {name}: {e}")
                fail += 1

    print(f"\nStep 2 complete: {ok} converted, {fail} failed")
    return ok, fail


def backport_kicad_mod_to_legacy(kicad_mod_files, mod_path):
    """
    Step 3: Append .kicad_mod footprints to a legacy .mod file.
    Reads each .kicad_mod, converts to legacy format using pcbnew, appends to mod_path.
    """
    import pcbnew

    sexp_plugin = pcbnew.PCB_IO_MGR.FindPlugin(pcbnew.PCB_IO_MGR.KICAD_SEXP)
    legacy_plugin = pcbnew.PCB_IO_MGR.FindPlugin(pcbnew.PCB_IO_MGR.LEGACY)

    # Read existing names in the .mod to avoid duplicates
    existing = set(parse_mod_index(mod_path))

    ok = 0
    fail = 0
    for kmod_path in kicad_mod_files:
        name = os.path.splitext(os.path.basename(kmod_path))[0]
        if name in existing:
            print(f"  SKIP (exists): {name}")
            continue
        try:
            parent_dir = os.path.dirname(kmod_path)
            fp = sexp_plugin.FootprintLoad(parent_dir, name, False, pcbnew.str_utf8_Map())
            if fp is None:
                print(f"  FAIL (None): {name}")
                fail += 1
                continue
            legacy_plugin.FootprintSave(mod_path, fp)
            ok += 1
            print(f"  OK: {name}")
        except Exception as e:
            print(f"  FAIL: {name}: {e}")
            fail += 1

    print(f"\nStep 3 complete: {ok} appended, {fail} failed")
    return ok, fail


if __name__ == '__main__':
    if len(sys.argv) < 3:
        print(__doc__)
        sys.exit(1)

    if sys.argv[1] == '--backport':
        # python convert_mod_to_pretty.py --backport <source.pretty/> <output.mod>
        pretty_src = sys.argv[2]
        mod_out = sys.argv[3]
        kmod_files = [
            os.path.join(pretty_src, f)
            for f in os.listdir(pretty_src)
            if f.endswith('.kicad_mod')
        ]
        print(f"Backporting {len(kmod_files)} .kicad_mod files to {mod_out}")
        backport_kicad_mod_to_legacy(kmod_files, mod_out)
    else:
        # python convert_mod_to_pretty.py <input.mod> <output.pretty/>
        mod_in = sys.argv[1]
        pretty_out = sys.argv[2]
        convert_mod_to_pretty(mod_in, pretty_out)
