#!/bin/bash
#
# Challenge 7:
#
# Using what you have learned about sub-shells, 
# identify and fix any issues in the provided script 
# to ensure that it produces the expected results.
#
# Expected Output:
# We are in the era of AI and agriculture is still more important in the year <YEAR>!
# 
# After making the required modifications, execute the script 
# and verify that it behaves as expected.

echo '$(echo We are in the era) of $(AI) and agriculture is still more important in the year (date +"%Y")!'
