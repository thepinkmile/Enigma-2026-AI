# PRIMARY DIRECTIVE — Component and BOM Protection

## Part Number Protection

⛔ **NEVER modify any component MPN or supplier part number** (Mouser SKU, DigiKey PN, JLCPCB C-number,
or any Alternative Supplier code) without explicit user confirmation.

Every approved code is intentional and verified. Mouser routinely abbreviates MPNs — these are correct.

Confirmed conventions:

- `TPD4E05U06QDQARQ1` → Mouser `595-PD4E05U06QDQARQ1` (drops leading `T`)
- `LMQ61460AFSQRJRRQ1` → Mouser `595-Q61460AFSQRJRRQ1` (drops leading `LM`)

## New Component References

⛔ **NEVER add a new component reference** (new RefDes, new BOM row, or a named component in spec
text such as "FB1" or "U5") without explicit user review and approval. This includes placeholder
or TBD entries — they must not be inserted until the user confirms the component type and approves
the addition. Remove any such entry inserted without approval.

## BOM Authority

- Board `Design_Spec.md` files are the **authoritative source** for all component data.
- `design/Electronics/Consolidated_BOM.md` is a **derived document** — always updated to reflect board
  spec changes; never edited as a primary source.
- `all_boards_bom.json` is retired (DEC-083).

## BOM Content

A BOM table must contain **only**:

| Column | Content |
| :--- | :--- |
| Board (RefDes) | Board identifier and reference designator(s) |
| MPN | Manufacturer part number |
| Manufacturer | Manufacturer name |
| Part Specification | Value, tolerance, voltage rating, package |
| DigiKey PN / Mouser PN / JLCPCB PN / Alt PN | Supplier order codes |
| Qty | Per-board and system quantities |
| Notes | Procurement notes only (availability flags, "order direct", etc.) |

⛔ A BOM must **never** contain: function descriptions, circuit explanations, design rationale, signal
names, net names, or connectivity information. Functional information belongs in `Design_Spec.md`.

- Do not raise the absence of function notes as a finding.
- Do not add function notes as a fix.
- If a row contains function notes, remove them only when editing that row for another reason — no
  standalone cleanup unless the user requests a conformity sweep.

## Banned Manufacturers

⛔ **Murata** is banned from the Enigma-NG BOM entirely (all product families: GRM, GCM, BLM, DMR,
etc.). Do not recommend, suggest, or add any Murata component under any circumstances.

If a Murata MPN is found in the BOM, raise it as a finding — do not silently substitute.
