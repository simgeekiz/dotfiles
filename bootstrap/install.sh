#!/usr/bin/env sh
# ~/.dotfiles/bootstrap/install.sh
# Installation script for Linux and MacOS
# - installs required packages and development tools;
# - installs Re-volt;
#
# Author: Simge Ekiz
# License: MIT
# https://github.com/simgeekiz/dotfiles

# DONE
# function to install fonts
install_fonts() {
  # This script installs custom fonts from a specified source directory to the target font directory.
  printf '%s\n' "🌌 Installing Custom Fonts..."

  # Source folder where your fonts are stored
  FONT_SOURCE="$HOME/.dotfiles/fonts"

  FONT_TARGET="$HOME/.local/share/fonts"

  OS_NAME=$(uname -s)
  case "$OS_NAME" in
    Linux) FONT_TARGET="$HOME/.local/share/fonts" ;;
    Darwin) FONT_TARGET="$HOME/Library/Fonts" ;;
    *) printf '%s\n' "❗ Unsupported OS: $OS_NAME"; exit 1 ;;
  esac

  # Check source exists
  [ -d "$FONT_SOURCE" ] || { 
    printf '%s\n' "❗ Font source folder not found: $FONT_SOURCE"; 
    return 1
  }

  # Save file list to temporary file
  tmp_fonts=$(mktemp) || return 1
  find "$FONT_SOURCE" -type f \( -iname "*.ttf" -o -iname "*.otf" \) > "$tmp_fonts"

  # Track whether any fonts were copied
  fonts_copied=false

  # Create the target directory if it doesn't exist
  mkdir -p "$FONT_TARGET" || {
    printf '%s\n' "❗ Failed to create font directory: $FONT_TARGET"
    return 1
  }

  # Copy fonts (.ttf and .otf)
  while IFS= read -r font_file; do
    font_name=$(basename "$font_file")
    target_font="$FONT_TARGET/$font_name"

    if [ ! -f "$target_font" ]; then
      cp "$font_file" "$target_font"
      fonts_copied=true
      printf '%s\n' "✅ Installed font: $font_name"
    fi
  done < "$tmp_fonts"

  rm -f "$tmp_fonts"

  # Update font cache if any fonts were copied
  if [ "$fonts_copied" = "true" ]; then
    if command -v fc-cache >/dev/null 2>&1; then
      printf '%s\n' "🔄 Updating font cache..."
      fc-cache -f -v
    fi
  else
    printf '%s\n' "📖 Fonts already installed — skipping cache update."
  fi

  printf '%s\n' '📜 Please change your font in Preferences and select MesloLGS NF Regular'
  # Guake:
  # Under Appearance tab, uncheck Use the system fixed width font (if not already) and select MesloLGS NF Regular.
  # Exit the Preferences dialog by clicking Close.
  # Apple Terminal:
  # Open Terminal → Preferences → Profiles → Text, click Change under Font and select MesloLGS NF family.
}


# DONE
# Function to install powerlevel10k and create a symbolic link
install_p10k() {
  printf '%s\n' "🌌 Installing Powerlevel10k..."

  repo_dir="$HOME/powerlevel10k"

  # Check if repository already exists
  if [ -d "$repo_dir/.git" ]; then
    printf '%s\n' "🗞️  Powerlevel10k already cloned at $repo_dir"
  else
    if ! git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$repo_dir"; then
      printf '%s\n' "❗ Failed to clone Powerlevel10k"
      return 1
    fi
  fi

  # Create symlink for .p10k.zsh
  if [ -f "$HOME/.dotfiles/p10k/.p10k.zsh" ]; then
    symlink "$HOME/.dotfiles/p10k/.p10k.zsh" "$HOME/.p10k.zsh"
  else
    printf '%s\n' "ℹ️ No .p10k.zsh found in dotfiles — skipping symlink."
  fi
}


# DONE
# Function to install a .deb package
install_deb() {
  app="$1"
  url="$2"

  # Create a temporary file safely
  tmpfile=$(mktemp "/tmp/${app}.XXXXXX.deb") || return 1

  # Download the .deb file
  if ! wget -qO "$tmpfile" "$url"; then
    printf '%s\n' "❗ Failed to download $app from $url"
    rm -f "$tmpfile"
    return 1
  fi

  # Install the package
  if ! sudo apt install -y "$tmpfile"; then
    printf '%s\n' "❗ Failed to install $app"
    rm -f "$tmpfile"
    return 1
  fi

  # Remove temporary file
  rm -f "$tmpfile"
  printf '%s\n' "✅ $app installed successfully."
}


# DONE
install_code() {
  # Installs Visual Studio Code and extensions
  printf '%s\n' "🧩 Installing Visual Studio Code..."
  sudo apt update || printf '%s\n' "❗ Failed to update package lists..."
  sudo apt install -y wget gpg || printf '%s\n' "❗ Failed to install wget/gpg..."

  # Create temporary files
  tmpkey=$(mktemp "/tmp/ms_key.XXXXXX.asc") || return 1
  tmpgpg=$(mktemp "/tmp/packages.microsoft.XXXXXX.gpg") || { rm -f "$tmpkey"; return 1; }

  # Download Microsoft GPG key
  if ! wget -qO "$tmpkey" https://packages.microsoft.com/keys/microsoft.asc; then
    printf '%s\n' "❗ Failed to download Microsoft GPG key"
    rm -f "$tmpkey"
    return 1
  fi

  # Convert GPG key
  if ! gpg --dearmor < "$tmpkey" > "$tmpgpg"; then
    printf '%s\n' "❗ Failed to process GPG key"
    rm -f "$tmpkey" "$tmpgpg"
    return 1
  fi

  # Install the GPG key into apt keyrings
  if ! sudo install -D -o root -g root -m 644 "$tmpgpg" /etc/apt/keyrings/packages.microsoft.gpg; then
    printf '%s\n' "❗ Failed to install Microsoft GPG key"
    rm -f "$tmpkey" "$tmpgpg"
    return 1
  fi

  # Add VS Code repository
  if ! printf '%s\n' \
    "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" \
    | sudo tee /etc/apt/sources.list.d/vscode.list >/dev/null; then
    printf '%s\n' "❗ Failed to add VS Code repository"
    rm -f "$tmpkey" "$tmpgpg"
    return 1
  fi


  # Clean up temporary key file
  rm -f "$tmpkey" "$tmpgpg"

  # Install VS Code
  if ! sudo apt update; then
    printf '%s\n' "❗ Failed to update package lists after adding repo"
    return 1
  fi

  if ! sudo apt install -y code; then
    printf '%s\n' "❗ VS Code installation failed"
    return 1
  fi

  # Install extensions
  CODE_CMD=""
  if command -v code >/dev/null 2>&1; then
    CODE_CMD="code"
  elif command -v code-insiders >/dev/null 2>&1; then
    CODE_CMD="code-insiders"
  fi

  if [ -z "$CODE_CMD" ]; then
    printf '%s\n' "⚠️ VS Code CLI not found."
    return 1
  fi

  EXT_FILE="$HOME/.dotfiles/vscode/vscode-extensions.txt"
  
  if [ -f "$EXT_FILE" ]; then
    printf '%s\n' "📦 Installing extensions from $EXT_FILE..."
    while IFS= read -r ext; do
      case $ext in
        ''|\#*) continue ;;
      esac
      "$CODE_CMD" --install-extension "$ext" --force
    done < "$EXT_FILE"

    printf '%s\n' "✅ Extensions installation complete."
  else
    printf '%s\n' "ℹ️ No extensions file found at $EXT_FILE — skipping."
  fi
}


# DONE
# Function to install GUI applications
install_gui() {
  # List of GUI apps in "name|method|url" format
  gui_file=$HOME/.dotfiles/gui-apps.txt

  if [ ! -f "$gui_file" ]; then
    printf '%s\n' "⚠️ GUI app list not found: $gui_file"
    return 1
  fi

  # Loop over each line
  while IFS= read -r ap; do
    case $ap in
      ''|\#*) continue ;;
    esac


    OLD_IFS=$IFS
    IFS='|'
    set -- $ap
    IFS=$OLD_IFS

    name=$1
    method=$2
    url=$3

    # Validate fields
    if [ -z "$name" ] || [ -z "$method" ]; then
      printf '%s\n' "⚠️ Invalid entry: $ap"
      continue
    fi

    # Check if already installed
    if command -v "$name" >/dev/null 2>&1; then
      printf '%s\n' "🏡 $name is already installed"
      continue
    fi

    printf '%s\n' "🔧 Installing $name..."

    case $method in
      deb)
        # install_deb "$name" "$url" || printf '%s\n' "⚠️ $name installation failed"
        if ! install_deb "$name" "$url"; then
          printf '%s\n' "⚠️ $name installation failed"
        fi
        ;;
      repo)
        if [ "$name" = "code" ]; then
          install_code || printf '%s\n' "⚠️ VS Code installation failed!"
        fi
        ;;
      *)
        printf '%s\n' "⚠️ Unknown method '$method' for $name"
        ;;
    esac
    
  done < "$gui_file"
}


# Function to install Node.js and its dependencies
install_nodejs() {
  printf '%s\n' "🚀 Installing Node.js via NVM..."

  # Check if nvm is already installed
  if [ -s "$HOME/.nvm/nvm.sh" ]; then
    # Load nvm
    . "$HOME/.nvm/nvm.sh"
  else
    # Download and install nvm
    tmpfile=$(mktemp) || return 1

    if ! curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh -o "$tmpfile"; then
      printf '%s\n' "❗ Failed to download NVM installer"
      rm -f "$tmpfile"
      return 1
    fi

    if ! sh "$tmpfile"; then
      printf '%s\n' "❗ Failed to run NVM installer"
      rm -f "$tmpfile"
      return 1
    fi

    rm -f "$tmpfile"

    # Load NVM after install
    if [ -s "$HOME/.nvm/nvm.sh" ]; then
      . "$HOME/.nvm/nvm.sh"
    else
      printf '%s\n' "❗ NVM install failed or nvm.sh not found."
      return 1
    fi
  fi

  # Ensure nvm is available
  if ! command -v nvm >/dev/null 2>&1; then
    printf '%s\n' "❗ nvm command not available"
    return 1
  fi

  # Check if Node.js v24 is already installed
  if command -v node >/dev/null 2>&1; then
    NODE_VERSION=$(node -v | sed 's/^v//')
    case "$NODE_VERSION" in
      24*)
        printf '%s\n' "📦 Node.js v24 already installed: v$NODE_VERSION"
        return 0
        ;;
    esac
  fi

  # Install Node.js v24
  if ! nvm install 24; then
    printf '%s\n' "❗ Node.js installation failed"
    return 1
  fi

  if ! nvm use 24 >/dev/null 2>&1; then
    printf '%s\n' "❗ Failed to activate Node.js v24"
    return 1
  fi
  
  # Print versions
  command -v node >/dev/null 2>&1 && printf '%s\n' "✅ Node.js installed successfully. Node.js version: $(node -v)"
  command -v npm >/dev/null 2>&1 && printf '%s\n' "npm version: $(npm -v)"
}


# Function to install CLI tools and update the system
install_cli() {
  # Get operating system

  printf '%s\n' "🔄 Updating system packages..."
  sudo apt update || printf '%s\n' "❗ Failed to update package lists."
  sudo apt upgrade -y || printf '%s\n' "❗ Failed to upgrade packages."

  printf '%s\n' "🔨 Installing CLI tools from apt.txt..."
  
  # --- Check if package list exists ---
  file="$HOME/.dotfiles/packages/apt.txt"
  if [ -f "$file" ]; then
    while IFS= read -r pkg; do
      case $pkg in
        ''|\#*) continue ;;
      esac
      
      if ! sudo apt install -y "$pkg"; then
        printf '%s\n' "❗ Failed to install $pkg; continuing..."
      fi
    done < "$file"
  else
    printf '%s\n' "ℹ️ No apt.txt found — skipping."
  fi

  printf '%s\n' "⚙️ Running cleanup steps..."
  sudo apt autoremove -y || printf '%s\n' "❗ Failed to autoremove packages during cleanup"
  sudo apt clean || printf '%s\n' "❗ Failed to clean apt cache"
}

install_mac_gui() {
  printf '%s\n' "☕️ Installing Homebrew dependencies... 🏡 Setting up GUI apps..."
  brew bundle install --file="$HOME/.dotfiles/packages/Brewfile"
}

install_mac_cli() {
  # to install only CLI tools (strip cask lines)
  printf '%s\n' "☕️ Installing CLI tools and libraries... 📝 Skipping GUI apps..."
  grep "^brew " "$HOME/.dotfiles/packages/Brewfile" > "$HOME/.dotfiles/packages/Brewfile.cli"
  brew bundle install --file="$HOME/.dotfiles/packages/Brewfile.cli"
  rm -f "$HOME/.dotfiles/packages/Brewfile.cli"
}

# newfun() {
#   echo "install 1, this have to run there is no return yet"
#   # return 1

#   if [ ! -f "$HOME/.dotfiles/plan/fail" ]; then
#       printf "❗ no file\n"
#       return 1  
#   fi

#   echo "install 4, this does not need to run"
# }

# newfun

# echo "install 5 outside This needs to run after function fail"
# [ -f "$HOME/.dotfiles/plan/fail" ] || { 
#     printf "❗ no file\n"
#     # return 1
# }
# echo "install 6 outside. I want this to run after fail"

main() {
  case "$(uname -s)" in
    Darwin*)
      printf '%s\n' "🍎 Platform detected as macOS. Installing accordingly."

      # Ask the user about GUI apps
      prompt_user "🦋 Do you want to install GUI (desktop) applications as well?" \
        'install_mac_gui || printf "⚠️ GUI apps installation failed...\n"' \
        'install_mac_cli || printf "⚠️ CLI-only installation failed...\n"'
      ;;
    Linux*)
      printf '%s\n' "🌲 Platform detected as Linux. Installing accordingly."

      # Install CLI tools
      printf '%s\n' "⚙️ Installing CLI tools via apt..."
      install_cli || printf '⚠️ Some CLI tools failed...\n'

      # Ask the user if they want to install GUI applications
      prompt_user "🦋 Do you want to install GUI (desktop) applications as well?" \
        'install_gui || printf "⚠️ GUI apps installation failed...\n"' \
        ''
      ;;
    *)
      printf '%s\n' "❗ Unsupported OS: $(uname -s). Please check if you are running this on a supported OS (Linux or macOS)."
      exit 1
      ;;
  esac
}

main "$@"

# Optional installs

# # Ask the user if they want to install custom fonts and powerlevel10k
# prompt_user "🛠️  Do you want to install Powerlevel10k?" \
#   'install_fonts || printf "⚠️ Fonts installation failed. \n"; 
#    install_p10k || printf "⚠️ Powerlevel10k installation failed. \n"' \
#   ''

# # Ask the user if they want to install Re-volt
# prompt_user "🏎️ Do you want to install Re-Volt?" '. $HOME/.dotfiles/re-volt/install.zsh' ''

# # Ask the user if they want to install Node.js
# prompt_user "🚀 Do you want to install Node.js?" \
#   'install_nodejs || printf "⚠️ Node.js installation failed; continuing...\n"' \
#   ''
# ;;
