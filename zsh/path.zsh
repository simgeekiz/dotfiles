# ~/.dotfiles/zsh/path.zsh
# Zsh environment variables
# Managed by: ~/.dotfiles/zsh/zshrc or zprofile
# Author: Simge Ekiz
# License: MIT

# Ensure every directory in PATH appears only once.
typeset -U path 

[[ -d "$HOME/.dotfiles/bin" ]] && path=("$HOME/.dotfiles/bin" $path)

export PATH