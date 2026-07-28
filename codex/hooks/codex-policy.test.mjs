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
