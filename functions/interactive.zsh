function with_cat() {
  # 🐱 Define ASCII art function 🐾
  # Run any command passed in
  "$@"
  if [[ "$SHOW_CAT" == "true" ]]; then
    echo "
      /\\_/\\
     ( o.o )
      > v <
    ------------"
  fi
}

function ls() {  
  command ls --color "$@"  # runs the real `ls`, bypassing your custom function
  with_cat
}

function cat() {
  command cat "$@"
  with_cat
}

function grep() {
  command grep --color "$@"
  with_cat
}


# Clean Debian packages
apt-clean() {
    sudo apt-get clean
    sudo apt-get autoclean
    sudo apt-get autoremove
}

# Create a new directory and enter it
mkd() {
    mkdir -p "$@" && cd "$@"
}

# Show the current weather
weather() {
    # ANSI colors
  local RED="\033[31m"
  local GREEN="\033[32m"
  local BLUE="\033[34m"
  local ORANGE="\033[38;5;214m"
  local CYAN="\033[36m"
  local YELLOW="\033[33m"
  local BOLD="\033[1m"
  local RESET="\033[0m"

  local location="${1:-}"
  echo "🌞 Fetching weather for ${BOLD}${location:-'your location'}...${RESET}"

  # Get weather summary
  local raw

  if [[ -z "$location" ]]; then
    raw=$(curl -s "wttr.in?format=%l|%c|%C|%t|%w|%m")
  else
    raw=$(curl -s "wttr.in/${location// /+}?format=%l|%c|%C|%t|%w|%m")
  fi

  # Split parts
  IFS="|" read -r city emoji desc temp wind moon <<< "$raw"

  # Print formatted and colored output
  echo -e "Today: ${BOLD}${GREEN}${city}${RESET}: ${emoji}${ORANGE}(${desc})${RESET} ${RED}${temp}${RESET} ${CYAN}${wind}${RESET} ${YELLOW}Moon:${moon}${RESET}"
}
