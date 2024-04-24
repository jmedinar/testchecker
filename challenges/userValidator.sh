#!/bin/bash
#
# Challenge name:        userValidator.sh
# Description:           Using correct script formatting rules for shell scripts,
#                        identify and fix any issues in the provided script to
#                        ensure that it produces the expected results.
# Script Purpose:        This script first checks that its being executed by the root
#                        user, then gets a list of users from the /etc/passwd file that
#                        it uses to identify the status of the users.
#
# Expected Output:       Hello, world!
#
# Testing:               After making the required modifications, execute the script
#                        and verify that it behaves as expected.
#

if [[ 'root' != $(whoami) ]]
then
	echo 'Script must be executed with root authority'
	exit 1
fi
for user in $(cat /etc/passwd | grep -vE 'nologin' | sed 's/:/ /g' | awk '{print $1}')
do
	status = $(passwd -S $user)
	if [[ ${status} =~ 'locked' ]]
	then
		echo "${user} is LOCKED"
	elif [[ ${status} =~ 'set' ]]
	then
		echo "${user} is UNLOCKED"
	else
		echo "${user} is ALTERNATE"
	fi
done
