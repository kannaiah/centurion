# source .bashrc               
case "$-" in *i*) if [ -r ~/.bashrc ]; then . ~/.bashrc; fi;; esac

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

# export other directories to PATH
PATH=$PATH:/home/jason/Scripts:/usr/lib/surfraw/
export PATH="$PATH:$(ruby -rubygems -e 'puts Gem.user_dir')/bin"

# start keychain
/usr/bin/keychain -Q -q --nogui id_dsa id_rsa alioth bb B1BD4E40
[ -f $HOME/.keychain/${HOSTNAME}-sh ] && source $HOME/.keychain/${HOSTNAME}-sh
[ -f $HOME/.keychain/${HOSTNAME}-sh-gpg ] && source $HOME/.keychain/${HOSTNAME}-sh-gpg

# startx if on TTY1 and tmux on TTY2
if [[ -z "$DISPLAY" ]] && [[ $(tty) = /dev/tty1 ]]; then
    exec startx -- vt1 &>/dev/null
    logout
  elif [[ $(tty) = /dev/tty2 ]]; then
    tmux -f $HOME/.tmux/conf new -s secured
fi

