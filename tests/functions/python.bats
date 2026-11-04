#!/usr/bin/env bats
# Unit tests for functions/python.sh
#
# Run with:
#   bats tests/functions/python.bats

setup() {
  SCRIPT_DIR="$(CDPATH= cd -- "$(dirname "$BATS_TEST_FILENAME")/../.." && pwd)"
  SCRIPT="$SCRIPT_DIR/functions/python.sh"

  TEST_HOME="$(mktemp -d)"
  MOCK_BIN="$(mktemp -d)"
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

# --- venv ---

@test "venv activates an existing .venv directory" {
  mkdir -p "$TEST_HOME/project/.venv/bin"
  cat > "$TEST_HOME/project/.venv/bin/activate" <<'EOF'
VENV_WAS_ACTIVATED=true
EOF

  run bash -c 'source "'"$SCRIPT"'"; cd "'"$TEST_HOME"'/project" && venv && [ "$VENV_WAS_ACTIVATED" = true ]'

  [ "$status" -eq 0 ]
}

@test "venv checks .venv, .env, venv, env in that order" {
  mkdir -p "$TEST_HOME/project/env/bin"
  touch "$TEST_HOME/project/env/bin/activate"

  run bash -c 'source "'"$SCRIPT"'"; cd "'"$TEST_HOME"'/project" && venv'

  [ "$status" -eq 0 ]
}

@test "venv reports when no virtual environment is found" {
  mkdir -p "$TEST_HOME/empty_project"

  run bash -c 'source "'"$SCRIPT"'"; cd "'"$TEST_HOME"'/empty_project" && venv'

  [[ "$output" == *"No virtual environment found"* ]]
}

# --- mkvenv ---

@test "mkvenv creates a .venv directory using python3 -m venv" {
  make_mock python3 'if [ "$1" = "-m" ] && [ "$2" = "venv" ]; then mkdir -p "$3/bin"; touch "$3/bin/activate"; fi'

  run bash -c 'source "'"$SCRIPT"'"; cd "'"$TEST_HOME"'" && mkvenv'

  [ "$status" -eq 0 ]
  [ -d "$TEST_HOME/.venv" ]
  [[ "$output" == *"Created virtual environment '.venv'"* ]]
}

@test "mkvenv accepts a custom directory name" {
  make_mock python3 'if [ "$1" = "-m" ] && [ "$2" = "venv" ]; then mkdir -p "$3/bin"; touch "$3/bin/activate"; fi'

  run bash -c 'source "'"$SCRIPT"'"; cd "'"$TEST_HOME"'" && mkvenv myenv'

  [ "$status" -eq 0 ]
  [ -d "$TEST_HOME/myenv" ]
}

@test "mkvenv skips creation when the directory already exists" {
  mkdir -p "$TEST_HOME/.venv/bin"
  touch "$TEST_HOME/.venv/bin/activate"
  make_mock python3 'echo "python3 should not be called for venv creation"; exit 1'

  run bash -c 'source "'"$SCRIPT"'"; cd "'"$TEST_HOME"'" && mkvenv'

  [[ "$output" == *"already exists. Skipping creation."* ]]
}

# --- activate / deac ---

@test "activate is an alias for venv" {
  mkdir -p "$TEST_HOME/project/.venv/bin"
  touch "$TEST_HOME/project/.venv/bin/activate"

  run bash -c 'source "'"$SCRIPT"'"; cd "'"$TEST_HOME"'/project" && activate'

  [ "$status" -eq 0 ]
}

@test "deac does not fail even when nothing is activated" {
  run deac
  [ "$status" -eq 0 ]
}
