#!/usr/bin/env bash
# Script: assignment2.sh
# Author: Professor Juan Medina
# Email: jmedina@collin.edu
# Date: 03/23/2024

# --- Configuration ---

assignment=2
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

# Get the username from the environment variable set by sudo
# Assumes the parent script (testChecker.sh) already validated SUDO_USER
realuser="${SUDO_USER}"
# realuser=$(bash -c 'echo $SUDO_USER')
report_path="/home/${realuser}/backup/system-backup.info"

# 1. Check if the report file exists
_msg "Report file exists (~/backup/system-backup.info)"
if [[ -f "${report_path}" ]]; then
    _pass

    # 2. Check for Full Hostname
    _msg "Report contains Full Hostname"
    # Use grep -F for fixed string search, -q for quiet (only exit status)
    if grep -qF "$(hostname -f)" "${report_path}"; then
        _pass
    else
        _fail
    fi

    # 3. Check for Current Date (Year and timezone check)
    _msg "Report contains Current Date Info (Year/Timezone)"
    # Checks for the current year OR CDT/CST timezone abbreviation
    # This might need refinement based on the exact expected date format in the report
    if grep -qE "($(date +%Y)|CDT|CST)" "${report_path}"; then
        _pass
    else
        _fail
    fi

    # 4. Check for Uptime Information
    _msg "Report contains Uptime Information ('load average')"
    if grep -q 'load average' "${report_path}"; then
        _pass
    else
        _fail
    fi

    # 5. Check for Last Name Placeholder (Assuming literal 'LASTNAME')
    _msg "Report contains 'LASTNAME' placeholder"
    if grep -q 'LASTNAME' "${report_path}"; then
        _pass
    else
        _fail
    fi

    # 6. Check for /etc/resolv.conf Content
    _msg "Report contains '/etc/resolv.conf' entries"
    if grep -q 'nameserver' "${report_path}"; then
        _pass
    else
        _fail
    fi

    # 7. Check for /var/log/ File List Content
    _msg "Report contains the list of files in the '/var/log' directory"
    # Assumes 'boot.log' is a representative file expected in the listing
    if grep -q 'boot.log' "${report_path}"; then
        _pass
    else
        _fail
    fi

    # 8. Check for /home Directory Space Usage Info
    _msg "Report contains space usage information for the '/home' directory"
    # Checks for the header typically included in df output
    if grep -q 'Filesystem' "${report_path}"; then
        _pass
    else
        _fail
    fi

    # 9. Check for 'apropos uname' Output (excluding 'kernel')
    _msg "Report contains 'apropos uname' output (without 'kernel')"
    # Use a pipeline: find lines with 'uname', then exclude lines with 'kernel'
    # grep -q returns true if *any* line matches the combined condition
    if grep 'uname' "${report_path}" | grep -qv 'kernel'; then
        _pass
    else
        _fail
    fi

else
    # Report file does not exist
    _fail
    echo -e "${CR}Error: The report file '${report_path}' was not found.${CW}" >&2
    echo -e "${CR}Cannot perform further checks for Assignment ${assignment}.${CW}" >&2
    exit 1
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
