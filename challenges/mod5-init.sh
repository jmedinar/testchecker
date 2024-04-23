#!/bin/bash
# Author: Juan Medina
# Date: Apt 2024
# Description: Setup challenge scripts for module five

# Red             Green          Yellow            Blue
CR='\e[0;31m' CG='\e[0;32m' CY='\e[0;33m' CL='\e[0;34m'
# Purple          Cyan           White
CP='\e[0;35m' CC='\e[0;36m' CW='\e[0;37m'
realuser=$(who am i | awk '{ print $1}')

# Verifying the Script was Executed with root Privileges
if [[ ${UID} -ne 0 ]]; then
    echo -e "${CR}
    This script must be executed with sudo to acquire administrator (root) privileges!
    Example: ${CY} sudo bash ~/Downloads/mod5-init.sh ${CW}"
    exit 2
fi

# Verifying Internet Connection
if [[ $( wget -q --spider http://google.com; echo $?) -ne 0 ]]; then
    echo -e "${CR} Your Virtual Machine is currently not connected to the internet!
    ${CY}
    Connect it by clicking on the icons at the top right corner of Linux 
    and ensuring the Wi-Fi is enabled. 
    ${CL}
    Once corrected, rerun this script. ${CW}"
    exit 3
fi

mkdir -p /sysadm/bin
chown -R ${realuser}:${realuser}: /sysadm
cd /sysadm/bin || exit
curl -sk -H 'Cache-Control: no-cache' $(echo "" | base64 -d)
echo Done!
