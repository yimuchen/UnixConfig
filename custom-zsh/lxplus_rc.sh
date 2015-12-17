#-------------------------------------------------------------------------------
#
#   File        : lxplus_rc.sh
#   Descriptions: LXPLUS machine specific 
#   Usage       : ./lxplus_rc.sh Option
#
#-------------------------------------------------------------------------------
export WORKPATH='/afs/cern.ch/work/y/yichen'
export STOREPATH='/store/yichen'

source ~/.custom-zsh/cmssw.sh
source ~/.custom-zsh/xrd_ntugrid.sh

alias bpktest='cmsRun bprimeKit_miniAOD_MC.py   maxEvts=100 Debug=100 2>&1 | tee log.txt'
alias bpkdata='cmsRun bprimeKit_miniAOD_data.py maxEvts=100 Debug=100 2>&1 | tee log.txt'
alias fatalCheck='cat log.txt | grep -A 10 -B 10 Fatal'
alias inrne4='ssh inrne4'

unset SSH_ASKPASS ## Disabling gnome

bcheck(){
   echo "QUEUE   Total   Running   Pending"
   for queue in "1nh 8nh 1nd 2nd 1nw 2nw" ; do
      total=$(   bjobs | grep $queue | grep $USER | wc --lines )
      running=$( bjobs | grep $queue | grep RUN   | wc --lines )
      pending=$( bjobs | grep $queue | grep PEN D | wc --lines )
      echo $queue $total $running $pending
   done
}


