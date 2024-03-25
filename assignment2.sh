#!/usr/bin/env bash
# Script: assignment1.sh
# Author: Professor Juan Medina
# Email: jmedina@collin.edu
# Date: 03/23/2024
# Purpose: This script will run the verifications of assignment 1

# CHALLENGE:

 

# Create a report file named system-backup.info inside the ~/backup/ directory (symbolized by ~, representing your user's home directory).

# Utilize redirections (> or >>) And the commands listed in the TIPS section below to extract and append the following requested information to the previously created report file:

 

#     The Fully Qualified Domain Name (FQDN) hostname of the system.
#     The current date of the system.
#     The uptime information of the system.
#     Echo your last name in the simple text following the format: LASTNAME: <Student lastname>.
#     Print the internal content of the /etc/resolv.conf file.
#     The list of files in the folder /var/log/ sorted alphabetically.
#     The report of file system space usage for the /home folder.
#     Run the command apropos uname  and piped to the grep command (look at the grep--help and find the option to reverse the result) using it to remove (reverse) the lines containing the word kernel in them.

# Warning: If you encounter the error "nothing appropriate" while running the apropos command, run the sudo mandb command and try again.

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






mod2 = {
    'Task1': {
        'd': 'System report file exist /tmp/stage2/system.info',
        'vc': "ls -l /tmp/stage2/system.info >/dev/null 2>&1; echo $?",
        'r': 0,
        'p': 'eq',
    },
    'Task2': {
        'd': 'Contains the full hostname',
        'vc': "grep $(hostname -f) /tmp/stage2/system.info >/dev/null 2>&1; echo $?",
        'r': 0,
        'p': 'eq',
    },
    'Task3': {
        'd': 'Contains the current date of the system',
        'vc': "grep -w \"$(date +\"%Y\")\" /tmp/stage2/system.info >/dev/null 2>&1; echo $? ",
        'r': 0,
        'p': 'eq',
    },
    'Task4': {
        'd': 'Contains the load of the system',
        'vc': "grep 'load average' /tmp/stage2/system.info >/dev/null 2>&1; echo $? ",
        'r': 0,
        'p': 'eq',
    }, 
    'Task5': {
        'd': 'Contains your lastname in the proper format',
        'vc': "grep 'LASTNAME' /tmp/stage2/system.info >/dev/null 2>&1; echo $? ",
        'r': 0,
        'p': 'eq',
    },
    'Task6': {
        'd': 'Content of the /etc/resolv.conf file',
        'vc': "grep 'nameserver' /tmp/stage2/system.info >/dev/null 2>&1; echo $?",
        'r': 0,
        'p': 'eq',
    }, 
    'Task7': {
        'd': 'The disk usage of the /home directory from the df command',
        'vc': "grep 'Filesystem' /tmp/stage2/system.info >/dev/null 2>&1; echo $?",
        'r': 0,
        'p': 'eq',
    }, 
    'Task8': {
        'd': 'The output of the ~apropos backup~ command without the word ~snapshots~',
        'vc': "grep snapshots /tmp/stage2/system.info >/dev/null 2>&1; echo $?",
        'r': 1,
        'p': 'eq',
    }, 
}





