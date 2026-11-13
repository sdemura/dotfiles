# tmux configuration

Guide to [tmux.conf](../tmux.conf). The configuration uses tmux 3.8 floating
panes, vi-style navigation, persistent scratch terminals, and agent status dots.
It uses tmux's built-in commands and requires no plugin manager.

## Setup and reload

Use tmux 3.8 or later. Load the configuration through `~/.tmux.conf`.
For a new installation with no existing file at that path:

```sh
ln -s ~/.dotfiles/tmux.conf ~/.tmux.conf
```

The terminal inside tmux is `tmux-256color`. If that terminfo entry is missing,
compile the supplied source from the repository root:

```sh
tic -x tmux-256color.src
```

Ghostty must permit clipboard writes for OSC 52 clipboard support:

```ini
clipboard-write = allow
```

Press `Ctrl+b`, then `R`, to reload the configuration. From a shell inside tmux:

```sh
tmux source-file ~/.tmux.conf
```

## Shortcuts

**Prefix** means press `Ctrl+b`, release it, then press the listed key.
Uppercase keys require Shift. For `Prefix Ctrl+r`, press `Ctrl+b`, then
press `Ctrl+r`.

Window and pane numbers start at **1**. Windows renumber when one closes.
`Prefix 0` is reserved for the floating scratch terminal.

### General controls

| After Prefix | Action |
| --- | --- |
| `0` | Show or hide the floating scratch terminal. |
| `u` | Show shortcut descriptions. |
| `R` | Reload `~/.tmux.conf`. |
| `r` | Set the current pane's border label. An empty label restores the process name. |
| `Ctrl+r` | Restart the current pane's command after confirmation. |
| `Space` | Show pane numbers and wait for a selection. |
| `q` | Show pane numbers briefly. |
| `Tab` | Select the last window. |
| `;` | Select the last pane. |
| `1`–`9` | Select a window by number. |
| `,` | Rename the current window. |
| `z` | Toggle pane zoom. |
| `d` | Detach the current client. |

`q`, `;`, number selection, `,`, `z`, and `d` retain tmux's default bindings.
The pane label set by `r` is separate from the window name and terminal title.

### Move and resize panes

| After Prefix | Action |
| --- | --- |
| `h`, `j`, `k`, `l` | Select the pane left, below, above, or right. |
| `Ctrl+h`, `Ctrl+j`, `Ctrl+k`, `Ctrl+l` | Select a pane in the same directions. |
| `H`, `J`, `K`, `L` | Resize left, down, up, or right by five columns or lines. |
| `<`, `>` | Swap the current window with its left or right neighbor. |

Resize and window-swap keys can repeat without pressing Prefix again while
tmux's repeat timer is active.

### Create panes and windows

All these commands start in the **active pane's current directory**.

| After Prefix | Action |
| --- | --- |
| `c` | Create a window. |
| `\|` or `%` | Split the current pane into panes side by side. |
| `-` or `"` | Split the current pane into panes above and below. |
| `\` | Split across the full window height, side by side. |
| `_` | Split across the full window width, above and below. |

Click the **+ after the last tab** to create a window in the active pane's current
directory. The button also works inside floating scratch terminals.

## Floating scratch terminal

Press `Prefix 0` or click the **gray dot beside the session name**. The float
occupies 80% of the terminal's width and height and has a blue border. The parent
status bar stays available, so the same dot can hide or reopen the float.

Each parent session has its own scratch session:

- First creation starts in the active pane's current directory.
- Hiding the float leaves its shells, running commands, panes, and windows alive.
- Reopening it restores the existing scratch session and its current directory.
- Renaming the parent session keeps the same scratch session.
- Another parent session gets a separate scratch session.

Normal tmux shortcuts work inside the float. Use `Prefix c` for another scratch
window, split it into panes, or use `Prefix 0` to hide it. Scratch windows retain
their own working directories.

Exit a scratch shell with `exit` or `Ctrl+d` at an empty shell prompt. Other
scratch panes and windows stay open. When the final shell exits, the scratch
session ends. The gray launcher dot stays visible. Its next use creates a new
scratch session in the active pane's current directory.

The float can open above a zoomed pane without clearing the parent's zoom state.
Its outer border shows the selected scratch pane's label or process name and
its agent status. Inner scratch pane labels are hidden.

Scratch sessions use names such as `popup-3`, based on the parent's stable tmux
session ID. The floating pane attaches a client to that session on the same tmux
server. Closing the float detaches that client and preserves the session.
Keep the `popup-` session-name prefix reserved for these scratch sessions.

## Copy mode and mouse selection

Copy mode uses vi keys. Press `Prefix [` to enter it, or scroll up with the mouse
wheel. Use the usual vi motions to move through history. Press `Space` to begin
a keyboard selection.

| In copy mode, without Prefix | Action |
| --- | --- |
| `y` | Copy the selection and exit copy mode. |
| `Y` | Copy the selection, clear it, and keep copy mode and the scroll position. |
| `Escape` | Exit copy mode. |
| `/` | Search forward as text is entered. |
| `?` | Search backward as text is entered. |

From normal mode, `Prefix /` opens a search **backward** through history.
`Prefix ?` opens a search **forward**. Those entry shortcuts differ from the
search keys used after entering copy mode.

Mouse selection waits for an explicit copy:

- Drag to select text. Releasing the mouse keeps the selection.
- Double-click to select a word, full path, or filename. `/` and `.` stay within
  words for both double-click selection and keyboard word movement.
- Triple-click to select a line.
- Press `y` to copy and exit copy mode. Press `Y` to copy and keep the scroll position.
- Press `Escape` to leave copy mode without copying.
- Left-click inside another pane to exit copy mode in the previous pane.
  This clears any uncopied selection and returns that pane to live output.
  Clicking inside the same pane keeps copy mode and the scroll position.
  Keyboard pane changes also keep the previous pane's scroll position.

Applications that handle mouse input receive their normal clicks. The copy-mode
scrollbar appears on the right and hides after half a second of inactivity.
Scrolling down at the bottom of history exits copy mode. Use the default
`Prefix ]` to paste tmux's buffer. System clipboard copying uses the terminal's
OSC 52 support.

## Status bar and pane labels

The bottom status bar has a divider above the window tabs. It shows the parent
session name and scratch launcher on the left. On the right, it shows the
24-hour clock and indicators for Prefix, copy mode, and zoom.
The muted **+** after the last tab creates another window.

Split panes show a label along the top border. The label defaults to the current
process name. A single ordinary pane has no top label. Use `Prefix r` to set a
custom label without changing the window name or terminal title.

Colored dots in window tabs and pane labels show agent state:

| Color | Meaning |
| --- | --- |
| Yellow | Working. |
| Red | Action or permission required. |
| Green | Ready or finished. |
| Gray | Claude session started, before a work event. |

Window tabs include the status dots from every agent pane in that window.
The separate gray launcher dot beside the parent session name opens the scratch
terminal; it is not an agent status indicator.

Codex state comes from its terminal title while `codex` is the pane's current
command. Claude state comes from configured hooks that call
[agent-status.py](agent-status.py) with the `claude` argument. That helper reads
the hook event from standard input and updates the owning pane. It ignores
child-agent events. Stale Claude state is hidden after a pane process changes.

## Terminal behavior

Colors follow the terminal's light or dark palette. The configuration also
sets a 50,000-line history limit, immediate Escape handling, focus events,
clipboard support, and graphics passthrough. Pane borders, prompts, selections,
and menus use the terminal palette. True-color and cursor-shape support are
explicitly enabled for Ghostty. Other terminals use tmux's capability detection.

## Check configuration changes

From the repository root:

```sh
python3 tmux/check.py
```

The check uses a disposable tmux server and a terminal client. It covers config
reloads, terminal rules, Codex title states, copy and mouse behavior, pane labels,
scratch session persistence, working directories, window tabs, zoom, and separate
parent sessions. It removes its test server when it finishes. Python 3 is
required for this check and the Claude hook helper.
