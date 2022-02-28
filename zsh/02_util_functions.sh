#*******************************************************************************
#
#  Filename    : 02_util_function.sh
#  Description : Common one line function call for easy modification
#  Author      : Yi-Mu "Enoch" Chen [ ensc@hep1.phys.ntu.edu.tw ]
#
#*******************************************************************************

function extract() {
   if [ -f $1 ]; then
      case $1 in
      *,tar.xz) tar xvf $1 ;;
      *.tar.bz2) tar xvjf $1 ;;
      *.tar.gz) tar xvzf $1 ;;
      *.bz2) bunzip2 $1 ;;
      *.rar) unrar x $1 ;;
      *.gz) gunzip $1 ;;
      *.tar) tar xvf $1 ;;
      *.tbz2) tar xvjf $1 ;;
      *.tgz) tar xvzf $1 ;;
      *.zip) unzip $1 ;;
      *.Z) uncompress $1 ;;
      *.7z) 7z x $1 ;;
      *) echo "don't know how to extract '$1'..." ;;
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
      return 1
   fi

   if [[ ! -d $check_path ]]; then
      printf "${PURPLE}Warning:${NC} Directory doesn't exist, creating...\n"
      mkdir -p $check_path
      if [[ -d $check_path ]]; then
         return true
      else
         return false
      fi
   fi
}

function listpath() {
   for file in $@; do
      echo $HOST:$(readlink -f $file)
   done
}

function convert_pdf() {
   ## Options given at
   ## http://stackoverflow.com/questions/6605006/convert-pdf-to-image-with-high-resolution
   local input_file=$1
   local output_file=${input_file/.pdf/.png}
   convert \
      -density 400 \
      -trim \
      $input_file \
      -quality 100 \
      -sharpen 0x1.0 \
      $output_file
}

function get_jupyter_url() {
   # Getting the url of the of the jupyter server session that is running in this
   # directory
   local json_file=$(ls -1t ${PWD}/.local/share/jupyter/runtime/nbserver-*.json | head -n 1)
   local token=$(cat ${json_file} | grep 'token' | awk '{print $2}')
   local url=$(cat ${json_file} | grep 'http' | awk '{print $2}')
   token=${token//\"/}
   token=${token//,/}
   url=${url//\"/}
   url=${url//,/}
   echo "${url}?token=${token}"
}
