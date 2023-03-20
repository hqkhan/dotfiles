#!/bin/sh

FZF_OPTS="--no-mouse --height=50% --multi --delimiter='[ :]'"
FZF_OPTS="$FZF_OPTS --info=inline --border --preview-window=down"
FZF_BINDS="alt-a:select-all,alt-d:deselect-all"
FZF_PREVIEW_OPTS="hidden:border:nowrap,right:60%"
FZF_CTRL_R_OPTS="--height=50% --no-separator --info=inline"
FZF_CTRL_T_OPTS="--layout=reverse"
FZF_OPTS_COLORS="bg+:#100E23,gutter:#323F4E,pointer:#F48FB1,info:#ffe6b3,hl:#F48FB1,hl+:#F48FB1"

# Use fzf inside tmux popup if possible
if [ -n $TMUX ]; then
  export FZF_TMUX_OPTS="-p80%,60% --color=border:yellow -- --margin=0,0"
  export FZF_CTRL_T_OPTS="${FZF_CTRL_T_OPTS} --preview-window=hidden"
  export FZF_CTRL_R_OPTS=$FZF_CTRL_R_OPTS
fi

# use `bat` for preview if installed, `head` otherwise
# https://github.com/sharkdp/bat
if command -v bat > /dev/null 2>&1; then
  FZF_PREVIEW_CMD="bat --style=numbers --color=always {} || ls -la {}"
  # bat options
  # for list of themes `bat --list-themes`
  export BAT_PAGER="less -R"
  export BAT_THEME="1337"
else
  FZF_PREVIEW_CMD="head -n FZF_PREVIEW_LINES {} || ls -la {}"
fi

# construct ${FZF_DEFAULT_OPTS}
export FZF_DEFAULT_OPTS="$FZF_OPTS --bind='$FZF_BINDS' --preview-window='$FZF_PREVIEW_OPTS' --preview='$FZF_PREVIEW_CMD' --color='$FZF_OPTS_COLORS'"

# use `rg` if installed
# https://github.com/BurntSushi/ripgrep
if command -v rg > /dev/null 2>&1; then
  RG_OPTS="--files --no-ignore --hidden --follow -g '!{.git,node_modules}/*' 2> /dev/null"
  export FZF_DEFAULT_COMMAND="rg $RG_OPTS"
  export FZF_CTRL_T_COMMAND="rg $RG_OPTS"
fi

# use `fd` if installed
# https://github.com/sharkdp/fd
if command -v fd > /dev/null 2>&1; then
  FD_OPTS="--hidden --follow --exclude .git --exclude node_modules"
  export FZF_DEFAULT_COMMAND="fd --strip-cwd-prefix --type f --type l $FD_OPTS"
  export FZF_CTRL_T_COMMAND="fd --strip-cwd-prefix $FD_OPTS"
  export FZF_ALT_C_COMMAND="fd --type d $FD_OPTS"
  # export FZF_ALT_C_COMMAND="fd --type d $FD_OPTS . ~"
fi
