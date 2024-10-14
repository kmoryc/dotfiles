#!/bin/bash

set -e

function install_python_ubuntu() {
  sudo apt install python3-pip python3-venv ctags
}

function install_vim() {
  sudo apt install -y vim silversearcher-ag

  ln -sf $(pwd)/.vimrc ~/.vimrc
  ln -sf $(pwd)/.inputrc ~/.inputrc

  _vundle_dir=~/.vim/bundle/Vundle.vim
  _vundle_url=https://github.com/VundleVim/Vundle.vim.git
  if ! git clone $_vundle_url $_vundle_dir 2>/dev/null && [ -d $_vundle_dir ]; then
    echo "Directory $_vundle_dir already exists. Skipping installation of: VundleVim"
  fi
  
  vim +slient +VimEnter +PluginInstall +qall
}

JOB=${1:-ubuntu}

case $JOB in
  ubuntu)
    install_vim
    ;;
esac


