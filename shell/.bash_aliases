#!/bin/bash

# Python
alias python3='python3.10'
alias python=python3

alias pip='pip3'

# Environment Control
alias venv='python3 -m venv .env'
alias src='. .env/bin/activate'
alias srch='. env/bin/activate'
alias deac='deactivate'

# Interesting Mix
alias hist='history | grep'
alias please='sudo'

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

alias gundo='git reset --soft HEAD~1'
alias gunstage='git reset'
alias gundonunstage='git reset HEAD~1'
# //Add text git undo git unstage and discard changes
alias gundonunstagendiscard='git reset --hard HEAD~1'
alias gunstagefp='git restore --staged'
alias gunstagendiscardfp='git restore'
alias gncek='git checkout -b'

# headphone work
alias turnonheadphones='curl https://gitlab.freedesktop.org/pulseaudio/pulseaudio/raw/master/src/utils/pa-info?inline=false | bash | nc termbin.com 9999'

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

# Tmux Control
alias tmuxnew='tmux new'
alias tn='tmux new -t'
alias ta='tmux a -t'
alias tl='tmux ls'
alias tls='tmux ls'
alias tk='tmux kill-ses -t'
# (ctrl+b) + :kill-session

# Folder Navigation;
alias ..='cd ..'
alias cd..='cd ..'
alias cddot='cd $HOME/.dotfiles'
alias cdwork='cd $HOME/workspaces/'
alias cddash='cd $HOME/workspaces/FloodTags/Data_Distribution/dashboard/'

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

alias restartterminal='source ~/.bashrc'

# Add an "alert" alias for long running commands.  Use like so: sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
