# Lab Tests

**Status:** Draft
**Project:** Enigma-NG
**Author:** Izzyonstage & GitHub Copilot
**Version:** v.0.1.0
**Associated Hardware Revision:** Rev A
**Last Updated:** 2026-04-26

## Overview

This document tracks all lab-bench tests required to confirm or finalise design parameters that
cannot be resolved without physical prototypes. Tests are assigned IDs (`LT-NNN`) and cross-referenced
from relevant design and software specification documents.

Tests must be executed on Rev A prototype hardware before those parameter values are considered
finalised. Results should be recorded in this document and the relevant design files updated where
necessary.

---

## Lab Test Register

| ID | Title | Description | Purpose | Expected Result | Status |
| :--- | :--- | :--- | :--- | :--- | :--- |
| LT-001 | FDC2114 IDRIVE Baseline Calibration | Apply baseline `DRIVE_CURRENT_CHx = 0x7C00` (`IDRIVE = 0b01111`) to a populated Rotor board. Using an oscilloscope probe at the INxA/INxB pads, measure the peak-to-peak sensor drive voltage across the LC tank for each active channel. Adjust `IDRIVE` register field upward or downward until the measured drive is within the 1.2-1.8 Vpk target range documented in TI FDC2114 datasheet §8.4.3. Record the final `IDRIVE` value and update `design/Software/CPLD_Logic/Rotor_Logic.md` §2.1. | Confirm the baseline drive current produces adequate LC tank excitation without exceeding maximum sensor drive. Too low → poor sensitivity; too high → saturation or IC damage. | Sensor drive within 1.2-1.8 Vpk on all active channels at `IDRIVE = 0b01111`, or a revised `IDRIVE` value identified and documented. | Pending prototype |
| LT-002 | fSENSOR Resonant Frequency Validation | With the LC tank assembled (18 µH + 33 pF in parallel between INxA/INxB), use a network analyser or FDC2114 data register read to confirm the measured resonant frequency of each channel. Verify the measured fRES is below 80% of the selected inductor's self-resonant frequency (SRF). Record measured fRES per channel and per board variant (N=26 and N=64 builds). Update `design/Electronics/Rotor/Design_Spec.md` §2.1 with final measured values. | Confirm the selected 18 µH part is suitable for ~6.5 MHz tank operation and that fRES < 0.8 x SRF to ensure valid inductance at operating frequency. | Measured fRES per channel ≈ 6.5 MHz (within ±10%), and fRES < 0.8 x inductor SRF for all channels on both board variants. | Pending prototype |
