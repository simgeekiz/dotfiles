# ~/.dotfiles/zsh/config.zsh
# Zsh module setting environment variables and general configuration
# Managed by: ~/.dotfiles/zsh/zshrc
# Author: Simge Ekiz
# License: MIT

## APPEARANCE ###
# Sets color variable such as $fg, $bg, $color and $reset_color
autoload -U colors && colors

### General shell behavior ###
# Disable terminal bell/beep on errors or tab completion
setopt NO_BEEP
# Allow comments (# ...) in interactive shell commands
setopt interactive_comments
# Enable command substitution (e.g. $(...) ) inside prompt variables
setopt prompt_subst  
# Enable extended globbing features (advanced pattern matching like ^, ~, etc.)
setopt extendedglob
# You may need to manually set your language environment
export LANG=en_US.UTF-8

### Directory Navigation ###
# Allows you to change directories just by typing the directory name
setopt auto_cd
# Attempt to correct mistyped commands (can be intrusive in practice)
# setopt correct

# =========================
# History
# =========================
# History file and size
HISTSIZE=100000
SAVEHIST=$HISTSIZE
HISTFILE="$HOME/.zsh_history"

# Duplicate handling
setopt hist_ignore_all_dups      # Keep only the latest copy of duplicate commands
setopt hist_ignore_dups          # Do not record an event that was just recorded again.
setopt hist_expire_dups_first    # Expire a duplicate first when trimming history.
setopt hist_find_no_dups         # Don't show a previously found history entry
setopt hist_save_no_dups         # Don't save duplicates to file

# Formatting and verification
setopt hist_reduce_blanks        # Remove extra spaces from history commands
setopt hist_ignore_space         # Don't record commands starting with a space
setopt hist_verify               # Show expanded history command before executing
# setopt inc_append_history        # Write each command to disk right away.
setopt extended_history          # Save timestamps with history entries

# Sharing across sessions and alerts
setopt share_history             # Share history across sessions instantly
setopt hist_beep                 # Beep when accessing non-existent history.

### Custom variables ###
export SHOW_CAT=true

### Completion behaviour ###
# Uncomment the following line to use case-sensitive completion.
export CASE_SENSITIVE=true
# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# export HYPHEN_INSENSITIVE="true"

# Menu-like autocompletion selection
zmodload -i zsh/complist
setopt auto_list        # Automatically list choices on ambiguous completion
setopt auto_menu        # show completion menu on successive tab press
setopt always_to_end    # Move cursor to end if word had one match
unsetopt menu_complete  # do not autoselect the first completion entry
unsetopt flowcontrol
setopt complete_in_word
### setopt NO_COMPLETE_ALIASES


# =========================
# LS colors
# =========================
# Don't set ls coloring if disabled
if [[ "$DISABLE_LS_COLORS" != true ]]; then
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
          source <(dircolors -b)
        else
          export LS_COLORS="di=1;94:ln=1;95:so=32:pi=33:ex=31:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43:*.md=32:*.sh=33"
        fi
      fi
      ;;
  esac
fi