# Enable colors and change prompt:
autoload -U colors && colors
case `id -u` in
0) prompt="#";;
*) prompt="$";;
esac
PS1="%B%{$fg[red]%}[%{$fg[yellow]%}%n%{$fg[green]%}@%{$fg[blue]%}%M %{$fg[magenta]%}%~%{$fg[red]%}]%{$reset_color%}${prompt}%b "

# History in cache directory:
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.cache/zsh/history

# Bash-like navigation
autoload -U select-word-style
select-word-style bash

# tmux messes up LS colors, reset to default
[[ ! -z $TMUX ]] && unset LS_COLORS

# make the cache directory if needed
[ ! -d "$HOME/.cache/zsh" ] && mkdir -p "$HOME/.cache/zsh"

# Load aliases and if exists.
[ -f "$HOME/.config/aliases/public" ] && source "$HOME/.config/aliases/public"
[ -f "$HOME/.config/aliases/private" ] && source "$HOME/.config/aliases/private"

alias ss="source $XDG_CONFIG_HOME/zsh/.zshrc"

# add yadm completions to path, must be done before compinit
[ -d "$HOME/dots/yadm" ] && fpath=($HOME/dots/yadm/completion/zsh $fpath)

# Basic auto/tab complete:
autoload -U +X compinit
# zstyle ':completion:*' menu select
zstyle ':completion:::*:default' menu no select
zmodload zsh/complist
compinit
_comp_options+=(globdots)		# Include hidden files.

# emacs mode 
# bindkey -v # vi mode (the equivalent of `set -o vi`)
bindkey -e

# set 1ms timeout for Esc press so we can switch
# between vi "normal" and "command" modes faster
# export KEYTIMEOUT=1

# zoxide - smarter cd
# https://github.com/ajeetdsouza/zoxide
if command -v zoxide > /dev/null 2>&1; then
    eval "$(zoxide init zsh --cmd j)"
fi

# fzf (https://github.com/junegunn/fzf)
# if installed enable fzf keybinds
# Linux possible paths
[ -f /usr/share/fzf/completion.zsh ] && source /usr/share/fzf/completion.zsh
[ -f /usr/share/fzf/key-bindings.zsh ] && source /usr/share/fzf/key-bindings.zsh
[ -f /usr/local/share/fzf/completion.zsh ] && source /usr/local/share/fzf/completion.zsh
[ -f /usr/local/share/fzf/key-bindings.zsh ] && source /usr/local/share/fzf/key-bindings.zsh
[ -f /usr/share/doc/fzf/completion.zsh ] && source /usr/share/doc/fzf/completion.zsh
[ -f /usr/share/doc/fzf/key-bindings.zsh ] && source /usr/share/doc/fzf/key-bindings.zsh
# OSX paths
[ -f /usr/local/opt/fzf/shell/completion.zsh ] && source /usr/local/opt/fzf/shell/completion.zsh
[ -f /usr/local/opt/fzf/shell/key-bindings.zsh ] && source /usr/local/opt/fzf/shell/key-bindings.zsh
[ -f /opt/homebrew/opt/fzf/shell/completion.zsh ] && source /opt/homebrew/opt/fzf/shell/completion.zsh
[ -f /opt/homebrew/opt/fzf/shell/key-bindings.zsh ] && source /opt/homebrew/opt/fzf/shell/key-bindings.zsh

# ^N for generic "live" ripgrep
source $ZDOTDIR/fzf_defaults.sh
[ -f "$ZDOTDIR/fzf_git_functions.sh" ] && source "$ZDOTDIR/fzf_git_functions.sh"
source $ZDOTDIR/fzf_git_keybindings.zsh

# Public funcs
[ -f $HOME/.bash_func ] && source $HOME/.bash_func
# Private conf
[ -f $HOME/.config/bash/.bash_priv ] && source $HOME/.config/bash/.bash_priv
# Private funcs
[ -f $HOME/.config/bash/.bash_priv_func ] && source $HOME/.config/bash/.bash_priv_func

# LF file manager icons
[ -f $HOME/.config/zsh/lf-icons.sh ] && source $HOME/.config/zsh/lf-icons.sh

# Add all ssh-keys 
if [ -z "$SSH_AUTH_SOCK" ] ; then
  eval `ssh-agent -s`
  ssh-add `find ~/.ssh -not -name "*.pub" -name "id_*"`
fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

LS_COLORS='rs=0:di=1;35:ln=4;94;1:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arc=01;31:*.arj=01;31:*.taz=01;31:*.lha=01;31:*.lz4=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.tzo=01;31:*.t7z=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.dz=01;31:*.gz=01;31:*.lrz=01;31:*.lz=01;31:*.lzo=01;31:*.xz=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.alz=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.cab=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.axv=01;35:*.anx=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.axa=00;36:*.oga=00;36:*.spx=00;36:*.xspf=00;36:';
export LS_COLORS

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Don't use any plugins for root
if [ "$EUID" -ne 0 ]; then
    # do we have starship.rs prompt installed?
    if command -v starship > /dev/null 2>&1; then
        HAS_STARSHIP=true
        eval "$(starship init zsh)"
    else
        HAS_STARSHIP=false
    fi

    # https://github.com/mattmc3/antidote
    if [ ! -d ${ZDOTDIR:-~}/.antidote ]; then
        git clone --depth=1 https://github.com/mattmc3/antidote.git ${ZDOTDIR:-~}/.antidote
    fi

    # source antidote
    source ${ZDOTDIR:-~}/.antidote/antidote.zsh

    # https://getantidote.github.io/migrating-from-antigen
    # Initialize antidote's dynamic mode, which changes `antidote bundle`
    # from static mode (instead of `antidote load` & .zsh_plugins.txt).
    source <(antidote init)

    # Syntax highlighting bundle.
    antidote bundle zdharma-continuum/fast-syntax-highlighting
fi # if [ "$EUID" -ne 0 ]; then

bindkey '^l' forward-char
bindkey '^h' backward-char
bindkey '^p' forward-word
bindkey '^f' backward-word
bindkey '^k' up-line-or-history
bindkey '^j' down-line-or-history
