# ~/.dotfiles/tmux/tmux_aliases.sh
# Module defining Tmux aliases
# Managed by: ~/.dotfiles/tmux/tmux_aliases.sh
# Author: Simge Ekiz
# License: MIT

if command -v tmux >/dev/null 2>&1; then
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
fi
