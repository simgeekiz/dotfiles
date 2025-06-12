# Key bindings
# Author: Simge Ekiz

# List all keybindings:
#   bindkey

# Use emacs keybindings even if our EDITOR is set to vi
bindkey -e

# Delete: https://blog.pilif.me/2004/10/21/delete-key-in-zsh/
bindkey '^[[3~' delete-char  # Delete: deletes the character under the cursor
bindkey '^[[3;5~' delete-char  # Ctrl-Delete: deletes the character under the cursor

bindkey "^[[H" beginning-of-line  # Home key 
bindkey "^[[F" end-of-line      # End key

# Ctrl-O will accept the current completion 
bindkey -M menuselect '^o' accept-and-infer-next-history

# Smarter history search with arrow keys
autoload -U up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

# Bind arrow keys (both modes)
bindkey '^[[A' up-line-or-beginning-search  # Normal mode
bindkey '^[OA' up-line-or-beginning-search   # Application mode
bindkey '^[[B' down-line-or-beginning-search  # Normal mode
bindkey '^[OB' down-line-or-beginning-search  # Application mode

bindkey '^[[1;3D' backward-word # Alt + ←
bindkey '^[[1;3C' forward-word # Alt + →

bindkey '^[[1;5D' beginning-of-line # Ctrl + ←
bindkey '^[[1;5C' end-of-line # Ctrl + →

bindkey '^U' backward-kill-line # Ctrl + U to delete the line before the cursor
bindkey '^X^U' kill-whole-line  # Ctrl + X, Ctrl + U to kill the whole line

