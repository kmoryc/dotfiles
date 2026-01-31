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

function install_devops_tools() {
  install_terraform
  install_kubernetes
  install_helm
}

function install_network_tools() {
  sudo apt update && sudo apt install -y \
    net-tools
}

function install_terraform() {
  sudo apt-get update && sudo apt-get install -y \
    gnupg \
    software-properties-common

  # Install GPG key
  wget -O- https://apt.releases.hashicorp.com/gpg | \
    gpg --dearmor | \
    sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null

  # Verify GPG key
  gpg --no-default-keyring \
    --keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg \
    --fingerprint

  # Add Hashicorp repository
  echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
    https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
  sudo tee /etc/apt/sources.list.d/hashicorp.list

  #Install terraform
  sudo apt update && sudo apt-get install -y \
    terraform

  # Install autocomplete for commands
  _aliases_path=~/.bashrc
  if [ -f $_aliases_path ]; then
    echo $_aliases_path
    terraform -install-autocomplete || true
  fi
}

function install_kubernetes() {
  K8S_VERSION=$(curl -L -s https://dl.k8s.io/release/stable.txt)
  
  # Download binary
  curl -LO "https://dl.k8s.io/release/$K8S_VERSION/bin/linux/amd64/kubectl"
  
  # Checksum validation
  curl -LO "https://dl.k8s.io/release/$K8S_VERSION/bin/linux/amd64/kubectl.sha256"
  echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check

  # Install Kubernetes
  sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

  # Verify installation
  kubectl version --client --output=yaml
}

function install_helm() {
  HELM_VERSION=$(curl -L -s https://dl.k8s.io/release/stable.txt)
  
  # Install dependencies
  sudo apt-get install -y apt-transport-https

  curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg > /dev/null
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list

  sudo apt-get update && sudo apt-get install -y helm

  # Verify installation
  echo "Helm installed: $(helm version --short)"  
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

  # Add preexec hook to display timestamp before each command
  if grep -q "^preexec()" ~/.zshrc; then
    echo "preexec hook already present in ~/.zshrc"
  else
    echo '
# Function to execute before running a command
preexec() {
    # Print full date and time (Year-Month-Day Hour:Minute:Second)
    echo -e "\e[1;32m[$(date "+%Y-%m-%d %H:%M:%S")]\e[0m"
}
' >> ~/.zshrc
  fi
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
  devops)
    install_devops_tools
    ;;
  network)
    install_network_tools
    ;;
  ohmyzsh)
    install_ohmyzsh
    ;;
esac


