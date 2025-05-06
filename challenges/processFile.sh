#!/usr/bin/environment bash/korn
# -----------------------------------------------------------------------------
# Challenge Name:   processFile.sh
# Student Task:     Fix errors related to shebang, file testing, and file processing loops.
# Description:      This script demonstrates different methods (some flawed) for reading
#                   a file line-by-line in Bash. It takes a filename as a command-line
#                   argument and processes it using three distinct functions. It contains
#                   errors in its setup, argument handling, and one of the processing methods.
# Script Purpose:   To compare three different techniques for reading file content within a script.
#                   Method 1 uses `cat` piped to `while read`.
#                   Method 2 uses `while read` with input redirection.
#                   Method 3 uses a `for` loop with command substitution (incorrectly).
#                   The script times each method and writes the processed lines to a temporary file.
# -----------------------------------------------------------------------------
# Problem:          The script fails to execute correctly or produces unexpected results
#                   due to several issues:
#                   1. Incorrect Shebang: The `#!/usr/bin/environment bash/korn` line is invalid.
#                      It attempts to use `environment` as a command and provides an incorrect
#                      path for an interpreter.
#                   2. Incorrect File Existence Check: The script checks `[[ ! -f 1 ]]` instead
#                      of checking the actual input filename provided by the user (`$1` or `${InFile}`).
#                   3. Flawed Loop Logic (Method 3): The `for LINE in $(cat ${InFile})` loop does
#                      *not* read the file line by line. Command substitution `$(...)` undergoes
#                      word splitting based on spaces, tabs, and newlines. Each *word* from the
#                      file will be assigned to `LINE` in separate loop iterations, not each line.
#                   4. Misleading Expected Output Comment: The original comment "Expected Output: Hello, world!"
#                      does not match what this script actually does (it prints method descriptions
#                      and timing information). The *real* expected behavior involves successfully
#                      running the methods and observing their timing/output differences (though
#                      Method 3's output will be incorrect due to word splitting).
#
# Your Task:        Identify and correct the errors:
#                   1. Fix the shebang line (`#!/bin...`) to use the correct Bash interpreter.
#                   2. Correct the file existence check (`if [[ ! -f ... ]]`) to test the
#                      filename passed as an argument (`$1` or `${InFile}`).
#                   3. (Optional but Recommended for Understanding): Observe why Method 3 produces
#                      incorrect output in `tempfile.out` compared to Methods 1 and 2 when processing
#                      a file with multiple words per line. Understand that fixing Method 3 to read
#                      line-by-line would require a different approach (like `while read` or `mapfile`).
#                      *For this challenge, simply fixing the shebang and file test might be sufficient
#                      to make the script runnable, even if Method 3 remains logically flawed for line processing.*
#
# Expected Behavior (After Fixes):
#                   - The script should run without syntax errors when given a valid filename as input.
#                   - It should correctly check if the input file exists.
#                   - It should execute Methods 1, 2, and 3, printing their descriptions and timing.
#
# Hints:
#                   * What is the standard shebang for Bash scripts? (`#!/bin...`)
#                   * How do you refer to the first command-line argument in a script? (`$1` or `${1}`)
#                   * How does command substitution `$(...)` handle whitespace (spaces, newlines) in its output?
#                     Does `for var in $(command)` iterate over lines or words?
#                   * Review the `while read` loop structure with input redirection (`< file`).
# -----------------------------------------------------------------------------

# --- Script Code ---

InFile="${1}"
OutFile="tempfile.out"

# Color Variables
CR='\e[0;31m' # Red
CG='\e[0;32m' # Green
CY='\e[0;33m' # Yellow
CW='\e[0;37m' # White

function method1(){
    echo -e "${CG}Method 1: Using cat piped to 'while read'${CY}"
    cat "${InFile}" | while IFS= read -r LINE || [[ -n "$LINE" ]]; do 
        echo "${LINE}" >> "${OutFile}"
    done
}

function method2(){
    echo -e "${CG}Method 2: Using 'while read' with input redirection${CY}"
    while IFS= read -r LINE || [[ -n "$LINE" ]]; do
        echo "${LINE}" >> "${OutFile}"
    done < "${InFile}"
}

function method3(){
    echo -e "${CG}Method 3: Using 'for' loop over '$(cat file)' (Processes words, not lines)${CY}"
    for LINE in $(cat "${InFile}")
    do
        echo "${LINE}" >> "${OutFile}"
    done
}

# --- Main Script ---

# Check for exactly one parameter
if (( $# != 1 )); then
    echo -e "${CR}Error: A target filename is required as the first argument.${CW}" >&2
    exit 1
fi

# Check if the argument exists as a regular file
if [[ ! -f 1 ]]; then
    echo -e "${CR}Error: Input file '$1' not found or is not a regular file.${CW}" >&2
    exit 2
fi

# Array of method function names
methods=(method1 method2 method3)

# Loop through each method, time it, and run it
for method in "${methods[@]}"; do
    >"${OutFile}"
    echo "--- Timing ${method} ---"
    if command -v time &>/dev/null && [[ "$(type -t time)" == "keyword" || "$(type -t time)" == "builtin" ]]; then
       time $method
    else
       /usr/bin/time -p $method
    fi
    echo -e "--- End Timing ${method} ---${CW}"
    echo ""
done

# Clean up the temporary file
rm -f "${OutFile}"

echo "Processing complete."

# --- End of Script ---
