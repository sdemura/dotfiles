#!/usr/bin/env python3
"""Check tmux behavior on a disposable server: python3 tmux/check.py."""

import fcntl
from itertools import product
import os
from pathlib import Path
import pty
import re
import select
import shlex
import struct
import subprocess
import sys
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

    def popup_indicator(parent, color="themelightgrey"):
        left = value(parent, "#{E:status-left}")
        return ("│ ● │" in re.sub(r"#\[[^\]]*\]", "", left)
                and f"fg={color} nobold] ● " in left)

    def new_window_button_x(target):
        # Sentinels preserve the padding that run() normally strips.
        tabs = value(target, "|#{W:#{E:window-status-format}#{?loop_last_flag,,#{E:window-status-separator}}}|")[1:-1]
        left = value(target, "|#{T;=/#{status-left-length}:status-left}|")[1:-1]
        bar = re.sub(r"#\[[^\]]*\]", "", left + tabs)
        assert bar.count("+") == 1, bar
        return bar.index("+") + 1

    def click(x, y):
        keys(f"\x1b[<0;{x};{y}M\x1b[<0;{x};{y}m".encode())

    try:
        # Include shell quotes and a literal tmux format in the starting path.
        cwd = folder / "space ' \" #{session_name}"
        cwd.mkdir()
        root = run(
            "-f", "/dev/null", "new-session", "-d", "-P", "-F", "#{pane_id}",
            "-s", "parent with ' quotes", "-c", str(cwd).replace("#", "##"), "/bin/sh -i",
        )
        original_clicks = [run("list-keys", "-T", "root", key)
                           for key in ("MouseDown1Status", "MouseDown3StatusLeft")]
        parent = value(root, "#{session_id}")
        run("set-option", "-g", "default-shell", "/bin/sh")
        terminal_defaults = run("show-options", "-s", "terminal-features")
        # Reloads must remove the old rule without removing tmux's defaults.
        run("set-option", "-s", "terminal-features[11]", "*256col*:RGB")
        run("source-file", str(config))
        terminal_features = run("show-options", "-s", "terminal-features").splitlines()
        assert all(entry in terminal_features for entry in terminal_defaults.splitlines())
        assert any("xterm-ghostty:RGB:cstyle" in entry for entry in terminal_features)
        assert not any("*256col*:RGB" in entry for entry in terminal_features)
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
        assert original_clicks == [run("list-keys", "-T", "root", key)
                                   for key in ("MouseDown1Status", "MouseDown3StatusLeft")]
        assert popup_indicator(parent)
        assert popup(parent) not in run("list-sessions", "-F", "#{session_name}").splitlines()
        print("PASS: config loads; reloads preserve terminal rules and tab text")

        # Evaluate the configured tmux format with representative Codex titles.
        title = value(root, "#{pane_title}")
        codex_titles = [
            ("[ ! ] Action Required - Approve command", "red"),
            ("[ . ] Action Required - Choose an option", "red"),
            ("Codex - Review tmux.conf", "green"),
            ("Review ⠋ previous task", "green"),
            ("", "green"),
        ] + [(f"{spinner} Working - Review tmux.conf", "yellow")
             for spinner in "⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏"]
        for prefix in ("", "● "):
            for sample, expected in codex_titles:
                run("select-pane", "-t", root, "-T", prefix + sample)
                actual = value(root, "#{E:@codex-status-color}")
                assert actual == expected, (prefix + sample, expected, actual)
        run("select-pane", "-t", root, "-T", title)
        print("PASS: Codex titles show working, action-required, and ready colors")

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

        # The + belongs to its own mouse range, after the last tab.
        row = int(value(parent, "#{client_height}"))
        click(new_window_button_x(parent), row)
        wait(lambda: value(parent, "#{session_windows}") == "2")
        first_new = value(parent, "#{window_id}")
        assert Path(value(parent, "#{pane_current_path}")).resolve() == cwd.resolve()
        left = re.sub(r"#\[[^\]]*\]", "", value(parent, "|#{T;=/#{status-left-length}:status-left}|")[1:-1])
        click(len(left) + 2, row)
        assert value(parent, "#{pane_id}") == root
        # It must also work when the last tab is inactive.
        click(new_window_button_x(parent), row)
        wait(lambda: value(parent, "#{session_windows}") == "3")
        second_new = value(parent, "#{window_id}")
        assert second_new != first_new
        assert Path(value(parent, "#{pane_current_path}")).resolve() == cwd.resolve()
        new_window_button_x(parent)  # Exactly one + after all three tabs.
        for window in (first_new, second_new):
            run("kill-window", "-t", window)
        assert value(parent, "#{pane_id}") == root
        assert value(root, "#{pane_pid}") == pid
        print("PASS: + creates tabs in the current directory; ordinary tab clicks still select tabs")

        run("send-keys", "-t", root, "-l",
            "i=0; while [ $i -lt 80 ]; do echo '/tmp/my_file-name.py beta gamma'; i=$((i+1)); done")
        run("send-keys", "-t", root, "Enter")
        drain(0.4)
        for clicks, in_copy_mode, copy_key in product((2, 3), (False, True), (b"y", b"Y")):
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
            keys(copy_key)
            assert run("show-buffer") == (
                "/tmp/my_file-name.py" if clicks == 2 else "/tmp/my_file-name.py beta gamma"
            )
            if copy_key == b"Y":
                assert value(root, "#{pane_mode}") == "copy-mode"
                assert value(root, "#{scroll_position}") == scroll
                assert value(root, "#{selection_present}") == "0"
                keys(b"\x1b")
            else:
                assert value(root, "#{pane_mode}") == ""
            drain(0.35)
        print("PASS: word/line selection waits for copying; y exits copy mode; Y keeps scroll position")

        assert value(root, "#{pane-border-status}") == "off"
        split = run("split-window", "-d", "-P", "-F", "#{pane_id}",
                    "-t", root, "/bin/sh -i")
        wait(lambda: value(root, "#{pane-border-status}") == "top")

        # Drag and copy in scrolled history without returning to live output.
        run("copy-mode", "-t", root)
        run("send-keys", "-t", root, "-X", "-N", "5", "scroll-up")
        scroll = value(root, "#{scroll_position}")
        assert int(scroll) > 0
        row = int(value(root, "#{pane_top}")) + 3
        run("set-buffer", "untouched")
        keys(f"\x1b[<0;1;{row}M\x1b[<32;20;{row}M\x1b[<0;20;{row}m".encode())
        assert value(root, "#{pane_mode}") == "copy-mode"
        assert value(root, "#{scroll_position}") == scroll
        assert value(root, "#{selection_present}") == "1"
        assert run("show-buffer") == "untouched"
        drain(0.35)
        click(20, row)
        assert value(root, "#{pane_mode}") == "copy-mode"
        assert value(root, "#{scroll_position}") == scroll
        keys(b"Y")
        copied = run("show-buffer")
        assert copied == "/tmp/my_file-name.py", copied
        assert value(root, "#{pane_mode}") == "copy-mode"
        assert value(root, "#{scroll_position}") == scroll
        assert value(root, "#{selection_present}") == "0"
        print("PASS: drag, same-pane clicks, and Y keep the scroll position")

        # Both normal panes and panes already in copy mode can receive focus.
        for target_in_copy_mode in (False, True):
            if target_in_copy_mode:
                run("copy-mode", "-t", split)
            run("send-keys", "-t", root, "-X", "begin-selection")
            run("send-keys", "-t", root, "-X", "-N", "3", "cursor-right")
            assert value(root, "#{selection_present}") == "1"
            drain(0.35)  # Each case starts with a single click, not a double-click.
            click(3, int(value(split, "#{pane_top}")) + 3)
            assert value(parent, "#{pane_id}") == split, (
                target_in_copy_mode, run("list-panes", "-F", "#{pane_id}:#{pane_mode}:#{pane_active}")
            )
            assert value(root, "#{pane_mode}") == ""
            assert value(split, "#{pane_mode}") == (
                "copy-mode" if target_in_copy_mode else ""
            )
            assert run("show-buffer") == copied
            run("select-pane", "-t", root)
            run("copy-mode", "-t", root)
            run("send-keys", "-t", root, "-X", "-N", "5", "scroll-up")
        # Keyboard pane changes still preserve the previous pane's history view.
        scroll = value(root, "#{scroll_position}")
        keys(b"\x02j")
        assert value(parent, "#{pane_id}") == split
        assert value(root, "#{pane_mode}") == "copy-mode"
        assert value(root, "#{scroll_position}") == scroll
        keys(b"\x02k")
        assert value(parent, "#{pane_id}") == root
        run("send-keys", "-t", root, "-X", "cancel")
        run("send-keys", "-t", split, "-X", "cancel")
        print("PASS: clicking another pane exits the old copy mode; keyboard changes preserve it")

        # A program requesting mouse input must still receive the selecting click.
        mouse_log = folder / "mouse-event"
        mouse_app = (
            "import os, termios, tty; saved = termios.tcgetattr(0); tty.setraw(0); "
            "os.write(1, b'\\x1b[?1000h\\x1b[?1006h'); event = os.read(0, 128); "
            "termios.tcsetattr(0, termios.TCSANOW, saved); "
            "os.write(1, b'\\x1b[?1000l\\x1b[?1006l'); "
            f"open({str(mouse_log)!r}, 'wb').write(event)"
        )
        run("send-keys", "-t", split, "-l", shlex.join([sys.executable, "-c", mouse_app]))
        run("send-keys", "-t", split, "Enter")
        wait(lambda: value(split, "#{mouse_any_flag}") == "1")
        run("copy-mode", "-t", root)
        drain(0.35)
        click(3, int(value(split, "#{pane_top}")) + 3)
        wait(lambda: mouse_log.exists() and mouse_log.stat().st_size > 0)
        assert mouse_log.read_bytes().startswith(b"\x1b[<0;"), mouse_log.read_bytes()
        assert value(root, "#{pane_mode}") == ""
        assert value(parent, "#{pane_id}") == split
        run("select-pane", "-t", root)
        print("PASS: selecting a pane still forwards the click to its application")

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

        # The dot must create a popup before the keyboard shortcut is used.
        run("rename-window", "-t", root, "align")
        tab_before_popup = value(root, "#{E:window-status-current-format}")
        row = int(value(parent, "#{client_height}"))
        left = re.sub(r"#\[[^\]]*\]", "", value(parent, "#{E:status-left}"))
        dot_x = left.index("●") + 1
        keys(f"\x1b[<0;{dot_x};{row}M\x1b[<0;{dot_x};{row}m".encode())
        wait(lambda: popup(parent) in clients())
        assert value(root, "#{window_name}") == "align"
        assert value(root, "#{E:window-status-current-format}") == tab_before_popup
        assert value(parent, "#{pane_floating_flag}") == "1"
        assert value(parent, "#{pane_modal_flag}") == "1"
        wrapper = value(parent, "#{pane_id}")
        assert value(wrapper, "#{pane-border-status}") == "top"
        assert value(root, "#{pane-border-status}") == "off"
        assert popup_indicator(parent, "blue")
        scratch = value(popup(parent) + ":", "#{pane_id}")
        assert not popup_indicator(scratch)
        assert value(scratch, "#{E:status-left}") == ""
        assert value(scratch, "#{status}") == "2"
        assert Path(value(scratch, "#{pane_current_path}")).resolve() == cwd.resolve(), (
            str(cwd), value(root, "#{pane_current_path}"),
            value(scratch, "#{pane_current_path}"),
            "\n".join(line for line in run("show-messages").splitlines()
                      if "display-popup" in line or "run-shell -C" in line)[:2500],
        )
        assert value(scratch, "#{pane-border-status}") == "off"
        assert value(wrapper, "#{E:pane-border-format}") == value(
            scratch, "#{E:pane-border-format}"
        )
        # The outer border must follow process changes without changing titles.
        run("rename-window", "-t", scratch, "scratch-tab")
        drain()
        # Escape the command name so only the border can print plain "sleep".
        run("send-keys", "-t", scratch, "-l", "slee\\p 30")
        run("send-keys", "-t", scratch, "Enter")
        wait(lambda: value(scratch, "#{pane_current_command}") == "sleep")
        assert " sleep " in value(wrapper, "#{E:pane-border-format}")
        assert "sleep" in drain(1.3), "outer border did not redraw the live process"
        run("send-keys", "-t", scratch, "C-c")
        wait(lambda: value(scratch, "#{pane_current_command}") != "sleep")
        # Split labels stay hidden inside the scratch terminal. The active
        # pane's custom name and agent dot still appear in the outer border.
        scratch_split = run("split-window", "-P", "-F", "#{pane_id}",
                            "-t", scratch, "/bin/sh -i")
        assert value(scratch, "#{pane-border-status}") == "off"
        run("set-option", "-p", "-t", scratch_split, "@pane_label", "review 'quoted' #{pane_id}")
        run("set-option", "-p", "-t", scratch_split, "@agent_process",
            value(scratch_split, "#{pane_pid}:#{pane_current_command}"))
        run("set-option", "-p", "-t", scratch_split, "@agent_status", "green")
        outer_label = value(wrapper, "#{E:pane-border-format}")
        assert outer_label == value(scratch_split, "#{E:pane-border-format}")
        assert "fg=green" in outer_label and "●" in outer_label
        assert "review 'quoted' ##{pane_id}" in outer_label
        run("select-pane", "-t", scratch)
        assert value(wrapper, "#{E:pane-border-format}") == value(
            scratch, "#{E:pane-border-format}"
        )
        run("kill-pane", "-t", scratch_split)
        original = value(scratch, "#{window_id}")
        # A + inside the float creates a scratch tab, not a parent tab.
        parent_windows = value(parent, "#{session_windows}")
        click(int(value(wrapper, "#{pane_left}")) + new_window_button_x(popup(parent)),
              int(value(wrapper, "#{pane_top}")) + int(value(wrapper, "#{pane_height}")))
        wait(lambda: value(popup(parent), "#{session_windows}") == "2")
        assert value(parent, "#{session_windows}") == parent_windows
        assert Path(value(popup(parent), "#{pane_current_path}")).resolve() == cwd.resolve()
        run("kill-window", "-t", value(popup(parent), "#{window_id}"))
        assert value(popup(parent), "#{pane_id}") == scratch
        print("PASS: the + inside a scratch terminal creates a tab in its own session")
        # Prefix commands must reach the inner session.
        keys(b"\x02c")
        wait(lambda: len(run("list-windows", "-t", popup(parent)).splitlines()) == 2)
        extra = value(popup(parent) + ":", "#{pane_id}")
        assert value(extra, "#{pane-border-status}") == "off"
        run("set-option", "-p", "-t", extra, "@pane_label", "second scratch tab")
        assert "second scratch tab" in value(wrapper, "#{E:pane-border-format}")
        # Reloading while open must preserve the outer label and inner layout.
        run("source-file", str(config))
        assert popup_indicator(parent, "blue")
        assert value(wrapper, "#{pane-border-status}") == "top"
        assert value(extra, "#{pane-border-status}") == "off"
        assert "second scratch tab" in value(wrapper, "#{E:pane-border-format}")
        print("PASS: only the outer scratch border shows the live process, custom name, and agent dot")
        keys(b"\x020")
        wait(lambda: len(clients()) == 1)
        wait(lambda: value(root, "#{window_panes}") == "1")
        assert value(root, "#{E:window-status-current-format}") == tab_before_popup
        assert popup_indicator(parent)
        run("rename-session", "-t", parent, "renamed parent")
        assert popup_indicator(parent)
        # A click on the session name must not open the popup.
        row = int(value(parent, "#{client_height}"))
        keys(f"\x1b[<0;2;{row}M\x1b[<0;2;{row}m".encode())
        assert len(clients()) == 1
        left = re.sub(r"#\[[^\]]*\]", "", value(parent, "#{E:status-left}"))
        dot_x = left.index("●") + 1
        keys(f"\x1b[<0;{dot_x};{row}M\x1b[<0;{dot_x};{row}m".encode())
        wait(lambda: popup(parent) in clients())
        assert value(popup(parent) + ":", "#{pane_id}") == extra
        scratch_pids = run("list-panes", "-s", "-t", popup(parent), "-F",
                           "#{pane_id}:#{pane_pid}")
        keys(f"\x1b[<0;{dot_x};{row}M\x1b[<0;{dot_x};{row}m".encode())
        wait(lambda: len(clients()) == 1)
        wait(lambda: value(root, "#{window_panes}") == "1")
        assert value(root, "#{pane-border-status}") == "off"
        assert value(root, "#{pane_pid}") == pid
        assert popup_indicator(parent)
        keys(f"\x1b[<0;{dot_x};{row}M\x1b[<0;{dot_x};{row}m".encode())
        wait(lambda: popup(parent) in clients())
        assert value(popup(parent) + ":", "#{pane_id}") == extra
        assert run("list-panes", "-s", "-t", popup(parent), "-F",
                   "#{pane_id}:#{pane_pid}") == scratch_pids
        keys(b"\x020")
        wait(lambda: len(clients()) == 1)
        wait(lambda: value(root, "#{window_panes}") == "1")
        # The float must also work above a zoomed pane without clearing zoom.
        zoom_split = run("split-window", "-d", "-P", "-F", "#{pane_id}",
                         "-t", root, "/bin/sh -i")
        run("resize-pane", "-Z", "-t", root)
        assert value(root, "#{window_zoomed_flag}") == "1"
        zoomed_tab = value(root, "#{E:window-status-current-format}")
        assert "alignZ" in zoomed_tab
        keys(f"\x1b[<0;{dot_x};{row}M\x1b[<0;{dot_x};{row}m".encode())
        wait(lambda: popup(parent) in clients())
        assert value(root, "#{window_zoomed_flag}") == "1"
        assert value(parent, "#{pane_floating_flag}") == "1"
        assert value(root, "#{E:window-status-current-format}") == zoomed_tab
        print("PASS: popup leaves tab text unchanged, including the zoom indicator")
        print("PASS: dot clicks open, hide, and reopen; scratch tabs and processes survive")
        assert original in run("list-windows", "-t", popup(parent), "-F", "#{window_id}").splitlines()
        closing = value(extra, "#{window_id}")
        run("send-keys", "-t", extra, "C-d")
        wait(lambda: closing not in run("list-windows", "-t", popup(parent),
                                       "-F", "#{window_id}").splitlines())
        assert "no such window" not in drain(0.3).lower()
        assert value(scratch, "#{pane-border-status}") == "off"
        keys(b"\x020")
        wait(lambda: len(clients()) == 1)
        wait(lambda: value(root, "#{window_panes}") == "2")
        assert value(root, "#{window_zoomed_flag}") == "1"
        run("resize-pane", "-Z", "-t", root)
        run("kill-pane", "-t", zoom_split)
        print("PASS: popup paths, persistent tabs, parent renames, labels, and Ctrl-d")

        other = run("new-session", "-d", "-P", "-F", "#{session_id}",
                    "-s", "another parent", "/bin/sh -i")
        assert popup_indicator(other)
        assert popup(other) not in run("list-sessions", "-F", "#{session_name}").splitlines()
        run("switch-client", "-t", other)
        keys(b"\x020")
        wait(lambda: popup(other) in clients())
        assert popup(other) != popup(parent)
        assert run("has-session", "-t", popup(parent)) == ""
        assert popup_indicator(other, "blue")
        assert popup_indicator(parent)
        print("PASS: parent sessions use separate popups")
        last = value(popup(other) + ":", "#{pane_id}")
        run("send-keys", "-t", last, "C-d")
        wait(lambda: len(clients()) == 1 and popup(other) not in
             run("list-sessions", "-F", "#{session_name}").splitlines())
        assert popup_indicator(other)
        assert popup_indicator(parent)
        left = re.sub(r"#\[[^\]]*\]", "", value(other, "#{E:status-left}"))
        dot_x = left.index("●") + 1
        keys(f"\x1b[<0;{dot_x};{row}M\x1b[<0;{dot_x};{row}m".encode())
        wait(lambda: popup(other) in clients())
        assert value(popup(other) + ":", "#{pane_id}") != last
        assert value(scratch, "#{window_id}") == original
        assert popup_indicator(other, "blue")
        print("PASS: dot is blue while open, gray after closing, and creates a new popup after final exit")
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
