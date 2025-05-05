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

# Define points for each script type
declare -A script_points=(
    ["challenge"]=10
    ["processFile"]=30
    ["testString"]=30
    ["homeChecker"]=20
    ["rabbitJumps"]=20
    ["userValidator"]=20
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

     # Determine points value for this script based on type
    local script_type="challenge" # Default type
    if [[ "${script_basename}" == "processFile" || "${script_basename}" == "testString" ]]; then
        script_type="processFile" # Treat testString same as processFile for points
    elif [[ "${script_basename}" == "homeChecker" || "${script_basename}" == "rabbitJumps" || "${script_basename}" == "userValidator" ]]; then
        script_type="homeChecker" # Group other 20-point scripts
    fi
    points_value=${script_points[$script_type]:-10} # Default to 10 if type not found

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
        # Use timeout to prevent hung scripts (e.g., 5 seconds)
        script_output=$(timeout 5 "${script_path}" ${script_args} 2>/dev/null) || exit_code=$?

        # Check timeout exit code (124)
        if [[ ${exit_code} -eq 124 ]]; then
             details+=" Script timed out (>${CG}5s${CR})."
        elif [[ ${exit_code} -ne 0 ]]; then
            details+=" Script exited with error (code ${exit_code})."
        # Check if the output contains the expected substring
        # Using grep -F for fixed string matching is safer if no regex is needed
        elif echo "${script_output}" | grep -qF "${expected_output}"; then
            # Check 3: Source Code Pattern (Optional - currently disabled)
            # local code_check_passed=true # Assume true if check is disabled
            # if [[ -n "${expected_code_pattern}" ]]; then
            #     if ! grep -q "${expected_code_pattern}" "${script_path}"; then
            #         code_check_passed=false
            #         details+=" Required code pattern not found."
            #     fi
            # fi
            # if [[ "$code_check_passed" == true ]]; then
                 result_status="PASS"
                 points_awarded=${points_value}
                 ((total_points_earned += points_awarded))
            # fi
        else
            # Check if output was empty when expected output was not
            if [[ -z "${script_output}" && -n "${expected_output}" ]]; then
                details+=" No output produced."
            else
                details+=" Output mismatch (Expected: '${expected_output}')."
            fi
        fi
    fi

    # Print result row
    printf "${CY}%-20s %-10s %-10s ${CR}%s${CW}\n" \
        "${script_basename}.sh" "${result_status}" "${points_awarded}" "${details}"
}

# --- Verification Logic ---

_print_line
echo -e "${CP}Assignment ${assignment} Verification Started${CW}"
_print_line

# Get the username from the environment variable set by sudo
# Assumes the parent script (testChecker.sh) already validated SUDO_USER
realuser="${SUDO_USER}"

# --- Execute and Check Student Scripts ---
printf "${CG}%-20s %-10s %-10s %s${CW}\n" "SCRIPT" "RESULT" "POINTS" "DETAILS"
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

# Calculate the final grade percentage, capped at 100%
final_grade_percentage=0
target_points_for_100=100 # Define the target score for 100%

if [[ ${max_possible_points} -eq 0 ]]; then
    # Avoid division by zero if no scripts were configured or points assigned
    echo -e "${CR}No points were assigned for checks. Grade cannot be calculated.${CW}"
    final_grade_percentage=0
elif [[ ${total_points_earned} -ge ${target_points_for_100} ]]; then
    # If earned points meet or exceed the target, grade is 100%
    final_grade_percentage=100
    echo -e "${CG}Target score of ${target_points_for_100} points reached or exceeded!${CW}"
else
    # Calculate percentage based on the target score needed for 100%
    # This effectively scales the grade based on progress towards 100 points.
    final_grade_percentage=$(echo "scale=2; (100 / ${target_points_for_100}) * ${total_points_earned}" | bc -l)
    # Round to nearest integer for final reporting
    final_grade_percentage=$(printf '%.0f' "${final_grade_percentage}")
fi

# Print the final result
printf "${CP}Assignment ${assignment} Result: ${CG}%d%%${CW} (%d points earned towards target of %d)\n" \
       "${final_grade_percentage}" \
       "${total_points_earned}" \
       "${target_points_for_100}"

_print_line
source <(curl -s --fail -L -H 'Cache-Control: no-cache' "${ENCODER_SCRIPT_URL}") "${grade}" "${assignment}"
