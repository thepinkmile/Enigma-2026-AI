# Download remaining 3D models for library parts

**ID:** `download-missing-3d-models`
**Status:** pending
**Category:** Library Housekeeping
**Source:** Pass 9 deferred-item resolution session (2026-05-16)
**Blocked by:** —

---

## Description

Download SamacSys/Mouser LIB zips for the following 33 parts that still have no 3D model in `SamacSys_Parts.3dshapes`. Drop each zip into `src\Electronics\Library\temp\` and ask Copilot to import.

For each zip the import pattern is:
1. Copy `.kicad_mod` → `SamacSys_Parts.pretty\` (overwrite if existing)
2. Merge `.kicad_sym` symbol block into `SamacSys_Parts.kicad_sym` (replace existing entry, preserve symbol name)
3. Copy `.stp` → `SamacSys_Parts.3dshapes\`
4. Verify `(model ...)` reference in `.kicad_mod` matches STP filename
5. Move zip and extraction folder to `.recycle-bin\`

## Parts needing download

| # | Footprint / Expected STP name |
|---|---|
| 1 | `101642271004A1RLF` |
| 2 | `11236847` |
| 3 | `1211` |
| 4 | `16742311` |
| 5 | `20074351` |
| 6 | `2195630015` |
| 7 | `484060003` |
| 8 | `B3F1060` |
| 9 | `BEADC2012X110N` |
| 10 | `CAPPRD750W85D1600H2500` |
| 11 | `CSD19531Q5AT` |
| 12 | `DIOM5436X244N` |
| 13 | `DQA(R-PUSON-N10)` |
| 14 | `ERA2AED122X` |
| 15 | `ERA3AEB101V` |
| 16 | `ERA3KV_(0603)` |
| 17 | `ERF8-005-XX.X-YYY-DV-L-K-TR` |
| 18 | `ERJ2RKD1004X` |
| 19 | `ERM8-005-YYYY-XXX-DV-K-TR` |
| 20 | `F52Q1A7H111015` |
| 21 | `HDRV5W64P0X254_1X5_1270X250X850P` |
| 22 | `KRL6432T4MR010FT1` |
| 23 | `LMQ61460AFSQRJRRQ1` |
| 24 | `POE600F12LB` |
| 25 | `QFP50P1600X1600X120-100N` |
| 26 | `QFP50P900X900X160-48N` |
| 27 | `QFP80P900X900X160-32N` |
| 28 | `RS105G` |
| 29 | `SHDR6W50P0X200_1X6_1390X450X600P` |
| 30 | `SM04B-SRSS-TB(LFSN)` |
| 31 | `SRP1265A` |
| 32 | `TPS75933KTTR` |
| 33 | `USB4135GFA` |

## Notes

- Parts imported during the 2026-05-16 session (not in this list): `DF40C20DP04V51`, `DF40HC3520DS04V51`, `TPS23730RMTR`, `TPS25751DREFR`, `TPS259804ONRGER`
- Some ERxx / QFPxx entries may be generic IPC footprint names — confirm whether a part-specific STP is available or if a shared generic model is appropriate
- `ERM8-005-YYYY-XXX-DV-K-TR` had no STP in its original SamacSys package; retry with a fresh download or flag as unavailable
