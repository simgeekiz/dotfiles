#!/bin/zsh
# ---
# Author: Simge Ekiz
# ---
# Prints public SSH key, generates it if necessary adds it to the ssh-agent, Uploads it to the github.

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
  # Checks for GitHub CLI (gh) and authenticates if needed.
  # Uploads your SSH public key to your GitHub account with a descriptive title.
  # Confirm GitHub CLI is installed
  if ! command -v gh >/dev/null 2>&1; then
    case "$(uname)" in
      Darwin)
        echo "🍏 GitHub CLI not found. Installing with Homebrew..."
        brew install gh
        ;;
      Linux)
        echo "🐧 GitHub CLI not found. Installing with apt..."
        sudo apt update && sudo apt install -y gh
        ;;
      *)
        echo "❗ Unsupported OS for GitHub CLI installation. Please install it manually."
        exit 1
        ;;
    esac
  else
    echo "✅ GitHub CLI is already installed: $(gh --version)"
  fi 
}

# 🧠 Main logic
# If no key exists, generate a new one
if ! print_existing_ssh_key; then
  echo "🔐 No SSH key found. Generating a new one..."
  read -p "📧 Enter your email for the SSH key: " EMAIL

  ssh-keygen -t ed25519 -C "$EMAIL" 

  # Start the ssh-agent
  eval "$(ssh-agent -s)"
  # Add the new key to the agent
  ssh-add "$SSHDIR/id_ed25519"
 
  echo "✅ SSH key generated and added to the ssh-agent."
fi

# Detect the most recent or relevant SSH public key
PUBKEY=$(find "$HOME/.ssh" -type f -name "*.pub" | grep -E 'id_(ed25519|ecdsa|rsa)\.pub' | head -n 1)

check_GitHub_CLI   

# 🔼 Upload to GitHub
# Authenticate with GitHub CLI if needed
if ! gh auth status >/dev/null 2>&1; then
  echo "🔐 Authenticating GitHub CLI..."
  gh auth login
fi

# Check if SSH connection to GitHub works
if ssh -T git@github.com 2>&1 | grep -q "successfully authenticated"; then
  echo "✅ SSH authentication to GitHub succeeded."
  # Upload the public key to GitHub
  KEY_TITLE="$USER ($(hostname)) - $(date +%Y-%m-%d)"

  if gh ssh-key add "$PUBKEY" --title "$KEY_TITLE" 2>&1 | tee /tmp/gh_output.log | grep -q "key is already in use"; then
    echo "⚠️  SSH key is already in use on GitHub. Skipping upload."
  else
    echo "🔑 SSH key uploaded to GitHub with title: $KEY_TITLE"
  fi  
fi