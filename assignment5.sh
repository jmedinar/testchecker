#!/usr/bin/env bash
# Script: assignment5.sh
# Author: Professor Juan Medina
# Email: jmedina@collin.edu
# Date: 03/23/2024

# --- Configuration ---
assignment=5
total_points_earned=0 # Accumulator for points earned
max_possible_points=0 # Maximum possible points for percentage calculation

# Base directory for student scripts
script_base_dir="/sysadm/bin"

# List of target script basenames (without .sh extension)
targets=(
    challenge1 challenge2 challenge3 challenge4 challenge5 challenge6 challenge7 challenge8 challenge9
    homeChecker rabbitJumps testString processFile userValidator
)

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

# Function to evaluate a student script's output
# Arguments: $1=script_basename, $2=arguments_to_pass, $3=expected_output_substring
_check_script_output(){
    local script_basename="$1"
    local script_args="$2"
    local expected_output="$3"

    local script_path="${script_base_dir}/${script_basename}.sh"
    local points_value=0
    local points_awarded=0
    local result_status="FAIL"
    local details=""

    # Determine points value for this script
    case "${script_basename}" in
        challenge*)      points_value=10 ;;
        processFile|testString) points_value=30 ;;
        *)               points_value=20 ;; # homeChecker, rabbitJumps, userValidator
    esac
    # Add points value to max possible *before* checking existence
    ((max_possible_points += points_value))

    # Check 1: Script Existence and Executability
    if [[ ! -f "${script_path}" ]]; then
        details+=" Script not found."
    elif [[ ! -x "${script_path}" ]]; then
        details+=" Script not executable."
    else
        # Check 2: Script Output
        local script_output=""
        local exit_code=0
        # Run the script, capture output and exit code. Redirect stderr to /dev/null.
        script_output=$("${script_path}" ${script_args} 2>/dev/null) || exit_code=$?

        if [[ ${exit_code} -ne 0 ]]; then
            details+=" Script exited with error (code ${exit_code})."
        # Check if the output contains the expected substring
        # Using grep -F for fixed string matching is safer if no regex is needed
        elif echo "${script_output}" | grep -qF "${expected_output}"; then
            result_status="PASS"
            points_awarded=${points_value}
            ((total_points_earned += points_awarded))
        else
            details+=" Output mismatch (Expected: '${expected_output}')."
        fi
    fi

    # Print result row
    printf "${CY}%-30s %-10s %-10s ${CR}%s${CW}\n" \
        "${script_basename}.sh" "${result_status}" "${points_awarded}/${points_value}" "${details}"
}

# --- Verification Logic ---

_print_line
echo -e "${CP}Assignment ${assignment} Verification Started${CW}"
_print_line

# Get the username from the environment variable set by sudo
# Assumes the parent script (testChecker.sh) already validated SUDO_USER
realuser="${SUDO_USER}"

# --- Execute and Check Student Scripts ---
printf "${CG}%-30s %-10s %-10s %s${CW}\n" "SCRIPT" "RESULT" "POINTS" "DETAILS"
_print_line

for t in "${targets[@]}"
do
    case ${t} in
        challenge1)  _check_script_output "${t}" "" \
                                "Hello, world!" ;;

        challenge2)  _check_script_output "${t}" "" \
                                "Linux" ;;

        challenge3)  _check_script_output "${t}" "" \
                                "Hello Alice, Welcome to Wonderland!" ;;

        challenge4)  _check_script_output "${t}" "" \
                                "File /etc/passwd found" ;;

        challenge5)  _check_script_output "${t}" "Learning Linux challenging it also fun very rewarding" \
                                "Learning Linux is challenging but it is also fun and very rewarding" ;;

        challenge6)  _check_script_output "${t}" "" \
                                "Multiplication: 50" ;;

        challenge7)  _check_script_output "${t}" "" \
                                "We are in the era of AI and agriculture is still more important in the year 2024!" ;;

        challenge8)  _check_script_output "${t}" "" \
                                "/etc/passwd exists!" ;;

        challenge9)  _check_script_output "${t}" "" \
                                ". Like in the Beatles song, Hello, Goodbye!" ;;

        homeChecker) _check_script_output "${t}" "" \
                                "/home/goneuser" ;;

        processFile) _check_script_output "${t}" "/etc/passwd" \
                                "Method" ;; # Check for the word "Method"

        rabbitJumps) _check_script_output "${t}" "" \
                                "The Rabbit made it!" ;;

        testString)  _check_script_output "${t}" "1" \
                                "Binary or positive integer" ;;

        userValidator) _check_script_output "${t}" "" \
                                "sync password is NOT SET" ;;

        *) echo -e "${CR}Unknown target script configured in checker: ${t}${CW}" ;;
    esac
done
_print_line

# --- Grade Calculation & Reporting ---

echo "" # Add a blank line for spacing
_print_line

local grade_percentage=0
if [[ ${max_possible_points} -gt 0 ]]; then
    # Calculate grade percentage using bc for floating point
    grade_percentage=$(echo "scale=2; (100 / ${max_possible_points}) * ${total_points_earned}" | bc -l)
    printf "${CP}Assignment ${assignment} Result: ${CG}%d%%${CW} (%d/%d points earned)\n" \
           "$(printf '%.0f' ${grade_percentage})" \
           "${total_points_earned}" \
           "${max_possible_points}"
else
    echo -e "${CR}No questions were checked or max points is zero. Grade cannot be calculated.${CW}"
    grade_percentage=0 # Assign 0 if no questions were run
fi

_print_line
source <(curl -s --fail -L -H 'Cache-Control: no-cache' "${ENCODER_SCRIPT_URL}") "${grade}" "${assignment}"
