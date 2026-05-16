# Intel / Altera MAX II EPM570T100I5N CPLD - Datasheet Summary

## Source Reference

- **Source document:** [Intel_max2_cpld-handbook.md](Intel_max2_cpld-handbook.md)
- **Source PDF:** [Intel_max2_cpld-handbook.pdf](Intel_max2_cpld-handbook.pdf)
- **Note:** This is a part-specific summary synthesised from the MAX II Device Handbook.
  All electrical values are sourced directly from the handbook. Consult the full handbook
  for architecture details, timing diagrams, JTAG programming flows, and PCB layout guidance.

## Part Identity and Ordering

| Field | Value |
| :--- | :--- |
| Manufacturer | Intel / Altera (formerly Altera Corporation) |
| Part Number | EPM570T100I5N |
| Family | MAX II CPLD |
| Density | 570 Logic Elements (440 equivalent macrocells) |
| Package | 100-pin Plastic Thin Quad Flat Pack (TQFP-100) |
| Speed Grade | -5 |
| Temperature Grade | I = Industrial (-40 °C to +100 °C junction) |
| Lead-free | N suffix = lead-free, RoHS-compliant |
| Power Variant | Standard (no suffix) - **not** G (Green/low-power) or Z variant |

### Ordering Code Breakdown

```text
 |    |   |    |   |   |  |
 |    |   |    |   |   |  +-- N = lead-free
 |    |   |    |   |   +----- Speed grade (-5)
 |    |   |    |   +--------- Temp grade (I = Industrial)
 |    |   |    +------------- Pin count (100)
 |    |   +------------------ Package (T = TQFP)
 |    +---------------------- Density (570 LEs)
 +--------------------------- Family (MAX II)
```

**Important variant distinction:**

| Variant | VCCINT Supply | Internal Core Regulation |
| :--- | :--- | :--- |
| EPM570 (standard, **our part**) | 3.3 V or 2.5 V external | On-chip LDO generates 1.8 V core internally |
| EPM570**G** (Green/low-power) | 1.8 V external only | External supply drives core directly - no internal LDO |
| EPM570**Z** (ultra-low-power) | 1.8 V external only | External supply drives core directly - no internal LDO |

> **If the part number does not include the G or Z suffix, it is the standard variant and
> requires a 3.3 V or 2.5 V VCCINT supply. No external 1.8 V rail is needed.**

## Power Supply Requirements

### Absolute Maximum Ratings (from Table 5-1 of handbook)

| Symbol | Parameter | Min | Max | Unit |
| :--- | :--- | :---: | :---: | :---: |
| VCCINT | Internal supply voltage | -0.5 | 4.6 | V |
| VCCIO | I/O supply voltage | -0.5 | 4.6 | V |
| VI | DC input voltage | -0.5 | 4.6 | V |
| IOUT | DC output current per pin | -25 | 25 | mA |
| TJ | Junction temperature (under bias) | - | 135 | °C |

### Recommended Operating Conditions (from Table 5-2 of handbook)

| Symbol | Parameter | Min | Nom | Max | Unit |
| :--- | :--- | :---: | :---: | :---: | :---: |
| VCCINT | 3.3 V supply for internal logic and ISP | 3.00 | 3.3 | 3.60 | V |
| VCCINT | 2.5 V supply for internal logic and ISP | 2.375 | 2.5 | 2.625 | V |
| VCCIO | I/O supply - 3.3 V operation | 3.00 | 3.3 | 3.60 | V |
| VCCIO | I/O supply - 2.5 V operation | 2.375 | 2.5 | 2.625 | V |
| VCCIO | I/O supply - 1.8 V operation | 1.71 | 1.8 | 1.89 | V |
| VCCIO | I/O supply - 1.5 V operation | 1.425 | 1.5 | 1.575 | V |
| TJ | Junction temperature (industrial) | -40 | - | 100 | °C |

> **Note:** The voltage regulator is not guaranteed for VCCINT values between the 2.5 V
> maximum and the 3.3 V minimum (i.e. approximately 2.625 V to 3.00 V). Do not operate
> VCCINT in this intermediate range.

### MultiVolt Core Architecture

The standard MAX II device (EPM570, not G/Z) integrates an **on-chip linear voltage regulator**
that accepts 3.3 V or 2.5 V on the VCCINT pins and regulates the supply down to an internal
1.8 V core voltage. This is transparent to the board designer - **no external 1.8 V rail is
required** when powering VCCINT from a 3.3 V supply.

The VCCIO pins are independent and can be set to 1.5 V, 1.8 V, 2.5 V, or 3.3 V to match
the I/O voltage standard of each I/O bank. Multiple VCCIO voltages can be used simultaneously
across different banks.

## Package Information

- Package: 100-pin Plastic Thin Quad Flat Pack (TQFP)
- Designation in handbook: TQFP-100
- Section 7 of the handbook contains the package outline drawing (Figure 7-2).

## Device Features Summary (EPM570)

| Feature | Value |
| :--- | :--- |
| Logic Elements | 570 |
| Equivalent Macrocells | 440 (typical) / 240-570 (range) |
| Maximum User I/O pins | 160 |
| UFM (User Flash Memory) | 8,192 bits |
| Speed grades available | -3, -4, -5 |
| tPD1 (pin-to-pin delay, speed -5) | 6.2 ns |
| fCNT (counter frequency) | 304 MHz |
| tSU | 1.2 ns |
| tCO | 4.6 ns |
| In-system programming | IEEE 1532 / JTAG |
| Hot-socketing | Supported |
| Power-on reset | Integrated |
| Internal oscillator | Included (3.3-5.5 MHz, for UFM timing) |
