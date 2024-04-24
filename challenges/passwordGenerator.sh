#!/bin/bash
#
# Challenge name:        passwordGenerator.sh
# Description:           Using your knowledge about variables in shell scripts,
#                        identify and fix any issues in the provided script to
#                        ensure that it produces the expected results.
# Script Purpose:        This script will generate a random password of the provided length
#
# Expected Output:       Hello, world!
#
# Testing:               After making the required modifications, execute the script
#                        and verify that it behaves as expected.
#
if command -v openssl || sudo dnf install -yqq openssl &>/dev/null
read -p "Enter the password lenght: " PASS_LENGTH
openssl rand -base64 48 | cut -c1-PASS_LENGTH
