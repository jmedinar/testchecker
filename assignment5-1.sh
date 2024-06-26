#!/usr/bin/env bash
# Script: assignment5.sh
# Author: Professor Juan Medina
# Email: jmedina@collin.edu
# Date: 03/23/2024

# Red           Green         Yellow        Blue          Purple        Cyan          White
CR='\e[0;31m' CG='\e[0;32m' CY='\e[0;33m' CL='\e[0;34m' CP='\e[0;35m' CC='\e[0;36m' CW='\e[0;37m'
assignment=5
ca=0
tq=4

_msg() {
   echo -ne "${CY} ${1}"
}

_pass() {
   echo -e "${CG} true ${CR}"
   ((ca++))
}

_fail() {
   echo -e "${CR} false ${CG}"
}

_eval() {
    if eval ${1} &>/dev/null; then _pass; else _fail; fi
}

_print_line() {
    printf "${CC}%0.s=" {1..80}
    printf "${CW}\n"
}

_print_line
echo -e "${CP} Assignment ${assignment} Verification"
_print_line

base_dir="/sysadm/bin"
targets=(processFile.sh rabbitJumps.sh testString.sh color.sh)

for t in "${targets[@]}"
do
    if [[ -f ${base_dir}/${t} ]]
    then
        if [[ -x ${base_dir}/${t} ]]
        then
            _msg "Verifying ${t}"
            case ${t} in
                processFile.sh)
                    if ${base_dir}/${t} /etc/passwd 2>/dev/null | grep "Method" &>/dev/null; then _pass; else _fail; fi
                    ;;
                rabbitJumps.sh)
                    if ${base_dir}/${t} 2>/dev/null | grep "SUCCESS!" &>/dev/null; then _pass; else _fail; fi
                    ;;
                testString.sh)
                    if ${base_dir}/${t} 1 2>/dev/null | grep "Binary or positive integer" &>/dev/null; then _pass; else _fail; fi
                    ;;
                color.sh)
                    if ${base_dir}/${t} 2>/dev/null | grep -i LOVE &>/dev/null
                    then
                        if grep "echo -e" ${base_dir}/${t} &>/dev/null \
                            || grep "printf" ${base_dir}/${t} &>/dev/null; then _pass; else _fail; fi
                    else
                        _fail
                    fi
                    ;;
                *) echo "Unknown"
                    ;;
            esac
        else
            echo -e "${CR} ${t} cannot be executed! ${CW}"
        fi
    else
        echo -e "${CR} ${base_dir}/${t} NOT FOUND! ${CW}"
    fi
done

printf "${CP} FINAL GRADE: ${CC} %.0f ${CW}" $(echo "(100/${tq})*${ca}" | bc -l)
echo ""

# CHALLENGE:
# Download the following scripts into the /sysadm/bin folder.
#       processFile.sh
#       rabbitJumps.sh
#       testString.sh
# Adjust the permissions of the scripts to ensure they are executable.
# Execute the scripts to test their functionality. Anticipate errors; identify and rectify any issues encountered!
# Craft a fourth script at the identical location as the preceding ones and label it color.sh. 
# The objective is for the script to display the string "I LOVE Linux!" with the word Linux highlighted in a color of your choosing!
