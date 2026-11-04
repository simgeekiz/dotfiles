#!/usr/bin/env bats
# Unit tests for bootstrap/install.sh
#
# Run with:
#   bats tests/bootstrap/install.bats
#
# install.sh sources "$HOME/.dotfiles/bootstrap/helpers.sh" using a hardcoded
# $HOME-based path (not a path relative to itself). Only helpers.sh is
# symlinked into a sandboxed $HOME/.dotfiles/bootstrap/ to satisfy that;
# everything else under $HOME/.dotfiles (gui-apps.txt, Brewfile, ...) is left
# for each test to create itself, so no test is affected by the real repo's files.

setup() {
  SCRIPT_DIR="$(CDPATH= cd -- "$(dirname "$BATS_TEST_FILENAME")/../.." && pwd)"
  SCRIPT="$SCRIPT_DIR/bootstrap/install.sh"

  TEST_HOME="$(mktemp -d)"
  MOCK_BIN="$(mktemp -d)"
  mkdir -p "$TEST_HOME/.dotfiles/bootstrap"
  ln -s "$SCRIPT_DIR/bootstrap/helpers.sh" "$TEST_HOME/.dotfiles/bootstrap/helpers.sh"
  export HOME="$TEST_HOME"
  export PATH="$MOCK_BIN:$PATH"

  source "$SCRIPT"
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

# --- has_apt / detect_linux_package_manager ---

@test "has_apt succeeds when apt is on PATH" {
  make_mock apt 'exit 0'
  run has_apt
  [ "$status" -eq 0 ]
}

@test "detect_linux_package_manager reports apt when available" {
  make_mock apt 'exit 0'
  run detect_linux_package_manager
  [ "$status" -eq 0 ]
  [ "$output" = "apt" ]
}

@test "detect_linux_package_manager fails when no supported manager is found" {
  old_path="$PATH"
  PATH="$MOCK_BIN"
  run detect_linux_package_manager
  PATH="$old_path"
  [ "$status" -eq 1 ]
}

# --- update_linux_packages / install_linux_package / cleanup_linux_packages ---

@test "update_linux_packages runs apt update and upgrade for apt" {
  make_mock sudo 'echo "sudo $*"'
  run update_linux_packages apt
  [[ "$output" == *"sudo apt update"* ]]
  [[ "$output" == *"sudo apt upgrade -y"* ]]
}

@test "install_linux_package installs a package via apt" {
  make_mock sudo 'echo "sudo $*"'
  run install_linux_package apt curl
  [[ "$output" == *"sudo apt install -y curl"* ]]
}

@test "install_linux_package fails for an unsupported manager" {
  run install_linux_package yum curl
  [ "$status" -eq 1 ]
}

@test "cleanup_linux_packages runs autoremove and clean for apt" {
  make_mock sudo 'echo "sudo $*"'
  run cleanup_linux_packages apt
  [[ "$output" == *"sudo apt autoremove -y"* ]]
  [[ "$output" == *"sudo apt clean"* ]]
}

# --- install_deb ---

@test "install_deb requires an apt-based system" {
  old_path="$PATH"
  PATH="$MOCK_BIN"
  run install_deb myapp "https://example.com/myapp.deb"
  PATH="$old_path"
  [ "$status" -eq 1 ]
  [[ "$output" == *"only supported on apt-based"* ]]
}

@test "install_deb requires sudo" {
  make_mock apt 'exit 0'
  make_mock sudo 'exit 1'
  run install_deb myapp "https://example.com/myapp.deb"
  [ "$status" -eq 1 ]
  [[ "$output" == *"requires sudo"* ]]
}

@test "install_deb downloads and installs the package on success" {
  make_mock apt 'exit 0'
  make_mock sudo 'echo "sudo $*"; exit 0'
  make_mock wget 'echo "fake deb contents" > "$3"; exit 0'

  run install_deb myapp "https://example.com/myapp.deb"

  [ "$status" -eq 0 ]
  [[ "$output" == *"myapp installed successfully"* ]]
}

@test "install_deb reports failure when the download fails" {
  make_mock apt 'exit 0'
  make_mock sudo 'exit 0'
  make_mock wget 'exit 1'

  run install_deb myapp "https://example.com/myapp.deb"

  [ "$status" -eq 1 ]
  [[ "$output" == *"Failed to download myapp"* ]]
}

# --- install_code (guard checks only; the full repo-setup flow has too
# many external dependencies — wget/gpg/apt/sudo/code — for a unit test) ---

@test "install_code requires an apt-based system" {
  old_path="$PATH"
  PATH="$MOCK_BIN"
  run install_code
  PATH="$old_path"
  [ "$status" -eq 1 ]
  [[ "$output" == *"only supported on apt-based"* ]]
}

@test "install_code requires sudo" {
  make_mock apt 'exit 0'
  make_mock sudo 'exit 1'
  run install_code
  [ "$status" -eq 1 ]
  [[ "$output" == *"requires sudo"* ]]
}

# --- install_cli ---

@test "install_cli requires sudo" {
  make_mock sudo 'exit 1'
  run install_cli
  [ "$status" -eq 1 ]
  [[ "$output" == *"requires sudo"* ]]
}

@test "install_cli reports when no package manager is found" {
  make_mock sudo 'exit 0'
  old_path="$PATH"
  PATH="$MOCK_BIN"
  run install_cli
  PATH="$old_path"
  [ "$status" -eq 1 ]
  [[ "$output" == *"No supported Linux package manager"* ]]
}

@test "install_cli updates and cleans up packages via apt" {
  make_mock sudo 'echo "sudo $*" >> "'"$TEST_HOME"'/sudo.log"; exit 0'
  make_mock apt 'exit 0'

  run install_cli

  [ "$status" -eq 0 ]
  grep -q "sudo apt update" "$TEST_HOME/sudo.log"
  grep -q "sudo apt autoremove" "$TEST_HOME/sudo.log"
}

@test "COMMON_PACKAGES lists the expected core tools" {
  [[ "$COMMON_PACKAGES" == *"git"* ]]
  [[ "$COMMON_PACKAGES" == *"python3"* ]]
  [[ "$COMMON_PACKAGES" == *"build-essential"* ]]
}

@test "install_cli installs every package in COMMON_PACKAGES via apt" {
  make_mock sudo 'echo "sudo $*" >> "'"$TEST_HOME"'/sudo.log"; exit 0'
  make_mock apt 'exit 0'

  run install_cli

  [ "$status" -eq 0 ]
  grep -q "sudo apt install -y git" "$TEST_HOME/sudo.log"
  grep -q "sudo apt install -y build-essential" "$TEST_HOME/sudo.log"
}

# --- install_gui ---

@test "install_gui requires sudo" {
  make_mock sudo 'exit 1'
  run install_gui
  [ "$status" -eq 1 ]
  [[ "$output" == *"requires sudo"* ]]
}

@test "install_gui requires an apt-based system" {
  make_mock sudo 'exit 0'
  old_path="$PATH"
  PATH="$MOCK_BIN"
  run install_gui
  PATH="$old_path"
  [ "$status" -eq 1 ]
  [[ "$output" == *"only supported on apt-based"* ]]
}

@test "install_gui reports a missing app list file" {
  make_mock sudo 'exit 0'
  make_mock apt 'exit 0'

  run install_gui

  [ "$status" -eq 1 ]
  [[ "$output" == *"GUI app list not found"* ]]
}

@test "install_gui skips an app that is already installed" {
  make_mock sudo 'exit 0'
  make_mock apt 'exit 0'
  make_mock google-chrome 'exit 0'
  echo "google-chrome|deb|https://example.com/chrome.deb" > "$TEST_HOME/.dotfiles/bootstrap/gui-apps.txt"

  run install_gui

  [[ "$output" == *"google-chrome is already installed"* ]]
}

@test "install_gui installs a missing app via the deb method" {
  make_mock sudo 'exit 0'
  make_mock apt 'exit 0'
  make_mock wget 'echo "fake deb" > "$3"; exit 0'
  echo "newapp|deb|https://example.com/newapp.deb" > "$TEST_HOME/.dotfiles/bootstrap/gui-apps.txt"

  run install_gui

  [[ "$output" == *"Installing newapp"* ]]
  [[ "$output" == *"newapp installed successfully"* ]]
}

@test "install_gui warns about an unknown install method" {
  make_mock sudo 'exit 0'
  make_mock apt 'exit 0'
  echo "mysteryapp|carrier-pigeon|https://example.com/x" > "$TEST_HOME/.dotfiles/bootstrap/gui-apps.txt"

  run install_gui

  [[ "$output" == *"Unknown method 'carrier-pigeon'"* ]]
}

@test "install_gui skips comment and blank lines in the app list" {
  make_mock sudo 'exit 0'
  make_mock apt 'exit 0'
  make_mock google-chrome 'exit 0'
  printf '# a comment\n\ngoogle-chrome|deb|https://example.com/chrome.deb\n' > "$TEST_HOME/.dotfiles/bootstrap/gui-apps.txt"

  run install_gui

  [ "$status" -eq 0 ]
  [[ "$output" == *"google-chrome is already installed"* ]]
}

# --- install_mac_cli / install_mac_gui ---

@test "install_mac_cli runs brew bundle with a CLI-only Brewfile" {
  make_mock brew 'echo "brew $*"; cat > /dev/null'
  printf 'brew "wget"\ncask "chrome"\nbrew "git"\n' > "$TEST_HOME/.dotfiles/bootstrap/Brewfile"

  run install_mac_cli

  [[ "$output" == *"brew bundle install --file=$TEST_HOME/.dotfiles/bootstrap/Brewfile.cli"* ]]
  [ ! -f "$TEST_HOME/.dotfiles/bootstrap/Brewfile.cli" ]
}

@test "install_mac_gui runs brew bundle with the full Brewfile" {
  make_mock brew 'echo "brew $*"'
  touch "$TEST_HOME/.dotfiles/bootstrap/Brewfile"

  run install_mac_gui

  [[ "$output" == *"brew bundle install --file=$TEST_HOME/.dotfiles/bootstrap/Brewfile"* ]]
}
