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

## __Prerequisites Linux:__  

Ensure you have git and zsh installed.  

1. Install Zsh 

        $ echo $SHELL

    If it returns /bin/zsh → You're using zsh  
    
    If it returns /bin/bash → You're using bash 
    Please continue to install zsh

    - If zsh not already installed   
      
          $ sudo apt install zsh
        
    - Change the default shell:

          $ chsh -s $(which zsh)
          $ reboot

2. Install git  
 
        $ sudo apt-get install git   
        or   
        $ sudo apt install git  

## __Prerequisites MacOS:__

Ensure you have brew and git.

1. Install brew

        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

        echo >> /Users/sekiz/.zprofile
        echo 'eval "$(/usr/local/bin/brew shellenv)"' >> ~/.zprofile
        eval "$(/usr/local/bin/brew shellenv)"

        # verify the installation
        brew --version

2. Install git 

        brew install git

## __Installation__
- Generate SSH key.
    - Follow the instructions in ssh/ssh_key.md
    
- Clone this repository

      # Clone the repository
      git clone git@github.com:simgeekiz/dotfiles.git ~/.dotfiles 

- If you don't want to use the SSH link (uses SSH key) Use HTTPS link.
       
      # Clone the repository
      git clone https://github.com/simgeekiz/dotfiles.git ~/.dotfiles 

- Run setup script:

      zsh ./.dotfiles/git/git_setup.zsh
      zsh  ./.dotfiles/setup/install.zsh  
      

## __Resources__

- [GitHub ~/](http://dotfiles.github.io/)
- [Erkan's dotfiles](https://github.com/ErkanBasar/dotfiles)
- [Sapegin's dotfiles](https://github.com/sapegin/dotfiles)
---