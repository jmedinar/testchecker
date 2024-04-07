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
    if [[ -e ${1} ]]; then exist="true"; ((ca++)); fi
    if [[ $(stat -c %U ${1} 2>/dev/null) == "${2}" ]]; then owner="true"; ((ca++)); fi
    if [[ $(stat -c %a ${1} 2>/dev/null) == "${3}" ]]; then mode="true"; ((ca++)); fi
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
printf "${CP} FINAL GRADE: ${CC} %.0f ${CW}" "$(echo "(100/${tq})*${ca}" | bc -l)"
echo ""

# CHALLENGE:
# Create the following folder structure
# /opt
# ├── enterprise-app
#     ├── bin
#     ├── code
#     ├── docs
#     ├── flags
#     ├── libs
#     ├── logs
#     └── scripts
#
#     Ensure the user root is the owner of the enterprise-app folder.
#     Ensure your regular user account owns all the other folders in the structure except the bin/ folder.
#     Create the following files:
#         app.py in the bin folder
#         stdout.log and stderr.log in the logs folder
#         README.txt in the docs folder
#         clean.sh in the scripts folder
#         pid.info in the flags folder
#     Set the permissions for the created files as follows:
#         Anyone can execute the script scripts/clean.sh.
#         The files inside logs can be read by anyone, cannot be executed, and can only be written by the owner (your regular account).
#         The file bin/app.py should have the mode. 700.
#     Create a symbolic link named alt_app_access under the code folder of the structure. The link must point to the bin/app.py file.
#     Generate a report of the enterprise application by extracting information about the files we have created. 
#     Create the file docs/report.out and redirect the following information from two files, bin/app.py and scripts/clean.sh:
#           File owner in the format: OWNER:<FileName>:<Information>
#           File octal mode permissions in the format: PERMISSIONS:<FileName>:<Information>
#           File inode number in the format: INODE:<FileName>:<Information>
#     Create the enterprise_app_backup.tar.gz file of the /opt/enterprise-app structure at the /tmp directory.
