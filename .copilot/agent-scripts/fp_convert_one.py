"""
fp_convert_one.py — Single-footprint legacy→pretty converter.

Called as a subprocess by fp_batch_convert.py (or manually) so that
a crash or hang in the KiCAD LEGACY plugin only kills the child process,
not the whole batch run.

Usage:
    python fp_convert_one.py <mod_path> <footprint_name> <pretty_dir>

Exit codes:
    0  — success (prints "OK")
    2  — FootprintLoad returned None (prints diagnostic to stderr)
    3  — footprint name not found in the .mod file
    1  — unhandled exception
"""

import sys
import tempfile
import os

# Allow running from any working directory
sys.path.insert(0, os.path.join(os.path.dirname(__file__)))
import convert_mod_to_pretty as c
import pcbnew

if len(sys.argv) != 4:
    print("Usage: fp_convert_one.py <mod_path> <footprint_name> <pretty_dir>", file=sys.stderr)
    sys.exit(1)

mod_path  = sys.argv[1]
name      = sys.argv[2]
out_dir   = sys.argv[3]

blocks = c.extract_module_blocks(mod_path)
if name not in blocks:
    print(f"NOT_FOUND: {name}", file=sys.stderr)
    sys.exit(3)

legacy = pcbnew.PCB_IO_MGR.FindPlugin(pcbnew.PCB_IO_MGR.LEGACY)
sexp   = pcbnew.PCB_IO_MGR.FindPlugin(pcbnew.PCB_IO_MGR.KICAD_SEXP)

with tempfile.TemporaryDirectory() as td:
    tmp = c.write_temp_lib(name, blocks[name], td)
    fp  = legacy.FootprintLoad(tmp, name, False, pcbnew.str_utf8_Map())
    if fp is None:
        print(f"NONE_RESULT for {name}", file=sys.stderr)
        sys.exit(2)
    sexp.FootprintSave(out_dir, fp)
    print("OK")
