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
  backup "$HOME/$file" # Backup existing file if it exists and is not a symlink
  fullpath="$HOME/$file"
  symlink $HOME/.dotfiles/zsh/$file $fullpath
done

# POWERLEVEL10K
repo_dir="$HOME/powerlevel10k"
if [[ -d "$repo_dir/.git" && -d "$repo_dir" ]]; then
  # echo "🗞️  Powerlevel10k already cloned at $repo_dir"
  symlink $HOME/.dotfiles/p10k/.p10k.zsh $HOME/.p10k.zsh
fi

# Symlink VS Code settings and keybindings to the present `settings.json` and `keybindings.json` files
if [[ $(uname) == "Linux" ]]; then
  CODE_PATH="$HOME/.config/Code/User"
  # If this folder doesn't exist, it's a WSL
  if [ ! -e $CODE_PATH ]; then
    CODE_PATH="$HOME/.vscode-server/data/Machine"
  fi
elif [[ $(uname) == "Darwin" ]]; then
   CODE_PATH="$HOME/Library/Application Support/Code/User"
fi

if [ -d "$CODE_PATH" ] && command -v code >/dev/null 2>&1; then
  symlink $HOME/.dotfiles/vscode/settings.json $CODE_PATH/settings.json
fi

# Autostart
# sudo rm -rf $HOME/.config/autostart/
# sudo ln -sfn $HOME/.dotfiles/autostart/ $HOME/.config/autostart