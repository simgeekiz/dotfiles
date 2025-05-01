## Tips & Tricks

### Separate Git identity for work repositories

Assuming your work repositories are inside the `~/PIZZA` folder.

1. First create a separate Git config:

```
git config -f ~/work_project/.gitconfig user.email "work@email.com"
git config -f ~/work_project/.gitconfig user.name "Simge Ekiz"
```

2. Then create `~/.gitlocal` file:

```
[includeIf "gitdir:~/work_project/"]
    path = ~/work_project/.gitconfig
```

### Per repository Git identity

```
cd ~/new_repository
git config user.email "another@email"
git config user.name "Simge Ekiz"
```
