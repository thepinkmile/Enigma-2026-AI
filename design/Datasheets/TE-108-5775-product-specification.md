# TE Connectivity Product Specification 108-5775 - 2.5 mm Pitch Battery Connector

## Source

- Source PDF: [TE-1-1674231-1-product-specification.pdf](TE-1-1674231-1-product-specification.pdf)
- Generated Markdown: `TE-108-5775-product-specification.md`
- Document Number: 108-5775 Rev. B2 (also referenced as 3-5775 in legacy TE/AMP notation)
- Date: 18 JUL 2019
- Originator: Tyco Electronics AMP K.K.
- Conversion method: manual extraction from 10-page PDF (full page-by-page review)

## Reviewed Summary

This document is the electrical and environmental Product Specification for the TE Connectivity 2.5 mm pitch battery connector family. It covers both the plug (`1-1123684-7`) and receptacle
(`1-1674231-1`) parts covered by this specification, and is the authoritative source for all rated electrical and environmental parameters for those parts.

**Applies to (Appendix 2):**

- `1-1123684-7` / `1123684-7` - Plug Connector, 10 positions
- `1-1674231-1` - Receptacle Connector, 10 positions

## Electrical Ratings (§3.3)

| Parameter | Specification |
| --- | --- |
| Voltage Rating | 30V DC max |
| Current Rating | **6A per contact** |
| Operating Temperature | **-20°C to +80°C** (see temperature note below) |

## Materials (§3.2)

| Parameter | Specification |
| --- | --- |
| Contact material | Copper alloy |
| Contact finish | Nickel underplate; gold plating at contact area; gold/tin at solder area |
| Housing material | Thermoplastic moulding compound, black, UL94 V-0 |

## Electrical Performance (§3.5)

| Test | Specification |
| --- | --- |
| Contact resistance - initial | 30 mΩ max (20 mV open-circuit, 10 mA test current) |
| Contact resistance - change after tests (ΔR) | 20 mΩ max |
| Dielectric withstanding voltage | 1 kVAC for 1 minute; leakage ≤ 0.5 mA |
| Insulation resistance - initial | ≥ 1,000 MΩ (500V DC for 1 minute) |
| Insulation resistance - after tests | ≥ 100 MΩ |
| **Temperature rise at rated current** | **30°C max at 6A rated current** (tested per AMP Spec 109-5310) |
| Solderability (reflow) | 230 ± 5°C, 3 ± 0.5 s |
| Solderability (manual iron) | 350 ± 10°C, 3 s |

## Environmental Qualification (§3.5)

| Test | Conditions | Pass Criterion |
| --- | --- | --- |
| Physical shock (§3.5.10) | 50G half-sine, 11 ms; 18 drops | No discontinuity > 0.1 µs; ΔR ≤ 20 mΩ |
| **Thermal shock (§3.5.12)** | **-40°C / 30 min ↔ +85°C / 30 min x 5 cycles** | **ΔR ≤ 20 mΩ** |
| Humidity-temperature cycling (§3.5.13) | 25-65°C, 90-95% RH, 24h cycles x 10; -10°C cold shock | ΔR ≤ 20 mΩ |
| Salt spray (§3.5.14) | 5% NaCl, 35°C, 24 h | ΔR ≤ 20 mΩ |
| Industrial gas - SO₂ (§3.5.15) | 10 ppm SO₂, 95% RH, 25°C, 24 h | ΔR ≤ 20 mΩ |
| Temperature life / heat aging (§3.5.17) | 85°C, 96 hours (mated) | ΔR ≤ 20 mΩ |

## Extraction Notes

- Full 10-page spec reviewed manually; all key ratings transcribed above.
- Pages 1-5: scope, purpose, applicable documents, materials, dimensions.
- Pages 6-8: electrical test procedures and results.
- Pages 9-10 (Appendix 2): applicable part number list confirming both project parts.
