#!/usr/bin/env bash
# Script: assignment1.sh
# Author: Professor Juan Medina
# Email: jmedina@collin.edu
# Date: 03/23/2024
# Purpose: This script will run the verifications of assignment 1

# CHALLENGE:
#     Download the following scripts into the /sysadm/bin folder.
#         processFile.sh 
# Download processFile.sh
# rabbitJumps.sh
# Download rabbitJumps.sh
# testString.sh
#     Download testString.sh
# Adjust the permissions of the scripts to ensure they are executable.
# Execute the scripts to test their functionality. Anticipate errors; identify and rectify any issues encountered!
# Craft a fourth script at the identical location as the preceding ones and label it color.sh. The objective is for the script to display the string "I LOVE Linux!" with the word Linux highlighted in a color of your choosing!


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



mod5 = {
    'Task1': {
        'd': 'Verifying userValidator.sh',
        'vc': "/sysadm/bin/userValidator.sh >/dev/null 2>&1; echo $?",
        'r': 0,
        'p': 'eq',
    },
    'Task2': {
        'd': 'Verifying homeChecker.sh',
        'vc': "/sysadm/bin/homeChecker.sh >/dev/null 2>&1; echo $?",
        'r': 0,
        'p': 'eq',
    },
    'Task3': {
        'd': 'Verifying passwordGenerator.sh',
        'vc': "echo 10 | /sysadm/bin/passwordGenerator.sh >/dev/null 2>&1; echo $?",
        'r': 0,
        'p': 'eq',
    },
    'Task4': {
        'd': 'Verifying color.sh',
        'vc': "/sysadm/bin/color.sh >/dev/null 2>&1; echo $?",
        'r': 0,
        'p': 'eq',
    },
}
# mod6 doesn't have checker database
