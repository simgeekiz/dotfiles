#!/usr/bin/env bats
# Unit tests for bootstrap/helpers.sh
#
# Run with:
#   bats tests/bootstrap/helpers.bats

setup() {
  SCRIPT_DIR="$(CDPATH= cd -- "$(dirname "$BATS_TEST_FILENAME")/../.." && pwd)"
  SCRIPT="$SCRIPT_DIR/bootstrap/helpers.sh"

  TEST_HOME="$(mktemp -d)"
  export HOME="$TEST_HOME"

  source "$SCRIPT"
}

teardown() {
  rm -rf "$TEST_HOME"
}

# --- symlink ---

@test "symlink fails without source or destination" {
  run symlink "" "$HOME/dest"
  [ "$status" -eq 1 ]
}

@test "symlink creates a new link when destination does not exist" {
  touch "$HOME/source"

  run symlink "$HOME/source" "$HOME/dest"

  [ "$status" -eq 0 ]
  [ -L "$HOME/dest" ]
  [ "$(readlink "$HOME/dest")" = "$HOME/source" ]
}

@test "symlink is a no-op (but still succeeds) when already correct" {
  touch "$HOME/source"
  ln -s "$HOME/source" "$HOME/dest"

  run symlink "$HOME/source" "$HOME/dest"

  [ "$status" -eq 0 ]
  [[ "$output" == *"already points to the correct target"* ]]
}

@test "symlink updates a destination that points elsewhere" {
  touch "$HOME/source" "$HOME/other"
  ln -s "$HOME/other" "$HOME/dest"

  run symlink "$HOME/source" "$HOME/dest"

  [ "$status" -eq 0 ]
  [ "$(readlink "$HOME/dest")" = "$HOME/source" ]
}

# --- backup_file ---

@test "backup_file does nothing when source does not exist" {
  run backup_file "$HOME/does-not-exist"

  [ "$status" -eq 0 ]
  [ "$(find "$HOME" -maxdepth 1 -name '*.backup.*' | wc -l)" -eq 0 ]
}

@test "backup_file moves an existing plain file aside" {
  echo "content" > "$HOME/myfile"

  run backup_file "$HOME/myfile"

  [ "$status" -eq 0 ]
  [ ! -e "$HOME/myfile" ]
  backup=$(find "$HOME" -maxdepth 1 -name 'myfile.backup.*')
  [ -n "$backup" ]
  [ "$(cat "$backup")" = "content" ]
}

@test "backup_file skips files that are already symlinks" {
  touch "$HOME/real"
  ln -s "$HOME/real" "$HOME/link"

  run backup_file "$HOME/link"

  [ "$status" -eq 0 ]
  [ -L "$HOME/link" ]
  [ "$(find "$HOME" -maxdepth 1 -name 'link.backup.*' | wc -l)" -eq 0 ]
}

# --- prompt_user ---

@test "prompt_user runs yes_cmd when user answers y" {
  run bash -c 'source "'"$SCRIPT"'"; echo y | prompt_user "Continue?" "echo YES_RAN" "echo NO_RAN"'

  [[ "$output" == *"YES_RAN"* ]]
  [[ "$output" != *"NO_RAN"* ]]
}

@test "prompt_user runs yes_cmd by default on empty input" {
  run bash -c 'source "'"$SCRIPT"'"; echo "" | prompt_user "Continue?" "echo YES_RAN" "echo NO_RAN"'

  [[ "$output" == *"YES_RAN"* ]]
}

@test "prompt_user runs no_cmd when user answers n" {
  run bash -c 'source "'"$SCRIPT"'"; echo n | prompt_user "Continue?" "echo YES_RAN" "echo NO_RAN"'

  [[ "$output" == *"NO_RAN"* ]]
  [[ "$output" != *"YES_RAN"* ]]
}

@test "prompt_user re-prompts on an invalid answer before accepting yes" {
  run bash -c 'source "'"$SCRIPT"'"; printf "maybe\ny\n" | prompt_user "Continue?" "echo YES_RAN" "echo NO_RAN"'

  [[ "$output" == *"Please answer yes"* ]]
  [[ "$output" == *"YES_RAN"* ]]
}
