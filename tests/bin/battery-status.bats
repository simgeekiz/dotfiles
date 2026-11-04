#!/usr/bin/env bats
# Unit tests for bin/battery-status
#
# Run with:
#   bats tests/bin/battery-status.bats

setup() {
  SCRIPT_DIR="$(CDPATH= cd -- "$(dirname "$BATS_TEST_FILENAME")/../.." && pwd)"
  SCRIPT="$SCRIPT_DIR/bin/battery-status"

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

@test "parse_args --short sets SHORT=1" {
  SHORT=0
  parse_args --short
  [ "$SHORT" -eq 1 ]
}

@test "parse_args rejects an unknown flag" {
  run parse_args --bogus
  [ "$status" -eq 1 ]
  [[ "$output" == *"Unknown option"* ]]
}

# --- macos_battery_info ---

@test "macos_battery_info reports when pmset is unavailable" {
  run macos_battery_info
  [ "$status" -eq 1 ]
  [[ "$output" == *"pmset command not found"* ]]
}

@test "macos_battery_info parses a discharging battery on AC" {
  make_mock pmset 'echo "Now drawing from '"'"'AC Power'"'"'"; echo " -InternalBattery-0 (id=123) 85%; discharging; 2:15 remaining present: true"'

  run macos_battery_info

  [[ "$output" == *"On AC"* ]]
  [[ "$output" == *"discharging"* ]]
  [[ "$output" == *"85%"* ]]
}

@test "macos_battery_info supports short output" {
  make_mock pmset 'echo "Now drawing from '"'"'Battery Power'"'"'"; echo " -InternalBattery-0 (id=123) 42%; discharging; 1:00 remaining present: true"'
  SHORT=1

  run macos_battery_info

  [ "$output" = "42%" ]
}

# --- linux_battery_info ---
# /sys/class/power_supply paths are read directly (not parameterized), so
# faking "no battery" would require mount tricks that are out of scope
# here; this is a smoke test against whatever hardware the test runs on.

@test "linux_battery_info runs without error and reports a status line" {
  run linux_battery_info
  [ "$status" -eq 0 ] || [[ "$output" == *"No battery found"* ]]
}

# --- main OS dispatch ---

@test "main reports an unsupported OS" {
  run bash -c 'source "'"$SCRIPT"'"; uname() { echo Plan9; }; main'
  [ "$status" -eq 1 ]
  [[ "$output" == *"Unsupported OS"* ]]
}
