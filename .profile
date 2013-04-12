# source .bashrc               
case "$-" in *i*) 
    [[ -r $HOME/.bashrc ]] && source $HOME/.bashrc ;; 
esac

# setup environment
export LC_ALL=
export LC_COLLATE="C"
export EDITOR="vim"
export VISUAL=$EDITOR
export FCEDIT="vim"
export BROWSER="/usr/bin/vimprobable2"
export PRINTER="HP_psc_1200_series"
export http_proxy="http://127.0.0.1:8118"
export https_proxy="http://127.0.0.1:8118"
export SYSTEMD_PAGER="/usr/bin/less -R"

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

