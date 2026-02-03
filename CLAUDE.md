# Project: [Name]

## Description
[Brief description of what this project does]

---

## Context Management System

This project uses dynamic context discovery to reduce context bloat and preserve important information across sessions.

### Directory Structure
```
.context/
├── tool-outputs/   # Saved long command outputs (>50 lines)
├── history/        # Session logs and decisions
├── mcp/            # MCP tool descriptions by server
├── skills/         # Reusable task instructions
│   └── scripts/    # Helper scripts
├── terminal/       # Terminal session logs
└── project/        # Project overview, patterns, decisions
```

### Rule 1: Long Output Handling
When any command, tool, or MCP returns output greater than 50 lines:

```bash
# Save and summarize
command 2>&1 | tee .context/tool-outputs/$(date +%Y%m%d-%H%M%S)-[name].md

# Or use helper script
.context/skills/scripts/save-output.sh "command" "description"
```

Keep only a summary (first 10 + last 10 lines) in working memory. Retrieve details with:
```bash
tail -50 .context/tool-outputs/[file].md
grep "pattern" .context/tool-outputs/*.md
```

### Rule 2: Session Documentation
After completing significant tasks, document the session:

```bash
.context/skills/scripts/new-session.sh "Task Description"
```

Or manually add to `.context/history/[YYYY-MM-DD].md`:
- Task summary and approach taken
- Key decisions with rationale
- Files modified
- Issues encountered and solutions
- Next steps

### Rule 3: Skill Discovery
Before specialized tasks, search for existing skills:

```bash
# Find relevant skills
grep -l "keyword" .context/skills/*.md

# Read the skill
cat .context/skills/[skill-name].md

# List all skills
cat .context/skills/INDEX.md
```

Create new skills when you discover reusable patterns.

### Rule 4: MCP Tool Lookup
MCP tool descriptions are stored in `.context/mcp/[server-name]/`:

```bash
# See available servers
ls .context/mcp/

# List tools for a server
cat .context/mcp/[server]/_INDEX.md

# Get tool details (only when needed)
cat .context/mcp/[server]/[tool].md
```

### Rule 5: Terminal Logging
For important or long-running commands:

```bash
# Log output
npm run dev 2>&1 | tee .context/terminal/$(date +%Y%m%d-%H%M%S)-dev-server.log

# Background with logging
npm run dev > .context/terminal/dev-server.log 2>&1 &
```

Retrieve with:
```bash
tail -100 .context/terminal/[file].log
grep -i "error" .context/terminal/*.log
```

### Quick Reference
```bash
# Recent session history
cat .context/history/$(ls -t .context/history/*.md 2>/dev/null | head -1)

# Search saved outputs
grep -rn "pattern" .context/tool-outputs/

# Find skills by topic
grep -l "database\|migration" .context/skills/*.md

# Recent errors in terminal
grep -i "error\|fail" .context/terminal/*.log | tail -20

# Cleanup old files
.context/skills/scripts/cleanup.sh 7
```

### Project Context
Before starting work, review:
- `.context/project/overview.md` - Project summary and tech stack
- `.context/project/patterns.md` - Code conventions
- `.context/project/decisions.md` - Architecture decisions (ADRs)
