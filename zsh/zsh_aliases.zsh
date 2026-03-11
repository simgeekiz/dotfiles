# Python
alias python='python3.10'
alias python=python3

alias pip='pip3'

# Environment Control
alias activate='source .env/bin/activate'
alias deac='deactivate'

# Interesting Mix
alias hist='history | grep'
alias historytime='fc -il 1'
alias histg='history | grep -i'
alias please='sudo'

# Git aliases
alias gaa='git add -A :/'
alias gsta='git status'
alias gbra='git branch'

# VSCODE
alias editdotfiles='code $HOME/.dotfiles'

# nvidia-prime Control
alias nvidia='sudo prime-select nvidia'

# Screen control
alias scr='screen'
alias scrs='screen -S'
alias scrr='screen -r'
alias scrls='screen -ls'
alias scrl=scrls
killscr () {
  screen -X -S $1 quit
}

# Tmux Control
# start a new tmux session
alias tmuxnew='tmux new'
alias tn='tmux new'
alias tnt='tmux new -t'
alias tns='tmux new -s'
# attach to an existing tmux session
alias ta='tmux a'
alias tat='tmux a -t'
alias tattach='tmux attach'
# detach from a tmux session
alias td='tmux detach'
alias tdetach='tmux detach'
# list all tmux sessions
alias tls='tmux ls'
# kill a tmux session
alias tkt='tmux kill-ses -t'
alias tkill='tmux kill-session -t'
# (ctrl+b) + :kill-session

# Jekkyl
alias js='jekyll serve'
alias bejs='bundle exec jekyll serve'

# Django
alias pmr='python manage.py runserver'

# Jupyter
alias jnote='jupyter notebook'
alias jnotescr='screen -S jnote bash -c "source .env/bin/activate; jupyter notebook"'
alias jnotescreen='screen -S jnote bash -c "source .env/bin/activate; jupyter notebook"'
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
alias ~='cd ~'
alias cddot='cd $HOME/.dotfiles'
alias cdwork='cd $HOME/workspaces/'

alias realrm="/bin/rm"
alias realls="/bin/ls"
alias realgrep="/bin/grep"

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
alias du='du -h -d 2'

# Kill jobs
alias ka9='killall -9'
alias k9='kill -9'

alias restartterminal='exec $SHELL'
alias reload='exec $SHELL'

# Add an "alert" alias for long running commands.  Use like so: sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Homebrew
alias brewu='brew update && brew upgrade && brew cleanup && brew doctor'
