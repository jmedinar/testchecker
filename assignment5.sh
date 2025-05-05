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
    # $4=code_pattern (currently unused/commented out)
    # local expected_code_pattern="$4"

    local script_path="${script_base_dir}/${script_basename}.sh"
    local points_value=0
    local points_awarded=0
    local result_status="${CR}FAIL${CW}" # Default to FAIL
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
            # Check 3: Source Code Pattern (Optional - currently disabled)
            # local code_check_passed=true # Assume true if check is disabled
            # if [[ -n "${expected_code_pattern}" ]]; then
            #     if ! grep -q "${expected_code_pattern}" "${script_path}"; then
            #         code_check_passed=false
            #         details+=" Required code pattern not found."
            #     fi
            # fi
            # if [[ "$code_check_passed" == true ]]; then
                 result_status="${CG}PASS${CW}"
                 points_awarded=${points_value}
                 ((total_points_earned += points_awarded))
            # fi
        else
            details+=" Output mismatch (Expected: '${expected_output}')."
        fi
    fi

    # Print result row
    printf "${CY}%-30s %-10s %-10s ${CR}%s${CW}\n" \
        "${script_basename}.sh" "${result_status}" "${points_awarded}/${points_value}" "${details}"
}

# _eval(){
#     target=$1     arg=$2     ret=$3     code=$4     r=false     points=0      value=10
#     # Evaluating output
#     if ${bdir}/${target}.sh ${arg} 2>/dev/null | grep -q "${ret}"
#     then
#         # Evaluating source code
#         #if grep -q "${code}" ${bdir}/${target}
#         #then
#             r=true
#             # grading
#             case ${target} in
#                             challenge*) (( points = value * 1 )); ((grade+=points)) ;;
#                 processFile|testString) (( points = value * 3 )); ((grade+=points)) ;;
#                                      *) (( points = value * 2 )); ((grade+=points)) ;;
#             esac
#         #fi
#     fi
#     printf "${CG}%-30s${CY}%-20s%-20s${CW}\n" ${bdir}/${target}.sh ${r} ${points}
# }

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

# printf "${CG}%-30s%-20s%-20s${CW}\n" SCRIPT RESULT POINTS
# _print_line
# for t in "${targets[@]}"
# do
#     case ${t} in
#         challenge1)  _eval      "${t}" "" \
#                                 "Hello, world!" ;;

#         challenge2)  _eval      "${t}" "" \
#                                 "Linux" ;;

#         challenge3)  _eval      "${t}" "" \
#                                 "Hello Alice, Welcome to Wonderland!" ;;

#         challenge4)  _eval      "${t}" "" \
#                                 "File /etc/passwd found" ;;

#         challenge5)  _eval      "${t}" "Learning Linux challenging it also fun very rewarding" \
#                                 "Learning Linux is challenging but it is also fun and very rewarding" ;;

#         challenge6)  _eval      "${t}" "" \
#                                 "Multiplication: 50" ;;

#         challenge7)  _eval      "${t}" "" \
#                                 "We are in the era of AI and agriculture is still more important in the year 2024!" ;;

#         challenge8)  _eval      "${t}" "" \
#                                 "/etc/passwd exists!" ;;

#         challenge9)  _eval      "${t}" "" \
#                                 ". Like in the Beatles song, Hello, Goodbye!" ;;

#         homeChecker) _eval      "${t}" "" \
#                                 "/home/goneuser" ;;

#         processFile) _eval      "${t}" "/etc/passwd" \
#                                 "Method" ;;

#         rabbitJumps) _eval      "${t}" "" \
#                                 "The Rabbit made it!" ;;

#         testString)  _eval      "${t}" "1" \
#                                 "Binary or positive integer" ;;

#         userValidator) _eval    "${t}" "" \
#                                 "sync password is NOT SET" ;;

#         *) echo "Unknown" ;;
#     esac
# done
# _print_line


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
