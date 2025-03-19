#!/bin/bash
# Script: encoder.sh
# Author: Professor Juan Medina
# Email: jmedina@collin.edu
# Date: Aug 2024

uuid=$(dmidecode -s system-uuid)
sname=$(who am i | awk '{print $1}')
hostname=$(hostname -f)
today=$(date)

if [[ ${2} == "midterm" ]] || [[ ${2} == "final" ]]
then
    echo -e "${CY} $(echo "${uuid},${sname},${1},${2},${hostname},${today}" | base64 -w 0)${CW}"
else
    echo -e "${CY} $(echo "${uuid},${sname},${1},assignment${2},${hostname},${today}" | base64 -w 0)${CW}"
fi
