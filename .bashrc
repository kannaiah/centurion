#-------------------------------------------------
# file:     ~/.bashrc
# author:   jason ryan - http://jasonwryan.com/
# vim:fenc=utf-8:nu:ai:si:et:ts=4:sw=4:ft=sh:
#-------------------------------------------------

# check for interactive
[[ $- = *i* ]] || return

# bash options ------------------------------------
set -o vi                   # Vi mode
set -o noclobber            # do not overwrite files
shopt -s autocd             # change to named directory
shopt -s cdable_vars        # if cd arg is not valid, assumes its a var defining a dir
shopt -s cdspell            # autocorrects cd misspellings
shopt -s checkwinsize       # update the value of LINES and COLUMNS after each command if altered
shopt -s cmdhist            # save multi-line commands in history as single line
shopt -s histappend         # do not overwrite history
shopt -s dotglob            # include dotfiles in pathname expansion
shopt -s expand_aliases     # expand aliases
shopt -s extglob            # enable extended pattern-matching features
shopt -s globstar           # recursive globbing…
shopt -s progcomp           # programmable completion
shopt -s hostcomplete       # attempt hostname expansion when @ is at the beginning of a word
shopt -s nocaseglob         # pathname expansion will be treated as case-insensitive

set_prompt_style () {
    if [ -n "$SSH_CLIENT" ]; then
        PS1="┌─[\[\e[0;34m\]\h\[\e[0m\] \[\e[1;33m\]\w:\[\e[0m\] \[\e[1;31m\]«SSH»\[\e[0m\]]\n└─╼ "
    else
        PS1="┌─[\[\e[34m\]\h\[\e[0m\] \[\e[32m\]\w\[\e[0m\]]\n└─╼ "
    fi
}

set_prompt_style

# set history variables 
unset HISTFILESIZE
HISTSIZE="5000"
HISTCONTROL=ignoreboth:erasedups
# share history across all terminals
PROMPT_COMMAND="history -a; history -c; history -r"
export HISTSIZE PROMPT_COMMAND

# command not found
source /usr/share/doc/pkgfile/command-not-found.bash

# visual bell
set bell-style visible

# colour coreutils
eval $(dircolors -b ~/.dir_colors)
export GREP_COLOR="1;31"
alias grep="grep --color=auto"
alias ls="ls --color=auto"

# TTYtter hack
export PERL_SIGNALS=unsafe

# ruby version management
if [[ -e /usr/local/share/chruby ]]; then
    source /usr/local/share/chruby/{chruby,auto}.sh
    chruby $(<$HOME/.ruby-version)
fi

######## Aliases ########

#The 'ls' family
# --------------------------
alias ll="ls -l --group-directories-first"
alias ls="ls -h --color"   # add colors for filetype recognition
alias la="ls -a"            # show hidden files
alias lx="ls -xb"           # sort by extension
alias lk="ls -lSr"          # sort by size, biggest last
alias lc="ls -ltcr"         # sort by and show change time, most recent last
alias lu="ls -ltur"         # sort by and show access time, most recent last
alias lt="ls -ltr"          # sort by date, most recent last
alias lm="ls -al |more"     # pipe through 'more'
alias lr="ls -lR"           # recursive ls
alias lsr="tree -Csu"       # nice alternative to 'recursive ls'

# General ------------------
alias less="less -FX"
alias sraw="sr archwiki"
alias exit="clear; exit"
alias wifi="wicd-curses"
alias cdp="mplayer cdda://"
alias updates="checkupdates"
alias blog="cd ~/VCS/octopress"
alias tmux="tmux -f ~/.tmux/conf"
alias 200="ssh 200 -t tmux a -d"
alias sent="ssh -t cent ssh -t 200"
alias dush="du -sm *|sort -n|tail"
alias fire="sudo ufw status verbose"
alias pong="ping -c 3 www.google.com"
alias socks="ssh -D 8080 -f -C -q -N 200"
alias vime="vim -u $HOME/.vim/vimencrypt -x"
alias nocomment='egrep -v "^[ \t]*#|^[ \t]*$"'
alias pi="ssh pi -t 'LANG=en_NZ.utf-8 tmux a -d'"
alias irc="rm -f $HOME/.irssi/saved_colors && irssi"
alias rss="newsbeuter -C $XDG_CONFIG_HOME/newsbeuter/config"
alias backmusic="rsync -azPv --exclude=Juno* Music /media/Apollo"
alias ttytter="Scripts/ttytter.pl -keyf=$HOME/.config/ttytter/key -rc=$HOME/.config/ttytter/jwr"

### Pacman ###
# bash completion
complete -cf pacman

# update
alias pacup="sudo pacman -Syu"

# Remove orphans
alias orphans="pacman -Qtdq"

# sudo pacman backup packages to Dropbox
alias pacback='pacman -Qqe | grep -v "$(pacman -Qmq)" > ~/Dropbox/Centurion/pklist.txt'

# check the log
paclog() { tail -n"$1" /var/log/pacman.log ;}

unsigned() { expac -S '%r %n %g'|awk '$3=="(null)" {print $1 "/" $2}' > unsigned.packages ; }

# Mounts
alias sentinel="sudo mount.nfs4 192.168.1.200:/ /media/Sentinel"

####### Functions ########

# Extract Files
extract() {
  if [ -f $1 ] ; then
      case $1 in
          *.tar.bz2)   tar xvjf $1    ;;
          *.tar.gz)    tar xvzf $1    ;;
          *.tar.xz)    tar xvJf $1    ;;
          *.bz2)       bunzip2 $1     ;;
          *.rar)       unrar x $1     ;;
          *.gz)        gunzip $1      ;;
          *.tar)       tar xvf $1     ;;
          *.tbz2)      tar xvjf $1    ;;
          *.tgz)       tar xvzf $1    ;;
          *.zip)       unzip $1       ;;
          *.Z)         uncompress $1  ;;
          *.7z)        7z x $1        ;;
          *.xz)        unxz $1        ;;
          *.exe)       cabextract $1  ;;
          *)           echo "\`$1': unrecognized file compression" ;;
      esac
  else
      echo "\`$1' is not a valid file"
  fi
}

# ssh tmux connections
shux() { args=("$@"); ssh "$1" -t LANG=en_NZ.utf-8 "${args[@]:1}" ;}

# processes
pids() { ps aux | grep $1 ;}

# Motherboard temp
temp() { awk '/^MB/ { sub(/+/, ""); print $3}' <(sensors) ;}

# paste to sprunge
sprung() { curl -F "sprunge=<-" http://sprunge.us <"$1" ;}

# list aur updates
aurup() { awk '{print $2}' </tmp/aurupdates* ;}

# Follow copied and moved files to destination directory
cpf() { cp "$@" && goto "$_"; }
mvf() { mv "$@" && goto "$_"; }
goto() { [ -d "$1" ] && cd "$1" || cd "$(dirname "$1")"; }

# edit posts in Octopress
pedit() { find source/_posts/ -name "*$1*" -exec vim {} \; ;}

# External IP
wmip(){ printf "External IP: %s\n" $(curl -s  http://ifconfig.me/) ;}

# Health of RAID array
raid() { awk '/^md/ {printf "%s: ", $1}; /blocks/ {print $NF}' </proc/mdstat ;}

# SSH Keys 
keys() { eval $(ssh-agent) && ssh-add ~/.ssh/{bb,id_*sa} ;}

# surfraw ML
surf() { awk '/surf/ {printf "%s", $3}' <$HOME/Dropbox/Documents/notes/misc | xsel -b ;}

# surfraw git
srgit() { git "$1" ssh://jasonwryan-guest@git.debian.org/git/surfraw/surfraw ; }

# attach tmux to existing session
mux() { [[ -z "$TMUX" ]] && { tmux attach -d || tmux -f $HOME/.tmux/conf new -s secured ;} }

# International timezone
zone() { TZ="$1"/"$2" date; }
zones() { ls /usr/share/zoneinfo/"$1" ;}

# Nice mount output
nmount() { (echo "DEVICE PATH TYPE FLAGS" && mount | awk '$2=$4="";1') | column -t; }

# Print man pages 
manp() { man -t "$@" | lpr -pPrinter; }

# Create pdf of man page - requires ghostscript and mimeinfo
manpdf() { man -t "$@" | ps2pdf - /tmp/manpdf_$1.pdf && xdg-open /tmp/manpdf_$1.pdf ;}

### Simple notes ------------------------------------------------
n() {
  local arg files=()
  for arg; do 
      files+=( $HOME/".notes/$arg" )
  done
  ${EDITOR:-vi} "${files[@]}";
}

nls() {
  tree -CR --noreport $HOME/.notes | awk '{
    if (NF==1) print $1
    else if (NF==2) print $2
    else if (NF==3) printf "  %s\n", $3
  }'
}

# TAB completion for notes
_notes() {
  local files=($HOME/.notes/**/"$2"*)
  [[ -e ${files[0]} ]] && COMPREPLY=( "${files[@]##$HOME/.notes/}" )
}
complete -o default -F _notes n

### linux console colors (jwr dark) ###

if [ "$TERM" = "linux" ]; then
    echo -en "\e]P0000000" #black
    echo -en "\e]P85e5e5e" #darkgrey
    echo -en "\e]P18a2f58" #darkred
    echo -en "\e]P9cf4f88" #red
    echo -en "\e]P2287373" #darkgreen
    echo -en "\e]PA53a6a6" #green
    echo -en "\e]P3914e89" #darkyellow
    echo -en "\e]PBbf85cc" #yellow
    echo -en "\e]P4395573" #darkblue
    echo -en "\e]PC4779b3" #blue
    echo -en "\e]P55e468c" #darkmagenta
    echo -en "\e]PD7f62b3" #magenta
    echo -en "\e]P62b7694" #darkcyan
    echo -en "\e]PE47959e" #cyan
    echo -en "\e]P7899ca1" #lightgrey
    echo -en "\e]PFc0c0c0" #white
    clear # bring us back to default input colours
fi

