# !/bin/zsh
# Sets up the a new computer:
# - creates symbolic links for the dotfiles;
# - software installations and updates the system;
#
# Author: Simge Ekiz
# License: MIT
# https://github.com/simgeekiz/dotfiles

# Exit on any failed command
set -e

# === Import functions ===
[[ -f "$HOME/.dotfiles/functions/core.zsh" ]] && source "$HOME/.dotfiles/functions/core.zsh"

# Check if Zsh is installed If not, exit
if [ -n "$ZSH_VERSION" ]; then
  print_log "You are running Zsh (version: $ZSH_VERSION)"
else
  print_log "🥀 You are still running an unknown shell: $SHELL \n 
  🛑 Please install Zsh and run this script again."
  exit 1
fi

# software installations
prompt_user "🛠️  Do you want to do installation?" 'source $HOME/.dotfiles/setup/install.zsh' ""

# === Symlink dotfiles ===
[[ -f "$HOME/.dotfiles/setup/symlink.zsh" ]] && source "$HOME/.dotfiles/setup/symlink.zsh"

echo "🦆 Restarting Terminal"  
exec $SHELL