
# Enable colors and git detection
autoload -U colors && colors

# Git branch function
git_branch() {
  local branch
  branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
  if [[ -n $branch ]]; then
    echo "%F{white}|%f %F{yellow}${branch}%f "
  fi
}

# Python / virtualenv detection
venv_prompt() {
  if [[ -n "$VIRTUAL_ENV" ]]; then
    echo "%F{white}|%f %F{green}($(basename $VIRTUAL_ENV))%f "
  fi
}

# ---- final prompt ----
precmd() {
  PROMPT='%K{236}'                       # gray background 
  PROMPT+='%F{cyan}%n@%m%f'              # user@hostname
  PROMPT+='%F{white}|%f %F{blue}%~%f '   # current path
  PROMPT+='$(git_branch)'                # Git branch
  PROMPT+='$(venv_prompt)'               # virtualenv
  PROMPT+='%F{white}%#  %f'              # prompt char (# or $)
  PROMPT+='%k'                           # end background
}
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