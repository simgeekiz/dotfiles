#!/usr/bin/env sh
# ~/.dotfiles/bootstrap/symlink.sh
# Creates symlinks from ~/.dotfiles into the home directory.
# Author: Simge Ekiz
# License: MIT

main() {
  # === Import functions ===
  if [ -r "$HOME/.dotfiles/bootstrap/helpers.sh" ]; then
    . "$HOME/.dotfiles/bootstrap/helpers.sh"
  else
    printf '%s\n' "⚠️ helpers.sh not found or unreadable"
    return 1
  fi

  # === Ensure required functions exist ===
  for func in symlink backup_file; do
    type "$func" >/dev/null 2>&1 || \
      printf '%s\n' "⚠️  Required function not found: $func"
  done

  # === Git configurations ===
  if [ -r "$HOME/.dotfiles/git/gitconfig" ]; then
    symlink "$HOME/.dotfiles/git/gitconfig" "$HOME/.gitconfig"
  else
    printf '%s\n' "⚠️  Git config missing."
  fi

  # === Guake settings ===
  # if command -v guake >/dev/null 2>&1; then
  # mkdir -p "$HOME/.config/guake/guake.conf"
  # symlink $HOME/.dotfiles/guake/guake.conf $HOME/.config/guake/guake.conf

  link_shell_files() {
    dir=$1
    shift

    for file in "$@"; do
      if [ -r "$HOME/.dotfiles/$dir/$file" ]; then
        backup_file "$HOME/.$file"
        symlink "$HOME/.dotfiles/$dir/$file" "$HOME/.$file"
      else
        printf '%s\n' "⚠️  Source file missing: $HOME/.dotfiles/$dir/$file"
      fi
    done
  }

  # Link whichever supported shells are available on this machine.
  if command -v bash >/dev/null 2>&1; then
    printf '%s\n' "🐚 Linking Bash configuration files"
    link_shell_files "bash" bashrc profile inputrc bash_logout
  fi

  if command -v zsh >/dev/null 2>&1; then
    printf '%s\n' "🐚 Linking Zsh configuration files"
    link_shell_files "zsh" zshrc zshenv
  fi


  # === POWERLEVEL10K ===
  ### repo_dir="$HOME/powerlevel10k"
  ### if [ -d "$repo_dir/.git" ] && [ -d "$repo_dir" ]; then
  ### # printf '%s\n' "🗞️  Powerlevel10k already cloned at $repo_dir"
  ###  symlink $HOME/.dotfiles/p10k/.p10k.zsh $HOME/.p10k.zsh
  ### fi

  # === VSCODE ===
  # bootstrap VS Code on macOS, Linux, WSL, or VS Code Server
  #   • Symlinks settings.json and keybindings.json from ~/.dotfiles/vscode
  #   • Installs extensions from ~/.dotfiles/vscode/extensions.txt
  CODE_BIN=$(command -v code 2>/dev/null || command -v code-insiders 2>/dev/null || true)
  if [ -n "$CODE_BIN" ]; then
    case "$(uname -s)" in
      Darwin*)
        CODE_PATH="$HOME/Library/Application Support/Code/User"
        ;;
      Linux*)
        if [ -d "$HOME/.config/Code/User" ]; then
          CODE_PATH="$HOME/.config/Code/User"
        elif [ -d "$HOME/.vscode-server/data/Machine" ]; then
          CODE_PATH="$HOME/.vscode-server/data/Machine"
        else
          # fallback (choose one or create new)
          CODE_PATH="$HOME/.config/Code/User"
        fi
        ;;
      *)
        printf '%s\n' "Unsupported OS: $(uname -s). Please check if you are running this on a supported OS (Linux or macOS)."
        exit 1
        ;;
    esac

    mkdir -p "$CODE_PATH"
    if [ -r "$HOME/.dotfiles/vscode/settings.json" ]; then
        symlink "$HOME/.dotfiles/vscode/settings.json" "$CODE_PATH/settings.json"
    else
        printf ' %s\n' "⚠️  VS Code settings.json missing."
    fi

    if [ -r "$HOME/.dotfiles/vscode/keybindings.json" ]; then
        symlink "$HOME/.dotfiles/vscode/keybindings.json" "$CODE_PATH/keybindings.json"
    else
        printf ' %s\n' "⚠️  VS Code keybindings.json missing."
    fi

  fi
}

main "$@"

# === # Autostart ===
# rm -rf $HOME/.config/autostart/
# ln -sfn $HOME/.dotfiles/autostart/ $HOME/.config/autostart
