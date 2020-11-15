#!/bin/bash

# Set Variables for script as desired
NAME="Chad Capra"
EMAIL="chadcapra@gmail.com"
GIT_REPO_PATH="git@github.com:ChadCapra/dotfiles.git"

SSH_KEY_TYPE="ed25519" 
SSH_KEY_PARAMS="-o -a 256" 
SSH_KEY_PATH="$HOME/.ssh/id_$SSH_KEY_TYPE"

export DOTGIT_DIR=$HOME/dotfiles
DOTGIT_BAK=$DOTGIT_DIR-"$(date +"%Y%m%d_%H%M%S")"

# Set current directory to home
cd $HOME

# Update apt for latest versions
sudo apt update

# Install vim, git, curl, wget, tmux, zsh
sudo apt install -y vim git curl wget tmux zsh

# config git
git config --global user.name "$NAME"
git config --global user.email "$EMAIL"

# create ssh key
echo "Creating ssh key at default location. Feel free to password protect key"
ssh-keygen $SSH_KEY_PARAMS -t $SSH_KEY_TYPE -C "$EMAIL" -f $SSH_KEY_PATH

echo ""
echo "###############################"
echo "#####   BEFORE SSH KEY   ######"
echo "###############################"
echo ""

# show public ssh-key to add to github
CONTENTS=sudo cat $SSH_KEY_PATH.pub
echo "$CONTENTS" 

# TODO: Automatically copy key into clipboard
# (once issue with char limit is figured out)
#printf "\033]52;c;$(echo "$CONTENTS" | base64)\a"

echo "###############################"
echo "#####   AFTER SSH KEY    ######"
echo "###############################"
echo ""

# pause to give user a chance to add key to github
echo "Before continuing, copy and paste ssh-key into github to allow access"
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

# Set up stream for pushing updates back to github
dotgit push --set-upstream origin main

# remove any empty backup folders
find $HOME/DOTGIT_DIR* -empty -type d -delete

# Add DOTGIT_DIR env variable for zsh to allow for dotgit command
echo "DOTGIT_DIR=$DOTGIT_DIR" >> $HOME/.zshenv

echo "Installing oh-my-zsh and changing default shell to zsh"

# Install oh-my-zsh (but keep .zshrc) - Leave as last command!!
OH_MY_ZSH_URL=https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh
sh -c "$(curl -fsSL $OH_MY_ZSH_URL)" "" --keep-zshrc

