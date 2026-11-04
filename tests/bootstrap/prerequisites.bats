#!/usr/bin/env bats
# Unit tests for bootstrap/prerequisites.sh
#
# Run with:
#   bats tests/bootstrap/prerequisites.bats

setup() {
  SCRIPT_DIR="$(CDPATH= cd -- "$(dirname "$BATS_TEST_FILENAME")/../.." && pwd)"
  SCRIPT="$SCRIPT_DIR/bootstrap/prerequisites.sh"

  TEST_HOME="$(mktemp -d)"
  MOCK_BIN="$(mktemp -d)"
  export HOME="$TEST_HOME"
  export PATH="$MOCK_BIN:$PATH"

  source "$SCRIPT"

  # setup_zsh ends with a real `exec "$RESTART_SHELL" -l`, which would
  # replace this test's own shell process. Overriding exec with a no-op
  # function (bash allows shadowing builtins this way) keeps it observable
  # and harmless instead.
  exec() { echo "[mock exec] $*"; }
}

teardown() {
  rm -rf "$TEST_HOME" "$MOCK_BIN"
}

make_mock() {
  name=$1
  body=$2
  cat > "$MOCK_BIN/$name" <<EOF
#!/bin/sh
$body
EOF
  chmod +x "$MOCK_BIN/$name"
}

# --- has_sudo ---

@test "has_sudo succeeds when sudo works without a password" {
  make_mock sudo 'exit 0'
  run has_sudo
  [ "$status" -eq 0 ]
}

@test "has_sudo fails when sudo denies all access" {
  make_mock sudo 'exit 1'
  run has_sudo
  [ "$status" -eq 1 ]
}

# --- install_package ---

@test "install_package requires sudo" {
  make_mock sudo 'exit 1'
  run install_package git
  [ "$status" -eq 1 ]
  [[ "$output" == *"requires sudo"* ]]
}

@test "install_package installs via apt when sudo and apt are available" {
  make_mock sudo 'echo "sudo $*"'
  make_mock apt 'exit 0'

  run install_package git

  [[ "$output" == *"sudo apt install -y git"* ]]
}

# --- ask_for_zsh ---

@test "ask_for_zsh sets USE_ZSH=true without prompting when already on zsh" {
  CURRENT_SHELL=zsh
  USE_ZSH=false

  ask_for_zsh

  [ "$USE_ZSH" = true ]
}

@test "ask_for_zsh sets USE_ZSH=true when the user answers yes" {
  CURRENT_SHELL=bash
  USE_ZSH=false

  run bash -c 'source "'"$SCRIPT"'"; CURRENT_SHELL=bash; USE_ZSH=false; ask_for_zsh <<< "y"; echo "USE_ZSH=$USE_ZSH"'

  [[ "$output" == *"USE_ZSH=true"* ]]
}

@test "ask_for_zsh leaves USE_ZSH=false when the user answers no" {
  run bash -c 'source "'"$SCRIPT"'"; CURRENT_SHELL=bash; USE_ZSH=false; ask_for_zsh <<< "n"; echo "USE_ZSH=$USE_ZSH"'

  [[ "$output" == *"USE_ZSH=false"* ]]
}

# --- setup_macos ---

@test "setup_macos skips installation when the user declines" {
  make_mock uname 'echo Darwin'

  run bash -c 'source "'"$SCRIPT"'"; setup_macos <<< "n"'

  [[ "$output" == *"Skipping installation"* ]]
}

@test "setup_macos installs git/curl/zsh via brew when missing and accepted" {
  make_mock uname 'echo Darwin'
  make_mock brew 'echo "brew $*"'

  run bash -c '
    source "'"$SCRIPT"'"
    command() {
      if [ "$1" = "-v" ]; then
        case "$2" in
          git|curl|zsh) return 1 ;;
        esac
      fi
      builtin command "$@"
    }
    USE_ZSH=true
    setup_macos <<< "y"
  '

  [[ "$output" == *"brew install git"* ]]
  [[ "$output" == *"brew install curl"* ]]
  [[ "$output" == *"brew install zsh"* ]]
}

# --- setup_linux ---

@test "setup_linux requires sudo" {
  make_mock uname 'echo Linux'
  make_mock sudo 'exit 1'

  run setup_linux

  [ "$status" -eq 1 ]
  [[ "$output" == *"requires sudo"* ]]
}

@test "setup_linux skips installation when the user declines" {
  make_mock uname 'echo Linux'
  make_mock sudo 'exit 0'

  run bash -c 'source "'"$SCRIPT"'"; setup_linux <<< "n"'

  [[ "$output" == *"Skipping installation"* ]]
}

@test "setup_linux installs git/curl/zsh via install_package when accepted" {
  make_mock uname 'echo Linux'
  make_mock sudo 'echo "sudo $*" >> "'"$TEST_HOME"'/sudo.log"'
  make_mock apt 'exit 0'

  run bash -c '
    source "'"$SCRIPT"'"
    command() {
      if [ "$1" = "-v" ]; then
        case "$2" in
          git|curl|zsh) return 1 ;;
        esac
      fi
      builtin command "$@"
    }
    USE_ZSH=true
    setup_linux <<< "y"
  '

  grep -q "sudo apt install -y git" "$TEST_HOME/sudo.log"
  grep -q "sudo apt install -y curl" "$TEST_HOME/sudo.log"
  grep -q "sudo apt install -y zsh" "$TEST_HOME/sudo.log"
}

# --- setup_ssh ---

@test "setup_ssh downloads and runs the upload script on success" {
  make_mock curl 'echo "echo ran-the-downloaded-script" > upload_ssh_to_github.sh; exit 0'

  run bash -c 'cd "'"$TEST_HOME"'" && source "'"$SCRIPT"'" && setup_ssh'

  [[ "$output" == *"ran-the-downloaded-script"* ]]
}

@test "setup_ssh warns when the download fails" {
  make_mock curl 'exit 1'

  run bash -c 'cd "'"$TEST_HOME"'" && source "'"$SCRIPT"'" && setup_ssh'

  [[ "$output" == *"Failed to download SSH script"* ]]
}

# --- clone_dotfiles ---

@test "clone_dotfiles pulls when ~/.dotfiles already exists as a git repo" {
  mkdir -p "$TEST_HOME/.dotfiles/.git"
  make_mock git 'echo "git $*"'

  run clone_dotfiles

  [[ "$output" == *"Updating dotfiles"* ]]
  [[ "$output" == *"git pull"* ]]
}

@test "clone_dotfiles clones via SSH when ~/.dotfiles does not exist" {
  make_mock git 'if [ "$1" = "clone" ]; then echo "git $*"; exit 0; fi'

  run clone_dotfiles

  [[ "$output" == *"Cloned via SSH"* ]]
}

@test "clone_dotfiles falls back to HTTPS when the SSH clone fails" {
  make_mock git '
    if [ "$1" = "clone" ]; then
      case "$2" in
        git@github.com:*) exit 1 ;;
        *) echo "git $*"; exit 0 ;;
      esac
    fi
  '

  run clone_dotfiles

  [[ "$output" == *"Falling back to HTTPS"* ]]
}

# --- setup_zsh ---

@test "setup_zsh restarts the current shell without switching when USE_ZSH=false" {
  USE_ZSH=false
  SHELL=/bin/bash

  run setup_zsh

  [[ "$output" == *"[mock exec] /bin/bash -l"* ]]
}

@test "setup_zsh requires sudo when switching to zsh" {
  USE_ZSH=true
  make_mock sudo 'exit 1'

  run setup_zsh

  [ "$status" -eq 1 ]
  [[ "$output" == *"requires sudo"* ]]
}

@test "setup_zsh adds zsh to /etc/shells and calls chsh when switching" {
  make_mock zsh 'exit 0'
  make_mock sudo 'echo "sudo $*"'
  make_mock chsh 'echo "chsh $*"'
  make_mock tee 'cat >> /dev/null; echo added-to-shells'

  run bash -c '
    source "'"$SCRIPT"'"
    exec() { echo "[mock exec] $*"; }
    USE_ZSH=true
    CURRENT_SHELL=bash
    setup_zsh
  '

  [[ "$output" == *"chsh"* ]]
}
