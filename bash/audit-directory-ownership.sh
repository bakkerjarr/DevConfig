#!/bin/bash
#title          : audit-directory-ownership.sh
#description    : Fetch the owner and group of every file and directory under a
#                 parent directory and write the output to STDOUT. Optionally,
#                 a similar audit can be done but on POSIX ACLs instead. The
#                 fields in the output are comma-separated.
#author         : Jarrod N. Bakker
#date           : 11/06/2021
#version        : 0.1.0
#usage          : See disaply_usage() function below.
#history        : 14/06/2020 - jb - Draft version complete.
#===============================================================================
PATH=/bin:/usr/bin:/sbin:/usr/sbin:/usr/local/bin
export PATH

display_usage() {
    cat <<HELP_USAGE
Usage: $0 -h [-a] base_dir

Fetch the owner and group of every file and directory under a parent directory
and write the output to STDOUT. Optionally, a similar audit can be done but on
POSIX ACLs instead. The fields in the output are comma-separated.

Required:
  base_dir  The parent directory to audit. The audit recurses to get the
            required information from all children and grandchildren.

Options:
  -a        Write the POSIX ACLs of the parent directory and its children to
            STDOUT instead of the owner and group.
  -h        Display this message and exit
HELP_USAGE
}

display_uid() {
    cat <<HELP_UID
This script must be run as root/the superuser i.e. uid=0
You are: $(id -un) (uid=$(id -u))
HELP_UID
}

# Write the POSIX ACLs of a directory and its children to STDOUT
#
# $1 -> base_path: The base directory to recurse from.
audit_posix_acls() {
    base_path=$1

    while IFS= read -r -d $'\0' path; do
        getfacl -Ecs ${path} 2>/dev/null | awk '$0 !~ /::|getfacl:/' | sed -e '/^$/d' | awk -v path=$path '{print $0","path}'    
    done < <(find ${base_path} -print0)
}

# Write the user, group and path of a directory and its children to STDOUT
#
# $1 -> base_path: The base directory to recurse from.
audit_posix_ownership() {
    base_path=$1
    find ${base_path} -printf '%u,%g,%p\n'
}

### SANITY CHECKS ###
# Thanks to https://medium.com/@Drew_Stokes/bash-argument-parsing-54f3b81a6a8f
# for the options parser below!
ACL_MODE=0
PARAMS=""
while (( "$#" )); do
    case "$1" in
        -h)
            display_usage
            exit 0
            ;;
        -a) # supported flags
            ACL_MODE=1
            shift
            ;;
        -*|--*=) # unsupported flags
            echo "Unsupported flag supplied: $1" >&2
            display_usage
            exit 1
            ;;
        *) # preserve positional arguments
            PARAMS="$PARAMS $1"
            shift
            ;;
    esac
done
# set positional arguments in their proper place
eval set -- "$PARAMS"

# Check that we are running as root
[[ $(id -u) -ne 0 ]] && display_uid && exit 1

# Has the user supplied the correct number of arguments?
[[ $# -ne 1 ]] && display_usage && exit 1
### SANITY CHECKS DONE ###

BASE_PATH="$1"

if [[ $ACL_MODE -eq 1 ]]; then
    audit_posix_acls $BASE_PATH
else
    audit_posix_ownership $BASE_PATH
fi
