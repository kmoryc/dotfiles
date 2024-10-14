#!/bin/bash

set -xe

function install_python_ubuntu() {
  sudo apt install python3-pip python3-venv ctags
}

function install_vim() {
  sudo apt install -y vim silversearcher-ag

  ln -sf $(pwd)/.vimrc ~/.vimrc
  ln -sf $(pwd)/.inputrc ~/.inputrc

  _vundle_dir=~/.vim/bundle/Vundle.vim
  _vundle_url=https://github.com/VundleVim/Vundle.vim.git
  if ! git clone $_vundle_url $_vundle_dir 2>&1 && [ -d $_vundle_dir ]; then
    echo "Directory $_vundle_dir already exists. Skipping installation of: VundleVim"
  fi
 
  _onedark_dir=~/.vim/bundle/onedark.vim
  _onedark_url=https://github.com/joshdick/onedark.vim.git
  if ! git clone $_onedark_url $_onedark_dir 2>&1 && [ -d $_onedark_dir ]; then
    echo "Directory $_onedark_dir already exists. Skipping installation of: onedark.vim"
  else
    mkdir -p ~/.vim/colors
    cp $_onedark_dir/colors/onedark.vim ~/.vim/colors/onedark.vim  
    mkdir -p ~/.vim/autoload
    cp $_onedark_dir/autoload/onedark.vim ~/.vim/autoload/onedark.vim 
  fi

  vim +PluginInstall +qall
}

JOB=${1:-ubuntu}

case $JOB in
  ubuntu)
    install_vim
    ;;
esac


