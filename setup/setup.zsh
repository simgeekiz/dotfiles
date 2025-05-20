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
  echo "⚓ Symbolic link created: $source_file -> $destination_file"
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

# software installations
source $HOME/.dotfiles/setup/install.zsh

# # Guake settings
# if command -v guake >/dev/null 2>&1; then
#   mkdir -p "$(dirname $HOME/.config/guake/guake.conf)"

#   if [[ -e $HOME/.config/guake/guake.conf ]]; then
#     if [[ -L $HOME/.config/guake/guake.conf ]]; then
#       echo "✔️  $HOME/.config/guake/guake.conf already points to the correct target"
#     else
#       create_symbolic_link $HOME/.dotfiles/guake/guake.conf $HOME/.config/guake/guake.conf
#     fi
#   else
#     create_symbolic_link $HOME/.dotfiles/guake/guake.conf $HOME/.config/guake/guake.conf
#   fi
# fi

# Git configurations
# .gitconfig
if [[ -e $HOME/.gitconfig ]]; then
  if [[ -L $HOME/.gitconfig && $(readlink $HOME/.gitconfig)=="$HOME/.dotfiles/git/.gitconfig" ]]; then
    echo "✔️  $HOME/.gitconfig already points to the correct target"
  else
    create_symbolic_link $HOME/.dotfiles/git/.gitconfig $HOME/.gitconfig
  fi
else
  create_symbolic_link $HOME/.dotfiles/git/.gitconfig $HOME/.gitconfig
fi

git_name=$(git config --global --get user.name || true)
git_email=$(git config --global --get user.email || true)

if [[ -n "$git_name" && -n "$git_email" ]]; then
  echo "🔖 Git name and email are already set."
else
  source $HOME/.dotfiles/git/git_setup.zsh
fi


# Install Powerlevel10k
echo "🌌 Installing Powerlevel10k..."
repo_dir="$HOME/powerlevel10k"
if [[ -d "$repo_dir/.git" && -d "$repo_dir" ]]; then
  echo "🗞️  Powerlevel10k already cloned at $repo_dir"
else
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $repo_dir
fi


if [[ -e $HOME/.p10k.zsh ]]; then
  if [[ -L $HOME/.p10k.zsh && $(readlink $HOME/.p10k.zsh)=="$HOME/.dotfiles/p10k/.p10k.zsh" ]]; then
    echo "✔️  $HOME/.p10k.zsh already points to the correct target"
  else
    create_symbolic_link $HOME/.dotfiles/p10k/.p10k.zsh $HOME/.p10k.zsh
  fi
else
  create_symbolic_link $HOME/.dotfiles/p10k/.p10k.zsh $HOME/.p10k.zsh
fi


#### Creating Symlinks / Bootsrapping
echo "🐿️  Setting up Symlinks..."
# Shell
# if is_file_exists "$HOME/.zshrc"; then
#   mv $HOME/.zshrc $HOME/.zshrc_old
# fi

# List of config files to check
files=(.zshrc .zsh_aliases .zprofile)

for file in $files; do
  fullpath="$HOME/$file"

  if [[ -e $fullpath ]]; then
    if [[ -L $fullpath ]]; then
      if [[ $(readlink $fullpath)=="$HOME/.dotfiles/zsh/$file" ]]; then
        echo "✔️  $fullpath already points to the correct target"
      else
        create_symbolic_link $HOME/.dotfiles/zsh/$file $fullpath
      fi

    else
      create_symbolic_link $HOME/.dotfiles/zsh/$file $fullpath
    fi
  else
    create_symbolic_link $HOME/.dotfiles/zsh/$file $fullpath
  fi
done


# Autostart
# sudo rm -rf $HOME/.config/autostart/
# sudo ln -sfn $HOME/.dotfiles/autostart/ $HOME/.config/autostart

echo "🦆 Restarting Terminal"  
exec $SHELL
