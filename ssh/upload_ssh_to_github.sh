#!/usr/bin/env sh
# ~/.dotfiles/ssh/upload_ssh_to_github.sh
# Uploads the local SSH public key to GitHub.
# - Prints public SSH key, generates SSH key if necessary 
# - Adds SSH key to the ssh-agent and uploads it to the github.
# Author: Simge Ekiz
# License: MIT

SSHDIR="$HOME/.ssh"

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
      command -v gh >/dev/null 2>&1 || install_package gh
      ;;
    *)
      echo "❗ Unsupported OS for GitHub CLI installation. Please install it manually."
      exit 1
      ;;
  esac
}

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

# Authenticate with GitHub CLI & Upload to GitHub
if ! gh auth status >/dev/null 2>&1; then
  echo "🔐 Authenticating GitHub CLI..."
  gh auth login
fi

# Check if SSH connection to GitHub works
if ssh -T git@github.com 2>&1 | grep -q "successfully authenticated"; then
  echo "✅ SSH authentication to GitHub succeeded."
  # Upload the public key to GitHub
  KEY_TITLE="$USER ($(hostname)) - $(date +%Y-%m-%d)"

  if gh ssh-key add "$PUBKEY" --title "$KEY_TITLE" 2>&1 | tee /tmp/gh_output.printf '%s\n' | grep -q "key is already in use"; then
    echo "⚠️  SSH key is already in use on GitHub. Skipping upload."
  else
    echo "🔑 SSH key uploaded to GitHub with title: $KEY_TITLE"
  fi  
fi