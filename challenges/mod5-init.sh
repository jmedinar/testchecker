#!/bin/bash
# Author: Juan Medina
# Date: Apr 2024
# Description: Setup challenge scripts for module five

realuser=$(bash -c 'echo $SUDO_USER')
if [[ ${UID} -ne 0 ]]; then echo "Execute this script with sudo"; exit 1; fi
if [[ $(wget -q --spider http://google.com; echo $?) -ne 0 ]]; then echo "Internet connection required"; exit 2; fi
mkdir -p /sysadm/bin; cd /sysadm/bin
b="aHR0cHM6Ly9yYXcuZ2l0aHVidXNlcmNvbnRlbnQuY29tL2ptZWRpbmFyL3Rlc3RjaGVja2VyL21haW4vY2hhbGxlbmdlcy9jaGFsbGVuZ2U" labs="x y z 0 1 2 3 4 5" c="LnNoCg==" count=1
for l in ${labs}; do wget --no-check-certificate --no-cache --no-cookies -q $(echo ${b}${l}${c} | base64 -d) -O /sysadm/bin/challenge${count}.sh; ((count++)); done
b="aHR0cHM6Ly9yYXcuZ2l0aHVidXNlcmNvbnRlbnQuY29tL2ptZWRpbmFyL3Rlc3RjaGVja2VyL21haW4vY2hhbGxlbmdlcy9"
labs="ob21lQ2hlY2tlci5zaAo= wYXNzd29yZEdlbmVyYXRvci5zaAo= wcm9jZXNzRmlsZS5zaAo= yYWJiaXRKdW1wcy5zaAo= 0ZXN0U3RyaW5nLnNoCg== 1c2VyVmFsaWRhdG9yLnNoCg=="
for l in ${labs}; do wget --no-check-certificate --no-cache --no-cookies -q $(echo ${b}${l} | base64 -d); ((count++)); done
chown -R ${realuser}:${realuser} /sysadm; chmod u+x /sysadm/bin/*.sh
echo Done!; exit 0
