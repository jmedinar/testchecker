#!/usr/bin/env bash
# Script: testChecker.sh
title="TestChecker"
# Author: Professor Juan Medina
# Email: jmedina@collin.edu
# Date: 03/23/2024
version="4.0.4"
# Purpose: This script will gater VM and Student information
#          and will execute the interactive test verification scripts

# Red         Green         Yellow        Blue  		Purple        Cyan          White
CR='\e[0;31m' CG='\e[0;32m' CY='\e[0;33m' CL='\e[0;34m' CP='\e[0;35m' CC='\e[0;36m' CW='\e[0;37m'
username=$(who am i | awk '{print $1}')
testtype=$1
studentid=0

if [[ ${UID} -ne 0 ]]; then echo "Execute this script with sudo"; exit 1; fi
if id "liveuser" &>/dev/null || [ -f /etc/live-release ] || [[ "$(findmnt -n -o FSTYPE /)" =~ (squashfs|overlay) ]]; then
    echo "Error: This script should not be run as the 'liveuser' or from the live ISO environment."
    echo "Please complete the Fedora installation and log in as a regular user before running this script."
    exit 1
fi
if id "vboxuser" &>/dev/null; then
    echo "Error: This script should not be run as the 'vboxuser'."
    echo "If using a computer at school ensure you are running under your own user account before running this script."
    exit 1
fi
if ! grep -q '^ID=fedora$' /etc/os-release || [ ! -f /etc/fedora-release ] || ! command -v dnf &>/dev/null; then
    echo "Error: This script is designed to run on Fedora Linux only."
    echo "Please run this script on a Fedora Linux System."
    exit 1
fi
if [[ $(wget -q --spider http://google.com; echo $?) -ne 0 ]]; then echo "Internet connection required"; exit 2; fi

_update(){
	# Check if running the latest version
	code="aHR0cHM6Ly9yYXcuZ2l0aHVidXNlcmNvbnRlbnQuY29tL2ptZWRpbmFyL3Rlc3RjaGVja2VyL21haW4vdGVzdGNoZWNrZXIuc2gK" 
	remote_version=$(curl -sk -H 'Cache-Control: no-cache' \
		$(echo ${code} | base64 -d) \
		| grep -E '^version' \
		| sed 's/=/ /' \
		| awk '{print $NF}' \
		| sed 's/"//g')
	if [[ ${remote_version} != ${version} ]]
	then
		echo -e "${CR} A new version of the testchecker is available. Upgrading..."
		wget -q --no-check-certificate --no-cache --no-cookies \
			$(echo ${code} | base64 -d) \
			-O /usr/bin/testchecker
		chmod 700 /usr/bin/testchecker
		echo -e "${CG}Upgrade Done. ${CY}Please rerun the testchecker.${CW}"
		exit 5
	fi
}

_print_line() {
    printf "${CC}%0.s=" {1..80}
    printf "${CW}\n"
}

_update

clear
echo ""
_print_line
echo -e "${CL}                        C O L L I N   C O L L E G E "
echo -e "${CP}                        ${title} Version: ${version} "
_print_line
echo -e "${CG} DATE: ${CY} $(date) ${CG} STUDENT: ${CY} ${username} ${CW}"
read -p " Introduce your student numeric ID: " studentid
if [[ -z ${testtype} ]]
then
	read -p " Indicate the assignment to check [from 1 to 8]: " choice
	case ${choice} in
		1) source <(curl -sk -H 'Cache-Control: no-cache' \
					$(echo "aHR0cHM6Ly9yYXcuZ2l0aHVidXNlcmNvbnRlbnQuY29tL2ptZWRpbmFyL3Rlc3RjaGVja2VyL21haW4vYXNzaWdubWVudDEuc2gK" | base64 -d)) ;;
		2) source <(curl -sk -H 'Cache-Control: no-cache' \
					$(echo "aHR0cHM6Ly9yYXcuZ2l0aHVidXNlcmNvbnRlbnQuY29tL2ptZWRpbmFyL3Rlc3RjaGVja2VyL21haW4vYXNzaWdubWVudDIuc2gK" | base64 -d)) ;;
		3) source <(curl -sk -H 'Cache-Control: no-cache' \
					$(echo "aHR0cHM6Ly9yYXcuZ2l0aHVidXNlcmNvbnRlbnQuY29tL2ptZWRpbmFyL3Rlc3RjaGVja2VyL21haW4vYXNzaWdubWVudDMuc2gK" | base64 -d)) ;;
		4) source <(curl -sk -H 'Cache-Control: no-cache' \
					$(echo "aHR0cHM6Ly9yYXcuZ2l0aHVidXNlcmNvbnRlbnQuY29tL2ptZWRpbmFyL3Rlc3RjaGVja2VyL21haW4vYXNzaWdubWVudDQuc2gK" | base64 -d)) ;;
		5) source <(curl -sk -H 'Cache-Control: no-cache' \
					$(echo "aHR0cHM6Ly9yYXcuZ2l0aHVidXNlcmNvbnRlbnQuY29tL2ptZWRpbmFyL3Rlc3RjaGVja2VyL21haW4vYXNzaWdubWVudDUuc2gK" | base64 -d)) ;;
		6) source <(curl -sk -H 'Cache-Control: no-cache' \
					$(echo "aHR0cHM6Ly9yYXcuZ2l0aHVidXNlcmNvbnRlbnQuY29tL2ptZWRpbmFyL3Rlc3RjaGVja2VyL21haW4vYXNzaWdubWVudDYuc2gK" | base64 -d)) ;;
		7) source <(curl -sk -H 'Cache-Control: no-cache' \
					$(echo "aHR0cHM6Ly9yYXcuZ2l0aHVidXNlcmNvbnRlbnQuY29tL2ptZWRpbmFyL3Rlc3RjaGVja2VyL21haW4vYXNzaWdubWVudDcuc2gK" | base64 -d)) ;;
		8) source <(curl -sk -H 'Cache-Control: no-cache' \
					$(echo "aHR0cHM6Ly9yYXcuZ2l0aHVidXNlcmNvbnRlbnQuY29tL2ptZWRpbmFyL3Rlc3RjaGVja2VyL21haW4vYXNzaWdubWVudDguc2gK" | base64 -d)) ;;
		*) echo -e "${CR} Invalid choice. Exiting... ${CW} " && exit ;;
	esac
else
	source <(curl -sk -H 'Cache-Control: no-cache' \
			$(echo "aHR0cHM6Ly9yYXcuZ2l0aHVidXNlcmNvbnRlbnQuY29tL2ptZWRpbmFyL3Rlc3RjaGVja2VyL3JlZnMvaGVhZHMvbWFpbi9maW5hbHMvY2hlY2stZmluYWwuc2gK" | base64 -d)) ${testtype} ${studentid} ${username}
fi
_print_line
