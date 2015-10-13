#!/bin/bash 

## Running from the directory of the script 
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
SCRIPTFILE=`basename $0`
echo "You are running $SCRIPTFILE"
echo "Soft linking all files in $DIR to ${HOME}..." 

for FILE in $( ls $DIR ) ; do
   if [[ "$FILE" = "$SCRIPTFILE" ]] ; then  
      continue 
   elif [[ "$FILE" = "README.md" ]] ; then 
      continue 
   elif [[ "$FILE" = "LICENSE" ]] ; then 
      continue 
   elif [[ $FILE == "TexSettings" ]]; then
      continue
   fi
   
   TARGET_FILE=$HOME/"."$FILE ;
   if [[ -e $TARGET_FILE ]] ; then 
      echo ">>> Deleting existing $TARGET_FILE"
      rm $TARGET_FILE -rf 
   fi 
   
   SOURCE_FILE=$DIR/$FILE 
   echo ">>> Linking $SOURCE_FILE to $TARGET_FILE"
   ln -sf $SOURCE_FILE $TARGET_FILE 

done

####  Taking care of vim plugins
if [[ ! -e ~/.vim/bundle/Vundle.vim ]] ; then 
   echo "First installation for the file! Pulling fresh version of Vundle and YouCompleteMe..."
   mkdir ~/.vim/bundle 
   git clone https://github.com/gmarik/Vundle.vim.git       ~/.vim/bundle/Vundle.vim/
   git clone https://github.com/Valloric/YouCompleteMe.git  ~/.vim/bundle/YouCompleteMe/
   cd ~/.vim/bundle/YouCompleteMe/ 
   git submodule update --init --recursive
   cd -
   exec ~/.vim/bundle/YouCompleteMe/install.sh
   echo "Please manually start a new session an run the command \":PluginUpdate\""
fi 

#-----  Taking care of latex configuration files  --------------------------------------------------
TEXMFDIR=`kpsewhich -var-value=TEXMFHOME`
if [[ ! -d $TEXMFDIR ]] ; then 
   mkdir -p $TEXMFDIR/tex/
fi
ln -sf $DIR/TexSettings $TEXMFDIR/tex/latex

