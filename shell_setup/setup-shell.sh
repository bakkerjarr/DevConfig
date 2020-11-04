#!/bin/bash
#title          : setup-shell.sh
#description    : TBD
#author         : Jarrod N. Bakker
#date           : XX/11/2020
#version        : X.Y.Z
#usage          : bash setup-shell.sh ...
#history        : 00-00-00 - jnb - Initial version
#==============================================================================
PATH=/bin:/usr/bin:/sbin:/usr/sbin:/usr/local/bin
export PATH

display_usage() {
    cat <<HELP_USAGE
Usage: $0 [options]

Options:
  -h        Display this message and exit
HELP_USAGE
}

echo "Hello. This script is designed to prepare your bash environment on" \
     "this Linux system."
read -p "Do you want to continue? (y/n) " -r && echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    exit 0
fi

# See if $HOME/bin already exists and create it if not
if [ -d "$HOME/bin" ]; then
    echo "Directory already exists (skipping creation): \"$HOME/bin\""
else
    echo "Directory does not exist (creating): "$HOME/bin""
    #mkdir "$HOME/bin"
    echo "Setting permissions on \"$HOME/bin\" to octal 700..."
    #chmod 700 "$HOME/bin"
fi

# Append $HOME/bin to PATH
if [ ! -z $(grep 'PATH=$PATH' "$HOME/.bash_profile" | grep '$HOME/bin\|~/bin') ]; then
    echo "\"$HOME/.bash_profile\" already has \"\$HOME/bin\" or \"~/bin\" set in the PATH variable"
else
    echo "Adding \"\$HOME/bin\" to the PATH variable in \"$HOME/.bash_profile\"..."
    #cp -p "$HOME/.bash_profile" "$HOME/.bash_profile.`date +%F`"
    #sed -i '/^PATH=\$PATH/ s/$/\:\$HOME\/bin/' "$HOME/.bash_profile"
fi

# Copy your user's bin scripts to $HOME/bin
echo "Copying scripts to \"$HOME/bin\"..."
#cp -i "./bin_scripts/*" "$HOME/bin"
#chmod -R 700 "$HOME/bin"

# Copy over the .vimrc
if [ -f "$HOME/.vimrc" ]; then
    echo "WARNING: \"$HOME/.vimrc\" already exists and will be backed up"
    #cp -p "$HOME/.vimrc" "$HOME/.vimrc.`date +%F`"
fi
#TODO if system is RHEL-based copy over vimrc to ~/ || if system is Debian-based copy over vimrc_debian to ~/

# Configure your user's git client if it is installed
#TODO Is git installed? -> which git