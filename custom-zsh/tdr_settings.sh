#*******************************************************************************
 #
 #  Filename    : tdr_settings.sh
 #  Description : Aliases and functions for TDR compilation
 #  Author      : Yi-Mu "Enoch" Chen [ ensc@hep1.phys.ntu.edu.tw ]
 #
#*******************************************************************************

function tdrnote_setup() {
   if [ -z $TDR_DIR ] ; then
      echo "${RED}ERROR!${NC} The variable ${WHITE}TDR_DIR${NC}' is not set!"
      return
   fi

   cd $TDR_DIR &> /dev/null
   eval `./notes/tdr runtime -sh`
   cd - &> /dev/null
}


function tdrnote_make() {
   NOTEV=$1 # Takes eactly one argument

   if [ ! -d $TDR_DIR/notes/$NOTEV ] ; then
      echo "${RED}ERROR!${NC} Note ${WHITE}$NOTEV${NC} doesnt exists!"
      return
   fi

   cd $TDR_DIR/notes/$NOTEV/trunck &> /dev/null
   tdr --style=an b $NOTEV
   cd - &> /dev/null
}
