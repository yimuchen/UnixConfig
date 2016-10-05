#-------------------------------------------------------------------------------
#
#   File        : cprojects.sh
#   Descriptions: Short hands for C++/CMSSW projects  
#
#-------------------------------------------------------------------------------

function make_C_package() 
{
   if [[ $# -lt 1 ]]; then
      echo "Error! Requires at least one argument!"
   fi
   for package in $@ ; do 
      if [[ -f $package ]]; then
         echo "Error! File $package exists!"
         return 1
      fi

      mkdir -p $package 
      
      ## Moving template CMakeFile 
      cat ~/.templates/CMakeLists.txt |
         sed "s@PACKAGE_NAME@$package@g" > $package/CMakeLists.txt

      ## Assuming class based package, inserting header and cpp files 
      cat ~/.templates/cpp_header.h |
         sed "s@PACKAGE_NAME@$package@g" > ${package}/${package}.h
      cat ~/.templates/cpp_source.cc |
         sed "s@PACKAGE_NAME@$package@g" > ${package}/${package}.cc

   done
}
