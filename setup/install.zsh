create_symbolic_link() {
  local source_file="$1"
  local destination_file="$2"
  sudo ln -sfn "$source_file" "$destination_file"
  echo "Symbolic link created: $source_file -> $destination_file"
}

is_file_exists() {
  local source_file="$1"

  # note -e → Checks if the file or directory exists, regardless of type.
  # -f → Checks if the path exists and is a regular file (not a directory, symlink to a directory, etc.).
  # -n -n is used in Bash to test whether a string is non-empty. Which is always true, because the string /home/youruser/.bashrc is non-empty.
  #    It does not check if the file exists — only that the string path is not empty.
  if [[ -e "$source_file" ]]; then
    return 0  # success
  else
    return 1  # failure
  fi
}

printlog () {
    echo
    echo "---------------------------------------------------------------------------" >&2
    echo "$1"
    echo "---------------------------------------------------------------------------" >&2
}

# Testing the is_file_exist function
# isFile=$(is_file_exists "$HOME/.bashrc")
# echo "$isFile"

# Get operating system
unamestr=$(uname)
if [[ $unamestr == "Linux" ]]; then
  printlog 'Platform detected as Linux. Installing accordingly.'

  # Having a little bit fun
  sudo apt install fortune-mod
  sudo apt install cowsay

  # Installing Tmux
  sudo apt install tmux

  # Installing pip and python environment
  sudo apt-get install python3-pip
  apt install python3.10-venv
  
elif [[ $unamestr == "Darwin" ]]; then
  printlog "Platform detected as macOS. Installing accordingly."
fi

if [ -n "$BASH_VERSION" ]; then
  printlog "You are running Bash (version: $BASH_VERSION)"
  
  #### Creating Symlinks
  if is_file_exists "$HOME/.bashrc"; then
    mv $HOME/.bashrc $HOME/.bashrc_old
  fi
  create_symbolic_link $HOME/.dotfiles/shell/.bashrc $HOME/.bashrc 
  create_symbolic_link $HOME/.dotfiles/shell/.bash_aliases $HOME/.bash_aliases
  create_symbolic_link $HOME/.dotfiles/shell/.bash_history $HOME/.bash_history
  create_symbolic_link $HOME/.dotfiles/shell/.bash_logout $HOME/.bash_logout
  create_symbolic_link $HOME/.dotfiles/shell/.profile $HOME/.profile 

  # echo "-------------------------Github configurations-------------------------"
  # bash  $HOME/.dotfiles/git/git_setup.zsh 
  
  #Install jekyll
  # bash $HOME/.dotfiles/jekyll/install.zsh

  #Install Re-volt
  #bash $HOME/.dotfiles/re-volt/install.zsh

elif [ -n "$ZSH_VERSION" ]; then
  printlog "You are running Zsh (version: $ZSH_VERSION)"

  #### Creating Symlinks
  if is_file_exists "$HOME/.zshrc"; then
    mv $HOME/.zshrc $HOME/.zshrc_old
  fi
  create_symbolic_link $HOME/.dotfiles/zshell/.zshrc $HOME/.zshrc 
  create_symbolic_link $HOME/.dotfiles/zshell/.zsh_aliases $HOME/.zsh_aliases
  create_symbolic_link $HOME/.dotfiles/zshell/.zsh_history $HOME/.zsh_history

  # echo "-------------------------Github configurations-------------------------"
  # zsh $HOME/.dotfiles/git/git_setup.zsh

  #Install jekyll
  # zsh $HOME/.dotfiles/jekyll/install.zsh

  #Install Re-volt
  #zsh $HOME/.dotfiles/re-volt/install.zsh

else
  echo "You are running an unknown shell: $SHELL"
fi

echo "Restarting Terminal"  
exec $SHELL
