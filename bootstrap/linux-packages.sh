#!/usr/bin/env sh
# Linux package definitions for supported package managers.
# Kept in one POSIX-friendly file to avoid a directory of package lists.

COMMON_PACKAGES='
git
curl
tmux
wget
'

APT_PACKAGES='
python3
python3-pip
build-essential
gpg
python3-venv
'

DNF_PACKAGES='
python3
python3-pip
gcc
gcc-c++
make
gnupg2
'

YUM_PACKAGES='
python3
python3-pip
gcc
gcc-c++
make
gnupg2
'

PACMAN_PACKAGES='
python
python-pip
base-devel
gnupg
'

ZYPPER_PACKAGES='
python3
python3-pip
gcc
gcc-c++
make
gpg2
'

print_linux_package_list() {
  manager=$1

  printf '%s\n' "$COMMON_PACKAGES"

  case "$manager" in
    apt) printf '%s\n' "$APT_PACKAGES" ;;
    dnf) printf '%s\n' "$DNF_PACKAGES" ;;
    yum) printf '%s\n' "$YUM_PACKAGES" ;;
    pacman) printf '%s\n' "$PACMAN_PACKAGES" ;;
    zypper) printf '%s\n' "$ZYPPER_PACKAGES" ;;
    *) return 1 ;;
  esac
}
