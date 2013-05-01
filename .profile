#-------------------------------------------------
# file:     ~/.profile
# author:   jason ryan - http://jasonwryan.com/
# vim:fenc=utf-8:nu:ai:si:et:ts=4:sw=4:ft=sh:
#-------------------------------------------------

# source .bashrc
case "$-" in *i*) 
    [[ -r $HOME/.bashrc ]] && source $HOME/.bashrc ;; 
esac

# setup default dirs
[[ "$XDG_CACHE_HOME" ]] || export XDG_CACHE_HOME="$HOME/.cache"
[[ "$XDG_CONFIG_HOME" ]] || export XDG_CONFIG_HOME="$HOME/.config"
[[ "$XDG_DATA_HOME" ]] || export XDG_DATA_HOME="$HOME/.local/share"

# setup environment
export LC_ALL=
export LC_COLLATE="C"
export EDITOR="vim"
export FCEDIT="vim"
export VISUAL=$EDITOR
export GPGKEY="B1BD4E40"
export BROWSER="$HOME/Scripts/vimprobtab.sh"
export PRINTER="HP_psc_1200_series"
export http_proxy="http://127.0.0.1:8118"
export https_proxy="http://127.0.0.1:8118"
export SYSTEMD_PAGER="/usr/bin/less -R"
# coloured man pages
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;34m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;30;03;36m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;35m'

# export other directories to PATH
PATH=$PATH:$HOME/Scripts:/usr/lib/surfraw/

# start keychain
/usr/bin/keychain -Q -q --nogui id_dsa id_rsa alioth archer bb B1BD4E40
[[ -f $HOME/.keychain/${HOSTNAME}-sh ]] && source $HOME/.keychain/${HOSTNAME}-sh
[[ -f $HOME/.keychain/${HOSTNAME}-sh-gpg ]] && source $HOME/.keychain/${HOSTNAME}-sh-gpg

# startx if on TTY1 and tmux on TTY2
if [[ -z "$DISPLAY" ]] && [[ $(tty) = /dev/tty1 ]]; then
    exec startx -- vt1 &>/dev/null
    logout
  elif [[ $(tty) = /dev/tty2 ]]; then
    tmux -f $HOME/.tmux/conf new -s secured
fi

