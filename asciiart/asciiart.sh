#!/usr/bin/env bash
# ~/.dotfiles/asciiart/asciiart.sh
# ASCII arts
# Managed by: ~/.dotfiles/asciiart/asciiart.sh
# Author: Simge Ekiz
# License: MIT

# Note: This script is **not POSIX-compliant**, but it works reliably on:
#       - bash and zsh
#       - macOS and Linux

rand_index() {
  local n=$1
  echo $(( RANDOM % n + 1 ))
}

print_asciiart() {
  # Load config
  ASCIIART_RC="${HOME}/.dotfiles/asciiart/asciiart.rc"
  [ -r "$ASCIIART_RC" ] && . "$ASCIIART_RC" || {
    printf "asciiart: config not found: %s\n" "$ASCIIART_RC" >&2
    return 1 2>/dev/null || return 1
  }

  selected_art=$(
    # Put all arts into positional parameters (POSIX trick)
    set -- "$cat_1" "$cat_2" "$meeseeks" "$oli_the_cat" "$oli_the_cat_2"
    count=$#

    [ "$count" -eq 0 ] && exit 1

    idx=$(rand_index "$count")

    i=1
    for art do
      [ "$i" -eq "$idx" ] && { printf "%s\n" "$art"; exit 0; }
      i=$((i + 1))
    done
  )

  selected_msg=$(
    set -- \
      "$messages_1" "$messages_2" "$messages_3" \
      "$messages_4" "$messages_5" "$messages_6"

    count=$#
    
    [ "$count" -eq 0 ] && exit 1

    idx=$(rand_index "$count")
    i=1
    for msg do
      [ "$i" -eq "$idx" ] && { printf "%s" "$msg"; exit 0; }
      i=$((i + 1))
    done
  )

  # Print Together
  [ -n "$selected_art" ] && printf "%s\n" "$selected_art"
  # [ -n "$selected_msg" ] && printf "%s\n" "$selected_msg"
}

# Run if executed directly
print_asciiart