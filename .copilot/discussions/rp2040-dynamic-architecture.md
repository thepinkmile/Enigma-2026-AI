DOCUMENT TITLE: Consolidated Technical Architecture Specification: Software-Routed, Multi-Bus, Hardware-Accelerated Digital Enigma Machine

SECTION 1: Executive Summary and Design Objective
This document outlines the full engineering specification for a modular, stackable digital Enigma machine architecture. The design completely decouples low-level, real-time hardware interfacing from high-level cryptographic business logic and POS-style user terminal presentation.

By placing an RP2040 microcontroller and an Altera MAX II EPM570 CPLD on every single peripheral board, the system replaces wide 12-pin parallel data interconnect networks with uniform, highly reliable 4-pin SPI lines. The localized CPLDs compress up to 64 individual physical switch matrix inputs or single-hit lamp driver outputs into efficient, native 6-bit binary data arrays. 

The master system host is a Raspberry Pi Compute Module 5 (CM5) running a custom Yocto Linux distribution. The CM5 orchestrates the entire machine across 6 independent hardware SPI buses simultaneously, allowing maximum interleaving of hardware requests and asynchronous processing.

---

SECTION 2: Host Operating System and Application Stack Layout
The system architecture isolates business rules from hardware execution using a containerized microservice pipeline:
- Layer 4 (User Interface): An Avalonia UI cross-platform XAML application compiling down to a native single-binary executable running directly on top of the Yocto Linux framebuffer or X11 surface. It delivers a modern, POS-style terminal interface.
- Layer 3 (Domain Logic Engine): A .NET Core containerized service containing the mathematical Enigma configurations, state machines, odometer tracking logic, and historical mapping variant lookup tables. It shares a common data contract assembly (.dll library) directly with the Layer 4 GUI app to avoid contract duplication.
- Layer 2 (Real-Time Hardware Daemon): A lightweight native host-level C++ binary running under a Linux Real-Time thread priority scheduler (using SCHED_FIFO). It hosts a high-speed gRPC server endpoint to manage communication loopbacks inside the Docker network interface.
- Layer 1 (Hardware Drivers): Native Linux Yocto kernel spidev and gpiochip device drivers interacting directly with the physical BCM2712 silicon pin registers on the CM5.

---

SECTION 3: Distributed Hardware Subsystem Allocation
The architecture allocates the 6 independent hardware SPI controllers on the CM5 across dedicated peripheral branches to ensure concurrent execution:

SPI Bus 1: Dedicated entirely to the Forward Mini-Stack Bus. It addresses the 6 Right-Side Egress RP2040 microcontrollers to capture forward cryptographic rotor transformations.
SPI Bus 2: Dedicated entirely to the Return Mini-Stack Bus. It addresses the 6 Left-Side Ingress RP2040 microcontrollers to inject and recover data during the path-inversion process.
SPI Bus 3: Dedicated entirely to the Keyboard Encoder Board. It polls the single Keyboard RP2040, which reads a 64-input CPLD compression matrix to register physical character input actions.
SPI Bus 4: Dedicated entirely to the Lightboard and Lampboard Output Board. It streams data down to a single Lampboard RP2040, which expands 6-bit tokens via its local CPLD into up to 64 individual lamp illumination lines.
SPI Bus 5: Dedicated entirely to Plugboard Pass 1. It operates across 2 dedicated Plugboard boards (Input and Output boundaries) to execute the preliminary character swappable patching rules.
SPI Bus 6: Dedicated entirely to Plugboard Pass 2. It operates across another 2 dedicated Plugboard boards to process the post-cryptographic text modifications before rendering output text.

---

SECTION 4: Power Delivery Architecture and PCB Stackup Constraints
The system relies entirely on an independent, high-capacity external power distribution board capable of supplying 5V at 9A maximum and 3.3V at 6A maximum. To eliminate voltage sag and ripple from inductive loads without adding local Low-Dropout regulators, the power subsystem relies on massive, segmented bulk storage networks on every single modular board.

Each board implements two entirely separate 5-capacitor bulk reservoir networks arranged in a graduated star topology:
- 5V Actuator Rail: Features 1x 100uF to 220uF Low-ESR Tantalum or Aluminum Polymer central capacitor paired with 4x identical-value ceramic capacitors in parallel. This acts as the heavy energy reservoir for the servo's mechanical transients and stall currents. The tantalum capacitor is rated to at least 10V to protect against aggressive inrush rise times.
- 3.3V Logic Rail: Features 1x 22uF or 47uF Tantalum central capacitor paired with 4x identical-value ceramic capacitors. The natural ESR of the central tantalum capacitor dampens the low-ESR ceramic caps and parasitic trace inductances, eliminating high-frequency ringing and tank-circuit oscillations.

Physical Layer 4-Layer Coaxial Shielded Stackup:
- Layer 1 (Top Layer): Components and a 100 percent pure unbroken Ground Plane (GND). No electrical signal routing is permitted on this layer.
- Layer 2 (Inner Layer 1): Power Pours. Geographically split 3.3V and localized 5V planes. The 5V plane is tightly restricted to a localized boundary directly beneath high-current nodes.
- Layer 3 (Inner Layer 2): High-Speed Signals. All SPI daisy-chain, GPIO, and control lines run exclusively on this layer. Because they are sandwiched between Layer 2 Power and Layer 4 Ground, they form stripline conductors with complete immunity from external EMI.
- Layer 4 (Bottom Layer): A 100 percent pure unbroken Ground Plane (GND) containing zero components and zero signal traces.

Manufacturing Specifications:
- Via Fill: All vias must be resin or copper-filled and planarised with a copper cap (IPC-4761 Type VII Via-in-Pad) to allow direct placement inside SMD component pads without causing solder wicking defects.
- Current-Density Vias: To transition heavy current from Layer 1 down to Layer 2, multi-via clusters are required in parallel: a minimum of 6 to 8 parallel 0.3mm drill filled vias for the 5V rail and a minimum of 4 to 5 parallel 0.3mm drill filled vias for the 3.3V rail.
- RP2040 Core Power: A tiny, isolated 1.1V copper island is carved out on Layer 2 directly under the center footprint of the RP2040 chip to handle DVDD power. The VREG_VOUT pin drops a filled via to this island, and the two DVDD core pins drop filled vias into it, completely isolating the 1.1V loop from the main 3.3V logical plane.

---

## SECTION 5: Three-Phase Operation Sequence Timeline
To guarantee that the edge-sensitive JTAG Test Access Port data lines (TCK, TMS, TDO) never toggle while 9A servo switching spikes are present on the board, execution is split into three deterministic phases driven by the keyboard's physical ENC_ACTIVE_N interrupt line.

Phase 1: Selective Actuation Event
- The operator depresses a key. The Keyboard Encoder board compresses the matrix contact via its local CPLD, and the Keyboard RP2040 surfaces the 6-bit data byte while driving the global active-low interrupt line ENC_ACTIVE_N down to 0V.
- The Master Management Component captures the keyboard interrupt. The CM5 application instantly evaluates internal Enigma odometer stepping states and broadcasts targeted advance commands down the SPI bus. Only the designated Ingress/Egress RP2040 microcontrollers activate their local 5V MOSFET lines to step their respective mechanical rotor assemblies.

Phase 2: Mechanical Damping and JTAG Position Capture
- The system pauses for a 45 millisecond window while the physical rotors step into slot alignment. Inductive switching noise on the 9A power rails peaks and completely dampens out. All high-speed JTAG and SPI lines remain completely quiet.
- Once the mechanical step is verified as complete and the electrical planes are quiet, the JTAG master fires the SAMPLE Boundary Scan over the EPM570 CPLD chain. A snapshot of all dual-track Gray-code encoder positions is shifted out via TDO in a single pass. The .NET Domain Engine verifies that physical orientation matches the expected internal software model indexes.

Phase 3: Interleaved Cryptographic Evaluation Loop
- The initial character token is passed through Plugboard Pass 1 (processed concurrently across SPI Bus 5).
- The resulting byte is handed over to the first Ingress RP2040 on the active mini-stack via local RAM buffers. The data passes combinationally through the 5 internal CPLD rotor matrices.
- The C++ hardware service handles the forward and return paths using independent worker threads pinned to CPU Core 2 and Core 3. The threads interleave the 12 to 18 routing hops across the stack using lock-free single-producer single-consumer atomic memory ring buffers in host RAM, bypassing the Docker container network layers entirely.
- The finalized character token passes through Plugboard Pass 2 (processed concurrently across SPI Bus 6) and is handed over to SPI Bus 4, where the Lampboard RP2040 expands the 6-bit data stream via its CPLD to instantly illuminate the target output lamp.

---

SECTION 6: Peer Review Focus Areas
When submitting this consolidated technical model to your repository for peer discussion, request that reviewers analyze the following key criteria:

- CPU Affinity Partitioning: Is the thread binding layout (pinning the Forward SPI Thread to Core 2 and the Return SPI Thread to Core 3) fully protected against Linux OS scheduler migration jitter?
- JTAG TAP Reference Stability: Does the 45ms mechanical settlement window guarantee that the 9A power rail ground-return plane has achieved a stable 0V reference with zero lingering inductive noise before the SAMPLE boundary scan begins?
- SPI Bus Clock Cross-Talk: Does the allocation of 6 independent hardware SPI buses running up to 25MHz require physical ground shield trace guards on Layer 3 between every adjacent clock routing path to prevent edge-bleeding or capacitive cross-talk?
- Memory Buffer Allocation Costs: Does the rapid creation and instantiation of TaskCompletionSource tracking layers inside the .NET Domain logic during an 18-step loop create garbage collection overhead within an embedded platform footprint?
- Docker Virtual Bridge Latency: Will the high-throughput gRPC stream passing messages for all 6 active hardware SPI buses simultaneously experience any packet serialization delays across the local host loopback interface?
- CPLD Compression Timing: Does the localized compression of 64 inputs into a 6-bit binary token introduce any measurable propagation jitter before the RP2040 reads the signal boundaries?
