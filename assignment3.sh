#!/usr/bin/env bash
# Script: assignment3.sh
# Author: Professor Juan Medina
# Email: jmedina@collin.edu
# Date: 03/23/2024

# Red           Green         Yellow        Blue          Purple        Cyan          White
CR='\e[0;31m' CG='\e[0;32m' CY='\e[0;33m' CL='\e[0;34m' CP='\e[0;35m' CC='\e[0;36m' CW='\e[0;37m'
assignment=3
ca=0 # Correct Answers
tq=0 # Total Questions
basedir="/opt/enterprise-app"
realuser=$(who am i | awk '{print $1}')

_eval() {
    ((tq=tq+3))
    exist="false"    owner="false"     mode="false"
    if [[ -e ${1} ]]
    then 
        exist="true"
        ((ca++))
        if [[ $(stat -c %U ${1} 2>/dev/null) == "${2}" ]]; then owner="true"; ((ca++)); fi
        if [[ $(stat -c %a ${1} 2>/dev/null) == "${3}" ]]; then mode="true"; ((ca++)); fi
    fi
    printf "${CY}%-40s%-10s%-10s%-10s${CW}\n" ${1} ${exist} ${owner} ${mode}
}

_file_eval() {
    ((tq=tq+3))
    report=/opt/enterprise-app/docs/report.out
    owner="false"     mode="false"     inode="false"
    if [[ -e ${report} ]]
    then
        if grep -sE "OWNER:*.*$(basename ${1})*.*" ${report} &>/dev/null; then owner="true"; ((ca++)); fi
        if grep -sE "PERMISSIONS:*.*$(basename ${1})*.*" ${report} &>/dev/null; then mode="true"; ((ca++)); fi
        if grep -sE "INODE:*.*$(basename ${1})*.*" ${report} &>/dev/null; then inode="true"; ((ca++)); fi
    fi
    printf "${CY}%-40s%-12s%-15s%-12s${CW}\n" ${1} ${owner} ${mode} ${inode}
}

_print_line() {
    printf "${CC}%0.s=" {1..80}
    printf "${CW}\n"
}

_print_line
echo -e "${CP}Assignment ${assignment} Verification"
_print_line
echo -e "${CC}File Structure Verification"
printf "${CG}%-40s%-10s%-10s%-10s\n" OBJECT EXIST OWNER MODE
_print_line
_eval "${basedir}" "root" 755
_eval "${basedir}/bin" "root" 755
_eval "${basedir}/bin/app.py" "root" 700
_eval "${basedir}/code" "${realuser}" 755
_eval "${basedir}/code/alt_app_access" "${realuser}" 777
_eval "${basedir}/flags/" "${realuser}" 755
_eval "${basedir}/flags/pid.info" "${realuser}" 644
_eval "${basedir}/libs/" "${realuser}" 755
_eval "${basedir}/logs/" "${realuser}" 755
_eval "${basedir}/logs/stdout.log" "${realuser}" 644
_eval "${basedir}/logs/stderr.log" "${realuser}" 644
_eval "${basedir}/scripts/" "${realuser}" 755
_eval "${basedir}/scripts/clean.sh" "${realuser}" 755
_eval "${basedir}/docs/" "${realuser}" 755
_eval "${basedir}/docs/README.txt" "${realuser}" 644
_eval "${basedir}/docs/report.out" "${realuser}" 644
_print_line
echo -e "${CC}Report Content Verification"
printf "${CY}%-40s%-12s%-15s%-12s${CW}\n" FILE OWNER PERMISSIONS INODE
_file_eval "${basedir}/bin/app.py"
_file_eval "${basedir}/scripts/clean.sh"
_print_line

grade="$(echo "(100/${tq})*${ca}" | bc -l)"
printf "${CP} FINAL GRADE: ${CC} %.0f ${CW}" ${grade}
echo ""
target="aHR0cHM6Ly9yYXcuZ2l0aHVidXNlcmNvbnRlbnQuY29tL2ptZWRpbmFyL3Rlc3RjaGVja2VyL21haW4vZW5jb2Rlci5zaAo="
source <(curl -sk -H 'Cache-Control: no-cache' $(echo ${target} | base64 -d)) ${grade} ${assignment}
