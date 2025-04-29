#!/bin/bash
# Script: encoder.sh
# Author: Professor Juan Medina
# Email: jmedina@collin.edu
# Date: Aug 2024

uuid=$(dmidecode -s system-uuid)
realuser=$(bash -c 'echo $SUDO_USER')
hostname=$(hostname -f)
today=$(date)

if [[ ${2} == "midterm" ]] || [[ ${2} == "final" ]]
then
    echo -e "${CY}$(echo "${uuid},${realuser},${1},${2},${hostname},${today}" | base64 -w 0)${CW}"
else
    echo -e "${CY}$(echo "${uuid},${realuser},${1},assignment${2},${hostname},${today}" | base64 -w 0)${CW}"
fi
