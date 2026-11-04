#!/usr/bin/env bats
# Unit tests for functions/misc.sh
#
# Run with:
#   bats tests/functions/misc.bats

setup() {
  SCRIPT_DIR="$(CDPATH= cd -- "$(dirname "$BATS_TEST_FILENAME")/../.." && pwd)"
  SCRIPT="$SCRIPT_DIR/functions/misc.sh"

  TEST_HOME="$(mktemp -d)"
  MOCK_BIN="$(mktemp -d)"
  export HOME="$TEST_HOME"
  export PATH="$MOCK_BIN:$PATH"

  cat > "$MOCK_BIN/notify-send" <<'EOF'
#!/bin/sh
echo "[mock notify-send] $*"
EOF
  chmod +x "$MOCK_BIN/notify-send"

  # alert()/brewu() are only defined if their required command exists at
  # source time, so the mock must be in place before sourcing.
  source "$SCRIPT"
}

teardown() {
  rm -rf "$TEST_HOME" "$MOCK_BIN"
}

# --- with_cat ---

@test "with_cat runs the wrapped command and returns its exit status" {
  SHOW_CAT=false
  run with_cat true
  [ "$status" -eq 0 ]
}

@test "with_cat prints the cat art only when SHOW_CAT=true" {
  SHOW_CAT=true
  run with_cat true
  [[ "$output" == *"/\\_/\\"* ]]
}

@test "with_cat does not print the cat art when SHOW_CAT=false" {
  SHOW_CAT=false
  run with_cat true
  [[ "$output" != *"/\\_/\\"* ]]
}

# --- mkd ---

@test "mkd creates a nested directory and cds into it" {
  run bash -c 'source "'"$SCRIPT"'"; mkd "'"$TEST_HOME"'/a/b/c" && pwd'

  [ "$status" -eq 0 ]
  [ "$output" = "$TEST_HOME/a/b/c" ]
  [ -d "$TEST_HOME/a/b/c" ]
}

# --- add_to_path ---

@test "add_to_path adds a new directory to PATH" {
  PATH="/usr/bin"
  add_to_path "/tmp/some-new-dir"
  case ":$PATH:" in
    *":/tmp/some-new-dir:"*) ;;
    *) false ;;
  esac
}

@test "add_to_path does not duplicate an already-present directory" {
  PATH="/tmp/some-dir:/usr/bin"
  add_to_path "/tmp/some-dir"
  occurrences=$(printf '%s' "$PATH" | grep -o "/tmp/some-dir" | wc -l)
  [ "$occurrences" -eq 1 ]
}

# --- hist / histg ---
# fc -l reads the in-memory shell history list, so entries are injected
# manually with `history -s` to simulate prior commands.

@test "hist finds matching history entries" {
  run bash -c '
    source "'"$SCRIPT"'"
    set -o history
    history -s "echo hello world"
    history -s "ls -la"
    hist "hello"
  '
  [[ "$output" == *"hello world"* ]]
  [[ "$output" != *"ls -la"* ]]
}

@test "histg is case-insensitive" {
  run bash -c '
    source "'"$SCRIPT"'"
    set -o history
    history -s "echo HELLO world"
    histg "hello"
  '
  [[ "$output" == *"HELLO world"* ]]
}

# --- git-clean-branches ---

# KNOWN BUG: `git branch --merged` output lines are indented ("  branch" or
# "* branch"), and git-clean-branches reads them with `IFS=` (no word
# splitting), so the leading spaces end up baked into $branch. This makes
# every `git branch -d "$branch"` call fail silently (wrong branch name),
# so merged branches are never actually deleted. This test documents the
# current (buggy) behavior; if you fix the whitespace handling (e.g. with
# `git branch --merged | sed 's/^[* ]*//'`), update/remove this test.
@test "git-clean-branches currently fails to delete merged branches (KNOWN BUG, see comment above)" {
  TEST_REPO="$(mktemp -d)"
  (
    cd "$TEST_REPO" || exit 1
    git init -q
    git config user.email "test@example.com"
    git config user.name "Test User"
    echo "a" > file.txt
    git add file.txt
    git commit -qm "initial"
    git branch merged-feature
  )

  run bash -c 'cd "'"$TEST_REPO"'" && source "'"$SCRIPT"'" && git-clean-branches; git branch'

  [[ "$output" == *"merged-feature"* ]]
  rm -rf "$TEST_REPO"
}

# --- alert ---

@test "alert reports success icon after a successful command" {
  run bash -c '
    source "'"$SCRIPT"'"
    true
    alert
  '
  [[ "$output" == *"terminal"* ]]
}

@test "alert reports error icon after a failing command" {
  run bash -c '
    source "'"$SCRIPT"'"
    false
    alert
  '
  [[ "$output" == *"error"* ]]
}
