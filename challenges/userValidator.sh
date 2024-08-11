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
passwd -l sync &>/dev/null
for user in $(cat /etc/passwd | grep -vE 'nologin' | sed 's/:/ /g' | awk '{print $1}')
do
	status = $(userdbctl user ${user} | grep "Password OK" 2>/dev/null)
	if [[ ${status} =~ 'locked' ]]
	then
		echo "${user} is LOCKED"
	elif [[ ${status} =~ 'set' ]]
	then
		echo "${user} password is NOT SET"
	elif [[ ${status} =~ 'yes' ]]
	then
		echo "${user} password is SET"
	fi
done
passwd -u sync &>/dev/null
