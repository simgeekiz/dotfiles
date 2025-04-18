# From https://github.com/lewagon/dotfiles/blob/master/git_setup.sh
echo "Type in your first and last name (no accent or special characters - e.g. 'ç'): "
read full_name

echo "Type in your email address (the one used for your GitHub account): "
read email

git config --global user.email "$email"
git config --global user.name "$full_name"
git config --global init.defaultBranch main

echo "👌 Awesome, all set."