#!/bin/bash

# if running bash

# Load alias definitions.
if [ -f $HOME/.zsh_aliases ]; then
    source $HOME/.zsh_aliases
fi

echo $the_cow

# set PATH so it includes user's private bin directories
PATH="$HOME/bin:$HOME/.local/bin:$PATH"
export PATH="$PATH:/Library/Frameworks/Python.framework/Versions/3.10/bin"
export PATH=/usr/local/bin:$PATH
# PATH=$PATH:/Users/sekiz/Library/Python/3.7/bin/

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/sekiz/opt/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/sekiz/opt/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/Users/sekiz/opt/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/Users/sekiz/opt/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<
