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
