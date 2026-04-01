# ~/.bash_aliases
# Bash command aliases
# Managed via: ~/.dotfiles/bash/bashrc
# Author: Simge Ekiz
# License: MIT

has() {
  command -v "$1" >/dev/null 2>&1
}

# Python
alias python='python3'
alias pip='pip3'

# Interesting Mix
alias please='sudo'

# VSCODE
has code && alias editdotfiles="code \"$HOME/.dotfiles\""

# nvidia-prime Control
has prime-select && alias nvidia='sudo prime-select nvidia'

# Screen Control
if has screen; then
  alias scr='screen'
  alias scrs='screen -S'
  alias scrr='screen -r'
  alias scrl='screen -ls'
  alias scrls='screen -ls'
  killscr() {
    [ -n "$1" ] && screen -X -S "$1" quit
  }
fi

# Jekkyl
if has jekyll; then
  alias js='jekyll serve'

  if has bundle; then
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
alias cd..='cd ..'
alias ..='cd ..'
alias ...='cd ../..'
alias .3='cd ../../..'
alias .4='cd ../../../..'
alias .5='cd ../../../../..'

if diff --color=auto /dev/null /dev/null &>/dev/null; then
  alias diff='diff --color=auto'
fi

# ls and ls color
case "$(uname -s)" in
  Darwin*) alias ls='ls -G' ;;
  Linux*)  
  
      # Optional: only if dircolors exists
    if command -v dircolors >/dev/null 2>&1; then
      eval "$(dircolors -b ~/.dircolors 2>/dev/null || dircolors -b)"
    fi

    alias ls='ls --color=auto'
   # alias dir='dir --color=auto'
  # alias vdir='vdir --color=auto'
    alias grep='grep --color=auto'
    ;;
esac

alias ll='ls -l'
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
  Linux*) 
  alias du='du -h -d 2';;
esac

# Kill jobs
alias ka9='killall -9'
alias k9='kill -9'

alias restartterminal='exec "$SHELL"'
alias reload='exec "$SHELL"'
