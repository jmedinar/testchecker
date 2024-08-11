#!/bin/bash
# Author: Juan Medina
# Date: Aug 2024
# Description: Setup Linux class requirements

if [[ ${UID} -ne 0 ]]; then echo "Execute this script with sudo"; exit 1; fi
if [[ $(wget -q --spider http://google.com; echo $?) -ne 0 ]]; then echo "Internet connection required"; exit 2; fi
target="aHR0cHM6Ly9yYXcuZ2l0aHVidXNlcmNvbnRlbnQuY29tL2ptZWRpbmFyL3Rlc3RjaGVja2VyL21haW4vc2V0dXAuc2gK"
source <(curl -sk -H 'Cache-Control: no-cache' $(echo ${target} | base64 -d))
echo Done!; exit 0
