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

### -- History
hist() {
  fc -l 1 | grep "$@"
}

histg() {
  fc -l 1 | grep -i "$@"
}

if [ -n "$ZSH_VERSION" ] || [ -n "$BASH_VERSION" ]; then
  historytime() { 
    fc -il 1 
  }
fi

### -- Git
# delete merged branches
git-clean-branches() {
  # Only merged branches that are not current
  git branch --merged | grep -v '^\*' | while IFS= read -r branch; do
    [ -n "$branch" ] && git branch -d "$branch"
  done
}


# ALERT (functions)
# Add an "alert" alias for long running commands.  Use like so: sleep 10; alert
if command -v notify-send >/dev/null 2>&1; then
  alert() {
    status=$?
    icon="error"
    [ "$status" -eq 0 ] && icon="terminal"

    # Zsh & Bash compatible way to get last command
    if [ -n "$ZSH_VERSION" ]; then
      last_cmd=$(fc -ln -1)
    else
      last_cmd=$(history | tail -n1 | sed -e 's/^[[:space:]]*[0-9]\+[[:space:]]*//')
    fi

    notify-send --urgency=low -i "$icon" "$last_cmd"
  }
fi

# Homebrew
if [ "$(uname -s)" = "Darwin" ] && command -v brew >/dev/null 2>&1; then
  brewu() {
    brew update && brew upgrade && brew cleanup && brew doctor
  }
fi