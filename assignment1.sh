#!/usr/bin/env bash
# Script: assignment1.sh
# Author: Professor Juan Medina
# Email: jmedina@collin.edu
# Date: Mar 2024

# --- Configuration ---

assignment=1
correct_answers=0 # Counter for correct answers
total_questions=0 # Counter for total questions checked

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

# 1. Memory Check (Target: > 1.8 GiB)
_msg "System Memory (> 1.8 GiB)"
mem_kib=$(grep MemTotal /proc/meminfo | awk '{print $2}')
# Calculate GiB (integer division is fine here)
mem_gib=$(( mem_kib / 1024 / 1024 ))
# Check if memory in KiB is greater than 1.8 * 1024 * 1024 KiB
if [[ ${mem_kib} -gt 1887436 ]]; then # 1.8 * 1024 * 1024 = 1887436.8
    _pass
else
    _fail
    echo -e "   ${CY}Detected Memory: ${mem_gib} GiB${CW}" # Show detected value on fail
fi

# 2. Disk Space Check (Target: Root filesystem > 15 GiB)
_msg "Root Disk Space (> 15 GiB)"
# Use df with specific block size (G) and output field (size)
# tail -n 1 skips the header line
disk_size_gib=$(df --output=size -B G / | tail -n 1 | sed 's/G//')
if [[ ${disk_size_gib} -gt 15 ]]; then
    _pass
else
    _fail
    echo -e "   ${CY}Detected Root Disk Size: ${disk_size_gib} GiB${CW}" # Show detected value on fail
fi

# 3. CPU Core Count Check (Target: > 0, essentially checks if info is available)
_msg "CPU Processor Count (> 0)"
cpu_cores=$(grep -c processor /proc/cpuinfo)
if [[ ${cpu_cores} -gt 0 ]]; then
    _pass
else
    _fail
    echo -e "   ${CY}Detected CPU Cores: ${cpu_cores}${CW}"
fi

# 4. Internet Connectivity Check (Target: Can reach google.com)
_msg "Internet Connectivity"
# Use curl, consistent with parent script. -s silent, -I head only, --fail fail fast, --connect-timeout
if curl -sI --fail --connect-timeout 5 http://google.com > /dev/null; then
    _pass
else
    _fail
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
echo "" # Add a blank line

# Source the encoder/reporter script, passing the calculated grade and assignment number
# Assumes the encoder script handles the student ID and username passed by the main testChecker
echo -e "${CY}Reporting results...${CW}"
# Use curl: -s silent, --fail error on HTTP failure, -L follow redirects
# If curl fails, set -e inherited from parent script should cause an exit
source <(curl -s --fail -L -H 'Cache-Control: no-cache' "${ENCODER_SCRIPT_URL}") "${grade}" "${assignment}"

# The script finish is handled by the parent script (testChecker.sh)
