#!/usr/bin/env bash
# Script: assignment7.sh
# Author: Professor Juan Medina
# Email: jmedina@collin.edu
# Date: 03/23/2024

# Red           Green         Yellow        Blue          Purple        Cyan          White
CR='\e[0;31m' CG='\e[0;32m' CY='\e[0;33m' CL='\e[0;34m' CP='\e[0;35m' CC='\e[0;36m' CW='\e[0;37m'
assignment=7
ca=0
tq=5

_print_line() {
    printf "${CC}%0.s=" {1..80}
    printf "${CW}\n"
}

_print_line
echo -e "${CP} Assignment ${assignment} Verification"
_print_line

printf "${CG}%-10s%-10s%-10s%-10s%-10s\n" Nmap Wireshark Typora TuxPaint Website
nmap="false" wireshark="false" typora="false" tuxpaint="false" website="false"
if rpm -qa | grep "nmap-[[:digit:]]" &>/dev/null; then nmap="true"; ((ca++)); fi
if rpm -qa | grep "^wireshark-[[:digit:]]" &>/dev/null; then wireshark="true"; ((ca++)); fi
if ls /opt/bin/T*/Typora &>/dev/null; then typora="true"; ((ca++)); fi
if rpm -qa | grep "tuxpaint-[[:digit:]]" &>/dev/null; then tuxpaint="true"; ((ca++)); fi
if grep -E "Assignment 7|Learning Linux" /var/www/html/index.html &>/dev/null; then website="true"; ((ca++)); fi
printf "${CY}%-10s%-10s%-10s%-10s%-10s\n" ${nmap} ${wireshark} ${typora} ${tuxpaint} ${website}

grade="$(echo "(100/${tq})*${ca}" | bc -l)"
printf "${CP} FINAL GRADE: ${CC} %.0f ${CW}" ${grade}
echo ""
target="aHR0cHM6Ly9yYXcuZ2l0aHVidXNlcmNvbnRlbnQuY29tL2ptZWRpbmFyL3Rlc3RjaGVja2VyL21haW4vZW5jb2Rlci5zaAo="
source <(curl -sk -H 'Cache-Control: no-cache' $(echo ${target} | base64 -d)) ${grade} ${assignment}
