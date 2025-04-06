# shellcheck shell=bash
# .bash_profile

# Check if the user has already completed the first time setup
if [ -f "/etc/.tuspending" ]; then
    konsole -e "$HOME/.firstsetup.sh"
fi

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
    . ~/.bashrc
fi

# User specific environment and startup programs
