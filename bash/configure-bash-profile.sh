#!/bin/bash
#title          : configure-bash-profile.sh
#description    : Setup a bash profile file (~/.profile or ~/.bash_profile) with
#                 my usual stuff. This script writes to STDOUT so that it can be
#                 redirected to the desired file.
#author         : Jarrod N. Bakker
#date           : 07/07/2023
#version        : 1.0.0
#usage          : See disaply_usage() function below.
#history        : 07/07/2023 - jb - Initial version complete.
#===============================================================================


PATH=/bin:/usr/bin:/sbin:/usr/sbin:/usr/local/bin
export PATH

display_usage() {
    cat <<HELP_USAGE
Usage: $0 -h

Setup a bash profile file (~/.profile or ~/.bash_profile) with my usual stuff.
This script writes to STDOUT so that it can be redirected to the desired file.

For example:

    $ $0 >> ~/.bash_profile

Options:
  -h        Display this message and exit
HELP_USAGE
}

write_profile_config() {
    cat <<PROFILE_CONFIG

# Environment variables for login shells
export EDITOR=/usr/bin/vi
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
