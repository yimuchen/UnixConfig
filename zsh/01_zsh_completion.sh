#--------------------------------------------------------------------------------  
#  Source from:  http://dotshare.it/dots/105/6/raw/
#--------------------------------------------------------------------------------  

## Setting Advanced LS colors 
## Pulled from ntugrid
LS_COLORS=""

## Standard ls colors 
LS_COLORS+="rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01"
LS_COLORS+=":or=40;31;01:mi=01;05;37;41:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32"

## Compressed files 
LS_COLORS+=":*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31"
LS_COLORS+=":*.zip=01;31:*.z=01;31:*.Z=01;31:*.dz=01;31:*.gz=01;31:*.lz=01;31:*.xz=01;31:*.bz2=01;31:*.tbz=01;31"
LS_COLORS+=":*.tbz2=01;31:*.bz=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.rar=01;31:*.ace=01;31"
LS_COLORS+=":*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31"

## Visual multimedia 
LS_COLORS+=":*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35"
LS_COLORS+=":*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35"
LS_COLORS+=":*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.ogm=01;35:*.mp4=01;35"
LS_COLORS+=":*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35"
LS_COLORS+=":*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35"
LS_COLORS+=":*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.axv=01;35:*.anx=01;35:*.ogv=01;35:*.ogx=01;35"

## Audio multimedia
LS_COLORS+=":*.aac=01;36:*.au=01;36:*.flac=01;36:*.mid=01;36:*.midi=01;36:*.mka=01;36:*.mp3=01;36:*.mpc=01;36"
LS_COLORS+=":*.ogg=01;36:*.ra=01;36:*.wav=01;36:*.axa=01;36:*.oga=01;36:*.spx=01;36:*.xspf=01;36:"

export LS_COLORS

#--------------------------------------------------------------------------------  
#  General configuration
#--------------------------------------------------------------------------------  
zstyle ':completion:*'         accept-exact '*(N)'
zstyle ':completion:*'         separate-sections 'yes'
zstyle ':completion:*'         list-dirs-first true
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*'         menu select=200
zstyle ':completion:*'         use-perl=1
zstyle ':completion:*'         squeeze-slashes true
zstyle ':completion:*'                        matcher-list 'm:{a-z}={A-Z}'

zstyle ':completion:*:(all-|)files'          ignored-patterns '*.un~'

zstyle ':completion::complete:*'              use-cache on
zstyle ':completion::complete:*'              cache-path ~/etc/cache/$HOST
zstyle ':completion:*:*:kill:*:processes'    list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:processes'              command 'ps -axw'
zstyle ':completion:*:processes-names'        command 'ps -awxho command'
zstyle ':completion:*:functions'              ignored-patterns '_*'

zstyle ':completion:*' group-name            ''

#--------------------------------------------------------------------------------  
#  File navigation commands
#--------------------------------------------------------------------------------  
zstyle ':completion:*:*:(vim|rview|vimdiff|xxd):*:*files' \
  ignored-patterns '*~|*.(old|bak|zwc|viminfo|rxvt-*|zcompdump)|pm_to_blib|cover_db|blib' \
  file-sort modification
zstyle ':completion:*:*:(vim|rview|vimdiff|xxd):*' \
  file-sort modification
zstyle ':completion:*:*:(vim|rview|vimdiff|xxd):*' \
  tag-order files

#--------------------------------------------------------------------------------  
#  Navigation completions
#-------------------------------------------------------------------------------- 
setopt AUTO_PUSHD
setopt PUSHD_MINUS
setopt CDABLE_VARS
zstyle ':completion:*:directory-stack' list-colors '=(#b) #([0-9]#)*( *)==95=38;5;12'

zstyle ':completion:*:cd:*'            ignore-parents parent pwd
zstyle ':completion:*:*:(cd):*:*files' ignored-patterns '*~' file-sort access
zstyle ':completion:*:*:(cd):*'        file-sort access
zstyle ':completion:*:*:(cd):*'        menu select
zstyle ':completion:*:*:(cd):*'        completer _history

zstyle ':completion:*:*:perl:*'        file-patterns '*'


zstyle ':completion:*:descriptions' \
  format $'%{- \e[38;5;137;1m\e[48;5;234m%}%B%d%b%{\e[m%}'
zstyle ':completion:*:warnings' \
  format $'%{No match for \e[38;5;240;1m%}%d%{\e[m%}'


zstyle ':completion:most-accessed-file:*' match-original both
zstyle ':completion:most-accessed-file:*' file-sort access
zstyle ':completion:most-accessed-file:*' file-patterns '*:all\ files'
zstyle ':completion:most-accessed-file:*' hidden all
zstyle ':completion:most-accessed-file:*' completer _files


#--------------------------------------------------------------------------------  
#  SSH related command completion
#--------------------------------------------------------------------------------  
zstyle ':completion:*:*:(scp):*'             file-sort modification

zstyle ':completion:*:scp:*' group-order \
   users files all-files hosts-domain hosts-host hosts-ipaddr
zstyle ':completion:*:ssh:*' tag-order \
   users 'hosts:-host hosts:-domain:domain hosts:-ipaddr:IP\ address *'
zstyle ':completion:*:ssh:*' group-order \
   hosts-domain hosts-host users hosts-ipaddr
zstyle ':completion:*:(ssh|scp):*:hosts-host' ignored-patterns \
   '*.*' loopback localhost
zstyle ':completion:*:(ssh|scp):*:hosts-domain' ignored-patterns \
   '<->.<->.<->.<->' '^*.*' '*@*'
zstyle ':completion:*:(ssh|scp):*:hosts-ipaddr' ignored-patterns \
   '^<->.<->.<->.<->' '127.0.0.<->'
zstyle ':completion:*:(ssh|scp):*:users' ignored-patterns \
   adm bin daemon halt lp named shutdown sync
zstyle ':completion:*:(ssh|scp):*:my-accounts' users-hosts \
  'scp1@192.168.1.100' 'scp1@brutus.ethup.se' 'trapd00r@90.225.22.81'

zstyle -s ':completion:*:hosts' hosts _ssh_config
[[ -r ~/.ssh/config ]] && _ssh_config+=($(cat ~/.ssh/config | sed -ne 's/Host[=\t ]//p'))
zstyle ':completion:*:hosts' hosts $_ssh_config


zstyle '*' single-ignored show

go_prefixes=(5 6 8)
for p in $prefixes; do
  compctl -g "*.${p}" ${p}l
  compctl -g "*.go"   ${p}g
done
compctl -g "*.go" gofmt
compctl -g "*.go" gccgo

