#!/usr/bin/env bash
# Script: encoder.sh
# Author: Professor Juan Medina
# Email: jmedina@collin.edu
# Date: Aug 2024
# Purpose: Collects system/user info, formats it with grade/assignment data,
#          and outputs a Base64 encoded string.

# --- Configuration ---

# Color Codes
CR='\e[0;31m' # Red
CG='\e[0;32m' # Green
CY='\e[0;33m' # Yellow
CL='\e[0;34m' # Blue
CP='\e[0;35m' # Purple
CC='\e[0;36m' # Cyan
CW='\e[0;37m' # White (reset)

# --- Argument Handling & Validation ---

# This script expects 2 arguments:
# $1: Grade (numeric value)
# $2: Assignment ID (e.g., 1, 2, midterm, final)

grade="${1}"
assignment_id="${2}"

# --- Data Collection ---

# Get system UUID (requires root privileges, assumed from parent script)
system_uuid=$(dmidecode -s system-uuid)
if [[ -z "${system_uuid}" || "${system_uuid}" == "Undefined" || "${system_uuid}" == "Not Present" ]]; then
     system_uuid="UNKNOWN_UUID" # Example fallback
fi

# Get Fully Qualified Domain Name
fqdn_hostname=$(hostname -f)
if [[ -z "${fqdn_hostname}" ]]; then
    fqdn_hostname=$(hostname) # Fallback to short hostname
    if [[ -z "${fqdn_hostname}" ]]; then
        fqdn_hostname="UNKNOWN_HOSTNAME" # Final fallback
    fi
fi

# Get current date/time in a standard format (ISO 8601 recommended)
current_datetime=$(date --iso-8601=seconds)

# --- Format Assignment Identifier ---

# Add "assignment" prefix unless it's a special type like midterm/final
formatted_assignment_id="${assignment_id}"
if [[ "${assignment_id}" != "midterm" ]] && [[ "${assignment_id}" != "final" ]]; then
    # Check if it's purely numeric before adding prefix
    if [[ "${assignment_id}" =~ ^[0-9]+$ ]]; then
        formatted_assignment_id="assignment${assignment_id}"
    fi
    # If it's neither numeric nor midterm/final, keep original value
fi

# --- Construct and Encode Data ---

realuser=$(bash -c 'echo $SUDO_USER')
# Create comma-separated string
# Format: UUID,Username,Grade,AssignmentIdentifier,Hostname,Timestamp
data_string="${system_uuid},${realuser},${grade},${formatted_assignment_id},${fqdn_hostname},${current_datetime}"

# Base64 encode the string with no line wrapping (-w 0)
encoded_string=$(echo -n "${data_string}" | base64 -w 0) # Use echo -n to avoid trailing newline

# --- Output ---

# Print *only* the Base64 encoded string to standard output
# The calling script can decide how to present it.
echo "${encoded_string}"

exit 0
