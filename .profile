PATH=/home/linuxbrew/.linuxbrew/bin:$HOME/.cargo/bin:$HOME/.config/tmux/plugins/t-smart-tmux-session-manager/bin:$HOME/bin:/opt/homebrew/bin:/usr/local/bin:/usr/local/sbin:/bin:/sbin:/usr/bin:/usr/sbin:/opt/local/bin:$HOME/.local/bin:/usr/local/go/bin
MANPATH=/usr/share/man:/usr/local/share/man:/opt/homebrew/share/man
export PATH MANPATH HOME TERM

# use nvim if installed, vi default
case "$(command -v nvim)" in
  */nvim) VIM=nvim ;;
  *)      VIM=vi   ;;
esac

# use neovim as man pager
if [ $VIM = "nvim" ]; then
    export MANPAGER='nvim +Man!'
    export MANWIDTH=999
fi

export EDITOR=$VIM
export FCEDIT=$EDITOR
export PAGER=less
export LESS='-iMRS -x2'
export LANG=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8

# for some reason this gets set over ssh
# and messes up the colors
# unset LS_COLORS

# prevent less from saving history in ~/.lesshst
export LESSHISTFILE=/dev/null

# Void linux without eologind doesn't have $XDG_RUNTIME_DIR defined
# if '/run/user/USER_ID' doesn't exist, create our runtime under /tmp
if [ -z "$XDG_RUNTIME_DIR" ] && [ -d /run/user/$(id -u) ]; then
    export XDG_RUNTIME_DIR=/run/user/$(id -u)
fi
if [ -z "$XDG_RUNTIME_DIR" ]; then
    mkdir -p /tmp/${USER}-runtime && chmod -R 0700 /tmp/${USER}-runtime
    export XDG_RUNTIME_DIR=/tmp/${USER}-runtime
fi

export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export INPUTRC="${XDG_CONFIG_HOME:-$HOME/.config}/inputrc"
export TMUX_TMPDIR="${XDG_RUNTIME_DIR}"

# zsh will look for .zshrc here
export ZDOTDIR="${XDG_CONFIG_HOME:-$HOME/.config}/zsh"

# dotfile repo
export DOTFILES_REPO="$HOME/.cfg"
# private dotfile repo
export DOTFILES_PRIV_REPO="$HOME/.cfg_priv"

# starship prompt config
export STARSHIP_CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}/starship/starship.toml"

# rust backtrace by default
export RUST_BACKTRACE=1
