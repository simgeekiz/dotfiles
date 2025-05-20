# dotfiles
                         /\_/\      *What's going on?*
                        ( o.o )
                      ------------

My natural habitat  



### __Assuming you have fresh operating system installed;__ 

<!-- Along these steps I am installing 
    chrome
    Visual Studio (sync with github not microsoft)
    From software manager: 
    # Slack 
    GUAKE terminal
-->

## __Prerequisites:__  

Ensure you have; 
- git

- Generate SSH key.
    - Follow the instructions in ssh/ssh_key.md
    
- Clone this repository

      # Clone the repository
      git clone git@github.com:simgeekiz/dotfiles.git ~/.dotfiles 

- If you don't want to use the SSH link (uses SSH key) Use HTTPS link.
       
      # Clone the repository
      git clone https://github.com/simgeekiz/dotfiles.git ~/.dotfiles 


## __Installation__

- Check zsh installed and it is your current shell.  

      # depending on the $SHELL use bash or zsh:
      bash/zsh .dotfiles/setup/prerequisites.sh

- Run setup script:

      zsh ./.dotfiles/setup/setup.zsh 

## __Resources__

- [GitHub ~/](http://dotfiles.github.io/)
- [Erkan's dotfiles](https://github.com/ErkanBasar/dotfiles)
- [Sapegin's dotfiles](https://github.com/sapegin/dotfiles)
- [Paulmillr's dotfiles](https://github.com/paulmillr/dotfiles)
- [Mathiasbynens's dotfiles](https://github.com/mathiasbynens/dotfiles)
- [Lewagon's dotfiles](https://github.com/lewagon/dotfiles)
- [Holman's dotfiles](https://github.com/holman/dotfiles)

---