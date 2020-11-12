#!/bin/bash

# On Gnome < 3.32, if you are using nVidia graphics cards it results in pixalated screen after resuming from suspend.
# The following commands refreshes the desktop and removes pixalations.

dbus-send --type=method_call --dest=org.gnome.Shell /org/gnome/Shell org.gnome.Shell.Eval "string:global.reexec_self()"
