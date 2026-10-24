// Status line: model, folder, context-window use, and plan usage limits, with a handoff nudge as context fills.
// Configure in ~/.claude/settings.json: "statusLine": { "type": "command", "command": "node \"<repo>/scripts/statusline.mjs\"" }
import fs from 'node:fs';
import path from 'node:path';

let data = {};
try { data = JSON.parse(fs.readFileSync(0, 'utf8')); } catch {}

const color = (pct, text) => {
  const code = pct >= 80 ? 31 : pct >= 60 ? 33 : 32; // red, yellow, green
  return `\x1b[${code}m${text}\x1b[0m`;
};

const parts = [];
if (data.model?.display_name) parts.push(`[${data.model.display_name}]`);
const cwd = data.workspace?.current_dir || data.cwd;
if (cwd) parts.push(path.basename(cwd));

const ctx = data.context_window?.used_percentage;
if (ctx != null) {
  const pct = Math.round(ctx);
  parts.push(color(pct, `ctx ${pct}%`) + (pct >= 60 ? ' → /ctx:handoff then /clear' : ''));
}

for (const [key, label] of [['five_hour', '5h'], ['seven_day', '7d']]) {
  const used = data.rate_limits?.[key]?.used_percentage;
  if (used != null) parts.push(color(used, `${label} ${Math.round(used)}%`));
}

console.log(parts.join(' · '));
