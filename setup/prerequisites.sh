# This script is used to set Zsh as the default shell
## It checks the operating system and installs Zsh if it is not already installed
## It also installs Homebrew on macOS if it is not already installed

# Author: Simge Ekiz
# License: MIT
# https://github.com/simgeekiz/dotfiles

# Exit on any failed command
set -e

# Get operating system
unamestr=$(uname)
if [[ $unamestr == "Linux" ]]; then
  echo '🌲 Platform detected as Linux. Installing accordingly.'

  # Install Zsh (If zsh not already installed)
  sudo apt install zsh

elif [[ $unamestr == "Darwin" ]]; then
  echo '🌲 Platform detected as MacOS. Installing accordingly.'

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
  if ! command -v zsh > /dev/null 2>&1; then
    echo "🌸 Installing Zsh..."
    brew install zsh
  else
    echo "🌸 Zsh already installed..."
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
  /bin/zsh
fi


