### 1. Check for existing SSH keys.

First, check whether you already have any SSH keys:

` ls -al $HOME/.ssh`

If you already have an SSH key, you don't need to generate another one.
If you need a new SSH key, continue to the next step.

### 2. Generating a new SSH key

Generate an Ed25519 SSH key using your email address:
`ssh-keygen -t ed25519 -C "email@example.com"`

When prompted for the file location, you can press Enter to use the default:

`/home/your-user/.ssh/id_ed25519`

#### Add Another SSH Key

If you already have a personal SSH key and want to add a separate work key, generate the work key with a different filename:

    ```
    ssh-keygen -t ed25519 -C "work@email.com" -f ~/.ssh/id_ed25519_work
    ```

This gives you:
`     ~/.ssh/id_ed25519_work
    ~/.ssh/id_ed25519_work.pub
    `

Your existing personal key remains untouched:
` ~/.ssh/id_ed25519
~/.ssh/id_ed25519.pub

### 3. Adding your SSH key to the ssh-agent

If this is added one time there is no need to add it again so check if there is something then decide wheteher to add or not

    ```
    #Start the ssh-agent in the background.
    $ eval "$(ssh-agent -s)"

    Check whether your key is already loaded:
    ssh-add -l

    # If it is not listed, Add your SSH private key to the ssh-agent.
    ssh-add ~/.ssh/id_ed25519

    # or a work key:
    ssh-add ~/.ssh/id_ed25519_work

    # You can verify the keys currently loaded with:
    ssh-add -l
    ```

### 4. Adding a new SSH key to your account

Then select and copy the contents of the id_ed25519.pub file displayed in the terminal to your clipboard paste it to your Github/GitLab account SSH and GPG keys section

    ```
    cat ~/.ssh/id_ed25519.pub
    cat ~/.ssh/id_ed25519_work.pub
    ```

### 5. Verify that you can connect

Replace hostname with your GitLab/Github instance’s hostname

    ```
    For GitHub:
    ssh -T git@github.com
    For GitLab:
    ssh -T git@gitlab.com
    ```

If you are using a custom GitLab/GitHub instance, replace the hostname accordingly.

### Configure Multiple SSH Keys

If you use different GitHub accounts, create or edit:

~/.ssh/config

Example:
in my case

```text
# Company GitLab
Host mycompany.gitlab.host
    HostName mycompany.gitlab.host
    User git
    IdentityFile ~/.ssh/id_ed25519_work
    IdentitiesOnly yes


# Everything else (GitHub, GitLab.com, Bitbucket, etc.)
Host *
    User git
    IdentityFile ~/.ssh/id_ed25519
    IdentitiesOnly yes
```

You can then use the appropriate SSH alias when cloning repositories.

**Personal repository**
`git clone git@github.com:personal-username/project.git` or
`git clone git@gitlab.com:personal-username/project.git`

**Work repository**
`git clone git@github-work:work-organization/project.git`

**For an existing repository, change its remote:**
`git remote set-url origin git@github-work:work-organization/project.git`

### Set Git Email Per Project

SSH keys determine which account authenticates with GitHub/GitLab. Your Git email determines which email is attached to your commits.

```
    # For a work project:
    git config user.name "Your Work Name"
    git config user.email "work@email.com"

    # For a personal project:

    git config user.name "Your Personal Name"
    git config user.email "personal@email.com"

    # Check the configuration:
    git config --local --list
    # Or check only the email:
    git config user.email
```

### Remove ssh keys

    # To remove a key from your local machine:
    rm ~/.ssh/id_ed25519
    rm ~/.ssh/id_ed25519.pub

    # For the work key:
    rm ~/.ssh/id_ed25519_work
    rm ~/.ssh/id_ed25519_work.pub

```

### **Resources**

---

- [Gitlab SSH Key](https://docs.gitlab.com/ee/user/ssh.html)
- [Generate a new ssh key](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent#generating-a-new-ssh-key)
- [Adding a ssh key to your account](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account)

---
```
