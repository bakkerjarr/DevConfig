#!/usr/bin/env python3          

import argparse
import sys


__author__ = "Jarrod N. Bakker"


# The string to be replaced is shown below.
#
# if [ "$color_prompt" = yes ]; then
#     PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
# else
#     PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
# fi
# unset color_prompt force_color_prompt
TARGET = "if [ \"$color_prompt\" = yes ]; then\n    PS1='${" \
         "debian_chroot:+($debian_chroot)}\\[\\033[01;32m\\]\\u@\\h\\[" \
         "\\033[00m\\]:\\[\\033[01;34m\\]\\w\\[\\033[00m\\]\\$ " \
         "'\nelse\n    PS1='${debian_chroot:+(" \
         "$debian_chroot)}\\u@\\h:\\w\\$ '\nfi\nunset color_prompt " \
         "force_color_prompt"

# The replacement string is shown below.
#
# parse_git_branch() {
#   git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
# }
# if [ "$color_prompt" = yes ]; then
#     PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[01;31m\]$(parse_git_branch)\[\033[00m\]\$ '
# else
#     PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w$(parse_git_branch)\$ '
# fi
# unset color_prompt force_color_prompt
REPLACEMENT = "parse_git_branch() {\n    git branch 2> /dev/null | " \
              "sed -e '/^[^*]/d' -e 's/* \\(.*\\)/(\\1)/'\n}\nif [ " \
              "\"$color_prompt\" = yes ]; then\n    PS1='${" \
              "debian_chroot:+($debian_chroot)}\\[\\033[" \
              "01;32m\\]\\u@\\h\\[\\033[00m\\]:\\[\\033[" \
              "01;34m\\]\\w\\[\\033[01;31m\\]$(parse_git_branch)\\[" \
              "\\033[00m\\]\\$ '\nelse\n    PS1='${debian_chroot:+(" \
              "$debian_chroot)}\\u@\\h:\\w$(parse_git_branch)\\$ " \
              "'\nfi\nunset color_prompt force_color_prompt"


def process_bashrc(arg_input_path, arg_output_path):
    """Modify the input .bashrc file to print git branch names into
    the bah prompt.

    :param arg_input_path: Path of the input .bashrc file.
    :param arg_output_path: Path of the output .bashrc file. If None
    then write the result to the input .bashrc file.
    """
    in_path = arg_input_path
    out_path = arg_input_path if arg_output_path is None else \
        arg_output_path
    print("Input .bashrc path:\t%s\nOutput .bashrc path:\t%s" % (
        in_path, out_path))
    # Read everything in from the file at in_path
    try:
        f_input = open(in_path, 'r')
        input_contents = f_input.read()
        f_input.close()
    except IOError as err:
        print("Error reading data from '%s': %s" % (in_path, err))
        print("Exiting...")
        sys.exit(1)
    # Modify the contents
    if not input_contents.find(TARGET):
        print("%s does not contain the string:\n%s\n" % (in_path,
                                                         TARGET))
        print("Exiting...")
        sys.exit(1)
    modified_str = input_contents.replace(TARGET, REPLACEMENT)
    # Write the modifications to the file at out_path
    try:
        f_output = open(out_path, 'w')
        f_output.write(modified_str)
        f_output.close()
    except IOError as err:
        print("Error writing data to '%s': %s" % (out_path, err))
        print("Exiting...")
        sys.exit(1)
    print("Modifications completed!\nExiting...")


if __name__ == "__main__":
    scr_des = "A script to configure an input .bashrc file to print " \
              "git branch names into the bash prompt."
    parser = argparse.ArgumentParser(description=scr_des)
    input_help = "Path of an .bashrc file to process."
    parser.add_argument("input", metavar="INPUT", help=input_help)
    output_help = "Path to write the modified .bashrc file to."
    parser.add_argument("-o", "--output", dest="output",
                        help=output_help)
    args = parser.parse_args()
    process_bashrc(args.input, args.output)
