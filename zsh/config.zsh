# Key bindings
# Author: Simge Ekiz

#### Turn off the sometimes annoying beep
setopt NO_BEEP

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

### Directory Navigation ###
# Allows you to change directories just by typing the directory name
setopt auto_cd
setopt correct_all

### History ###
# Keep 1000 lines of history within the shell and save it to ~/.zsh_history:
HISTSIZE=100000
SAVEHIST=$HISTSIZE
HISTFILE=~/.zsh_history

setopt hist_ignore_all_dups  # Keep only the latest copy of duplicate commands
# Delete an old recorded event if a new event is a duplicate.
setopt share_history  # Share history across sessions instantly
setopt hist_reduce_blanks # Remove extra spaces from history commands
setopt hist_ignore_space # Don't record commands starting with a space
setopt hist_verify               # Show expanded history command before running
# Do not execute immediately upon history expansion.
setopt inc_append_history        # Write each command to disk right away.
setopt extended_history          # Save timestamps with history entries
setopt HIST_EXPIRE_DUPS_FIRST    # Expire a duplicate event first when trimming history.
setopt HIST_IGNORE_DUPS          # Do not record an event that was just recorded again.
setopt HIST_FIND_NO_DUPS         # Do not display a previously found event.
setopt HIST_SAVE_NO_DUPS         # Do not write a duplicate event to the history file.
setopt HIST_BEEP                 # Beep when accessing non-existent history.


## APPEARANCE ###
# Sets color variable such as $fg, $bg, $color and $reset_color
autoload -U colors && colors

# Use diff --color if available
if command diff --color /dev/null{,} &>/dev/null; then
  function diff {
    command diff --color "$@"
  }
fi

# Don't set ls coloring if disabled
[[ "$DISABLE_LS_COLORS" != true ]] || return 0

# Set up ls colors and alias based on the platform

case "$(uname -s)" in
  Darwin*)
    # Default coloring for BSD-based ls # macOS / BSD 
    export LSCOLORS="ExFxCxDxBxegedabagacad"
    ;;
  Linux*)
    # Default coloring for GNU-based ls
    if [[ -z "$LS_COLORS" ]]; then
      # Define LS_COLORS via dircolors if available. Otherwise, set a default
      # equivalent to LSCOLORS (generated via https://geoff.greer.fm/lscolors)
      if (( $+commands[dircolors] )); then
        [[ -f "$HOME/.dircolors" ]] \
          && source <(dircolors -b "$HOME/.dircolors") \
          || source <(dircolors -b)
      else
        export LS_COLORS="di=1;94:ln=1;95:so=32:pi=33:ex=31:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43:*.md=32:*.sh=33"
      fi
    fi
    ;;
esac



