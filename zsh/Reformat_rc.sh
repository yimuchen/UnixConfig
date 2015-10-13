
#--------------------------------------------------------------------------------  
#  Defining the required variables 
#--------------------------------------------------------------------------------  
export TARGET_EXTENSION=".cc"
export OTHER_EXTENSIONS=".C .cxx .cpp .CPP"

export TARGET_HEADER=".h"
export OTHER_HEADERS=".hpp .hh .H .HPP"

ALL_CPP_FILES=""
for EXT in $TARGET_HEADER $TARGET_EXTENSION $OTHER_HEADERS $OTHER_EXTENSIONS ; do 
   export ALL_CPP_FILES="*$EXT "$ALL_CPP_FILES
done


#--------------------------------------------------------------------------------  
#  Defining the helper functions 
#--------------------------------------------------------------------------------  
function check-git() { 
   if [[ ! -d .git ]] ; then 
      echo "Error! Requires running in a git directory"
      return -1
   fi
   return 0;
}


function change-cpp-ext() {
   if [[ `check-git()` != "" ]] ; then 
      echo "Error! Requires running in a git directory"
      return -1
   fi 

   echo "----------------------------  Changing file extension  ----------------------------"

   for EXT in $OTHER_EXTENSIONS ; do 
      for FILE in $( git ls-files "*$EXT" ) ; do 
         NEWFILE=${FILE%$EXT}$TARGET_EXTENSION
         echo ">>> Renaming $FILE to $NEWFILE" 
         mv $FILE $NEWFILE
         git add $FILE $NEWFILE
      done 
   done

   return 0;
}

function change-head-ext() {
   if [[ `check-git()` != "" ]] ; then  
      echo "Error! Requires running in a git directory"
      return -1;
   fi 

   echo "---------------------------  Changing header extension  ---------------------------"

   for EXT in $OTHER_HEADERS ; do
      for FILE in $( git ls-files "*$EXT" ) ; do

         ## Finding files, renaming and git update
         echo ">>> Warning! Header file with different extension found!"
         NEWFILE=${FILE%$EXT}$TARGET_HEADER 
         echo ">>> Renaming $FILE to $NEWFILE"
         mv $FILE $NEWFILE
         git add $FILE $NEWFILE 

         ## Getting file name 
         FILENAME=${FILE##*/}
         NEWFILENAME=${NEWFILE##*/}
         echo ">>> Checking dependencies on file: $FILENAME"

         ## Editing with header dependencies
         IFS=$'\n'
         for LINE in `git grep "$FILENAME"` ; do
            DEP_FILE=${LINE%%:*}
            echo  "   >>> Editing file: $DEP_FILE"
            sed -i "s@$FILENAME@$NEWFILENAME@" "$DEP_FILE"
         done
      done 
   done 

   return 0;
}

function fix-links() {
   if [[ `check-git()` != "" ]] ; then 
      echo "Error! Requires running in a git directory"
      return -1 ;
   fi

   echo "-----------------------------  Fixing symbolic links  -----------------------------"

   for FILE in `git ls-files` ; do 
      if [[ ! -L $FILE ]] ; then continue ; fi
      PREV_FILE=`readlink $FILE`

      for EXT in $OTHER_EXTENSIONS $OTHER_HEADERS ; do 
         if [[ $PREV_FILE == *"$EXT" ]] ; then
            NEWFILE=${PREV_FILE%$EXT}$TARGET_HEADER 
            echo "Linking $FILE from $PREV_FILE to $NEWFILE"
            ln -sf $NEWFILE $FILE
         fi 
      done 
   done

   return 0;
}

function run-astyle() {
   if [[ `check-git()` != "" ]] ; then 
      echo "Error! Requires running in a git directory"
      return -1
   fi 

   echo "------------------------------  Astyle reformatting  ------------------------------" 

   for FILE in `git ls-files "*$TARGET_HEADER" "*$TARGET_EXTENSION"` ; do
      astyle --formatted -n $FILE
   done

   return 0
}


#--------------------------------------------------------------------------------  
#  The highest functions 
#--------------------------------------------------------------------------------  

function reformat() {
   if [[ `check-git` != "" ]] ; then 
      echo "Error! Requires running in a git directory"
      return -1
   fi 

   exec change-cpp-ext  
   exec change-head-ext
   exec fix-links
   exec run-astyle 
}
