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
  echo "🌌 Installing Custom Fonts..."
 
  # Source folder where your fonts are stored
  FONT_SOURCE_DIR="$HOME/.dotfiles/fonts"

  FONT_TARGET_DIR="$HOME/.local/share/fonts"

  if [[ $(uname) == "Linux" ]]; then
    FONT_TARGET_DIR="$HOME/.local/share/fonts"
  elif [[ $(uname) == "Darwin" ]]; then
    FONT_TARGET_DIR="$HOME/Library/Fonts"
  fi 

  if [ ! -d "$FONT_SOURCE_DIR" ]; then
    echo "❌ Font source folder not found: $FONT_SOURCE_DIR"
    return 1   
  fi

  # Track whether any fonts were copied
  fonts_copied=false

  # Create the target directory if it doesn't exist
  if [ ! -d "$FONT_TARGET_DIR" ]; then
    mkdir -p "$FONT_TARGET_DIR"  
  fi

  while IFS= read -r -d '' font_file; do
    font_name=$(basename "$font_file")
    target_font="$FONT_TARGET_DIR/$font_name"

    if [[ ! -f "$target_font" ]]; then
      cp "$font_file" "$target_font"
      fonts_copied=true
    fi
  done < <(find "$FONT_SOURCE_DIR" -type f \( -iname "*.ttf" -o -iname "*.otf" \) -print0)

  # # Copy .ttf and .otf fonts
  # find "$FONT_SOURCE_DIR" -type f \( -iname "*.ttf" -o -iname "*.otf" \) -exec cp "{}" "$FONT_TARGET_DIR" \;
  
  if $fonts_copied; then
    echo "🔄 Updating font cache..."
    fc-cache -f -v
  else
    echo "📖 All fonts already installed. Skipping cache update."
  fi

  echo '📜 Please change your font in Preferences and select MesloLGS NF Regular'
  # Guake: 
  # Under Appearance tab, uncheck Use the system fixed width font (if not already) and select MesloLGS NF Regular. 
  # Exit the Preferences dialog by clicking Close.
  # Apple Terminal: 
  # Open Terminal → Preferences → Profiles → Text, click Change under Font and select MesloLGS NF family.
}

install_deb() {
  local app="$1"
  local url="$2"
  wget -qO "/tmp/$app.deb" "$url"
  sudo apt install -y "/tmp/$app.deb"
  rm "/tmp/$app.deb"
}

install_code() {
  local app="$1"
  sudo apt-get install wget gpg
  wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
  sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
  echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" |sudo tee /etc/apt/sources.list.d/vscode.list > /dev/null
  rm -f packages.microsoft.gpg
}

function install_software {
  # Get operating system
  unamestr=$(uname)
  if [[ $unamestr == "Linux" ]]; then
    printf "🌲 Platform detected as Linux. Installing accordingly."
    # Update the system
    echo
    echo "🔄 Updating system..."
    sudo apt update && sudo apt upgrade -y

    # Array of packages to install CLI(command line Interface)   # cmake fortune-mod cowsay htop, tree, tmux, vim
    # "zsh" "vim" "htop" "tree" "jq" "cmake" "fortune-mod" "cowsay" "python-is-python3
    cli_packages=("git" "python3" "python3-pip" "curl" "tmux" "wget" "build-essential" "gpg")

    for pkg in "${cli_packages[@]}"; do
      # Check if the package is already installed
      if dpkg -s "$pkg" >/dev/null 2>&1 || command -v "$pkg" >/dev/null 2>&1; then
        echo "🐣 $pkg is already installed"
      else
        echo "🔨 Installing $pkg"
        sudo apt install -y "$pkg" || echo "🐥 Unable to install $pkg"
      fi
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
          gui_apps=(
            "google-chrome|deb|https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
            "code|repo|https://packages.microsoft.com/repos/vscode"
          )

          for ap in "${gui_apps[@]}"; do
            IFS="|" read -r name method url <<< "$ap"
            if command -v "$name" >/dev/null 2>&1; then
              echo "🏡 $name is already installed"
            else
              echo "🔧 Installing $name..."
              if [[ $name == "code" ]]; then
                install_code "$name" 
              else
                install_deb "$name" "$url"
              fi
            fi
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
    printf "🍎 Platform detected as macOS. Installing accordingly."

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

  else
    # Unknown or unsupported OS
    printf "❌ Unsupported platform: $unamestr"
    exit 1
  fi
  
  # # Ask the user if they want to install Re-volt
  # echo
  # while true; do
  #   printf "🏎️ Do you want to install Re-Volt? [Y/n]: "
  #   read install_revolt
  #   install_revolt=$(echo "$install_revolt" | xargs) # Trim whitespace
  #   install_revolt=${install_revolt:-y}  # set default to 'y' if empty
    
  #   case $install_revolt in
  #     y|Y|yes|YES|Yes|YeS|yEs|YEs) 
  #       echo "🚙 Installing Re-Volt..."
  #       # Install Re-Volt
  #       source $HOME/.dotfiles/revolt/install.zsh
  #       break;;
  #     n|N|no|NO|No|nO )
  #       echo "🗑️ Skipping Re-Volt installation..."
  #       break;;
  #     * )
  #       echo "🎸 Please answer yes [y] or no [n]."
  #       ;;
  #   esac
  # done

}

# Installing custom fonts
echo
while true; do
  printf "🛠️  Do you want to install custom fonts? [Y/n]: "
  read install_font
  install_font=$(echo "$install_font" | xargs) # Trim whitespace
  install_font=${install_font:-y}  # set default to 'y' if empty

  case "$install_font" in
    y|Y|yes|YES|Yes|YeS|yEs|YEs)
      install_fonts
      break
      ;;
    n|N|no|NO|No|nO ) 
      break
      ;;
    * )
      echo "🎸 Please answer yes [y] or no [n]."
      ;;
  esac
done


# Ask the user if they want to install any applications or update the system
echo
while true; do
  printf "🛠️  Do you want to install CLI tools and update the system? [Y/n]: "
  read install_cli
  install_cli=$(echo "$install_cli" | xargs) # Trim whitespace
  install_cli=${install_cli:-y}  # set default to 'y' if empty

  case "$install_cli" in
    y|Y|yes|YES|Yes|YeS|yEs|YEs)
      install_software
      break
      ;;
    n|N|no|NO|No|nO ) 
      break
      ;;
    * )
      echo "🎸 Please answer yes [y] or no [n]."
      ;;
  esac
done


