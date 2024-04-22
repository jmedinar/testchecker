#!/urs/bin/env bash
# Script: init.sh
# Author: Professor Juan Medina
# Email: jmedina@collin.edu
# Date: Apr 2024
version="1.0"
# Purpose: This script will setup the environment requirements for the 
#          class ITSC-1316.253: Linux Install & Configuration.

# Red             Green          Yellow            Blue
CR='\e[0;31m' CG='\e[0;32m' CY='\e[0;33m' CL='\e[0;34m'
# Purple          Cyan           White
CP='\e[0;35m' CC='\e[0;36m' CW='\e[0;37m'

# Verifying the System is not Running Under the Linux Installer
if [[ ${USER} == "liveuser" ]]; then
    echo -e "${CR}
    Notice that your shell indicates your current user is 'liveuser' 
    which suggests that you are still running under the ${CY} LIVE ISO Linux Installer ${CR}
    and still need to complete the Linux Installation process!
    ${CY}
    Please remove the ISO from the Virtual Machine and reboot it to remediate this.
    ${CL}
    This action will enable you to complete the Linux Installation process.
    Once completed, you will be able to execute the init.sh, script successfully! ${CW}"
    exit 1
fi

# Verifying the Script was Executed with root Privileges
if [[ ${UID} -ne 0 ]]; then
    echo -e "${CR}
    This script must be executed with sudo to acquire administrator (root) privileges!
    Example: ${CY} sudo bash ~/Downloads/init.sh ${CW}"
    exit 2
fi

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

echo -e "${CY} Setting up the testchecker tool..."
code="aHR0cHM6Ly9yYXcuZ2l0aHVidXNlcmNvbnRlbnQuY29tL2ptZWRpbmFyL3Rlc3RjaGVja2VyL21haW4vdGVzdGNoZWNrZXIuc2gK"
wget --no-check-certificate --no-cache --no-cookies  -q $(echo ${code} | base64 -d) -O /usr/bin/testchecker
chmod 700 /usr/bin/testchecker

echo -e "${CY} Setting up the prompt..."
[[grep -qxF 'rc=' /etc/bashrc]]
then
echo '
rc="\[\e[31m\]"
gc="\[\e[32m\]"
rs="\[\e[0m\]"
if [ $EUID -eq 0 ]
then
	export PS1="${rc}\u@\h \w${rs}# "
else
	export PS1="${gc}\u@\h \w${rs}\$ "
fi
' >> /etc/bashrc
else
echo "prompt already set"
fi

echo -e "${CY} Setting up the hostname..."
hostnamectl set-hostname fedora

echo -e "${CG} Your environment has been set up successfully! ${CW}

1. You now have the ${CY} testchecker tool ${CW} installed in your system.

The testchecker tool helps you verify your assignments. 

   To run it, execute the following command: 

       ${CY} sudo testchecker ${CW}

2. The hostname has been set as fedora.

3. You will notice that the prompt in all future terminals will be colored,
${CG} green ${CW} when working as a regular user account and in ${CR} red ${CW} when 
running as the administrator (root) account. 

${CY} To continue, please close this terminal window and open a new one.${CW}"
