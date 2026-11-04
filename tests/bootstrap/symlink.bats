#!/usr/bin/env bats
# Unit tests for bootstrap/symlink.sh
#
# Run with:
#   bats tests/bootstrap/symlink.bats
#
# symlink.sh sources "$HOME/.dotfiles/bootstrap/helpers.sh" using a
# hardcoded $HOME-based path, and reads source files from
# $HOME/.dotfiles/{git,guake,bash,zsh,vscode}/... . Each test builds its
# own throwaway $HOME/.dotfiles tree with exactly the fixture files it
# needs, and real system tools (bash/zsh/code/guake) are hidden via a
# `command` override rather than relying on their real absence/presence.

setup() {
  SCRIPT_DIR="$(CDPATH= cd -- "$(dirname "$BATS_TEST_FILENAME")/../.." && pwd)"
  SCRIPT="$SCRIPT_DIR/bootstrap/symlink.sh"

  TEST_HOME="$(mktemp -d)"
  mkdir -p "$TEST_HOME/.dotfiles/bootstrap"
  ln -s "$SCRIPT_DIR/bootstrap/helpers.sh" "$TEST_HOME/.dotfiles/bootstrap/helpers.sh"
  export HOME="$TEST_HOME"

  source "$SCRIPT"

  # Hide bash/zsh/guake/code from this test's view by default; individual
  # tests re-enable exactly the ones they need to exercise.
  command() {
    if [ "$1" = "-v" ]; then
      case "$2" in
        bash|zsh|guake|code|code-insiders) return 1 ;;
      esac
    fi
    builtin command "$@"
  }
}

teardown() {
  rm -rf "$TEST_HOME"
}

# --- git config ---

@test "main symlinks ~/.gitconfig when git/gitconfig is present" {
  mkdir -p "$TEST_HOME/.dotfiles/git"
  touch "$TEST_HOME/.dotfiles/git/gitconfig"

  run main

  [ -L "$TEST_HOME/.gitconfig" ]
}

@test "main warns when git/gitconfig is missing" {
  run main

  [[ "$output" == *"Git config missing"* ]]
}

# --- guake ---

@test "main restores guake preferences when guake and its config exist" {
  mkdir -p "$TEST_HOME/.dotfiles/guake"
  touch "$TEST_HOME/.dotfiles/guake/guake.conf"

  run bash -c '
    source "'"$SCRIPT"'"
    guake() { echo "guake $*"; }
    main
  '

  [[ "$output" == *"guake --restore-preferences"* ]]
}

@test "main warns when guake config is missing" {
  run main

  [[ "$output" == *"Guake config missing"* ]]
}

# --- shell config files ---

@test "main links bash config files when bash is available" {
  mkdir -p "$TEST_HOME/.dotfiles/bash"
  for f in bashrc profile inputrc bash_logout; do
    echo "# $f" > "$TEST_HOME/.dotfiles/bash/$f"
  done

  run bash -c '
    source "'"$SCRIPT"'"
    command() {
      if [ "$1" = "-v" ]; then
        case "$2" in
          bash) return 0 ;;
          zsh|guake|code|code-insiders) return 1 ;;
        esac
      fi
      builtin command "$@"
    }
    main
  '

  [ -L "$TEST_HOME/.bashrc" ]
  [ -L "$TEST_HOME/.profile" ]
  [ -L "$TEST_HOME/.inputrc" ]
  [ -L "$TEST_HOME/.bash_logout" ]
}

@test "main reports a missing shell config file instead of failing" {
  mkdir -p "$TEST_HOME/.dotfiles/bash"
  touch "$TEST_HOME/.dotfiles/bash/bashrc"
  # profile, inputrc, bash_logout intentionally left missing

  run bash -c '
    source "'"$SCRIPT"'"
    command() {
      if [ "$1" = "-v" ]; then
        case "$2" in
          bash) return 0 ;;
          zsh|guake|code|code-insiders) return 1 ;;
        esac
      fi
      builtin command "$@"
    }
    main
  '

  [[ "$output" == *"Source file missing"* ]]
  [ -L "$TEST_HOME/.bashrc" ]
}

@test "main backs up an existing real file before symlinking over it" {
  mkdir -p "$TEST_HOME/.dotfiles/bash"
  echo "# managed" > "$TEST_HOME/.dotfiles/bash/bashrc"
  echo "old real bashrc" > "$TEST_HOME/.bashrc"

  run bash -c '
    source "'"$SCRIPT"'"
    command() {
      if [ "$1" = "-v" ]; then
        case "$2" in
          bash) return 0 ;;
          zsh|guake|code|code-insiders) return 1 ;;
        esac
      fi
      builtin command "$@"
    }
    main
  '

  [ -L "$TEST_HOME/.bashrc" ]
  backup=$(find "$TEST_HOME" -maxdepth 1 -name '.bashrc.backup.*')
  [ -n "$backup" ]
  [ "$(cat "$backup")" = "old real bashrc" ]
}

# --- VS Code ---

@test "main symlinks VS Code settings when code is available" {
  mkdir -p "$TEST_HOME/.dotfiles/vscode" "$TEST_HOME/.config/Code/User"
  echo "{}" > "$TEST_HOME/.dotfiles/vscode/settings.json"
  echo "[]" > "$TEST_HOME/.dotfiles/vscode/keybindings.json"

  run bash -c '
    source "'"$SCRIPT"'"
    command() {
      if [ "$1" = "-v" ]; then
        case "$2" in
          code) echo "/fake/bin/code"; return 0 ;;
          bash|zsh|guake|code-insiders) return 1 ;;
        esac
      fi
      builtin command "$@"
    }
    uname() { echo Linux; }
    main
  '

  [ -L "$TEST_HOME/.config/Code/User/settings.json" ]
  [ -L "$TEST_HOME/.config/Code/User/keybindings.json" ]
}

@test "main warns about missing VS Code files instead of failing" {
  mkdir -p "$TEST_HOME/.config/Code/User"

  run bash -c '
    source "'"$SCRIPT"'"
    command() {
      if [ "$1" = "-v" ]; then
        case "$2" in
          code) echo "/fake/bin/code"; return 0 ;;
          bash|zsh|guake|code-insiders) return 1 ;;
        esac
      fi
      builtin command "$@"
    }
    uname() { echo Linux; }
    main
  '

  [[ "$output" == *"VS Code settings.json missing"* ]]
  [[ "$output" == *"VS Code keybindings.json missing"* ]]
}

@test "main does nothing VS Code related when code is not installed" {
  run main

  [[ "$output" != *"VS Code"* ]]
}
