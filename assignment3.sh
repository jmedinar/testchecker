#!/usr/bin/env bash
# Script: assignment1.sh
# Author: Professor Juan Medina
# Email: jmedina@collin.edu
# Date: 03/23/2024
# Purpose: This script will run the verifications of assignment 1

# CHALLENGE:

#         Create the following folder structure inside the existing system folder /opt:

# /opt
# ├── enterprise-app
#     ├── bin
#     ├── code
#     ├── docs
#     ├── flags
#     ├── libs
#     ├── logs
#     └── scripts

#     Ensure the user root is the owner of the enterprise-app folder.

#     Ensure your regular user account owns all the other folders in the structure except the bin/ folder (which should be owned by the root user).

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

#     Generate a report of the enterprise application by extracting information about the files we have created. Create the file docs/report.out and redirect the information obtained using the stat command. Extract the following information from two files, bin/app.py and scripts/clean.sh:

# Requested Information:

#     File owner in the format: OWNER:<FileName>:<Information>
#     File octal mode permissions in the format: PERMISSIONS:<FileName>:<Information>
#     File inode number in the format: INODE:<FileName>:<Information>

# Example using the /etc/passwd File as target:
# $ stat -c "INODE:%n:%i" /etc/passwd
# INODE:/etc/passwd:16948603

#     Finally, create the enterprise_app_backup.tar.gz compressed archive file of the /opt/enterprise-app folder structure and files, and save it inside the /tmp directory.


CB='\e[0;30m' # Black - Regular
CR='\e[0;31m' # Red
CG='\e[0;32m' # Green
CY='\e[0;33m' # Yellow
CL='\e[0;34m' # Blue
CP='\e[0;35m' # Purple
CC='\e[0;36m' # Cyan
CW='\e[0;37m' # White

TITLE="Assignment 1 Verification"
echo -e "$CP $TITLE $CW"

echo -e "$CY At least 2 GB of Memory $CW"
echo -e "$CY One Virtual Disk of at least 20 GB in size (Fixed size) $CW"
echo -e "$CY At least 1 CPU $CW"
echo -e "$CY Ensure the Virtual Machine can reach the Internet $CW"




mod3 = {
    'Task1': {
        'd': 'System report file exist /tmp/system.info.2',
        'vc': "ls -l /tmp/system.info.2 >/dev/null 2>&1; echo $?",
        'r': 0,
        'p': 'eq',
    },
    'Task2': {
        'd': 'Owner of passwd',
        'vc': "grep -s OWNER /tmp/system.info.2 | grep passwd | grep root >/dev/null 2>&1; echo $?",
        'r': 0,
        'p': 'eq',
    },
    'Task3': {
        'd': 'Owner of boot.log',
        'vc': "grep -s OWNER /tmp/system.info.2 | grep boot | grep root >/dev/null 2>&1; echo $?",
        'r': 0,
        'p': 'eq',
    },
    'Task4': {
        'd': 'Octal Permissions passwd',
        'vc': "grep -s PERMISSIONS /tmp/system.info.2 | grep passwd | grep $(stat -c '%a' /etc/passwd) >/dev/null 2>&1; echo $? ",
        'r': 0,
        'p': 'eq',
    }, 
    'Task5': {
        'd': 'Octal Permissions boot.log',
        'vc': "grep -s PERMISSIONS /tmp/system.info.2 | grep boot | grep $(stat -c '%a' /var/log/boot.log) >/dev/null 2>&1; echo $? ",
        'r': 0,
        'p': 'eq',
    },
    'Task6': {
        'd': 'Creation date of passwd',
        'vc': "grep -s 'DATE' /tmp/system.info.2 | grep passwd | grep $(date +\"%Y\") >/dev/null 2>&1; echo $?",
        'r': 0,
        'p': 'eq',
    }, 
    'Task7': {
        'd': 'Creation date of boot.log',
        'vc': "grep -s 'DATE' /tmp/system.info.2 | grep boot | grep $(date +\"%Y\") >/dev/null 2>&1; echo $?",
        'r': 0,
        'p': 'eq',
    }, 
    'Task8': {
        'd': 'Inode of passwd',
        'vc': "grep -s 'INODE' /tmp/system.info.2 | grep passwd | grep $(ls -i /etc/passwd | awk '{print $1}') >/dev/null 2>&1; echo $?",
        'r': 0,
        'p': 'eq',
    }, 
    'Task9': {
        'd': 'Inode of boot.log',
        'vc': "grep -s 'INODE' /tmp/system.info.2 | grep boot | grep $(ls -i /var/log/boot.log | awk '{print $1}') >/dev/null 2>&1; echo $?",
        'r': 0,
        'p': 'eq',
    }, 
    'Task10': {
        'd': 'Structure check 1',
        'vc': "ls -l /opt/system1/bin >/dev/null 2>&1; echo $?",
        'r': 0,
        'p': 'eq',
    }, 
    'Task11': {
        'd': 'Structure check 2',
        'vc': "ls -l /opt/system1/logs >/dev/null 2>&1; echo $?",
        'r': 0,
        'p': 'eq',
    }, 
    'Task12': {
        'd': 'Structure check 3',
        'vc': "ls -l /opt/system2/flags >/dev/null 2>&1; echo $?",
        'r': 0,
        'p': 'eq',
    }, 
    'Task13': {
        'd': 'Structure check 4',
        'vc': "ls -l /opt/system3 >/dev/null 2>&1; echo $?",
        'r': 0,
        'p': 'eq',
    }, 
    'Task14': {
        'd': 'Existence of system1.info',
        'vc': "ls -l /opt/system1/logs/system1.info >/dev/null 2>&1; echo $?",
        'r': 0,
        'p': 'eq',
    }, 
    'Task15': {
        'd': 'Permissions of system1.info',
        'vc': "stat -c '%a' /opt/system1/logs/system1.info 2>/dev/null | grep 764 >/dev/null 2>&1; echo $?",
        'r': 0,
        'p': 'eq',
    }, 
    'Task16': {
        'd': 'Link to system1.info',
        'vc': "ls -l /root/system1_link >/dev/null 2>&1; echo $?",
        'r': 0,
        'p': 'eq',
    }, 
    'Task18': {
        'd': 'Verification of the tar.gz',
        'vc': "ls -l /home/my_backup.tar.gz >/dev/null 2>&1; echo $?",
        'r': 0,
        'p': 'eq',
    }, 
}
