#-------------------------------------------------------------------------------
#
#   File        : cmssw.sh
#   Descriptions: Aliasing for cmssw
#
#-------------------------------------------------------------------------------

alias crab-setup='source /cvmfs/cms.cern.ch/crab3/crab.sh'
alias htop='htop --user ${USER}'
alias usecms='source /cvmfs/cms.cern.ch/cmsset_default.sh'
alias init-voms='voms-proxy-init -voms cms --valid 192:00 --out ${HOME}/x509up_u${UID}'

export X509_USER_PROXY=${HOME}/x509up_u${UID}
export CPATH=$CPATH:/$HOME/local/include/:$HOME/local/include/ImageMagick-7/
export LIBRARY_PATH=$LIBRARY_PATH:$HOME/local/lib/:$HOME/local/lib64/

#-------------------------------------------------------------------------------
#
# Simple function for running the scram b command on half the cores available in
# a CMSSW environment
#
#-------------------------------------------------------------------------------
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

#-------------------------------------------------------------------------------
#
# Getting the hold reason for all jobs in a condor_q. Notice this command
# assumes the -better-analyze options can be used without additional arugments
# (such as specifying scheduler names)
#
#-------------------------------------------------------------------------------
condor_checkhold() {
  for job_id in $(condor_q -nobatch | grep ' H ' | awk '{print $1}'); do
    reason=$(condor_q ${job_id} -better-analyze | grep 'Hold reason');
    echo $job_id $reason
  done
}
