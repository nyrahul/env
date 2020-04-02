#!/bin/bash

# use touchpad.sh ... to disable
# use touchpad.sh enabled ... to enable

cmd=${1-disabled}

echo "Touchpad $cmd ..."

gsettings set org.gnome.desktop.peripherals.touchpad send-events $cmd
