#-------------------------------------------------------------------------------
#
#   File        : ntugrid.sh
#   Descriptions: NTUGrid specific
#
#-------------------------------------------------------------------------------

# Setting machine specific variables
export WORKPATH="/wk_cms2/yichen/"
export LD_LIBRARY_PATH=$HOME/local/lib/root/:$LD_LIBRARY_PATH

## Loading common settings between machines
source ~/.custom-zsh/cmssw.sh

## Machine specific aliases
unset SSH_ASKPASS

alias wget='wget --no-check-certificate'
