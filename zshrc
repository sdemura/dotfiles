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

  local cache_file="$HOME/.git_repos.cache"
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

# Fuzzy find a git repository or worktree and cd into it
repo() {
  local cache_file="$HOME/.git_repos.cache"
  local src_dir="$HOME/src"
  local worktree_dir="$HOME/.herdr/worktrees"

  if ! command -v fd &>/dev/null || ! command -v fzf &>/dev/null; then
    echo "Error: fd and fzf are required" >&2
    return 1
  fi

  if [[ ! -d "$src_dir" && ! -d "$worktree_dir" ]]; then
    echo "Error: neither $src_dir nor $worktree_dir exists" >&2
    return 1
  fi

  _repo_update_cache() {
    local silent="$1"
    [[ "$silent" != "silent" ]] && echo "Updating git repo cache..." >&2
    {
      local root_dir
      for root_dir in "$src_dir" "$worktree_dir"; do
        [[ -d "$root_dir" ]] || continue
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
          done
      done
    } >"$cache_file.tmp" &&
      mv "$cache_file.tmp" "$cache_file"
    [[ "$silent" != "silent" ]] && echo "Cache update complete." >&2
  }

  if [[ "$1" == "update" ]] || [[ ! -f "$cache_file" ]]; then
    _repo_update_cache
    [[ "$1" == "update" ]] && return 0
  fi

  if [[ -n "$(find "$cache_file" -mmin +1440 2>/dev/null)" ]]; then
    echo "Cache is stale, updating in background..." >&2
    (_repo_update_cache silent &)
  fi

  local repo
  repo=$(fzf <"$cache_file")

  if [[ -n "$repo" ]]; then
    [[ "$repo" == /* ]] || repo="$src_dir/$repo"
    echo "Switching to $repo" >&2
    cd "$repo" || return
  fi
}

# Fuzzy switch to a recent git branch
gs() {
  local branch
  branch=$(git reflog --date=relative |
    grep 'checkout: moving' |
    sed 's/.*{\(.*\)}: checkout: moving.* to \(.*\)/\2 (\1)/' |
    awk -F' \\(' '!seen[$1]++ {printf "\033[33m%s\033[0m \033[32m(%s\033[0m\n", $1, $2}' |
    fzf --layout=reverse --ansi --preview-window=right:66% \
      --preview 'git log --color=always --format="%C(yellow)%h %C(green)%ar %C(reset)%s" $(echo {} | awk "{print \$1}") --' |
    awk '{print $1}')

  [[ -n "$branch" ]] && git switch "$branch"
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

# Ctrl-O: fuzzy repo switcher
_repo_widget() { repo; zle reset-prompt; }
zle -N _repo_widget
bindkey '^O' _repo_widget

# Ctrl-G: fuzzy branch switcher
_gs_widget() { gs; zle reset-prompt; }
zle -N _gs_widget
bindkey '^G' _gs_widget

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
