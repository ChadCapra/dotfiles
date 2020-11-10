#!/bin/bash

# Update apt for latest versions
sudo apt update

# Install vim, git, curl, wget, tmux, zsh
sudo apt install -y vim git curl wget tmux zsh

# Install oh-my-zsh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# config git
git config --global user.name "Chad Capra"
git config --global user.email chadcapra@gmail.com

echo "begin key gen"
# create ssh key
ssh-keygen -t ed25519 -C "chadcapra@gmail.com"

echo "show key"

# show public ssh-key to add to github
cat ~/.ssh/id_ed25519.pub

# pause to give user a chance to add
read -p "Press enter to continue"

# end of script
echo "You have reached the end of the setup script"
