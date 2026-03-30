# ~/.dotfiles/zsh/prompt.zsh
# Zsh module configuring custom shell prompt
# Managed by: ~/.dotfiles/zsh/prompt.zsh
# Author: Simge Ekiz
# License: MIT

# Enable colors and git detection
autoload -U colors add-zsh-hook
colors

# Git branch function
git_branch() {
  local branch
  branch=$(command git symbolic-ref --short HEAD 2>/dev/null) || \
  branch=$(command git rev-parse --short HEAD 2>/dev/null) || return
  print -r -- "%F{white}|%f %F{yellow}${branch}%f "
}

# Python / virtualenv detection
venv_prompt() {
  if [[ -n "${VIRTUAL_ENV-}" ]]; then
    print -r -- "%F{white}|%f %F{green}($(basename "$VIRTUAL_ENV"))%f "
  fi
}

# ---- final prompt ----
set_prompt() {
  PROMPT='%K{236}'                       # gray background 
  PROMPT+='%F{cyan}%n@%m%f'              # user@hostname
  PROMPT+='%F{white}|%f %F{blue}%~%f '   # current path
  PROMPT+='$(git_branch)'                # Git branch
  PROMPT+='$(venv_prompt)'               # virtualenv
  PROMPT+='%F{white}%#  %f'              # prompt char (# or $)
  PROMPT+='%k'                           # end background
}

# Run the function set_prompt every time right before the prompt is shown
add-zsh-hook precmd set_prompt

### --- Notes
  # %B  -> start bold text
  # %b  -> end bold text
  # %n  -> username
  # %m  -> hostname
  # %~  -> current directory (shortened)
  # %#  -> prompt symbol $ or #

  # ${cyan}, ${blue}, ${green}, ${red}, ${yellow}, ${orange}, ${white}, ${reset}
  # ${reset} clears the color.
  # ${bold} works for bold text.
  # ${fg[cyan]} is also valid if you want the fg[] syntax.