## 1. Check for existing SSH keys. 

        #Checking for existing SSH keys  
        ls -al $HOME/.ssh 
        
        if [ -d $SSHDIR ]; then
          if [ -f "$HOME/.ssh/id_rsa.pub" ]; then
            echo "$HOME/.ssh/id_rsa.pub exists."
          elif [ -f "$HOME/.ssh/id_ecdsa.pub" ]; then
            echo "$HOME/.ssh/id_ecdsa.pub exists."
          elif [ -f "$HOME/.ssh/id_ed25519.pub" ]; then
            echo "$HOME/.ssh/id_ed25519.pub exists."
          else
            echo "Generating a new SSH key"
            read -p "Please enter the email address you wish to create ssh key? " EMAIL
            ssh-keygen -t ed25519 -C "$EMAIL"
          fi 
        fi 

https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent#generating-a-new-ssh-key

## 2. Adding your SSH key to the ssh-agent

  if this is added one time there is no need to add it again so check if there is something then decide wheteher to add or not  

      #Start the ssh-agent in the background.
      $ eval "$(ssh-agent -s)"

      #Add your SSH private key to the ssh-agent.
      ssh-add ~/.ssh/id_ed25519

https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent

## 3. Adding a new SSH key to your account

  Then select and copy the contents of the id_ed25519.pub file displayed in the terminal to your clipboard paste it to your Github account SSH and GPG keys section

      cat ~/.ssh/id_ed25519.pub


  https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account

## 4. Verify that you can connect

Replace hostname with your GitLab/Github instance’s hostname

      ssh -T git@github.com 

### Remove ssh keys

    rm $HOME/.ssh/id_ed25519 
    rm -rf $HOME/.ssh/id_ed25519.pub 


https://docs.gitlab.com/ee/user/ssh.html