#!/usr/bin/env bats
# Unit tests for bin/extract
#
# Run with:
#   bats tests/bin/extract.bats

setup() {
  SCRIPT_DIR="$(CDPATH= cd -- "$(dirname "$BATS_TEST_FILENAME")/../.." && pwd)"
  SCRIPT="$SCRIPT_DIR/bin/extract"

  TEST_HOME="$(mktemp -d)"
  cd "$TEST_HOME" || exit 1

  source "$SCRIPT"
}

teardown() {
  cd /
  rm -rf "$TEST_HOME"
}

# --- parse_args ---

@test "parse_args requires at least one file" {
  run parse_args
  [ "$status" -eq 1 ]
  [[ "$output" == *"No file specified"* ]]
}

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

@test "parse_args collects multiple file arguments" {
  parse_args a.zip b.tar.gz
  [ "${files[0]}" = "a.zip" ]
  [ "${files[1]}" = "b.tar.gz" ]
}

# --- extract_file ---

@test "extract_file reports a non-existent file" {
  run extract_file "does-not-exist.zip"
  [[ "$output" == *"is not a valid file"* ]]
}

@test "extract_file extracts a .zip archive" {
  echo "hello" > hello.txt
  zip -q archive.zip hello.txt
  rm hello.txt

  run extract_file archive.zip

  [ -f hello.txt ]
  [ "$(cat hello.txt)" = "hello" ]
}

@test "extract_file extracts a .tar.gz archive" {
  echo "hello" > hello.txt
  tar -czf archive.tar.gz hello.txt
  rm hello.txt

  run extract_file archive.tar.gz

  [ -f hello.txt ]
}

@test "extract_file reports an unsupported file type" {
  touch mystery.xyz

  run extract_file mystery.xyz

  [[ "$output" == *"cannot be extracted"* ]]
}
