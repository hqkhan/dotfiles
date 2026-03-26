#!/bin/bash
name="$1"
shift

target=$(tmux list-windows -F "#{window_index}:#{window_name}" | grep -F "$name" | head -1 | cut -d: -f1)

if [ -n "$target" ]; then
    tmux select-window -t "$target"
else
    tmux new-window -n "$name" "lazygit $*"
fi
