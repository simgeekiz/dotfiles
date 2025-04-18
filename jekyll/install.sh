#!/bin/bash
sudo apt-get install ruby-full build-essential zlib1g-dev

if [ -f "$HOME/.localrc" ]; then
    echo "$HOME/.localrc exists. Using the original file"
else 
    echo "$HOME/.localrc does not exist. creating one"
    touch $HOME/.localrc
    chmod 755 $HOME/.localrc 
fi 

echo '# Install Ruby Gems to ~/gems' >> ~/.localrc
echo 'export GEM_HOME="$HOME/gems"' >> ~/.localrc
echo 'export PATH="$HOME/gems/bin:$PATH"' >> ~/.localrc

source ~/.bashrc

sudo gem install jekyll bundler

# Then follow the instruction from your project 
# Probably the steps are following:
# $ bundle config set --local path 'vendor/bundle'
# $ bundle install
# Then Go to the project folder where you can find Gemfile.
# $ cd <path_to_dashboard_repository> 
# Run the server.
# $ bundle exec jekyll serve 
