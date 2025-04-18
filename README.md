# dotfiles
My natural habitat  



__Assuming you have fresh operating system installed;__ 

<!-- Along these steps I am installing 
    chrome
    Visual Studio (sync with github not microsoft)
    From software manager: 
    Slack 
    GUAKE terminal
-->

1. First you need to install git
        
        # Make sure you have git   
        sudo apt-get install git   
        or   
        sudo apt install git  

2. Clone this repository

        <!-- git clone https://github.com/simgeekiz/dotfiles.git -->  
        
        git clone https://github.com/simgeekiz/dotfiles.git ~/.dotfiles 
        cd ~/.dotfiles

    or 

        # Clone the repository
        git clone github_repository_dotfiles
        # rename the repository
        mv dotfiles .dotfiles

4. If you want change bash to zsh:  

        $ sudo apt install zsh
        Change the default shell:
        $ chsh -s $(which zsh)
        $ reboot

3. Installation:

        bash ./.dotfiles/setup/install.zsh 
        or 
        zsh  ./.dotfiles/setup/install.sh  

    or

        # define the symlinks by yourself
        sudo ln -sfn $HOME/.dotfiles/zshell/.zshrc $HOME/.zshrc  
        sudo ln -sfn $HOME/.dotfiles/shell/.zsh_history $HOME/.zsh_history
        sudo ln -sfn $HOME/.dotfiles/shell/.zsh_aliases $HOME/.zsh_aliases 

