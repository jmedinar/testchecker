#!/usr/bin/env bash
# Script: assignment8.sh
# Author: Professor Juan Medina
# Email: jmedina@collin.edu
# Date: 03/23/2024
# Purpose: Displays a congratulatory farewell message to students.

# --- Configuration ---
assignment=8

# Color Codes
CR='\e[0;31m' # Red
CG='\e[0;32m' # Green
CY='\e[0;33m' # Yellow
CL='\e[0;34m' # Blue
CP='\e[0;35m' # Purple
CC='\e[0;36m' # Cyan
CW='\e[0;37m' # White (reset)

# --- Helper Functions ---

function _print_line() {
    printf "${CC}%0.s=" {1..80} # Print 80 '=' characters
    printf "${CW}\n" # Reset color and add newline
}

# --- Verification Logic ---

_print_line
echo -e "${CP}Assignment ${assignment} Farewell!${CW}"
_print_line

# --- Display Farewell Message ---

figlet "Congratulations!" | lolcat
echo ""
echo -e "${CY}You've gained a lot of knowledge this semester!"
echo -e "While questions may still arise, remember that continuous practice"
echo -e "is the key to solidifying your Linux skills.${CW}"
figlet "Embrace the world of Linux!" | lolcat
echo ""
echo -e "${CC}Wishing you the best of luck on your journey!${CW}"
echo ""

_print_line
echo -e "${CP}End of Semester${CW}"
_print_line

# No grade calculation or reporting needed for this script
