#!/bin/zsh -i

GIT_BASE_DIR=$HOME/gittest/

prev=$(fc -ln | tail -2 | head -1)
echo $prev

mv $GIT_BASE_DIR/.git $GIT_BASE_DIR/_git

igit status
#COMMAND=$(fc -ln -1)
#
#echo $COMMAND
#
#exit
