# ── Options ──────────────────────────────────────────────────────────
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY
setopt INTERACTIVECOMMENTS

# ── Environment & PATH ──────────────────────────────────────────────
export HISTFILE=~/.zsh_history
export HISTSIZE=10000000
export SAVEHIST=$HISTSIZE

# Keep custom terminfo entries readable inside sandboxed tools such as Codex.
export TERMINFO="$HOME/.local/share/terminfo"
unset TERMINFO_DIRS

export BUN_INSTALL="$HOME/.bun"
export PATH="$HOME/go/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.dotfiles/bin:$PATH"
export PATH="$BUN_INSTALL/bin:$PATH"

# ── Completions ─────────────────────────────────────────────────────
autoload -Uz compinit && compinit

[[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh
[[ -s "$HOME/.bun/_bun" ]] && source "$HOME/.bun/_bun"

# Google Cloud SDK
if [[ -f "$HOME/src/gitlab.com/corelight/engineering/cloud/cloud-images-distribution/google-cloud-sdk/path.zsh.inc" ]]; then
  source "$HOME/src/gitlab.com/corelight/engineering/cloud/cloud-images-distribution/google-cloud-sdk/path.zsh.inc"
fi
if [[ -f "$HOME/src/gitlab.com/corelight/engineering/cloud/cloud-images-distribution/google-cloud-sdk/completion.zsh.inc" ]]; then
  source "$HOME/src/gitlab.com/corelight/engineering/cloud/cloud-images-distribution/google-cloud-sdk/completion.zsh.inc"
fi

# ── Aliases ─────────────────────────────────────────────────────────
alias g='git'
alias j='just'
alias ls='lsd'
alias rg="rg --hidden -g '!.git' -g '!.venv' --no-ignore-vcs"

# ── Functions ───────────────────────────────────────────────────────
# source "$HOME/.dotfiles/wt.zsh"

# Close all tmux windows except current
tabo() { tmux kill-window -a; }

# # Rename tmux window to 'claude' while claude is running
# claude() {
#   if [[ -n "$TMUX" ]]; then
#     local prev
#     prev=$(tmux display-message -p '#W')
#     tmux rename-window claude
#     command claude "$@"
#     local rc=$?
#     tmux rename-window "$prev"
#     tmux set-window-option -u automatic-rename
#     return $rc
#   else
#     command claude "$@"
#   fi
# }

# Copy file contents to clipboard
pc() { pbcopy < "$1" && echo "copied contents of $1 to clipboard"; }

# Copy absolute path to clipboard (no args: fuzzy repo selector)
rp() {
  if [[ -n "$1" ]]; then
    local p
    p=$(realpath "$1") && printf '%s' "$p" | pbcopy && echo "copied $p to clipboard"
    return
  fi

  local cache_file="$HOME/.git_repos_src.cache"
  local src_dir="$HOME/src"

  if [[ ! -f "$cache_file" ]]; then
    echo "No repo cache found. Run 'repo update' first." >&2
    return 1
  fi

  local selection
  selection=$(fzf <"$cache_file")

  if [[ -n "$selection" ]]; then
    [[ "$selection" == /* ]] || selection="$src_dir/$selection"
    printf '%s' "$selection" | pbcopy
    echo "copied $selection to clipboard"
  fi
}

# Keep source repositories separate from worktrees and the old mixed cache.
repo() { _repo_picker "$HOME/src" "$HOME/.git_repos_src.cache" "$1"; }
wrepo() { _repo_picker "$HOME/.herdr/worktrees" "$HOME/.git_worktrees.cache" "$1"; }

_repo_update_cache() {
  setopt localoptions pipefail
  local root_dir="$1" cache_file="$2" silent="$3"
  [[ "$silent" != "silent" ]] && echo "Updating git repo cache for $root_dir..." >&2
  fd --hidden --type d --type f '^\.git$' --base-directory "$root_dir" --exec dirname |
    sed 's|^\./||' |
    while IFS= read -r repo; do
      local parent="$(dirname "$repo")"
      local is_submodule=false
      while [[ "$parent" != "." ]]; do
        if [[ -e "$root_dir/$parent/.git" ]]; then
          is_submodule=true
          break
        fi
        parent="$(dirname "$parent")"
      done
      if [[ "$is_submodule" == "false" ]]; then
        printf '%s\n' "$root_dir/$repo"
      fi
    done >"$cache_file.tmp" || return
  mv "$cache_file.tmp" "$cache_file" || return
  [[ "$silent" != "silent" ]] && echo "Cache update complete." >&2
  return 0
}

_repo_picker() {
  local root_dir="$1" cache_file="$2" action="$3"

  if ! command -v fd &>/dev/null || ! command -v fzf &>/dev/null; then
    echo "Error: fd and fzf are required" >&2
    return 1
  fi

  if [[ ! -d "$root_dir" ]]; then
    echo "Error: $root_dir does not exist" >&2
    return 1
  fi

  if [[ "$action" == "update" ]] || [[ ! -f "$cache_file" ]]; then
    _repo_update_cache "$root_dir" "$cache_file" || return
    [[ "$action" == "update" ]] && return 0
  fi

  if [[ -n "$(find "$cache_file" -mmin +1440 2>/dev/null)" ]]; then
    echo "Cache is stale, updating in background..." >&2
    (_repo_update_cache "$root_dir" "$cache_file" silent &)
  fi

  local repo
  repo=$(fzf <"$cache_file")

  if [[ -n "$repo" ]]; then
    [[ "$repo" == /* ]] || repo="$root_dir/$repo"
    echo "Switching to $repo" >&2
    cd "$repo" || return
  fi
}

# Fuzzy switch to a local or fetched remote branch, with a commit preview.
_branch_picker() {
  if [[ "$(git rev-parse --is-inside-work-tree 2>/dev/null)" != true ]]; then
    echo "Error: not inside a Git working tree" >&2
    return 1
  fi

  local branches selection ref tracking_branch
  branches=$(git for-each-ref --sort=-committerdate \
    --format='%(if)%(symref)%(then)%(else)%(refname)%09%(refname:short)%09%(committerdate:relative)%09%(subject)%(end)' \
    refs/heads refs/remotes) || return
  if [[ -z "$branches" ]]; then
    echo "No branches found." >&2
    return 1
  fi

  selection=$(printf '%s\n' "$branches" | sed '/^$/d' |
    fzf --layout=reverse --delimiter=$'\t' --with-nth=2.. --nth=1 \
      --prompt='Branch> ' --preview-window=right:66% \
      --preview 'git log -30 --color=always --format="%C(yellow)%h %C(green)%ar %C(reset)%s" {1} --') || return
  [[ -n "$selection" ]] || return 0
  ref="${selection%%$'\t'*}"

  if [[ "$ref" == refs/heads/* ]]; then
    git switch -- "${ref#refs/heads/}"
  else
    tracking_branch=$(git for-each-ref --format='%(refname:lstrip=2)%09%(upstream)' refs/heads |
      awk -F '\t' -v upstream="$ref" '$2 == upstream { print $1; exit }')
    if [[ -n "$tracking_branch" ]]; then
      git switch -- "$tracking_branch"
    else
      git switch --track -- "$ref"
    fi
  fi
}

# ── ZLE Widgets & Keybindings ───────────────────────────────────────
# Ctrl-Z: toggle foreground/background (or stash current input)
fancy-ctrl-z() {
  if [[ $#BUFFER -eq 0 ]]; then
    BUFFER="fg"
    zle accept-line
  else
    zle push-input
    zle clear-screen
  fi
}
zle -N fancy-ctrl-z
bindkey '^Z' fancy-ctrl-z

# Ctrl-O opens a picker: R for repositories, W for worktrees, B for branches.
# Remove the single-key action so zsh waits for the second key.
bindkey -r '^O'
_repo_widget() { repo; zle reset-prompt; }
zle -N _repo_widget
bindkey '^Or' _repo_widget

_wrepo_widget() { wrepo; zle reset-prompt; }
zle -N _wrepo_widget
bindkey '^Ow' _wrepo_widget

_branch_widget() { _branch_picker; zle reset-prompt; }
zle -N _branch_widget
bindkey '^Ob' _branch_widget

# Retire gs even when reloading an existing shell; Ctrl-G cancels input again.
unfunction gs _gs_widget 2>/dev/null || true
zle -D _gs_widget 2>/dev/null || true
bindkey '^G' send-break

# ── Theme (Catppuccin — auto light/dark) ───────────────────────────
if [[ "$(defaults read -g AppleInterfaceStyle 2>/dev/null)" == "Dark" ]]; then
    # Catppuccin Macchiato
    export FZF_DEFAULT_OPTS=" \
        --color=bg+:#363a4f,bg:#24273a,spinner:#f4dbd6,hl:#ed8796 \
        --color=fg:#cad3f5,header:#ed8796,info:#c6a0f6,pointer:#f4dbd6 \
        --color=marker:#b7bdf8,fg+:#cad3f5,prompt:#c6a0f6,hl+:#ed8796 \
        --color=selected-bg:#494d64 \
        --color=border:#363a4f,label:#cad3f5"
    sed -i '' 's/^palette = .*/palette = "catppuccin_macchiato"/' ~/.dotfiles/starship.toml
    cp ~/.dotfiles/lsd/colors-macchiato.yaml ~/.config/lsd/colors.yaml
    sed -i '' 's/skin: catppuccin-.*/skin: catppuccin-macchiato/' ~/Library/Application\ Support/k9s/config.yaml
else
    # Catppuccin Latte
    export FZF_DEFAULT_OPTS=" \
        --color=bg+:#ccd0da,bg:#eff1f5,spinner:#dc8a78,hl:#d20f39 \
        --color=fg:#4c4f69,header:#d20f39,info:#8839ef,pointer:#dc8a78 \
        --color=marker:#7287fd,fg+:#4c4f69,prompt:#8839ef,hl+:#d20f39 \
        --color=selected-bg:#bcc0cc \
        --color=border:#ccd0da,label:#4c4f69"
    sed -i '' 's/^palette = .*/palette = "catppuccin_latte"/' ~/.dotfiles/starship.toml
    cp ~/.dotfiles/lsd/colors-latte.yaml ~/.config/lsd/colors.yaml
    sed -i '' 's/skin: catppuccin-.*/skin: catppuccin-latte/' ~/Library/Application\ Support/k9s/config.yaml
fi

# ── External sources ────────────────────────────────────────────────
[[ -f ~/.env.zsh ]] && source ~/.env.zsh

# ── Prompt ──────────────────────────────────────────────────────────
eval "$(starship init zsh)"

# ── Cursor ──────────────────────────────────────────────────────────
# Reset cursor to a bar on every prompt so it doesn't get stuck as a block
# after a program (nvim, fzf, etc.) exits without restoring it.
_set_cursor_bar() { printf '\e[5 q' }
precmd_functions+=(_set_cursor_bar)


# added by SpookiUI — force a portable TERM over SSH (see fix-ssh)
alias ssh="TERM=xterm-256color ssh"
