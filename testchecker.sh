#!/usr/bin/env bash
# Script: testChecker.sh
# Author: Professor Juan Medina
# Email: jmedina@collin.edu
# Date: 03/23/2024
# Purpose: This script gathers VM and Student information
#          and executes the interactive test verification scripts

# Cause pipelines to return the exit status of the last command that failed.
set -o pipefail

# --- Configuration ---
title="TestChecker"
version="6.0.1" # This version string is compared against the remote script's version

# Base URL for raw GitHub content
GH_RAW_BASE="https://raw.githubusercontent.com/jmedinar/testchecker/main"
SELF_SCRIPT_URL="${GH_RAW_BASE}/testchecker.sh"
ASSIGNMENT_URLS=(
    "${GH_RAW_BASE}/assignment1.sh"
    "${GH_RAW_BASE}/assignment2.sh"
    "${GH_RAW_BASE}/assignment3.sh"
    "${GH_RAW_BASE}/assignment4.sh"
    "${GH_RAW_BASE}/assignment5.sh"
    "${GH_RAW_BASE}/assignment6.sh"
    "${GH_RAW_BASE}/assignment7.sh"
    "${GH_RAW_BASE}/assignment8.sh"
)
FINAL_CHECK_URL="${GH_RAW_BASE}/finals/check-final.sh"

# Color Codes
CR='\e[0;31m' # Red
CG='\e[0;32m' # Green
CY='\e[0;33m' # Yellow
CL='\e[0;34m' # Blue
CP='\e[0;35m' # Purple
CC='\e[0;36m' # Cyan
CW='\e[0;37m' # White (reset)

# --- Pre-flight Checks ---

if [[ ${UID} -ne 0 ]]; then
    echo -e "${CR}Error: This script must be executed with sudo.${CW}" >&2
    exit 1
fi

if [[ -z "${SUDO_USER}" ]]; then
    echo -e "${CR}Error: Could not determine the original user. Make sure you are using 'sudo' correctly.${CW}" >&2
    exit 1
fi
realuser="${SUDO_USER}" # Use the environment variable

if id "liveuser" &>/dev/null || [ -f /etc/live-release ] || [[ "$(findmnt -n -o FSTYPE /)" =~ (squashfs|overlay) ]]; then
    echo -e "${CR}Error: This script should not be run as the 'liveuser' or from the live ISO environment.${CW}" >&2
    echo "Please complete the Fedora installation and log in as your user before running this script with sudo." >&2
    exit 1
fi

if [[ "${realuser}" == "vboxuser" ]]; then
    echo -e "${CR}Error: This script should not be run as the 'vboxuser'.${CW}" >&2
    echo "If using a computer at school, ensure you are logged in under your own user account before running this script with sudo." >&2
    exit 1
fi

if ! grep -q '^ID=fedora$' /etc/os-release || [ ! -f /etc/fedora-release ] || ! command -v dnf &>/dev/null; then
    echo -e "${CR}Error: This script is designed to run on Fedora Linux only.${CW}" >&2
    echo "Please run this script on a Fedora Linux System." >&2
    exit 1
fi

if [[ $(wget -q --spider http://google.com; echo $?) -ne 0 ]]; then 
	echo "Internet connection required"
	exit 2
fi

# --- Functions ---

function _update() {
    echo -e "${CY}Checking for updates to the TestChecker script...${CW}"
    local remote_version
    # Fetch remote version string: use grep and cut for simplicity
    # Assumes version line format is: version="X.Y.Z"
    remote_version=$(curl -s --fail -H 'Cache-Control: no-cache' "${SELF_SCRIPT_URL}" | grep '^version=' | cut -d'"' -f2)

    if [[ -z "${remote_version}" ]]; then
        echo -e "${CR}Warning: Could not retrieve remote version information. Skipping update check.${CW}" >&2
        return # Continue without update check if retrieval failed
    fi

    if [[ "${remote_version}" != "${version}" ]]; then
        echo -e "${CR}A new version (${remote_version}) of the TestChecker is available. Current version is ${version}.${CW}"
        echo -e "${CY}Attempting to upgrade...${CW}"

        if curl -s --fail -L -o /usr/bin/testchecker "${SELF_SCRIPT_URL}"; then
            chmod 700 /usr/bin/testchecker
            echo -e "${CG}Upgrade successful!${CW}"
            echo -e "${CY}Please rerun the testchecker command.${CW}"
            exit 5 # Exit so the user runs the new version
        fi
    else
        echo -e "${CG}TestChecker is up to date (Version: ${version}).${CW}"
    fi
}

function _print_line() {
    printf "${CC}%0.s=" {1..80} # Print 80 '=' characters
    printf "${CW}\n" # Reset color and add newline
}

# --- Main Script Logic ---

_update
clear
echo ""
_print_line
echo -e "${CL}                        C O L L I N   C O L L E G E "
echo -e "${CP}                        ${title} Version: ${version} "
_print_line
echo -e "${CG}DATE: ${CY}$(date)${CG} STUDENT: ${CY}${realuser}${CW}"

# Get student ID
studentid=""
while [[ ! "$studentid" =~ ^[0-9]+$ ]]; do
    read -p "Enter your numeric student ID: " studentid
    if [[ ! "$studentid" =~ ^[0-9]+$ ]]; then
        echo -e "${CR}Invalid input. Please enter numbers only.${CW}" >&2
    fi
done

# Determine which test to run (argument vs. interactive menu)
testtype="${1:-}" # Get first argument, default to empty string if not provided

if [[ -z "${testtype}" ]]; then
    # Interactive mode
    choice=""
    while [[ ! "$choice" =~ ^[1-8]$ ]]; do
        read -p "Enter the assignment number to check [1-8]: " choice
        if [[ ! "$choice" =~ ^[1-8]$ ]]; then
             echo -e "${CR}Invalid choice. Please enter a number between 1 and 8.${CW}" >&2
        fi
    done

    # Adjust index for 0-based array
    assignment_index=$((choice - 1))
    target_script_url="${ASSIGNMENT_URLS[${assignment_index}]}"
    # Source the script directly from the URL using process substitution
    source <(curl -s --fail -L -H 'Cache-Control: no-cache' "${target_script_url}")

else
    # Argument mode
    echo -e "${CY}Fetching and running the final check script...${CW}"
    source <(curl -s --fail -L -H 'Cache-Control: no-cache' "${FINAL_CHECK_URL}") "${testtype}" "${studentid}" "${realuser}"
fi

echo ""
_print_line
exit 0
