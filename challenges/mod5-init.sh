#!/bin/bash
# Author: Juan Medina
# Date: Apt 2024
# Description: Setup challenge scripts for module five

realuser=$(who am i | awk '{ print $1}')
if [[ ${UID} -ne 0 ]] && echo "Execute this script with sudo"; exit 2; fi
if wget -q --spider http://google.com; then echo "not connected to the internet!"; exit 3; fi
mkdir -p /sysadm/bin
cd /sysadm/bin || exit
bu="aHR0cHM6Ly9yYXcuZ2l0aHVidXNlcmNvbnRlbnQuY29tL2ptZWRpbmFyL3Rlc3RjaGVja2VyL21haW4vY2hhbGxlbmdlcy8K"
ch="Y2hhbGxlbmdlMS5zaAo= Y2hhbGxlbmdlMi5zaAo= Y2hhbGxlbmdlMy5zaAo= Y2hhbGxlbmdlNC5zaAo= Y2hhbGxlbmdlNS5zaAo= Y2hhbGxlbmdlNi5zaAo= Y2hhbGxlbmdlNy5zaAo= Y2hhbGxlbmdlOC5zaAo= Y2hhbGxlbmdlOS5zaAo="
for j in ${ch}; do curl -skH 'Cache-Control: no-cache' $(echo "${bu}${j}" | base64 -d); done
chown -R ${realuser}:${realuser}: /sysadm
echo Done!
