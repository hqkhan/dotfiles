#!/bin/bash
(sesh list --icons && find /local/home/$USER/workspace/*/src/* -maxdepth 0 -type d 2>/dev/null) | awk -v home="$HOME" '{ norm=$0; gsub(/^[^ ]* /, "", norm); sub("^~", home, norm); if (!seen[norm]++) print }'
