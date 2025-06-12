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

- Generate SSH key. (Optional)
    - Follow the instructions in ssh/ssh_key.md 

- Run the preparation script. This script does the following;  
    - installs and changes your default shell to zsh.  
    - installs git   
    - setup a ssh key(if already not exist) and uploads it to the GitHub.  
    - clones this dotfiles repository.  
     <!-- # depending on the $SHELL use bash or zsh:
      bash/zsh .dotfiles/setup/prerequisites.sh -->

```
$ curl -o https://raw.githubusercontent.com/simgeekiz/dotfiles/refs/heads/master/setup/prerequisites.sh    
$ [ -x /bin/zsh ] && /bin/zsh prerequisites.sh || bash prerequisites.sh
```
<!-- 
      Or
      -Install git and
      # Clone the repository
      git clone git@github.com:simgeekiz/dotfiles.git ~/.dotfiles 
      or
      # If you don't want to use the SSH link (uses SSH key) Use HTTPS link.
      git clone https://github.com/simgeekiz/dotfiles.git ~/.dotfiles  -->

## __Installation__

- Check zsh installed and it is your current shell.  

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