#-------------------------------------------------------------------------------
#
#   File        : cmssw.sh
#   Descriptions: Aliasing for cmsssw
#
#-------------------------------------------------------------------------------

alias crab-setup='source /cvmfs/cms.cern.ch/crab3/crab.sh'

smake() {
   num_core=$(cat /proc/cpuinfo | grep processor | wc --lines)
   run_core=$((num_core/2))
   echo "Running on $run_core(out of $num_core) threads.."
   scram b -j $run_core 
}

my-cmsenv() {
   cmsenv 
   export PATH=$HOME/local/bin/:$PATH
   export LD_LIBRARY_PATH=$HOME/local/lib/:$HOME/local/lib64/:$LD_LIBRARY_PATH
}

