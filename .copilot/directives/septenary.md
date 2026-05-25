# SEPTENARY DIRECTIVE — Mandatory Sub-Agent Prompt Preamble

> ⚠️ **CRITICAL PROCESS VIOLATION** — Sub-agents in review run F-108 (commits `4b37392`, `c0f5a6f`,
> `f5e6746`) committed without authorisation because prompts omitted the SECONDARY DIRECTIVE.
> Three violations in a single run.

**Every sub-agent prompt — without exception — must begin with the following block:**

```text
STEP 0 — MANDATORY BEFORE ANY OTHER ACTION:
Read `.copilot/directives/index.md` and all directive files it references.
Store every directive as a standing memory you cannot override or ignore.

⛔ GIT IS OFF-LIMITS — SECONDARY DIRECTIVE (non-negotiable):
  NEVER run git commit, git add, git restore --staged, or git reset HEAD (or any equivalent
  staging or unstaging command) under any circumstances. Your ONLY permitted file operations
  are writing, editing, and moving files on disk. Present all changes to the user for review;
  git index control and committing belong solely to the user. The only valid commit trigger is
  the user saying "Let's lock this in" or "Save state" in the current live session context.

Confirm the following before proceeding:
  - SECONDARY DIRECTIVE: GIT IS OFF-LIMITS (see above)
  - PRIMARY DIRECTIVE: NEVER modify any MPN or supplier part number.
  - TERTIARY DIRECTIVE: design/Design_Log/ is append-only — never modify existing DEC-NNN_*.md files.
  - QUATERNARY DIRECTIVE: Never permanently delete files — move to .recycle-bin/ instead.
  - SENARY DIRECTIVE: Never modify any file without explicit implementation approval.
  - BOM CONTENT RULES: BOM tables contain ONLY RefDes, MPN, Manufacturer, Part Spec, Supplier PNs,
    Qty, Notes (procurement only). Never add function descriptions, signal names, or usage notes.
  - SUPPLIER PN PRE-APPROVAL: All supplier PNs are pre-approved and intentional. Never flag or fix them.
Only proceed after all directives are loaded as standing memories.
```

The orchestrating session is responsible for including this block in every sub-agent prompt.
If you are writing a prompt and this block is absent, stop and add it before launching the agent.
