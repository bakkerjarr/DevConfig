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

perform_git_config() {
    git config --global user.name "Jarrod N. Bakker"
    git config --global user.email "jarrodbakker@hotmail.com"
    git config --global core.editor vim
    git config --global push.default simple
}

print_bash_aliases() {
    cat <<CONTENT_BASH_ALIASES

# User specific aliases and functions
alias psc='ps xawf -eo pid,user,cgroup,args'

CONTENT_BASH_ALIASES
}

print_vimrc() {
    cat <<CONTENT_VIMC
" Turn on the ruler for cursor position
set ruler

" Show line numbers
set nu

" use arrow keys and other useful things
set nocompatible

" size of a hard tabstop
set tabstop=4

" size of an 'indent'
set shiftwidth=4

" a combination of spaces and tabs are used to simulate tab stops at a width
" other than the (hard)tabstop
set softtabstop=4

" always uses spaces instead of tab characters
set expandtab

" use auto-indentation
set autoindent

" syntax highlighting
syntax on

" Map keys for switching tabs (previous then next)
map <F7> :tabp<CR>
map <F8> :tabn<CR>

" Draw a verticle line at column 81 to establish a boundary for lines
highlight ColorColumn ctermbg=lightgrey guibg=lightgrey
set colorcolumn=81

CONTENT_VIMC
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
echo

# Append $HOME/bin to PATH
if [ ! -z $(grep 'PATH=$PATH' "$HOME/.bash_profile" | grep '$HOME/bin\|~/bin') ]; then
    echo "\"$HOME/.bash_profile\" already has \"\$HOME/bin\" or \"~/bin\" set in the PATH variable"
else
    echo "Adding \"\$HOME/bin\" to the PATH variable in \"$HOME/.bash_profile\"..."
    #cp -p "$HOME/.bash_profile" "$HOME/.bash_profile.`date +%F`"
    #sed -i '/^PATH=\$PATH/ s/$/\:\$HOME\/bin/' "$HOME/.bash_profile"
fi
echo

# Copy your user's bin scripts to $HOME/bin
echo "Copying scripts to \"$HOME/bin\"..."
#cp -i "./bin_scripts/*" "$HOME/bin"
#chmod -R 700 "$HOME/bin"
echo

# Configure user bash aliases
echo "Inserting user bash aliases into \"$HOME/bin\"..."
#cp -p "$HOME/.bashrc" "$HOME/.bashrc.`date +%F`"
#print_bash_aliases >> "$HOME/.bashrc"
echo

# Import my personal vi/vim configuration
if [ -f "$HOME/.vimrc" ]; then
    echo "WARNING: \"$HOME/.vimrc\" already exists and will be backed up"
    #cp -p "$HOME/.vimrc" "$HOME/.vimrc.`date +%F`"
fi
echo "Creating personal vi/vim configuration at \"$HOME/.vimrc\"..."
#print_vimrc > "$HOME/.vimrc"
#TODO if the system is Debian-based then insert the following at the top of .vimrc: runtime! debian.vim
echo

# Configure your user's Git client if it is installed
if ! which git > /dev/null 2>&1 ; then
    echo "Git is not currently installed, skipping Git client configuration"
else
    echo "Configuring Git client..."
    #perform_git_config
fi
echo
