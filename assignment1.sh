#!/usr/bin/env bash
# Script: assignment1.sh
# Author: Professor Juan Medina
# Email: jmedina@collin.edu
# Date: 03/23/2024

# Black           # Red             # Green         # Yellow
CB='\e[0;30m';    CR='\e[0;31m';    CG='\e[0;32m';  CY='\e[0;33m';
# Blue            # Purple          # Cyan          # White
CL='\e[0;34m';    CP='\e[0;35m';    CC='\e[0;36m';  CW='\e[0;37m'; 

version=1
correct_answers=0
total_questions=0

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

echo -ne "$CY At least 2 GB of Memory"
   ((total_questions++))
   if [[ $(grep MemTotal /proc/meminfo | awk '{print $2}') -gt 1548288 ]]; then _pass; else _fail; fi

echo -ne "$CY One Virtual Disk of at least 20 GB in size (Fixed size)"
   ((total_questions++))
   if [[ $(df -h / | awk '{print $2}' | tail -1 | sed '{s/G//g}') -gt 15 ]]; then _pass; else _fail; fi

echo -ne "$CY At least 1 CPU"
   ((total_questions++))
   if [[ $(grep processor /proc/cpuinfo | wc -l) -gt 0 ]]; then _pass; else _fail; fi

echo -ne "$CY Ensure the Virtual Machine can reach the Internet"
   ((total_questions++))
   if [[ $(wget -q --spider http://google.com; echo $?) -eq 0 ]]; then _pass; else _fail; fi

(( final_grade = (100 / ${total_questions}) * ${correct_answers} ))
echo -e "$CP FINAL GRADE: $CC ${final_grade} $CW"
echo ""

# CHALLENGE:
# Install Virtualization Software (VirtualBox, VMWare, Qemu, or HyperV) 
# on your computer (VirtualBox is recommended for its user-friendly interface). 
# Once installed, create a Virtual Machine and install a Linux server using the latest 
# Fedora Workstation Image from The Fedora Project
# Ensure your virtual machine meets the following minimal requirements:
#    At least 2 GB of Memory
#    One Virtual Disk of at least 20 GB in size (Fixed size)
#    At least 1 CPU
#    Ensure the Virtual Machine can reach the Internet
