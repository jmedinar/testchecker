#!/usr/bin/env bash
# Script: assignment4.sh
# Author: Professor Juan Medina
# Email: jmedina@collin.edu
# Date: 03/23/2024

# --- Configuration ---
assignment=4
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

function _print_line() {
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
        local user_groups # Array to hold all groups for the user
        # Get all groups the user belongs to (including primary)
        mapfile -t user_groups < <(id -nG "${username}" 2>/dev/null)

        case "${expected_primary_group}" in
            "accounting" | "technology")
                # For these primary groups, user should ONLY be in the primary group.
                # Check if the number of groups is exactly 1.
                if [[ ${#user_groups[@]} -eq 1 ]]; then
                    aux_groups_ok=true
                else
                    details+=" AuxGrp: Should only be in primary group."
                fi
                ;;
            "humanresources")
                # Requires primary group 'humanresources' AND auxiliary group 'accounting'.
                local found_accounting=false
                for group in "${user_groups[@]}"; do
                    if [[ "${group}" == "accounting" ]]; then
                        found_accounting=true
                        break # Found it, no need to check further
                    fi
                done
                if [[ "$found_accounting" == true ]]; then
                    aux_groups_ok=true
                else
                    details+=" AuxGrp: Missing 'accounting'."
                fi
                ;;
            "directionboard")
                # Requires primary 'directionboard' AND auxiliaries 'technology', 'humanresources', 'accounting'.
                local found_tech=false found_hr=false found_acc=false
                for group in "${user_groups[@]}"; do
                    case "${group}" in
                        "technology") found_tech=true ;;
                        "humanresources") found_hr=true ;;
                        "accounting") found_acc=true ;;
                    esac
                done
                if [[ "$found_tech" == true && "$found_hr" == true && "$found_acc" == true ]]; then
                    aux_groups_ok=true
                else
                    details+=" AuxGrp: Missing required groups (Tech/HR/Acc)."
                fi
                ;;
            *)
                # Should not happen with current calls, but good practice
                details+=" AuxGrp: Unknown primary group rule."
                ;;
        esac

        # Set final status based on the logic above
        if [[ "$aux_groups_ok" == true ]]; then
            aux_status="PASS"
            ((correct_answers++))
        else
            aux_status="FAIL"
            # Details string already populated by the case statement
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

# Get the username from the environment variable set by sudo
# Assumes the parent script (testChecker.sh) already validated SUDO_USER
realuser="${SUDO_USER}"

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
