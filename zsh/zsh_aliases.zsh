# ~/.dotfiles/zsh/zsh_aliases.zsh
# Zsh module defining command aliases and tools
# Managed by: ~/.dotfiles/zsh/zsh_aliases.zsh
# Author: Simge Ekiz
# License: MIT

# Python
alias python='python3.10'
alias python=python3

alias pip='pip3'

# Environment Control
alias activate='source .env/bin/activate'
alias deac='deactivate'

# Interesting Mix
alias hist='fc -l 1 | grep '
alias histg='fc -l 1 | grep -i '

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
  killscr () {
    screen -X -S $1 quit
  }
fi

# Jekkyl
alias js='jekyll serve'
alias bejs='bundle exec jekyll serve'

# Django
alias pmr='python manage.py runserver'

# Jupyter
alias jnote='jupyter notebook'
alias jnotescr='screen -S jnote bash -c "source .env/bin/activate; jupyter notebook"'
alias jlab='jupyter lab'
alias jlabscr='screen -S jlab bash -c "source .env/bin/activate; jupyter lab"'

# File System shortcuts
alias md='mkdir -p'
alias rd=rmdir

# Navigations
alias -g ...='../..'
alias cd..='cd ..'
alias ..='cd ..'
alias ...='cd ../..'
alias .3='cd ../../..'
alias .4='cd ../../../..'
alias .5='cd ../../../../..'

alias cddot='cd $HOME/.dotfiles'
alias cdwork='cd $HOME/workspaces/'

if diff --color=auto /dev/null /dev/null &>/dev/null; then
  alias diff='diff --color=auto'
fi

# ls and easy report
case "$(uname -s)" in
  Darwin*) alias ls='ls -G' ;;
  Linux*)  alias ls='ls --color=auto' ;;
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

alias restartterminal='exec $SHELL'
alias reload='exec $SHELL'

# Add an "alert" alias for long running commands.  Use like so: sleep 10; alert
if (( $+commands[notify-send] )); then
  alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
fi

# Homebrew
alias brewu='brew update && brew upgrade && brew cleanup && brew doctor'
