# ~/.dotfiles/zsh/zsh_aliases.zsh
# Zsh module defining command aliases and tools
# Managed by: ~/.dotfiles/zsh/zsh_aliases.zsh
# Author: Simge Ekiz
# License: MIT

# Python
alias python='python3'
alias pip='pip3'

# Interesting Mix
alias please='sudo'

# VSCODE
(( $+commands[code] )) && alias editdotfiles='code $HOME/.dotfiles'

# nvidia-prime Control
if (( $+commands[prime-select] )); then
  alias nvidia='sudo prime-select nvidia'
fi

# Screen control
if (( $+commands[screen] )); then
  alias scr='screen'
  alias scrs='screen -S'
  alias scrr='screen -r'
  alias scrls='screen -ls'
  alias scrl=scrls
  killscr() {
    [ -n "$1" ] && screen -X -S "$1" quit
  }
fi

# Jekkyl
if (( $+commands[jekyll] )); then
  alias js='jekyll serve'

  if (( $+commands[bundle] )); then
    alias bejs='bundle exec jekyll serve'
  fi
fi

# Django
alias pmr='python manage.py runserver'

# Jupyter
alias jnote='jupyter notebook'
alias jlab='jupyter lab'

# File System shortcuts
alias md='mkdir -p'
alias rd=rmdir

# Folder Navigation;
alias ..='cd ..'
alias cd..='cd ..'
alias cddot='cd $HOME/.dotfiles'
alias cdwork='cd $HOME/workspaces/'

# Navigations
alias -g ...='../..'
alias cd..='cd ..'
alias ..='cd ..'
alias ...='cd ../..'
alias .3='cd ../../..'
alias .4='cd ../../../..'
alias .5='cd ../../../../..'

if diff --color=auto /dev/null /dev/null &>/dev/null; then
  alias diff='diff --color=auto'
fi

# ls and easy report
case "$(uname -s)" in
  Darwin*) alias ls='ls -G' ;;
  Linux*)  alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
    ;;
esac
alias ll='ls -al'
alias la='ls -A'
alias lla='ls -lah'
alias cls='clear;ls'
alias lsa='ls -lah'
# show me files matching "ls grep"
alias lsg='ll | grep'
alias lll='ls -alF'
alias l='ls -CF'

alias fdir='find . -type d -name'
alias ff='find . -type f -name'

# df(short for disk free) is used to show the amount of free disk space available
# Show human friendly numbers and colors
alias df='df -h'

case "$(uname -s)" in
  Darwin*) alias du='du -h -L 2' ;;  # BSD alternative
  Linux*)  alias du='du -h -d 2' ;;
esac

# Kill jobs
alias ka9='killall -9'
alias k9='kill -9'

alias restartterminal='exec "$SHELL"'
alias reload='exec "$SHELL"'