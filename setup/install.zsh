#!/bin/zsh

# Installation script for Linux and MacOS
# - installs all the needed software;
# - installs Re-volt;
#
# Author: Simge Ekiz
# License: MIT
# https://github.com/simgeekiz/dotfiles

function install_fonts() {
  # This script installs custom fonts from a specified source directory to the target font directory.
  # It is designed to work on macOS, but can be adapted for other systems.

  echo "🌌 Installing Custom Fonts..."
 
  # Source folder where your fonts are stored
  FONT_SOURCE_DIR="$HOME/.dotfiles/fonts"

  # Target font folder for the current user (macOS only)
  FONT_TARGET_DIR="$HOME/Library/Fonts"

  if [ ! -d "$FONT_SOURCE_DIR" ]; then
    echo "❌ Font source folder not found: $FONT_SOURCE_DIR"
    exit 1   
  elif [ -d "$FONT_SOURCE_DIR" ]; then
    # Create the target directory if it doesn't exist
    if [ ! -d "$FONT_TARGET_DIR" ]; then
      mkdir -p "$FONT_TARGET_DIR"  
    fi

    # Copy .ttf and .otf fonts
    find "$FONT_SOURCE_DIR" -type f \( -iname "*.ttf" -o -iname "*.otf" \) -exec cp "{}" "$FONT_TARGET_DIR" \;
  fi
}

# Ask the user if they want to install any applications or update the system
echo
while true; do
  printf "🛠️  Do you want to install CLI tools and update the system? [Y/n]: "
  read install_cli
  install_cli=$(echo "$install_cli" | xargs) # Trim whitespace
  install_cli=${install_cli:-y}  # set default to 'y' if empty

  case "$install_cli" in
    y|Y|yes|YES|Yes|YeS|yEs|YEs)
      break
      ;;
    n|N|no|NO|No|nO ) 
      exit 1   
      break
      ;;
    * )
      echo "🎸 Please answer yes [y] or no [n]."
      ;;
  esac
done

# Get operating system
unamestr=$(uname)
if [[ $unamestr == "Linux" ]]; then
  printlog "🌲 Platform detected as Linux. Installing accordingly."
  # Update the system
  echo "🔄 Updating system..."
  sudo apt update && sudo apt upgrade -y

  # Array of packages to install CLI(command line Interface)   # cmake fortune-mod cowsay htop, tree, tmux, vim
  # "zsh" "vim" "htop" "tree" "jq" "cmake" "fortune-mod" "cowsay" "python-is-python3
  cli_packages=("git" "python3" "python3-pip" "curl" "tmux" "wget" "build-essential")

  for package in "${cli_packages[@]}"; do
    echo "⚒️ Installing $package"
    sudo apt install -y "$package"

    # # Check if the package is already installed
    # if ! which $package > /dev/null; then
    #   # Install the package
    #   sudo apt install -y "$package" || echo "🐥 Unable to install $package"
    # else
    #   echo "🐣 $package is already installed"
    # fi
  done

  # Ask the user if they want to install GUI applications
  echo
  while true; do
    printf "🦋 Do you want to install GUI (desktop) applications as well? [Y/n]: "
    read install_gui
    install_gui=$(echo "$install_gui" | xargs) # Trim whitespace
    install_gui=${install_gui:-y}  # set default to 'y' if empty

    case "$install_gui" in
      y|Y|yes|YES|Yes|YeS|yEs|YEs) 
        gui_apps=("code" "slack" "google-chrome" "vlc")
        # Install GUI applications using snap
        for ap in "${gui_apps[@]}"; do
          sudo apt install -y snapd
          echo "🏡 Installing $ap"
          sudo snap install --classic "$ap" || echo "Unable to install $ap"
          # # Check if the package is already installed
          # if ! which $package > /dev/null; then
          #   # Install the package
          #   sudo apt install -y "$package" || echo "🐥 Unable to install $package"
          # else
          #   echo "🐣 $package is already installed"
          # fi

          # snap install --classic code (for Visual Studio Code)
          # snap install slack --classic (for Slack)
          # gimp vlc steam spotify-client python-is-python3 guake
        done
        break
        ;;
      n|N|no|NO|No|nO ) 
        echo "📝 Skipping GUI apps..."
        break
        ;;
      * )
        echo "🎸 Please answer yes [y] or no [n]."
        ;;
    esac
  done

  # Ask the user if they want to install Node.js
  echo
  while true; do
    printf "🚀 Do you want to install Node.js? [Y/n]: "
    read install_node
    install_node=$(echo "$install_node" | xargs) # Trim whitespace
    install_node=${install_node:-y}  # set default to 'y' if empty

    case $install_node in
      y|Y|yes|YES|Yes|YeS|yEs|YEs) 
        echo "🚀 Installing Node.js..."
        # Installing Node.js dependencies...
        npm config set loglevel warn
        npm install -g npm-upgrade
        npm install
        break;;
      n|N|no|NO|No|nO )
        echo "🗂️ Skipping Node.js installation..."
        break;;
      * )
        echo "🎸 Please answer yes [y] or no [n]."
        ;;
    esac
  done

  echo "⚙️ Updating & Upgrading & Autoremoving"
  sudo apt update
  sudo apt upgrade
  sudo apt autoremove
  sudo apt clean

elif [[ $unamestr == "Darwin" ]]; then
  printlog "🍎 Platform detected as macOS. Installing accordingly."

  # Ask the user if they want to install GUI applications
  while true; do
    printf "🦋 Do you want to install GUI (desktop) applications as well? [Y/n]: "
    read install_gui

    install_gui=$(echo "$install_gui" | xargs) # Trim whitespace
    install_gui=${install_gui:-y}  # set default to 'y' if empty
    case "$install_gui" in
      y|Y|yes|YES|Yes|YeS|yEs|YEs) 
      echo "☕️ Installing Homebrew dependencies...\n🏡 Setting up GUI apps..."
      brew bundle install --file="$HOME/.dotfiles/setup/Brewfile"
      break
      ;;
      n|N|no|NO|No|nO ) 
      # to install only CLI tools (strip cask lines)
      echo "☕️ Installing Cli tools and libraries... \n📝 Skipping GUI apps..."
      grep '^brew ' "$HOME/.dotfiles/setup/Brewfile" > "$HOME/.dotfiles/setup/Brewfile.cli"
      brew bundle install --file="$HOME/.dotfiles/setup/Brewfile.cli"
      rm "$HOME/.dotfiles/setup/Brewfile.cli"
      break
      ;;
      * )
      echo "🎸 Please answer yes [y] or no [n]."
      ;;
    esac
  done

  # fzf, fuzzy finder
  # echo "🌁 Configuring fzf..."
  # $(brew --prefix)/opt/fzf/install
  # echo

  # Installing custom fonts
  install_fonts

else
  # Unknown or unsupported OS
  printlog "❌ Unsupported platform: $unamestr"
  exit 1
fi


# Ask the user if they want to install Re-volt
echo
while true; do
  printf "🏎️ Do you want to install Re-Volt? [Y/n]: "
  read install_revolt
  install_revolt=$(echo "$install_revolt" | xargs) # Trim whitespace
  install_revolt=${install_revolt:-y}  # set default to 'y' if empty
  
  case $install_revolt in
    y|Y|yes|YES|Yes|YeS|yEs|YEs) 
      echo "🚙 Installing Re-Volt..."
      # Install Re-Volt
      zsh $HOME/.dotfiles/revolt/install.zsh
      break;;
    n|N|no|NO|No|nO )
      echo "🗑️ Skipping Re-Volt installation..."
      break;;
    * )
      echo "🎸 Please answer yes [y] or no [n]."
      ;;
  esac
done