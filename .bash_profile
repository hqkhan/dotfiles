# https://askubuntu.com/questions/121073/why-bash-profile-is-not-getting-sourced-when-opening-a-terminal/121075#121075
source ~/.profile
source ~/.bashrc
system_type=$(uname -s)

if [ "$system_type" = "Darwin" ]; then
  eval "$(/usr/local/bin/brew shellenv)"
else
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi
. "$HOME/.cargo/env"
export PATH="/home/linuxbrew/.linuxbrew/opt/openjdk@17/bin:$PATH"
