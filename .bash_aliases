WORKSPACES=$HOME/workspaces
GERRIT_DIR=$WORKSPACES/Gerrit
GITHUB_DIR=$WORKSPACES/Github
SETUP_DIR=$HOME/setup

GIT_DEFAULT_BRANCH=${GIT_DEFAULT_BRANCH:-main}

# Clear
alias clr="clear && cd $HOME"

# Main paths
alias cds="cd $SETUP_DIR"
alias cdg="cd $GERRIT_DIR"
alias cdgt="cd $GITHUB_DIR"

# Git
alias gitrm="git stash && git fetch --all && git checkout $GIT_DEFAULT_BRANCH && git reset --hard origin/$GIT_DEFAULT_BRANCH"
alias gits="git status"
alias gitd="git --no-pager diff"
alias gitl="git --no-pager log --oneline -10"
alias gitle="git --no-pager log --oneline --pretty=format:\"%C(Yellow)%h%C(reset)%x20|%x20%ad%x20|%x20%ae%x20|%x20%s\" --date=short -10"
alias gitlee="git --no-pager log --oneline --pretty=format:\"%C(Yellow)%h%C(reset)%x20|%x20%ad%x20|%x20%ae%x20|%x20%s\" --date=format:'%Y-%m-%d %H:%M:%S' -10"
alias gitau="git add -u"
alias gitc="gitau && git commit"
alias gitam="gitau && git commit --amend"
alias gitr="git push origin HEAD:refs/for/$GIT_DEFAULT_BRANCH"
alias gitamp="gitau && git commit --amend --no-edit && gitr"
alias gitp="git push origin $GIT_DEFAULT_BRANCH"
alias gitpp="gitau && git commit --amend --no-edit && gitp"
alias giturl="git remote -v"
