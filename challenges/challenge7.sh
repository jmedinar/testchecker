#!/bin/bash
# -----------------------------------------------------------------------------
# Challenge Name:   challenge7.sh
# Student Task:     Fix errors related to command substitution and quoting.
# Description:      Bash allows you to run commands and use their output within
#                   another command. This is called *command substitution*, typically
#                   done using `$(...)`. This script attempts to construct a sentence
#                   by combining literal text with the output of several commands,
#                   but it uses incorrect syntax for both command substitution and
#                   quoting.
# Script Purpose:   This script intends to print a sentence where parts of the
#                   sentence come from the output of `echo` commands and the
#                   current year comes from the `date` command.
# -----------------------------------------------------------------------------
# Problem:          The script does not produce the expected output. Instead, it
#                   prints the command substitution syntax literally because:
#                   1. Single quotes (`'...'`) are used around the entire string.
#                      Single quotes prevent *all* expansions, including command
#                      substitution (`$(...)`) and variable expansion (`$VAR`).
#                   2. Even if double quotes were used, the syntax for some of the
#                      intended command substitutions is incorrect (e.g., `$(AI)`
#                      and `(date +"%Y")`). The shell tries to run `AI` as a command,
#                      which likely fails. The `date` command substitution is missing
#                      the required `$`.
#
# Your Task:        Modify *only* the `echo` command line.
#                   1. Change the outer quoting to a type that *allows* command
#                      substitution (typically double quotes `"`).
#                   2. Correct the syntax for *each* command substitution `$(...)`
#                      within the string so that the commands (`echo We are in the era`,
#                      `echo AI`, `date +"%Y"`) are actually executed and their
#                      output is inserted into the final sentence.
#
# Expected Output:  When executed correctly (e.g., ./challenge7.sh), the
#                   script should print a sentence like the following, where
#                   `<YEAR>` is replaced by the current 4-digit year:
#                   We are in the era of AI and agriculture is still more important in the year <YEAR>!
#                   (Example: We are in the era of AI and agriculture is still more important in the year 2025!)
#
# Hints:
#                   * Review the difference between single quotes (`'`) and double
#                     quotes (`"`) regarding command substitution and variable expansion.
#                   * The correct syntax for command substitution is `$(command)`.
#                   * Ensure that the commands inside `$(...)` are valid commands
#                     that produce the desired text fragments (e.g., `echo AI`, `date +"%Y"`).
#
# Testing:          After making the required modifications, make the script
#                   executable (`chmod +x challenge7.sh`) and run it
#                   (`./challenge7.sh`). Verify the output matches the
#                   "Expected Output" format, including the current year.
# -----------------------------------------------------------------------------

# --- Script Code ---

echo '$(echo We are in the era) of $(AI) and agriculture is still more important in the year (date +"%Y")!'

# --- End of Script ---
