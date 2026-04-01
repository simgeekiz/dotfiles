# ~/.dotfiles/bash/env.sh
# Environment variables and path config
# Managed by: ~/.dotfiles/bash/bashrc
# Author: Simge Ekiz
# License: MIT

# === PATH config === # 
if [ -d "$HOME/.dotfiles/bin" ]; then
  case ":$PATH:" in
    *":$HOME/.dotfiles/bin:"*) ;; # already in PATH
    *) PATH="$HOME/.dotfiles/bin:$PATH" ;;
  esac
fi

# # Install Ruby Gems to ~/gems
# export GEM_HOME="$HOME/gems"
# export PATH="$HOME/gems/bin:$PATH"

# === Tools === # 
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# === Environment === # 
# To run cuDNN
export LD_LIBRARY_PATH="${LD_LIBRARY_PATH:+$LD_LIBRARY_PATH:}/usr/local/cuda/lib64"

## Editor and pager
export EDITOR="nano"
export PAGER="less"

# Python virtualenv
export VIRTUAL_ENV_DISABLE_PROMPT=1

# GCC colors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# less smarter file handling
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"