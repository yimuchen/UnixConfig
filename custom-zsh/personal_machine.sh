#-------------------------------------------------------------------------------
#
#   File        : personal_machine.sh
#   Descriptions: Specific commands for Arch Linux machine
#
#-------------------------------------------------------------------------------

#-----  Pacman Update command  -------------------------------------------------
pacupdate(){
   yaourt --sync --refresh --sysupgrade -a;
   sudo --preserve-env pacdiffviewer;
   yaourt --query --unrequired --deps;
}

#-----  Single file C++ compiling  ---------------------------------------------
Gcc(){
   g++ -std=c++11 -g -pthread -o ${1%.cpp}.out -Wall  $1 
}

#-----  Xelatex quick compile  -------------------------------------------------
genlatex(){
   xelatex --shell-escape -synctex=1 -interaction=nonstopmode $1
}

#-----  Madgraph environment settings  -----------------------------------------
export ROOTSYS=/usr
export PATH=$PATH:$ROOTSYS/bin
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$ROOTSYS/lib
export DYLD_LIBRARY_PATH=$DYLD_LIBRARY_PATH:$ROOTSYS/lib

#-----  Ruby settings  ---------------------------------------------------------
export PATH=$PATH:$HOME/.gem/ruby/2.3.0/bin


#----- Optirun -----------------------------------------------------------------
alias optirun="LD_PRELOAD=\"libpthread.so.0 libGL.so.1\" __GL_THREADED_OPTIMIZATIONS=1 optirun" 
