#!/bin/bash
# Author: Juan Medina
# Date: Apt 2024
# Description: Setup challenge scripts for module five

realuser=$(who am i | awk '{ print $1}')
if [[ ${UID} -ne 0 ]]; then echo "Execute this script with sudo"; exit 1; fi
if [[ $(wget -q --spider http://google.com; echo $?) -ne 0 ]]; then echo "Internet connnection required"; exit 2; fi
mkdir -p /sysadm/bin
b="aHR0cHM6Ly9yYXcuZ2l0aHVidXNlcmNvbnRlbnQuY29tL2ptZWRpbmFyL3Rlc3RjaGVja2VyL21haW4vY2hhbGxlbmdlcy9jaGFsbGVuZ2U" labs="x y z 0 1 2 3 4 5" c="LnNoCg==" count=1
for l in ${labs}; do wget --no-check-certificate --no-cache --no-cookies -q $(echo ${b}${l}${c} | base64 -d) -O /sysadm/bin/challenge${count}.sh; ((count++)); done
chown -R ${realuser}:${realuser} /sysadm; chmod u+x /sysadm/bin/challenge*.sh
echo Done!; exit 0
