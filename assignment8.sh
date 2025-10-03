#!/usr/bin/env bash
# Script: assignment8.sh
# Author: Professor Juan Medina
# Email: jmedina@collin.edu
# Date: 08/06/2025

# --- Configuration ---
assignment=8
correct_answers=0
total_questions=0

# Base directory and file paths
reports_dir="/home/${SUDO_USER}/reports"
report_path="${reports_dir}/package-management.info"
packages_to_install=("htop" "fastfetch" "iotop")
package_to_uninstall="fastfetch"
package_to_rollback="iotop"
package_group="Development Tools"

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

# 1. Check for reports directory
_msg "Directory '~/reports' exists"
if [[ -d "${reports_dir}" ]]; then
    _pass
else
    _fail
    echo -e "${CR}Error: The directory '${reports_dir}' was not found.${CW}" >&2
    echo -e "${CR}Cannot perform further checks for Assignment ${assignment}.${CW}" >&2
    exit 1
fi

# 2. Check for report file
_msg "Report file exists"
if [[ -f "${report_path}" ]]; then
    _pass
else
    _fail
    echo -e "${CR}Error: The report file '${report_path}' was not found.${CW}" >&2
    echo -e "${CR}Cannot perform further checks for Assignment ${assignment}.${CW}" >&2
    exit 1
fi

# 3. Check for the final state of the packages
_msg "Package '${package_to_uninstall}' is not currently installed"
if ! rpm -q "${package_to_uninstall}" &>/dev/null; then
    _pass
else
    _fail
fi

_msg "Package '${package_to_rollback}' is not currently installed"
if ! rpm -q "${package_to_rollback}" &>/dev/null; then
    _pass
else
    _fail
fi

_msg "Package 'htop' is currently installed"
if rpm -q "htop" &>/dev/null; then
    _pass
else
    _fail
fi

_msg "Package group '${package_group}' is installed"
if dnf group info development-tools 2>/dev/null | grep Installed | grep -q yes; then
    _pass
else
    _fail
fi

# 4. Check report file content for dnf history
_msg "Report contains dnf history record for 'install'"
if grep -q "install" "${report_path}"; then
    _pass
else
    _fail
fi

# 5. Check report file content for rpm -qi htop
_msg "Report contains detailed info for 'htop'"
if grep -q "Name        : htop" "${report_path}"; then
    _pass
else
    _fail
fi

# 6. Check report file content for dnf history showing 'erase' and 'rollback'
_msg "Report contains dnf history records for 'undo' and 'rollback'"
if grep -q "undo" "${report_path}" && grep -q "rollback" "${report_path}"; then
    _pass
else
    _fail
fi

# 7. Check report file content for the final rpm -qa output
_msg "Report contains final rpm output with only remaining packages"
if grep -q "htop-[0-9]*" "${report_path}"; then
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
