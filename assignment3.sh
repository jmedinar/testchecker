#!/usr/bin/env bash
# Script: assignment3.sh
# Author: Professor Juan Medina
# Email: jmedina@collin.edu
# Date: 03/23/2024

# Black           # Red             # Green         # Yellow
CB='\e[0;30m';    CR='\e[0;31m';    CG='\e[0;32m';  CY='\e[0;33m';
# Blue            # Purple          # Cyan          # White
CL='\e[0;34m';    CP='\e[0;35m';    CC='\e[0;36m';  CW='\e[0;37m'; 

version=3
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

_dir(){
    _msg "Verify $1 exist"
        if [[ $(ls -d $1 &>/dev/null; echo $?) -eq 0 ]]; then _pass; else _fail; fi
}

_dir /opt/enterprise-app
_dir /opt/enterprise-app/bin
_dir /opt/enterprise-app/code
_dir /opt/enterprise-app/docs
_dir /opt/enterprise-app/flags
_dir /opt/enterprise-app/libs
_dir /opt/enterprise-app/logs
_dir /opt/enterprise-app/scripts

_msg "root is the owner of the enterprise-app folder"
    if [[ $(stat -c %U /opt/enterprise-app/ 2>/dev/null) == "root" ]]; then _pass; else _fail; fi

_msg "student's regular user owns all the other folders in the enterprise-app folder structure"
    if [[ $(ls -l /opt/enterprise-app/ | grep root &>/dev/null; echo $?) -eq 1 ]]; then _pass; else _fail; fi
     
_file() {
    _msg "Verify $1 exist"
        if [[ $(ls $1 &>/dev/null; echo $?) -eq 0 ]]; then _pass; else _fail; fi
}

_file /opt/enterprise-app/bin/app.py
_file /opt/enterprise-app/logs/stdout.log
_file /opt/enterprise-app/logs/stderr.log
_file /opt/enterprise-app/docs/README.txt
_file /opt/enterprise-app/scripts/clean.sh
_file /opt/enterprise-app/flags/pid.info

_mode() {
    _msg "Permissions (mode) of $1"
        if [[ $(stat -c %a $1 2>/dev/null) -eq $2 ]]; then _pass; else _fail; fi
}

_own() {
    _msg "Ownership of $1"
        if [[ $(stat -c %U $1 2>/dev/null) -eq $2 ]]; then _pass; else _fail; fi
}

_mode /opt/enterprise-app/scripts/clean.sh 754
_mode /opt/enterprise-app/logs/stdout.log 544
_own /opt/enterprise-app/logs/stdout.log root
_mode /opt/enterprise-app/logs/stderr.log 544
_own /opt/enterprise-app/logs/stderr.log root
_mode /opt/enterprise-app/bin/app.py 700

_file /opt/enterprise-app/code/alt_app_access
_msg "Correctness of symbolic link"
    if [[ $(stat -c %N /opt/enterprise-app/code/alt_app_access &>/dev/null; echo $?) -eq 0 ]]; then _pass; else _fail; fi
    
_file /opt/enterprise-app/docs/report.out

_stat() {
    report=/opt/enterprise-app/docs/report.out
    _msg "Report presents the value $1 for file $2"
        if [[ $(grep -sE "$1:*.*$2:" ${report} &>/dev/null; echo $?) -eq 0 ]]; then _pass; else _fail; fi
}

_stat OWNER bin/app.py
_stat OWNER scripts/clean.sh
_stat PERMISSIONS bin/app.py
_stat PERMISSIONS scripts/clean.sh
_stat INODE bin/app.py
_stat INODE scripts/clean.sh

(( final_grade = (100 / ${total_questions}) * ${correct_answers} ))
echo -e "$CP FINAL GRADE: $CC ${final_grade} $CW"
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
