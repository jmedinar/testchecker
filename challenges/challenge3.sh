#!/bin/bash
# -----------------------------------------------------------------------------
# Challenge Name:   challenge3.sh
# Student Task:     Fix errors related to quoting and command substitution.
# Description:      Quotes (`"`, `'`, `` ` ``) behave differently in shell scripts.
#                   This script attempts to assign strings to variables and
#                   print a combined message, but uses incorrect quoting methods.
# Script Purpose:   This script should define greeting, name, and location variables
#                   and then print a combined welcome message using these variables.
# -----------------------------------------------------------------------------
# Problem:          The script produces incorrect output or errors because:
#                   1. Backticks (`` ` ``) are used incorrectly for simple string
#                      assignment in the `GREETING` variable. Backticks are meant
#                      for *command substitution* (running a command and capturing
#                      its output).
#                   2. Single quotes (`'`) are used in the `echo` command where
#                      variable expansion is needed. Single quotes prevent the shell
#                      from replacing variable names (like `$LOCATION`) with their values.
#
# Your Task:        Identify and correct the quoting errors:
#                   1. Modify the `GREETING` variable assignment to correctly store
#                      the string "Hello,".
#                   2. Modify the `echo` command to ensure all variables (`$GREETING`,
#                      `$NAME`, `$LOCATION`) are correctly expanded to produce the
#                      expected sentence. Pay attention to how different quote types
#                      affect variable expansion.
#
# Expected Output:  When executed correctly (e.g., ./challenge3.sh), the
#                   script should print exactly:
#
#                   Hello Alice, Welcome to Wonderland!
#
# Hints:
#                   * Review the difference between double quotes (`"`), single quotes
#                     (`'`), and backticks (`` ` ``) in Bash.
#                   * Which type of quote allows variable expansion?
#                   * Which type of quote prevents variable expansion?
#                   * What are backticks used for? Is that needed for `GREETING`?
#                   * How should you assign a simple string like "Hello," to a variable?
#
# Testing:          After making the required modifications, make the script
#                   executable (`chmod +x challenge3.sh`) and run it
#                   (`./challenge3.sh`). Verify the output matches the
#                   "Expected Output" above.
# -----------------------------------------------------------------------------

# --- Script Code ---

GREETING=`Hello,`
NAME="Alice"
LOCATION='Wonderland'
echo "$GREETING $NAME Welcome 'to $LOCATION!" 

# --- End of Script ---
