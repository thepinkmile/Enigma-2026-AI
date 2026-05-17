# review-clean-passes-gate

**Status:** pending  
**Blocked by:** all `review-pass-x` todos (see Dependencies below)

## Purpose

This is a collective gate todo that remains open until **two consecutive clean review
passes** have been achieved. It aggregates every `review-pass-x` as a dependency so
that no downstream work (e.g. `consolidate-design-spec-content`) can be considered
ready until the full review-pass chain is complete.

**Closing criteria:** mark this todo `done` manually when the last two completed
review passes both returned zero new findings (or all findings were pre-existing,
tracked, and deferred intentionally). Do not close this gate on a pass that opened
new items.

## Dependencies

| Review Pass | Status |
|---|---|
| `review-pass-7` | done |
| `review-pass-8` | done |
| `review-pass-9` | done |
| `review-pass-10` | done |
| `review-pass-11` | pending |
| `review-pass-12` | pending |

> **Maintenance note:** When a new `review-pass-x` todo is created, add it to:
> 1. The table above (this file)
> 2. The `todo_deps` SQL block in `.copilot/todo-list.md` under the
>    `review-clean-passes-gate` section
> 3. The session DB at session start (or immediately if the session is live)

## Downstream todos gated by this item

- `consolidate-design-spec-content` — cannot consolidate specs until clean passes achieved
