# Checkpoint 105 — DR cleanup and datasheets added

**Status:** Complete — ready to commit

## What was done

Follow-on cleanup after the DF40 connector changeset (checkpoints 103–104).

### DR table cleanup

- `design/Electronics/Controller/Design_Spec.md`: removed blank row left between DR-CTL-12 and DR-CTL-14 after DR-CTL-13 deletion
- `design/Electronics/Extension/Design_Spec.md`: removed DR-EXT-10 retired connector stub row entirely (design specs reflect current design only — no historical stubs)

### New markdown datasheets

Five new datasheet markdowns added to `design/Datasheets/`:

| File | Part / Source |
|---|---|
| `Hirose-DF40_Catalog_en-datasheet.md` | Hirose DF40 connector series catalog; includes curated Design Notes with selected parts, supplier codes, polarity warning, mounting hole keying strategy, key dimensions, PCB land pattern tables |
| `Hirose-DF40_Catalog_en-datasheet.pdf` | Source PDF for above |
| `9774035151R-standoff-datasheet.md` | Würth WA-SMSI M2.5×3.5mm SMT standoff; source PDF is `9774040151R-standoff-datasheet.pdf` (shared WA-SMSI series datasheet) |
| `Glenair_03232018_807_216-3045547-datasheet.md` | Glenair Mighty Mouse Series 807 drawing |
| `Glenair_mighty-mouse-807-nw-connector_catalogue.md` | Glenair Mighty Mouse 807 NW catalogue |
| `TE-1-1674231-1-product-specification.md` | TE Connectivity 1-1674231-1 product spec |
| `TI-csd17578q5a-datasheet.md` | TI CSD17578Q5A FET datasheet |

Inventory JSON (`_generated_markdown_inventory.json`) rebuilt to include all new files.

### Notes

- The script (`generate_markdown_datasheets.py`) is at HEAD; it regenerates all markdowns unconditionally on each run. Curated Design Notes sections must be preserved manually.
- 9774035151R and 9774040151R share the same Würth WA-SMSI series PDF. The 3.5mm variant has no separate datasheet; the 4.0mm PDF is canonical for both.
