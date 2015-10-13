export WORKPATH='/afs/cern.ch/work/y/yichen'
export STOREPATH='/store/yichen'

alias crab-setup='source /cvmfs/cms.cern.ch/crab3/crab.sh'

alias smake='scram b -j 8'
alias bpktest='cmsRun bprimeKit_miniAOD_MC.py   maxEvts=100 Debug=100 2>&1 | tee log.txt'
alias bpkdata='cmsRun bprimeKit_miniAOD_data.py maxEvts=100 Debug=100 2>&1 | tee log.txt'
alias fatalCheck='cat log.txt | grep -A 10 -B 10 Fatal'

unset SSH_ASKPASS ## Disabling gnome 

my-cmsenv() {
   cmsenv 
   export PATH=$HOME/local/bin/:$PATH
   export LD_LIBRARY_PATH=$HOME/local/lib/:$HOME/local/lib64/:$LD_LIBRARY_PATH
}

inrne4 (){
   ssh inrne4
}
