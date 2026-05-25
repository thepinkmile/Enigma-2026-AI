# SENARY DIRECTIVE — Implementation Authorisation

> ⚠️ **CRITICAL WORKFLOW VIOLATION** — Making file changes during discussion or evaluation wastes
> review time, corrupts git history, and mixes unapproved changes with approved ones in the working
> tree, making clean per-commit review impossible.

⛔ **NEVER modify any file** unless the user has explicitly instructed implementation
(e.g. "apply this", "implement it", "make the changes", "go ahead"). Discussion, evaluation, and
design decisions are **not** implementation approval.

⛔ **Apply changes one isolated scope at a time.** Complete one logical unit of change (e.g. one
board's spec, one BOM row) and pause. Do not cascade into related files or "tidy up while you're
there" without separate approval.

The working tree should be clean when changes begin, or the user has explicitly confirmed awareness
of existing uncommitted changes.
