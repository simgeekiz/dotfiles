#!/usr/bin/env sh
# ~/.dotfiles/git/git_setup.sh
# Script to initialize Git settings and setup repositories
# Managed by: ~/.dotfiles/git/git_setup.sh
# Author: Simge Ekiz
# License: MIT
# Source / Inspired by: https://github.com/lewagon/dotfiles/blob/master/git_setup.sh
# Note: This is setup by gitignore file already

set -eu

git_name=""
if git_name_tmp=$(git config --global --get user.name 2>/dev/null); then
  git_name="$git_name_tmp"
fi

git_email=""
if git_email_tmp=$(git config --global --get user.email 2>/dev/null); then
  git_email="$git_email_tmp"
fi

echo "$git_name, $git_email"
if [ -n "$git_name" ] && [ -n "$git_email" ]; then
  echo "🔖 Git name and email are already set."
else
  echo "🔧 Setting up Git identity"

  printf "Type in your first and last name (no accent or special characters): "
  read -r full_name

  printf "Type in your email address (the one used for your GitHub account): "
  read -r email

  git config --global user.email "$email"
  git config --global user.name "$full_name"
  git config --global init.defaultBranch main

  echo "👌 Awesome, all set."
fi

