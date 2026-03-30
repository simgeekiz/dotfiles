# ~/.dotfiles/zsh/key-bindings.zsh
# Zsh module configuring shell key bindings
# Managed by: ~/.dotfiles/zsh/zshrc
# Author: Simge Ekiz
# License: MIT

# List all keybindings:
#   bindkey

# Use emacs keybindings even if our EDITOR is set to vi
bindkey -e

### Basic Editing Keys
# Delete: https://blog.pilif.me/2004/10/21/delete-key-in-zsh/
bindkey '^[[3~' delete-char  # Delete: deletes the character under the cursor
bindkey '^[[3;5~' delete-char  # Ctrl-Delete: deletes the character under the cursor

bindkey "^[[H" beginning-of-line  # Home key 
bindkey "^[[F" end-of-line      # End key

bindkey '^U' backward-kill-line # Ctrl + U to delete the line before the cursor
bindkey '^X^U' kill-whole-line  # Ctrl + X, Ctrl + U to kill the whole line

### Completion Menu Enhancements
# Ctrl-O will accept the current completion
bindkey -M menuselect '^o' accept-and-infer-next-history

###  Smarter History Navigation (history search with arrow keys)
autoload -U up-line-or-beginning-search down-line-or-beginning-search
# Only define if not already defined
(( $+widgets[up-line-or-beginning-search] )) || zle -N up-line-or-beginning-search
(( $+widgets[down-line-or-beginning-search] )) || zle -N down-line-or-beginning-search

# Bind arrow keys (both modes)
bindkey '^[[A' up-line-or-beginning-search  # Up arrow Normal mode
bindkey '^[OA' up-line-or-beginning-search   # Up arrow Application mode
bindkey '^[[B' down-line-or-beginning-search  # Down arrow Normal mode
bindkey '^[OB' down-line-or-beginning-search  # Down arrow Application mode

### Word and Line Navigation (Terminal-aware)
bindkey '^[[1;3D' backward-word # Alt + ←
bindkey '^[[1;3C' forward-word # Alt + →

bindkey '^[[1;5D' beginning-of-line # Ctrl + ←
bindkey '^[[1;5C' end-of-line # Ctrl + →
