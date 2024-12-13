#!/bin/bash
#title          : configure-bashrc.sh
#description    : Configure the individual per-interactive-shell bash startup
#                 file (~/.bashrc) with my usual stuff. This script writes to
#                 STDOUT so that it can be redirected to the desired file.
#author         : Jarrod N. Bakker
#date           : 14/12/2024
#version        : 1.0.0
#usage          : See disaply_usage() function below.
#history        : 14/12/2024 - jb - Initial version complete.
#==============================================================================


PATH=/bin:/usr/bin:/sbin:/usr/sbin:/usr/local/bin
export PATH

display_usage() {
    cat <<HELP_USAGE
Usage: $0 -h

Configure the individual per-interactive-shell bash startup file (~/.bashrc)
with my usual stuff. This script writes to STDOUT so that it can be redirected
to the desired file.

For example:

    $ $0 >> ~/.bashrc

Options:
  -h        Display this message and exit
HELP_USAGE
}

write_profile_config() {
    cat <<PROFILE_CONFIG

# Check if the OS is based on Debian, Ubuntu or their derivatives
if [ "\$(grep -Ei 'debian|buntu|mint' /etc/*release)" ]; then
    # Redefine bash's primary prompt string (PS1) to include git branches
    GIT_PROMPT_FILE="/usr/lib/git-core/git-sh-prompt"
    if [ -f \$GIT_PROMPT_FILE ]; then    
        source $GIT_PROMPT_FILE
        if [ "\$color_prompt" = yes ]; then
            PS1='\${debian_chroot:+(\$debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\[\033[33m\]\$(__git_ps1 " (%s)")\[\033[00m\]\\$ '
        else
            PS1='\${debian_chroot:+(\$debian_chroot)}\u@\h:\w\$(__git_ps1 " (%s)")\\$ '
        fi
        unset color_prompt force_color_prompt
    fi

    # Configure fzf keybindings
    FZF_KEYBINDING_FILE="/usr/share/doc/fzf/examples/key-bindings.bash"
    if [ -f \$FZF_KEYBINDING_FILE ]; then
        source \$FZF_KEYBINDING_FILE
    fi
fi
PROFILE_CONFIG
}

# Thanks to https://medium.com/@Drew_Stokes/bash-argument-parsing-54f3b81a6a8f
# for the options parser below!
PARAMS=""
while (( "$#" )); do
    case "$1" in
        -h)
            display_usage
            exit 0
            ;;
        -*|--*=) # unsupported flags
            # Ignore as this script does not accept flags or arugments
            shift
            ;;
        *) # preserve positional arguments
            # Ignore as this script does not accept flags or arugments
            shift
            ;;
    esac
done

write_profile_config
