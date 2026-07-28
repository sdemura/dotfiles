# Codex-Native Configuration Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development
> (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use
> checkbox (`- [ ]`) syntax for tracking.

**Goal:** Replace Claude compatibility machinery with independently maintained, Codex-native
instructions, policy, integrations, and runtime configuration.

**Architecture:** Human-authored instructions, rules, and the narrow policy hook live in
`~/.dotfiles/codex` and are linked into `~/.codex`. Codex keeps ownership of `config.toml` and
runtime state; Herdr and context-mode keep ownership of their generated integrations.

**Tech Stack:** Codex TOML/JSON configuration, Codex Starlark rules, Node.js ESM and `node:test`,
POSIX symlinks, Git, and Herdr 0.7.5.

## Global Constraints

- Preserve the working Aperture model provider and MCP server.
- Preserve restricted filesystem and network access with on-request approvals.
- Preserve GitLab, Atlassian, Slack, browser, visualization, gopls, Pyright, and context-mode
  capabilities.
- Preserve Herdr using Herdr's native Codex integration.
- Never push code or post MR/PR comments, notes, reviews, or approvals on the user's behalf.
- Do not version Codex runtime state, credentials, caches, databases, trust records, or app-managed
  configuration churn.
- Do not modify unrelated existing dotfiles changes.
- Never stage with `git add -A`; stage only the files named by each task.
- Never modify Claude's independent configuration.

---

### Task 1: Capture the Baseline and Create a Recoverable Backup

**Files:**
- Read: `/Users/sean/.codex/config.toml`
- Read: `/Users/sean/.codex/AGENTS.md`
- Read: `/Users/sean/.codex/hooks.json`
- Read: `/Users/sean/.codex/hooks/`
- Read: `/Users/sean/.codex/rules/`
- Create: `/tmp/Codex/codex-native-pre-migration-20260727/`

**Interfaces:**
- Consumes: the current working Codex configuration.
- Produces: an immutable migration backup and a verified baseline for later comparison.

- [ ] **Step 1: Confirm the fixed backup path is unused**

Run:

```bash
/bin/test ! -e /tmp/Codex/codex-native-pre-migration-20260727
```

Expected: exit `0`. If the path already exists, stop instead of clobbering it.

- [ ] **Step 2: Create the backup directory**

Run:

```bash
/bin/mkdir -p /tmp/Codex/codex-native-pre-migration-20260727
```

Expected: exit `0`.

- [ ] **Step 3: Copy every affected runtime-owned file**

Run each command separately:

```bash
/bin/cp -p /Users/sean/.codex/config.toml /tmp/Codex/codex-native-pre-migration-20260727/config.toml
/bin/cp -p /Users/sean/.codex/AGENTS.md /tmp/Codex/codex-native-pre-migration-20260727/AGENTS.md
/bin/cp -p /Users/sean/.codex/hooks.json /tmp/Codex/codex-native-pre-migration-20260727/hooks.json
/bin/cp -R /Users/sean/.codex/hooks /tmp/Codex/codex-native-pre-migration-20260727/hooks
/bin/cp -R /Users/sean/.codex/rules /tmp/Codex/codex-native-pre-migration-20260727/rules
```

Expected: all commands exit `0`.

- [ ] **Step 4: Record the fresh health baseline**

Run:

```bash
/Users/sean/.local/bin/codex doctor --summary --ascii --no-color
```

Expected: `0 warn`, `0 fail`.

Run:

```bash
/Users/sean/.local/bin/herdr integration status
```

Expected before migration: `claude: current` and `codex: not installed`.

- [ ] **Step 5: Verify the backup inventory**

Run:

```bash
/usr/bin/find /tmp/Codex/codex-native-pre-migration-20260727 -maxdepth 2 -type f -print
```

Expected: `config.toml`, `AGENTS.md`, `hooks.json`, five hook scripts, and `default.rules` are
present. Do not continue if any source file is absent from the backup.

---

### Task 2: Build the Narrow Codex Policy Hook with Tests

**Files:**
- Create: `/Users/sean/.dotfiles/codex/hooks/codex-policy-lib.mjs`
- Create: `/Users/sean/.dotfiles/codex/hooks/codex-policy.mjs`
- Create: `/Users/sean/.dotfiles/codex/hooks/codex-policy.test.mjs`

**Interfaces:**
- Consumes: Codex hook JSON on standard input with `tool_name` and `tool_input`.
- Produces: `decisionForInput(input)`, `isGitPushCommand(command)`, and
  `isProhibitedRemoteWriteTool(toolName)`; the executable emits Codex's `PreToolUse` denial shape or
  no output.

- [ ] **Step 1: Write the failing policy tests**

Create `codex/hooks/codex-policy.test.mjs` with:

```javascript
import assert from 'node:assert/strict';
import { spawnSync } from 'node:child_process';
import { fileURLToPath } from 'node:url';
import test from 'node:test';

import {
  decisionForInput,
  isGitPushCommand,
  isProhibitedRemoteWriteTool,
} from './codex-policy-lib.mjs';

const executable = fileURLToPath(new URL('./codex-policy.mjs', import.meta.url));

test('detects git push without blocking other git commands', () => {
  const denied = [
    'git push',
    '/opt/homebrew/bin/git push origin main',
    'git -C /Users/sean/src/example push',
    'git -c push.default=current push',
    'git --git-dir=/tmp/repo/.git push',
    'GIT_SSH_COMMAND=ssh git push',
    'env GIT_SSH_COMMAND=ssh git push',
    'git status | git push',
  ];
  const allowed = [
    'git status',
    '/opt/homebrew/bin/git -C /Users/sean/src/example commit',
    'git grep push',
    "echo 'git push'",
    'printf push',
  ];

  for (const command of denied) assert.equal(isGitPushCommand(command), true, command);
  for (const command of allowed) assert.equal(isGitPushCommand(command), false, command);
});

test('blocks only known MR and PR interaction tools', () => {
  const denied = [
    'mcp__gitlab__create_merge_request_note',
    'mcp__gitlab__create_workitem_note',
    'mcp__plugin_gitlab_gitlab__create_workitem_note',
    'mcp__github__add_issue_comment',
    'mcp__github__create_pull_request_review',
    'mcp__github__submit_pending_pull_request_review',
    'mcp__github__add_comment_to_pending_review',
    'mcp__github__approve_pull_request',
    'mcp__github__approve_merge_request',
    'mcp__github__pull_request_review_write',
  ];
  const allowed = [
    'mcp__gitlab__get_merge_request',
    'mcp__gitlab__get_merge_request_notes',
    'mcp__github__get_pull_request',
    'mcp__github__get_pull_request_comments',
    'mcp__atlassian__addCommentToJiraIssue',
  ];

  for (const toolName of denied) {
    assert.equal(isProhibitedRemoteWriteTool(toolName), true, toolName);
  }
  for (const toolName of allowed) {
    assert.equal(isProhibitedRemoteWriteTool(toolName), false, toolName);
  }
});

test('returns Codex denial JSON only for prohibited operations', () => {
  assert.equal(
    decisionForInput({ tool_name: 'Bash', tool_input: { command: 'git status' } }),
    null,
  );

  const push = decisionForInput({
    tool_name: 'Bash',
    tool_input: { command: '/opt/homebrew/bin/git -C /tmp/repo push' },
  });
  assert.equal(push.hookSpecificOutput.hookEventName, 'PreToolUse');
  assert.equal(push.hookSpecificOutput.permissionDecision, 'deny');
  assert.match(push.hookSpecificOutput.permissionDecisionReason, /push/i);

  const note = decisionForInput({
    tool_name: 'mcp__gitlab__create_merge_request_note',
    tool_input: { project_id: 'group/project', merge_request_iid: 7 },
  });
  assert.equal(note.hookSpecificOutput.permissionDecision, 'deny');
  assert.match(note.hookSpecificOutput.permissionDecisionReason, /review interaction/i);
});

test('executable writes a denial and fails loudly on malformed input', () => {
  const denied = spawnSync(executable, {
    input: JSON.stringify({ tool_name: 'Bash', tool_input: { command: 'git push' } }),
    encoding: 'utf8',
  });
  assert.equal(denied.status, 0);
  assert.equal(JSON.parse(denied.stdout).hookSpecificOutput.permissionDecision, 'deny');

  const allowed = spawnSync(executable, {
    input: JSON.stringify({ tool_name: 'Bash', tool_input: { command: 'git status' } }),
    encoding: 'utf8',
  });
  assert.equal(allowed.status, 0);
  assert.equal(allowed.stdout, '');

  const malformed = spawnSync(executable, { input: '{', encoding: 'utf8' });
  assert.equal(malformed.status, 2);
  assert.match(malformed.stderr, /Invalid Codex hook input/);
});
```

- [ ] **Step 2: Run the tests to verify they fail**

Run:

```bash
/Applications/Codex.app/Contents/Resources/cua_node/bin/node --test \
  /Users/sean/.dotfiles/codex/hooks/codex-policy.test.mjs
```

Expected: failure with `ERR_MODULE_NOT_FOUND` for `codex-policy-lib.mjs`.

- [ ] **Step 3: Implement the policy library**

Create `codex/hooks/codex-policy-lib.mjs` with:

```javascript
import { basename } from 'node:path';

const CONTROL_TOKENS = new Set(['|', '||', '&&', ';', '&']);
const GIT_OPTIONS_WITH_VALUE = new Set([
  '-C',
  '-c',
  '--config-env',
  '--exec-path',
  '--git-dir',
  '--namespace',
  '--super-prefix',
  '--work-tree',
]);
const PROHIBITED_REMOTE_WRITE_SUFFIXES = new Set([
  'add_comment_to_pending_review',
  'add_issue_comment',
  'approve_merge_request',
  'approve_pull_request',
  'create_merge_request_note',
  'create_pull_request_review',
  'create_workitem_note',
  'pull_request_review_write',
  'submit_pending_pull_request_review',
]);

function tokenizeShell(command) {
  const tokens = [];
  let current = '';
  let escaped = false;
  let quote = null;

  const flush = () => {
    if (current) tokens.push(current);
    current = '';
  };

  for (let index = 0; index < command.length; index += 1) {
    const character = command[index];
    if (escaped) {
      current += character;
      escaped = false;
      continue;
    }
    if (character === '\\' && quote !== "'") {
      escaped = true;
      continue;
    }
    if (quote) {
      if (character === quote) quote = null;
      else current += character;
      continue;
    }
    if (character === "'" || character === '"') {
      quote = character;
      continue;
    }
    if (/\s/.test(character)) {
      flush();
      continue;
    }
    if ('|&;'.includes(character)) {
      flush();
      const doubled = command[index + 1] === character;
      tokens.push(doubled ? character + character : character);
      if (doubled) index += 1;
      continue;
    }
    current += character;
  }
  if (escaped) current += '\\';
  flush();
  return tokens;
}

function commandSegments(command) {
  const segments = [[]];
  for (const token of tokenizeShell(command)) {
    if (CONTROL_TOKENS.has(token)) segments.push([]);
    else segments.at(-1).push(token);
  }
  return segments.filter((segment) => segment.length > 0);
}

function isAssignment(token) {
  return /^[A-Za-z_][A-Za-z0-9_]*=/.test(token);
}

function executableIndex(tokens) {
  let index = 0;
  while (isAssignment(tokens[index] ?? '')) index += 1;

  if (basename(tokens[index] ?? '') === 'env') {
    index += 1;
    while (tokens[index]?.startsWith('-') || isAssignment(tokens[index] ?? '')) index += 1;
  }
  if (basename(tokens[index] ?? '') === 'command') {
    index += 1;
    while (tokens[index]?.startsWith('-')) index += 1;
  }
  return index;
}

function gitSubcommand(tokens, gitIndex) {
  let index = gitIndex + 1;
  while (index < tokens.length) {
    const token = tokens[index];
    if (token === '--') return tokens[index + 1] ?? null;
    if (GIT_OPTIONS_WITH_VALUE.has(token)) {
      index += 2;
      continue;
    }
    if (
      token.startsWith('-C') ||
      token.startsWith('-c') ||
      [...GIT_OPTIONS_WITH_VALUE].some((option) => token.startsWith(`${option}=`))
    ) {
      index += 1;
      continue;
    }
    if (token.startsWith('-')) {
      index += 1;
      continue;
    }
    return token;
  }
  return null;
}

export function isGitPushCommand(command) {
  return commandSegments(String(command ?? '')).some((tokens) => {
    const index = executableIndex(tokens);
    return basename(tokens[index] ?? '') === 'git' && gitSubcommand(tokens, index) === 'push';
  });
}

export function isProhibitedRemoteWriteTool(toolName) {
  const normalized = String(toolName ?? '').toLowerCase().replaceAll('-', '_');
  return [...PROHIBITED_REMOTE_WRITE_SUFFIXES].some((suffix) => {
    return normalized.endsWith(`__${suffix}`);
  });
}

function deny(reason) {
  return {
    hookSpecificOutput: {
      hookEventName: 'PreToolUse',
      permissionDecision: 'deny',
      permissionDecisionReason: reason,
    },
  };
}

export function decisionForInput(input) {
  const toolName = String(input?.tool_name ?? '');
  if (toolName === 'Bash' && isGitPushCommand(input?.tool_input?.command)) {
    return deny('git push is always denied. Sean pushes manually.');
  }
  if (toolName.startsWith('mcp__') && isProhibitedRemoteWriteTool(toolName)) {
    return deny('Remote MR/PR review interaction is denied. Sean posts it manually.');
  }
  return null;
}
```

- [ ] **Step 4: Implement the executable wrapper**

Create `codex/hooks/codex-policy.mjs` with:

```javascript
#!/usr/bin/env node
import { readFileSync } from 'node:fs';

import { decisionForInput } from './codex-policy-lib.mjs';

try {
  const input = JSON.parse(readFileSync(0, 'utf8'));
  const decision = decisionForInput(input);
  if (decision) process.stdout.write(JSON.stringify(decision));
} catch (error) {
  process.stderr.write(`Invalid Codex hook input: ${error.message}\n`);
  process.exit(2);
}
```

Make it executable:

```bash
/bin/chmod 0755 /Users/sean/.dotfiles/codex/hooks/codex-policy.mjs
```

- [ ] **Step 5: Run the focused tests**

Run:

```bash
/Applications/Codex.app/Contents/Resources/cua_node/bin/node --test \
  /Users/sean/.dotfiles/codex/hooks/codex-policy.test.mjs
```

Expected: four tests pass with zero failures and zero skips.

- [ ] **Step 6: Commit the policy hook only**

Run:

```bash
/opt/homebrew/bin/git -C /Users/sean/.dotfiles add \
  codex/hooks/codex-policy-lib.mjs \
  codex/hooks/codex-policy.mjs \
  codex/hooks/codex-policy.test.mjs
/opt/homebrew/bin/git -C /Users/sean/.dotfiles commit \
  -m "feat: add Codex-native policy hook" \
  -m "Block pushes and remote review interactions without reading Claude settings."
```

Expected: the commit contains exactly the three policy files.

---

### Task 3: Track Codex Instructions and Native Command Rules

**Files:**
- Create: `/Users/sean/.dotfiles/codex/AGENTS.md`
- Create: `/Users/sean/.dotfiles/codex/rules/default.rules`

**Interfaces:**
- Consumes: the approved design and current user preferences.
- Produces: Codex-native model instructions and command-prefix policy without Claude imports.

- [ ] **Step 1: Create the Codex-native `AGENTS.md`**

Create `codex/AGENTS.md` by copying the existing sections and making only these exact semantic
changes:

1. Delete the final `@RTK.md` line.
2. Replace the commit instruction with:

```markdown
- Commit code changes as a natural part of completing implementation work; do not wait for a
  separate commit request.
```

3. Replace `Bash tool call` with `shell tool call` in the no-command-chaining instruction.
4. Retain all GitLab/GitHub, no-push, no-review-write, temporary-file, deletion, and shell rules.

Run:

```bash
/opt/homebrew/bin/rg -n '@RTK|Claude|Bash tool call|system prompt' \
  /Users/sean/.dotfiles/codex/AGENTS.md
```

Expected: no output.

- [ ] **Step 2: Create the native rules file**

Create `codex/rules/default.rules` by copying the current rules unchanged except for replacing:

```python
# Claude-compatible commands that must always surface an approval prompt.
```

with:

```python
# Commands that must always surface a Codex approval prompt.
```

Retain all 11 existing allow rules, all 10 prompt rules, and all four forbidden rules.

- [ ] **Step 3: Validate rule counts and required prohibitions**

Run:

```bash
/opt/homebrew/bin/rg -c 'decision="allow"' /Users/sean/.dotfiles/codex/rules/default.rules
/opt/homebrew/bin/rg -c 'decision="prompt"' /Users/sean/.dotfiles/codex/rules/default.rules
/opt/homebrew/bin/rg -c 'decision="forbidden"' /Users/sean/.dotfiles/codex/rules/default.rules
```

Expected counts: `11`, `10`, and `4`.

Run:

```bash
/opt/homebrew/bin/rg -n \
  'git.*push|terraform.*destroy|terminate-instances|s3.*rb.*rm' \
  /Users/sean/.dotfiles/codex/rules/default.rules
```

Expected: four forbidden policy lines are present.

- [ ] **Step 4: Commit instructions and rules only**

Run:

```bash
/opt/homebrew/bin/git -C /Users/sean/.dotfiles add codex/AGENTS.md codex/rules/default.rules
/opt/homebrew/bin/git -C /Users/sean/.dotfiles commit \
  -m "chore: track Codex instructions and rules" \
  -m "Keep durable behavior and command policy independent from Claude configuration."
```

Expected: the commit contains exactly `codex/AGENTS.md` and `codex/rules/default.rules`.

---

### Task 4: Install Native Herdr and Deploy the Tracked Hook Configuration

**Files:**
- Create: `/Users/sean/.codex/herdr-agent-state.sh` through Herdr.
- Modify: `/Users/sean/.codex/config.toml` through Herdr's installer.
- Modify: `/Users/sean/.codex/hooks.json` through Herdr's installer.
- Create: `/Users/sean/.dotfiles/codex/hooks.json`
- Replace with symlinks: `/Users/sean/.codex/AGENTS.md`, `/Users/sean/.codex/hooks.json`,
  `/Users/sean/.codex/hooks/`, `/Users/sean/.codex/rules/`

**Interfaces:**
- Consumes: the tested policy hook, tracked instructions/rules, and Herdr's generated Codex
  handlers.
- Produces: native Herdr session identity plus one Codex policy handler and no Claude/RTK/Orca
  handlers.

- [ ] **Step 1: Install Herdr's Codex integration**

Run:

```bash
/Users/sean/.local/bin/herdr integration install codex
```

Expected: Herdr reports installation of `~/.codex/herdr-agent-state.sh`, ensures Codex hooks, and
updates Codex configuration without changing Claude configuration.

- [ ] **Step 2: Verify Herdr before removing the copied hook**

Run:

```bash
/Users/sean/.local/bin/herdr integration status
```

Expected: `codex: current` at `/Users/sean/.codex/herdr-agent-state.sh`.

Run:

```bash
/opt/homebrew/bin/rg -n 'HERDR_INTEGRATION_ID=codex|source = "herdr:codex"' \
  /Users/sean/.codex/herdr-agent-state.sh
```

Expected: both Codex identity markers are present. If either verification fails, stop and retain the
existing copied Herdr hook.

- [ ] **Step 3: Preserve Herdr's generated registration for rollback and tracking**

Run:

```bash
/bin/cp -p /Users/sean/.codex/hooks.json \
  /tmp/Codex/codex-native-pre-migration-20260727/hooks.herdr-generated.json
```

Expected: exit `0`.

- [ ] **Step 4: Create the tracked hook registration**

Read the Herdr-generated `hooks.json`. Create `codex/hooks.json` with this deterministic merge:

- Preserve every handler whose command contains
  `/Users/sean/.codex/herdr-agent-state.sh`, including its event, matcher, timeout, and action.
- Remove every other generated or pre-existing handler.
- Add one `PreToolUse` matcher group with matcher `^(Bash|mcp__.*)$` and this handler:

```json
{
  "type": "command",
  "command": "'/Users/sean/.codex/hooks/codex-policy.mjs'",
  "timeout": 10,
  "statusMessage": "Checking local and review-write policy"
}
```

The resulting root shape must remain `{ "hooks": { ... } }`. Do not copy Herdr's generated shell
script into dotfiles.

- [ ] **Step 5: Validate the tracked hook registration**

Run:

```bash
/opt/homebrew/bin/python3 -m json.tool /Users/sean/.dotfiles/codex/hooks.json
```

Expected: valid JSON.

Run:

```bash
/opt/homebrew/bin/rg -n \
  'claude|rtk|orca|allow-claude|context-mode-cache-heal' \
  /Users/sean/.dotfiles/codex/hooks.json
```

Expected: no output.

Run:

```bash
/opt/homebrew/bin/rg -n 'herdr-agent-state\.sh|codex-policy\.mjs' \
  /Users/sean/.dotfiles/codex/hooks.json
```

Expected: at least one Herdr handler and exactly one policy handler.

- [ ] **Step 6: Commit the hook registration only**

Run:

```bash
/opt/homebrew/bin/git -C /Users/sean/.dotfiles add codex/hooks.json
/opt/homebrew/bin/git -C /Users/sean/.dotfiles commit \
  -m "chore: track Codex hook registration" \
  -m "Keep native Herdr lifecycle reporting and one narrow policy hook."
```

Expected: the commit contains only `codex/hooks.json`.

- [ ] **Step 7: Move active legacy files into the existing backup**

Run each command separately:

```bash
/bin/mv /Users/sean/.codex/AGENTS.md /tmp/Codex/codex-native-pre-migration-20260727/AGENTS.active.md
/bin/mv /Users/sean/.codex/hooks.json \
  /tmp/Codex/codex-native-pre-migration-20260727/hooks.active.json
/bin/mv /Users/sean/.codex/hooks /tmp/Codex/codex-native-pre-migration-20260727/hooks.active
/bin/mv /Users/sean/.codex/rules /tmp/Codex/codex-native-pre-migration-20260727/rules.active
```

Expected: the four active paths no longer exist under `~/.codex`; their contents remain recoverable
under `/tmp/Codex/codex-native-pre-migration-20260727`.

- [ ] **Step 8: Link the dotfiles-owned configuration into Codex**

Run each command separately:

```bash
/bin/ln -s /Users/sean/.dotfiles/codex/AGENTS.md /Users/sean/.codex/AGENTS.md
/bin/ln -s /Users/sean/.dotfiles/codex/hooks.json /Users/sean/.codex/hooks.json
/bin/ln -s /Users/sean/.dotfiles/codex/hooks /Users/sean/.codex/hooks
/bin/ln -s /Users/sean/.dotfiles/codex/rules /Users/sean/.codex/rules
```

Expected: all four links are created without replacing another path.

- [ ] **Step 9: Verify link targets and Herdr status**

Run:

```bash
/usr/bin/readlink /Users/sean/.codex/AGENTS.md
/usr/bin/readlink /Users/sean/.codex/hooks.json
/usr/bin/readlink /Users/sean/.codex/hooks
/usr/bin/readlink /Users/sean/.codex/rules
```

Expected: each output points to the corresponding path under `/Users/sean/.dotfiles/codex`.

Run:

```bash
/Users/sean/.local/bin/herdr integration status
```

Expected: `codex: current` remains true after linking the tracked registration.

---

### Task 5: Simplify Runtime Configuration and Verify the Migration

**Files:**
- Modify: `/Users/sean/.codex/config.toml`
- Test: `/Users/sean/.dotfiles/codex/hooks/codex-policy.test.mjs`
- Read: `/Users/sean/.codex/AGENTS.md`
- Read: `/Users/sean/.codex/hooks.json`
- Read: `/Users/sean/.codex/rules/default.rules`

**Interfaces:**
- Consumes: the deployed dotfiles configuration and native integrations.
- Produces: the final app-owned runtime configuration with redundant plugins disabled and no
  Claude-specific global environment.

- [ ] **Step 1: Disable redundant Claude-derived plugins**

In `/Users/sean/.codex/config.toml`, set `enabled = false` under exactly these tables:

```toml
[plugins."claude-md-management@claude-plugins-official"]
enabled = false

[plugins."code-review@claude-plugins-official"]
enabled = false

[plugins."feature-dev@claude-plugins-official"]
enabled = false

[plugins."superpowers@claude-plugins-official"]
enabled = false
```

Leave browser, visualize, Atlassian, GitLab, gopls, Pyright, Slack, and context-mode enabled. Leave
Slack's nested MCP override disabled as it is today.

- [ ] **Step 2: Remove obsolete features, environment entries, and Claude profile naming**

Delete the emptyable section:

```toml
[features]
js_repl = false
```

Keep:

```toml
[shell_environment_policy]
inherit = "core"
```

Delete the entire `[shell_environment_policy.set]` table and all 12 values beneath it. Do not remove
the separate `[mcp_servers.node_repl.env]` table or any of its values.

Rename the custom permission profile from `claude-parity` to `local-development`, update its
description to Codex-native wording, and remove `~/.claude` from its workspace roots. Retain the
`~/src` and `~/.dotfiles` workspace roots, `~/go` read access, `/tmp/Codex` write access, and
inheritance from `:workspace`.

- [ ] **Step 3: Parse the runtime configuration**

Run:

```bash
/opt/homebrew/bin/python3 -c \
  'import tomllib; tomllib.load(open("/Users/sean/.codex/config.toml", "rb")); print("valid TOML")'
```

Expected: `config.toml: valid TOML`.

- [ ] **Step 4: Verify removed and retained runtime configuration**

Run:

```bash
/opt/homebrew/bin/rg -n \
  'js_repl|ANTHROPIC_|CLAUDE_CODE_|MAX_THINKING_TOKENS|claude-parity|"~/.claude"' \
  /Users/sean/.codex/config.toml
```

Expected: no output.

Run:

```bash
/opt/homebrew/bin/rg -n \
  'default_permissions = "local-development"|permissions\.local-development' \
  /Users/sean/.codex/config.toml
```

Expected: the selected profile and all three `local-development` tables are present.

Run:

```bash
/opt/homebrew/bin/rg -n -A 1 \
  'browser@|visualize@|atlassian@|gitlab@|gopls-lsp@|pyright-lsp@|slack@|context-mode@' \
  /Users/sean/.codex/config.toml
```

Expected: retained top-level plugins report `enabled = true`; Slack's nested MCP override remains
`enabled = false`.

- [ ] **Step 5: Run the policy tests and direct hook probes**

Run:

```bash
/Applications/Codex.app/Contents/Resources/cua_node/bin/node --test \
  /Users/sean/.dotfiles/codex/hooks/codex-policy.test.mjs
```

Expected: four tests pass with zero failures and zero skips.

Run:

```bash
/usr/bin/printf '%s\n' \
  '{"tool_name":"Bash","tool_input":{"command":"git push"}}' \
  | /Users/sean/.codex/hooks/codex-policy.mjs
```

Expected: JSON with `permissionDecision` equal to `deny`.

Run:

```bash
/usr/bin/printf '%s\n' \
  '{"tool_name":"Bash","tool_input":{"command":"git status"}}' \
  | /Users/sean/.codex/hooks/codex-policy.mjs
```

Expected: no output and exit `0`.

- [ ] **Step 6: Verify plugin and integration state**

Run:

```bash
/Users/sean/.local/bin/codex plugin list --json
```

Expected: `superpowers`, `feature-dev`, `code-review`, and `claude-md-management` are disabled;
approved integrations remain enabled.

Run:

```bash
/Users/sean/.local/bin/herdr integration status
```

Expected: `codex: current`.

- [ ] **Step 7: Verify no Claude compatibility references remain active**

Run:

```bash
/opt/homebrew/bin/rg -n \
  -e '@RTK|claude-permissions|allow-claude-tmp-rm' \
  -e 'deny-bash-chains|rtk hook|orca|context-mode-cache-heal' \
  /Users/sean/.codex/AGENTS.md \
  /Users/sean/.codex/hooks.json \
  /Users/sean/.codex/hooks \
  /Users/sean/.codex/rules
```

Expected: no output.

- [ ] **Step 8: Review and trust the two active non-managed hook sources**

Start a new Codex session, run `/hooks`, and review the active handlers. Trust only:

- `/Users/sean/.codex/hooks/codex-policy.mjs`
- `/Users/sean/.codex/herdr-agent-state.sh`

Expected: no RTK, Orca, Claude permission, temporary deletion, or Claude cache-healing handlers are
listed. This is an explicit user-review checkpoint; do not bypass it by editing `[hooks.state]`
hashes.

- [ ] **Step 9: Run final Codex diagnostics**

Run after hook trust is recorded:

```bash
/Users/sean/.local/bin/codex doctor --summary --ascii --no-color
```

Expected: zero warnings and zero failures. If diagnostics fail, restore the fixed backup before
attempting further changes.

- [ ] **Step 10: Verify dotfiles commit isolation**

Run:

```bash
/opt/homebrew/bin/git -C /Users/sean/.dotfiles log --oneline -8
/opt/homebrew/bin/git -C /Users/sean/.dotfiles status --short
```

Expected: the Codex design, plan, implementation, and migration-adjustment commits are present.
Pre-existing unrelated dotfiles changes remain uncommitted and unchanged; no Codex runtime state
appears in Git.

## Rollback Commands

Use these only if an acceptance check fails. Move the linked paths aside, then restore the active
copies from the fixed backup:

```bash
/bin/rm /Users/sean/.codex/AGENTS.md
/bin/rm /Users/sean/.codex/hooks.json
/bin/rm /Users/sean/.codex/hooks
/bin/rm /Users/sean/.codex/rules
/bin/cp -p /tmp/Codex/codex-native-pre-migration-20260727/AGENTS.active.md \
  /Users/sean/.codex/AGENTS.md
/bin/cp -p /tmp/Codex/codex-native-pre-migration-20260727/hooks.active.json \
  /Users/sean/.codex/hooks.json
/bin/cp -R /tmp/Codex/codex-native-pre-migration-20260727/hooks.active /Users/sean/.codex/hooks
/bin/cp -R /tmp/Codex/codex-native-pre-migration-20260727/rules.active /Users/sean/.codex/rules
/bin/cp -p /tmp/Codex/codex-native-pre-migration-20260727/config.toml /Users/sean/.codex/config.toml
```

Then run:

```bash
/Users/sean/.local/bin/herdr integration uninstall codex
/Users/sean/.local/bin/codex doctor --summary --ascii --no-color
```

Expected after rollback: the original configuration is restored and Codex diagnostics return to the
Task 1 baseline.
