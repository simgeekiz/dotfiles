#!/bin/bash

# Python
alias python3='python3.8'
alias python=python3

# Environment Control
alias venv='python3 -m venv .env'
alias src='. .env/bin/activate'
alias srch='. env/bin/activate'
alias deac='deactivate'

# Git aliases
alias gadd='git add'
alias gaa='git add -A :/'
alias gcom='git commit'
alias gcam='git commit -am'
alias gcek='git checkout'
alias gsta='git status'
alias gbra='git branch'
alias gpus='git push'
alias gpush='git push'
alias gpul='git pull'
alias gpull='git pull'
alias gclo='git clone'
alias gclone='git clone'
alias gfet='git fetch'
alias gfetch='git fetch'

# nvidia-prime Control
alias nvidia='sudo prime-select nvidia'

# Screen Control
alias scr='screen'
alias scrs='screen -S'
alias scrr='screen -r'
alias scrl='screen -ls'
alias scrls='screen -ls'
killscr () {
  screen -X -S $1 quit
}

# Folder Navigation;
alias ..='cd ..'
alias cd..='cd ..'
alias cddot='cd $HOME/.dotfiles'
alias cdwork='cd $HOME/Dropbox/workspaces/'
alias cdflo='cd $HOME/Dropbox/workspaces/FloodTags/'
alias cddash='cd $HOME/Dropbox/workspaces/FloodTags/Data_Distribution/dashboard/'
alias cdeifd='cd $HOME/Dropbox/workspaces/FloodTags/Enrichments/information-extraction/'

# Django
alias pmr='python manage.py runserver'

# Jupyter Notebook
alias jnote='jupyter notebook'
alias jnotescr='screen -S jnote bash -c "source .env/bin/activate; jupyter notebook"'
alias jnotescreen='screen -S jnote bash -c "source .env/bin/activate; jupyter notebook"'

# ls and ls color
alias ll='ls -l'
alias la='ls -A'
alias lla='ls -lah'
if [ -x /usr/bin/dircolors ]; then
    test -r $HOME/.dircolors && eval "$(dircolors -b $HOME/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# Start Radboud Science VPN in a screen;
alias ruvpn='screen -S ruvpn bash -c "sudo openvpn $HOME/.dotfiles/vpn/openvpn-science-ru-nl.ovpn"'
alias ftvpn='screen -S ftvpn bash -c "sudo openvpn $HOME/.dotfiles/vpn/openvpn-floodtags-basar.ovpn"'
alias flovpn=ftvpn

# Add an "alert" alias for long running commands.  Use like so: sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
