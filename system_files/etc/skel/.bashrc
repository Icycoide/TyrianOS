# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]; then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
if [ -d ~/.bashrc.d ]; then
    for rc in ~/.bashrc.d/*; do
        if [ -f "$rc" ]; then
            . "$rc"
        fi
    done
fi
unset rc

# History file
shopt -s histappend
HISTSIZE=1000
HISTFILESIZE=1000

echo "You're currently inside a system shell session. For a fully mutable envrionment where you may install programs freely, please refer to the Toolbx documentation at: 'https://docs.fedoraproject.org/en-US/fedora-silverblue/toolbox/'. "
