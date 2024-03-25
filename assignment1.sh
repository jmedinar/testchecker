#!/usr/bin/env bash
# Script: assignment1.sh
# Author: Professor Juan Medina
# Email: jmedina@collin.edu
# Date: 03/23/2024
# Purpose: This script will run the verifications of assignment 1

# CHALLENGE:
#
# Install Virtualization Software (VirtualBox, VMWare, Qemu, or HyperV) 
# on your computer (VirtualBox is recommended for its user-friendly interface). 
# Once installed, create a Virtual Machine and install a Linux server using the latest 
# Fedora Workstation Image from The Fedora Project
#
# Ensure your virtual machine meets the following minimal requirements:
#
#    At least 2 GB of Memory
#    One Virtual Disk of at least 20 GB in size (Fixed size)
#    At least 1 CPU
#    Ensure the Virtual Machine can reach the Internet
# 

CB='\e[0;30m' # Black - Regular
CR='\e[0;31m' # Red
CG='\e[0;32m' # Green
CY='\e[0;33m' # Yellow
CL='\e[0;34m' # Blue
CP='\e[0;35m' # Purple
CC='\e[0;36m' # Cyan
CW='\e[0;37m' # White

correct_answers=0
total_questions=0

echo -e "$CP Assignment 1 Verification $CW"

echo -e "$CY At least 2 GB of Memory"
if [[ $(grep MemTotal /proc/meminfo | awk '{print $2}') -gt 1548288 ]]; then
    echo -ne "$CG OK $CR"
    correct_answers=correct_answers+1
    total_questions=total_questions+1
else
    echo -ne "$CR ERROR $CG"
fi

echo -e "$CY One Virtual Disk of at least 20 GB in size (Fixed size)"
if [[ $(df -h / | awk '{print $2}' | tail -1 | sed '{s/G//g}') -gt 15 ]]; then
    echo -ne "$CG OK $CR"
    correct_answers=correct_answers+1
    total_questions=total_questions+1
else
    echo -ne "$CR ERROR $CG"
fi

echo -e "$CY At least 1 CPU"
if [[ $(grep processor /proc/cpuinfo | wc -l) -gt 0 ]]; then
    echo -ne "$CG OK $CR"
    correct_answers=correct_answers+1
    total_questions=total_questions+1
else
    echo -ne "$CR ERROR $CG"
fi

echo -e "$CY Ensure the Virtual Machine can reach the Internet"
if [[ $(wget -q --spider http://google.com; echo $?) -eq 0 ]]; then
    echo -ne "$CG OK $CR"
    correct_answers=correct_answers+1
    total_questions=total_questions+1
else
    echo -ne "$CR ERROR $CG"
fi 

final_grade = ( 100.0 / ${total_questions} ) * ${correct_answers}
echo -e "$CP FINAL GRADE: ${final_grade} $CW"






