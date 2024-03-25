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

TITLE="Assignment 1 Verification"
echo -e "$CP $TITLE $CW"

echo -e "$CY At least 2 GB of Memory $CW"
echo -e "$CY One Virtual Disk of at least 20 GB in size (Fixed size) $CW"
echo -e "$CY At least 1 CPU $CW"
echo -e "$CY Ensure the Virtual Machine can reach the Internet $CW"

source <(curl -s http://mywebsite.example/myscript.txt)

