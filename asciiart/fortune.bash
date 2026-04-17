#!/usr/bin/env bash
# ~/.dotfiles/asciiart/fortune.bash
# Fortune and Cowsay Script
# Managed by: ~/.dotfiles/asciiart/fortune.bash
# Author: Simge Ekiz
# License: MIT

# Note: This script is **not POSIX-compliant**, but it works reliably on:
#       - bash and zsh
#       - macOS and Linux

### === Fortune and Cowsay === ###
# Ensure dependencies are installed
if ! command -v cowsay >/dev/null 2>&1; then
  echo "❗ cowsay is not installed"
  exit 1
fi
if ! command -v fortune >/dev/null 2>&1; then
  echo "❗ fortune is not installed"
  exit 1
fi

# Get all cows as a string
animals=$(cowsay -l | tail -n +2 | tr ' ' '\n')

# Convert string into an array (works in bash and zsh)
cows=()
while IFS= read -r cow; do
  cows+=("$cow")
done <<< "$animals"

# Pick a random cow
cow_count=${#cows[@]}
if [ "$cow_count" -eq 0 ]; then
  echo "❗ No cows available"
  exit 1
fi

if [ -n "${ZSH_VERSION:-}" ]; then
  cow_index=$(( RANDOM % cow_count + 1 ))
else
  cow_index=$(( RANDOM % cow_count ))
fi

cow_file="${cows[cow_index]}"

# Generate fortune with that cow
fortune -s | cowsay -f "$cow_file"
