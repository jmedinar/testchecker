#!/usr/bin/env bash
# Script: assignment8.sh
# Author: Professor Juan Medina
# Email: jmedina@collin.edu
# Date: 03/23/2024

# Black           # Red             # Green         # Yellow
CB='\e[0;30m';    CR='\e[0;31m';    CG='\e[0;32m';  CY='\e[0;33m';
# Blue            # Purple          # Cyan          # White
CL='\e[0;34m';    CP='\e[0;35m';    CC='\e[0;36m';  CW='\e[0;37m'; 

version=8
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

echo ""
echo -e "$CP $TITLE $CW"
echo -e "$CL Congratulations on completing the class! $CW"
echo -e "$CY You've undoubtedly gained a lot of knowledge, and while questions may arise, continuous practice is the key to solidifying your skills. $CW"
echo -e "$CL With dedication, you'll soon find yourself evolving into a Linux expert. $CW"
echo -e "$CY Embrace the world of Linux! $CW"
echo -e "$CC Wishing you the best of luck on your journey! $CW"
echo ""
