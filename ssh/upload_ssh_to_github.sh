#!/usr/bin/env sh
# ~/.dotfiles/ssh/upload_ssh_to_github.sh
# Uploads the local SSH public key to GitHub.
# - Prints public SSH key, generates SSH key if necessary
# - Adds SSH key to the ssh-agent and uploads it to the github.
# Author: Simge Ekiz
# License: MIT

SSHDIR="$HOME/.ssh"

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
  if sudo -l >/dev/null 2>&1; then
    return 0  # true, user can sudo (but password required)
  fi

  # No sudo access at all
  return 1
}

install_package() {
  pkg=$1
  if command -v apt >/dev/null 2>&1; then
    sudo apt install -y "$pkg" || printf '%s\n' "Failed to install $pkg (apt)"
  else
    printf '%s\n' "❗ Unsupported OS: $(uname -s)" >&2
    exit 1
  fi
}

# 🔍 Function to check existing SSH public key
print_existing_ssh_key() {
  for key_type in rsa ecdsa ed25519; do
    if [ -f "$SSHDIR/id_${key_type}.pub" ]; then
      echo "✅ Found SSH key: $SSHDIR/id_${key_type}.pub"
      return 0
    fi
  done
  return 1
}

# 📤 Function to upload a public key to GitHub via `gh`, handling the
# "already in use" case separately from a genuine failure.
# Pulled out of main() so it can be unit-tested on its own.
upload_key_to_github() {
  pubkey=$1
  key_title=$2
  gh_output_log="${GH_OUTPUT_LOG:-/tmp/gh_output}"

  gh_output=$(gh ssh-key add "$pubkey" --title "$key_title" 2>&1)
  gh_exit=$?
  printf '%s\n' "$gh_output" > "$gh_output_log"

  if [ "$gh_exit" -eq 0 ]; then
    echo "🔑 SSH key uploaded to GitHub with title: $key_title"
  elif printf '%s\n' "$gh_output" | grep -q "key is already in use"; then
    echo "⚠️  SSH key is already in use on GitHub. Skipping upload."
  else
    echo "⚠️  Failed to upload SSH key: $gh_output"
  fi
}

# 🛠 Function to install/check GitHub CLI
check_GitHub_CLI() {
  # Checks for GitHub CLI (gh).
  case "$(uname -s)" in
    Darwin*)
      # Install GitHub CLI (if missing)
      command -v gh >/dev/null 2>&1 || {
        echo "🌸 Installing GitHub CLI"
        brew install gh
      }
      ;;
    Linux)
      # Install GitHub CLI (if missing)
      if ! command -v gh >/dev/null 2>&1; then
        if has_sudo; then
          install_package gh
        else
          echo "⚠️ No sudo access. Skipping GitHub CLI installation."
          echo "ℹ️ You can still use git + SSH without gh."
        fi
      fi
      ;;
    *)
      printf "❗ Unsupported OS for GitHub CLI installation. Please install it manually." >&2
      return 1
      ;;
  esac
}

main() {
  # If no key exists, generate a new one
  if ! print_existing_ssh_key; then # Check for existing SSH keys.
    echo "🔐 No SSH key found. Generating a new one..."
    printf "📧 Enter your email for the SSH key: "
    read EMAIL

    # Generating a new SSH key
    ssh-keygen -t ed25519 -C "$EMAIL"

    # Adding your SSH key to the ssh-agent
    eval "$(ssh-agent -s)" # Start the ssh-agent
    ssh-add "$SSHDIR/id_ed25519"

    echo "✅ SSH key generated and added to the ssh-agent."
  fi

  # Adding a new SSH key to your account
  # Detect the most recent or relevant SSH public key
  PUBKEY=$(find "$HOME/.ssh" -type f -name "*.pub" | grep -e 'id_(ed25519|ecdsa|rsa)\.pub' | head -n 1)

  check_GitHub_CLI

  # Check if SSH connection to GitHub works
  if ssh -T git@github.com 2>&1 | grep -q "successfully authenticated"; then
    echo "✅ SSH already configured with GitHub. Nothing to do."
    return
  fi

  if command -v gh >/dev/null 2>&1; then
    # Upload the public key to GitHub
    echo "🚀 GitHub CLI detected, uploading key..."

    KEY_TITLE="$USER ($(hostname)) - $(date +%Y-%m-%d)"

    # Authenticate with GitHub CLI & Upload to GitHub
    if ! gh auth status >/dev/null 2>&1; then
      echo "🔐 Authenticating GitHub CLI..."
      gh auth login
    fi

    # Single upload attempt; capture output once so we don't hit the API twice.
    upload_key_to_github "$PUBKEY" "$KEY_TITLE"
  else
    echo "ℹ️ gh not found, falling back to manual setup."
    echo "👉 Copy this key and add it to GitHub:"
    echo "--------------------------------------------------"
    cat "$PUBKEY"
    echo "--------------------------------------------------"
    echo ""
    echo "🔗 Go to: https://github.com/settings/keys"
    echo "➕ Click 'New SSH key' and paste the key above."
  fi
}

# Only run main() when this script is executed directly (e.g. `sh upload_ssh_to_github.sh`).
# When it is instead sourced (e.g. `. upload_ssh_to_github.sh` from a test file),
# $0 holds the parent shell's name instead of this script's filename, so
# main() is skipped and tests can call individual functions above without
# triggering the real interactive flow.
case "${0##*/}" in
  upload_ssh_to_github.sh) main "$@" ;;
esac
