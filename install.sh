#!/bin/bash

set -xe

function install_system_modules() {
  sudo apt update && sudo apt install -y \
    gimp \
    python3-pip \
    python3-venv \
    silversearcher-ag \
    terminator

  sudo snap install \
    discord \
    keepassxc \
    libreoffice \
    firefox \
    spotify
}

function install_vimrc() {
  #Install required apt packages
  sudo apt install -y \
    silversearcher-ag # Required by mileszs/ack.vim plugin 

  ln -sf $(pwd)/.vimrc ~/.vimrc
  ln -sf $(pwd)/.inputrc ~/.inputrc

  _autoload_dir=~/.vim/autoload
  if [ ! -d $_autoload_dir ]; then
    echo "Creating $_autoload_dir directory..."
    mkdir -p $_autoload_dir
  fi
  cp -f $(pwd)/lib.vim ~/.vim/autoload/lib.vim

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
  sudo apt update
  sudo apt install -y libncurses5-dev libgtk2.0-dev libatk1.0-dev \
    libcairo2-dev libx11-dev libxpm-dev libxt-dev \
    python3-dev ruby-dev lua5.2 liblua5.2-dev libperl-dev git

  sudo apt remove -y vim vim-runtime gvim

  _vim_dir=~/vim
  _vim_repo_url=https://github.com/vim/vim.git
  _vim_version_tag=v9.1.1324

  if [ -d $_vim_dir ]; then
    echo "Directory $_vim_dir already exists. Removing..."
    rm -rf $_vim_dir
  fi
  git clone --branch $_vim_version_tag $_vim_repo_url $_vim_dir

  pushd $_vim_dir
    _vim_install_dir=~/.local
    ./configure --with-features=huge \
                --enable-python3interp=yes \
                --with-python3-config-dir=$(python3-config --configdir) \
                --enable-gui=gtk2 \
                --enable-cscope \
                --prefix=$_vim_install_dir
    make VIMRUNTIMEDIR=$_vim_install_dir/share/vim/vim91
    make install
  popd

  sudo ln -sf $_vim_install_dir/bin/vim /usr/local/bin/vim

  vim --version | head -n 3

  #Add temporary vim swap files to gitignore

}

function install_ycm() { 
  sudo apt install -y build-essential cmake vim-nox python3-dev
  pushd ~/.vim/bundle/YouCompleteMe 
  python3 install.py --clangd-completer
  popd
}

function set_defaults() {
  git config --global core.editor "vim"
}

function install_bash_aliases() {
  _target_rc_file=${1:-~/.bashrc}
  _aliases_path=$(pwd)/.bash_aliases
  cp $_target_rc_file "${_target_rc_file}_backup"

  if grep "$_aliases_path" $_target_rc_file; then
    echo "Path $_aliases_path already present in ${_target_rc_file}"
  else
  echo "
if [ -f $_aliases_path ]; then
  . $_aliases_path
fi
" >> $_target_rc_file
  fi

source $_target_rc_file
}

function install_ohmyzsh() {
  sudo apt install -y zsh

  _ohmyzsh_folder=$HOME/.oh-my-zsh
  if [ ! -d $_ohmyzsh_folder ]; then
    echo "Installing OhMyZsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  else
    echo "Folder $_ohmyzsh_folder already exists. Skipping installation of OhMyZsh.."
  fi

  zshrc_path=$(pwd)/.zshrc
  cp ~/.zshrc ~/.zshrc_backup
  cp $zshrc_path ~/.zshrc

  # Change default theme
  sed -i '/ZSH_THEME="/c\ZSH_THEME="steeef"' ~/.zshrc

  #Add bash_aliases to ~/.zshrc
  install_bash_aliases ~/.zshrc
}

function create_gitignore() {
  _global_gitignore_file=~/.gitignore
  echo "
*.swp
*.swo
" > $_global_gitignore_file
  git config --global core.excludesfile $_global_gitignore_file
}

MODE=${1:-}
if [ -z $1 ]; then
  echo "Missing required 1st argument: <INSTALLATION_MODE>"
  exit 1
fi

case $MODE in
  ubuntu)
    install_system_modules
    install_bash_aliases
    rebuild_vim_from_sources
    set_defaults
    install_vimrc
    create_gitignore
    ;;
  modules)
    install_system_modules
    ;;
  vim)
    rebuild_vim_from_sources
    set_defaults
    ;;
  vimrc)
    install_vimrc
    ;;
  bash)
    install_bash_aliases
    ;;
  gitignore)
    create_gitignore
    ;;
  ohmyzsh)
    install_ohmyzsh
    ;;
esac


