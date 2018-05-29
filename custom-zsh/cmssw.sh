#-------------------------------------------------------------------------------
#
#   File        : cmssw.sh
#   Descriptions: Aliasing for cmsssw
#
#-------------------------------------------------------------------------------

alias crab-setup='source /cvmfs/cms.cern.ch/crab3/crab.sh'
alias htop='htop --user ${USER}'

smake() {
   num_core=$(nproc)
   run_core=$((num_core/2))
   echo "Running on $run_core(out of $num_core) threads.."
   scram b -j $run_core
}

