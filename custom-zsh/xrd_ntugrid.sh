#-------------------------------------------------------------------------------
#
#   File        : xrd_ntugrid.sh
#   Descriptions: xrdfs command alias an utility functions
#
#-------------------------------------------------------------------------------

export REMOTE_SERVER="ntugrid4.phys.ntu.edu.tw"
export REMOTE_DEFAULT_BASE="/cms/store/user/yichen"

#--------------------------------------------------------------------------------
#  ls with wildcard support
#--------------------------------------------------------------------------------
function ls_ntugrid() {
   local target=""
   local target_list=""
   local target_path=""
   local target_type=""

   if [[ $# -lt 1 ]]; then
      ls_ntugrid $REMOTE_DEFAULT_BASE
   fi

   for target in $@ ; do
      target_list=( $(expand_xrd_wildcard $target) )
      for target_path in ${target_list[@]} ; do
         target_type=$( get_xrd_type $target_path )
         if [[ $target_type=="DIR" ]]; then
            echo "[$target_path]"
            xrdfs $REMOTE_SERVER ls $target_path
            echo ""
         else
            xrdfs $REMOTE_SERVER ls $target_path
         fi
      done
   done
}

#--------------------------------------------------------------------------------
#  rm remotely with globbing support
#--------------------------------------------------------------------------------
function rm_ntugrid() {
   local target=""
   local target_path_list=""
   local target_path=""
   local target_type=""

   for target in $@ ; do
      target_path_list=( $(expand_xrd_wildcard $target) )
      for target_path in ${target_path_list[@]} ; do
         target_type=$(get_xrd_type $target_path )
         if [[ $target_type == "DIR" ]]; then ## Is filst
            echo "Removing Directory $target_path"
            rmdir_ntugrid $target_path
         else
            echo "Removing file $target_path"
            xrdfs $REMOTE_SERVER rm $target_path
         fi
      done
   done
}

#--------------------------------------------------------------------------------
#  cp with globbing support
#--------------------------------------------------------------------------------
function cp_ntugrid() {
   local target_list=""
   local local_path=""

   if [[ $# -lt 2 ]]; then
      echo "ERROR! At least two arguments required!"
      return false;
   fi

   # Getting last argument as local_path
   for local_path in $@ ; do true ; done

   if check_dir $local_path ; then
   else
      echo "Failed to create directory! Aborting"
      return false;
   fi

   target_list=${@%$local_path}
   for target in ${target_list[@]} ; do
      target_path_list=( ${target_path[@]} $( expand_xrd_wildcard $target ) )
   done

   for target_path in ${target_path_list[@]} ; do
      if [[ $(get_xrd_type $target_path) == "DIR" ]]; then
         #echo "Fetching directory $target_path"
         cpdir_ntugrid $target_path $local_path
      else
         echo "Copying file $target_path to $local_path"
         xrdcp xroot://$REMOTE_SERVER//$target_path $local_path
      fi
   done
}


#--------------------------------------------------------------------------------
#  Recursively remove all contents from a path
#--------------------------------------------------------------------------------
function rmdir_ntugrid() {
   # All local variables for recursive calls
   local dir=""
   local pathList=""
   local remote_path=""
   local path_type=""

   for dir in $@ ; do
      pathList=( $(xrdfs $REMOTE_SERVER ls $dir) )

      for remote_path in ${pathList[@]} ; do
         path_type=$( get_xrd_type $remote_path )
         if [[ $path_type == "DIR" ]]; then
            echo "Decending into $remote_path"
            rmdir_ntugrid $remote_path
         else
            echo "[rmdir] Removing file $remote_path"
            xrdfs $REMOTE_SERVER rm $remote_path
         fi
      done

      echo "[rmdir] Removing directory $dir"
      xrdfs $REMOTE_SERVER rmdir $dir

   done
}

#--------------------------------------------------------------------------------
#  cp directory structure to local path
#  Behaviour definition:
#      target_dir = /some/remote/path/dir_name
#      local_path = /some/local/path
#  Create local directory /some/local/path/dir_name
#  even if /some/local/path is empty
#--------------------------------------------------------------------------------
function cpdir_ntugrid() {
   local target_dir=$1
   local local_path=$2
   local dir_name=${target_dir##*/}
   local local_dir=$local_path/$dir_name
   local target_list=""
   local target=""


   if [[ $target_dir == "" ]]; then return 1; fi
   if [[ $local_path == "" ]]; then return 1; fi

   if check_dir "$local_dir" ; then
   else
      echo "Failed!"
      return false;
   fi

   target_list=( $( xrdfs $REMOTE_SERVER ls $target_dir ) )
   for target in ${target_list[@]} ; do
      if [[ $(get_xrd_type $target) == "DIR" ]]; then
         echo "Getting Directory $target"
         cpdir_ntugrid $target $local_dir
      else
         echo "Getting File $target"
         xrdcp xroot://$REMOTE_SERVER//$target $local_dir
      fi
   done
}


#--------------------------------------------------------------------------------
#  Wildcard functions
#--------------------------------------------------------------------------------
function expand_xrd_wildcard() {
   local word_list=$1
   local querylist=""
   local nextquerylist=""
   local regex_string=""

   if [[ $word_list != "/"* ]]; then
      word_list="${REMOTE_DEFAULT_BASE}/${word_list}"
   fi

   word_list=( $(split_path $word_list) )
   word_list=( $(wildcard_to_regex $word_list ) )

   querylist=( "/" )
   for word in ${word_list[@]} ; do
      regex_string="${regex_string}/${word}"
      for query in ${querylist[@]} ; do
         raw_query=$( xrdfs $REMOTE_SERVER ls $query )
         new_query_items=( $( echo $raw_query | grep --color=none $regex_string$ ) )
         #echo "[DEBUG][wildcard] regex_string: $regex_string"
         #echo "[DEBUG][wildcard] query:        $query"
         #echo "[DEBUG][wildcard] raw results:  $raw_query"
         #echo "[DEBUG][wildcard] next list:    ${new_query_items[@]}"
         nextquerylist=( ${nextquerylist[@]} ${new_query_items[@]} )
      done
      querylist=( $nextquerylist[@] )
      nextquerylist=""
      #echo "[DEBUG][wildcard] $querylist"
   done

   #echo "[DEBUG][RESULTS]"
   echo $querylist
}

function split_path() {
   local line=${1}
   echo $line | sed "s@/@ @g"
}

function wildcard_to_regex() {
   input=$@
   echo $input | \
      sed "s@\.@\.@g"  | \
      sed "s@\?@.@g"   | \
      sed "s@\*@[0-9a-zA-Z_-]*@g"
}

function get_xrd_type() {
   input_path=$1
   result=$(xrdfs $REMOTE_SERVER stat $input_path | grep "IsDir" )
   if [[ $result == "" ]]; then
      echo "FILE"
   else
      echo "DIR"
   fi
}
