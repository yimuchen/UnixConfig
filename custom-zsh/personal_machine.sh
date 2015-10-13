
##aliasing update command
pacupdate(){
   yaourt --sync --refresh --sysupgrade -a;
   sudo --preserve-env pacdiffviewer;
   yaourt --query --unrequired --deps;
}

##aliasing for fast single file C++ compiling
Gcc(){
   g++ -std=c++11 -g -pthread -o ${1%.cpp}.out -Wall  $1 
}

##Lxplus cp 
cp_from_lxplus() {
   remote_file=$1
   local_file=$2
   scp yichen@lxplus6.cern.ch:'$1' $2
}

##xelatex quick complile
genlatex(){
   xelatex --shell-escape -synctex=1 -interaction=nonstopmode $1
}

##Magraph environment setting
export ROOTSYS=/usr
export PATH=$PATH:$ROOTSYS/bin
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$ROOTSYS/lib
export DYLD_LIBRARY_PATH=$DYLD_LIBRARY_PATH:$ROOTSYS/lib

## Ruby setup
export PATH=$PATH:$HOME/.gem/ruby/2.2.0/bin
