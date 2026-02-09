#!/bin/bash
# Claude Context Management - One-command setup
# Usage: curl -sL https://gist.githubusercontent.com/montidesign/GIST_ID/raw/init.sh | bash

set -e

echo "🚀 Setting up Claude Context Management..."

# Create directory structure
mkdir -p .context/{tool-outputs,history,mcp,skills/scripts,terminal,project}

# Create .gitkeep files
touch .context/tool-outputs/.gitkeep
touch .context/terminal/.gitkeep
touch .context/history/.gitkeep
touch .context/mcp/.gitkeep

# Create .gitignore
cat > .context/.gitignore << 'EOF'
tool-outputs/*
terminal/*
!tool-outputs/.gitkeep
!terminal/.gitkeep
EOF

# Create CLAUDE.md
cat > CLAUDE.md << 'EOF'
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
command 2>&1 | tee .context/tool-outputs/$(date +%Y%m%d-%H%M%S)-[name].md
```
Retrieve with `tail`, `head`, or `grep` as needed.

### Rule 2: Session Documentation
After completing significant tasks:
```bash
.context/skills/scripts/new-session.sh "Task Description"
```

### Rule 3: Skill Discovery
Before specialized tasks, search for existing skills:
```bash
grep -l "keyword" .context/skills/*.md
```

### Rule 4: MCP Tool Lookup
MCP tool descriptions are stored in `.context/mcp/[server-name]/`.
Look up tools on-demand rather than loading all descriptions.

### Rule 5: Terminal Logging
For important or long-running commands:
```bash
command 2>&1 | tee .context/terminal/$(date +%Y%m%d-%H%M%S)-[name].log
```

### Quick Reference
```bash
# Recent session history
cat .context/history/$(ls -t .context/history/*.md 2>/dev/null | head -1)

# Search saved outputs
grep -rn "pattern" .context/tool-outputs/

# Find skills by topic
grep -l "keyword" .context/skills/*.md

# Cleanup old files
.context/skills/scripts/cleanup.sh 7
```
EOF

# Create project overview
cat > .context/project/overview.md << 'EOF'
# Project: [Name]

## Description
[Brief description]

## Tech Stack
| Category | Technology |
|----------|------------|
| Language | |
| Framework | |
| Database | |

## Commands
| Action | Command |
|--------|---------|
| Dev | `npm run dev` |
| Test | `npm test` |
| Build | `npm run build` |
EOF

# Create patterns
cat > .context/project/patterns.md << 'EOF'
# Code Patterns & Conventions

## File Naming
- [Your conventions]

## Code Style
- [Your style guide]

## Testing
- [Your testing patterns]
EOF

# Create decisions
cat > .context/project/decisions.md << 'EOF'
# Architecture Decision Records

## ADR-XXX: [Title]
**Date**: YYYY-MM-DD
**Status**: Proposed | Accepted | Deprecated

### Context
[Why is this decision needed?]

### Decision
[What was decided?]

### Consequences
- [Outcomes]
EOF

# Create skills index
cat > .context/skills/INDEX.md << 'EOF'
# Available Skills

Search: `grep -l "keyword" .context/skills/*.md`

## Categories
- *Add skills as you create them*
EOF

# Create history template
cat > .context/history/TEMPLATE.md << 'EOF'
# Session: [Title]
**Date**: YYYY-MM-DD

## Task
[What was accomplished]

## Decisions
- [Decision]: [Rationale]

## Files Changed
- `path/file` - [What changed]

## Next Steps
- [ ] [What's next]
EOF

# Create save-output script
cat > .context/skills/scripts/save-output.sh << 'EOF'
#!/bin/bash
COMMAND="$1"
DESC="${2:-output}"
[ -z "$COMMAND" ] && echo "Usage: $0 \"command\" \"description\"" && exit 1
OUTFILE=".context/tool-outputs/$(date +%Y%m%d-%H%M%S)-${DESC}.md"
echo "Saving to: $OUTFILE"
eval "$COMMAND" 2>&1 | tee "$OUTFILE"
EOF

# Create new-session script
cat > .context/skills/scripts/new-session.sh << 'EOF'
#!/bin/bash
TITLE="${1:-Work Session}"
FILE=".context/history/$(date +%Y-%m-%d).md"
[ -f "$FILE" ] && echo -e "\n---\n" >> "$FILE"
cat >> "$FILE" << TEMPLATE

# Session: $TITLE
**Time**: $(date +%H:%M)

## Task
[What are you working on?]

## Decisions
- 

## Files Changed
- 

## Next Steps
- [ ] 
TEMPLATE
echo "✅ Session added to $FILE"
EOF

# Create cleanup script
cat > .context/skills/scripts/cleanup.sh << 'EOF'
#!/bin/bash
DAYS="${1:-7}"
echo "Cleaning files older than $DAYS days..."
find .context/tool-outputs -type f -name "*.md" -mtime +$DAYS -delete 2>/dev/null
for f in .context/terminal/*.log; do
  [ -f "$f" ] && [ $(wc -l < "$f") -gt 1000 ] && tail -1000 "$f" > "$f.tmp" && mv "$f.tmp" "$f"
done
echo "✅ Done"
EOF

# Make scripts executable
chmod +x .context/skills/scripts/*.sh

echo ""
echo "✅ Context management initialized!"
echo ""
echo "Next steps:"
echo "  1. Edit CLAUDE.md - update project name"
echo "  2. Edit .context/project/overview.md - add your tech stack"
echo "  3. Run: .context/skills/scripts/new-session.sh 'First Session'"
