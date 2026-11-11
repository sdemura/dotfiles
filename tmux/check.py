#!/usr/bin/env python3
"""Check tmux behavior on a disposable server: python3 tmux/check.py."""

import fcntl
import os
from pathlib import Path
import pty
import select
import struct
import subprocess
import tempfile
import termios
import time


def check(folder):
    config = Path(__file__).resolve().parents[1] / "tmux.conf"
    tmux = ["tmux", "-S", str(folder / "test.sock")]
    env = dict(os.environ, TERM="xterm-256color")
    env.pop("TMUX", None)
    client = master = None

    def run(*args):
        result = subprocess.run(tmux + list(args), env=env, text=True, capture_output=True)
        if result.returncode:
            raise RuntimeError(f"{args}: {result.stderr}")
        return result.stdout.strip()

    def value(target, format_string):
        return run("display-message", "-p", "-t", target, format_string)

    def drain(seconds=0.15):
        output = b""
        end = time.monotonic() + seconds
        while time.monotonic() < end:
            if select.select([master], [], [], max(0, end - time.monotonic()))[0]:
                output += os.read(master, 65536)
        return output.decode(errors="replace")

    def wait(predicate):
        end = time.monotonic() + 4
        while not predicate():
            assert time.monotonic() < end, "timed out waiting for tmux"
            drain(0.03)

    def keys(data):
        os.write(master, data)
        drain()

    def clients():
        return run("list-clients", "-F", "#{session_name}").splitlines()

    def popup(parent):
        return "popup-" + parent.removeprefix("$")

    try:
        # Include shell quotes and a literal tmux format in the starting path.
        cwd = folder / "space ' \" #{session_name}"
        cwd.mkdir()
        root = run(
            "-f", "/dev/null", "new-session", "-d", "-P", "-F", "#{pane_id}",
            "-s", "parent with ' quotes", "-c", str(cwd).replace("#", "##"), "/bin/sh -i",
        )
        parent = value(root, "#{session_id}")
        run("set-option", "-g", "default-shell", "/bin/sh")
        run("source-file", str(config))
        assert Path(value(root, "#{pane_current_path}")).resolve() == cwd.resolve()
        initial = [run("show-options", "-s", option) for option in
                   ("terminal-features", "terminal-overrides")]
        for _ in range(2):
            run("source-file", str(config))
        assert initial == [run("show-options", "-s", option) for option in
                           ("terminal-features", "terminal-overrides")]
        assert value(root, "#{status}") == "2"
        assert value(root, "#{E:window-status-format}") == value(
            root, "#{E:window-status-current-format}"
        )
        assert "tpm" not in run("list-keys", "-T", "prefix")
        print("PASS: config loads; reloads preserve terminal rules and tab text")

        master, slave = pty.openpty()
        fcntl.ioctl(slave, termios.TIOCSWINSZ, struct.pack("HHHH", 32, 120, 0, 0))
        client = subprocess.Popen(
            tmux + ["-u", "attach-session", "-t", parent],
            env=env, stdin=slave, stdout=slave, stderr=slave,
        )
        os.close(slave)
        drain(0.4)

        pid = value(root, "#{pane_pid}")
        title = value(root, "#{pane_title}")
        for name in ("notes, 'quoted'", 'review "quotes"; #{pane_id} \\ path', "0", ""):
            keys(b"\x02r")
            keys(b"\x15" + name.encode() + b"\r")
            actual = run("show-options", "-pqv", "-t", root, "@pane_label")
            assert actual == name, (name, actual)
        assert value(root, "#{pane_title}") == title
        keys(b"\x02\x12")
        keys(b"n")
        assert value(root, "#{pane_pid}") == pid
        print("PASS: r names the pane; Ctrl-r requires confirmation")

        run("send-keys", "-t", root, "-l",
            "i=0; while [ $i -lt 80 ]; do echo 'alpha beta gamma'; i=$((i+1)); done")
        run("send-keys", "-t", root, "Enter")
        drain(0.4)
        for clicks, in_copy_mode in ((2, False), (3, False), (2, True), (3, True)):
            run("set-buffer", "untouched")
            if in_copy_mode:
                run("copy-mode", "-t", root)
                run("send-keys", "-t", root, "-X", "-N", "5", "scroll-up")
            for _ in range(clicks):
                os.write(master, b"\x1b[<0;3;5M\x1b[<0;3;5m")
                drain(0.06)
            drain(0.7)
            assert value(root, "#{pane_mode}") == "copy-mode"
            assert run("show-buffer") == "untouched"
            scroll = value(root, "#{scroll_position}")
            keys(b"y")
            assert run("show-buffer") == ("alpha" if clicks == 2 else "alpha beta gamma")
            assert value(root, "#{pane_mode}") == "copy-mode"
            assert value(root, "#{scroll_position}") == scroll
            keys(b"\x1b")
            drain(0.35)
        print("PASS: word/line clicks wait for y; copying keeps mode and scroll position")

        assert value(root, "#{pane-border-status}") == "off"
        split = run("split-window", "-d", "-P", "-F", "#{pane_id}",
                    "-t", root, "/bin/sh -i")
        wait(lambda: value(root, "#{pane-border-status}") == "top")
        for pane, color in ((root, "yellow"), (split, "green")):
            run("set-option", "-p", "-t", pane, "@agent_process",
                value(pane, "#{pane_pid}:#{pane_current_command}"))
            run("set-option", "-p", "-t", pane, "@agent_status", color)
            assert f"fg={color}" in value(pane, "#{E:pane-border-format}")
        tab = value(root, "#{E:window-status-current-format}")
        assert tab == value(root, "#{E:window-status-format}")
        assert tab.count("●") == 2 and "fg=yellow" in tab and "fg=green" in tab
        run("set-option", "-pu", "-t", root, "@agent_status")
        run("set-option", "-pu", "-t", root, "@agent_process")
        run("kill-pane", "-t", split)
        wait(lambda: value(root, "#{pane-border-status}") == "off")
        print("PASS: split labels and shared tab text keep each agent dot")

        keys(b"\x02g")
        wait(lambda: popup(parent) in clients())
        scratch = value(popup(parent) + ":", "#{pane_id}")
        assert Path(value(scratch, "#{pane_current_path}")).resolve() == cwd.resolve(), (
            str(cwd), value(root, "#{pane_current_path}"),
            value(scratch, "#{pane_current_path}"),
            "\n".join(line for line in run("show-messages").splitlines()
                      if "display-popup" in line or "run-shell -C" in line)[:2500],
        )
        assert value(scratch, "#{pane-border-status}") == "top"
        original = value(scratch, "#{window_id}")
        extra = run("new-window", "-P", "-F", "#{pane_id}",
                    "-t", popup(parent) + ":", "/bin/sh -i")
        wait(lambda: value(extra, "#{pane-border-status}") == "top")
        keys(b"\x02g")
        wait(lambda: len(clients()) == 1)
        run("rename-session", "-t", parent, "renamed parent")
        keys(b"\x02g")
        wait(lambda: popup(parent) in clients())
        assert original in run("list-windows", "-t", popup(parent), "-F", "#{window_id}").splitlines()
        closing = value(extra, "#{window_id}")
        run("send-keys", "-t", extra, "C-d")
        wait(lambda: closing not in run("list-windows", "-t", popup(parent),
                                       "-F", "#{window_id}").splitlines())
        assert "no such window" not in drain(0.3).lower()
        assert value(scratch, "#{pane-border-status}") == "top"
        keys(b"\x02g")
        wait(lambda: len(clients()) == 1)
        print("PASS: popup paths, persistent tabs, parent renames, labels, and Ctrl-d")

        other = run("new-session", "-d", "-P", "-F", "#{session_id}",
                    "-s", "another parent", "/bin/sh -i")
        run("switch-client", "-t", other)
        keys(b"\x02g")
        wait(lambda: popup(other) in clients())
        assert popup(other) != popup(parent)
        assert run("has-session", "-t", popup(parent)) == ""
        print("PASS: parent sessions use separate popups")
    finally:
        if client is not None:
            client.kill()
            client.wait(timeout=3)
        if master is not None:
            os.close(master)
        subprocess.run(tmux + ["kill-server"], env=env, capture_output=True)


if __name__ == "__main__":
    with tempfile.TemporaryDirectory(prefix="tmux-check-") as directory:
        check(Path(directory))
