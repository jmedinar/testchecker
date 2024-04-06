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
   echo -e "${CG} PASS ${CR}"
   ((ca++))
}

_fail() {
   echo -e "${CR} FAIL ${CG}"
}

_eval() {
    if eval ${1} &>/dev/null; then _pass; else _fail; fi
}

echo -e "${CC} ========================================================================="
echo -e "${CP} Assignment ${assignment} Verification ${CW}"
echo -e "${CC} ========================================================================="

report="/home/$(who am i | awk '{print $1}')/backup/system-backup.info"

_msg "System report file exist ~/backup/system-backup.info"
if [[ $(ls -l ${report} &>/dev/null; echo $?) -eq 0 ]]
then 
    _pass
    _msg "Full Hostname:"
        _eval "grep $(hostname -f) ${report}"
    _msg "Current Date:"
        _eval "grep -E 'CDT|$(date +%Y)' ${report}"
    _msg "Uptime Information:"
        _eval "grep 'load average' ${report}"
    _msg "Lastname in the Proper Format:"
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
    echo -e "${CR} The verification process cannot proceed whithout the presence of the ~/backup/system-backup.info file. ${CW}"
fi

printf "${CP} FINAL GRADE: ${CC} %.0f ${CW}" "$(echo "(100/${tq})*${ca}" | bc -l)"
echo ""

# CHALLENGE:
# Create a report file named system-backup.info inside the ~/backup/ directory.
# Utilize redirections to extract and append the following information to the file:
#     The Fully Qualified Domain Name (FQDN) hostname of the system.
#     The current date of the system.
#     The uptime information of the system.
#     Echo your last name in the simple text following the format: LASTNAME: <Student lastname>.
#     Print the internal content of the /etc/resolv.conf file.
#     The list of files in the folder /var/log/ sorted alphabetically.
#     The report of file system space usage for the /home folder.
#     Run the command apropos uname and piped to the grep command to remove the lines containing the word kernel.
