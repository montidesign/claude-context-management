---
name: handoff
description: Save this session's state and full history to .context/ so the next session can pick up after /clear without re-reading the old conversation. Use when the user says handoff, wrap up, save progress, checkpoint, end the session, or is about to /clear, or when the context window is getting full.
---

# Handoff

Record where the work stands so the user can `/clear` and continue in a fresh, cheap session.
Two audiences:

- **The next session** reads only `.context/STATE.md`; a SessionStart hook loads it automatically. Keep it short.
- **The user, later**, reads history and decisions to rehash *why* something was decided. These files are
  never loaded automatically, so their length costs nothing until someone asks. Write them in full: thin
  history is the failure mode here, not long history.

Write only inside `.context/` in the project root. Create the folders if missing.

## 1. Gather

Work from this conversation; re-read files only to confirm a detail. Run `git status --short` and
`git log --oneline -10` for files changed and commits made. Note the current branch.

## 2. Append the session log: `.context/history/YYYY-MM-DD-<short-slug>.md`

One file per session (append with a `---` separator if this session already wrote one). Cover everything a
reader would need to reconstruct the reasoning without the transcript:

```markdown
# YYYY-MM-DD: <title>
Session: ${CLAUDE_SESSION_ID} (reopen with `claude --resume <id>`) · Branch: <branch>

## Goal
What the user asked for, in their words where it matters.

## What happened
Chronological narrative: approach, what was tried, what was found, how the plan changed and why.

## Decisions
For each: the decision, the options considered, why this one won, why the others lost, and what drove
it (user preference, constraint, evidence). Quote the user when their words set the direction.
Major decisions also go to decisions.md (step 3); link the entry here.

## Dead ends
What was tried and failed, and why, so no one retries it.

## Evidence
Commands, errors, benchmarks, links, and doc sources that informed the work. Paste the short, decisive
lines; for long output, give the path or command to regenerate it.

## Files changed
- `path`: what changed and why

## Follow-ups
Open questions, known gaps, and things deliberately deferred.
```

If the Session line above shows a placeholder and not an actual ID, leave the ID out.

## 3. Append lasting decisions: `.context/decisions.md`

Add an entry for each decision that shapes the project beyond this task (architecture, tools, conventions,
scope calls, anything the user may later ask "why did we…" about). Never rewrite past entries. When a
decision changes, add a new entry that names the one it supersedes.

```markdown
## D-NNN: <title>
Date: YYYY-MM-DD · Status: accepted | superseded by D-NNN · Session log: history/<file>.md

**Context**: the problem and constraints at the time.
**Options considered**: each, with its trade-offs.
**Decision**: what was chosen.
**Why**: the reasoning, including the user's stated reasons.
**Consequences**: what this commits us to, and what to revisit if circumstances change.
```

## 4. Overwrite the current state: `.context/STATE.md`

The next session's starting point. At most about 40 lines; it loads at the start of every session.

```markdown
# State
Updated: YYYY-MM-DD HH:MM · Branch: <branch>

## Goal
One or two lines.

## Done so far
- Key completed items (most recent first; drop old ones once they no longer help the next step)

## Next
- [ ] Concrete next actions, in order

## Open questions / blockers
- ...

## Pointers
- Last session: history/<file>.md
- Key files: `path`: why it matters
```

## 5. Leave memory to auto memory

Corrections, user preferences, and general lessons belong in Claude Code's auto memory, not in `.context/`.
Save one there only if it came up this session and isn't already recorded.

## 6. One-time cleanup check

If the project has the old layout from this kit's earlier template (`.context/tool-outputs/`,
`.context/terminal/`, `.context/mcp/`, `.context/skills/`, or a "Context Management System" section in
CLAUDE.md), tell the user they're no longer needed and offer to remove them. Don't remove anything
without their go-ahead.

## 7. Report

Reply in two or three lines: what was saved and where, then "Run `/clear` to continue; STATE.md will
load automatically."
