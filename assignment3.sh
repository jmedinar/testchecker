#!/usr/bin/env bash
# Script: assignment3.sh
# Author: Professor Juan Medina
# Email: jmedina@collin.edu
# Date: 08/06/2025

# --- Configuration ---
assignment=3
correct_answers=0 # Counter for correct answers
total_questions=0 # Counter for total questions checked

# Base directory for the application structure
basedir="/home/${SUDO_USER}/enterprise-app"
# Report file path used in _check_report_content
report_path="${basedir}/docs/report.out"

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

# Function to check file/directory existence
# Arguments: $1=path
_check_existence() {
    local path="$1"
    _msg "Existence: ${path}"
    if [[ -e "${path}" ]]; then
        _pass
    else
        _fail
    fi
}

# Function to check for specific lines in the report file
# Arguments: $1=file_path_to_check_for, $2=expected_owner, $3=expected_mode, $4=expected_inode
_check_report_content() {
    local path="$1"
    local filename=$(basename "${path}")
    local expected_owner="$2"
    local expected_mode="$3"
    local expected_inode="$4"

    _msg "Report contains OWNER line for ${filename}"
    if grep "OWNER" "${report_path}" | grep -q ${filename}; then
        _pass
    else
        _fail
    fi

    _msg "Report contains PERMISSIONS line for ${filename}"
    if grep "PERMISSIONS" "${report_path}" | grep -q ${filename}; then
        _pass
    else
        _fail
    fi

    _msg "Report contains INODE line for ${filename}"
    if grep "INODE" "${report_path}" | grep -q ${filename}; then
        _pass
    else
        _fail
    fi
}

# --- Verification Logic ---

_print_line
echo -e "${CP}Assignment ${assignment} Verification Started${CW}"
_print_line

# Get the username from the environment variable set by sudo
realuser="${SUDO_USER}"

# --- File Structure Verification ---
echo -e "${CC}File Structure and Existence Verification${CW}"
_print_line
_check_existence "${basedir}"
_check_existence "${basedir}/bin"
_check_existence "${basedir}/code"
_check_existence "${basedir}/docs"
_check_existence "${basedir}/flags"
_check_existence "${basedir}/libs"
_check_existence "${basedir}/logs"
_check_existence "${basedir}/scripts"
_check_existence "${basedir}/bin/app.py"
_check_existence "${basedir}/logs/stdout.log"
_check_existence "${basedir}/logs/stderr.log"
_check_existence "${basedir}/docs/README.txt"
_check_existence "${basedir}/scripts/clean.sh"
_check_existence "${basedir}/flags/pid.info"
_check_existence "${basedir}/docs/report.out"

_print_line
echo ""

# --- Report Content Verification ---
echo -e "${CC}Report Content Verification (${report_path})${CW}"
_print_line

# Check if report file exists before attempting content checks
if [[ -f "${report_path}" ]]; then
    app_py_path="${basedir}/bin/app.py"
    clean_sh_path="${basedir}/scripts/clean.sh"

    app_py_owner=$(stat -c %U "${app_py_path}")
    app_py_mode=$(stat -c %a "${app_py_path}")
    app_py_inode=$(stat -c %i "${app_py_path}")

    clean_sh_owner=$(stat -c %U "${clean_sh_path}")
    clean_sh_mode=$(stat -c %a "${clean_sh_path}")
    clean_sh_inode=$(stat -c %i "${clean_sh_path}")

    _check_report_content "${app_py_path}" "${app_py_owner}" "${app_py_mode}" "${app_py_inode}"
    _check_report_content "${clean_sh_path}" "${clean_sh_owner}" "${clean_sh_mode}" "${clean_sh_inode}"
else
    echo -e "${CR}Error: Report file '${report_path}' not found. Cannot verify report content.${CW}" >&2
    ((total_questions+=6))
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