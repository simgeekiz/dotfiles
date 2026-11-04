#!/usr/bin/env bats
# Unit tests for bootstrap/setup.sh
#
# Run with:
#   bats tests/bootstrap/setup.bats
#
# setup.sh's main() sources helpers.sh, conditionally sources install.sh
# (via prompt_user), and unconditionally sources symlink.sh, all using
# hardcoded $HOME/.dotfiles/... paths. Each test builds a throwaway
# $HOME/.dotfiles containing exactly the pieces it needs.

setup() {
  SCRIPT_DIR="$(CDPATH= cd -- "$(dirname "$BATS_TEST_FILENAME")/../.." && pwd)"
  SCRIPT="$SCRIPT_DIR/bootstrap/setup.sh"

  TEST_HOME="$(mktemp -d)"
  mkdir -p "$TEST_HOME/.dotfiles/bootstrap"
  ln -s "$SCRIPT_DIR/bootstrap/helpers.sh" "$TEST_HOME/.dotfiles/bootstrap/helpers.sh"
  export HOME="$TEST_HOME"

  source "$SCRIPT"

  # main() ends with `exec "$SHELL" -l`, which would replace this test's
  # own shell process; override exec with a harmless, observable no-op.
  exec() { echo "[mock exec] $*"; }
}

teardown() {
  rm -rf "$TEST_HOME"
}

@test "main warns when helpers.sh is missing" {
  rm "$TEST_HOME/.dotfiles/bootstrap/helpers.sh"

  run main

  [ "$status" -eq 1 ]
  [[ "$output" == *"helpers.sh not found"* ]]
}

@test "main warns when install.sh is missing" {
  # No install.sh and no symlink.sh placed: both warnings should appear,
  # and main should still reach the final steps rather than aborting.
  run main

  [[ "$output" == *"install.sh not found or unreadable"* ]]
  [[ "$output" == *"symlink.sh not found or unreadable"* ]]
  [[ "$output" == *"All steps completed"* ]]
}

@test "main prompts to run install.sh when it is present" {
  cat > "$TEST_HOME/.dotfiles/bootstrap/install.sh" <<'EOF'
echo "INSTALL_SH_RAN"
EOF

  run bash -c 'source "'"$SCRIPT"'"; exec() { echo "[mock exec] $*"; }; main <<< "y"'

  [[ "$output" == *"INSTALL_SH_RAN"* ]]
}

@test "main skips install.sh when the user declines" {
  cat > "$TEST_HOME/.dotfiles/bootstrap/install.sh" <<'EOF'
echo "INSTALL_SH_RAN"
EOF

  run bash -c 'source "'"$SCRIPT"'"; exec() { echo "[mock exec] $*"; }; main <<< "n"'

  [[ "$output" != *"INSTALL_SH_RAN"* ]]
}

@test "main sources symlink.sh when present" {
  cat > "$TEST_HOME/.dotfiles/bootstrap/symlink.sh" <<'EOF'
echo "SYMLINK_SH_RAN"
EOF

  run main

  [[ "$output" == *"SYMLINK_SH_RAN"* ]]
}

@test "main restarts the shell at the end" {
  SHELL=/bin/bash

  run main

  [[ "$output" == *"[mock exec] /bin/bash -l"* ]]
}
