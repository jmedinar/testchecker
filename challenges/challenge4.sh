#!/bin/bash
#
# Challenge name:        challenge4.sh
# Description:           Using what you have learned about using exit codes and redirection channels,
#                        identify and fix any issues in the provided script to
#                        ensure that it produces the expected results.
# Script Purpose:        This script will use a loop to verify the existence of four files
#                        using the exit code of the ls command.
#
# Expected Output:       File /path/to/nonexistent/file does not exist
#                        File /etc/passwd exists
#                        File /etc/fedora-release exists
#                        File /etc/linux_version does not exist
#
# Testing:               After making the required modifications, execute the script
#                        and verify that it behaves as expected.
#

files_to_list="/path/to/nonexistent/file /etc/passwd /etc/fedora-release /etc/linux_version"
for file in ${files_to_list}
do
    ls ${file} 2>/dev/null
    if [[ $? -eq 1 ]]
    then
        echo "File $file exists"
    else
        echo "File $file does not exist"
    fi 
done
