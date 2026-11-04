#!/usr/bin/env bats
# Unit tests for bin/remove
#
# Run with:
#   bats tests/bin/remove.bats
#
# run_rm shells out to the real /bin/rm; all tests operate inside a
# throwaway sandbox directory so nothing outside it is ever deleted.

setup() {
  SCRIPT_DIR="$(CDPATH= cd -- "$(dirname "$BATS_TEST_FILENAME")/../.." && pwd)"
  SCRIPT="$SCRIPT_DIR/bin/remove"

  TEST_HOME="$(mktemp -d)"
  cd "$TEST_HOME" || exit 1

  source "$SCRIPT"
}

teardown() {
  cd /
  rm -rf "$TEST_HOME"
}

# --- parse_args ---

@test "parse_args requires at least one argument" {
  run parse_args
  [ "$status" -eq 1 ]
  [[ "$output" == *"No arguments provided"* ]]
}

@test "parse_args --help exits 0" {
  run parse_args --help
  [ "$status" -eq 0 ]
  [[ "$output" == *"Usage:"* ]]
}

@test "parse_args collects files and detects a directory" {
  touch file1.txt
  mkdir somedir

  parse_args file1.txt somedir

  [ "${files[0]}" = "file1.txt" ]
  [ "${files[1]}" = "somedir" ]
  [ "$has_dir" -eq 1 ]
}

@test "parse_args rejects when only flags are given and no files" {
  run parse_args --dry-run
  [ "$status" -eq 1 ]
  [[ "$output" == *"No valid files or directories"* ]]
}

@test "parse_args passes through dash-prefixed flags as extra_args" {
  touch file1.txt
  parse_args -r file1.txt
  [ "${extra_args[0]}" = "-r" ]
  [ "${files[0]}" = "file1.txt" ]
}

@test "parse_args sets DRY_RUN and VERBOSE flags" {
  touch file1.txt
  parse_args --dry-run --verbose file1.txt
  [ "$DRY_RUN" = true ]
  [ "$VERBOSE" = true ]
}

# --- confirm ---

@test "confirm returns success immediately in dry-run mode" {
  DRY_RUN=true
  run confirm
  [ "$status" -eq 0 ]
}

@test "confirm returns success when the user answers yes" {
  DRY_RUN=false
  files=(file1.txt)
  has_dir=0

  run bash -c 'source "'"$SCRIPT"'"; DRY_RUN=false; files=(file1.txt); has_dir=0; confirm <<< "y"'

  [ "$status" -eq 0 ]
}

@test "confirm returns failure when the user answers no" {
  run bash -c 'source "'"$SCRIPT"'"; DRY_RUN=false; files=(file1.txt); has_dir=0; confirm <<< "n"'

  [ "$status" -eq 1 ]
}

# --- run_rm ---

@test "run_rm shows what would be deleted in dry-run mode without deleting" {
  touch file1.txt
  DRY_RUN=true
  files=(file1.txt)
  extra_args=()

  run run_rm

  [[ "$output" == *"Would delete"* ]]
  [ -f file1.txt ]
}

@test "run_rm actually deletes the file when not in dry-run mode" {
  touch file1.txt
  DRY_RUN=false
  VERBOSE=false
  files=(file1.txt)
  extra_args=()

  run run_rm

  [ ! -f file1.txt ]
}

# --- main (end-to-end) ---

@test "main deletes a file after the user confirms" {
  touch file1.txt

  run bash -c 'source "'"$SCRIPT"'"; main file1.txt <<< "y"'

  [ ! -f file1.txt ]
}

@test "main aborts without deleting when the user declines" {
  touch file1.txt

  run bash -c 'source "'"$SCRIPT"'"; main file1.txt <<< "n"'

  [ -f file1.txt ]
  [[ "$output" == *"Aborted"* ]]
}
