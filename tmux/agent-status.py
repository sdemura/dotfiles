#!/usr/bin/env python3
"""Show Codex and Claude hook events in tmux's window tabs."""

import json
import os
import subprocess
import sys


STATES = {
    "SessionStart": "💤",
    "UserPromptSubmit": "⏳",
    "PermissionRequest": "🙋",
    "PostToolUse": "⏳",
    "PostToolUseFailure": "⏳",
    "Stop": "✅",
    "Interrupt": "💤",
    "SessionEnd": "",
}


def update():
    if len(sys.argv) != 2 or sys.argv[1] not in ("codex", "claude"):
        return
    pane = os.environ.get("TMUX_PANE", "")
    socket = os.environ.get("TMUX", "").rsplit(",", 2)[0]
    if not socket or not pane.startswith("%") or not pane[1:].isdigit():
        return  # Hooks also run outside tmux.

    event = json.load(sys.stdin)
    if not isinstance(event, dict):
        raise ValueError("expected a JSON object")
    # Child agents share the terminal. Only the main agent owns its label.
    thread = os.environ.get("CODEX_THREAD_ID")
    if event.get("agent_id") or (
        sys.argv[1] == "codex" and thread and event.get("session_id") != thread
    ):
        return
    state = STATES.get(event.get("hook_event_name"))
    if state is None:
        return

    tmux = ["tmux", "-S", socket]
    process = subprocess.run(
        tmux + ["display-message", "-p", "-t", pane,
                "#{pane_pid}:#{pane_current_command}"],
        check=True, capture_output=True, text=True, timeout=1,
    ).stdout.strip()
    subprocess.run(
        tmux + ["set-option", "-p", "-t", pane, "@agent_process", process,
                ";", "set-option", "-p", "-t", pane, "@agent_status", state],
        check=True, capture_output=True, timeout=1,
    )


if __name__ == "__main__":
    try:
        update()
    except (OSError, ValueError, subprocess.SubprocessError) as error:
        # A status display must not block the agent.
        print(f"tmux agent status: {error}", file=sys.stderr)
    print("{}")  # Valid hook output, including for Stop and Interrupt.
