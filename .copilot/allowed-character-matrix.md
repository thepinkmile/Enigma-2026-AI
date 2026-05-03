# Allowed Character Matrix

> Canonical reference for permitted non-ASCII characters in Enigma-NG repository documents.
> Any non-ASCII character **NOT** on this list must be approved by the repository owner before use.

This matrix governs all files in the `design/` tree and any other repository documents.
Files within `.copilot/` are for agent consumption; new agent docs should follow this matrix
as best practice, but historical checkpoint content is exempt.

---

## Group A - Engineering and Technical Symbols

These characters carry specific engineering meaning and must **not** be replaced with ASCII approximations.

| Character | U+    | Name                               | Approved Usage                              |
|-----------|-------|------------------------------------|---------------------------------------------|
| §         | 00A7  | SECTION SIGN                       | Section cross-references (e.g. §3.2)        |
| °         | 00B0  | DEGREE SIGN                        | Temperatures (e.g. 25°C, -40°C)             |
| ±         | 00B1  | PLUS-MINUS SIGN                    | Tolerances (e.g. ±5%)                       |
| µ         | 00B5  | MICRO SIGN                         | SI micro prefix (µF, µA, µH, µs)            |
| ¼         | 00BC  | VULGAR FRACTION ONE QUARTER        | Fractional values                           |
| Ø         | 00D8  | LATIN CAPITAL LETTER O WITH STROKE | Diameter notation (e.g. Ø3.5mm)            |
| ÷         | 00F7  | DIVISION SIGN                      | Division in expressions                     |
| √         | 221A  | SQUARE ROOT                        | Square root in formulas                     |
| ≈         | 2248  | ALMOST EQUAL TO                    | Approximations                              |
| ≤         | 2264  | LESS-THAN OR EQUAL TO              | Constraints and ratings                     |
| ≥         | 2265  | GREATER-THAN OR EQUAL TO           | Constraints and ratings                     |
| ⊕         | 2295  | CIRCLED PLUS                       | Exclusive-OR / XOR logic operations         |

**Any Greek letter** (α-ω, Α-Ω) is permitted for engineering and mathematical notation.
Examples: `Ω` (resistance), `η` (efficiency), `Δ` (change), `θ` (thermal resistance), `Γ`, `λ`, `π`, `τ`.

**Any Unicode superscript or subscript** digit or letter is permitted for formula, chemical, and engineering notation.
This includes: superscript digits (U+00B2, U+00B3, U+00B9, U+2070-U+2079), subscript digits (U+2080-U+2089), and subscript letters (e.g. U+1D63 `ᵣ`).
Examples: `²` (I²C, mm²), `₂` (MnO₂), `ᵣ` (Eᵣ).

**Not permitted** (use ASCII equivalent instead):

| Character | U+    | Name                       | Use instead              |
|-----------|-------|----------------------------|--------------------------|
| ×         | 00D7  | MULTIPLICATION SIGN        | `x`                      |
| −         | 2212  | MINUS SIGN                 | `-`                      |
| ½         | 00BD  | VULGAR FRACTION ONE HALF   | `1/2`                    |

---

## Group B - Navigation and Flow Symbols

| Character | U+    | Name                     | Approved Usage                              |
|-----------|-------|--------------------------|---------------------------------------------|
| £         | 00A3  | POUND SIGN               | GBP currency values                         |
| ·         | 00B7  | MIDDLE DOT               | Separator in summary lines                  |
| †         | 2020  | DAGGER                   | Footnote marker in tables                   |
| ←         | 2190  | LEFTWARDS ARROW          | Reverse flow notation                       |
| →         | 2192  | RIGHTWARDS ARROW         | Mapping, flow, and transformation notation  |
| ↔         | 2194  | LEFT RIGHT ARROW         | Bidirectional interface notation            |
| ↓         | 2193  | DOWNWARDS ARROW          | Falling/decreasing flow, signal states      |

**Not permitted** (use approved equivalent instead):

| Character | U+    | Name                            | Use instead                            |
|-----------|-------|---------------------------------|----------------------------------------|
| —         | 2014  | EM DASH                         | `-`                                    |
| –         | 2013  | EN DASH                         | `-`                                    |
| …         | 2026  | HORIZONTAL ELLIPSIS             | `...`                                  |
| ″         | 2033  | DOUBLE PRIME                    | `"` (standard double quotation mark)   |
| ü (etc.)  | 00FC+ | Accented Latin letters          | Base ASCII letter (e.g. `u` for Wurth) — **see exception below** |
| ▼         | 25BC  | BLACK DOWN-POINTING TRIANGLE    | `↓`                                    |
| ▶         | 25B6  | BLACK RIGHT-POINTING TRIANGLE   | `→`                                    |

**Exception - German display text (ALL CAPITALS only):**

The Enigma-NG system is derived from the original German Enigma machine. German technical terms that
appear as **display or printed text** (e.g. panel labels, procedure headings, section titles) and are
written in **ALL CAPITALS** are exempt from the umlaut ban and must retain correct German spelling.

Permitted umlauted characters in this context:

| Character | U+   | Name                                          | Context                                     |
|-----------|------|-----------------------------------------------|---------------------------------------------|
| Ä         | 00C4 | LATIN CAPITAL LETTER A WITH DIAERESIS         | ALL-CAPS German display/label text only     |
| Ö         | 00D6 | LATIN CAPITAL LETTER O WITH DIAERESIS         | ALL-CAPS German display/label text only     |
| Ü         | 00DC | LATIN CAPITAL LETTER U WITH DIAERESIS         | ALL-CAPS German display/label text only     |

Examples:
- `GRENZFLÄCHE` (thermal interface boundary) - correct, ALL-CAPS German term
- `HINWEIS` - no umlaut, no change needed
- `Würth` - manufacturer name, **not** in scope; use `Wurth` (ASCII)
- `ü` in running English text - **not** in scope; use ASCII (`u`)

---

## Group C - Status and UI Symbols

| Character | U+          | Name                    | Approved Usage                          |
|-----------|-------------|-------------------------|-----------------------------------------|
| ✔         | 2714        | HEAVY CHECK MARK        | Completed / verified item               |
| ❌        | 274C        | CROSS MARK              | Failed / rejected item                  |
| ⚠️        | 26A0 + FE0F | WARNING SIGN            | Caution / attention marker              |
| 🔵        | 1F535       | LARGE BLUE CIRCLE       | LED colour state indicator (blue)       |
| 🟠        | 1F7E0       | LARGE ORANGE CIRCLE     | LED colour state indicator (orange/amber)|
| 🟢        | 1F7E2       | LARGE GREEN CIRCLE      | LED colour state indicator (green)      |
| 🔴        | 1F534       | LARGE RED CIRCLE        | LED colour state indicator (red)        |

**Not permitted** (use approved equivalent instead):

| Character | U+    | Name                       | Use instead  |
|-----------|-------|----------------------------|--------------|
| ✅        | 2705  | WHITE HEAVY CHECK MARK     | `✔` (U+2714) |
| ✓         | 2713  | CHECK MARK                 | `✔` (U+2714) |

---

## Group D - Board Layout Diagrams (Board_Layout.md files ONLY)

Box-drawing characters are permitted **exclusively in `Board_Layout.md` files** for
creating visual component placement and connector diagrams. They must not appear in
Design_Spec.md, BOM, or any other document type.

### Light box-drawing

| Character | U+    | Name                                      |
|-----------|-------|-------------------------------------------|
| ─         | 2500  | BOX DRAWINGS LIGHT HORIZONTAL             |
| │         | 2502  | BOX DRAWINGS LIGHT VERTICAL               |
| ┌         | 250C  | BOX DRAWINGS LIGHT DOWN AND RIGHT         |
| ┐         | 2510  | BOX DRAWINGS LIGHT DOWN AND LEFT          |
| └         | 2514  | BOX DRAWINGS LIGHT UP AND RIGHT           |
| ┘         | 2518  | BOX DRAWINGS LIGHT UP AND LEFT            |
| ├         | 251C  | BOX DRAWINGS LIGHT VERTICAL AND RIGHT     |
| ┤         | 2524  | BOX DRAWINGS LIGHT VERTICAL AND LEFT      |
| ┬         | 252C  | BOX DRAWINGS LIGHT DOWN AND HORIZONTAL    |
| ┴         | 2534  | BOX DRAWINGS LIGHT UP AND HORIZONTAL      |
| ┼         | 253C  | BOX DRAWINGS LIGHT VERTICAL AND HORIZONTAL |

### Double box-drawing

| Character | U+    | Name                                          |
|-----------|-------|-----------------------------------------------|
| ═         | 2550  | BOX DRAWINGS DOUBLE HORIZONTAL                |
| ║         | 2551  | BOX DRAWINGS DOUBLE VERTICAL                  |
| ╔         | 2554  | BOX DRAWINGS DOUBLE DOWN AND RIGHT            |
| ╗         | 2557  | BOX DRAWINGS DOUBLE DOWN AND LEFT             |
| ╚         | 255A  | BOX DRAWINGS DOUBLE UP AND RIGHT              |
| ╝         | 255D  | BOX DRAWINGS DOUBLE UP AND LEFT               |
| ╠         | 2560  | BOX DRAWINGS DOUBLE VERTICAL AND RIGHT        |
| ╣         | 2563  | BOX DRAWINGS DOUBLE VERTICAL AND LEFT         |
| ╦         | 2566  | BOX DRAWINGS DOUBLE DOWN AND HORIZONTAL       |
| ╩         | 2569  | BOX DRAWINGS DOUBLE UP AND HORIZONTAL         |
| ╬         | 256C  | BOX DRAWINGS DOUBLE VERTICAL AND HORIZONTAL   |

---

## Requesting New Characters

If you require a non-ASCII character not listed above, raise it with the repository owner
before use. Provide:

1. The character and its Unicode codepoint
2. The context and document type where it will be used
3. The reason an ASCII equivalent is insufficient
