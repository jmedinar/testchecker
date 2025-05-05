#!/usr/bin/env bash
# Script: assignment3.sh
# Author: Professor Juan Medina
# Email: jmedina@collin.edu
# Date: 03/23/2024

# --- Configuration ---
assignment=3
correct_answers=0 # Counter for correct answers
total_questions=0 # Counter for total questions checked

# Base directory for the application structure
basedir="/opt/enterprise-app"
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
    local check_desc # Description for output table

    # Use relative path for display if it starts with basedir
    if [[ "$path" == "$basedir"* ]]; then
        check_desc=".${path#$basedir}" # e.g., ./bin/app.py
    else
        check_desc="$path"
    fi

    local exists="-" owner_ok="-" mode_ok="-"
    local actual_owner="" actual_mode=""
    local details=""

    # Check Existence
    ((total_questions++))
    if [[ -e "${path}" ]]; then
        exists="PASS"
        ((correct_answers++))

        # Check Owner (only if exists)
        ((total_questions++))
        actual_owner=$(stat -c %U "${path}" 2>/dev/null || echo "Error")
        if [[ "${actual_owner}" == "${expected_owner}" ]]; then
            owner_ok="PASS"
            ((correct_answers++))
        else
            owner_ok="FAIL"
            details+=" Own:${actual_owner}(Exp:${expected_owner})"
        fi

        # Check Mode (only if exists)
        ((total_questions++))
        actual_mode=$(stat -c %a "${path}" 2>/dev/null || echo "Error")
         if [[ "${actual_mode}" == "${expected_mode}" ]]; then
            mode_ok="PASS"
            ((correct_answers++))
        else
            mode_ok="FAIL"
            details+=" Mode:${actual_mode}(Exp:${expected_mode})"
        fi
    else
        exists="FAIL"
        owner_ok="FAIL" # Cannot check owner if not exists
        mode_ok="FAIL"  # Cannot check mode if not exists
        ((total_questions+=2)) # Increment tq for owner/mode checks even though they auto-fail
        details+=" Does not exist."
    fi

    # Print results row
    printf "${CY}%-40s %-10s %-10s %-10s ${CR}%s${CW}\n" \
        "${check_desc}" "${exists}" "${owner_ok}" "${mode_ok}" "${details}"
}

# Function to check for specific lines in the report file
# Arguments: $1=file_path_to_check_for (used to extract basename)
_check_report_content() {
    local file_path="$1"
    local filename=$(basename "${file_path}")
    local check_desc # Description for output table

    # Use relative path for display if it starts with basedir
    if [[ "$file_path" == "$basedir"* ]]; then
        check_desc=".${file_path#$basedir}" # e.g., ./bin/app.py
    else
        check_desc="$file_path"
    fi

    local owner_ok="-" perm_ok="-" inode_ok="-"
    local details=""

    # Check Owner line in report
    ((total_questions++))
    # Regex: Start of line (^), "OWNER:", optional whitespace (\s*), any chars (.*), the filename, any chars (.*)
    if grep -qE "^OWNER:\s*.*${filename}.*" "${report_path}"; then
        owner_ok="PASS"
        ((correct_answers++))
    else
        owner_ok="FAIL"
        details+=" Owner line missing."
    fi

    # Check Permissions line in report
    ((total_questions++))
    if grep -qE "^PERMISSIONS:\s*.*${filename}.*" "${report_path}"; then
        perm_ok="PASS"
        ((correct_answers++))
    else
        perm_ok="FAIL"
        details+=" Perms line missing."
    fi

    # Check Inode line in report
    ((total_questions++))
    if grep -qE "^INODE:\s*.*${filename}.*" "${report_path}"; then
        inode_ok="PASS"
        ((correct_answers++))
    else
        inode_ok="FAIL"
        details+=" Inode line missing."
    fi

    # Print results row
    printf "${CY}%-40s %-12s %-15s %-12s ${CR}%s${CW}\n" \
        "${check_desc}" "${owner_ok}" "${perm_ok}" "${inode_ok}" "${details}"
}

# --- Verification Logic ---

_print_line
echo -e "${CP}Assignment ${assignment} Verification Started${CW}"
_print_line

# Get the username from the environment variable set by sudo
# Assumes the parent script (testChecker.sh) already validated SUDO_USER
realuser="${SUDO_USER}"
# realuser=$(bash -c 'echo $SUDO_USER')

# --- File Structure Verification ---

echo -e "${CC}File Structure Verification (Existence / Owner / Mode)${CW}"
printf "${CG}%-40s %-10s %-10s %-10s %s${CW}\n" "OBJECT" "EXISTS" "OWNER" "MODE" "DETAILS"
_print_line
_check_file_metadata "${basedir}"             "root"     755
_check_file_metadata "${basedir}/bin"         "root"     755
_check_file_metadata "${basedir}/bin/app.py"  "root"     700
_check_file_metadata "${basedir}/code"        "${realuser}" 755
_check_file_metadata "${basedir}/code/alt_app_access" "${realuser}" 777
_check_file_metadata "${basedir}/flags"       "${realuser}" 755 # Directory check (trailing slash optional)
_check_file_metadata "${basedir}/flags/pid.info" "${realuser}" 644
_check_file_metadata "${basedir}/libs"        "${realuser}" 755 # Directory check
_check_file_metadata "${basedir}/logs"        "${realuser}" 755 # Directory check
_check_file_metadata "${basedir}/logs/stdout.log" "${realuser}" 644
_check_file_metadata "${basedir}/logs/stderr.log" "${realuser}" 644
_check_file_metadata "${basedir}/scripts"     "${realuser}" 755 # Directory check
_check_file_metadata "${basedir}/scripts/clean.sh" "${realuser}" 755
_check_file_metadata "${basedir}/docs"        "${realuser}" 755 # Directory check
_check_file_metadata "${basedir}/docs/README.txt" "${realuser}" 644
_check_file_metadata "${basedir}/docs/report.out" "${realuser}" 644
_print_line
echo ""

# --- Report Content Verification ---
echo -e "${CC}Report Content Verification (${report_path})${CW}"
# Check if report file exists before attempting content checks
if [[ -f "${report_path}" ]]; then
    printf "${CG}%-40s %-12s %-15s %-12s %s${CW}\n" "FILE CHECKED" "OWNER LINE" "PERMS LINE" "INODE LINE" "DETAILS"
    _check_report_content "${basedir}/bin/app.py"
    _check_report_content "${basedir}/scripts/clean.sh"
else
    echo -e "${CR}Error: Report file '${report_path}' not found. Cannot verify report content.${CW}" >&2
    # Increment total questions by the number of checks that would have run (2 files * 3 checks/file = 6)
    ((total_questions+=6))
    # correct_answers remains unchanged (effectively 0 for these checks)
fi
_print_line

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
