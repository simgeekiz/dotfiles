# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

function add_to_path() {
	if ! $(echo "$PATH" | tr ":" "\n" | grep -qx "$1"); then
		PATH="$1:$PATH"
	fi
}

### Set up the prompt ###
autoload -Uz promptinit
promptinit
# prompt redhat
# alternative liked ones redhat [%n@%m %1~]%(#.#.$)  restore %n@%m %1~ %#  suse %n@%m:%~/ > 
PS1='%B%n@%m %~ %#%b '

# Load configs

export SHOW_CAT="true"
# === Import functions ===
[[ -f "$HOME/.dotfiles/functions/interactive.zsh" ]] && source "$HOME/.dotfiles/functions/interactive.zsh"
[[ -f "$HOME/.dotfiles/functions/core.zsh" ]] && source "$HOME/.dotfiles/functions/core.zsh"

### Aliases ###
[[ -f $HOME/.zsh_aliases ]] && source $HOME/.zsh_aliases

### Completion ###

# Uncomment the following line to use case-sensitive completion.
export CASE_SENSITIVE="true"
# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
export HYPHEN_INSENSITIVE="true"

[[ -f $HOME/.dotfiles/zsh/completion.zsh ]] && source $HOME/.dotfiles/zsh/completion.zsh

### Key Bindings ###
[[ -f "$HOME/.dotfiles/zsh/key-bindings.zsh" ]] && source "$HOME/.dotfiles/zsh/key-bindings.zsh"


### Config ###
[[ -f $HOME/.dotfiles/zsh/config.zsh ]] && source $HOME/.dotfiles/zsh/config.zsh

### Fortune and Cowsay ###
# # Get list of cowsay animals as array
# animals=(${(f)"$(cowsay -l)"})
# # Pick one at random
# animals_index=$(( (RANDOM % ${#animals[@]}) + 1 ))
# random_animal=${animals[$animals_index]}
# fortune -s | cowsay -f $random_animal


### Load the ascii art. ###
[[ -f $HOME/.dotfiles/asciiart/asciiart.rc ]] && source $HOME/.dotfiles/asciiart/asciiart.rc

### Add custom bin directory to PATH ###
if [ -d $HOME/.dotfiles/bin ]; then
  add_to_path "$HOME/.dotfiles/bin"
  export PATH

  for file in "$HOME/.dotfiles/bin"/*; do
    chmod +x "$file"
  done
fi

source ~/powerlevel10k/powerlevel10k.zsh-theme
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

