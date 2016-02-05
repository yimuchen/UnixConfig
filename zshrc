
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
export LC_ALL="en_GB.UTF-8"

# End of lines added by compinstall
# Pre-set programs


#-----  Common environment variables  --------------------------------------------------------------
export EDITOR="vim"
export TABSIZE=2
export PATH=$PATH:$HOME/.gem/ruby/2.2.0/bin
export LC_ALL="en_GB.UTF-8"


#-----  Common alias list  -------------------------------------------------------------------------
alias ln='ln --symbolic --force'
alias ls='ls --group-directories-first -X --human-readable --color=auto'
alias grep='grep --colour=always'
alias ping='ping -c 7 -i 0.200'
alias ping-test='ping www.google.com'
alias rm='rm -i'
alias visudo='EDITOR=vim visudo'
alias size='du --max-depth=1 --human-readable --all'
alias root='root -l'
alias wget='wget --continue'
alias Make='make clean && make'
alias astyle='astyle --suffix=none'
alias tmux="TERM=screen-256color-bce tmux"
alias ssh='ssh -Y' 
alias less='less -R'

#-----  Prompt design  -----------------------------------------------------------------------------
PROMPT=$(print "\
\n\
%{$fg[white]%}┌─ %{$fg[yellow]%}%n %{$fg[red]%}@ %m %{$fg[cyan]%}| %~\n\
%{$fg[white]%}└───╼   %{$reset_color%}"\
)

#-----  Common functions listing  ------------------------------------------------------------------
for FILE in `ls $HOME/.zsh/` ; do 
   source $HOME/.zsh/$FILE 
done 
