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

if [ -d "~/bin" ]; then
    echo "Directory already exists (skipping creation): \"$HOME/bin\""
else
    echo "Directory does not exist (creating): "$HOME/bin""
    #TODO: mkdir "$HOME/bin"
    echo "Setting permissions on \"$HOME/bin\" to octal 700..."
    #TODO: chmod 700 "$HOME/bin"
fi

# Append ~/bin $HOME/bin to PATH
if [ ! -z $(grep 'PATH=$PATH' "$HOME/.bash_profile") ]; then echo "FOUND"; fi
#TODO grep the above grep command for ~/bin or $HOME/bin
#TODO back-up the .bash_profile file before editing it: cp -p "$HOME/.bash_profile" "$HOME/.bash_profile.`date+%F`"

