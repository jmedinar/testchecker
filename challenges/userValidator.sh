#!/bin/bash
# -----------------------------------------------------------------------------
# Challenge Name:   userValidator.sh
# Student Task:     Fix errors related to root check, command execution, variable
#                   assignment, and output parsing.
# Description:      This script attempts to check the password status (locked, set,
#                   not set) for users listed in `/etc/passwd` (excluding those
#                   with nologin shells). It uses `userdbctl` (or intends to) to get
#                   status information. It contains errors in checking for root
#                   privileges, assigning variables, and interpreting command output.
# Script Purpose:   To iterate through system users with valid shells and report
#                   their password status. It temporarily locks the 'sync' user
#                   to ensure different statuses are present for testing.
# -----------------------------------------------------------------------------
# Problem:          The script fails to execute correctly or produces incorrect
#                   status reports due to several issues:
#                   1. Incorrect Root Check: `[[ 'root' != $(whoami) ]]` is not the most
#                      reliable way to check for root privileges, especially in scripts.
#                      Checking the effective user ID (EUID) is preferred.
#                   2. Fragile User List Generation: Using `cat | grep | sed | awk` to parse
#                      `/etc/passwd` can be brittle. Simpler methods using `awk` or `getent`
#                      might be more robust.
#                   3. Incorrect Variable Assignment: The line `status = $(...)` has spaces
#                      around the `=` sign, which is invalid syntax for variable assignment in Bash.
#                   4. Incorrect Command/Output Parsing: The command `userdbctl user ${user} | grep "Password OK"`
#                      is unlikely to provide the necessary status information (locked, set, not set).
#                      The actual output of `userdbctl user ${user}` or perhaps `passwd -S ${user}`
#                      needs to be examined to determine how to correctly extract the password status.
#                      Consequently, the `if/elif` conditions checking `$status` against 'locked',
#                      'set', and 'yes' are likely based on incorrect assumptions about the command's output.
#                   5. Misleading Expected Output Comment: The original comment
#                      "Expected Output: Hello, world!" is incorrect for this script.
#
# Your Task:        Identify and correct the errors:
#                   1. Fix the root check condition to reliably verify if the script
#                      is running with root privileges (effective UID 0).
#                   2. (Optional but Recommended): Consider if the user list generation can be simplified.
#                   3. Correct the variable assignment syntax for the `status` variable.
#                   4. Determine the correct command (`userdbctl user ...` or `passwd -S ...` or other)
#                      and parsing logic needed to reliably get the password status (e.g., 'L ' for locked,
#                      'PS' for password set, 'NP' or 'LK' for no password/locked without password, etc. -
#                      check the man pages or command output!).
#                   5. Adjust the `if/elif` conditions to correctly check the actual status information
#                      obtained in the previous step and print the appropriate messages.
#
# Expected Behavior (After Fixes):
#                   - The script should run without syntax errors when executed with `sudo`.
#                   - It should exit if not run with root privileges.
#                   - It should iterate through users with login shells.
#                   - For each user, it should print a message indicating whether their password
#                     is SET, NOT SET, or if the account is LOCKED, based on reliable status checks.
#                   - Example Output Lines (will vary based on system users):
#                     root password is SET
#                     bin password is NOT SET
#                     sync is LOCKED  (due to the temporary lock in the script)
#                     student password is SET
#                     ... etc. ...
#
# Hints:
#                   * How do you check the *effective* user ID (EUID) in Bash? (`$EUID`) What is root's EUID?
#                   * How do you assign the output of a command to a variable correctly? (`var=$(command)`)
#                   * Check the man pages or run the commands directly for `userdbctl user <username>` and
#                     `passwd -S <username>` to see their exact output format for different account statuses.
#                   * How can you use tools like `awk`, `cut`, or parameter expansion to extract specific
#                     parts of the command output (e.g., the status field from `passwd -S`)?
#                   * Adjust the patterns in the `if/elif` conditions (`=~ '...'` or string comparisons `== "..."`)
#                     to match the actual status indicators you find in the command output.
#
# Testing:          After making the required modifications:
#                   1. Make the script executable (`chmod +x userValidator.sh`).
#                   2. Run it *with sudo*: `sudo ./userValidator.sh`
#                   3. Verify it runs without errors and prints status messages for users. Check if the
#                      status reported for users like `root`, `bin`, `sync`, and your own user seems correct.
# -----------------------------------------------------------------------------

# --- Script Code (Contains Errors) ---

#!/bin/bash

# Problem 1: Incorrect Root Check
if [[ 'root' != $(whoami) ]]
then
    echo 'Script must be executed with root authority' >&2 # Send errors to stderr
    exit 1
fi

# Temporarily lock the 'sync' user account to test lock detection
# This part is functionally okay but relies on the rest of the script working.
passwd -l sync &>/dev/null

# Problem 2: User list generation might be fragile
# Problem 4 & 5: Command to get status and subsequent checks are likely incorrect
for user in $(cat /etc/passwd | grep -vE 'nologin|false' | sed 's/:/ /g' | awk '{print $1}') # Added 'false' to grep -vE
do
    # Problem 3: Incorrect variable assignment syntax (spaces around =)
    # Problem 4: Command and grep likely don't provide the needed status info
    status = $(userdbctl user ${user} | grep "Password OK" 2>/dev/null)

    # Problem 5: The patterns 'locked', 'set', 'yes' likely don't match the actual output
    if [[ ${status} =~ 'locked' ]] # This checks if the *variable* contains 'locked'
    then
        echo "${user} is LOCKED"
    elif [[ ${status} =~ 'set' ]] # This checks if the *variable* contains 'set'
    then
        # This message might be misleading depending on actual status (e.g., could be locked)
        echo "${user} password is NOT SET"
    elif [[ ${status} =~ 'yes' ]] # This checks if the *variable* contains 'yes'
    then
        echo "${user} password is SET"
    # Consider adding an 'else' to catch users where status wasn't determined
    # else
    #    echo "${user} status UNKNOWN (${status})"
    fi
done

# Unlock the 'sync' user account after the loop
passwd -u sync &>/dev/null

# --- End of Script ---
