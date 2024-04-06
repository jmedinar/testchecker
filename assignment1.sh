#!/usr/bin/env bash
# Script: assignment1.sh
# Author: Professor Juan Medina
# Email: jmedina@collin.edu
# Date: 03/23/2024

#Red           Green         Yellow        Blue          Purple        Cyan          White
CR='\e[0;31m' CG='\e[0;32m' CY='\e[0;33m' CL='\e[0;34m' CP='\e[0;35m' CC='\e[0;36m' CW='\e[0;37m'
assignment=1
ca=0 # Correct Answers
tq=0 # Total Questions

_msg() {
   echo -ne "${CY} ${1}"
   ((tq++))
}

_pass() {
   echo -e "${CG} PASS ${CR}"
   ((ca++))
}

_fail() {
   echo -e "${CR} FAIL ${CG}"
}

echo -e "${CC} ========================================================================="
echo -e "${CP} Assignment ${assignment} Verification"
echo -e "${CC} ========================================================================="

_msg "Memory:"
   if [[ $(grep MemTotal /proc/meminfo | awk '{print $2}') -gt 1548288 ]]; then _pass; else _fail; fi

_msg "Disk:"
   if [[ $(df -h / | awk '{print $2}' | tail -1 | sed '{s/G//g}') -gt 15 ]]; then _pass; else _fail; fi

_msg "CPU:"
   if [[ $(grep processor /proc/cpuinfo | wc -l) -gt 0 ]]; then _pass; else _fail; fi

_msg "Internet:"
   if wget -q --spider http://google.com; then _pass; else _fail; fi

printf "${CP} FINAL GRADE: ${CC} %.0f ${CW}" "$(echo "(100/${tq})*${ca}" | bc -l)"
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
