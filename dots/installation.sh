#!/bin/bash

install_tmux() {
    echo "==================================="
    echo "INSTALLING TMUX "
    echo "==================================="
    cd $HOME
    sudo yum install libevent-devel
    sudo yum install ncurses-devel
    git clone https://github.com/tmux/tmux.git
    cd tmux
    sh autogen.sh
    ./configure && make
    sudo cp ./tmux /usr/local/bin

    echo "==================================="
    echo "INSTALLING TPM"
    echo "==================================="
    git clone https://github.com/tmux-plugins/tpm $HOME/.tmux/plugins/tpm
}

install_font() {
    # insatll jetBrainsMono Nerd Font
    cd $HOME && git clone --filter=blob:none --sparse git@github.com:ryanoasis/nerd-fonts
    cd nerd-fonts
    git sparse-checkout add patched-fonts/JetBrainsMono install.sh
    ./install.sh JetBrainsMono
}

install_fzf() {
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    yes | ~/.fzf/install
}

install_cargo() {
    curl https://sh.rustup.rs -sSf | sh
    source "$HOME/.cargo/env"
}

install_nvim() {
    echo "==================================="
    echo "INSTALLING NVIM"
    echo "==================================="
    cd $HOME
    git clone git@github.com:neovim/neovim.git
    cd neovim/
    make CMAKE_BUILD_TYPE=RelWithDebInfo
    sudo make install
}

install_cargo_tools() {
  echo "INSTALLING git-delta"
  cargo install git-delta
  echo "INSTALLING fd-find"
  cargo install fd-find
  echo "INSTALLING Ripgrep"
  cargo install ripgrep
  echo "INSTALLING bat"
  cargo install --locked bat
  echo "INSTALLING starship"
  cargo install starship --locked
  echo "INSTALLING zoxide"
  cargo install zoxide --locked
  echo "INSTALLING bottom"
  cargo install bottom --locked
  echo "INSTALLING exa"
  cargo install exa
}

install_cmake() {
  cd $HOME
  wget https://github.com/Kitware/CMake/releases/download/v3.25.2/cmake-3.25.2-linux-x86_64.sh
  chmod u+x cmake-3.25.2-linux-x86_64.sh
  ./cmake-3.25.2-linux-x86_64.sh
}

install_packages() {
    install_cmake
    #install_cargo
    install_tmux
    #install_nvim
    #install_fzf
    #install_cargo_tools
    # install_font
}

install_packages
