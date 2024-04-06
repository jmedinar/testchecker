#!/usr/bin/env bash
# Script: assignment6.sh
# Author: Professor Juan Medina
# Email: jmedina@collin.edu
# Date: 03/23/2024

# Red           Green         Yellow        Blue          Purple        Cyan          White
CR='\e[0;31m' CG='\e[0;32m' CY='\e[0;33m' CL='\e[0;34m' CP='\e[0;35m' CC='\e[0;36m' CW='\e[0;37m'
assignment=6

echo -e "${CC} ========================================================================="
echo -e "${CP} Assignment ${assignment} Verification"
echo -e "${CC} ========================================================================="
echo -e "${CR} Assignment 6 does not have automated verification!
${CY} 
 Please submit the ${CL} SOURCE CODE ${CY} of your ${CG} sysmonitor.sh ${CY} script 
 on Canvas as evidence of your work. Your submission will be graded by the professor 
 based on the functionality, quality, and presentation of your code.${CW}"

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
