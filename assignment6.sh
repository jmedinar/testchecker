#!/usr/bin/env bash
# Script: assignment6.sh
# Author: Professor Juan Medina
# Email: jmedina@collin.edu
# Date: 03/23/2024

# Black           # Red             # Green         # Yellow
CB='\e[0;30m';    CR='\e[0;31m';    CG='\e[0;32m';  CY='\e[0;33m';
# Blue            # Purple          # Cyan          # White
CL='\e[0;34m';    CP='\e[0;35m';    CC='\e[0;36m';  CW='\e[0;37m'; 

version=6
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

echo -e "$CR Assignment 6 does not have automated verification!. 
$CY Please submit the $CL SOURCE CODE $CY of your $CW sysmonitor.sh $CY script on Canvas as evidence of your work. 
 Your submission will be graded by the professor based on the functionality, quality, and presentation of your code. $CW"

# _msg "Verifying sysmonitor.sh"
#     if [[ $(/sysadm/bin/processFile.sh /etc/passwd 2>&1 | grep method | wc -l) -eq 0 ]]; then _pass; else _fail; fi
    
# (( final_grade = (100 / ${total_questions}) * ${correct_answers} ))
# echo -e "$CP FINAL GRADE: $CC ${final_grade} $CW"
# echo ""

# CHALLENGE:
# Create a script named sysmonitor.sh and position it in the /sysadm/bin Directory. 
# This script should serve as a tool to monitor system resources, providing a concise output with critical performance information.
# The script should generate the following output featuring the relevant details:
#
# Performance Report
#     Hostname:
#     Date:
#     Load Average:
#     Number of CPUs:
#     Total Memory:
#     Total SWAP:

