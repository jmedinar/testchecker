#!/bin/bash
# -----------------------------------------------------------------------------
# Challenge Name:   challenge5.sh
# Student Task:     Fix the order of positional parameters in the echo statement.
# Description:      Shell scripts can accept arguments passed to them on the
#                   command line. These are accessed using positional parameters
#                   like $1 (first argument), $2 (second argument), etc. This
#                   script attempts to rearrange provided words into a specific
#                   sentence, but the order of parameters in the `echo` command
#                   is incorrect.
# Script Purpose:   This script takes multiple words as command-line arguments
#                   and rearranges them to print a specific sentence.
# -----------------------------------------------------------------------------
# Problem:          The script does not produce the "Expected Output" sentence
#                   when given the intended input words because the positional
#                   parameters (`$1`, `$3`, `$4`, etc.) in the `echo` statement
#                   are not in the correct sequence to form the target sentence.
#
# Your Task:        Modify *only* the `echo` command line. Do not change the
#                   shebang or the comments. Rearrange the existing positional
#                   parameters (`${1}` through `${10}`) within the `echo`
#                   statement so that when the script is run with the correct
#                   input words, it produces the exact "Expected Output".
#
# Required Input:   To get the expected output, the script needs to be run
#                   with the following 10 words as arguments, in this specific order:
#                   `./challenge5.sh Learning very Linux challenging is rewarding fun it also but`
#                   (Where "Learning" becomes $1, "very" becomes $2, "Linux" becomes $3, etc.)
#
# Expected Output:  When executed correctly with the required input arguments shown above,
#                   the script should print exactly:
#                   Learning Linux is challenging but it is also fun and very rewarding
#
# Hints:
#                   * `$1` refers to the first argument, `$2` to the second, and so on.
#                   * For arguments beyond 9 (like the 10th), you need curly braces: `${10}`.
#                   * Map the words from the "Required Input" to the "Expected Output"
#                     sentence to figure out which positional parameter corresponds to
#                     each word in the final sentence.
#                   * Example: The first word in the output is "Learning", which is the
#                     first input argument (`$1`). The second word is "Linux", which is the
#                     third input argument (`$3`). Continue this mapping.
#
# Testing:          After making the required modifications, make the script
#                   executable (`chmod +x challenge5.sh`) and run it *with the
#                   correct arguments*:
#                   `./challenge5.sh Learning very Linux challenging is rewarding fun it also but`
#                   Verify the output matches the "Expected Output" exactly.
# -----------------------------------------------------------------------------

# --- Script Code ---

echo "${1} ${3} is ${4} but ${7} is ${9} ${10} and ${2} ${5} ${6}"

# --- End of Script ---
