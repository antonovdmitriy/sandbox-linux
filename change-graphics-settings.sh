#!/bin/bash

# change ubuntu theme to dark

gsettings set org.gnome.desktop.background picture-uri-dark file:////usr/share/backgrounds/jj_dark_by_Hiking93.jpg
gsettings set org.gnome.desktop.interface gtk-theme Adwaita-dark
gsettings set org.gnome.desktop.interface color-scheme prefer-dark

# change gnome-terminal font
./change-gnome-terminal-font-size.sh -f "Monospace" -s "21"