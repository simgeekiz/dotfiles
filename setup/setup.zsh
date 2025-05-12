# Sets up the a new computer:
# - installs all the software;
# - creates symbolic links for the dotfiles;
# - installs Powerlevel10k;# - 
# - installs Jekyll;
# - installs Re-volt;
#
# Author: Simge Ekiz
# License: MIT
# https://github.com/simgeekiz/dotfiles

create_symbolic_link() {
  local source_file="$1"
  local destination_file="$2"
  ln -sfn "$source_file" "$destination_file"
  echo "Symbolic link created: $source_file -> $destination_file"
}

is_file_exists() {
  local source_file="$1"

  # note -e → Checks if the file or directory exists, regardless of type.
  # -f → Checks if the path exists and is a regular file (not a directory, symlink to a directory, etc.).
  # -n -n is used in Bash to test whether a string is non-empty. Which is always true, because the string /home/youruser/.bashrc is non-empty.
  #    It does not check if the file exists — only that the string path is not empty.
  if [[ -e "$source_file" ]]; then
    return 0  # success
  else
    return 1  # failure
  fi
}

printlog () {
    echo
    echo "---------------------------------------------------------------------------" >&2
    echo "$1"
    echo "---------------------------------------------------------------------------" >&2
}

# Exit on any failed command
set -e

# Check if Zsh is installed If not, exit
if [ -n "$ZSH_VERSION" ]; then
  printlog "You are running Zsh (version: $ZSH_VERSION)"
else
  printlog "🥀 You are still running an unknown shell: $SHELL \n \
  🛑 Please install Zsh and run this script again."
  exit 1
fi

# Run the installation script
zsh $HOME/.dotfiles/setup/install.zsh


# Github configurations
zsh $HOME/.dotfiles/git/git_setup.zsh

# Install Powerlevel10k
echo "🌌 Installing Powerlevel10k..."
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
create_symbolic_link $HOME/.dotfiles/tilde/.p10k.zsh $HOME/.p10k.zsh

#### Creating Symlinks / Bootsrapping
echo "🐿️ Setting up Symlinks..."
# Shell
if is_file_exists "$HOME/.zshrc"; then
  mv $HOME/.zshrc $HOME/.zshrc_old
fi
create_symbolic_link $HOME/.dotfiles/zsh/.zshrc $HOME/.zshrc 
create_symbolic_link $HOME/.dotfiles/zsh/.zsh_aliases $HOME/.zsh_aliases
create_symbolic_link $HOME/.dotfiles/zsh/.zprofile $HOME/.zprofile

# Git
# .gitconfig

# Autostart
# sudo rm -rf $HOME/.config/autostart/
# sudo ln -sfn $HOME/.dotfiles/autostart/ $HOME/.config/autostart

echo "🦆 Restarting Terminal"  
exec $SHELL
