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

# startx if on tty1 and tmux on tty2
if [[ -z "$DISPLAY" ]] && [[ $(tty) = /dev/tty1 ]]; then
    exec xinit -- :0 -novtswitch &>/dev/null &
    sleep 10
    logout
  elif [[ $(tty) = /dev/tty2 ]]; then
    tmux -f $HOME/.tmux/conf new -s secured
fi

# start keychain if secured tmux session launched
tsess=$(tmux ls 2>&1)

if [[ "${tsess%%:*}" = "secured" ]] && [[ -f $HOME/.keychain/$HOSTNAME-sh ]]; then
    # keychain
    /usr/bin/keychain -Q -q --nogui ~/.ssh/id_*
    source $HOME/.keychain/$HOSTNAME-sh
fi

