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

### Config ###
if [ -f $HOME/.dotfiles/zsh/config.zsh ]; then
    source $HOME/.dotfiles/zsh/config.zsh
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

