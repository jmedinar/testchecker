#!/bin/bash
#
# Challenge name:        challenge2.sh
# Description:           Using what you have learned about script variables
#                        identify and fix any issues in the provided script to
#                        ensure that it produces the expected results.
# Script Purpose:        This script will print a quote using color codes and variables
#
# Expected Output:       Welcome student to the Linux class!
#
# Testing:               After making the required modifications, execute the script
#                        and verify that it behaves as expected.
#

message="Welcome
red='\e[0;31m'
white='\e[0;37m'
parameter1=$1
class "Linux"

echo -e "${message} ${parameter1} to the red$class$white} class!"
