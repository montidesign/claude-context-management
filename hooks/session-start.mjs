// SessionStart hook: hand Claude the last handoff (.context/STATE.md) so a new session, or one after /clear
// or compaction, picks up where the work left off. Prints nothing when the project has no STATE.md.
import fs from 'node:fs';
import path from 'node:path';

const MAX_CHARS = 8000; // Claude Code caps hook output at 10,000 characters

let input = {};
try { input = JSON.parse(fs.readFileSync(0, 'utf8')); } catch {}
const root = process.env.CLAUDE_PROJECT_DIR || input.cwd || process.cwd();
const dir = path.join(root, '.context');

let state;
try { state = fs.readFileSync(path.join(dir, 'STATE.md'), 'utf8').trim(); } catch { process.exit(0); }
if (state.length > MAX_CHARS) state = `${state.slice(0, MAX_CHARS)}\n[...truncated; read .context/STATE.md for the rest]`;

let recent = [];
try {
  recent = fs.readdirSync(path.join(dir, 'history')).filter(f => f.endsWith('.md')).sort().reverse().slice(0, 3);
} catch {}

console.log(`Project state from the last handoff (.context/STATE.md). Continue from "Next" unless the user says otherwise.

${state}

Detailed history is not loaded: .context/history/ (session logs${recent.length ? `, latest: ${recent.join(', ')}` : ''}) and .context/decisions.md (why things were decided). Read or grep them when the user asks about earlier work or past decisions. Run /ctx:handoff before /clear to save progress.`);
