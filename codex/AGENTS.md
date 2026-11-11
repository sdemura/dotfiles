# AGENTS.md

## User Context
- Principal Engineer at Corelight Engineering, cloud team.
- Primary stack: Go, Kubernetes (operators, Helm), Terraform, `just` for task running.
- Skip beginner explanations; be direct about tradeoffs and push back on bad ideas.
- Personal dotfiles live at `~/.dotfiles`.

## Filesystem Layout
- Repos checked out under `~/src/<host>/<namespace>/<repo>`, mirroring the remote URL
  (e.g. `gitlab.com/corelight/engineering/cloud/hermes` →
  `~/src/gitlab.com/corelight/engineering/cloud/hermes`).
- Cloud team repos live under `~/src/gitlab.com/corelight/engineering/cloud/`.

## Worktrees
- Create new worktrees under `~/.worktrees/<repo-name>/<worktree-name>`.
- Use `git worktree add` directly. Specify the repository, branch, base, and destination.
- Before retrying a failed creation, check whether Git created the branch or worktree.
- Use the current linked worktree when already in one. Keep existing worktrees in place.
- Do not create worktrees inside a repository or as visible sibling checkouts.

## General
- For low-stakes or easily reversible choices, make a reasonable assumption, state it, and
  proceed. Ask only when the decision is high-stakes or hard to reverse.
- Read before you write. Before adding code, read exports, immediate callers, shared utilities.
- If unsure why existing code is structured a certain way, ask.

## Fail loudly
- "Completed" is wrong if anything was skipped silently.
- "Tests pass" is wrong if any were skipped.
- Default to surfacing uncertainty, not hiding it.

## Git
- GitLab is our primary VCS and the default. Do NOT assume GitHub: determine the host from the
  repo's actual remote, not by habit. In a repo with no GitHub remote, never reach for `gh` or
  GitHub APIs.
- Default to `glab` CLI and GitLab MCP tools. Use GitHub tooling (`gh`) only when the repo's remote
  is genuinely GitHub (e.g. an OSS upstream or mirror); read-only `gh pr view` / `gh run view` are
  fine for that case.
- When given a URL containing `gitlab`, always use GitLab tooling — never fall back to GitHub tools.
- Never push code. Do not suggest, offer, or attempt `git push`. I will push manually when ready.
- Never post comments, notes, reviews, or approvals on MRs/PRs on my behalf. This covers every
  channel: GitLab MCP tools (e.g. `create_merge_request_note`), `glab mr note`/`glab mr approve`,
  `gh pr comment`/`gh pr review`, and the web API. Draft the text and show it to me in chat instead
  — I will post it myself.
- Commit code changes as a natural part of completing implementation work; do not wait for a
  separate commit request.
- Commit titles should not be longer than 80 characters.
- Commit body should wrap at 100 characters per line.
- Do not ever use `git add -A`.

## Coding
- For inter-dependent repos, don't assume you must push/release to test changes — check for local
  dev tooling first (e.g. `go mod replace`). Ask if unsure.

## Temporary Files
- For any scratch/temp file, use `/tmp/Codex/` — never write elsewhere in `/tmp`. Create it if
  missing (`mkdir -p /tmp/Codex`).
- You have full control inside `/tmp/Codex/`: create, edit, and delete freely there.
- Deleting or clobbering files elsewhere in `/tmp` is guarded — treat `/tmp/Codex/` as your only
  temp workspace.

## Deleting files
- `rm` of files *inside* a git repo under `~/src` is pre-approved (they're recoverable from git).
- `rm` still prompts for: a repo root or its parent dirs, anything under `.git/`, and any path
  outside `/tmp/Codex/` and `~/src` repos. These aren't cleanly restorable — repos here often hold
  unpushed commits.

## Shell Commands
- Never chain shell commands with `;` or `&&`. Run each command as a separate shell tool call.
- Always use absolute paths. Never `cd` somewhere just to run a command — pass the absolute path to
  the command instead (e.g., `git -C /path status`, `just --justfile /path/justfile`, `ls /path`).
- For git commits, use `git -C <path> commit -m "subject" -m "body"` with multiple `-m` flags.
  Never use heredocs, `cat <<EOF`, or `$(...)` in commit commands.
- Pipes (`|`) are fine — they're a single logical operation.
- If inline code in a pipe (e.g., `python3 -c "..."`) exceeds a few lines, write it to a script
  file and execute that instead.
