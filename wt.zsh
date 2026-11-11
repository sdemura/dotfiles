_wt_usage() {
  print -u2 -- 'Usage:'
  print -u2 -- '  wt add <branch> [base]'
  print -u2 -- '  wt del <branch>'
  print -u2 -- '  wt list'
  print -u2 -- '  wt use [worktree]'
}

_wt_repo_root() {
  local common_dir
  common_dir=$(git rev-parse --path-format=absolute --git-common-dir 2>/dev/null) || {
    print -u2 -- 'Not inside a Git repository.'
    return 1
  }
  print -r -- "${common_dir:h}"
}

_wt_add_worktree() {
  local branch="$1" requested_base="${2:-}"
  local root
  root=$(_wt_repo_root) || return

  local worktree_dir="$HOME/.worktrees/${root:t}"
  local checkout_path="$worktree_dir/$branch"
  if [[ -e "$checkout_path" ]]; then
    print -u2 -- "Worktree '$branch' already exists at $checkout_path"
    return 1
  fi
  mkdir -p "$worktree_dir" || return

  local -a add_args
  local message base remote_ref="origin/$branch"

  if [[ -n "$requested_base" ]]; then
    if git show-ref --verify --quiet "refs/heads/$branch"; then
      print -u2 -- "Branch '$branch' already exists; omit the base to check it out."
      return 1
    fi

    base="$requested_base"
    if ! git show-ref --verify --quiet "refs/heads/$base" && \
        git show-ref --verify --quiet "refs/remotes/origin/$base"; then
      base="origin/$base"
    fi
    add_args=(-b "$branch" "$checkout_path" "$base")
    message="Created worktree '$branch' from $base at $checkout_path"
  elif git show-ref --verify --quiet "refs/heads/$branch"; then
    add_args=("$checkout_path" "$branch")
    message="Opened existing local branch '$branch' at $checkout_path"
  elif git show-ref --verify --quiet "refs/remotes/$remote_ref"; then
    add_args=(--track -b "$branch" "$checkout_path" "$remote_ref")
    message="Created worktree '$branch' tracking $remote_ref at $checkout_path"
  else
    base=$(git symbolic-ref --quiet --short refs/remotes/origin/HEAD 2>/dev/null) || {
      print -u2 -- "Could not determine origin's default branch (origin/HEAD is unset)."
      return 1
    }
    add_args=(-b "$branch" "$checkout_path" "$base")
    message="Created worktree '$branch' from $base at $checkout_path"
  fi

  local output rc
  output=$(git -C "$root" worktree add "${add_args[@]}" 2>&1)
  rc=$?
  if (( rc != 0 )); then
    print -u2 -- "Failed to create worktree '$branch': $output"
    return $rc
  fi

  print -- "$message"
}

_wt_list_worktrees() {
  local root
  root=$(_wt_repo_root) || return
  git -C "$root" worktree list
}

_wt_remove_worktree() {
  local branch="$1"
  local root
  root=$(_wt_repo_root) || return

  local listing checkout_path
  listing=$(git -C "$root" worktree list --porcelain) || return
  checkout_path=$(print -r -- "$listing" | awk -v wanted="refs/heads/$branch" '
    $1 == "worktree" { checkout = substr($0, 10) }
    $1 == "branch" && $2 == wanted { print checkout; exit }
  ')

  if [[ -z "$checkout_path" ]]; then
    print -u2 -- "No worktree found for branch '$branch'."
    return 1
  fi
  if [[ "$checkout_path" == "$root" ]]; then
    print -u2 -- "Refusing to remove the primary checkout at $root."
    return 1
  fi

  local output rc
  output=$(git -C "$root" worktree remove "$checkout_path" 2>&1)
  rc=$?
  if (( rc != 0 )); then
    print -u2 -- "Failed to remove worktree '$branch': $output"
    return $rc
  fi

  print -- "Removed worktree '$branch' at $checkout_path; branch retained."
}

_wt_use_worktree() {
  local requested_name="${1:-}"
  local root listing checkout_path worktree_name selection="" selected_record="" index
  local -a worktree_names worktree_paths

  root=$(_wt_repo_root) || return
  local worktree_dir="$HOME/.worktrees/${root:t}"
  listing=$(git -C "$root" worktree list --porcelain) || return

  while IFS= read -r checkout_path; do
    [[ "$checkout_path" == "$worktree_dir/"* ]] || continue
    worktree_name="${checkout_path#"$worktree_dir/"}"
    worktree_names+=("$worktree_name")
    worktree_paths+=("$checkout_path")
  done < <(print -r -- "$listing" | awk '$1 == "worktree" { print substr($0, 10) }')

  if [[ -n "$requested_name" ]]; then
    selection="$requested_name"
  else
    if (( ${#worktree_names} == 0 )); then
      print -u2 -- "No worktrees exist in $worktree_dir. Create one with 'wt add <name>'."
      return 1
    fi
    if ! command -v fzf >/dev/null 2>&1; then
      print -u2 -- "Required command not found: fzf"
      return 1
    fi
    selected_record=$(
      for (( index = 1; index <= ${#worktree_names}; index++ )); do
        printf '%s\t%s\n' "${worktree_names[$index]}" "${worktree_paths[$index]}"
      done | fzf --layout=reverse --delimiter=$'\t' --with-nth=1 \
        --preview-window=right:66% \
        --preview 'git -C {2} -c color.status=always status --short --branch; printf "\n"; git -C {2} log --color=always --graph --decorate --format="%C(yellow)%h %C(green)%ar %C(reset)%s %C(auto)%d" -20'
    )
    [[ -n "$selected_record" ]] || return 0
    selection="${selected_record%%$'\t'*}"
  fi

  for (( index = 1; index <= ${#worktree_names}; index++ )); do
    if [[ "${worktree_names[$index]}" == "$selection" ]]; then
      print -u2 -- "Switching to $selection"
      builtin cd -- "${worktree_paths[$index]}"
      return
    fi
  done

  print -u2 -- "Worktree '$selection' does not exist in $worktree_dir. Create it with 'wt add $selection'."
  return 1
}

wt() {
  emulate -L zsh
  setopt NO_UNSET PIPE_FAIL

  command -v git >/dev/null 2>&1 || {
    print -u2 -- 'Required command not found: git'
    return 1
  }

  case "${1:-}" in
    add)
      if (( $# < 2 || $# > 3 )); then
        _wt_usage
        return 2
      fi
      _wt_add_worktree "$2" "${3:-}"
      ;;
    del)
      if (( $# != 2 )); then
        _wt_usage
        return 2
      fi
      _wt_remove_worktree "$2"
      ;;
    list)
      if (( $# != 1 )); then
        _wt_usage
        return 2
      fi
      _wt_list_worktrees
      ;;
    use)
      if (( $# > 2 )); then
        _wt_usage
        return 2
      fi
      _wt_use_worktree "${2:-}"
      ;;
    -h|--help|help)
      _wt_usage
      return 0
      ;;
    *)
      _wt_usage
      return 2
      ;;
  esac
}
