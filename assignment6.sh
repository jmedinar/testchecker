#!/usr/bin/env bash
# Script: assignment6.sh
# Author: Professor Juan Medina
# Email: jmedina@collin.edu
# Date: 03/23/2024
# Purpose: Verifies student's analysis of the running stress-ng process for Assignment 6.

# --- Configuration ---
assignment=6
correct_answers=0 # Counter for correct answers
total_questions=0 # Counter for total questions checked

ENCODER_SCRIPT_URL="https://raw.githubusercontent.com/jmedinar/testchecker/main/encoder.sh"

# Color Codes
CR='\e[0;31m' # Red
CG='\e[0;32m' # Green
CY='\e[0;33m' # Yellow
CL='\e[0;34m' # Blue
CP='\e[0;35m' # Purple
CC='\e[0;36m' # Cyan
CW='\e[0;37m' # White (reset)

quotes=(
    "Bugs Bunny - What's up, doc?"
    "Homer Simpson - D'oh!"
    "Bart Simpson - Eat my shorts!"
    "Mickey Mouse - Oh boy!"
    "Daffy Duck - You're despicable!"
    "Yogi Bear - Smarter than the average bear."
    "Winnie the Pooh - Oh bother."
    "Dora the Explorer - Come on, vamonos!"
    "Optimus Prime - Autobots, roll out!"
    "Pink Panther - It's not easy being pink."
    "Bender - Bite my shiny metal ass!"
    "Porky Pig - Th-th-th-that's all, folks!"
    "Scooby-Doo - Scooby-Dooby-Doo, where are you?"
    "He-Man - I have the power!"
)

# --- Helper Functions ---

function _print_line() {
    printf "${CC}%0.s=" {1..80} # Print 80 '=' characters
    printf "${CW}\n" # Reset color and add newline
}

# --- Verification Logic ---

_print_line
echo -e "${CP}Assignment ${assignment} Verification Started${CW}"
_print_line

# Get the username from the environment variable set by sudo
# Assumes the parent script (testChecker.sh) already validated SUDO_USER
realuser="${SUDO_USER}"

# Find the PID of the exact process name "stress-ng"
stress_pid=$(pgrep -x "stress-ng")

if [[ -z "${stress_pid}" ]]; then
    echo -e "${CR}Error: The 'stress-ng' process does not appear to be running.${CW}" >&2
    echo -e "${CR}Please ensure you have run the 'mod6-init' script successfully.${CW}" >&2
    exit 1
fi

# Get PPID and Command Name using the found PID
process_name=$(ps -o comm= -p "${stress_pid}")

# --- Get info from journalctl ---
journal_entry=""
resource_type=""
funny_quote=""

# Retrieve the latest log entry with the specific tag
# Use -o cat for plain message, --no-pager to avoid interactivity
journal_entry=$(journalctl --since="3 hours ago" --priority=err -n 1 --no-pager -o cat)

if [[ -n "${journal_entry}" ]]; then
    # Extract resource type (CPU, MEMORY, IO) - assumes format like 
    # "...impacting your X - ..."
    # Use parameter expansion and case-insensitivity
    if [[ "${journal_entry,,}" == *"impacting your CPU"* ]]; then
        resource_type="CPU"
    elif [[ "${journal_entry,,}" == *"impacting your MEMORY"* ]]; then
        resource_type="MEMORY"
    elif [[ "${journal_entry,,}" == *"impacting your IO"* ]]; then
        resource_type="IO"
    fi
    # Extract the quote part (everything after the last comma)
    funny_quote=$(echo "${journal_entry}" | sed 's/.* , //')
else
    echo -e "${CR}Warning: Could not find the expected log entry from ${LOG_TAG} in journalctl.${CW}" >&2
    # Allow script to continue, but some checks might fail
fi

# --- Get open file info ---
# Check if lsof output for the PID contains the executable path
lsof_output=$(lsof -p "${stress_pid}" 2>/dev/null || echo "") # Capture output, handle potential errors
expected_file_path="/usr/bin/stress-ng"
lsof_contains_executable=false
if echo "${lsof_output}" | grep -qF "${expected_file_path}"; then
    lsof_contains_executable=true
fi

# --- Ask Student Questions ---

echo -e "${CY}Answer the following questions based on the running stress process:${CW}"
echo ""

# Question 1: PPID
((total_questions++))
read -p "   1. Identify the Parent Process ID (PPID) of the stress process: " ans1
q1_correct=false
if [[ "${ans1}" == "${stress_pid}" ]]; then
    q1_correct=true
    ((correct_answers++))
fi

# Question 2: Process Name
((total_questions++))
read -p "   2. Identify the command name of the stress process: " ans2
q2_correct=false
if [[ "${ans2}" == "${process_name}" ]]; then
    q2_correct=true
    ((correct_answers++))
fi

# Question 3: Resource Impacted
((total_questions++))
read -p "   3. Determine which resource (CPU, MEMORY, or IO) is being impacted (check journal): " ans3
q3_correct=false
# Case-insensitive comparison
if [[ "${ans3^^}" == "${resource_type}" ]]; then
    q3_correct=true
    ((correct_answers++))
else
    # Provide hint if journal entry was missing
    if [[ -z "${journal_entry}" ]]; then echo -e "      ${CR}(Hint: Could not find journal entry)${CW}"; fi
fi

# Question 4: Open File Check
((total_questions++))
read -p "   4. Enter the full path to the main executable file used by the stress process: " ans4
q4_correct=false
# Check if the answer matches the expected path
if [[ "${ans4}" == "${expected_file_path}" ]]; then
    q4_correct=true
    ((correct_answers++))
# else # Optional: Provide feedback if the lsof check passed but answer was wrong
#    if [[ "$lsof_contains_executable" = true ]]; then
#       echo -e "      ${CR}(Hint: Check the path carefully)${CW}"
#    fi
fi

# Question 5: Logged Message (Quote)
((total_questions++))
echo ""
echo -e "${CY}   5. Identify the funny message logged by the process (check journal):${CW}"
pos=0
# Display the list of possible quotes
for q in "${quotes[@]}"; do
    printf "      [%2d] %s\n" ${pos} "${q}" # Format index nicely
    ((pos+=1))
done
q5_correct=false
ans5=""
# Loop until valid numeric input is given
while [[ ! "$ans5" =~ ^[0-9]+$ ]] || [[ "$ans5" -ge ${#quotes[@]} ]]; do
    read -p "       Choose the number corresponding to the quote found in the journal: " ans5
    if [[ ! "$ans5" =~ ^[0-9]+$ ]]; then
        echo -e "      ${CR}Invalid input. Please enter a number.${CW}"
    elif [[ "$ans5" -ge ${#quotes[@]} ]]; then
        echo -e "      ${CR}Invalid number. Choose from the list (0-$((${#quotes[@]}-1))).${CW}"
    fi
done
# Check if the selected quote matches the one extracted from the journal
if [[ -n "${funny_quote}" && "${quotes[${ans5}]}" == "${funny_quote}" ]]; then
    q5_correct=true
    ((correct_answers++))
else
     # Provide hint if journal entry was missing or quote didn't match
    if [[ -z "${journal_entry}" ]]; then echo -e "      ${CR}(Hint: Could not find journal entry)${CW}"; fi
    if [[ -n "${journal_entry}" && "${quotes[${ans5}]}" != "${funny_quote}" ]]; then echo -e "      ${CR}(Hint: Quote does not match journal entry)${CW}"; fi
fi


# --- Display Results Summary ---
_print_line
printf "${CG}%-10s %-10s %-10s %-10s %-10s${CW}\n" "Q1(PPID)" "Q2(Name)" "Q3(Rsrc)" "Q4(File)" "Q5(Quote)"
printf "${CY}%-10s %-10s %-10s %-10s %-10s${CW}\n" \
    "$( [[ "$q1_correct" = true ]] && echo PASS || echo FAIL )" \
    "$( [[ "$q2_correct" = true ]] && echo PASS || echo FAIL )" \
    "$( [[ "$q3_correct" = true ]] && echo PASS || echo FAIL )" \
    "$( [[ "$q4_correct" = true ]] && echo PASS || echo FAIL )" \
    "$( [[ "$q5_correct" = true ]] && echo PASS || echo FAIL )"
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
