#-------------------------------------------------------------------------------
#
#   File        : cmssw.sh
#   Descriptions: Aliasing for cmssw
#
#-------------------------------------------------------------------------------

alias crab-setup='source /cvmfs/cms.cern.ch/crab3/crab.sh'
alias htop='htop --user ${USER}'
alias usecms='source /cvmfs/cms.cern.ch/cmsset_default.sh'

export CPATH=$CPATH:/$HOME/local/include/:$HOME/local/include/ImageMagick-7/
export LIBRARY_PATH=$LIBRARY_PATH:$HOME/local/lib/:$HOME/local/lib64/

smake() {
   if [ -z "$CMSSW_BASE" ]; then
     echo "\$CMSSW_BASE is not defined, make sure you are in a CMSSW environment"
     return 1
   fi

   local num_core=$(nproc)
   local run_core=$((num_core / 2))
   echo "Running on $run_core(out of $num_core) threads.."
   cd ${CMSSW_BASE}/src
   scram b -j $run_core
   cd -
}
