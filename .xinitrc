# -------------------------------------------------
# file:     ~/.xinitrc
# author:   jason ryan http://jasonwryan.com/
# vim:fenc=utf-8:nu:ai:si:et:ts=4:sw=4:ft=sh:
# -------------------------------------------------

# Source scripts in /etc/X11/xinit/xinitrc.d/
if [ -d /etc/X11/xinit/xinitrc.d ]; then
    for f in /etc/X11/xinit/xinitrc.d/*; do
        [ -x "$f" ] && . "$f"
    done
    unset f
fi

# load .Xresources
xrdb -merge $HOME/.Xresources

# enable restart X
setxkbmap -option terminate:ctrl_alt_bksp 

# disable CapsLock & map to Escape
setxkbmap -option caps:swapescape 

# compose key
setxkbmap -option compose:ralt

# numlock
numlockx &

# set wallpaper
sh $HOME/.fehbg &

# set cursor
xsetroot -cursor_name left_ptr &

# hide cursor
unclutter -noevents -idle 5 &

# start terminal emulation daemon
/usr/bin/urxvtd -q -o -f 

# clipboard synching
/usr/bin/autocutsel -fork &
/usr/bin/autocutsel -selection CLIPBOARD -fork &

# Check if mpd & other scripts are running
# and start them if they are not…
$HOME/Scripts/proc-check &

# automounting
/usr/bin/udiskie -s &

# ---- window manager ----
# launch dwm
exec $HOME/Scripts/dwm-start
