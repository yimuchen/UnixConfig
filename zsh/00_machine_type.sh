#-------------------------------------------------------------------------------
#
#   File        : machine_type.sh
#   Descriptions:
#                 List of machine specific files to load,
#                 this file will not be updated often
#
#-------------------------------------------------------------------------------

case $HOST in
ensc*)
  source ~/.custom-zsh/personal_machine.sh
  ;;
cmslpc*)
  source ~/.custom-zsh/cmssw.sh
  ;;
lxplus*)
  source ~/.custom-zsh/cmssw.sh
  ;;
*umd.edu)
  source ~/.custom-zsh/cmssw.sh
  ;;
login-el7.uscms.org)
  source ~/.custom-zsh/cmssw.sh
  ;;
ndpc3)
  source ~/.custom-zsh/ndpc3.sh
  ;;
*)
  # Error message for debugging.
  # echo "UNKNOWN MACHINE TYPE ${HOST}"
  # Do nothing for unrecognized
  ;;
esac
