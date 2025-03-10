#!/usr/bin/bash
# Script: init.sh
# Author: Professor Juan Medina
# Email: jmedina@collin.edu
# Date: Apr 2024
version="2.0"
# Purpose: This script will setup the environment requirements for the 
#          class ITSC-1316.253: Linux Install & Configuration.

# Red           Green           Yellow          Blue
CR='\e[0;31m'   CG='\e[0;32m'   CY='\e[0;33m'   CL='\e[0;34m'
# Purple        Cyan            White
CP='\e[0;35m'   CC='\e[0;36m'   CW='\e[0;37m'

echo "Setting up your Linux system for the class..."
echo "Version" ${version}"
echo "Date: $(date +%D)

echo "Step 1: Verifying you are no longer running the installer"
if [[ ${USER} == "liveuser" ]]
then
    echo -e "Your system is running as the ${CR} liveuser ${CW}
    which indicates you are running under the ${CY} LIVE ISO Linux Installer ${CW}
    remove the ISO from your Virtual Machine and reboot.${CW}"
    echo "Exiting..."
    exit 1
fi

echo "Step 2: Setting up the testchecker tool"
code="aHR0cHM6Ly9yYXcuZ2l0aHVidXNlcmNvbnRlbnQuY29tL2ptZWRpbmFyL3Rlc3RjaGVja2VyL21haW4vdGVzdGNoZWNrZXIuc2gK"
wget --no-check-certificate --no-cache --no-cookies  -q $(echo ${code} | base64 -d) -O /usr/bin/testchecker
chmod 700 /usr/bin/testchecker

echo -e "Step 3: Modifying your prompt"
if [[ $(grep -qF 'export PS1' /etc/bashrc; echo $?) -ne 0 ]]
then
echo '
rc="\[\e[31m\]"
gc="\[\e[32m\]"
rs="\[\e[0m\]"
if [ $EUID -eq 0 ]
then
	export PS1="${rc}\u@\h \w${rs}# "
else
	export PS1="${gc}\u@\h \w${rs}\$ "
fi
' >> /etc/bashrc
else
    echo "  prompt is already set"
fi

echo -e "Step 4: Setting up the hostname"
hostnamectl set-hostname fedora

echo -e "${CG} Environment setup completed successfully!${CW}"
echo -e "${CY} Rebooting now!${CW}"
reboot
