#!/usr/bin/env bash
# Script: assignment8.sh
# Author: Professor Juan Medina
# Email: jmedina@collin.edu
# Date: 03/23/2024

# Red           Green         Yellow        Blue          Purple        Cyan          White
CR='\e[0;31m' CG='\e[0;32m' CY='\e[0;33m' CL='\e[0;34m' CP='\e[0;35m' CC='\e[0;36m' CW='\e[0;37m'
assignment=8

_print_line() {
    printf "${CC}%0.s=" {1..80}
    printf "${CW}\n"
}

_print_line
echo -e "${CP} Assignment ${assignment} Verification"
_print_line
figlet "Congratulations!" | lolcat
echo -e "${CY} You've gained a lot of knowledge, and while questions may arise, 
 continuous practice is the key to solidifying your skills."
figlet "Embrace the world of Linux!" | lolcat
echo -e "${CC} Wishing you the best of luck on your journey!${CW}"
