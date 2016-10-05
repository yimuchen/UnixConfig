#-------------------------------------------------------------------------------
#
#   File        : remote_machines.sh
#   Descriptions: SSH settings
#
#-------------------------------------------------------------------------------

# SSH Aliases
alias cmsdas='ssh -Y yichen-@ntugrid1.phys.ntu.edu.tw'
alias ntugrid5='ssh -Y yichen@ntugrid5.phys.ntu.edu.tw'
alias ntugrid3='ssh -Y yichen@ntugrid3.phys.ntu.edu.tw'
alias lxplus='ssh -Y yichen@lxplus.cern.ch'
alias pcntu='ssh -Y yichen@pcntu12.cern.ch'


function tstarlogin() {
   ssh -Y yichen@lxplus.cern.ch -t ' cd /afs/cern.ch/work/y/yichen/TstarAnalysis/CMSSW_8_0_12/src/ ; bash  -l ; eval `/cvmfs/cms.cern.ch/common/scramv1 runtime -sh`'
}
