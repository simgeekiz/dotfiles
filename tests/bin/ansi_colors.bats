#!/usr/bin/env bats
# Unit tests for bin/ansi_colors
#
# Run with:
#   bats tests/bin/ansi_colors.bats

setup() {
  SCRIPT_DIR="$(CDPATH= cd -- "$(dirname "$BATS_TEST_FILENAME")/../.." && pwd)"
  SCRIPT="$SCRIPT_DIR/bin/ansi_colors"

  source "$SCRIPT"
}

# --- parse_args ---

@test "parse_args enables all sections when no options are given" {
  PRINT_STANDARD=false
  PRINT_ALL=false
  PRINT_CUBE=false

  parse_args

  [ "$PRINT_STANDARD" = true ]
  [ "$PRINT_ALL" = true ]
  [ "$PRINT_CUBE" = true ]
}

@test "parse_args --standard enables only the standard section" {
  PRINT_STANDARD=false
  PRINT_ALL=false
  PRINT_CUBE=false

  parse_args --standard

  [ "$PRINT_STANDARD" = true ]
  [ "$PRINT_ALL" = false ]
  [ "$PRINT_CUBE" = false ]
}

@test "parse_args combines multiple flags" {
  PRINT_STANDARD=false
  PRINT_ALL=false
  PRINT_CUBE=false

  parse_args --standard --cube

  [ "$PRINT_STANDARD" = true ]
  [ "$PRINT_CUBE" = true ]
  [ "$PRINT_ALL" = false ]
}

@test "parse_args --help exits 0 and prints usage" {
  run parse_args --help
  [ "$status" -eq 0 ]
  [[ "$output" == *"Usage:"* ]]
}

@test "parse_args rejects an unknown option" {
  run parse_args --bogus
  [ "$status" -eq 1 ]
  [[ "$output" == *"Unknown option"* ]]
}

# --- print functions ---

@test "print_standard_colors_with_codes prints all 8 standard color names" {
  run print_standard_colors_with_codes
  for name in Black Red Green Yellow Blue Magenta Cyan White; do
    [[ "$output" == *"$name"* ]]
  done
}

@test "print_color_cube prints the 256-color cube header" {
  run print_color_cube
  [[ "$output" == *"ANSI 256-color cube"* ]]
}
