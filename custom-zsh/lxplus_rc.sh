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

function get_lumical() 
{
   export PATH=$HOME/.local/bin:/afs/cern.ch/cms/lumi/brilconda-1.0.3/bin:$PATH
   pip install --install-option="--prefix=$HOME/.local" brilws
}
