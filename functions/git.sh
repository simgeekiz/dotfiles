# ~/.dotfiles/functions/git.sh
# Git helper functions (complex operations that need validation)
# Managed by: ~/.dotfiles/bashrc or ~/.dotfiles/zshrc
# Author: Simge Ekiz
# License: MIT

if ! command -v git >/dev/null 2>&1; then
  return
fi

# Git tag with proper validation
gitaddtag() {
  if [ $# -lt 1 ]; then
    printf '%s\n' "Usage: gitaddtag <tag-name> [commit-message]"
    return 1
  fi
  local tag_name="$1"
  local message="${2:-trigger ci/cd for $tag_name}"
  git tag -a "$tag_name" "$(git rev-parse HEAD)" -m "$message"
}

gaddtag() {
  gitaddtag "$@"
}

gitaddtagremote() {
  if [ $# -lt 1 ]; then
    printf '%s\n' "Usage: gitaddtagremote <tag-name>"
    return 1
  fi
  git push origin "$1"
}

gitdeltag() {
  if [ $# -lt 1 ]; then
    printf '%s\n' "Usage: gitdeltag <tag-name>"
    return 1
  fi
  git tag -d "$1"
}

gdeltag() {
  gitdeltag "$@"
}

gitdeltagremote() {
  if [ $# -lt 1 ]; then
    printf '%s\n' "Usage: gitdeltagremote <tag-name>"
    return 1
  fi
  git push --delete origin "$1"
}

# Git remote management with validation
gitaddremote() {
  if [ $# -lt 2 ]; then
    printf '%s\n' "Usage: gitaddremote <remote-name> <url>"
    return 1
  fi
  git remote add "$1" "$2"
}

gaddremote() {
  gitaddremote "$@"
}
