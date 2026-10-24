# Context Handoff (`ctx`) for Claude Code

Keep Claude Code sessions short without losing project history.

Every message re-sends the whole conversation, so a session kept open as "project memory" makes each
message more expensive than the last. This plugin makes the cheap path easy: finish a stretch of work,
run `/ctx:handoff`, run `/clear`, and keep going in a fresh session that already knows where things stand.

## How it works

| Piece | What it does | Context cost |
|---|---|---|
| `/ctx:handoff` skill | Writes the session log, decision records, and current state to `.context/` | Only when run |
| SessionStart hook | On startup, `/clear`, and compaction, loads `.context/STATE.md` (≤ ~40 lines) | Small, and nothing in projects without one |
| Status line (optional) | Shows context %, 5-hour and 7-day usage, and nudges you to hand off at 60% | None |

What it writes, per project:

```
.context/
├── STATE.md       # Overwritten each handoff: goal, done, next steps, open questions. Auto-loaded.
├── history/       # One detailed log per session: narrative, decisions and alternatives, dead ends,
│                  #   evidence, files changed, and the session ID for `claude --resume <id>`.
└── decisions.md   # Append-only decision records: context, options, choice, why, consequences.
```

`history/` and `decisions.md` are never loaded automatically, so they are written in full. Ask Claude
"why did we choose X?" and it greps them. For the verbatim conversation, reopen the session with
`claude --resume <session-id>` from the history entry.

What it leaves to Claude Code itself:

- **Lessons and preferences**: auto memory (`~/.claude/projects/<project>/memory/`) records corrections and preferences on its own.
- **Large tool output**: Claude Code saves oversized results to a file and keeps only a preview in context.
- **MCP tool descriptions**: tool search loads tool schemas only when needed.

## Install

```bash
claude plugin marketplace add montidesign/claude-context-management   # or a local clone's path
claude plugin install ctx@montidesign
```

Optional status line, in `~/.claude/settings.json` (point the path at your clone):

```json
"statusLine": {
  "type": "command",
  "command": "node \"D:/development/github/claude-context-management/scripts/statusline.mjs\""
}
```

Requires Node.js on PATH.

## Habits that save the most tokens

- One task per session: `/ctx:handoff` then `/clear` between tasks, instead of `/compact`.
- Press Esc twice to rewind a failed attempt instead of correcting it in place.
- Ask Claude to use subagents for broad searches and research; only their conclusions enter your context.
- `/context` shows what is filling the window.
- Raw transcripts are kept for `cleanupPeriodDays` (30 by default). Raise it in settings if you want
  `claude --resume` to reach further back.

## Should `.context/` be committed?

Commit `history/` and `decisions.md` if the team should share the record. `STATE.md` is personal
working state; add `.context/STATE.md` to `.gitignore` if several people work on the repo.

## History

v1 was a project template (a CLAUDE.md rule block plus `.context/` folders and shell scripts), adapted
from [Cursor's dynamic context discovery](https://cursor.com/blog/dynamic-context-discovery) research.
v2 drops the parts Claude Code now does natively and packages the rest as a plugin.
