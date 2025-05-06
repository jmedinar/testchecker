#!/bin/trash
# -----------------------------------------------------------------------------
# Challenge Name:   homeChecker.sh
# Student Task:     Fix errors related to shebang, root check, and command execution.
# Description:      This script attempts to find "orphaned" home directories
#                   (directories in /home whose owner user no longer exists)
#                   by creating and deleting a temporary user. It uses `find`
#                   to locate such directories and `stat` to get ownership info.
#                   However, it contains errors in its initial setup and how
#                   it executes and combines commands.
# Script Purpose:   To create a scenario where an orphaned home directory exists
#                   and then use `find` and `stat` to identify it and print its
#                   path and numeric owner:group information.
# -----------------------------------------------------------------------------
# Problem:          The script fails to execute correctly or produce the precise
#                   expected output due to several issues:
#                   1. Incorrect Shebang: The `#!/bin/trash` line is not a valid
#                      interpreter path, preventing the script from running correctly.
#                   2. Incorrect Root Check: `[[ $USER != "root" ]]` is unreliable.
#                      When using `sudo`, `$USER` often retains the original user's
#                      name, not "root". A check based on the *effective* user ID
#                      is needed.
#                   3. `find` Command Output: The current `find` command uses `-print`
#                      (which prints the directory path followed by a newline) and
#                      then `-exec stat ... \;` (which prints the stat output followed
#                      by a newline). This results in two separate lines of output for
#                      each found directory, not the combined format shown in the
#                      "Expected Output".
#
# Your Task:        Identify and correct the errors:
#                   1. Fix the shebang line (`#!/bin...`) to use the correct Bash interpreter.
#                   2. Modify the root check condition to reliably verify if the script
#                      is running with root privileges (effective UID 0).
#                   3. Adjust the `find` command or how its actions (`-print`, `-exec`)
#                      are used so that the output for the orphaned `/home/goneuser`
#                      directory matches the "Expected Output" format exactly (path on
#                      one line, UID:GID on the next). Consider how `-printf` or
#                      alternative ways to use `-exec` might achieve this.
#
# Expected Output:  When executed correctly (e.g., sudo ./homeChecker.sh), the
#                   script should print *exactly* two lines:
#                   /home/goneuser
#                   1010:1010
#                   (Note: The UID/GID `1010:1010` assumes the `goneuser` was assigned
#                    this specific ID. Your task is to make the script produce this
#                    *exact* output format, even if the underlying mechanism relies
#                    on `stat` printing the actual ID left behind.)
#
# Hints:
#                   * What is the standard shebang for Bash scripts? (`#!/bin...`)
#                   * How can you check the *effective* user ID (EUID) in Bash? (`$EUID`)
#                     What value does root's EUID have?
#                   * Explore the `find` command's actions:
#                     - How does `-print` format its output?
#                     - How does `-exec ... \;` format its output?
#                     - Does `find` have an action like `-printf` that allows custom
#                       output formatting, including newlines (`\n`)?
#                     - Could you use `-exec` to run a small shell command that combines
#                       `echo` and `stat`?
#
# Testing:          After making the required modifications, make the script
#                   executable (`chmod +x homeChecker.sh`) and run it *with sudo*:
#                   `sudo ./homeChecker.sh`
#                   Verify the output matches the "Expected Output" exactly.
# -----------------------------------------------------------------------------

# --- Script Code (Contains Errors) ---

# Problem 1: Incorrect Shebang
#!/bin/trash

# Problem 2: Incorrect Root Check
if [[ $USER != "root" ]]
then
    echo "Run this script using sudo!. Exiting..."
    exit 1
else
    # These commands correctly create and delete the user to orphan the directory
    useradd goneuser &>/dev/null
    userdel goneuser &>/dev/null

    # Problem 3: find command's output format doesn't match expected output
    # -print adds a newline, -exec stat adds another newline.
    find /home -maxdepth 1 -type d -nouser -print -exec stat -c "%u:%g" {} \;
fi

# --- End of Script ---
