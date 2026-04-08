# ~/.dotfiles/bootstrap/helpers.sh
# Utility functions shared by bootstrap scripts.
# Author: Simge Ekiz
# License: MIT

symlink() {
  source_file="$1"
  destination_file="$2"

  if [ -z "$source_file" ] || [ -z "$destination_file" ]; then
    printf '%s\n' "⚠️ symlink requires source and destination"
    return 1
  fi

  # If it's a symlink, check if it's already correct
  if [ -L "$destination_file" ]; then
    # current_target=$(ls -ld "$destination_file" | awk '{print $NF}')
    current_target=$(readlink "$destination_file")
    if [ "$current_target" = "$source_file" ]; then
      printf '%s\n' "✔️  $destination_file already points to the correct target"
      return 0
    fi
  fi

  # If destination exists (file, dir, or symlink)
  if [ -e "$destination_file" ] || [ -L "$destination_file" ]; then
    # Exists but wrong (file, dir, or wrong symlink) → update
    printf '%s\n' "🔗 Updating symbolic link: $source_file -> $destination_file"
  else
    # Does not exist → create
    printf '%s\n' "⚓ Symbolic link created: $source_file -> $destination_file"
  fi

  ln -sfn "$source_file" "$destination_file" || {
      printf '%s\n' "⚠️  Failed to create symlink: $destination_file"
      return 1
    }
}

backup_file() {

  source_file="$1"
  [ -L "$source_file" ] && return

  if [ -e "$source_file" ]; then
    timestamp=$(date +"%Y-%m-%d_%H-%M")
    mv "$source_file" "$source_file.backup.$timestamp"
    printf '%s\n' "🧾 Moved your old $source_file to $source_file.backup.$timestamp"
  fi
}

# Function to prompt user for yes/no input and run callback
prompt_user() {
  message=$1
  yes_cmd=$2
  no_cmd=${3:-}

  while true; do
    printf "%s [Y/n]: " "$message"
    IFS= read -r user_input

    # Trim leading/trailing whitespace (portable)
    user_input=$(printf "%s" "$user_input" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')

    # Default = yes
    [ -z "$user_input" ] && user_input="y"

    case "$user_input" in
      y|Y|yes|YES|Yes)
        sh -c "$yes_cmd"
        break
        ;;
      n|N|no|NO|No)
        printf '%s\n' "⏭️  Skipping..."
        [ -n "$no_cmd" ] && sh -c "$no_cmd"
        break
        ;;
      *)
        printf '%s\n' "❓ Please answer yes [y] or no [n]."
        ;;
    esac
  done
}