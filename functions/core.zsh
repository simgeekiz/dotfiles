symlink() {
  local source_file="$1"
  local destination_file="$2"

  if [[ -e $destination_file ]]; then
    if [[ -L $destination_file && $(readlink $destination_file)==$source_file ]]; then
      echo "✔️  $destination_file already points to the correct target"
    else
      echo "🔗 Updating symbolic link: $source_file -> $destination_file"
      ln -sfn "$source_file" "$destination_file"
    fi
  else
    echo "⚓ Symbolic link created: $source_file -> $destination_file"
    ln -sfn "$source_file" "$destination_file"
  fi
}

backup_file() {
  local source_file="$1"

  # note -e → Checks if the file or directory exists, regardless of type.
  # -f → Checks if the path exists and is a regular file (not a directory, symlink to a directory, etc.).
  # -n -n is used in Bash to test whether a string is non-empty. Which is always true, because the string /home/youruser/.bashrc is non-empty.
  #    It does not check if the file exists — only that the string path is not empty.
  if [[ -e "$source_file" ]]; then
    if [ ! -L "$source_file" ]; then
      mv "$target" "$target.backup"
      echo "🧾 Moved your old $source_file config file to $source_file.backup"
    # return 0  # success
    # return 1  # failure
    else
      echo "⚠️  $source_file is a symlink, skipping backup."
    fi
  fi
}

print_log () {
    echo
    echo "---------------------------------------------------------------------------" >&2
    echo "$1"
    echo "---------------------------------------------------------------------------" >&2
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

function add_to_path() {
  if [[ ":$PATH:" != *":$1:"* ]]; then
    export PATH="$1:$PATH"
  fi
}

