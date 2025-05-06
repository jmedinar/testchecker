#!/bin/bash
# -----------------------------------------------------------------------------
# Challenge Name:   challenge2.sh
# Student Task:     Fix variable assignments and string construction errors.
# Description:      Variables are fundamental in scripting for storing and
#                   reusing data. This script attempts to use variables to
#                   construct a colored message but contains several errors
#                   related to how variables are defined and used.
# Script Purpose:   This script is intended to define several variables (a message
#                   part, color codes, a parameter, and a class name) and then
#                   combine them using 'echo -e' to print a colored sentence.
# -----------------------------------------------------------------------------
# Problem:          The script fails to run correctly or produces unexpected
#                   output due to multiple issues:
#
#                   1. Incorrect multi-line variable assignment.
#                   2. Variables being defined *inside* another variable's string.
#                   3. Invalid syntax for assigning a string containing spaces.
#                   4. Incorrect syntax for embedding variables and color codes
#                      within the final 'echo' statement.
#                   5. A variable (`parameter1`) is assigned but not used as intended
#                      in the final output string.
#
# Your Task:        Identify and correct all the variable definition and usage
#                   errors. Ensure the final 'echo' command correctly constructs
#                   the expected sentence using the defined variables and applies
#                   the color codes properly. Assume the script should use the
#                   word "student" where `$parameter1` might have been intended.
#
# Expected Output:  When executed correctly (e.g., ./challenge2.sh), the
#                   script should print the following colored sentence (where
#                   "Linux" is red):
#                   Welcome student to the <RED_TEXT>Linux</RED_TEXT> class!
#                   (Note: <RED_TEXT> indicates where the color should change)
#
# Hints:
#                   * How do you assign a multi-line string to a variable?
#                   * Variables must be defined *before* they are used.
#                   * How do you assign a string containing spaces to a variable?
#                     (e.g., `my_var="some words"`)
#                   * How do you correctly reference variables within an `echo`
#                     string (e.g., `${variable_name}`)?
#                   * Pay close attention to quotes (`"` vs `'`) when using variables
#                     and escape sequences (`\e[...]`) with `echo -e`.
#                   * Ensure the color codes are applied correctly around the word "Linux".
#
# Testing:          After making the required modifications, make the script
#                   executable (`chmod +x challenge2.sh`) and run it
#                   (`./challenge2.sh`). Verify the output matches the
#                   "Expected Output" above, including the color on the word "Linux".
# -----------------------------------------------------------------------------

# --- Script Code ---

message="Welcome
red='\e[0;31m'
white='\e[0;37m'
parameter1=$1 # This variable is assigned but not used below
class "Linux" # This is not valid variable assignment syntax

# Problem Area 2: The echo command has syntax errors and doesn't use variables correctly
echo -e "${message} ${parameter1}to the red$class$white} class!"

# --- End of Script ---
