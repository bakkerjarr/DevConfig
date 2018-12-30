#!/bin/bash
#title          :bash_install_common_pkgs.sh
#description    :Script for install useful packages that I use on most
#	         Linux systems.
#author         :Jarrod N. Bakker
#date           :30/12/2017
#usage          :bash bash_install_common_pkgs.sh
#========================================================================
sudo apt-get update;
sudo apt-get upgrade -y;
sudo apt-get install vim tmux python python-dev python-pip python3 python3-dev python3-pip openssh-server -y;
sudo apt autoremove -y;

