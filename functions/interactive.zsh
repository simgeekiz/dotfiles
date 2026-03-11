# Interactive shell helpers
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

# Create a new directory and enter it
mkd() {
    mkdir -p "$1" && cd "$1"
}


# Function to prompt user for yes/no input and run callback
prompt_user() {
  local message=$1
  local yes_callback=$2
  local no_callback=$3

  while true; do
    printf "$message [Y/n]: "
    read user_input
    user_input=$(echo "$user_input" | xargs) # Trim whitespace
    user_input=${user_input:-y} # set default to 'y' if empty

    case "$user_input" in
      y|Y|yes|YES|Yes|YeS|yEs|YEs) eval "$yes_callback"; break ;;
      n|N|no|NO|No|nO) echo "⏭️  Skipping..."
      [[ -n "$no_callback" ]] && eval "$no_callback"; break ;;
      *) echo "❓ Please answer yes [y] or no [n]." ;;
    esac
  done
}