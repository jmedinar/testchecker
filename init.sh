#!/bin/bash
# Author: Juan Medina
# Date: Mar 2025
# Description: Setup Linux Class System

if [[ ${UID} -ne 0 ]]; then echo "Execute this script with sudo"; exit 1; fi
if id "liveuser" &>/dev/null || [ -f /etc/live-release ] || [[ "$(findmnt -n -o FSTYPE /)" =~ (squashfs|overlay) ]]; then
    echo "Error: This script should not be run as the 'liveuser' or from the live ISO environment."
    echo "Please complete the Fedora installation and log in as a regular user before running this script."
    exit 1
fi
if ! grep -q '^ID=fedora$' /etc/os-release || [ ! -f /etc/fedora-release ] || ! command -v dnf &>/dev/null; then
    echo "Error: This script is designed to run on Fedora Linux only."
    echo "Please run this script on a Fedora Linux System."
    exit 1
fi
if [[ $(wget -q --spider http://google.com; echo $?) -ne 0 ]]; then echo "Internet connection required"; exit 2; fi

dnf install -yqq ansible git figlet lolcat
sleep 10
figlet "Linux Setup" | lolcat
curl -s -o /tmp/class-setup.yml https://raw.githubusercontent.com/jmedinar/testchecker/refs/heads/main/class-setup.yml 
ansible-playbook /tmp/class-setup.yml -t "repos,extra_packages,configurations,security,cockpit,looks,background,linux_looks,final"
figlet "Setup completed. Restarting..." | lolcat 
rm -rf /tmp/class-setup.yml
sleep 20
reboot
