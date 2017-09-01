#-------------------------------------------------------------------------------
#
#   File        : personal_machine.sh
#   Descriptions: Specific commands for Arch Linux machine
#
#-------------------------------------------------------------------------------

# Machine specific variables
export XDG_CONFIG_HOME=$HOME/.fontconf/
export ROOTSYS=/usr
export PATH=$PATH:$ROOTSYS/bin
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$ROOTSYS/lib
export DYLD_LIBRARY_PATH=$DYLD_LIBRARY_PATH:$ROOTSYS/lib
export PATH=$PATH:$HOME/.gem/ruby/2.3.0/bin
export PATH=$PATH:$HOME/.gem/ruby/2.4.0/bin
export PATH=$PATH:$HOME/.py_script
export TDR_DIR=$HOME/HomeWork/CMS-Group/TDRMaster

# Importing common functions
source $HOME/.custom-zsh/tdr_settings.sh

# Machine specific alias
alias optirun="LD_PRELOAD=\"libpthread.so.0 libGL.so.1\" __GL_THREADED_OPTIMIZATIONS=1 optirun"

# Machine specific functions
pacupdate(){
   yaourt --sync --refresh --sysupgrade -a;
   sudo --preserve-env pacdiffviewer;
   yaourt --query --unrequired --deps;
}

Gcc(){
   g++ -std=c++11 -g -pthread -o ${1%.cpp}.out -Wall  $1
}

#-------------------------------------------------------------------------------
#   Networking test
#-------------------------------------------------------------------------------
ntugridvpn() {
   sshuttle -r yichen@ntugrid5.phys.ntu.edu.tw   140.112.0.0/0
}

fixrootpdf()
{
   file=$1
   gs                          \
      -sDEVICE=pdfwrite        \
      -dCompatibilityLevel=1.4 \
      -dPDFSETTINGS=/screen    \
      -dNOPAUSE                \
      -dQUIET                  \
      -dBATCH                  \
      -sOutputFile=tmp.pdf     \
      ${file}
   mv tmp.pdf ${file}
}
