#!/bin/trash
#
# Challenge name:        homeChecker.sh
# Description:           Using correct script formatting rules for shell scripts,
#                        identify and fix any issues in the provided script to
#                        ensure that it produces the expected results.
# Script Purpose:        This script is intended to be used to find home directories that are orphaned
#                        and setting a directory folder for testing purposes.
#
# Expected Output:       /home/goneuser
#                        1010:1010
#
# Testing:               After making the required modifications, execute the script
#                        and verify that it behaves as expected.
#

if [[ $USER != "root" ]]
then
    echo "Run this script using sudo!. Exiting..."
    exit 1
else
    useradd goneuser
    userdel goneuser
    find /home -maxdepth 1 -type d -nouser -print -exec stat -c "%u:%g" {} \; 
fi
