#!/usr/bin/env bash
# Script: assignment4.sh
# Author: Professor Juan Medina
# Email: jmedina@collin.edu
# Date: 08/06/2025

# --- Configuration ---
assignment=4
correct_answers=0 # Counter for correct answers
total_questions=0 # Counter for total questions checked

# Base directory for the application structure
basedir="/home/${SUDO_USER}/enterprise-app"
archive_path="/tmp/enterprise_app_backup.tar.gz"

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

# Function to check file/directory existence, owner, and mode (permissions)
# Arguments: $1=path, $2=expected_owner, $3=expected_mode (octal)
_check_file_metadata() {
    local path="$1"
    local expected_owner="$2"
    local expected_mode="$3"
    
    _msg "Existence: ${path}"
    if [[ -e "${path}" ]]; then
        _pass
    else
        _fail
        return
    fi

    _msg "Owner: ${path}"
    local actual_owner=$(stat -c %U "${path}" 2>/dev/null || echo "Error")
    if [[ "${actual_owner}" == "${expected_owner}" ]]; then
        _pass
    else
        _fail
    fi

    _msg "Permissions: ${path} (expected ${expected_mode})"
    local actual_mode=$(stat -c %a "${path}" 2>/dev/null || echo "Error")
    if [[ "${actual_mode}" == "${expected_mode}" ]]; then
        _pass
    else
        _fail
    fi
}

# Function to check if a path is a symbolic link and its target
# Arguments: $1=path_to_link, $2=expected_target
_check_symlink() {
    local path="$1"
    local expected_target="$2"
    local actual_target=""
    
    _msg "Is Symbolic Link: ${path}"
    if [[ -L "${path}" ]]; then
        _pass
    else
        _fail
        return
    fi

    _msg "Symbolic Link Target: ${path} -> ${expected_target}"
    actual_target=$(readlink "${path}" 2>/dev/null)
    if [[ "${actual_target}" == "${expected_target}" ]]; then
        _pass
    else
        _fail
    fi
}

# Function to check for a compressed archive
# Arguments: $1=archive_path
_check_archive() {
    local path="$1"
    
    _msg "Archive file exists: ${path}"
    if [[ -f "${path}" ]]; then
        _pass
    else
        _fail
        return
    fi

    _msg "Archive is a valid tar.gz file: ${path}"
    if file "${path}" | grep -q "gzip compressed data"; then
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

# --- File Metadata Verification ---
echo -e "${CC}File Structure, Ownership, and Permissions Verification${CW}"
_print_line
_check_file_metadata "${basedir}" "root" "755"
_check_file_metadata "${basedir}/bin" "root" "755"
_check_file_metadata "${basedir}/code" "${realuser}" "755"
_check_file_metadata "${basedir}/docs" "${realuser}" "755"
_check_file_metadata "${basedir}/flags" "${realuser}" "755"
_check_file_metadata "${basedir}/libs" "${realuser}" "755"
_check_file_metadata "${basedir}/logs" "${realuser}" "755"
_check_file_metadata "${basedir}/scripts" "${realuser}" "755"
_check_file_metadata "${basedir}/bin/app.py" "root" "700"
_check_file_metadata "${basedir}/logs/stdout.log" "${realuser}" "644"
_check_file_metadata "${basedir}/logs/stderr.log" "${realuser}" "644"
_check_file_metadata "${basedir}/docs/README.txt" "${realuser}" "644"
_check_file_metadata "${basedir}/scripts/clean.sh" "${realuser}" "755" # Anyone can execute, so 755 is a valid interpretation
_check_file_metadata "${basedir}/flags/pid.info" "${realuser}" "644"

_print_line
echo ""

# --- Symbolic Link Verification ---
echo -e "${CC}Symbolic Link Verification${CW}"
_print_line
_check_symlink "${basedir}/code/alt_app_access" "${basedir}/bin/app.py"
_print_line
echo ""

# --- Archive Verification ---
echo -e "${CC}Archive File Verification${CW}"
_print_line
_check_archive "${archive_path}"
_print_line
echo ""


# --- Grade Calculation & Reporting ---

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