#!/usr/bin/env bash
# Standard project layout, started by sesh in window 1 of a new session:
# 1 claude, 2 codex, 3 shell. Git repos only. Targets panes by id because sesh's own
# [[window]] startup_script lands in the active window instead.
set -euo pipefail

git rev-parse --is-inside-work-tree >/dev/null 2>&1 || exit 0

session=$(tmux display-message -p -t "$TMUX_PANE" '#{session_id}')

tmux rename-window -t "$TMUX_PANE" claude
codex_pane=$(tmux new-window -d -t "${session}:" -n codex -c "$PWD" -P -F '#{pane_id}')
tmux send-keys -t "$codex_pane" codex Enter
tmux new-window -d -t "${session}:" -n shell -c "$PWD"

claude
