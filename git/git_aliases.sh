# ~/.dotfiles/git/git_aliases.sh
# Module defining Git aliases
# Managed by: ~/.dotfiles/git/git_aliases.sh
# Author: Simge Ekiz
# License: MIT

if command -v git >/dev/null 2>&1; then
  alias gs='git status'
  alias gsta="git status"
  alias gbra="git branch"
  alias gco="git checkout"
  alias gncek='git checkout -b'
  alias gaa='git add -A :/'
  alias ga='git add'
  alias gc='git commit'
  alias gca='git commit -a'
  alias gp='git push'
  alias gl='git pull'
  alias gd='git diff'
  alias gcl='git clone'
  alias gclo='git clone'
  alias gfet='git fetch'
  alias gundo='git reset --soft HEAD~1'
  alias gunstage='git reset'
  alias gundonunstage='git reset HEAD~1'
  alias gundonunstagendiscard='git reset --hard HEAD~1'
  alias gunstagefp='git restore --staged'
  alias gunstagendiscardfp='git restore'
  # git last commit id git log -1 --format=%H
  alias glci='git log -1 --format=%H'
  alias gitlastcommitid='git log -1 --format=%H'
  alias gitaddtaglast='f() { git tag -a "$1" $(git rev-parse HEAD) -m "trigger ci/cd for $1"; }; f'
  alias gitaddtag='f() { git tag -a "$1" $(git rev-parse HEAD) -m "trigger ci/cd for $1"; }; f'
  alias gaddtaglast='f() { git tag -a "$1" $(git rev-parse HEAD) -m "trigger ci/cd for $1"; }; f'
  alias gaddtag='f() { git tag -a "$1" $(git rev-parse HEAD) -m "trigger ci/cd for $1"; }; f'
  alias gitaddtagremote='git push origin $1'
  alias gdeltag='git tag -d $1'
  alias gitdeltag='git tag -d $1'
  alias gitdeltagremote='git push --delete origin $1'
  alias gittagls='git tag -n'
  alias gitaddremote='git remote add origin $1'
  # alias gaddremote='git remote add origin $1'
  alias gaddremote='f() { git remote add "$1" "$2" }; f'

fi