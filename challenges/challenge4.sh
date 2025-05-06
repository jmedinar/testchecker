#!/bin/bash
# -----------------------------------------------------------------------------
# Challenge Name:   challenge4.sh
# Student Task:     Fix errors related to exit code checking and output redirection.
# Description:      Commands in Linux return an exit code ($?) to indicate success (0)
#                   or failure (non-zero). This script attempts to check if files
#                   exist using the 'ls' command and its exit code, but the logic
#                   is flawed. It also incorrectly handles error messages.
# Script Purpose:   This script iterates through a list of file paths and should
#                   report whether each file exists or not based on the success
#                   or failure of the 'ls' command.
# -----------------------------------------------------------------------------
# Problem:          The script produces incorrect "found" / "not found" messages
#                   because:
#                   1. It misinterprets the exit code of the `ls` command. `ls`
#                      returns 0 if the file *is* found and a non-zero code (like 1 or 2)
#                      if it's *not* found or another error occurs. The `if` condition
#                      currently checks if the exit code is exactly 1, leading to
#                      incorrect conclusions.
#                   2. While `2>/dev/null` correctly suppresses the error messages
#                      from `ls` (like "ls: cannot access ... No such file or directory"),
#                      the logic based on the exit code needs to be correct for the
#                      script's own messages to be accurate.
#
# Your Task:        Identify and correct the logic error:
#                   1. Modify the `if` condition to correctly check the exit code (`$?`)
#                      of the `ls` command to determine if the file was successfully
#                      listed (meaning it exists) or if `ls` failed (meaning it likely
#                      doesn't exist or there was another error).
#                   2. Ensure the `echo` statements within the `if` and `else` blocks
#                      print the correct message ("found" or "not found") based on the
#                      corrected exit code check.
#
# Expected Output:  When executed correctly (e.g., ./challenge4.sh), the
#                   script should print exactly:
#
#                   File /path/to/nonexistent/file not found
#                   File /etc/passwd found
#                   File /etc/fedora-release found
#                   File /etc/linux_version not found
#
#                   (Note: /etc/linux_version might exist on some very old systems,
#                    but is typically absent on modern Fedora, making "not found"
#                    the expected result here).
#
# Hints:
#                   * What does an exit code of 0 usually signify for a command?
#                   * What does a non-zero exit code usually signify?
#                   * How does the `ls` command behave regarding exit codes when a
#                     file exists versus when it doesn't? (Try `ls /etc/passwd; echo $?`
#                     and `ls /nonexistentfile; echo $?`)
#                   * How should the `if [[ $? -eq ... ]]` condition be written to
#                     correctly identify success (file found)?
#
# Testing:          After making the required modifications, make the script
#                   executable (`chmod +x challenge4.sh`) and run it
#                   (`./challenge4.sh`). Verify the output matches the
#                   "Expected Output" above.
# -----------------------------------------------------------------------------

# --- Script Code (Contains Errors) ---

# List of files to check
files_to_list="/path/to/nonexistent/file /etc/passwd /etc/fedora-release /etc/linux_version"

# Loop through each file path
for file in ${files_to_list}
do
    # Attempt to list the file, redirecting errors (like "No such file") to /dev/null
    ls ${file} 2>/dev/null
    # 'ls' returns 0 on success (file found), non-zero on failure (file not found).
    if [[ $? -eq 1 ]]
    then
        # This message prints when ls *fails* with exit code 1
        echo "File $file found"
    else
        # This message prints when ls *succeeds* (exit code 0) or fails with a different code
        echo "File $file not found"
    fi
done

# --- End of Script ---