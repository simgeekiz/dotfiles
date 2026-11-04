#!/usr/bin/env bats
# Unit tests for bin/speedtest
#
# Run with:
#   bats tests/bin/speedtest.bats

setup() {
  SCRIPT_DIR="$(CDPATH= cd -- "$(dirname "$BATS_TEST_FILENAME")/../.." && pwd)"
  SCRIPT="$SCRIPT_DIR/bin/speedtest"

  MOCK_BIN="$(mktemp -d)"
  export PATH="$MOCK_BIN:$PATH"

  source "$SCRIPT"
}

teardown() {
  rm -rf "$MOCK_BIN"
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

# --- parse_args ---

@test "parse_args --help exits 0" {
  run parse_args --help
  [ "$status" -eq 0 ]
  [[ "$output" == *"Usage:"* ]]
}

@test "parse_args --install sets INSTALL=true" {
  INSTALL=false
  parse_args --install
  [ "$INSTALL" = true ]
}

@test "parse_args passes unrecognized args through to speedtest-cli" {
  INSTALL=false
  extra_args=()
  parse_args --simple
  [ "${extra_args[0]}" = "--simple" ]
}

# --- install_speedtest ---

@test "install_speedtest installs via apt on Linux" {
  make_mock sudo 'echo "sudo $*"'
  make_mock apt 'exit 0'

  run bash -c 'source "'"$SCRIPT"'"; uname() { echo Linux; }; install_speedtest'

  [[ "$output" == *"Installing speedtest-cli via apt"* ]]
  [[ "$output" == *"sudo apt install -y speedtest-cli"* ]]
}

@test "install_speedtest installs via brew on macOS" {
  make_mock brew 'echo "brew $*"'

  run bash -c 'source "'"$SCRIPT"'"; uname() { echo Darwin; }; install_speedtest'

  [[ "$output" == *"brew install speedtest-cli"* ]]
}

@test "install_speedtest reports an unsupported OS" {
  run bash -c 'source "'"$SCRIPT"'"; uname() { echo Plan9; }; install_speedtest'
  [ "$status" -eq 1 ]
  [[ "$output" == *"Unsupported OS"* ]]
}

# --- run_speedtest ---

@test "run_speedtest runs speedtest-cli directly when already installed" {
  make_mock speedtest-cli 'echo "speedtest-cli $*"'
  extra_args=(--simple)

  run run_speedtest

  [[ "$output" == *"speedtest-cli --simple"* ]]
}

@test "run_speedtest installs speedtest-cli first when missing" {
  make_mock sudo 'echo "sudo $*"'
  make_mock apt 'exit 0'

  run bash -c '
    source "'"$SCRIPT"'"
    uname() { echo Linux; }
    extra_args=()
    command() {
      if [ "$1" = "-v" ] && [ "$2" = "speedtest-cli" ]; then return 1; fi
      builtin command "$@"
    }
    speedtest-cli() { echo "speedtest-cli $*"; }
    run_speedtest
  '

  [[ "$output" == *"speedtest-cli not found"* ]]
  [[ "$output" == *"sudo apt install -y speedtest-cli"* ]]
  [[ "$output" == *"Running speedtest"* ]]
}
