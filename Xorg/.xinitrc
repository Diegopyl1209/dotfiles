#!/bin/env bash

export _JAVA_AWT_WM_NONREPARENTING=1

xrdb -merge ~/.Xresources

exec dbus-launch --sh-syntax --exit-with-session xmonad
