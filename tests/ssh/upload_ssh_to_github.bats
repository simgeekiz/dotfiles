#!/usr/bin/env bats
# Unit tests for ssh/upload_ssh_to_github.sh
#
# Run with:
#   bats tests/ssh/upload_ssh_to_github.bats
#
# Each test runs in an isolated sandbox:
#   - $HOME points to a throwaway temp directory, never your real ~/.ssh
#   - $PATH is given a throwaway "mock bin" directory first, so fake
#     versions of external tools (gh, sudo, ...) are used instead of the
#     real ones.
# Author: Simge Ekiz
# License: MIT

setup() {
  SCRIPT_DIR="$(CDPATH= cd -- "$(dirname "$BATS_TEST_FILENAME")/../.." && pwd)"
  SCRIPT="$SCRIPT_DIR/ssh/upload_ssh_to_github.sh"

  TEST_HOME="$(mktemp -d)"
  MOCK_BIN="$(mktemp -d)"
  mkdir -p "$TEST_HOME/.ssh"

  export HOME="$TEST_HOME"
  export PATH="$MOCK_BIN:$PATH"
  export GH_OUTPUT_LOG="$TEST_HOME/gh_output"

  # Loads the script's functions without running main() (guarded in the
  # script itself), so tests can call has_sudo/print_existing_ssh_key/
  # upload_key_to_github directly.
  source "$SCRIPT"
}

teardown() {
  rm -rf "$TEST_HOME" "$MOCK_BIN"
}

# Writes an executable fake command into the mock bin directory.
# Usage: make_mock <command_name> '<shell script body>'
make_mock() {
  name=$1
  body=$2
  cat > "$MOCK_BIN/$name" <<EOF
#!/bin/sh
$body
EOF
  chmod +x "$MOCK_BIN/$name"
}

# --- print_existing_ssh_key ---

@test "print_existing_ssh_key finds an existing ed25519 key" {
  touch "$HOME/.ssh/id_ed25519.pub"

  run print_existing_ssh_key

  [ "$status" -eq 0 ]
  [[ "$output" == *"Found SSH key"* ]]
}

@test "print_existing_ssh_key fails when no key files exist" {
  run print_existing_ssh_key

  [ "$status" -eq 1 ]
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

# --- upload_key_to_github ---
# This is the function that replaced the buggy
#   tee /tmp/gh_output.printf '%s\n'
# line; these tests cover the 3 cases it has to distinguish.

@test "upload_key_to_github reports success when gh exits 0" {
  make_mock gh 'echo "uploaded ok"; exit 0'

  run upload_key_to_github "/fake/id_ed25519.pub" "test-title"

  [ "$status" -eq 0 ]
  [[ "$output" == *"uploaded to GitHub with title: test-title"* ]]
}

@test "upload_key_to_github reports already-in-use without failing the script" {
  make_mock gh 'echo "error: key is already in use"; exit 1'

  run upload_key_to_github "/fake/id_ed25519.pub" "test-title"

  [[ "$output" == *"already in use"* ]]
}

@test "upload_key_to_github surfaces other failures with gh's real message" {
  make_mock gh 'echo "some other failure"; exit 1'

  run upload_key_to_github "/fake/id_ed25519.pub" "test-title"

  [[ "$output" == *"Failed to upload SSH key"* ]]
  [[ "$output" == *"some other failure"* ]]
}

@test "upload_key_to_github writes gh's output to a single log file" {
  make_mock gh 'echo "uploaded ok"; exit 0'

  run upload_key_to_github "/fake/id_ed25519.pub" "test-title"

  [ -f "$GH_OUTPUT_LOG" ]
  grep -q "uploaded ok" "$GH_OUTPUT_LOG"
}

@test "upload_key_to_github never creates a stray '%s\\n' file (regression test)" {
  make_mock gh 'echo "uploaded ok"; exit 0'

  cd "$TEST_HOME" || exit 1
  run upload_key_to_github "/fake/id_ed25519.pub" "test-title"

  [ ! -e './%s\n' ]
}
