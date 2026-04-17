# ~/.dotfiles/git/git_aliases.sh
# Git aliases (simple pass-through commands)
# Complex operations are in ~/.dotfiles/functions/git.sh
# Managed by: ~/.dotfiles/git/git_aliases.sh
# Author: Simge Ekiz
# License: MIT

if ! command -v git >/dev/null 2>&1; then
  return
fi

# === Status and Info ===
alias gs='git status'
alias gsta='git status'
alias gbra='git branch'

# === Checkout ===
alias gco='git checkout'
alias gncek='git checkout -b'

# === Add ===
alias gaa='git add -A :/'
alias ga='git add'

# === Commit ===
alias gc='git commit'
alias gca='git commit -a'

# === Push/Pull ===
alias gp='git push'
alias gl='git pull'

# === Diff ===
alias gd='git diff'

# === Clone ===
alias gcl='git clone'
alias gclo='git clone'

# === Fetch ===
alias gfet='git fetch'

# === Reset/Restore ===
alias gundo='git reset --soft HEAD~1'
alias gunstage='git reset'
alias gundonunstage='git reset HEAD~1'
alias gundonunstagendiscard='git reset --hard HEAD~1'
alias gunstagefp='git restore --staged'
alias gunstagendiscardfp='git restore'

# === Log ===
alias glci='git log -1 --format=%H'
alias gitlastcommitid='git log -1 --format=%H'

# === Tags ===
alias gittagls='git tag -n'
# Complex tag operations: gitaddtag, gitdeltag, gitaddtagremote, gitdeltagremote
# (defined in ~/.dotfiles/functions/git.sh)