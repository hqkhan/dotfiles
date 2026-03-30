#!/usr/bin/env bash
# Extract the command from a tmux buffer that contains a prompt block.
# Input: tmux buffer content starting from " <cmd>" through to the next prompt.
# Output: just the command (including multi-line continuations), copied to tmux buffer + clipboard.

buf=$(tmux save-buffer -)

# Extract command: first line after , plus continuation lines
cmd=$(echo "$buf" | awk '
BEGIN { started = 0; cmd = "" }
{
  if (!started) {
    # First line: strip the prompt character " " prefix
    sub(/^[[:space:]]*[[:space:]]?/, "")
    cmd = $0
    started = 1
  } else {
    # Continuation: line starts with > or ∙ (starship default) or previous line ended with \
    if (/^[>∙][[:space:]]/ || prev_continued) {
      # Strip the continuation prompt prefix
      sub(/^[>∙][[:space:]]?/, "")
      cmd = cmd "\n" $0
    } else {
      exit
    }
  }
  prev_continued = /\\$/
}
END { print cmd }
')

# Load back into tmux buffer and attempt clipboard copy
printf '%s' "$cmd" | tmux load-buffer -
printf '%s' "$cmd" | tmux load-buffer -w - 2>/dev/null  # -w flag copies to client clipboard
tmux display-message "Copied command: $(printf '%.60s' "$cmd")..."
