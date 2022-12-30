#!/bin/bash
#title          : assign-directory-ownership.sh
#description    : Assign/reassign owners and groups to a list of files and
#                 directories defined in a file or STDIN. Optionally, POSIX
#                 ACLs can be assigned/reassigned instead. Note that existing
#                 ACLs on a file/directory will be wiped before the
#                 assignment/reassignment.
#author         : Jarrod N. Bakker
#date           : 15/06/2021
#version        : 0.1.0
#usage          : See disaply_usage() function below.
#history        : 16/06/2020 - jb - Draft version complete.
#===============================================================================
PATH=/bin:/usr/bin:/sbin:/usr/sbin:/usr/local/bin
export PATH

display_usage() {
    cat <<HELP_USAGE
Usage: $0 -h [-a] ownership

Assign/reassign owners and groups to a list of files and directories defined in
a file or STDIN. Optionally, POSIX ACLs can be assigned/reassigned instead.
Note that existing ACLs on a file/directory will be wiped before the
assignment/reassignment.

The values in the file/STDIN will need to be comma separated with one entry per
line and formatted as follows:
     1. For owners and groups

user1,groupA,/home/user1
user2,groupB,/home/user2
...

     2. For POSIX ACLs

user:user1:rwx,/misc/some/directory
default:groupB:r-x,/misc/some/other/directory
group:groupB:r-x,/misc/some/other/directory
...

Required:
  ownership The file that lists the ownership and groups, or POSIX ACLs that
            need to be set. STDIN can be used instead.

Options:
  -a        Indicates that the ownership information contains POSIX ACLs
            instead of 'regular' owners and groups.
  -h        Display this message and exit
HELP_USAGE
}

display_uid() {
    cat <<HELP_UID
This script must be run as root/the superuser i.e. uid=0
You are: $(id -un) (uid=$(id -u))
HELP_UID
}

log_info() {
    echo -e "`date '+%Y-%m-%d %H:%M:%S'` INFO $1"
}

log_warn() {
    echo -e "`date '+%Y-%m-%d %H:%M:%S'` WARN $1"
}

# Assign/reassign POSIX ACLs to a series of files and/or directories. These are
# defined in a file/STDIN.
#
# The values in the file/STDIN will need to be comma separated with one entry
# per line and formatted as follows:
#
# user1,groupA,/home/user1
# user2,groupB,/home/user2
# ...
#
# $1 -> audit_file: File (or STDIN) that lists the POSIX ACLs to be applied for
#                   a series of files and/or directories.
assign_posix_acls() {
    audit_file=$1
    
    log_info "Clearing existing ACLs from files and directories..."
    # Wipe all existing ACLs first
    while read -r line; do
        IFS=','
        read acl_spec path <<< "$line"

        # Check if the path is valid. Log a message if it doesn't and continue.
        if [[ ! -e ${path} ]]; then
            log_warn "The path '${path}' does not exist, skipping..."
            continue
        fi

        log_info "Removing ACLs from ${path}"
        setfacl -b ${path}
    done < "$audit_file"

    log_info "Assigning ACLs to files and directories..."
    while read -r line; do
        IFS=','
        read acl_spec path <<< "$line"
        
        # Check if the path is valid. Log a message if it doesn't and continue.
        if [[ ! -e ${path} ]]; then
            log_warn "The path '${path}' does not exist, skipping..."
            continue
        fi

        # Parse the ACL spec so that we can determine if the user/group exist.
        IFS=':'
        read -a spec_arr <<< "$acl_spec"
        # An ACL spec can have either 3 or 4 components depending on whether it
        # is a default ACL or not.
        is_default=0
        obj_type=''
        obj=''
        perm=''
        if [[ ${#spec_arr[@]} -eq 3 ]]; then
            obj_type=${spec_arr[0]}
            obj=${spec_arr[1]}
            perm=${spec_arr[2]}
        else
            is_default=1
            obj_type=${spec_arr[1]}
            obj=${spec_arr[2]}
            perm=${spec_arr[3]}
        fi

        # Check if the user/group exists. If it doesn't then we'll skip this
        # ACL as it would be invalid and we'll log this to the terminal.
        if [[ ${obj_type} == "user" ]]; then
            id -u ${obj} > /dev/null 2>&1
            id_result=$?
            if [[ id_result -ne 0 ]]; then
                log_warn "User '${obj}' does not exist, skipping ACL \
'${acl_spec}' on path '${path}'"
                continue
            fi
        elif [[ ${obj_type} == "group" ]]; then
            getent group ${obj} > /dev/null 2>&1
            getent_result=$?
            if [[ getent_result -ne 0 ]]; then
                log_warn "Group '${obj}' does not exist, skipping ACL \
'${acl_spec}' on path '${path}'"
                continue
            fi
        else
            log_warn "ACL object type '${obj_type}' is invalid, skipping ACL \
'${acl_spec}' on path '${path}'"
            continue
        fi

        comm=''
        # Assign the ACL to the file/directory
        if [[ is_default -eq 0 ]]; then
            comm="setfacl -m ${obj_type}:'${obj}':${perm} ${path}"
        else
            comm="setfacl -m default:${obj_type}:'${obj}':${perm} ${path}"
        fi
        log_info "Executing command: ${comm}"
        eval "${comm}"
    done < "$audit_file"
}

# Assign/reassign owners and groups to a series of files and/or directories.
# These are defined in a file/STDIN.
#
# The values in the file/STDIN will need to be comma separated with one entry
# per line and formatted as follows:
#
# user:user1:rwx,/misc/some/directory
# default:groupB:r-x,/misc/some/other/directory
# group:groupB:r-x,/misc/some/other/directory
# ...
#
# $1 -> audit_file: File (or STDIN) that lists the owners and groups to be
#                   applied for a series of files and/or directories.
assign_posix_ownership() {
    audit_file=$1

    while read -r line; do
        IFS=','
        read user group path <<< "$line"
        
        # Check if the path is valid. Log a message if it doesn't and continue.
        if [[ ! -e ${path} ]]; then
            log_warn "The path '${path}' does not exist, skipping..."
            continue
        fi
        # Check if the user still exists. No problem if it doesn't, we'll just
        # make a note of it via a warning message.
        id -u ${user} > /dev/null 2>&1
        id_result=$?
        if [[ id_result -ne 0 ]]; then
            log_warn "User '${user}' does not exist, please manually check \
the path '${path}'"
        fi
        # Check if the group still exists. No problem if it doesn't, we'll just
        # make a note of it via a warning message.
        getent group ${group} > /dev/null 2>&1
        getent_result=$?
        if [[ getent_result -ne 0 ]]; then
            log_warn "Group '${group}' does not exist, please manually check \
the path '${path}'"
        fi

        # Assign the ownership and group to the file/directory
        comm="chown '${user}':'${group}' $path"
        log_info "Executing command: ${comm}"
        eval "${comm}"
    done < "$audit_file"
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

# Has the user supplied the correct number of arguments or are they using
# STDIN for supplying the data?
[[ -t 0 && $# -ne 1 ]] && display_usage && exit 1
### SANITY CHECKS DONE ###

AUDIT_FILE="${1:-/dev/stdin}"

if [[ $ACL_MODE -eq 1 ]]; then
    assign_posix_acls $AUDIT_FILE
else
    assign_posix_ownership $AUDIT_FILE
fi
