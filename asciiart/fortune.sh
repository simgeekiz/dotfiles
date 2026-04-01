#!/usr/bin/env bash
# ~/.dotfiles/asciiart/fortune.zsh
# Fortune and Cowsay Script
# Managed by: ~/.dotfiles/asciiart/fortune.zsh
# Author: Simge Ekiz
# License: MIT

# Note: This script is **not POSIX-compliant**, but it works reliably on:
#       - bash and zsh
#       - macOS and Linux

### === Fortune and Cowsay === ###
# Get all cows as a string
animals=$(cowsay -l | tail -n +2 | tr ' ' '\n')

# Convert string into an array (works in bash and zsh)
cows=()
while IFS= read -r cow; do
  cows+=("$cow")
done <<< "$animals"

# Pick a random cow
cow_file="${cows[RANDOM % ${#cows[@]}]}"

# Generate fortune with that cow
fortune -s | cowsay -f "$cow_file"