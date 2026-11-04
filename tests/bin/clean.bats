#!/usr/bin/env bats
# Unit tests for bin/clean
#
# Run with:
#   bats tests/bin/clean.bats
#
# clean_trash/clean_package_cache call real `sudo rm -rf`/`sudo apt ...`;
# sudo is always mocked in every test here so nothing is ever actually
# deleted or modified on the test machine.

setup() {
  SCRIPT_DIR="$(CDPATH= cd -- "$(dirname "$BATS_TEST_FILENAME")/../.." && pwd)"
  SCRIPT="$SCRIPT_DIR/bin/clean"

  MOCK_BIN="$(mktemp -d)"
  export PATH="$MOCK_BIN:$PATH"
  make_mock() {
    name=$1
    body=$2
    cat > "$MOCK_BIN/$name" <<EOF
#!/bin/sh
$body
EOF
    chmod +x "$MOCK_BIN/$name"
  }
  make_mock sudo 'echo "sudo $*"'

  source "$SCRIPT"
}

teardown() {
  rm -rf "$MOCK_BIN"
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

@test "parse_args with no arguments cleans both trash and package cache" {
  run bash -c 'source "'"$SCRIPT"'"; parse_args'
  [[ "$output" == *"Cleaning system Trash"* ]]
  [[ "$output" == *"Detecting package manager"* ]]
}

@test "parse_args --trash only cleans the trash" {
  run bash -c 'source "'"$SCRIPT"'"; parse_args --trash'
  [[ "$output" == *"Cleaning system Trash"* ]]
  [[ "$output" != *"Detecting package manager"* ]]
}

@test "parse_args --packages only cleans the package cache" {
  run bash -c 'source "'"$SCRIPT"'"; parse_args --packages'
  [[ "$output" != *"Cleaning system Trash"* ]]
  [[ "$output" == *"Detecting package manager"* ]]
}

# --- clean_trash ---

@test "clean_trash uses sudo rm on Linux" {
  run bash -c 'source "'"$SCRIPT"'"; uname() { echo Linux; }; clean_trash'
  [[ "$output" == *"sudo rm -rf"* ]]
}

@test "clean_trash reports an unsupported OS" {
  run bash -c 'source "'"$SCRIPT"'"; uname() { echo Plan9; }; clean_trash'
  [ "$status" -eq 1 ]
  [[ "$output" == *"Unsupported OS"* ]]
}

# --- clean_package_cache ---

@test "clean_package_cache cleans via apt when available" {
  make_mock apt 'exit 0'

  run clean_package_cache

  [[ "$output" == *"Cleaning APT"* ]]
  [[ "$output" == *"sudo apt clean"* ]]
  [[ "$output" == *"sudo apt autoremove -y"* ]]
}

@test "clean_package_cache reports when no package manager is found" {
  run bash -c '
    source "'"$SCRIPT"'"
    command() {
      if [ "$1" = "-v" ]; then
        case "$2" in
          apt|brew) return 1 ;;
        esac
      fi
      builtin command "$@"
    }
    clean_package_cache
  '

  [[ "$output" == *"No supported package manager found"* ]]
}
