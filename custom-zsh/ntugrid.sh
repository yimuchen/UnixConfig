#-------------------------------------------------------------------------------
#
#   File        : ntugrid.sh
#   Descriptions: NTUGrid specific 
#
#-------------------------------------------------------------------------------
export WORKPATH="/wk_cms/yichen/"

alias usecms='source /cvmfs/cms.cern.ch/cmsset_default.sh'
alias wget='wget --no-check-certificate'

unset SSH_ASKPASS

export LD_LIBRARY_PATH=$HOME/local/lib/root/:$LD_LIBRARY_PATH

source ~/.custom-zsh/xrd_ntugrid.sh
source ~/.custom-zsh/cmssw.sh

#-----  Node aliasing  ---------------------------------------------------------
alias node01='ssh -Y node01'
alias node02='ssh -Y node02'
alias node03='ssh -Y node03'
alias node04='ssh -Y node04'
alias node05='ssh -Y node05'
alias node06='ssh -Y node06'
alias node07='ssh -Y node07'
alias node08='ssh -Y node08'
alias node09='ssh -Y node09'
alias node10='ssh -Y node10'
alias node11='ssh -Y node11'
alias node12='ssh -Y node12'
alias node13='ssh -Y node13'
alias node14='ssh -Y node14'
alias node15='ssh -Y node15'
alias node16='ssh -Y node16'
alias node17='ssh -Y node17'
alias node18='ssh -Y node18'
alias node19='ssh -Y node19'
alias node20='ssh -Y node20'

alias cn1='ssh  -Y cn1'
alias cn2='ssh  -Y cn2'
alias cn3='ssh  -Y cn3'
alias cn4='ssh  -Y cn4'
alias cn5='ssh  -Y cn5'
alias cn6='ssh  -Y cn6'
alias cn7='ssh  -Y cn7'
alias cn8='ssh  -Y cn8'
alias cn9='ssh  -Y cn9'
alias cn10='ssh -Y  cn10'
alias cn11='ssh -Y  cn11'
alias cn12='ssh -Y  cn12'
alias cn13='ssh -Y  cn13'
alias cn14='ssh -Y  cn14'
alias cn15='ssh -Y  cn15'
alias cn16='ssh -Y  cn16'
alias cn17='ssh -Y  cn17'
alias cn18='ssh -Y  cn18'
alias cn19='ssh -Y  cn19'
alias cn20='ssh -Y  cn20'
alias cn21='ssh -Y  cn21'
alias cn22='ssh -Y  cn22'
alias cn23='ssh -Y  cn23'
alias cn24='ssh -Y  cn24'
alias cn25='ssh -Y  cn25'
alias cn26='ssh -Y  cn26'
alias cn27='ssh -Y  cn27'
alias cn28='ssh -Y  cn29'

