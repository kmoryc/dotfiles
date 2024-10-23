#!/bin/bash

set -xe

function install_python_ubuntu() {
  sudo apt install python3-pip python3-venv ctags
}

function install_vimrc() {
  ln -sf $(pwd)/.vimrc ~/.vimrc
  ln -sf $(pwd)/.inputrc ~/.inputrc

  _vundle_dir=~/.vim/bundle/Vundle.vim
  _vundle_url=https://github.com/VundleVim/Vundle.vim.git
  if [ -d $_vundle_dir ]; then
    echo "Directory $_vundle_dir already exists. Removing..."
    rm -rf $_vundle_dir
  fi
  git clone $_vundle_url $_vundle_dir

  _onedark_dir=~/.vim/bundle/onedark.vim
  _onedark_url=https://github.com/joshdick/onedark.vim.git 
  if [ -d $_onedark_dir ]; then
    echo "Directory $_onedark_dir already exists. Removing..."
    rm -rf $_onedark_dir
  fi
  git clone $_onedark_url $_onedark_dir 
  mkdir -p ~/.vim/colors
  cp $_onedark_dir/colors/onedark.vim ~/.vim/colors/onedark.vim  
  mkdir -p ~/.vim/autoload
  cp $_onedark_dir/autoload/onedark.vim ~/.vim/autoload/onedark.vim

  vim +silent +VimEnter +PluginInstall +qall

  install_ycm
}

function rebuild_vim_from_sources() {
  sudo apt install -y libncurses5-dev libgtk2.0-dev libatk1.0-dev \
    libcairo2-dev libx11-dev libxpm-dev libxt-dev python2-dev \
    python3-dev ruby-dev lua5.2 liblua5.2-dev libperl-dev git

  sudo apt remove -y vim vim-runtime gvim

  _vim_dir=~/vim
  _vim_url=https://github.com/vim/vim.git 
  if [ -d $_vim_dir ]; then
    echo "Directory $_vim_dir already exists. Removing..."
    rm -rf $_vim_dir
  fi
  git clone $_vim_url $_vim_dir
  pushd $_vim_dir
  ./configure --with-features=huge \
            --enable-python3interp=yes \
            --with-python3-config-dir=$(python3-config --configdir) \
            --enable-gui=gtk2 \
            --enable-cscope \
            --prefix=/usr/local
  make VIMRUNTIMEDIR=/usr/local/share/vim/vim91

  sudo make install

  sudo update-alternatives --install /usr/bin/editor editor /usr/local/bin/vim 1
  sudo update-alternatives --set editor /usr/local/bin/vim
  sudo update-alternatives --install /usr/bin/vi vi /usr/local/bin/vim 1
  sudo update-alternatives --set vi /usr/local/bin/vim  
  
  vim --version | head -n 3

  popd
}

function install_ycm() { 
  sudo apt install -y build-essential cmake vim-nox python3-dev
  pushd ~/.vim/bundle/YouCompleteMe 
  python3 install.py --clangd-completer
  popd
}

function install_bash_aliases() {
  aliases_path=$(pwd)/bash_aliases
  cp ~/.bashrc ~/.bashrc_backup

  if grep "$aliases_path" ~/.bashrc; then
    echo "Path $aliases_path already present in ~/.bashrc"
    exit 0
  fi

  echo "
if [ -f $aliases_path ]; then
  . $aliases_path
fi
" >> ~/.bashrc  
}

JOB=${1:-}
if [ -z $1 ]; then
  echo "Missing required 1st argument: OS"
  exit 1
fi

case $JOB in
  ubuntu)
    install_bash_aliases
    rebuild_vim_from_sources
    install_vimrc
    install_ycm
    ;;
  vimrc)
    install_vimrc
    install_ycm
    ;;
  bash)
    install_bash_aliases
    ;;
esac


