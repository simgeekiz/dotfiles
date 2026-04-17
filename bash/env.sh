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

lazy_load_nvm() {
  [ -s "$NVM_DIR/nvm.sh" ] || return 1

  unset -f nvm node npm npx lazy_load_nvm
  \. "$NVM_DIR/nvm.sh" || return 1

  if [ -s "$NVM_DIR/bash_completion" ]; then
    \. "$NVM_DIR/bash_completion"
  fi
}

if [ -s "$NVM_DIR/nvm.sh" ]; then
  nvm() {
    lazy_load_nvm && nvm "$@"
  }

  node() {
    lazy_load_nvm && node "$@"
  }

  npm() {
    lazy_load_nvm && npm "$@"
  }

  npx() {
    lazy_load_nvm && npx "$@"
  }
fi

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
if command -v lesspipe >/dev/null 2>&1; then
  eval "$(SHELL=/bin/sh lesspipe)"
fi
