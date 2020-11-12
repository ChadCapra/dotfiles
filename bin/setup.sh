#!/bin/bash

# Set Variables for script as desired
NAME="Chad Capra"
EMAIL="chadcapra@gmail.com"

SSH_KEY_TYPE="ed25519" 
SSH_KEY_PARAMS="-o -a 256" 
SSH_KEY_PATH="$HOME/.ssh/id_$SSH_KEY_TYPE"

GIT_REPO_PATH="git@github.com:ChadCapra/dotfiles.git"
GIT_LOCAL_DIR=dotfiles
GIT_LOCAL_BAK=$GIT_LOCAL_DIR-bak
#           !!! IMPORTANT NOTE - PLEASE READ !!!
#  GIT_LOCAL_DIR is the name of the folder where git repo is pulled into
#  This path is used in other files for referencing location of git repo.
#  Therefore, if you change the above variable, please change in the following files:
#    - .zshrc

# Move to home directory
cd $HOME

# Update apt for latest versions
sudo apt update

# Install vim, git, curl, wget, tmux, zsh
sudo apt install -y vim git curl wget tmux zsh

# Install oh-my-zsh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# create ssh key
ssh-keygen $SSH_KEY_PARAMS -t $SSH_KEY_TYPE -C "$EMAIL" -f $SSH_KEY_PATH

echo ""
echo "###############################"
echo "#####   BEFORE SSH KEY   ######"
echo "###############################"
echo ""

# show public ssh-key to add to github
CONTENTS=sudo cat $SSH_KEY_PATH.pub
echo "$CONTENTS" 

# TODO: Automatically copy key into clipboard (once issue with char limit is figured out)
#printf "\033]52;c;$(echo "$CONTENTS" | base64)\a"

echo "###############################"
echo "#####   AFTER SSH KEY    ######"
echo "###############################"
echo ""

# pause to give user a chance to add key to github
echo "Before continuing, please copy and paste ssh-key into github to allow access"
echo ""
read continue 

# config git
git config --global user.name "$NAME"
git config --global user.email "$EMAIL"

# remove previous git (and backup) folder
sudo rm -rf $GIT_LOCAL_DIR
sudo rm -rf $GIT_LOCAL_BAK

# clone git repo to "~/$GIT_LOCAL_DIR"
git clone --bare $GIT_REPO_PATH $GIT_LOCAL_DIR

# set alias and create backup folder (in case dotfiles already exist from installs)
alias dotgit='/usr/bin/git --git-dir=$HOME/$GIT_LOCAL_DIR/ --work-tree=$HOME'
mkdir -p $GIT_LOCAL_BAK/bin

# checkout to home folder (to add/replace .vimrc, .zshrc, etc)
dotgit checkout 2>&1 | egrep "^\s+" | awk {'print $1'} | xargs -I{} mv {} $GIT_LOCAL_BAK/{}
dotgit checkout

# Set up stream for pushing updates back to github
dotgit push --set-upstream origin main

# end of script
echo "Congrats on your newly setup machine!! Nice work :)"


