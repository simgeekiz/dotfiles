#!/bin/sh
# This script is used to set Zsh as the default shell
## It checks the operating system and installs Zsh if it is not already installed
## It also installs Homebrew on macOS if it is not already installed

# Author: Simge Ekiz
# License: MIT
# https://github.com/simgeekiz/dotfiles

# Exit on any failed command
set -e

cd $HOME

# Get operating system
if [[ $(uname) == "Linux" ]]; then
  echo '🌲 Platform detected as Linux. Installing accordingly.'
  # Install Git (if it is not already installed)
  if ! command -v git >/dev/null 2>&1; then
    echo "🔧 Installing git"
    if [ -f /etc/debian_version ]; then
      sudo apt update && sudo apt install -y git
    elif [ -f /etc/redhat-release ]; then
      if command -v dnf >/dev/null 2>&1; then
        sudo dnf install -y git
      else
        sudo yum install -y git
      fi
    elif [ -f /etc/arch-release ]; then
      sudo pacman -Sy --noconfirm git
    else
      echo "❌ Unsupported Linux distro"
      exit 0
    fi
  else
    echo "✅ Git is already installed: $(git --version)"
  fi
  
  # Install Zsh (if not already installed)
  if ! command -v zsh >/dev/null 2>&1; then
    echo "🌸 Zsh not found. Attempting to install..."
    if [ -f /etc/debian_version ]; then
      sudo apt install -y zsh
    elif [ -f /etc/redhat-release ]; then
      if command -v dnf >/dev/null 2>&1; then
        sudo dnf install -y zsh
      else
        sudo yum install -y zsh
      fi
    elif [ -f /etc/arch-release ]; then
      sudo pacman -Sy --noconfirm zsh
    else
      echo "❌ Unsupported Linux distro. Install Zsh manually."
      exit 0
    fi
  else
    echo "✅ Zsh already installed: $(zsh --version)"
  fi

elif [[ $(uname) == "Darwin" ]]; then
  echo '🍏 Platform detected as macOS.🍎 Installing accordingly.'
  
  # Install Homebrew if it is not already installed
  if ! command -v brew > /dev/null 2>&1; then
    echo "🫖 Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  
    eval "$(/opt/homebrew/bin/brew shellenv)"
  else
    echo "🫖 Homebrew already installed..."
  fi

  # verify the installation
  echo $(brew --version)
  
  # Install Zsh (If zsh not already installed)
  if ! command -v zsh >/dev/null 2>&1; then
    echo "🌸 Zsh not found. Installing with Homebrew..."
    brew install zsh
  else
    echo "✅ Zsh already installed: $(zsh --version)"
  fi

  # Install Git (if not already installed)
  if ! command -v git >/dev/null 2>&1; then
    echo "🌱 Git not found. Installing with Homebrew..."
    brew install git
  else
    echo "✅ Git already installed: $(git --version)"
  fi
fi

# Check if the shell is Zsh
if [ -n "$ZSH_VERSION" ]; then 
  echo "🔁 You are already using Zsh. Please continue with next step."
else
  echo "🐚 You are using $SHELL"

  # add zsh to the list of shells
  zsh_path=$(which zsh)
  if ! grep -Fxq "$zsh_path" /etc/shells; then
    sudo bash -c "echo $zsh_path >> /etc/shells"
  fi #
  
  # Change the default shell:
  echo "🐚 Setting up Zsh as default shell..."
  chsh -s "$zsh_path"

  # Warn user to restart terminal
  echo "⚠️ Please close and reopen your terminal application for the changes to take effect fully."

  # Restart the terminal in case user forget to restart the terminal. This will not work in all cases. 
  # (For example, $SHELL is not updated in the current terminal session)
  echo "🦆 Restarting Terminal"  
  exec /bin/zsh
fi

bin/zsh .dotfiles/generic/upload_ssh_to_github.zsh

# # Check if the .dotfiles directory exists
if [[ -d "$HOME/.dotfiles" && -d "$HOME/.dotfiles/.git" ]]; then
  echo "🗞️ dotfiles already cloned at $HOME/.dotfiles"
  echo "✒️ Pulling changes from GitHub..."
  git pull
else
  # Clone the repository
  # Try a quick SSH connection to GitHub (non-interactive)
  if ssh -T git@github.com 2>&1 | grep -q "successfully authenticated"; then
    echo "✅ SSH authentication to GitHub succeeded."
    echo "📦 Cloning via SSH..."
    git clone git@github.com:simgeekiz/dotfiles.git ~/.dotfiles 
  else
    echo "⚠️ SSH to GitHub failed. Falling back to HTTPS..."
    git clone https://github.com/simgeekiz/dotfiles.git ~/.dotfiles
  fi
fi
