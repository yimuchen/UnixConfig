## Script commands for git inits 

git-getIgnore(){
   if [ -e .gitignore ] ; then return 0 ; fi  
   cp $HOME/.gitTemplate/gitignore .gitignore 
}

git-getLicense(){
   if [ -e LICENSE ] ; then return 0 ; fi 
   cp $HOME/.gitTemplate/LICENSE LICENSE
   local YEAR=`date +"%Y"`
   sed -i "s@\<year\>@$YEAR@" LICENSE 
}

git-genReadme(){
   if [ -e README.md ] ; then return 0 ; fi
   local DIR=${PWD##*/}
   echo "# $DIR" > README.md 
}

git-init() {
   if [ $# -ne 1 ] ; then 
         echo "Usage: git-init [directory name]"
      echo "Usage: git-init --here"
      return -1 ;
   fi 

   if [[ $1 != "--here" ]] ; then
      echo "Attempting to create directory $1 here..." 
      if [ -e $1 ] ; then 
         echo "Error! The file/directory $1 already exists!"
         return -1;
      fi 
      mkdir $1 
      cd    $1 
   else
      echo "Initiating git directory here..."
   fi 

   git init 
   git-getIgnore  
   git-getLicense  
   git-genReadme  
   git add .gitignore LICENSE README.md

   if [[ $1 == "--here" ]] ; then 
      git add * 
      git commit -m "First commit, added everything"
   else 
      git commit -m "First commit, added essentials"
   fi

}
