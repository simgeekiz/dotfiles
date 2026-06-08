#!/usr/bin/env sh
# Smoke-test shared shell helpers in both Bash and Zsh.

set -eu

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
REPO_ROOT=$(CDPATH= cd -- "$SCRIPT_DIR/.." && pwd)

run_shell_checks() {
  shell_name=$1

  if ! command -v "$shell_name" >/dev/null 2>&1; then
    printf '%s\n' "Skipping $shell_name: not installed"
    return 0
  fi

  printf '%s\n' "==> Checking $shell_name"

  shell_cmd='
    set -e

    for file in "'"$REPO_ROOT"'/functions"/*.sh; do
      [ -r "$file" ] && . "$file"
    done

    type mkd >/dev/null 2>&1
    type add_to_path >/dev/null 2>&1
    type with_cat >/dev/null 2>&1
    type venv >/dev/null 2>&1
    type activate >/dev/null 2>&1

    if command -v git >/dev/null 2>&1; then
      type gitaddtag >/dev/null 2>&1
    fi

    SHOW_CAT=false
    with_cat true >/dev/null

    PATH_BEFORE=$PATH
    add_to_path /tmp/dotfiles-shell-compat
    case ":$PATH:" in
      *":/tmp/dotfiles-shell-compat:"*) ;;
      *)
        printf "%s\n" "PATH update failed in '"$shell_name"'"
        exit 1
        ;;
    esac

    PATH=$PATH_BEFORE
  '

  case "$shell_name" in
    bash)
      "$shell_name" --noprofile --norc -c "$shell_cmd"
      ;;
    zsh)
      "$shell_name" -f -c "$shell_cmd"
      ;;
    *)
      "$shell_name" -c "$shell_cmd"
      ;;
  esac
}

run_shell_checks bash
run_shell_checks zsh

printf '%s\n' "==> Checking shared scripts"
bash -n "$REPO_ROOT"/asciiart/* "$REPO_ROOT"/bash/* "$REPO_ROOT"/bin/*

bash "$REPO_ROOT"/asciiart/asciiart.sh >/dev/null
bash "$REPO_ROOT"/bin/clean --help >/dev/null
bash "$REPO_ROOT"/bin/speedtest --help >/dev/null
bash "$REPO_ROOT"/bin/weather --help >/dev/null

printf '%s\n' "Shell compatibility smoke checks passed."
