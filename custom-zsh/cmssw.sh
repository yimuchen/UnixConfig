#-------------------------------------------------------------------------------
#
#   File        : cmssw.sh
#   Descriptions: Aliasing for cmsssw
#
#-------------------------------------------------------------------------------

alias smake='scram b -j 8'
alias crab-setup='source /cvmfs/cms.cern.ch/crab3/crab.sh'

my-cmsenv() {
   cmsenv 
   export PATH=$HOME/local/bin/:$PATH
   export LD_LIBRARY_PATH=$HOME/local/lib/:$HOME/local/lib64/:$LD_LIBRARY_PATH
}

