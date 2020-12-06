#!/bin/bash

# Set Variables for script as desired
NAME="Chad Capra"
EMAIL="chadcapra@gmail.com"
GIT_REPO_PATH="git@github.com:ChadCapra/dotfiles.git"

SSH_KEY_TYPE="ed25519" 
SSH_KEY_PARAMS="-o -a 256" 
SSH_KEY_PATH="$HOME/.ssh/id_$SSH_KEY_TYPE"

DOTGIT_DIR=$HOME/dotfiles
DOTGIT_BAK=$DOTGIT_DIR-"$(date +"%Y%m%d_%H%M%S")"

# Set current directory to home
cd $HOME

# Update apt for latest versions
sudo apt update

# Install vim, git, curl, wget, tmux, zsh
sudo apt install -y vim git curl wget tmux zsh

# Install docker (after uninstalling)
sudo apt remove docker docker-engine docker.io containerd runc

sudo apt install apt-transport-https ca-certificates
sudo apt install gnupg-agent software-properties-common

curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -

sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/debian \
   $(lsb_release -cs) \
   stable"

sudo apt update
sudo apt install docker-ce docker-ce-cli containerd.io

# config git
git config --global user.name "$NAME"
git config --global user.email "$EMAIL"

# create ssh key
echo ""
echo ""
echo "#########################################################################"
echo "###  Creating ssh key at $SSH_KEY_PATH"
echo "###    - Add password to better protect ssh key"
echo "#########################################################################"
echo ""
echo ""
ssh-keygen $SSH_KEY_PARAMS -t $SSH_KEY_TYPE -C "$EMAIL" -f $SSH_KEY_PATH

echo ""
echo ""
echo "#########################################################################"
echo "#####   $SSH_KEY_PATH.pub key below"
echo "#########################################################################"
echo ""

# show public ssh-key to add to github
CONTENTS=sudo cat $SSH_KEY_PATH.pub
echo "$CONTENTS" 

# TODO: Automatically copy key into clipboard
# (once issue with char limit is figured out)
#printf "\033]52;c;$(echo "$CONTENTS" | base64)\a"

# pause to give user a chance to add key to github
echo ""
echo ""
echo "#########################################################################"
echo "###  Before continuing, copy above ssh-key into github to allow access"
echo "#########################################################################"
echo ""
read continue 

# delete existing bare git dir and create new backup folder
# must include sub directories as mv will not (e.g. /bin)
rm -rf $DOTGIT_DIR
mkdir -p $DOTGIT_BAK/bin

# grab data from github and store in bare local dir: "~/$DOTGIT_DIR"
git clone --bare $GIT_REPO_PATH $DOTGIT_DIR
alias dotgit='/usr/bin/git --git-dir=$DOTGIT_DIR/ --work-tree=$HOME'

# checkout to home folder (to add/replace .vimrc, .zshrc, etc)
# and capture existing files and move to backup folder
dotgit checkout 2>&1 | egrep "^\s+" | awk {'print $1'} \
  | xargs -I{} mv {} $DOTGIT_BAK/{}
dotgit checkout

# update submodules
dotgit submodule init
dotgit submodule update

# Set up stream for pushing updates back to github
dotgit push --set-upstream origin main

# remove any empty backup folders
find $DOTGIT_BAK -empty -type d -delete

# Add DOTGIT_DIR env variable for zsh to allow for dotgit command
echo "DOTGIT_DIR=$DOTGIT_DIR" >> $HOME/.zshenv

# change default shell using sudo but for current user)
sudo chsh -s $(which zsh) $USER

echo ""
echo ""
echo "#########################################################################"
echo "###   Your machine is all set up! Let's restart the shell to launch zsh"
echo "###        * Press Enter to continue when ready..."
echo "#########################################################################"
echo ""
read continue

# final step is to reset terminal
reset; exec sudo --login --user $USER

