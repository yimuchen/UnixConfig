#-------------------------------------------------------------------------------
#
#   File        : lxplus_rc.sh
#   Descriptions: LXPLUS machine specific
#   Usage       : ./lxplus_rc.sh Option
#
#-------------------------------------------------------------------------------

# Setting machine specific variables
export WORKPATH='/afs/cern.ch/work/y/yichen'
export STOREPATH='/store/yichen'

# Loading common functions
source ~/.custom-zsh/cmssw.sh
source ~/.custom-zsh/xrd_ntugrid.sh

# Machine specific aliases
alias inrne4='ssh inrne4'

unset SSH_ASKPASS ## Disabling gnome


# Machine specific functions
bcheck(){
   echo "QUEUE   Total   Running   Pending"
   for queue in "1nh 8nh 1nd 2nd 1nw 2nw" ; do
      total=$(   bjobs | grep $queue | grep $USER | wc --lines )
      running=$( bjobs | grep $queue | grep RUN   | wc --lines )
      pending=$( bjobs | grep $queue | grep PEN D | wc --lines )
      echo $queue $total $running $pending
   done
}
