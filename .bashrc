# ~/.bashrc

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# alias ls='ls --color=auto'
# PS1='[\u@\h \W]\$ '

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

source ~/.git-prompt.sh
if [ "$color_prompt" = yes ]; then
    PS1='\[\e[0;1;38;5;113m\]-> \[\033[01;34m\]\w\[\033[00m\]\[\e[0;1;38;5;156m\]$(__git_ps1 " (%s)")\[\e[0;38;5;197m\] $\[\e[0m\] '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir

case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add all ssh-keys 
if [ -z "$SSH_AUTH_SOCK" ] ; then
  eval `ssh-agent -s`
  ssh-add `find ~/.ssh -not -name "*.pub" -name "id_*"`
fi

#export REQUESTS_CA_BUNDLE=/etc/ssl/certs/ca-certificates.crt

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

export COLORTERM="truecolor"
alias ss="source ~/.bashrc"
alias auth="kinit -f && mwinit -o"
alias breakglass="mwinit -o --breakglass"
alias bb="brazil-build"
alias lg="git log --pretty='%C(Yellow)%h  %C(reset)%ad (%C(Green)%cr%C(reset))%x09 %C(Cyan)%an: %C(reset)%s' --graph --date=short --date-order"
alias get-creds="/apollo/env/AmazonAwsCli/bin/isengard get $ACCOUNT_NUMBER $ROLE_NAME"

export INPUTRC="$HOME/.inputrc"

bind -f $INPUTRC

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Setting fd as the default source for fzf
FD_OPTS="--hidden --follow --exclude .git --exclude node_modules"
export FZF_DEFAULT_COMMAND="fd --strip-cwd-prefix --type f --type l $FD_OPTS"

FZF_OPTS="--info=inline --border --keep-right --preview-window=down --bind alt-a:select-all,alt-d:deselect-all"
export FZF_DEFAULT_OPTS="$FZF_OPTS --color=bg+:#100E23,gutter:#323F4E,pointer:#F48FB1,info:#ffe6b3,hl:#F48FB1,hl+:#F48FB1"

# To apply the command to CTRL-T as well
# export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_CTRL_T_OPTS="--layout=reverse"
export FZF_CTRL_R_OPTS="--height=50%"

# Use fd to generate the list for directory completion
cd_with_fzf() {
    cd "$(fd --type d --hidden --follow --exclude "*.git" . "$PWD" | fzf $FZF_DEFAULT_OPTS --layout=reverse --preview="tree -C {} | head -200" -m)"
}

# CTRL-G for changing directories
# bind '"\C-g":"cd_with_fzf\n"'
# OS-X
bind '"\C-g":"cd_with_fzf\C-M"'

export MANPAGER="sh -c 'col -bx | bat -l man -p'"
LS_COLORS='rs=0:di=1;95:ln=4;94;1:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arc=01;31:*.arj=01;31:*.taz=01;31:*.lha=01;31:*.lz4=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.tzo=01;31:*.t7z=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.dz=01;31:*.gz=01;31:*.lrz=01;31:*.lz=01;31:*.lzo=01;31:*.xz=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.alz=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.cab=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.axv=01;35:*.anx=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.axa=00;36:*.oga=00;36:*.spx=00;36:*.xspf=00;36:';
export LS_COLORS
export EDITOR=/usr/bin/nvim

# Get the colors in the opened man page itself
export MANPAGER="sh -c 'col -bx | bat -l man -p --paging always'"

# yadm / dotfiles
# need to add -C $HOME or `dot ls-files|grep` fails inside a git repo
# TODO: messes up the autocomplete, removed for now
alias yadm='$HOME/bin/yadm --yadm-repo $HOME/dots/yadm-repo'
alias dot='$HOME/bin/yadm --yadm-repo $HOME/dots/yadm-repo'

# Source all custom functions
source $HOME/.bash_func

. "$HOME/.cargo/env"
