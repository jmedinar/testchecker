#!/bin/bash
#
# Challenge 8:
#
# Using what you have learned about File Test Operators, 
# identify and fix any issues in the provided script 
# to ensure that it produces the expected results.
#
# Expected Output:
# /etc/passwd exists!
# 
# After making the required modifications, execute the script 
# and verify that it behaves as expected.

FILE="/etc/passwd"
if [[ -b $FILE ]]
then
    echo "$FILE exists!"
else
    echo "$FILE does not exist!"
fi
