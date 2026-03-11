# venv - Activate Python virtual environment helper
# Usage:
#   venv  -> Checks for .venv, .env, venv, env in the current
#            directory and Activates it
#
venv() {
  for d in .venv .env venv env; do
    if [ -f "$d/bin/activate" ]; then
      source "$d/bin/activate"
      echo "Activated $d"
      return
    fi
  done
  echo "No virtual environment found"
}

# mkvenv - Create a Python virtual environment and activate it
# Usage:
#   mkvenv             # creates .venv and activates it
#   mkvenv myenv       # creates and activates custom env "myenv"
#
mkvenv() {
  dir="${1:-.venv}"          # optional argument, default to .venv
  if [[ -d "$dir" ]]; then
    print "Directory '$dir' already exists. Skipping creation."
  else
    python3 -m venv "$dir"
    print "Created virtual environment '$dir'"
  fi
  
  # Activate using the universal function
  venv
  
  # Upgrade pip in the activated environment
  if command -v pip >/dev/null 2>&1; then
    pip install --upgrade pip
  fi
}