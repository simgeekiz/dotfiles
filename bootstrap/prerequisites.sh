#!/usr/bin/env sh
# ~/.dotfiles/bootstrap/prerequisites.sh
# Checks and installs required system prerequisites.
# - It installs Zsh if it is not already installed ans sets as the default shell
# - It installs Homebrew on macOS if it is not already installed
# Author: Simge Ekiz
# License: MIT
# https://github.com/simgeekiz/dotfiles

warn() { printf '⚠️  %s\n' "$*" >&2; }

cd "$HOME" 

# ---Globals---
USE_ZSH=false
CURRENT_SHELL=${SHELL##*/}
CURRENT_SHELL=${CURRENT_SHELL:-sh}


install_package() {
  pkg=$1
  if [ -f /etc/debian_version ]; then
    sudo apt install -y "$pkg" || warn "Failed to install $pkg (apt)"
  elif [ -f /etc/redhat-release ]; then
    if command -v dnf >/dev/null 2>&1; then
      sudo dnf install -y "$pkg" || warn "Failed to install $pkg (dnf)"
    else
      sudo yum install -y "$pkg" || warn "Failed to install $pkg (yum)"
    fi
  elif [ -f /etc/arch-release ]; then
    sudo pacman -S --noconfirm "$pkg" || warn "Failed to install $pkg (pacman)"
  else
    printf '%s\n' "❗ Unsupported OS: $(uname -s)"
    exit 1
  fi
}

# --- Ask user if they want to switch shell ---
ask_for_zsh() {
  if [ "$CURRENT_SHELL" = "zsh" ]; then
    USE_ZSH=true
    return 0
  fi
  
  printf '%s' "🐚 Do you want to switch your default shell to Zsh? [y/N]: "
  IFS= read -r answer

  case $(printf '%s' "$answer" | tr 'A-Z' 'a-z') in
      y|yes) USE_ZSH=true ;;
  esac
}

# --- macOS setup ---
setup_macos() {
  printf '%s\n' "🍏 Platform detected as macOS. Installing accordingly."

    # Install Homebrew if missing
    if ! command -v brew >/dev/null 2>&1; then 
      printf '%s\n' "🫖 Installing Homebrew..."
      /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" || warn "Homebrew install failed"

      # Set up brew environment for current shell session
     [ -x /opt/homebrew/bin/brew ] && eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
    
    # Install Git (if missing)
    command -v git >/dev/null 2>&1 || brew install git || warn "git install failed"
    # Install curl (if missing)
    command -v curl >/dev/null 2>&1 || brew install curl || warn "curl install failed"

    # Install Zsh (if missing)
    if [ "$USE_ZSH" = true ]; then
      command -v zsh >/dev/null 2>&1 || brew install zsh || warn "zsh install failed"
    fi
}

# --- Linux setup ---
setup_linux() {
  printf '%s\n' "🌲 Platform detected as Linux. Installing accordingly."

  command -v sudo >/dev/null 2>&1 || {
    printf '%s\n' "❗ sudo is required"
    return 1
  }

  if [ -f /etc/debian_version ]; then
    sudo apt update || warn "apt update failed"
  fi

  command -v git >/dev/null 2>&1 || install_package git
  command -v curl >/dev/null 2>&1 || install_package curl

  if [ "$USE_ZSH" = true ]; then
    command -v zsh >/dev/null 2>&1 || install_package zsh
  fi
}

# --- SSH setup ---
setup_ssh() {
  if curl -fsSL \
    https://raw.githubusercontent.com/simgeekiz/dotfiles/refs/heads/master/ssh/upload_ssh_to_github.sh \
    -o upload_ssh_to_github.sh
  then
    sh ./upload_ssh_to_github.sh || warn "SSH setup failed"
  else
    warn "Failed to download SSH script"
  fi

}

# --- Clone dotfiles ---
clone_dotfiles() {
  # Check if the .dotfiles directory exists
  if [ -d "$HOME/.dotfiles" ] && [ -d "$HOME/.dotfiles/.git" ]; then
    printf '%s\n' "🗞️ Updating dotfiles"
    (cd "$HOME/.dotfiles" && git pull) || warn "git pull failed"
    return 0
  fi
  # Clone the repository
  if git clone git@github.com:simgeekiz/dotfiles.git "$HOME/.dotfiles"; then
    printf '%s\n' "📦 Cloned via SSH"
  else
    printf '%s\n' "📦 Falling back to HTTPS"
    git clone https://github.com/simgeekiz/dotfiles.git "$HOME/.dotfiles" \
      || warn "HTTPS clone failed"
  fi
}

# --- Zsh setup ---
setup_zsh() {
  if [ "$USE_ZSH" = true ]; then
    ZSH_PATH=$(command -v zsh)
    # Decide which shell to use
    RESTART_SHELL="${SHELL:-/bin/sh}"
    
    # Add Zsh to /etc/shells if not present
    if [ -n "$ZSH_PATH" ]; then
      RESTART_SHELL="$ZSH_PATH"

      # Add Zsh to /etc/shells if not present
      if ! grep -Fxq "$ZSH_PATH" /etc/shells 2>/dev/null; then
        printf '%s\n' "📝 Adding Zsh to /etc/shells..."
        printf '%s\n' "$ZSH_PATH" | sudo tee -a /etc/shells >/dev/null \
          || warn "Failed to update /etc/shells"
      fi

      # Change default shell if needed
      if [ "$CURRENT_SHELL" != "zsh" ]; then
        # Change the default shell:
        printf '%s\n' "🐚 Setting zsh as default shell.."
        chsh -s "$ZSH_PATH" || warn "chsh failed"
      fi
    else
      warn "zsh not found, skipping shell switch"
    fi
  fi

  # Restart the terminal in case user forget to restart the terminal. or Warn user to restart terminal
  printf '%s\n' "🦆 Restarting Shell"
  exec "$RESTART_SHELL" -l || warn "⚠️ Please restart your terminal for the changes to take effect fully."
}


main() {
  ask_for_zsh

  # Get operating system
  case "$(uname -s)" in
    Darwin*) setup_macos;;
    Linux*) setup_linux;;
    *)
      printf '%s\n' "❗ Unsupported OS: $(uname -s)"
      exit 1
      ;;
  esac

  setup_ssh
  clone_dotfiles
  setup_zsh
}

main "$@"