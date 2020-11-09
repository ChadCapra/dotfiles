#!/bin/bash

# Update apt for latest versions
sudo apt update

# Install vim, git, curl, wget, tmux, zsh
sudo apt install -y vim git curl wget tmux zsh

# Install oh-my-zsh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# end of script
echo "You have reached the end of the setup script"
