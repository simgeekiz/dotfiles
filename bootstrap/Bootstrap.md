What am I installing and what are the step?

- Starting a system from nothing and preparing it.
- install packages
- create symlinks
- detect OS and configure shell
- run first-time setup
- prepare the environment

#### **Prerequisites:**

1. Generate SSH key (if already not exist) and uploads it to the GitHub.

   > Follow the instructions in ssh/ssh_key.md

2. Install and change your default shell to zsh.

3. Install git

```
  $ sudo apt update && sudo apt install -y git
```

4. Clone dotfiles repository.

```
  $ git clone git@github.com:simgeekiz/dotfiles.git ~/.dotfiles

  # If you don't want to use the SSH link (uses SSH key) Use HTTPS link.
  $ git clone https://github.com/simgeekiz/dotfiles.git ~/.dotfiles
```

5. Restart your terminal

```
$ exec /bin/zsh
```

6. Check zsh installed and it is your current shell.

```
$ command -v zsh >/dev/null 2>&1 && [ -n "$ZSH_VERSION" ] && echo "Zsh: $ZSH_VERSION " || echo "Zsh not installed or not current shell"
```

Or **Run the preparation script. (prerequisites.sh):**

This script does the steps above;

```
  $ curl -o prerequisites.sh https://raw.githubusercontent.com/simgeekiz/dotfiles/refs/heads/master/bootstrap/prerequisites.sh
  $ sh prerequisites.sh

```

## **Installation**

- Check zsh installed and it is your current shell.

- Run setup script:

```
  $ sh ./.dotfiles/bootstrap/setup.sh
```

- Check if Zsh is installed
- Asks to install sofware
  - Chrome, Visual Studio Code, GUAKE Terminal, Slack
  - git python3 python3-pip curl tmux wget build-essential gpg
- Symlink
