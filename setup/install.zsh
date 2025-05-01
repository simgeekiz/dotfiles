#!/bin/zsh

function printlog () {
    echo
    echo "---------------------------------------------------------------------------" >&2
    echo "$1"
    echo "---------------------------------------------------------------------------" >&2
}

function install_fonts() {
  # This script installs custom fonts from a specified source directory to the target font directory.
  # It is designed to work on macOS, but can be adapted for other systems.

  echo "🌌 Installing Custom Fonts..."
 
  # Source folder where your fonts are stored
  FONT_SOURCE_DIR="$HOME/.dotfiles/fonts"

  # Target font folder for the current user (macOS only)
  FONT_TARGET_DIR="$HOME/Library/Fonts"

  if [ ! -d "$FONT_SOURCE_DIR" ]; then
    echo "❌ Font source folder not found: $FONT_SOURCE_DIR"
    exit 1   
  elif [ -d "$FONT_SOURCE_DIR" ]; then
    # Create the target directory if it doesn't exist
    if [ ! -d "$FONT_TARGET_DIR" ]; then
      mkdir -p "$FONT_TARGET_DIR"  
    fi

    # Copy .ttf and .otf fonts
    find "$FONT_SOURCE_DIR" -type f \( -iname "*.ttf" -o -iname "*.otf" \) -exec cp "{}" "$FONT_TARGET_DIR" \;
  fi
}

# Install Jekyll
function install_jekyll() {
  # This script installs Jekyll and its dependencies.

  echo "🧪  Installing Jekyll..."

  # Check if Jekyll is already installed
  if ! command -v jekyll &> /dev/null; then
    echo "🐥 Jekyll not found. Installing..."
    gem install jekyll bundler
    # echo "✅ Jekyll installed!"
  else
    echo "🐣 Jekyll is already installed."
  fi

  sudo apt-get install ruby-full build-essential zlib1g-dev

  if [ -f "$HOME/.localrc" ]; then
      # echo "$HOME/.localrc exists. Using the original file"
  else 
      # echo "$HOME/.localrc does not exist. creating one"
      touch $HOME/.localrc
      chmod 755 $HOME/.localrc 
  fi 

  echo '# Install Ruby Gems to ~/gems' >> ~/.localrc
  echo 'export GEM_HOME="$HOME/gems"' >> ~/.localrc
  echo 'export PATH="$HOME/gems/bin:$PATH"' >> ~/.localrc

  exec "$SHELL" -l

  sudo gem install jekyll bundler

  # Then follow the instruction from your project 
  # Probably the steps are following:
  # $ bundle config set --local path 'vendor/bundle'
  # $ bundle install
  # Then Go to the project folder where you can find Gemfile.
  # $ cd <path_to_dashboard_repository> 
  # Run the server.
  # $ bundle exec jekyll serve 
}

# Function to create symbolic links
# Get operating system
unamestr=$(uname)
if [[ $unamestr == "Linux" ]]; then
  printlog "🌲 Platform detected as Linux. Installing accordingly."

  # Update the system
  echo "🔄 Updating system..."
  sudo apt update && sudo apt upgrade -y

  # Array of packages to install CLI(command line Interface)   # cmake fortune-mod cowsay htop, tree, tmux, vim
  cli_packages=("git" "python3" "python3-pip" "curl" "vim" "tmux" "wget" "build-essential" "snapd")

  for package in "${cli_packages[@]}"; do
    echo "⚒️ Installing $package"
    sudo apt install -y "$package"

    # # Check if the package is already installed
    # if ! which $package > /dev/null; then
    #   # Install the package
    #   sudo apt install -y "$package" || echo "🐥 Unable to install $package"
    # else
    #   echo "🐣 $package is already installed"
    # fi
  done

  # Ask the user if they want to install GUI applications
  echo
  while true; do
    printf "🦋 Do you want to install GUI (desktop) applications as well? [Y/n]: "
    read install_gui
    install_gui=$(echo "$install_gui" | xargs) # Trim whitespace
    install_gui=${install_gui:-y}  # set default to 'y' if empty

    case "$install_gui" in
      y|Y|yes|YES|Yes|YeS|yEs|YEs) 
        gui_apps=("code" "slack" "google-chrome" "vlc")
        # Install GUI applications using snap
        for ap in "${gui_apps[@]}"; do
          echo "🏡 Installing $ap"
          sudo snap install --classic "$ap" || echo "Unable to install $ap"
          # # Check if the package is already installed
          # if ! which $package > /dev/null; then
          #   # Install the package
          #   sudo apt install -y "$package" || echo "🐥 Unable to install $package"
          # else
          #   echo "🐣 $package is already installed"
          # fi

          # snap install --classic code (for Visual Studio Code)
          # snap install slack --classic (for Slack)
          # gimp vlc steam spotify-client python-is-python3 guake
        done
        break
        ;;
      n|N|no|NO|No|nO ) 
        echo "📝 Skipping GUI apps..."
        break
        ;;
      * )
        echo "🎸 Please answer yes [y] or no [n]."
        ;;
    esac
  done

  # Ask the user if they want to install Jekyll 
  echo
  while true; do
    printf "🧪 Do you want to install Jekyll? [Y/n]: "
    read install_jekyll
    install_jekyll=$(echo "$install_jekyll" | xargs) # Trim whitespace
    install_jekyll=${install_jekyll:-y}  # set default to 'y' if empty

    case $install_jekyll in
      y|Y|yes|YES|Yes|YeS|yEs|YEs) 
        # Install Jekyll
        install_jekyll
        break;;
      n|N|no|NO|No|nO )
        echo "🗄️ Skipping Jekyll installation..."
        break;;
      * ) 
        echo "🎸 Please answer yes [y] or no [n]."
        ;;
    esac
  done
  
  # Ask the user if they want to install Re-volt
  echo
  while true; do
    printf "🏎️ Do you want to install Re-Volt? [Y/n]: "
    read install_revolt
    install_revolt=$(echo "$install_revolt" | xargs) # Trim whitespace
    install_revolt=${install_revolt:-y}  # set default to 'y' if empty

    case $install_revolt in
      y|Y|yes|YES|Yes|YeS|yEs|YEs) 
        echo "🚙 Installing Re-Volt..."
        # Install Re-Volt
        zsh $HOME/.dotfiles/revolt/install.zsh
        break;;
      n|N|no|NO|No|nO )
        echo "🗑️ Skipping Re-Volt installation..."
        break;;
      * )
        echo "🎸 Please answer yes [y] or no [n]."
        ;;
    esac
  done

  # Ask the user if they want to install Node.js
  echo
  while true; do
    printf "🚀 Do you want to install Node.js? [Y/n]: "
    read install_node
    install_node=$(echo "$install_node" | xargs) # Trim whitespace
    install_node=${install_node:-y}  # set default to 'y' if empty

    case $install_node in
      y|Y|yes|YES|Yes|YeS|yEs|YEs) 
        echo "🚀 Installing Node.js..."
        # Installing Node.js dependencies...
        npm config set loglevel warn
        npm install -g npm-upgrade
        npm install
        break;;
      n|N|no|NO|No|nO )
        echo "🗂️ Skipping Node.js installation..."
        break;;
      * )
        echo "🎸 Please answer yes [y] or no [n]."
        ;;
    esac
  done

  # fzf, fuzzy finder
  # echo "🌁 Configuring fzf..."
  # $(brew --prefix)/opt/fzf/install
  # echo

  echo "⚙️ Updating & Upgrading & Autoremoving"
  sudo apt update
  sudo apt upgrade
  sudo apt autoremove
  sudo apt clean

elif [[ $unamestr == "Darwin" ]]; then
  printlog "🌲 Platform detected as macOS. Installing accordingly."

  # Ask the user if they want to install GUI applications
  while true; do
    printf "🦋 Do you want to install GUI (desktop) applications as well? [Y/n]: "
    read install_gui

    install_gui=$(echo "$install_gui" | xargs) # Trim whitespace
    install_gui=${install_gui:-y}  # set default to 'y' if empty
    case "$install_gui" in
      y|Y|yes|YES|Yes|YeS|yEs|YEs) 
        echo "☕️ Installing Homebrew dependencies...\n🏡 Setting up GUI apps..."
        brew bundle install --file="$HOME/.dotfiles/setup/Brewfile"
        break
        ;;
      n|N|no|NO|No|nO ) 
        # to install only CLI tools (strip cask lines)
        echo "☕️ Installing Cli tools and libraries... \n📝 Skipping GUI apps..."
        grep -v '^cask ' "$HOME/.dotfiles/setup/Brewfile" > "$HOME/.dotfiles/setup/Brewfile.cli"
        brew bundle install --file="$HOME/.dotfiles/setup/Brewfile.cli"
        # rm "$HOME/.dotfiles/setup/Brewfile.cli"
        break
        ;;
      * )
        echo "🎸 Please answer yes [y] or no [n]."
        ;;
    esac
  done

  # Installing pip
  # python3 -m ensurepip --upgrade

  # Installing custom fonts
  install_fonts

fi




