#!/usr/bin/env bash
# Project picker for tmux popups: Enter opens/switches, Tab marks, Ctrl-d kills
# the marked (or highlighted) sessions, Ctrl-t shows only open sessions.
set -euo pipefail

selection=$(
  sesh list --icons --hide-duplicates | fzf \
    --multi --no-sort --ansi --reverse \
    --border-label ' sessions ' --prompt '⚡  ' \
    --header 'enter open · tab mark · ^d kill · ^t open sessions · ^a all' \
    --bind 'ctrl-a:change-prompt(⚡  )+reload(sesh list --icons --hide-duplicates)' \
    --bind 'ctrl-t:change-prompt(🪟  )+reload(sesh list --tmux --icons)' \
    --bind 'ctrl-d:execute-silent(for s in {+2..}; do tmux kill-session -t "=$s"; done)+clear-selection+reload(sesh list --tmux --icons)' \
    --preview-window 'right:55%' \
    --preview 'sesh preview {2..}'
) || exit 0

sesh connect "$(head -n1 <<<"$selection")"
