#!/usr/bin/env bash
# Script: assignment7.sh
# Author: Professor Juan Medina
# Email: jmedina@collin.edu
# Date: 03/23/2024
# Purpose: Verifies the installation of specific packages and website content for Assignment 7.

# --- Configuration ---
assignment=7
correct_answers=0 # Counter for correct answers
total_questions=0 # Counter for total questions checked

# Expected path for Typora if installed manually
TYPORA_EXEC_PATH="/opt/bin/Typora-*/sTypora"
# Expected path for the website index file
WEBSITE_INDEX_PATH="/var/www/html/index.html"

# Color Codes
CR='\e[0;31m' # Red
CG='\e[0;32m' # Green
CY='\e[0;33m' # Yellow
CL='\e[0;34m' # Blue
CP='\e[0;35m' # Purple
CC='\e[0;36m' # Cyan
CW='\e[0;37m' # White (reset)

ENCODER_SCRIPT_URL="https://raw.githubusercontent.com/jmedinar/testchecker/main/encoder.sh"

# --- Helper Functions ---

function _msg() {
   echo -ne "${CY}Checking: ${1}... ${CW}" 
   ((total_questions++))
}

function _pass() {
   echo -e "${CG}PASS${CW}"
   ((correct_answers++))
}

function _fail() {
   echo -e "${CR}FAIL${CW}" #
}

function _print_line() {
    printf "${CC}%0.s=" {1..80} # Print 80 '=' characters
    printf "${CW}\n" # Reset color and add newline
}

# --- Verification Logic ---

_print_line
echo -e "${CP}Assignment ${assignment} Verification Started${CW}"
_print_line

# Get the username from the environment variable set by sudo
# Assumes the parent script (testChecker.sh) already validated SUDO_USER
realuser="${SUDO_USER}"

# --- Perform Checks ---

# 1. Check Nmap installation
_msg "Nmap package installed"
# Use rpm -q for a direct query. Redirect stdout/stderr to hide output.
if rpm -q nmap &> /dev/null; then
    _pass
else
    _fail
fi

# 2. Check Wireshark installation
_msg "Wireshark package installed"
if rpm -q wireshark &> /dev/null; then
    _pass
else
    _fail
fi

# 3. Check Typora installation/existence
# This assumes Typora is installed manually or via a method not tracked by rpm.
# Adjust TYPORA_EXEC_PATH if the expected location is different.
_msg "Typora application exists"
if [[ -f "${TYPORA_EXEC_PATH}" ]]; then
    _pass
else
    _fail
fi

# 4. Check TuxPaint installation
_msg "TuxPaint package installed"
if rpm -q tuxpaint &> /dev/null; then
    _pass
else
    _fail
fi

# 5. Check Website Content
_msg "Website content"
if [[ ! -f "${WEBSITE_INDEX_PATH}" ]]; then
    _fail
    echo -e "      ${CR}(Hint: File ${WEBSITE_INDEX_PATH} not found)${CW}"
elif grep -qE "Assignment 7|Learning Linux" "${WEBSITE_INDEX_PATH}"; then
    _pass
else
    _fail
    echo -e "      ${CR}(Hint: Required text 'Assignment 7' or 'Learning Linux' not found in file)${CW}"
fi

# --- Grade Calculation & Reporting ---

echo "" # Add a blank line for spacing
_print_line
if [[ ${total_questions} -gt 0 ]]; then
    # Calculate grade using bc for floating point
    grade=$(echo "scale=2; (100 / ${total_questions}) * ${correct_answers}" | bc -l)
    # Print rounded grade
    printf "${CP}Assignment ${assignment} Result: ${CG}%d%%${CW} (%d/%d checks passed)\n" \
           "$(printf '%.0f' ${grade})" \
           "${correct_answers}" \
           "${total_questions}"
else
    echo -e "${CR}No questions were checked. Grade cannot be calculated.${CW}"
    grade=0 # Assign 0 if no questions were run
fi
_print_line
source <(curl -s --fail -L -H 'Cache-Control: no-cache' "${ENCODER_SCRIPT_URL}") "${grade}" "${assignment}"
