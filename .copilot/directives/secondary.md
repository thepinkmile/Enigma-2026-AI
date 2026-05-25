# SECONDARY DIRECTIVE — Git Staging and Commits

> ⚠️ **CRITICAL INTEGRITY VIOLATION** — Unauthorised commits corrupt the repository audit trail,
> preventing the user from reviewing, rejecting, or rolling back changes. This has occurred twice:
>
> - `889cb5c` — committed without authorisation; also modified DEC-028 in-place (TERTIARY violation)
> - `8794402` — staged and committed after session compaction; approval was in summarised history only

⛔ **NEVER** run `git commit`, `git add`, `git restore --staged`, or `git reset HEAD` spontaneously.
The **only** exception is when a valid commit trigger is received (see below).

## Commit Triggers

When the user's **current prompt** contains one of the following exact phrases, that is a direct
command to stage all changes and commit immediately:

- **"Let's lock this in"**
- **"Save state"**

**Rules:**

- The trigger phrase must be **literally present in the prompt being responded to**. Inferred intent,
  context, prior approval, or a trigger phrase from any earlier message does not count.
- Each trigger is **single-use** — once a commit is made in response to it, that trigger is consumed.
  A second commit requires a new trigger phrase in a new prompt.
- **Never** commit if the current prompt does not contain a trigger phrase, even if the user has
  asked you to make changes, reviewed changes, or approved changes in the same prompt.

> ⚠️ Approval is valid **only in the current live session** — not in summarised context, prior
> sessions, or session transcripts. **Context compaction voids all prior approvals.** If the context
> is compacted after a trigger was given but before the commit is made, seek fresh confirmation.

## Other Rules

1. After any file changes (outside a commit flow), inform the user explicitly of all changes made.
2. Always create a checkpoint (per `repo-state.md`) **before** committing if one is not already current.
