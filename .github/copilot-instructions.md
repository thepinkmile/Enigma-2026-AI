# Copilot Instructions

## Initialization

Please load session state from the repo-local `.copilot` directory starting with committing the agent-directives to memory, then plan.md and handoff.md
and the checkpoints in the checkpoints subdirectory.

## Build, test, and lint

- From the repo root, lint Markdown with `.\node_modules\.bin\markdownlint.cmd "design/**/*.md"`. To lint a single file, run `.\node_modules\.bin\markdownlint.cmd .\README.md`.
- Build the only executable project with `dotnet build .\src\Software\GUI_App\EnigmaNG.sln`.
- Run the desktop app with `dotnet run --project .\src\Software\GUI_App\GUI_App.csproj`.
- Publish the CM5-targeted Linux build with `dotnet publish .\src\Software\GUI_App\GUI_App.csproj /p:PublishProfile=Properties\PublishProfiles\linux-arm64.pubxml`.
- There are currently no automated test projects in the repository.
  `dotnet test .\src\Software\GUI_App\EnigmaNG.sln` restores and builds the
  solution, but there is no single-test command yet because no test assembly
  exists.

## High-level architecture

- This repository is design-first. The `design\` tree is the primary source of
  truth for the system: electronics, mechanical, software, standards,
  procedures, and design decisions all live there. `src\Software\GUI_App\` is
  currently a minimal Avalonia/.NET 10 shell rather than the main body of
  project knowledge.
- The system itself is split across hardware modules that must be read together
  to understand the whole machine: **Power Module -> Controller Board (CM5
  carrier) -> Stator -> Extension/Reflector + up to 30 Rotor boards**.
  Link-Alpha carries power/telemetry between Power Module and Controller, while
  Link-Beta carries JTAG and encryption-stack interfaces between Controller and
  Stator.
- Software behavior is defined across both code and docs. Board
  `Design_Spec.md` files describe connectors, GPIO ownership, rail names, and
  I2C devices; `design\Software\Linux_OS\Power_Management.md` defines CM5
  shutdown and telemetry behavior; `design\Software\GUI_App\Design_Spec.md`
  describes the intended dashboard and hardware-facing GUI features.
- The GUI app follows a standard Avalonia MVVM shape: `Program.cs` bootstraps Avalonia, `App.axaml*` wires the application lifetime, and `Views\` / `ViewModels\` hold UI and view-model code.

## Key conventions

- Design specs follow a stable format: metadata header (`Status`, `Project`,
  `Author`, `Version`, `Associated Hardware Revision`, `Last Updated`)
  followed by requirement tables with IDs like `FR-CTL-01` and `DR-STA-07`.
  Preserve those IDs and cross-references instead of renumbering them casually.
- Architectural decisions are tracked centrally in `design\Design_Log\` (per-DEC files, index at `design\Design_Log\index.md`) as
  `DEC-NNN` entries. If a change alters a design rationale or reverses an
  established choice, update the affected `Design_Spec.md` file and the
  decision log together.
- Treat `design\Electronics\Consolidated_BOM.md` as the shared BOM authority across boards. Parts marked `🔒` require owner approval before they are changed.
- Keep system naming exact. Use `3V3_ENIG` for the shared 3.3V rail, and treat `ENC_IN` / `ENC_OUT` as names from the Enigma machine's perspective rather than the CM5's perspective.
- Board-level edits are expected to inherit repo-wide rules from
  `design\Standards\Global_Routing_Spec.md`. In practice, routing, stackup,
  grounding, and fabrication assumptions should not be changed only in one
  board spec without checking the standards docs and related board docs.
- Most boards are specified as 4-layer / 2oz designs; the Controller Board is the notable exception and is specified as a 6-layer / 2oz board for high-speed routing.
- Treat `.copilot\` as the canonical repo-local Copilot handoff. At session start, read any relevant plans, checkpoints, or other persisted context from that folder before making changes.
- When a session creates or updates checkpoints, plans, or other Copilot progress artifacts, write them directly into repo-local `.copilot\` or sync them there before declaring the checkpoint complete.
- Syncs into repo-local `.copilot\` must be sanitized for version control: use
  repo-relative paths or `%USERPROFILE%` placeholders instead of
  machine-specific absolute paths, and do not persist raw usernames or Copilot
  session IDs in committed handoff content.
- A checkpoint is not complete until the updated checkpoint file,
  `.copilot\checkpoints\index.md`, `.copilot\plan.md`, and any related agent
  prompt or handoff artifacts all exist in repo-local `.copilot\` in
  sanitized, commit-safe form.
