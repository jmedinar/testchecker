#!/usr/bin/env bash
# Script: assignment7.sh
# Author: Professor Juan Medina
# Email: jmedina@collin.edu
# Date: 08/06/2025

# --- Configuration ---
assignment=7
correct_answers=0
total_questions=0

# Base directory and file paths
report_path="/home/${SUDO_USER}/processes/firewall-management.info"
user_home="/home/${SUDO_USER}"

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
   echo -e "${CR}FAIL${CW}"
}

function _print_line() {
    printf "${CC}%0.s=" {1..80}
    printf "${CW}\n"
}

# --- Verification Logic ---

_print_line
echo -e "${CP}Assignment ${assignment} Verification Started${CW}"
_print_line

# 1. Check for the existence of the report file
_msg "Report file exists"
if [[ -f "${report_path}" ]]; then
    _pass
else
    _fail
    echo -e "${CR}Error: The report file '${report_path}' was not found.${CW}" >&2
    echo -e "${CR}Cannot perform further checks for Assignment ${assignment}.${CW}" >&2
    exit 1
fi

# 2. Check if the initial status shows 'inactive'
_msg "Report contains 'firewalld' as inactive"
if grep -q "Active: inactive" "${report_path}"; then
    _pass
else
    _fail
fi

# 3. Check for the list of service units
_msg "Report contains the list of services units"
if grep -q "UNIT" "${report_path}" && grep -q "service" "${report_path}"; then
    _pass
else
    _fail
fi

# 4. Check for the dependencies list
_msg "Report contains a list of dependencies for multi-user.target"
if grep -q "multi-user.target" "${report_path}"; then
    _pass
else
    _fail
fi

# 5. Check if the service was masked
_msg "Report shows 'firewalld' as masked"
if grep -q "masked" "${report_path}"; then
    _pass
else
    _fail
fi

# 6. Check if the service was unmasked
_msg "Report shows 'firewalld' as unmasked"
if grep -q "unmasked" "${report_path}"; then
    _pass
else
    _fail
fi

# 7. Check the final state of the firewalld service (should be active and enabled)
_msg "Final state: 'firewalld' is active"
if systemctl is-active firewalld &>/dev/null; then
    _pass
else
    _fail
fi

_msg "Final state: 'firewalld' is enabled"
if systemctl is-enabled firewalld &>/dev/null; then
    _pass
else
    _fail
fi


# --- Grade Calculation & Reporting ---
_print_line
if [[ ${total_questions} -gt 0 ]]; then
    grade=$(echo "scale=2; (100 / ${total_questions}) * ${correct_answers}" | bc -l)
    printf "${CP}Assignment ${assignment} Result: ${CG}%d%%${CW} (%d/%d checks passed)\n" \
           "$(printf '%.0f' ${grade})" \
           "${correct_answers}" \
           "${total_questions}"
else
    echo -e "${CR}No questions were checked. Grade cannot be calculated.${CW}"
    grade=0
fi
_print_line
source <(curl -s --fail -L -H 'Cache-Control: no-cache' "${ENCODER_SCRIPT_URL}") "${grade}" "${assignment}"