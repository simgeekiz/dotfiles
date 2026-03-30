# ~/.dotfiles/functions/misc.sh
# Interactive shell helpers (search, timestamps, etc.)
# Managed by: ~/.dotfiles/zsh/zshrc or ~/.dotfiles/bash/bashrc
# Author: Simge Ekiz
# License: MIT

## Shell helpers

with_cat() {
  # 🐱 Define ASCII art function 🐾
  # Run any command passed in
  "$@"
  if [ "$SHOW_CAT" = "true" ]; then
    printf "
      /\\_/\\
     ( o.o )
      > v <
    ------------"
  fi
}

# Create a new directory and enter it
mkd() {
    mkdir -p "$1" && cd "$1"
}

add_to_path() {
  case ":$PATH:" in
    *":$1:"*) ;;  # already in PATH, do nothing
    *) PATH="$1:$PATH" ;;
  esac
  export PATH
}


if [ -n "$ZSH_VERSION" ] || [ -n "$BASH_VERSION" ]; then
  historytime() { fc -il 1 }
fi


### -- Git
# delete merged branches
git-clean-branches() {
  merged=$(git branch --merged | grep -v '^\*' | tr '\n' ' ')
  [ -n "$merged" ] && echo "$merged" | xargs -n 1 git branch -d
}