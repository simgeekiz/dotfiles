#!/usr/bin/env bats
# Unit tests for bin/update
#
# Run with:
#   bats tests/bin/update.bats
#
# main() calls the real `clean` command (bin/clean) and real
# `sudo apt .../brew ...`; both are mocked in every test so nothing is
# ever actually updated, upgraded, or cleaned on the test machine.

setup() {
  SCRIPT_DIR="$(CDPATH= cd -- "$(dirname "$BATS_TEST_FILENAME")/../.." && pwd)"
  SCRIPT="$SCRIPT_DIR/bin/update"

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

@test "parse_args rejects an unknown flag" {
  run parse_args --bogus
  [ "$status" -eq 1 ]
  [[ "$output" == *"Unknown option"* ]]
}

@test "parse_args accepts no arguments" {
  run parse_args
  [ "$status" -eq 0 ]
}

# --- update_and_upgrade ---

@test "update_and_upgrade uses apt when available" {
  make_mock sudo 'echo "sudo $*"'
  make_mock apt 'exit 0'

  run update_and_upgrade

  [[ "$output" == *"sudo apt update"* ]]
  [[ "$output" == *"sudo apt full-upgrade -y"* ]]
}

@test "update_and_upgrade falls back to brew when apt is unavailable" {
  make_mock brew 'echo "brew $*"'

  run bash -c '
    source "'"$SCRIPT"'"
    command() {
      if [ "$1" = "-v" ] && [ "$2" = "apt" ]; then return 1; fi
      builtin command "$@"
    }
    update_and_upgrade
  '

  [[ "$output" == *"brew update"* ]]
  [[ "$output" == *"brew upgrade"* ]]
}

@test "update_and_upgrade reports when no package manager is found" {
  run bash -c '
    source "'"$SCRIPT"'"
    command() {
      if [ "$1" = "-v" ]; then
        case "$2" in apt|brew) return 1 ;; esac
      fi
      builtin command "$@"
    }
    update_and_upgrade
  '

  [[ "$output" == *"No supported package manager found"* ]]
}

# --- main ---

@test "main runs update_and_upgrade then clean --packages" {
  make_mock sudo 'echo "sudo $*"'
  make_mock apt 'exit 0'
  make_mock clean 'echo "clean $*"'

  run main

  [[ "$output" == *"sudo apt update"* ]]
  [[ "$output" == *"clean --packages"* ]]
}
