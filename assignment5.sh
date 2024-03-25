#!/usr/bin/env bash
# Script: assignment5.sh
# Author: Professor Juan Medina
# Email: jmedina@collin.edu
# Date: 03/23/2024

# Black           # Red             # Green         # Yellow
CB='\e[0;30m';    CR='\e[0;31m';    CG='\e[0;32m';  CY='\e[0;33m';
# Blue            # Purple          # Cyan          # White
CL='\e[0;34m';    CP='\e[0;35m';    CC='\e[0;36m';  CW='\e[0;37m'; 

version=5
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

_msg "Verifying processFile.sh"
    if [[ $(/sysadm/bin/processFile.sh /etc/passwd 2>&1 | grep method | wc -l) -eq 0 ]]; then _pass; else _fail; fi
    
_msg "Verifying rabbitJumps.sh"
    if [[ $(/sysadm/bin/rabbitJumps.sh 2>&1 | grep SUCCESS >/dev/null; echo $?) -eq 0 ]]; then _pass; else _fail; fi
    
_msg "Verifying testString.sh"
    if [[ $(/sysadm/bin/testString.sh 1 2>/dev/null) == "Binary or positive integer" ]]; then _pass; else _fail; fi
    
_msg "Verifying color.sh"
    if [[ $(/sysadm/bin/color.sh >/dev/null 2>&1; echo $?) -eq 0 ]]; then _pass; else _fail; fi
    
(( final_grade = (100 / ${total_questions}) * ${correct_answers} ))
echo -e "$CP FINAL GRADE: $CC ${final_grade} $CW"
echo ""

# CHALLENGE:
# Download the following scripts into the /sysadm/bin folder.
#       processFile.sh
#       rabbitJumps.sh
#       testString.sh
# Adjust the permissions of the scripts to ensure they are executable.
# Execute the scripts to test their functionality. Anticipate errors; identify and rectify any issues encountered!
# Craft a fourth script at the identical location as the preceding ones and label it color.sh. 
# The objective is for the script to display the string "I LOVE Linux!" with the word Linux highlighted in a color of your choosing!
