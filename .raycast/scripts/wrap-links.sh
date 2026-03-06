#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Wrap Selection with Link
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 🔗

url=$(pbpaste)
osascript -e 'tell application "System Events" to keystroke "c" using command down'
selected=$(pbpaste)
echo -n "[$selected]($url)" | pbcopy
osascript -e 'tell application "System Events" to keystroke "v" using command down'
echo -n "$url" | pbcopy
