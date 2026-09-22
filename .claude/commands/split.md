---
description: Fork this session into a new tmux window (optionally with a label).
---

Fork the current session into a new tmux window using `--fork-session`, so this
thread and the fork share history up to now but evolve independently.

**Label (optional):** $ARGUMENTS

Pick the tmux window name:
- If a label was given, use `claude-branch-<slug>` where `<slug>` is the label
  lowercased, spaces → `-`, stripped of anything not `[a-z0-9-]`.
- If no label was given, use `claude-branch`.

Then run **exactly one** command:

```
tmux new-window -n '<window-name>' "claude -r $CLAUDE_CODE_SESSION_ID --fork-session"
```

After it returns, confirm to the user that the branch opened in a new tmux window
and state the window name so they can find it.
