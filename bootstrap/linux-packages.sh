#!/usr/bin/env sh
# Linux package definitions for apt-based systems.
# Kept in one POSIX-friendly file to avoid a directory of package lists.

COMMON_PACKAGES='
 git
 curl
 tmux
 wget
 guake
 python3
 python3-pip
 python3-venv
 build-essential
 gpg
 '

print_linux_package_list() {
  printf '%s\n' "$PACKAGES"
}