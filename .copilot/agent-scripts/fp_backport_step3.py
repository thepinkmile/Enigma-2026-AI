"""
fp_backport_step3.py — Step 3: backport two .kicad_mod files into SamacSys_Parts.mod.

Avoids calling legacy_plugin.FootprintSave on the full .mod (which hangs due to
the corrupt 7448031002 entry). Instead saves to a fresh temp .mod, extracts the
MODULE block by text, and appends it to the main .mod via pure text manipulation.
"""
import sys
import tempfile
import os

sys.path.insert(0, os.path.join(os.path.dirname(__file__)))
import convert_mod_to_pretty as c
import pcbnew

pretty_dir = r'C:\_DATA_\Repositories\github\Enigma-NG\src\Electronics\Library\SamacSys_Parts.pretty'
mod_path   = r'C:\_DATA_\Repositories\github\Enigma-NG\src\Electronics\Library\SamacSys_Parts.mod'

sexp_plugin   = pcbnew.PCB_IO_MGR.FindPlugin(pcbnew.PCB_IO_MGR.KICAD_SEXP)
legacy_plugin = pcbnew.PCB_IO_MGR.FindPlugin(pcbnew.PCB_IO_MGR.LEGACY)

names_to_backport = ['SOT95P240X120-3N', 'NE555DR']
blocks_to_append = []

for name in names_to_backport:
    fp = sexp_plugin.FootprintLoad(pretty_dir, name, False, pcbnew.str_utf8_Map())
    if fp is None:
        print(f'FAIL (None): {name}')
        continue
    # Save to a FRESH temp .mod — no existing footprints, so no hang
    with tempfile.TemporaryDirectory() as td:
        tmp_mod = os.path.join(td, 'temp.mod')
        legacy_plugin.FootprintSave(tmp_mod, fp)
        with open(tmp_mod, encoding='utf-8', errors='replace') as f:
            content = f.read()
    # Extract the MODULE block via text
    start_tag = '$MODULE ' + name
    end_tag   = '$EndMODULE'
    start = content.find(start_tag)
    end   = content.find(end_tag, start) + len(end_tag)
    block = content[start:end].strip()
    if block:
        blocks_to_append.append((name, block))
        print(f'  Extracted block for {name}: {len(block)} chars')
    else:
        print(f'  FAIL: could not extract block for {name}')

# Append blocks to mod_path using pure text — no plugin involvement
if blocks_to_append:
    with open(mod_path, 'r', encoding='utf-8', errors='replace') as f:
        mod_content = f.read()
    for name, block in blocks_to_append:
        if ('$MODULE ' + name) in mod_content:
            print(f'  SKIP (already present): {name}')
            continue
        # Append before $EndLIBRARY
        mod_content = mod_content.rstrip()
        if mod_content.endswith('$EndLIBRARY'):
            mod_content = mod_content[: -len('$EndLIBRARY')].rstrip()
        mod_content += '\n' + block + '\n$EndMODULE\n$EndLIBRARY\n'
        print(f'  Appended: {name}')
    with open(mod_path, 'w', encoding='utf-8') as f:
        f.write(mod_content)

print('Step 3 complete.')
