# ~/.dotfiles/zsh/env.zsh
# Zsh environment variables
# Managed by: ~/.dotfiles/zsh/zshrc
# Author: Simge Ekiz
# License: MIT

# Ensure every directory in PATH appears only once.
typeset -U path 

if [ -d "$HOME/.dotfiles/bin" ]; then
  # Add my dotfiles bin directory to the front of PATH.
  path=("$HOME/.dotfiles/bin" $path)
fi


export EDITOR="nano"
export PAGER="less"
export VIRTUAL_ENV_DISABLE_PROMPT=1
