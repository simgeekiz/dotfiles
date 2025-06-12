### 1. Check for existing SSH keys. 

    ls -al $HOME/.ssh 
        
If you don't already have an SSH key, continue to step generate a new SSH key to use for authentication. 

         
### 2. Generating a new SSH key

    ssh-keygen -t ed25519 -C "email@example.com"

### 3. Adding your SSH key to the ssh-agent

  If this is added one time there is no need to add it again so check if there is something then decide wheteher to add or not  

      #Start the ssh-agent in the background.
      $ eval "$(ssh-agent -s)"

      #Add your SSH private key to the ssh-agent.
      ssh-add ~/.ssh/id_ed25519


### 4. Adding a new SSH key to your account

  Then select and copy the contents of the id_ed25519.pub file displayed in the terminal to your clipboard paste it to your Github account SSH and GPG keys section

    cat ~/.ssh/id_ed25519.pub

### 5. Verify that you can connect

Replace hostname with your GitLab/Github instance’s hostname

    ssh -T git@github.com 
    or 
    ssh -T git@gitlab.com


### Remove ssh keys

    rm $HOME/.ssh/id_ed25519 
    rm -rf $HOME/.ssh/id_ed25519.pub 


### __Resources__
---
- [Gitlab SSH Key](https://docs.gitlab.com/ee/user/ssh.html)
- [Generate a new ssh key](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent#generating-a-new-ssh-key)
- [Adding a ssh key to your account](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account)

---
