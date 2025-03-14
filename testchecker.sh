#!/usr/bin/env bash
# Script: testChecker.sh
title="TestChecker"
# Author: Professor Juan Medina
# Email: jmedina@collin.edu
# Date: 03/23/2024
version="3.0.1"
# Purpose: This script will gater VM and Student information
#          and will execute the interactive test verification scripts

# Red         Green         Yellow        Blue  		Purple        Cyan          White
CR='\e[0;31m' CG='\e[0;32m' CY='\e[0;33m' CL='\e[0;34m' CP='\e[0;35m' CC='\e[0;36m' CW='\e[0;37m'
sname=$(who am i | awk '{print $1}')
sid=0

_run_as_root() {
	# Verifying the Script was Executed with root Privileges
	if [[ ${UID} -ne 0 ]]; then
		echo -e "${CR}
		This script must be executed with sudo to acquire administrator (root) privileges!
		Example: ${CY} sudo testchecker ${CW}"
		exit 2
	fi
}

_no_vboxuser() {
	# Verify the student is not running as vboxuser
	if [[ ${USER} == "vboxuser" ]]; then
        echo -e "${CR}
        You are currently running as the 'vboxuser' user, which is not allowed!. ${CW}"
		exit 2
	fi
}

_internet_connection() {
	# Verifying Internet Connection
	if [[ $( wget -q --spider http://google.com; echo $?) -ne 0 ]]; then
		echo -e "${CR} Your Virtual Machine is currently not connected to the internet!
		${CY}
		Connect it by clicking on the icons at the top right corner of Linux 
		and ensuring the Wi-Fi is enabled. 
		${CL}
		Once corrected, rerun this script. ${CW}"
		exit 3
	fi
}

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

_run_as_root
_no_vboxuser
_internet_connection
_update

clear
echo ""
_print_line
echo -e "${CY}                        C O L L I N   C O L L E G E "
echo -e "${CY}                        ${title} Version: ${version} "
_print_line
echo -e "${CG} DATE: ${CY} $(date) ${CG} STUDENT: ${CY} ${sname} ${CW}"
read -p " Introduce your student numeric ID: " sid
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
_print_line
