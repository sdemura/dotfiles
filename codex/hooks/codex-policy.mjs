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
