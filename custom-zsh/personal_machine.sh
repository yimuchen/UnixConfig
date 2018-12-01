#-------------------------------------------------------------------------------
#
#   File        : personal_machine.sh
#   Descriptions: Specific commands for Arch Linux machine
#
#-------------------------------------------------------------------------------

# Machine specific variables
export XDG_CONFIG_HOME=$HOME/.fontconf/
export ROOTSYS=/usr
export PATH=$PATH:$ROOTSYS/bin
export PATH=$PATH:$HOME/.gem/ruby/2.3.0/bin
export PATH=$PATH:$HOME/.gem/ruby/2.5.0/bin
export PATH=$PATH:$HOME/.py_script
export PATH=$PATH:/opt/resolve/bin
export PYTHONPATH=$PYTHONPATH:$HOME/.pylib
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$ROOTSYS/lib
export TDR_DIR=$HOME/HomeWork/CMS-Group/TDRMaster

# Importing common functions
source $HOME/.custom-zsh/tdr_settings.sh

# Machine specific alias
alias optirun="LD_PRELOAD=\"libpthread.so.0 libGL.so.1\" __GL_THREADED_OPTIMIZATIONS=1 optirun"
alias gphoto2='gphoto2 --port usb:'
alias scrcpy='scrcpy -m 800 -b 2M'

#-------------------------------------------------------------------------------
#   Machine specific command pack
#-------------------------------------------------------------------------------
pacupdate(){
  prev=$(date -d "$(cat ~/.update.lock)" +%s)
  now=$(date +%s)
  if [[ $((now-prev)) -gt $((3600*24*7)) ]]; then
    echo "Performing system update"
    yaourt --sync --refresh --sysupgrade -a;
    sudo --preserve-env pacdiffviewer;
    yaourt --query --unrequired --deps;
    date "+%Y-%m-%d" > ~/.update.lock
  else
    echo "Previous update was at $(cat ~/.update.lock), less than a week ago"
    echo "You can still manually update by explicit yaourt calls"
  fi
}

#-------------------------------------------------------------------------------
#   Networking test
#-------------------------------------------------------------------------------
ntunode() {
  random=$(od -An -N1 -i < /dev/urandom)
  printf "ntunode%02d" $((random%20+1))
}

ntugridvpn() {
  sshuttle --dns -r yichen@ntugrid5  0/0 --exclude=140.112.104.121
}

umdcmsvpn() {
  sshuttle --dns -r umdcms 0/0 --exclude=128.8.216.5 --exclude=128.8.216.193
}

lxplusvpn() {
  machine="";
  ip="";
  while [ -z $ip ] ; do
    random=$(od -An -N1 -i < /dev/urandom)
    machine=$(printf "lxplus%03d.cern.ch" $((random%300+1)))
    ip=$(getent ahosts $machine | grep 'RAW' | awk '{print $1}' )
    echo $machine $ip
  done
  sshuttle -r yichen@$machine 0/0 --exclude=$ip
}

fixrootpdf() {
  file=$1
  gs                         \
    -sDEVICE=pdfwrite        \
    -dCompatibilityLevel=1.4 \
    -dPDFSETTINGS=/screen    \
    -dNOPAUSE                \
    -dQUIET                  \
    -dBATCH                  \
    -sOutputFile=tmp.pdf     \
    ${file}
  mv tmp.pdf ${file}
}

displayremote() {
  remote=$1
  scp $remote /tmp
  display /tmp/$(basename $remote)
}

#-------------------------------------------------------------------------------
#   Midi playback aliases
#-------------------------------------------------------------------------------
alias playmidi="fluidsynth -l \
  --audio-driver=alsa         \
  --midi-driver=alsa_seq      \
  --no-shell                  \
  /usr/share/soundfonts/FluidR3_GM.sf2"
