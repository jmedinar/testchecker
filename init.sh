#!/bin/bash
# Author: Juan Medina
# Date: Aug 2024
# Description: Setup challenge scripts for module five

realuser=$(who am i | awk '{ print $1}')
if [[ ${UID} -ne 0 ]]; then echo "Execute this script with sudo"; exit 1; fi
if [[ $(wget -q --spider http://google.com; echo $?) -ne 0 ]]; then echo "Internet connection required"; exit 2; fi
source <(curl -sk -H 'Cache-Control: no-cache' $(echo "aHR0cHM6Ly9yYXcuZ2l0aHVidXNlcmNvbnRlbnQuY29tL2ptZWRpbmFyL3Rlc3RjaGVja2VyL21haW4vcGVyZm9ybWFuY2UvcGVyZi1jaGFsbGVuZ2UxLnNoCg==" | base64 -d))
echo Done!; exit 0
