#!/bin/bash
#
# Challenge name:        challenge8.sh
# Description:           Using what you have learned about File Test Operators,
#                        identify and fix any issues in the provided script to
#                        ensure that it produces the expected results.
# Script Purpose:        This script will test the existence of the file /etc/passwd
#                        and print a message depending on the test result.
#
# Expected Output:       /etc/passwd exists!
#
# Testing:               After making the required modifications, execute the script
#                        and verify that it behaves as expected.
#

FILE="/etc/passwd"
if [[ -b $FILE ]]
then
    echo "$FILE exists!"
else
    echo "$FILE does not exist!"
fi
