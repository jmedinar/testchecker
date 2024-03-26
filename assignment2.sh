#!/usr/bin/env bash
# Script: assignment2.sh
# Author: Professor Juan Medina
# Email: jmedina@collin.edu
# Date: 03/23/2024

# Black           # Red             # Green         # Yellow
CB='\e[0;30m';    CR='\e[0;31m';    CG='\e[0;32m';  CY='\e[0;33m';
# Blue            # Purple          # Cyan          # White
CL='\e[0;34m';    CP='\e[0;35m';    CC='\e[0;36m';  CW='\e[0;37m'; 

version=2
correct_answers=0
total_questions=0

_msg() {
   echo -ne "$CY $1"
   ((total_questions++))
}

_pass() {
   echo -e "$CG PASS $CR"
   ((correct_answers++))
}

_fail() {
   echo -e "$CR FAIL $CG"
}

echo -e "$CC ===================================================="
echo -e "$CP Assignment ${version} Verification $CW"
echo -e "$CC ===================================================="

report="/home/$(who am i | awk '{print $1}')/backup/system-backup.info"

_msg "System report file exist ~/backup/system-backup.info"
if [[ $(ls -l ${report} &>/dev/null; echo $?) -eq 0 ]]
then 
    _pass

    _msg "Full Hostname:"
        if [[ $(grep $(hostname -f) ${report} &>/dev/null; echo $?) -eq 0 ]]; then _pass; else _fail; fi

    _msg "Current Date:"
        if [[ $(grep -E 'CDT|$(date +%Y)' ${report} &>/dev/null; echo $?) -eq 0 ]]; then _pass; else _fail; fi

    _msg "Uptime Information:"
        if [[ $(grep "load average" ${report} &>/dev/null; echo $?) -eq 0 ]]; then _pass; else _fail; fi

    _msg "Lastname in the Proper Format:"
        if [[ $(grep 'LASTNAME' ${report} &>/dev/null; echo $?) -eq 0 ]]; then _pass; else _fail; fi

    _msg "Content of the /etc/resolv.conf File"
        if [[ $(grep 'nameserver' ${report} &>/dev/null; echo $?) -eq 0 ]]; then _pass; else _fail; fi

    _msg "List of Files in the /var/log/ Directory"
        if [[ $(grep 'boot.log' ${report} &>/dev/null; echo $?) -eq 0 ]]; then _pass; else _fail; fi

    _msg "Space Usage for the /home Directory"
        if [[ $(grep 'Filesystem' ${report} &>/dev/null; echo $?) -eq 0 ]]; then _pass; else _fail; fi

    _msg "The 'apropos uname' Command Output Without the String 'kernel'"
        if [[ $(grep uname ${report} | grep -v kernel &>/dev/null; echo $?) -eq 0 ]]; then _pass; else _fail; fi

else 
    _fail
    echo -e "$CR The verification process cannot proceed whithout the presence of the ~/backup/system-backup.info file. $CW"
fi

printf "$CP FINAL GRADE: $CC %.0f $CW" $(echo "(100/$total_questions)*$correct_answers" | bc -l)
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

