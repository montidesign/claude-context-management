#!/bin/bash
# Save command output to context folder
# Usage: .context/skills/scripts/save-output.sh "command" "description"

COMMAND="$1"
DESC="${2:-output}"

if [ -z "$COMMAND" ]; then
    echo "Usage: $0 \"command\" \"description\""
    echo "Example: $0 \"npm install\" \"npm-install\""
    exit 1
fi

OUTFILE=".context/tool-outputs/$(date +%Y%m%d-%H%M%S)-${DESC}.md"

echo "Running: $COMMAND"
echo "Saving to: $OUTFILE"
echo ""
echo "---"

eval "$COMMAND" 2>&1 | tee "$OUTFILE"

echo ""
echo "---"
echo "✅ Saved to $OUTFILE"
