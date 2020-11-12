#!/bin/bash

# Set Variables for script as desired
NAME="Chad Capra"
EMAIL="chadcapra@gmail.com"
GIT_REPO_PATH="git@github.com:ChadCapra/dotfiles.git"

SSH_KEY_TYPE="ed25519" 
SSH_KEY_PARAMS="-o -a 256" 
SSH_KEY_PATH="$HOME/.ssh/id_$SSH_KEY_TYPE"

export DOTGIT_DIR=$HOME/dotfiles
DOTGIT_BAK=$DOTGIT_DIR-bak

# Set current directory to home
cd $HOME

# Update apt for latest versions
sudo apt update

# Install vim, git, curl, wget, tmux, zsh
sudo apt install -y vim git curl wget tmux zsh

# Install oh-my-zsh
OH_MY_ZSH_URL=https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh
sh -c "$(curl -fsSL $OH_MY_ZSH_URL)"

## Check if key exists at given ssh location (and ask user how to proceed)
#if [ -f $SSH_KEY_PATH]; then
#
#  echo -n "ssh key already exists at $SSH_KEY_PATH"
#  echo -n "Do you wish to (o)verwrite or (k)eep existing (o/k)?"
#  read answer
#  
#  if [ "$answer" != "${answer#[Oo]}" ] ;then
#
#    # delete existing key (public & private)
#    rm -f $SSH_KEY_PATH
#    rm -f $SSH_KEY_PATH.pub
 
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
sudo rm -rf $DOTGIT_DIR
sudo rm -rf $DOTGIT_BAK

# clone git repo to "~/$DOTGIT_DIR"
git clone --bare $GIT_REPO_PATH $DOTGIT_DIR

# set alias and create backup folder (in case dotfiles already exist from installs)
alias dotgit='/usr/bin/git --git-dir=$DOTGIT_DIR/ --work-tree=$HOME'
sudo mkdir -p $DOTGIT_BAK/bin

# checkout to home folder (to add/replace .vimrc, .zshrc, etc)
dotgit checkout 2>&1 | egrep "^\s+" | awk {'print $1'} | xargs -I{} sudo mv {} $DOTGIT_BAK/{}
dotgit checkout

# Set up stream for pushing updates back to github
dotgit push --set-upstream origin main

# end of script
echo "Congrats on your newly setup machine!! Nice work :)"


