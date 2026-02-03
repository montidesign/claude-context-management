# Claude Context Management Template

A project template with dynamic context discovery for Claude Code, adapted from [Cursor's context engineering research](https://cursor.com/blog/dynamic-context-discovery).

## What This Does

Reduces context window bloat and preserves important information by:

1. **Saving long outputs to files** instead of keeping them in context
2. **Documenting session history** so context survives summarization
3. **Organizing skills** as discoverable files for specialized tasks
4. **Managing MCP tools** with on-demand lookup (46.9% token reduction)
5. **Persisting terminal logs** for efficient retrieval with grep/tail

## Quick Start

### Using This Template

```bash
# Create a new project from this template
gh repo create my-project --template YOUR_USERNAME/claude-context-management --private --clone
cd my-project

# Or clone directly
git clone https://github.com/YOUR_USERNAME/claude-context-management.git my-project
cd my-project
rm -rf .git && git init
```

### After Creating Your Project

1. Edit `CLAUDE.md` - Update the project name and description at the top
2. Edit `.context/project/overview.md` - Fill in your tech stack and structure
3. Start working - The context management rules in `CLAUDE.md` guide Claude Code

## Directory Structure

```
├── CLAUDE.md                    # Main Claude Code instructions
├── .context/
│   ├── tool-outputs/            # Saved long command outputs
│   ├── history/                 # Session logs and decisions
│   ├── mcp/                     # MCP tool descriptions
│   ├── skills/                  # Reusable task instructions
│   │   ├── scripts/             # Helper scripts
│   │   └── INDEX.md             # Skill directory
│   ├── terminal/                # Terminal session logs
│   └── project/                 # Project context
│       ├── overview.md          # Tech stack, commands
│       ├── patterns.md          # Code conventions
│       └── decisions.md         # Architecture decisions
└── .claude/
    └── skills/                  # Claude Code skills
        └── context-management/  # This system as a skill
```

## Helper Scripts

```bash
# Save long command output
.context/skills/scripts/save-output.sh "npm install" "npm-install"

# Start a new session log
.context/skills/scripts/new-session.sh "Feature: User Auth"

# Clean up old files (default: 7 days)
.context/skills/scripts/cleanup.sh 7
```

## Key Commands

```bash
# Recent session history
cat .context/history/$(ls -t .context/history/*.md 2>/dev/null | head -1)

# Search saved outputs
grep -rn "error" .context/tool-outputs/

# Find skills
grep -l "database" .context/skills/*.md

# Check terminal logs
tail -100 .context/terminal/*.log
```

## Customization

### Adding Project-Specific Skills

Create `.context/skills/your-skill.md`:

```markdown
# Skill: [Name]

## Description
[What this skill does]

## When to Use
- [Trigger conditions]
- Keywords: [searchable terms]

## Instructions
[Step-by-step guide]
```

### Documenting MCP Tools

Create `.context/mcp/[server-name]/_INDEX.md` listing available tools, then individual files for each tool's parameters and usage.

## Credits

Based on [Cursor's Dynamic Context Discovery](https://cursor.com/blog/dynamic-context-discovery) research (January 2026).
