#!/bin/zsh

# Installation script for Linux and MacOS
# - installs all the needed software;
# - installs Re-volt;
#
# Author: Simge Ekiz
# License: MIT
# https://github.com/simgeekiz/dotfiles

# function to install fonts
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

# Function to install powerlevel10k and create a symbolic link
function install_p10k() {
  # Install Powerlevel10k
  echo "🌌 Installing Powerlevel10k..."
  repo_dir="$HOME/powerlevel10k"
  if [[ -d "$repo_dir/.git" && -d "$repo_dir" ]]; then
    echo "🗞️  Powerlevel10k already cloned at $repo_dir"
  else
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $repo_dir
  fi

  symlink $HOME/.dotfiles/p10k/.p10k.zsh $HOME/.p10k.zsh
}

# Function to install a .deb package
function install_deb() {
  local app="$1"
  local url="$2"
  wget -qO "/tmp/$app.deb" "$url"
  sudo apt install -y "/tmp/$app.deb"
  rm "/tmp/$app.deb"
}

# Function to install Visual Studio Code
function install_code() {
  local app="$1"
  sudo apt-get install wget gpg
  wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
  sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
  echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" |sudo tee /etc/apt/sources.list.d/vscode.list > /dev/null
  rm -f packages.microsoft.gpg

  # Install extensions
  if [ -f "$HOME/.dotfiles/vscode/vscode-extensions.txt" ]; then
    echo "📦 Installing extensions..."
    xargs -n 1 code --install-extension < "$HOME/.dotfiles/vscode/vscode-extensions.txt"
  else
    echo "⚠️ No vscode-extensions.txt file found"
  fi
}

# Function to install GUI applications
function install_gui {
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
}

# Function to install Node.js and its dependencies
function install_nodejs() {
  echo "🚀 Installing Node.js..."
  # Installing Node.js dependencies...
  npm config set loglevel warn
  npm install -g npm-upgrade
  npm install
}

# Function to install CLI tools and update the system
function install_cli {
  # Get operating system
 
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

  echo "⚙️ Updating & Upgrading & Autoremoving"
  sudo apt update
  sudo apt upgrade
  sudo apt autoremove
  sudo apt clean

}

# Ask the user if they want to install custom fonts and powerlevel10k
prompt_user "🛠️  Do you want to install Powerlevel10k?" "install_fonts && install_p10k" ""

case "$(uname)" in
  Darwin)
    printf "🍎 Platform detected as macOS. Installing accordingly."
    # to install only CLI tools (strip cask lines)
    prompt_user "🦋 Do you want to install GUI (desktop) applications as well?" \
    'echo "☕️ Installing Homebrew dependencies... 🏡 Setting up GUI apps..."; brew bundle install --file="$HOME/.dotfiles/setup/Brewfile"' \
    'echo "☕️ Installing CLI tools and libraries... 📝 Skipping GUI apps..."; grep "^brew " "$HOME/.dotfiles/setup/Brewfile" > "$HOME/.dotfiles/setup/Brewfile.cli"; brew bundle install --file="$HOME/.dotfiles/setup/Brewfile.cli"; rm "$HOME/.dotfiles/setup/Brewfile.cli"'
    ;;
  Linux)
    printf "🌲 Platform detected as Linux. Installing accordingly."
    # install any applications or update the system
    install_cli
    # Ask the user if they want to install GUI applications
    prompt_user "🦋 Do you want to install GUI (desktop) applications as well?" install_gui ""
    ;;
  *)
    echo "❌ Unsupported OS: $(uname)"
    echo "❗ Please check if you are running this on a supported OS (Linux or macOS)."
    exit 1
    ;;
esac

# # Ask the user if they want to install Re-volt
# prompt_user "🏎️ Do you want to install Re-Volt?" 'echo "🚙 Installing Re-Volt..." && source $HOME/.dotfiles/re-volt/install.zsh' ""

# # Ask the user if they want to install Node.js
# prompt_user "🚀 Do you want to install Node.js?" install_nodejs ""