
# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Lines configured by zsh-newuser-install
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
#zstyle :compinstall filename '/home/ensc/.zshrc'
#
zmodload zsh/complist
autoload -U colors && colors
autoload -Uz compinit
compinit
autoload bashcompinit
bashcompinit
# End of lines added by compinstall
# Pre-set programs

#-----  Common environment variables  ------------------------------------------
export EDITOR="vim"
export TABSIZE=2
export LC_ALL="en_US.UTF-8"

#-----  common functions listing  ----------------------------------------------
for file in `ls $HOME/.zsh/` ; do
   source $HOME/.zsh/$file
done

#-----  Common alias list ------------------------------------------------------
alias ln='ln --symbolic --force'
alias ls='ls --group-directories-first -X --human-readable --color=auto'
alias grp='grep --colour=always'
alias ping='ping -c 7 -i 0.200'
alias ping-test='ping www.google.com'
alias rm='rm -i'
alias visudo='EDITOR=vim visudo'
alias size='du --max-depth=1 --human-readable --all'
alias less='less --raw-control-chars'
alias root='root -l'
alias wget='wget --continue'
alias Make='make clean && make'
alias astyle='astyle --suffix=none'
alias tmux="TERM=screen-256color-bce tmux"
alias ssh='ssh -Y'
alias less='less -R'

#-----  Prompt design  ---------------------------------------------------------
PROMPT=$(print "\
\n\
%F{white}┌─ %F{yellow}%n %F{red}@ %m %F{cyan}| %~ %F{white}[%D{%y/%m/%f} %D{%L:%M:%S}]\n\
%F{white}└───╼ %{$reset_color%}  "\
)

#----- Time Command formatting -------------------------------------------------
TIMEFMT='[%J]'$'\n'\
'%U  user %S system %P cpu %*E total'$'\n'\
'avg shared (code):         %X KB'$'\n'\
'avg unshared (data/stack): %D KB'$'\n'\
'total (sum):               %K KB'$'\n'\
'max memory:                %M MB'$'\n'\
'page faults from disk:     %F'$'\n'\
'other page faults:         %R'