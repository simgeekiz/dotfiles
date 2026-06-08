#!/usr/bin/env sh
# ~/.dotfiles/bootstrap/install.sh
# Installation script for Linux and MacOS
# - installs required packages and development tools;
# - installs Re-volt;
#
# Author: Simge Ekiz
# License: MIT
# https://github.com/simgeekiz/dotfiles

# Load shared bootstrap helpers when install.sh is invoked directly or via sh -c.
if [ -r "$HOME/.dotfiles/bootstrap/helpers.sh" ]; then
  . "$HOME/.dotfiles/bootstrap/helpers.sh"
else
  printf '%s\n' "⚠️  helpers.sh not found or unreadable"
fi

if [ -r "$HOME/.dotfiles/bootstrap/linux-packages.sh" ]; then
  . "$HOME/.dotfiles/bootstrap/linux-packages.sh"
else
  printf '%s\n' "⚠️  linux-packages.sh not found or unreadable"
fi

# Function to check if user can use sudo
has_sudo() {
  # Check if sudo command exists
  if ! command -v sudo >/dev/null 2>&1; then
    return 1  # false, sudo not installed
  fi

  # Check if user can sudo non-interactively (passwordless)
  if sudo -n true 2>/dev/null; then
    return 0  # true, sudo works without password
  fi

  # User exists in sudoers but requires password
  # Optional: check if user can run sudo at all
  if sudo -n -l >/dev/null 2>&1; then
    return 0  # true, user can sudo (but password required)
  fi

  # No sudo access at all
  return 1
}

has_apt() {
  command -v apt >/dev/null 2>&1
}

detect_linux_package_manager() {
  if command -v apt >/dev/null 2>&1; then
    printf '%s\n' "apt"
  else
    return 1
  fi
}

update_linux_packages() {
  manager=$1

  case "$manager" in
    apt)
      sudo apt update || printf '%s\n' "❗ Failed to update package lists."
      sudo apt upgrade -y || printf '%s\n' "❗ Failed to upgrade packages."
      ;;
  esac
}

install_linux_package() {
  manager=$1
  pkg=$2

  case "$manager" in
    apt) sudo apt install -y "$pkg" ;;
    *) return 1 ;;
  esac
}

cleanup_linux_packages() {
  manager=$1

  case "$manager" in
    apt)
      sudo apt autoremove -y || printf '%s\n' "❗ Failed to autoremove packages during cleanup"
      sudo apt clean || printf '%s\n' "❗ Failed to clean apt cache"
      ;;
  esac
}

# Function to install a .deb package
install_deb() {
  app="$1"
  url="$2"

  if ! has_apt; then
    printf '%s\n' "⚠️ .deb installs are only supported on apt-based Linux systems."
    return 1
  fi

  # Check for sudo first
  if ! has_sudo; then
    printf '%s\n' "❗ This function requires sudo privileges. Skipping..."
    return 1
  fi

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


install_code() {
  if ! has_apt; then
    printf '%s\n' "⚠️ VS Code repo setup is currently only supported on apt-based Linux systems."
    return 1
  fi

  # Check for sudo first
  if ! has_sudo; then
    printf '%s\n' "❗ This function requires sudo privileges. Skipping..."
    return 1
  fi

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


# Function to install GUI applications
install_gui() {

  # Check for sudo first
  if ! has_sudo; then
    printf '%s\n' "❗ This function requires sudo privileges. Skipping..."
    return 1
  fi

  # List of GUI apps in "name|method|url" format
  if ! has_apt; then
    printf '%s\n' "⚠️ GUI app installation is currently only supported on apt-based Linux systems."
    return 1
  fi

  gui_file=$HOME/.dotfiles/bootstrap/gui-apps.txt


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

# Function to install CLI tools and update the system
install_cli() {
  # Check for sudo first
  if ! has_sudo; then
    printf '%s\n' "❗ This function requires sudo privileges. Skipping..."
    return 1
  fi

  manager=$(detect_linux_package_manager) || {
    printf '%s\n' "⚠️ No supported Linux package manager found."
    return 1
  }

  if ! type print_linux_package_list >/dev/null 2>&1; then
    printf '%s\n' "⚠️ Linux package definitions are unavailable."
    return 1
  fi

  printf '%s\n' "🔄 Updating system packages with $manager..."
  update_linux_packages "$manager"

  printf '%s\n' "🔨 Installing CLI tools for $manager..."
  print_linux_package_list "$manager" | while IFS= read -r pkg; do
    case $pkg in
      ''|\#*) continue ;;
    esac

    if ! install_linux_package "$manager" "$pkg"; then
      printf '%s\n' "❗ Failed to install $pkg with $manager; continuing..."
    fi
  done

  printf '%s\n' "⚙️ Running cleanup steps..."
  cleanup_linux_packages "$manager"
}


install_mac_gui() {
  printf '%s\n' "☕️ Installing Homebrew dependencies... 🏡 Setting up GUI apps..."
  brew bundle install --file="$HOME/.dotfiles/bootstrap/Brewfile"
}


install_mac_cli() {
  # to install only CLI tools (strip cask lines)
  printf '%s\n' "☕️ Installing CLI tools and libraries... 📝 Skipping GUI apps..."
  grep "^brew " "$HOME/.dotfiles/bootstrap/Brewfile" > "$HOME/.dotfiles/bootstrap/Brewfile.cli"
  brew bundle install --file="$HOME/.dotfiles/bootstrap/Brewfile.cli"
  rm -f "$HOME/.dotfiles/bootstrap/Brewfile.cli"
}

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
      printf '%s\n' "❗ Unsupported OS: $(uname -s). Please check if you are running this on a supported OS (Linux or macOS)." >&2
      exit 1
      ;;
  esac
}

main "$@"

# Optional installs
# # Ask the user if they want to install Re-volt
# prompt_user "🏎️ Do you want to install Re-Volt?" '. $HOME/.dotfiles/re-volt/install.zsh' ''
