#!/usr/bin/env bash
# Script: assignment4.sh (sourced by testChecker.sh)
# Author: Professor Juan Medina
# Email: jmedina@collin.edu
# Date: 03/23/2024 (Updated: 2025-05-06)
# Purpose: Verifies user account configurations (groups, GECOS) for Assignment 4.

# Note: set -e and set -o pipefail are expected to be inherited from the parent script (testChecker.sh)

# --- Configuration ---
assignment=5
correct_answers=0 # Counter for correct answers
total_questions=0 # Counter for total questions checked (dynamically calculated)

# Color Codes (should be inherited, but defined here for clarity/standalone testing)
CR='\e[0;31m' # Red
CG='\e[0;32m' # Green
CY='\e[0;33m' # Yellow
CL='\e[0;34m' # Blue
CP='\e[0;35m' # Purple
CC='\e[0;36m' # Cyan
CW='\e[0;37m' # White (reset)

# URL for the final encoding/reporting script (decoded)
ENCODER_SCRIPT_URL="https://raw.githubusercontent.com/jmedinar/testchecker/main/encoder.sh"

# --- Helper Functions ---

# Function to print a separator line
_print_line() {
    printf "${CC}%0.s=" {1..80} # Print 80 '=' characters
    printf "${CW}\n" # Reset color and add newline
}

# Function to check user existence, primary group, auxiliary groups, and GECOS comment
# Arguments: $1=username, $2=expected_primary_group
_check_user_config() {
    local username="$1"
    local expected_primary_group="$2"
    local expected_gecos_email="${username}@wedbit.com" # Expected email in GECOS

    # Use plain text for status variables used in printf width calculation
    local exists_status="-" primary_status="-" aux_status="-" gecos_status="-"
    local details="" # Failure details

    # --- Check User Existence ---
    ((total_questions++))
    if getent passwd "${username}" > /dev/null; then
        exists_status="PASS"
        ((correct_answers++))

        # --- Check Primary Group (only if user exists) ---
        ((total_questions++))
        local actual_primary_group
        actual_primary_group=$(id -gn "${username}" 2>/dev/null || echo "Error")
        if [[ "${actual_primary_group}" == "${expected_primary_group}" ]]; then
            primary_status="PASS"
            ((correct_answers++))
        else
            primary_status="FAIL"
            details+=" PrimGrp:${actual_primary_group}(Exp:${expected_primary_group})"
        fi

        # --- Check GECOS Field (only if user exists) ---
        ((total_questions++))
        local gecos_field
        # Extract the 5th field (GECOS) from getent passwd output
        gecos_field=$(getent passwd "${username}" | cut -d: -f5)
        # Check if the expected email is a substring of the GECOS field
        if [[ "${gecos_field}" == *"${expected_gecos_email}"* ]]; then
            gecos_status="PASS"
            ((correct_answers++))
        else
            gecos_status="FAIL"
            details+=" GECOS mismatch (Exp:${expected_gecos_email})"
        fi

        # --- Check Auxiliary Groups (only if user exists) ---
        ((total_questions++))
        local aux_groups_ok=false # Flag to track if aux group logic passes
        local user_groups=() # Initialize as array
        local groups_string # Temporary string for mapfile
        groups_string=$(id -nG "${username}" 2>/dev/null || echo "")
        # Use mapfile (readarray) to handle potential spaces in group names if any existed
        mapfile -t user_groups < <(echo "${groups_string}" | tr ' ' '\n')

        case "${expected_primary_group}" in
            "accounting" | "technology")
                # Rule: For these primary groups, user should ONLY be in the primary group.
                # Check if the number of groups is exactly 1 AND that group is the expected primary.
                if [[ ${#user_groups[@]} -eq 1 && "${user_groups[0]}" == "${expected_primary_group}" ]]; then
                    aux_groups_ok=true
                else
                    # Provide more detail on failure
                    details+=" AuxGrp: Should only be in primary group '${expected_primary_group}'. Found: ${groups_string:-<none>}"
                fi
                ;;
            "humanresources")
                # Rule: Requires primary group 'humanresources' AND auxiliary group 'accounting'.
                local found_accounting=false
                for group in "${user_groups[@]}"; do
                    # Skip checking the primary group itself if needed, though not strictly necessary here
                    # if [[ "$group" == "$expected_primary_group" ]]; then continue; fi
                    if [[ "${group}" == "accounting" ]]; then
                        found_accounting=true
                        break # Found it, no need to check further
                    fi
                done
                if [[ "$found_accounting" == true ]]; then
                    aux_groups_ok=true
                else
                    details+=" AuxGrp: Missing required group 'accounting'. Found: ${groups_string:-<none>}"
                fi
                ;;
            "directionboard")
                # Rule: Requires primary 'directionboard' AND auxiliaries 'technology', 'humanresources', 'accounting'.
                local found_tech=false found_hr=false found_acc=false
                for group in "${user_groups[@]}"; do
                     # Skip checking the primary group itself if needed
                    # if [[ "$group" == "$expected_primary_group" ]]; then continue; fi
                    case "${group}" in
                        "technology") found_tech=true ;;
                        "humanresources") found_hr=true ;;
                        "accounting") found_acc=true ;;
                    esac
                done
                if [[ "$found_tech" == true && "$found_hr" == true && "$found_acc" == true ]]; then
                    aux_groups_ok=true
                else
                    details+=" AuxGrp: Missing required groups (Tech/HR/Acc). Found: ${groups_string:-<none>}"
                fi
                ;;
            *)
                # Should not happen with current calls, but good practice
                details+=" AuxGrp: Unknown primary group rule for '${expected_primary_group}'."
                ;;
        esac

        # Set final status based on the logic above
        if [[ "$aux_groups_ok" == true ]]; then
            aux_status="PASS"
            ((correct_answers++))
        else
            aux_status="FAIL"
            # Details string should already be populated by the case statement on failure
        fi

    else
        # User does not exist - fail all checks
        exists_status="FAIL"
        primary_status="FAIL"
        aux_status="FAIL"
        gecos_status="FAIL"
        # Increment total_questions for the checks that couldn't run
        ((total_questions+=3))
        details+=" User does not exist."
    fi

    # Print results row - Use plain status variables for alignment
    # Color the line yellow, color details red
    printf "${CY}%-10s %-8s %-15s %-18s %-10s ${CR}%s${CW}\n" \
        "${username}" "${exists_status}" "${primary_status}" "${aux_status}" "${gecos_status}" "${details}"
}

# --- Verification Logic ---

_print_line
echo -e "${CP}Assignment ${assignment} Verification Started${CW}"
_print_line
echo "" # Add a blank line for spacing

# Get the username from the environment variable set by sudo
# Assumes the parent script (testChecker.sh) already validated SUDO_USER
realuser="${SUDO_USER}"

# Check for required commands
required_commands=("getent" "id" "cut" "grep" "bc")
for cmd in "${required_commands[@]}"; do
    if ! command -v "$cmd" &> /dev/null; then
        echo -e "${CR}Error: Required command '$cmd' not found. Please install it.${CW}" >&2
        exit 1
    fi
done

# --- User Configuration Verification ---
# Print Header Row (Plain text for alignment)
printf "${CG}%-10s %-8s %-15s %-18s %-10s %s${CW}\n" "USER" "EXISTS" "PRIMARY_GROUP" "AUXILIARY_GROUPS" "GECOS" "DETAILS"
_print_line
_check_user_config "cyen"     "accounting"
_check_user_config "mpearl"   "accounting"
_check_user_config "jgreen"   "directionboard"
_check_user_config "dpaul"    "technology"
_check_user_config "msmith"   "technology"
_check_user_config "poto"     "technology"
_check_user_config "mkhan"    "technology"
_check_user_config "llopez"   "directionboard"
_check_user_config "jramirez" "humanresources"
_print_line

# --- Grade Calculation & Reporting ---

echo "" # Add a blank line for spacing
_print_line
if [[ ${total_questions} -gt 0 ]]; then
    # Calculate grade using bc for floating point
    # Ensure correct_answers doesn't exceed total_questions (precaution)
    if [[ ${correct_answers} -gt ${total_questions} ]]; then correct_answers=${total_questions}; fi
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

# Source the encoder/reporter script, passing the calculated grade, assignment number, and username
echo -e "${CY}Reporting results...${CW}"
# Use curl: -s silent, --fail error on HTTP failure, -L follow redirects
# If curl fails, set -e inherited from parent script should cause an exit
source <(curl -s --fail -L -H 'Cache-Control: no-cache' "${ENCODER_SCRIPT_URL}") "$(printf '%.0f' ${grade})" "${assignment}" "${realuser}"

# The script finish is handled by the parent script (testChecker.sh)
