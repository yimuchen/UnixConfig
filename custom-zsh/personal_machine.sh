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
export PATH=$PATH:$HOME/.gem/ruby/2.6.0/bin
export PATH=$PATH:/opt/resolve/bin
export PYTHONPATH=$PYTHONPATH:$HOME/.pylib
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$ROOTSYS/lib
export TDR_DIR=$HOME/HomeWork/CMS-Group/TDRMaster
export XDG_CONFIG_HOME=/home/ensc/.config # KDE command line themeing

# Importing common functions
source $HOME/.custom-zsh/tdr_settings.sh

# Machine specific alias
alias optirun="LD_PRELOAD=\"libpthread.so.0 libGL.so.1\" __GL_THREADED_OPTIMIZATIONS=1 optirun"
alias gphoto2='gphoto2 --port usb:'
alias scrcpy='scrcpy -m 800 -b 2M'
alias cura='env -u DESKTOP_SESSION -u KDE_FULL_SESSION -u XDG_CURRENT_DESKTOP cura'
#-------------------------------------------------------------------------------
#   Machine specific command pack
#-------------------------------------------------------------------------------
pacupdate() {
  prev=$(date -d "$(cat ~/.update.lock)" +%s)
  now=$(date +%s)
  if [[ $((now - prev)) -gt $((3600 * 24 * 7)) ]]; then
    echo "Performing system update"
    yay
    sudo pacdiff
    yay --query --unrequired --deps --quiet | yay --remove --nosave --recursive -
    date "+%Y-%m-%d" >~/.update.lock
  else
    echo "Previous update was at $(cat ~/.update.lock), less than a week ago"
    echo "You can still manually update by explicit yaourt calls"
  fi
}

#-------------------------------------------------------------------------------
#   Single command reboot to windows
#-------------------------------------------------------------------------------
winreboot() {
  local WINDOWS_TITLE=$(sudo grep -i 'windows' /boot/grub/grub.cfg | cut -d"'" -f2)
  sudo grub-reboot "$WINDOWS_TITLE"
  sudo reboot
}

#-------------------------------------------------------------------------------
#   Slow restart of Networkmanager
#-------------------------------------------------------------------------------
netrestart() {
  nmcli device disconnect wlp3s0
  sleep 1s
  sudo systemctl stop NetworkManager.service
  sleep 2s
  sudo modprobe -r rtl8821ae
  sleep 5s
  sudo modprobe rtl8821ae
  sleep 2s
  sudo systemctl start NetworkManager.service
  sleep 1s
  nmcli device connect wlp3s0
}

#-------------------------------------------------------------------------------
#   Conky restart
#-------------------------------------------------------------------------------
conkrestart() {
	pkill conky 2> /dev/null 
	conky -c ~/.Conky_config/conkyrc.lua 2> /dev/null
}

#-------------------------------------------------------------------------------
#   Networking
#-------------------------------------------------------------------------------
ntunode() {
  random=$(od -An -N1 -i </dev/urandom)
  printf "ntunode%02d" $((random % 20 + 1))
}

ntugridvpn() {
  sshuttle --dns -r yichen@ntugrid5 0/0 --exclude=140.112.104.121
}

umdcmsvpn() {
  sshuttle --dns -r umdcms 0/0 --exclude=128.8.216.5 --exclude=128.8.216.193
}

lxplus() {
  # returning random lxplus machine
  local machine=""
  local random=""
  while [ -z $ip ]; do
    random=$(od -An -N1 -i </dev/urandom)
    machine=$(printf "lxplus7%02d.cern.ch" $((random % 100 + 1)))
    if nc -vzw 1 ${machine} 22 2> /dev/null ; then
      break
    fi
  done
  echo $machine
}

lxplusvpn() {
  local machine=$(lxplus)
  local ip=$(getent ahost $machine | grep 'RAW' | awk '{print $1}')
  while [ -z $ip ]; do
    random=$(od -An -N1 -i </dev/urandom)
    machine=$(printf "lxplus7%03d.cern.ch" $((random % 100 + 1)))
    ip=$(getent ahosts $machine | grep 'RAW' | awk '{print $1}')
    echo $machine $ip
  done
  sshuttle -r yichen@$machine 0/0 --exclude=$ip
}

pdfremote() {
  remote=$1
  scp $1 /tmp
  zathura /tmp/$(basename $remote)
}

displayremote() {
  remote=$1
  scp $remote /tmp
  display /tmp/$(basename $remote)
}

rootremote() {
  remote=$1 
  scp $remote /tmp 
  root /tmp/$(basename $remote)
}


#-------------------------------------------------------------------------------
#   Midi playback aliases
#-------------------------------------------------------------------------------
alias playmidi="fluidsynth -l \
  --audio-driver=alsa         \
  --midi-driver=alsa_seq      \
  --no-shell                  \
  /usr/share/soundfonts/FluidR3_GM.sf2"

## Aliasing functions for processing
export PATH=$PATH:$HOME/.py_script

## Allowing for autocompletion
for script_file in $HOME/.py_script/*.py; do
  eval "$(register-python-argcomplete ${script_file})"
done

#-------------------------------------------------------------------------------
#   Geant4 Stuff 
#-------------------------------------------------------------------------------
export G4ENSDFSTATEDATA=/usr/share/geant4-ensdfstatedata/G4ENSDFSTATE2.2/
export G4REALSURFACEDATA=/usr/share/geant4-realsurfacedata/RealSurface2.1.1/
export G4LEDATA=/usr/share/geant4-ledata/G4EMLOW7.7/
