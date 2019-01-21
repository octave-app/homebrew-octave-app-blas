#!/bin/bash
set -ev

# Install LinuxBrew.
sudo apt-get update

HOME=/home/linuxbrew  # install linuxbrew here so we can install the glibc bottle
sudo mkdir $HOME
sudo chown "$USER:" $HOME
LINUXBREW=$HOME/.linuxbrew
git clone https://github.com/Linuxbrew/brew $LINUXBREW
