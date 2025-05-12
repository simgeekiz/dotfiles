# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

### Set up the prompt ###
autoload -Uz promptinit
promptinit
# prompt redhat
# alternative liked ones redhat [%n@%m %1~]%(#.#.$)  restore %n@%m %1~ %#  suse %n@%m:%~/ > 
PS1='%B%n@%m %~ %#%b '

### History ###
setopt histignorealldups sharehistory
# Remove older duplicate entries from history
setopt hist_ignore_all_dups
# Remove superfluous blanks from history items
setopt hist_reduce_blanks
# Don't store commands prefixed with a space
setopt hist_ignore_space
# Show command with history expansion to user before running it
setopt hist_verify

# Keep 1000 lines of history within the shell and save it to ~/.zsh_history:
HISTSIZE=100000
SAVEHIST=$HISTSIZE
HISTFILE=~/.zsh_history

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

#### Turn off the sometimes annoying beep
setopt NO_BEEP

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

### APPEARANCE ###
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

# Default coloring for BSD-based ls
export LSCOLORS="Gxfxcxdxbxegedabagacad"

# Default coloring for GNU-based ls
if [[ -z "$LS_COLORS" ]]; then
  # Define LS_COLORS via dircolors if available. Otherwise, set a default
  # equivalent to LSCOLORS (generated via https://geoff.greer.fm/lscolors)
  if (( $+commands[dircolors] )); then
    [[ -f "$HOME/.dircolors" ]] \
      && source <(dircolors -b "$HOME/.dircolors") \
      || source <(dircolors -b)
  else
    export LS_COLORS="di=1;36:ln=35:so=32:pi=33:ex=31:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43"
  fi
fi

### Directory Navigation ###
# Allows you to change directories just by typing the directory name
setopt auto_cd
setopt correct_all

# Load configs
### Aliases ###
if [ -f $HOME/.zsh_aliases ]; then
    source $HOME/.zsh_aliases
fi
### Completion ###

# Uncomment the following line to use case-sensitive completion.
CASE_SENSITIVE="true"
# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
HYPHEN_INSENSITIVE="true"

if [ -f $HOME/.dotfiles/zsh/completion.zsh ]; then
    source $HOME/.dotfiles/zsh/completion.zsh
fi
### Key Bindings ###
if [ -f $HOME/.dotfiles/zsh/key-bindings.zsh ]; then
    source $HOME/.dotfiles/zsh/key-bindings.zsh
fi

### Fortune and Cowsay ###
# # Get list of cowsay animals as array
# animals=(${(f)"$(cowsay -l)"})
# # Pick one at random
# animals_index=$(( (RANDOM % ${#animals[@]}) + 1 ))
# random_animal=${animals[$animals_index]}
# fortune -s | cowsay -f $random_animal


### Load the ascii art. ###
if [ -f $HOME/.dotfiles/asciiart/asciiart.rc ]; then
    source $HOME/.dotfiles/asciiart/asciiart.rc
fi


# set PATH so it includes user's private bin directories ###
PATH="$HOME/bin:$HOME/.local/bin:$PATH"
export PATH="$PATH:/Library/Frameworks/Python.framework/Versions/3.10/bin"
export PATH=/usr/local/bin:$PATH
source ~/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

