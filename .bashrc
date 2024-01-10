#
# ~/.bashrc
#

#export http_proxy=http://127.0.0.1:9910
#export https_proxy=http://127.0.0.1:9910

HISTSIZE=100000

export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx

export LD_LIBRARY_PATH="/home/suxxsfe/mjai/akochan"

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '

source /home/suxxsfe/bin/my_alias.sh

