#!/usr/bin/env sh
# ~/.dotfiles/bootstrap/setup.sh
# Main entry point for the dotfiles bootstrap process.
# Sets up the a new computer:
# - Runs prerequisite checks
# - creates symbolic links for the dotfiles;
# - software installations and updates the system;
#
# Author: Simge Ekiz
# License: MIT
# https://github.com/simgeekiz/dotfiles

main() {
  # === Import functions ===
  if [ -r "$HOME/.dotfiles/bootstrap/helpers.sh" ]; then
    . "$HOME/.dotfiles/bootstrap/helpers.sh"
  else
    printf '%s\n' "⚠️  helpers.sh not found or unreadable"
    return 1
  fi

  # === Software installations ===
  printf '\n➡️  %s\n' "🛠️  Starting software installation..."
  if [ -r "$HOME/.dotfiles/bootstrap/install.sh" ]; then
    if type prompt_user >/dev/null 2>&1; then
      prompt_user "🛠️  Do you want to do installation?" ". \"$HOME/.dotfiles/bootstrap/install.sh\"" ""
    else
      printf '%s\n' "⚠️  prompt_user function not found"
    fi
  else
    printf '%s\n' "⚠️  install.sh not found or unreadable."
  fi

  # === Symlink dotfiles ===
  printf '\n➡️  %s\n' "🐿️  Creating symlinks..."
  if [ -r "$HOME/.dotfiles/bootstrap/symlink.sh" ]; then
    . "$HOME/.dotfiles/bootstrap/symlink.sh"
  else
    printf '%s\n' "⚠️  symlink.sh not found or unreadable."
  fi

  printf '\n ➡️ %s\n' "✅  All steps completed!"

  # === Restarting terminal ===
  if command -v "${SHELL:-/bin/sh}" >/dev/null 2>&1; then
    printf '%s\n' "🦆 Restarting Terminal"  
    exec "${SHELL:-/bin/sh}" -l || printf '%s\n' "Could not restart shell. Please restart manually."
  fi
}

main "$@"