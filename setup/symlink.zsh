# !/bin/zsh

#### Creating Symlinks / Bootsrapping
echo "🐿️  Setting up Symlinks..."

# Git configurations
# .gitconfig
symlink $HOME/.dotfiles/git/.gitconfig $HOME/.gitconfig

git_name=$(git config --global --get user.name || true)
git_email=$(git config --global --get user.email || true)

if [[ -n "$git_name" && -n "$git_email" ]]; then
  echo "🔖 Git name and email are already set."
else
  source $HOME/.dotfiles/git/git_setup.zsh
fi

# # Guake settings
# if command -v guake >/dev/null 2>&1; then
#   mkdir -p "$(dirname $HOME/.config/guake/guake.conf)"
# symlink $HOME/.dotfiles/guake/guake.conf $HOME/.config/guake/guake.conf

# List of config files to check
files=(.zshrc .zsh_aliases .zprofile)

for file in $files; do
  backup_file "$HOME/$file" # Backup existing file if it exists and is not a symlink
  fullpath="$HOME/$file"
  symlink $HOME/.dotfiles/zsh/$file $fullpath
done

# POWERLEVEL10K
repo_dir="$HOME/powerlevel10k"
if [[ -d "$repo_dir/.git" && -d "$repo_dir" ]]; then
  # echo "🗞️  Powerlevel10k already cloned at $repo_dir"
  symlink $HOME/.dotfiles/p10k/.p10k.zsh $HOME/.p10k.zsh
fi


# VSCODE 
# bootstrap VS Code on macOS, Linux, WSL, or VS Code Server
#   • Symlinks settings.json and keybindings.json from ~/.dotfiles/vscode
#   • Installs extensions from ~/.dotfiles/vscode/extensions.txt
if command -v code >/dev/null 2>&1 || command -v code-insiders >/dev/null 2>&1; then
  # Symlink VS Code settings and keybindings to the present `settings.json` and `keybindings.json` files
  case "$(uname -s)" in
    Darwin*)
      CODE_PATH="$HOME/Library/Application Support/Code/User"
      ;;
    Linux*)
      CODE_PATH="$HOME/.config/Code/User"
      # If this folder doesn't exist, it's a WSL
      if [ ! -d "$CODE_PATH" ]; then
        CODE_PATH="$HOME/.vscode-server/data/Machine"
      fi
      ;;
    *)
      echo "Unsupported OS: $(uname)"
      echo "Please check if you are running this on a supported OS (Linux or macOS)."
      exit 1
      ;;
  esac

  mkdir -p "$CODE_PATH"
  symlink "$HOME/.dotfiles/vscode/settings.json" "$CODE_PATH/settings.json"
  symlink "$HOME/.dotfiles/vscode/keybindings.json" "$CODE_PATH/keybindings.json"

  CODE_CMD=$(command -v code || command -v code-insiders)
  EXT_FILE="$HOME/.dotfiles/vscode/vscode-extensions.txt"
  if [ -f "$EXT_FILE" ]; then
    echo "📦  Installing extensions from $EXT_FILE ..."
    grep -vE '^\s*$|^\s*#' "$EXT_FILE" | while read -r ext; do
      "$CODE_CMD" --install-extension "$ext" --force
    done
    echo "✅  Extensions installed."
  else
    echo "ℹ️  No extensions.txt found – skipping extension install."
  fi
fi

# Autostart
# sudo rm -rf $HOME/.config/autostart/
# sudo ln -sfn $HOME/.dotfiles/autostart/ $HOME/.config/autostart