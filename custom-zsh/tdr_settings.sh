#*******************************************************************************
 #
 #  Filename    : tdr_settings.sh
 #  Description : Aliases and functions for TDR compilation
 #  Author      : Yi-Mu "Enoch" Chen [ ensc@hep1.phys.ntu.edu.tw ]
 #
#*******************************************************************************
function tdr_setup ()
{
   if [[ $# != 1 ]]; then
      echo "${WHITE}tdr_setup${NC} takes exactly one arugment"
      echo ">> tdr_setup [papers|notes]"
      return
   fi

   local setuptype=$1
   local setupdir=""

   if [[ $setuptype == "paper" ]]; then
      setupdir="papers"
   elif [[ $setuptype == "an" ]]; then
      setupdir="notes"
   else
      echo "${RED}ERROR${NC} Set up type unknown!"
      return
   fi

   local savepath=$PWD
   cd $TDR_DIR
   eval `$setupdir/tdr runtime -sh`
   cd $savepath
}

function tdr_make()
{
   if [ $# != 2 ] ; then
      echo "${WHITE}tdr_make${NC} expected exactly two arguments"
      echo ">> tdr_make [paper|an] [XXX-YY-NNN]"
      return
   fi

   local maketype=$1
   local version=$2
   local workdir=""

   if [[ $maketype == "paper" ]] ; then
      workdir="papers"
   elif [[ $maketype == "an" ]]; then
      workdir="notes"
   else
      echo "${RED}ERROR${NC} Unrecognizd type ${WHITE}$TYPE${NC}"
      echo ">> tdr_make [papers|an] [XXX-YY-NNN]"
      return
   fi

   if [ ! -d $TDR_DIR/$workdir/$version ] ; then
      echo "${RED}ERROR!${NC} The diretory for ${WHITE}$maketype/$version${NC} doesnt exists under the TDR directory!"
      echo "Check $TDR_DIR/$workdir/$version"
      return
   fi

   local savepath=$PWD
   cd $TDR_DIR/$workdir/$version/trunk
   $TDR_DIR/$workdir/tdr --draft --style=$maketype b $version
   cd $savepath
   cp $TDR_DIR/$workdir/tmp/${version}_temp.pdf $TDR_DIR/${version}.pdf
   echo "Duplicate PDF file to $TDR_DIR/${version}.pdf"
}
