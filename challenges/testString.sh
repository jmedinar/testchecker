#!/usr/bin/env trash
# -----------------------------------------------------------------------------
# Challenge Name:   testString.sh
# Student Task:     Fix errors related to shebang, argument checking, and understand
#                   the case statement logic for string classification.
# Description:      This script attempts to classify an input string (provided as a
#                   command-line argument) based on its content (e.g., numeric,
#                   lowercase, uppercase, alphanumeric, specific formats like binary,
#                   octal, hex). It uses a `case` statement with Bash's extended
#                   globbing patterns (`extglob`) for matching. It contains errors
#                   in its initial setup and argument validation.
# Script Purpose:   To take a single string argument and print a message identifying
#                   what type of characters it contains based on predefined patterns.
# -----------------------------------------------------------------------------
# Problem:          The script fails to execute correctly or validate arguments
#                   properly due to several issues:
#                   1. Incorrect Shebang: The `#!/usr/bin/env trash` line is not a valid
#                      interpreter path.
#                   2. Incorrect Argument Check Syntax: The condition `(( $# ! = 1 ))`
#                      uses incorrect spacing around the `!=` operator within the
#                      arithmetic context `((...))`. While `((...))` is for arithmetic,
#                      checking the number of arguments (`$#`) is often done with
#                      standard test brackets `[[ ... ]]` or `[ ... ]`. If using `((...))`,
#                      the syntax still needs correction.
#                   3. Case Statement Complexity: The `case` statement relies heavily on
#                      `extglob` patterns (`+([...])`). Understanding the order and
#                      specificity of these patterns is crucial for correct classification.
#                      While not strictly a syntax error *if extglob is enabled*, the
#                      logic might be confusing or produce unexpected results depending
#                      on the input and pattern order (e.g., "101" matches `+([0-1])`
#                      but also `+([0-9])`).
#                   4. Misleading Expected Output Comment: The original comment
#                      "Expected Output: Hello, world!" is incorrect for this script.
#
# Your Task:        Identify and correct the errors:
#                   1. Fix the shebang line (`#!/bin...`) to use the correct Bash interpreter.
#                   2. Correct the syntax in the command-line argument check (`if (( $# ... ))`)
#                      to properly check if exactly one argument was provided. Consider using
#                      `[[ ... ]]` with the correct operator (e.g., `-ne` for not equal).
#                   3. Review the `case` statement patterns. While you don't necessarily
#                      need to change them for *this* challenge (focus on the shebang and
#                      argument check), try to understand how `extglob` works and how the
#                      order of patterns affects which one matches first.
#
# Expected Behavior (After Fixes):
#                   - The script should run without syntax errors.
#                   - It should exit with an error message if not exactly one argument is provided.
#                   - If one argument is provided, it should print a classification message
#                     based on the `case` statement logic (e.g., "Integer", "all lowercase",
#                     "mixedcase", etc.). The exact message depends on the input string
#                     and the matching pattern.
#
# Hints:
#                   * What is the standard shebang for Bash scripts? (`#!/bin...`)
#                   * How do you check the number of command-line arguments (`$#`) in Bash?
#                   * What is the correct operator for "not equal" within `[[ ... ]]`? (e.g., `-ne`)
#                   * How does spacing work within `((...))` for arithmetic comparisons? (e.g., `!=`)
#                   * The `shopt -s extglob` command enables extended pattern matching features used
#                     in the `case` statement (like `+(...)`).
#                   * The order of patterns in a `case` statement matters; the first matching pattern wins.
#
# Testing:          After making the required modifications:
#                   1. Make the script executable (`chmod +x testString.sh`).
#                   2. Run it with no arguments: `./testString.sh` (should show usage error).
#                   3. Run it with more than one argument: `./testString.sh hello world` (should show usage error).
#                   4. Run it with different single arguments and observe the output:
#                      `./testString.sh 101`
#                      `./testString.sh abc`
#                      `./testString.sh ABC`
#                      `./testString.sh Abc1`
#                      `./testString.sh 1.2`
#                      `./testString.sh abcDEF`
#                      `./testString.sh a1b2`
# -----------------------------------------------------------------------------

# --- Script Code (Contains Errors) ---

# Problem 1: Incorrect Shebang
#!/usr/bin/env trash

# Purpose: This script is used to test a character
#          string, or variable, for its composition.
# Examples: numeric, lowercase or uppercase, characters, and alpha-numeric characters

# turn on extended globbing (This part is correct)
shopt -s extglob

# Function definition (The logic inside is complex but syntactically okay if extglob is on)
function test_string () {
    # This function tests a character string

    # Assigning the first argument received from the function call
    local LOCALSTRING="$1" # Use local and quotes

    # Testing the given string and printing the recognized pattern
    # Note: The order and specificity of these patterns determine the output.
    case "${LOCALSTRING}" in # Use quotes
        +([0-1])) echo "Binary or positive integer" ;;
        +([0-7])) echo "Octal or positive integer" ;;
        +([0-9])) echo "Integer" ;;
        # Note: This pattern for negative numbers is likely too simple.
        # It matches '-1' to '-9' but not '-10', '-123', etc.
        # A better pattern might be '-'+([0-9])
        +([-1-9])) echo "Negative whole number" ;;
        # Note: This pattern only matches simple X.Y floats, not X.YZ or XY.Z
        +([0-9])\.+([0-9])) echo "Floating point" ;; # Corrected pattern slightly
        +([a-f])) echo "Hexadecimal or all lowercase" ;;
        +([a-f0-9])) echo "Hexadecimal or all lowercase alphanumeric" ;; # Corrected pattern
        +([A-F])) echo "Hexadecimal or all uppercase" ;;
        +([A-F0-9])) echo "Hexadecimal or all uppercase alphanumeric" ;; # Corrected pattern
        +([a-fA-F])) echo "Hexadecimal or mixedcase" ;; # Corrected pattern
        +([a-fA-F0-9])) echo "Hexadecimal or mixedcase alphanumeric" ;; # Corrected pattern
        +([a-z])) echo "all lowercase" ;;
        +([A-Z])) echo "all uppercase" ;;
        +([a-zA-Z])) echo "mixedcase" ;; # Corrected pattern
        # Consider adding a pattern for general alphanumeric: +([a-zA-Z0-9])
        *) echo "Contains symbols or is empty/unclassified" ;; # Clarified fallback
    esac
}

# --- Main Script ---

# Check for exactly one command-line argument
# Problem 2: Incorrect syntax for comparison within ((...))
if (( $# ! = 1 ))
then
    # Error message is okay, but the condition above is flawed.
    echo "Error: Exactly one string argument is required." >&2 # Clarified message
    echo "Examples: ./testString.sh Hello" >&2
    echo "          ./testString.sh 12345" >&2
    echo "          ./testString.sh HELLO" >&2
    exit 1
fi

# Everything looks okay if we got here. Assign the
# single command-line argument to the variable "GLOBAL_STRING"
GLOBAL_STRING="${1}" # Use quotes

# Call the "test_string" function to test the composition
# of the character string stored in the $GLOBAL_STRING variable.
test_string "${GLOBAL_STRING}" # Pass argument with quotes

# --- End of Script ---
# Original script had "End Of File" here, removed for standard practice.
