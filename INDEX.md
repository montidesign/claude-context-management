# Available Skills

Skills are reusable instructions for common tasks. 

## Finding Skills
```bash
# Search by keyword
grep -l "keyword" .context/skills/*.md

# List all skills
ls .context/skills/*.md
```

## Categories

### Development
- *Add skills as you create them*

### Testing
- *Add skills as you create them*

### Deployment
- *Add skills as you create them*

---

## Creating New Skills

```bash
cat > .context/skills/[name].md << 'EOF'
# Skill: [Name]

## Description
[What this skill does - shows in search results]

## When to Use
- [Trigger condition]
- Keywords: [searchable terms]

## Prerequisites
- [Required tools/access]

## Instructions

### Step 1: [Name]
[Instructions]

### Step 2: [Name]
[Instructions]

## Common Issues

### [Problem]
**Solution**: [Fix]
EOF
```
