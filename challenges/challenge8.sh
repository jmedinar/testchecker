#!/bin/bash
# -----------------------------------------------------------------------------
# Challenge Name:   challenge8.sh
# Student Task:     Fix the incorrect file test operator.
# Description:      Bash provides test operators within `[[ ... ]]` or `[ ... ]`
#                   to check various properties of files, such as existence, type
#                   (regular file, directory, block device, etc.), and permissions.
#                   This script attempts to check if `/etc/passwd` exists but uses
#                   the wrong operator.
# Script Purpose:   This script should test if the file `/etc/passwd` exists
#                   and print a corresponding message.
# -----------------------------------------------------------------------------
# Problem:          The script incorrectly reports that `/etc/passwd` does not exist
#                   (or might report it exists for the wrong reason if `/etc/passwd`
#                   somehow *was* a block device) because it uses the `-b` file test
#                   operator. The `-b` operator specifically checks if a file exists
#                   AND is a block special file (like `/dev/sda`). It does *not* check
#                   for the general existence of any file or specifically for a
#                   regular file like `/etc/passwd`.
#
# Your Task:        Modify *only* the `if` condition line.
#                   1. Replace the incorrect file test operator (`-b`) with the
#                      correct operator to check if the file specified by the `$FILE`
#                      variable *exists*.
#
# Expected Output:  When executed correctly (e.g., ./challenge8.sh), the
#                   script should print exactly:
#                   /etc/passwd exists!
#
# Hints:
#                   * Review Bash File Test Operators (search "man test" or
#                     "bash file test operators").
#                   * Which operator checks if a file exists (regardless of type)?
#                   * Which operator checks if a file exists AND is a regular file
#                     (not a directory or device file)? Either would work here,
#                     but one is more general.
#                   * The `-b` operator is for block devices. `/etc/passwd` is a
#                     regular text file.
#
# Testing:          After making the required modification, make the script
#                   executable (`chmod +x challenge8.sh`) and run it
#                   (`./challenge8.sh`). Verify the output matches the
#                   "Expected Output" above.
# -----------------------------------------------------------------------------

# --- Script Code (Contains Errors) ---

FILE="/etc/passwd"

# Problem Area: The '-b' operator checks if the file exists AND is a block special file.
#               This is incorrect for checking the existence of a regular file like /etc/passwd.
if [[ -b $FILE ]]
then
    # This block will likely not execute for /etc/passwd
    echo "$FILE exists!"
else
    # This block will likely execute incorrectly because -b is the wrong test
    echo "$FILE does not exist!"
fi

# --- End of Script ---
