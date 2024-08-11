#!/usr/bin/env bash
# Script: assignment1.sh
# Author: Professor Juan Medina
# Email: jmedina@collin.edu
# Date: 03/23/2024

#Red           Green         Yellow        Blue          Purple        Cyan          White
CR='\e[0;31m' CG='\e[0;32m' CY='\e[0;33m' CL='\e[0;34m' CP='\e[0;35m' CC='\e[0;36m' CW='\e[0;37m'
assignment=1
ca=0 # Correct Answers
tq=0 # Total Questions

_msg() {
   echo -ne "${CY} ${1}"
   ((tq++))
}

_pass() {
   echo -e "${CG} true ${CR}"
   ((ca++))
}

_fail() {
   echo -e "${CR} false ${CG}"
}

_print_line() {
    printf "${CC}%0.s=" {1..80}
    printf "${CW}\n"
}

_print_line
echo -e "${CP} Assignment ${assignment} Verification"
_print_line

_msg "Memory:"
   if [[ $(grep MemTotal /proc/meminfo | awk '{print $2}') -gt 1548288 ]]; then _pass; else _fail; fi

_msg "Disk:"
   if [[ $(df -h / | awk '{print $2}' | tail -1 | sed '{s/G//g}') -gt 15 ]]; then _pass; else _fail; fi

_msg "CPU:"
   if [[ $(grep processor /proc/cpuinfo | wc -l) -gt 0 ]]; then _pass; else _fail; fi

_msg "Internet:"
   if wget -q --spider http://google.com; then _pass; else _fail; fi

grade="$(echo "(100/${tq})*${ca}" | bc -l)"
printf "${CP} FINAL GRADE: ${CC} %.0f ${CW}" ${grade}
echo ""
uuid=$(dmidecode -s system-uuid)
echo -e "${CY} $(echo "${uuid},${grade}" | base64 -w 0)${CW}"
echo ""
