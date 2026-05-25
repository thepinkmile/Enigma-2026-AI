# SECONDARY DIRECTIVE — Git Staging and Commits

> ⚠️ **CRITICAL INTEGRITY VIOLATION** — Unauthorised commits corrupt the repository audit trail,
> preventing the user from reviewing, rejecting, or rolling back changes. This has occurred twice:
>
> - `889cb5c` — committed without authorisation; also modified DEC-028 in-place (TERTIARY violation)
> - `8794402` — staged and committed after session compaction; approval was in summarised history only

⛔ **NEVER** run `git commit`, `git add`, `git restore --staged`, or `git reset HEAD`.
Write files to disk only. The user controls the git index entirely.

## Approval Rules

1. After any file changes, stop and inform the user explicitly of all changes made. Do not assume
   they have seen the changes.
2. Approval is valid **only if given in the current live session** — not in summarised context,
   prior sessions, or session transcripts.
3. **Context compaction voids all prior commit approvals.** If the context is compacted after an
   approval was given but before the commit is made, that approval is void. Seek fresh confirmation.
4. Valid commit triggers (current live session only):
   - **"Let's lock this in"**
   - **"Save state"**
5. When a valid trigger is received, create a checkpoint (per `repo-state.md`) **before** committing.
