#!/bin/env bash

export _JAVA_AWT_WM_NONREPARENTING=1

feh --no-fehbg --bg-fill "$HOME/Pictures/Wallpapers/samurai.jpg"
clstatus &

xrdb -merge ~/.Xresources
/usr/libexec/polkit-mate-authentication-agent-1 &

(sleep 2 && xset r rate 300 75 && setxkbmap latam && picom --backend glx) &

exec dbus-launch --sh-syntax --exit-with-session dwm
