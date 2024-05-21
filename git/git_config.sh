#!/bin/bash
#title          :git_config.sh
#description    :Script for configuring git.
#author         :Jarrod N. Bakker
#date           :19/09/2016
#usage          :bash git_config.sh
#========================================================================
git config --global user.name "Jarrod N. Bakker"
git config --global user.email jarrodbakker@hotmail.com
git config --global core.editor vim
git config --global push.default simple
git config --global init.defaultBranch main
ssh-keyscan github.com >> ~/.ssh/known_hosts
