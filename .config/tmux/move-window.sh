#!/bin/bash
target=$(sesh list -t --icons | fzf-tmux -p 60%,50% \
  --no-sort --ansi --reverse --border-label ' move window to session ' --prompt '⚡  ' \
  --color 'border:yellow,label:yellow' \
  --bind 'tab:down,btab:up' \
  --preview-window 'right:55%' \
  --preview 'sesh preview {}')
target=$(echo "$target" | sed 's/^[^ ]* //')
[ -n "$target" ] && tmux move-window -t "$target:" && tmux switch-client -t "$target"
exit 0
