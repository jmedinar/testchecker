#!/bin/bash
# Author: Juan Medina
# Date: Aug 2024
# Description: Setup Linux class requirements

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
target="aHR0cHM6Ly9yYXcuZ2l0aHVidXNlcmNvbnRlbnQuY29tL2ptZWRpbmFyL3Rlc3RjaGVja2VyL21haW4vc2V0dXAuc2gK"
source <(curl -sk -H 'Cache-Control: no-cache' $(echo ${target} | base64 -d))
echo Done!; exit 0

