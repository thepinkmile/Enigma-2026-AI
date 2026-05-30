# Architecture Specification: Multi-Stack Routing Sequence and System Dataflow

## 1. System Topology Overview
The digital Enigma machine architecture consists of up to 6 horizontally chained mini-stacks, driven by a system host (Compute Module 5). Each physical mini-stack features the following internal components:
- Rotor Assembly: 5 physical rotor boards mapped inside an Altera MAX II EPM570 CPLD.
- Position Sensing: Dual-track Gray-code encoders mapped on all 5 rotors, accessed simultaneously via a JTAG Boundary Scan chain.
- Boundary Controllers: Two independent RP2040 microcontrollers per mini-stack acting as ingress and egress route handlers:
  * Ingress RP2040 (Rotor Entrance / Left Side): Captures keyboard signals and initial inputs. Routes the return-pass signal to plugboards, adjacent stacks, or the lampboard.
  * Egress RP2040 (Rotor Exit / Right Side): Receives transformed data from the 5th rotor. Routes the forward-pass signal to alternative components, plugboards, or adjacent stacks.

---

## 2. Structural Signal Routing Map
A single keypress executes a multi-stage, synchronized parallel routine divided into a physical movement phase, a position verification phase, and a multi-pass combinatorial routing phase.

### Phase 1: Key Initialization and Universal Actuation
- Event 1: The operator presses a key on the matrix keyboard.
- Event 2: The keyboard module instantly surfaces the 6-bit input character data array (ENC_IN) and drives the global active-low interrupt line (ENC_ACTIVE_N) down to 0V.
- Event 3: The Ingress RP2040 on the active mini-stack intercepts ENC_ACTIVE_N and instantly triggers the local 5V MOSFET actuator circuit to physically step the rotor assembly.

### Phase 2: Parallel JTAG Capture and Ingress Setup
While the mechanical servos step the rotor positions into alignment, the system executes two tasks in parallel:
- Task A (JTAG Boundary Scan): The CM5 Host or designated JTAG master executes a SAMPLE/PRELOAD boundary scan transaction over the EPM570 CPLD chain. It clocks out the absolute Gray-code positions of all 5 rotors in a single pass to confirm mechanical orientation against the software domain state table.
- Task B (Signal Injection): The Ingress RP2040 injects the initial 6-bit character data into the first rotor pad of the localized CPLD matrix.

### Phase 3: The Forward Transformation and Routing Loop
- Step 1: The data travels combinationally through the internal matrix arrays of the 5 clustered rotors inside the CPLD.
- Step 2: The Egress RP2040 on the opposite side of the mini-stack captures the transformed 6-bit output data stream.
- Step 3: The Egress RP2040 evaluates its locally stored, pre-cached configuration table to determine the target routing vector. It forwards the data over the SPI daisy-chain bus to its designated destination:
  * Destination Option A: Directly into Plugboard Pass 1 or Plugboard Pass 2.
  * Destination Option B: Forward into the input header of the next sequential Mini-Stack in the chain.
  * Destination Option C: Instant turnaround into the Reflector module to initiate the return pipeline.

### Phase 4: The Return Transformation and Lamp Rendering
- Step 1: The reflected signal enters the return path of the CPLD rotor network, propagating backward through the 5 internal rotors in reverse order.
- Step 2: The Ingress RP2040 receives the final backward-transformed cryptographic byte.
- Step 3: The Ingress RP2040 checks its pre-cached routing configuration array and switches the data line to its designated return target:
  * Destination Option A: Divert to Plugboard Pass 1 or Plugboard Pass 2 for post-cryptographic modification.
  * Destination Option B: Pass backward to the previous Mini-Stack module in the sequence.
  * Destination Option C: Direct output payload straight to the hardware Lightboard (Lampboard) driver matrix to light up the corresponding output character lamp.

---

## 3. Textual System Flow Diagram Layout

The textual flow trace below maps out the precise input-to-output sequence across the subsystem boundaries.

~~~
Keypress on Keyboard Matrix
  │
  ├──► Generates Input Data (ENC_IN Data Bits)
  └──► Pulls Global Interrupt Low (ENC_ACTIVE_N Line)
        │
        ├──► Trigger Ingress RP2040: Fires 5V MOSFETs to actuate Servos
        │      │
        │      └──► Parallel Thread: Wait for Mechanical Step Completion (45ms)
        │             │
        │             └──► Execute JTAG SAMPLE Boundary Scan
        │                    │
        │                    └──► Shift out all Gray-code track values via TDO
        │
        └──► Ingress RP2040 feeds character payload into the Stator side
               │
               ▼
   [ ROTOR TRANSFORMATIONS: 1 to 5 inside CPLD ]
               │
               ▼
    Egress RP2040 captures output byte from 5th Rotor
               │
               ▼ (Instant Lookup via Pre-configured Route Tables)
    Route selection choice handles Forward Routing to:
       ├──► Plugboard Pass 1 / Pass 2
       ├──► Next Mini-Stack Module Input Header
       └──► Reflector Module (Path Inversion Boundary)
              │
              ▼ [ Signal Reverses Direction ]
   [ REVERSE ROTOR TRANSFORMATIONS: 5 to 1 inside CPLD ]
              │
              ▼
    Ingress RP2040 captures returned cryptographic byte
              │
              ▼ (Instant Lookup via Pre-configured Route Tables)
    Route selection choice handles Return Routing to:
       ├──► Plugboard Pass 1 / Pass 2
       ├──► Previous Mini-Stack Module Input Header
       └──► Output Lampboard Driver Matrix ──► Illuminates Target Enigma Lamp
~~~

---

## Technical Supplement Addendum: Concurrent Dual-Bus SPI Interleaving Architecture

### 1. Concurrency Model Overview

To minimize propagation delay across the modular subsystem, the Layer 2 native C++ daemon replaces single-threaded execution with a dual-threaded, asynchronous pipelined architecture. The system exploits the physical detachment of the Forward and Return hardware signal paths by assigning each to an isolated kernel thread bound to dedicated hardware processor cores.

### 2. Pipelined Interleaving Mechanics

The communication infrastructure uses two distinct hardware SPI controllers on the CM5 host operating in parallel:
- Forward Bus Thread: Anchored to Core 2 (SCHED_FIFO, Priority 85). Natively polls all Egress RP2040 nodes, capturing forward cryptographic transformations from the fifth rotor of the active mini-stacks.
- Return Bus Thread: Anchored to Core 3 (SCHED_FIFO, Priority 85). Natively polls all Ingress RP2040 nodes, injecting inverted data back down the return path toward plugboard passes and the lampboard driver matrix.

Data exchange between the two threads occurs via a lock-free, single-producer single-consumer (SPSC) atomic memory ring buffer located entirely within local host RAM. When the Forward Thread reads a transformation snapshot, it writes the 6-bit token into the atomic channel. The Return Thread picks up the token on its next interleaved clock phase. This local memory boundary handover bypasses the Docker container bridge and Linux network layer entirely during mid-flight routing steps, preserving sub-millisecond round-trip latencies.

### 3. Hardware and Layout Constraints

- Spatial Shielding: Forward and Return SPI signal lines must be completely isolated on Inner Layer 3 by an unbroken Digital Ground (GND) shield trace to prevent high-frequency capacitive crosstalk or clock edge bleeding at 25 MHz operating frequencies.
- Core Affinity Binding: Strict implementation of pthread_setaffinity_np is mandatory to prevent the Linux kernel scheduler from migrating threads across CPU cores, completely neutralizing context-switch jitter anomalies.

---

## Technical Supplement Addendum: Synchronized CPLD-Driven Hardware Sequencing

### 1. Hardware-Triggered Actuation Isolation

The architecture eliminates JTAG bus contention and OS-level race conditions by delegating the initial step sequence entirely to direct, high-speed combinatorial hardware loops managed by the Altera MAX II EPM570 CPLD. 

The global ENC_ACTIVE_N interrupt line is driven as a direct I/O signal from the keyboard matrix into the CPLD. The boundary RP2040 microcontrollers treat this line as a dedicated hardware input interrupt. 

### 2. Deterministic Execution Sequence

When a key is depressed, the system executes according to the following strict timeline:

- Time 0ms: ENC_ACTIVE_N falls low via direct I/O. The CPLD instantly reflects this state change to all stacked modules. The RP2040 microcontrollers detect this edge and instantly trigger the local 5V MOSFET actuator circuits to fire the rotor servos. No data is read or shifted on the SPI or JTAG lines during this transition.
- Time 0ms to 45ms (Mechanical Window): The servos physically translate the rotors into position. High-current inductive noise on the 9A power rails peaks and completely dampens out. Both the SPI and JTAG lines remain completely quiet.
- Time 45ms (Capture Window): The mechanical step is complete, and electrical rails have returned to a stable, quiet state. 
- Time 45.1ms (Parallel Execution): The CM5 or hardware JTAG master initiates the JTAG SAMPLE Boundary Scan, shifting out the absolute Gray-code positions of all rotors via TDO in a single pass. In parallel, the first Ingress RP2040 injects the initial ENC_IN character data array into the first rotor of the first mini-stack.

### 3. Engineering Advantages

This topology guarantees that the edge-sensitive JTAG Test Access Port (TAP) data lines (TCK, TMS, TDO) never toggle while 9A servo switching spikes are present on the board. Alignment verification and initial cryptographic data injection happen under ideal, electrically quiet conditions.

---
