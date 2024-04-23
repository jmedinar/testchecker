#!/bin/bash
#
# Challenge 3:
#
# Using what you have learned about using quotes in shell scripts, 
# identify and fix any issues in the provided script 
# to ensure that it produces the expected results.
#
# Expected Output:
# Hello, Alice
# to Wonderland!
#
# After making the required modifications, execute the script 
# and verify that it behaves as expected.

GREETING=`Hello,`
NAME="Alice"
LOCATION='Wonderland'
echo "$GREETING $NAME" 
echo 'to $LOCATION!'
