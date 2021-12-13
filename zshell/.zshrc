#!/bin/bash

# if running bash

# Load alias definitions.
if [ -f $HOME/.zsh_aliases ]; then
    source $HOME/.zsh_aliases
fi

# set PATH so it includes user's private bin directories
PATH="$HOME/bin:$HOME/.local/bin:$PATH"
export PATH="$PATH:/Library/Frameworks/Python.framework/Versions/3.8/bin"
# PATH=$PATH:/Users/sekiz/Library/Python/3.7/bin/
