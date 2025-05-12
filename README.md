# Dotfiles repository
Config files useful when setting up / restoring personal development environment

**To run full setup installation for ubuntu**
```
./install.sh ubuntu
```

**To run full installation for particular tools**
* Install system modules (apt, snap)
```
./install.sh modules
```
* Install vim (rebuild from sources) and set it as default editor
```
./install.sh vim
```
* Configure vimrc
```
./install.sh vimrc
```
* Install bash aliases (will cause ~/.bashrc to use `.bash_aliases` directly from this repo)
```
./install.sh bash
```
* Create global `.gitignore` files
```
./install.sh gitignore
```
* Install DevOps tools
```
./install.sh devops
```
* Install networking tools
```
./install.sh network
```
* Install ohmyzsh and set it as default shell
```
./install.sh ohmyzsh
```

