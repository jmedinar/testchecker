#!/usr/bin/env trash
#
# Challenge name:        testString.sh
# Description:           Using what you know about variables and the case statement,
#                        identify and fix any issues in the provided script to
#                        ensure that it produces the expected results.
# Script Purpose:        This script takes a string in any format and identifies
#                        the type of string by making use of regular expressions.
#
# Expected Output:       Hello, world!
#
# Testing:               After making the required modifications, execute the script
#                        and verify that it behaves as expected.
#
# Purpose: This script is used to test a character
#          string, or variable, for its composition.
# Examples: numeric, lowercase or uppercase, characters, and alpha-numeric characters

# turn on extended globbing
shopt -s extglob

function test_string () {
    # This function tests a character string
    
    # Assigning the first argument received from the user at runtime to the variable LOCALSTRING
    LOCALSTRING=$1

    # Testing the given string and printing the recognized pattern
    case LOCALSTRING in
        +([0-1])) echo "Binary or positive integer" ;;
        +([0-7])) echo "Octal or positive integer" ;;
        +([0-9])) echo "Integer" ;;
        +([-1-9])) echo "Negative whole number" ;;
        +([0-9][.][0-9])) echo "Floating point" ;;
        +([a-f])) echo "Hexidecimal or all lowercase" ;;
        +([a-f]|[0-9])) echo "Hexidecimal or all lowercase alphanumeric" ;;
        +([A-F])) echo "Hexadecimal or all uppercase" ;;
        +([A-F]|[0-9])) echo "Hexadecimal or all uppercase alphanumeric" ;;
        +([a-f]|[A-F])) echo "Hexadecimal or mixedcase" ;;
        +([a-f]|[A-F]|[0-9])) echo "Hexadecimal or mixedcase alphanumeric" ;;
        +([a-z])) echo "all lowercase" ;;
        +([A-Z])) echo "all uppercase" ;;
        +([a-z]|[A-Z])) echo "mixedcase" ;;
        *) echo "Invalid string composition" ;;
    esac
}

# Main

# Check for exactly one command-line argument
if (( $# ! = 1 ))
then
    echo "Error: at least one string to be tested must be given"
    echo "Examples: ./test_string.sh Hello"
    echo "          ./test_string.sh 12345"
    echo "          ./test_string.sh HELLO"
    exit 1
fi

# Everything looks okay if we got here. Assign the
# single command-line argument to the variable "GLOBAL_STRING"
GLOBAL_STRING=${1}

# Call the "test_string" function to test the composition
# of the character string stored in the $GLOBAL_STRING variable.

test_string $GLOBAL_STRING

End Of File
