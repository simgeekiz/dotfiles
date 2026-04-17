# ~/.dotfiles/bash/prompt.sh
# Bash prompt
# Managed by: ~/.dotfiles/bash/bashrc
# Author: Simge Ekiz
# License: MIT

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# ----- 16-color ANSI codes -----
GREEN="\[\033[01;32m\]"        # bright green
BLUE="\[\033[01;34m\]"         # bright blue
YELLOW="\[\033[01;33m\]"       # bright yellow
CYAN="\[\033[01;36m\]"         # bright cyan / light blue
RED="\[\033[01;31m\]"          # bright red (for root)
RESET="\[\033[0m\]"

# ----- Detect if terminal supports color -----
force_color_prompt=yes
color_prompt=
if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
        color_prompt=yes
    fi
fi

# ----- Git branch function -----
git_branch() {
    local branch
    if branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null); then
        echo "${YELLOW}${branch}${RESET} "
    fi
}

# ----- Python virtualenv function -----
python_env() {
    if [[ -n "$VIRTUAL_ENV" ]]; then
        local env_name
        env_name=$(basename "$VIRTUAL_ENV")
        echo "(${CYAN}${env_name}${RESET}) "
    fi
}

# ----- Build PS1 -----
# Prompt style
if [ "$color_prompt" = yes ]; then
    BASE_PS1=""
    if [[ ${EUID} == 0 ]]; then
        # Root: hostname red
        BASE_PS1+="${RED}\u@\h${RESET}"
    else
        # Normal user: user@host green
        BASE_PS1+="${GREEN}\u@\h${RESET}"
    fi
    # Add working directory
    BASE_PS1+=" ${BLUE}\w${RESET} "
else
    # Fallback plain prompt
    BASE_PS1+='${debian_chroot:+($debian_chroot) }\u@\h \w'
fi

# ----- Build final PS1  -----
build_prompt() {
    PS1=""
    PS1+="${debian_chroot:+($debian_chroot) }"  # chroot if any
    PS1+="$BASE_PS1"                            # user@host + folder
    PS1+="$(git_branch)"                        # optional git branch
    PS1+="$(python_env)"                        # optional virtualenv
    PS1+="${RESET}$ "                           # prompt character

    # ----- Terminal title for xterm/rxvt -----
    case "$TERM" in
        xterm*|rxvt*)
            PS1="\[\033]0;Bash\a\]$PS1"
            ;;
    esac
}

if [ -n "${PROMPT_COMMAND:-}" ]; then
    PROMPT_COMMAND="build_prompt; $PROMPT_COMMAND"
else
    PROMPT_COMMAND="build_prompt"
fi

build_prompt
export PS1

unset color_prompt force_color_prompt
