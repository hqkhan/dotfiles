# Config for neovim + basic terminal stuff
[Git bare repo](https://www.ackama.com/what-we-think/the-best-way-to-store-your-dotfiles-a-bare-git-repository-explained/) repo holding dotfiles.

Steps to get setup on new machine:
```
# Avoid any funky recursion
echo ".cfg" >> .gitignore

# clones bare this repository into "$HOME"
git clone --bare git@github.com:hqkhan/dotfiles.git $HOME/.cfg

# Create temporary alias
alias dot='git -c status.showUntrackedFiles=no --git-dir=$HOME/.cfg/ --work-tree=$HOME -C ${HOME}'

# Ignore all untracked files
dot config --local status.showUntrackedFiles no

# Resetting to HEAD
dot reset --hard HEAD

# Create symlink for fugitive to work with bare repo
ln -sf $HOME/.cfg $HOME/.git

# Run bootstrap script to get all goodies
./dots/bootstrap
```

# Config

![screenshot](./screenshot.png)

# Software

- Terminal: [Alacritty](https://alacritty.org)
- Font: [JetBrains Nerd Font](https://github.com/JetBrains/JetBrainsMono)
- Colors: [embark](https://github.com/embark-theme/vim)
- Shell: bash
- Multiplexer: [tmux](https://github.com/tmux/tmux/wiki)
- Editor: [Neovim](https://neovim.io)
- Git: [lazygit](https://github.com/jesseduffield/lazygit)
- Package Manager: [Homebrew](https://brew.sh)
- Hotkeys: [skhd](https://github.com/koekeishiya/skhd/)
- WM: [yabai](https://github.com/koekeishiya/yabai)
- Resource Monitor: [Stats](https://github.com/exelban/stats)

## Browser setup (Firefox)

- [uBlock Origin](https://addons.mozilla.org/en-US/firefox/addon/ublock-origin/)
- [Tree Style Tab](https://addons.mozilla.org/en-US/firefox/addon/tree-style-tab/) + [AutoTabDiscard](https://webextension.org/listing/tab-discard.html)
- [Darkreader](https://darkreader.org/)
- [TamperMonkey](https://www.tampermonkey.net/)
- [Vimium](https://github.com/philc/vimium) | [Config](https://gist.github.com/hqkhan/1c7b935a0a98f0feb95b6a2969d2f390)


## Useful References
- [Managing dotfiles with bare git
  repo](https://www.ackama.com/what-we-think/the-best-way-to-store-your-dotfiles-a-bare-git-repository-explained/)
