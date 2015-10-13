function extract () {
if [ -f $1 ] ; then
      case $1 in
      *.tar.bz2)   tar xvjf $1    ;;
      *.tar.gz)    tar xvzf $1    ;;
      *.bz2)       bunzip2 $1     ;;
      *.rar)       unrar x $1     ;;
      *.gz)        gunzip $1      ;;
      *.tar)       tar xvf $1     ;;
      *.tbz2)      tar xvjf $1    ;;
      *.tgz)       tar xvzf $1    ;;
      *.zip)       unzip $1       ;;
      *.Z)         uncompress $1  ;;
      *.7z)        7z x $1        ;;
      *)           echo "don't know how to extract '$1'..." ;;
   esac
else
   echo "'$1' is not a valid file!"
fi
}


function check_dir() {
   local check_path=""
   check_path=$1 ## Takes exactly one argument 

   if [[ -f $check_path ]]; then
      print "${RED}ERROR!${NC} File $check_path exists instead of directory!\n"
      return 1;
   fi

   if [[ ! -d $check_path ]]; then
      printf "${PURPLE}Warning:${NC} Directory doesn't exist, creating...\n"
      mkdir -p $check_path 
      if [[ -d $check_path ]]; then
         return true;
      else 
         return false;
      fi
   fi
}
