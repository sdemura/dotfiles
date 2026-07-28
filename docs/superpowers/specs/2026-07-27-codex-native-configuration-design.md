# Codex-Native Configuration Design

## Goal

Raise the personal Codex configuration to at least 9/10 Codex-idiomatic while preserving the useful
intent of the Claude configuration: explicit safety boundaries, GitLab-first workflows, no pushes or
remote review comments, efficient large-output handling, and Herdr lifecycle reporting.

Codex and Claude will be maintained independently. They may express the same human policy, but Codex
will not read Claude settings or emulate Claude-specific configuration mechanisms.

## Constraints

- Preserve the working Aperture model provider and MCP server.
- Preserve restricted filesystem and network access with on-request approvals.
- Preserve GitLab, Atlassian, Slack, browser, visualization, gopls, Pyright, and context-mode
  capabilities.
- Preserve Herdr using Herdr's native Codex integration.
- Never push code or post MR/PR comments, notes, reviews, or approvals on the user's behalf.
- Do not version Codex runtime state, credentials, caches, databases, trust records, or app-managed
  configuration churn.
- Do not modify unrelated existing dotfiles changes.

## Verified Current-State Problems

- `AGENTS.md` contains a literal `@RTK.md` reference, but `~/.codex/RTK.md` does not exist and Codex
  does not use Claude-style instruction-file includes.
- The temporary-deletion hook permits `/tmp/claude` while the documented Codex scratch directory is
  `/tmp/Codex`.
- Codex policy is partly derived at runtime from `~/.claude/settings.json`.
- `features.js_repl = false` configures a feature that the installed Codex runtime reports as
  removed.
- Claude/Anthropic variables and duplicated Node/browser variables are exported to every Codex child
  process.
- RTK, Orca, copied Claude Herdr hooks, and context-mode all contribute overlapping lifecycle logic.
- A Bash tool call can start six matching `PreToolUse` handlers when plugin hooks are included.
- `deny-bash-chains.mjs` is present but not referenced.
- Several enabled Claude plugins duplicate Codex behavior or expose only Claude-specific surfaces.
- Human-authored Codex files are not tracked in the dotfiles repository.

## Ownership Model

### Dotfiles-owned

The following files live under `~/.dotfiles/codex/` and are linked into `~/.codex/`:

- `AGENTS.md`: durable user preferences and behavioral invariants.
- `hooks.json`: minimal Codex lifecycle-hook registration.
- `hooks/codex-policy.mjs`: narrow policy that native command rules cannot express reliably.
- `rules/default.rules`: native command approval and prohibition rules.

These files are reviewed and committed like other dotfiles.

### Codex-owned

The following remain directly under `~/.codex` and are not versioned:

- `config.toml`, including provider, MCP, project trust, plugin state, desktop state, and hook trust
  hashes.
- Plugin caches and marketplace state.
- Session, memory, goal, log, OAuth, and application databases.
- Shell snapshots, generated state, and application packages.

User-authored entries in `config.toml` are kept minimal, but the file remains runtime-owned because
Codex and the desktop application update it.

### Integration-owned

Herdr owns the files installed by `herdr integration install codex`. Context-mode owns its plugin
cache, MCP server, skills, and bundled hooks. Neither generated integration is copied into dotfiles.

## Instruction Architecture

`AGENTS.md` contains only information that should influence model behavior:

- User and repository context.
- GitLab-versus-GitHub selection rules.
- No-push and no-remote-review-write policies.
- Coding, temporary-file, deletion, and shell conventions.
- Requirements to expose skipped checks and uncertainty.

The file does not contain imports, tool-protocol details, plugin instructions, hook implementation
details, claims about overriding system prompts, or references to Claude configuration files.

Project repositories may add closer `AGENTS.md` files for repository-specific commands and policy.

## Enforcement Architecture

Policy has one owner at each layer:

1. The custom permission profile in `config.toml` defines filesystem and network boundaries.
2. `rules/default.rules` handles executable-prefix decisions that Codex rules can express directly.
3. `codex-policy.mjs` handles only semantic cases that prefix rules cannot cover safely.
4. `AGENTS.md` communicates behavioral preferences that are unsuitable for mechanical enforcement.

The native rules retain:

- Explicitly approved local maintenance commands.
- Approval prompts for network download, package installation, cloud, and Terraform operations.
- Hard prohibitions on Terraform destruction and destructive AWS operations.
- A defense-in-depth exact-prefix prohibition for `git push`.

The policy hook denies:

- `git push` with global Git options or absolute executable paths that evade an exact prefix rule.
- GitLab or GitHub tool calls that create MR/PR notes, comments, reviews, or approvals.

The hook otherwise exits without a decision. It does not translate Claude permission syntax, grant
approvals, implement ordinary filesystem policy, or run during `PermissionRequest`.

Unsafe operations fall through to Codex's normal sandbox and approval flow. No `PreToolUse` hook
returns Claude's `ask` decision.

## Plugin and Integration Set

Keep enabled:

- OpenAI browser and visualization plugins.
- GitLab, Atlassian, and Slack integrations.
- gopls and Pyright language-server integrations.
- context-mode for large-output processing and persistent indexed context.

Disable:

- `superpowers`, because its mandatory meta-workflow overrides normal Codex task routing.
- `feature-dev` and `code-review`, because they duplicate Codex workflows and currently expose
  Claude-specific command or agent structures.
- `claude-md-management`, because it manages `CLAUDE.md` rather than Codex `AGENTS.md` files.

The Claude plugin marketplace may remain configured because retained integrations still use it.
Disabled plugin caches are left for Codex's normal plugin management rather than deleted manually.

Remove from global hooks:

- RTK command routing.
- Orca's Claude endpoint hooks.
- The copied Claude Herdr hook.
- The Claude context-mode cache-healing hook.
- The generic Claude permission adapter.
- Unreferenced hook scripts.

Context-mode's own Codex plugin hooks remain enabled. Herdr is installed using its built-in Codex
integration and must report `codex: current` before the copied Claude hook is removed.

## Shell Environment

Keep `shell_environment_policy.inherit = "core"` unless verification reveals a required variable is
missing. Remove globally injected variables that belong to Claude, Anthropic Bedrock, Node REPL, or
browser MCP configuration.

MCP-specific variables remain under the corresponding `mcp_servers.<name>.env` table. Secrets are
not moved into tracked files.

## Migration Safety

Before editing, copy every affected `~/.codex` file to a timestamped directory under `/tmp/Codex`.
The backup includes the current `AGENTS.md`, `hooks.json`, hook scripts, rules, and `config.toml`.

Migration order:

1. Create and commit the dotfiles-owned Codex files.
2. Install Herdr's native Codex integration.
3. Verify Herdr reports the Codex integration as current.
4. Link dotfiles-owned files into `~/.codex`.
5. Simplify runtime-owned `config.toml` entries and plugin enablement.
6. Remove obsolete copied hook files only after references are gone.
7. Run the complete verification suite.

If native Herdr installation or verification fails, retain the existing Herdr hook and report the
migration as incomplete. Do not silently drop lifecycle reporting.

## Verification

The migration is accepted only when all of the following are true:

- `config.toml` parses as TOML and `hooks.json` parses as JSON.
- `codex doctor --summary --ascii --no-color` reports zero warnings and zero failures.
- `herdr integration status` reports `codex: current`.
- Plugin inventory matches the approved enabled and disabled sets.
- Removed feature configuration, Claude settings dependencies, RTK, Orca, and Claude hook references
  are absent from active Codex configuration.
- Direct policy-hook fixtures prove:
  - ordinary read commands produce no decision;
  - normal Git operations produce no decision;
  - every supported `git push` spelling is denied;
  - MR/PR note, comment, review, and approval tools are denied;
  - read-only GitLab and GitHub tools produce no decision.
- `/tmp/Codex` operations defer to the native permission profile rather than a Claude temporary-file
  hook.
- The dotfiles commit contains only the intended dotfiles-owned Codex files and documentation.

## Rollback

Restore the timestamped `/tmp/Codex` backup and reinstall the previous plugin enablement if any
acceptance check fails. Dotfiles changes are recoverable through Git. Restore runtime-owned state
from the backup rather than reconstructing it manually.

## Out of Scope

- Changing the Aperture provider, selected model, or reasoning effort.
- Reworking project-specific trust entries.
- Replacing context-mode with a custom implementation.
- Modifying Claude's independent configuration.
- Deleting plugin caches, Codex databases, logs, or application-managed state.
