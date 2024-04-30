#!/bin/bash
# Script: assignment5.sh
# Author: Professor Juan Medina
# Email: jmedina@collin.edu
# Date: 03/23/2024

# Red         Green         Yellow        Blue          Purple        Cyan          White
CR='\e[0;31m' CG='\e[0;32m' CY='\e[0;33m' CL='\e[0;34m' CP='\e[0;35m' CC='\e[0;36m' CW='\e[0;37m'
assignment=5
ca=0
tq=4
bdir="/sysadm/bin"
targets=(challenge1 challenge2 challenge3 challenge4 challenge5 challenge6 challenge7 challenge8 challenge9 \
homeChecker rabbitJumps testString processFile userValidator)

_print_line() {
    printf "${CC}%0.s=" {1..80}
    printf "${CW}\n"
}

_eval(){
    target=$1     arg=$2     ret=$3     r=false
    if ${bdir}/${target}.sh ${arg} 2>/dev/null | grep "${ret}" &>/dev/null
    then
        r=true
    fi
    printf "${CG}%-30s${CY}%-20s${CW}\n" ${bdir}/${target}.sh ${r}
}

_print_line
echo -e "${CP} Assignment ${assignment} Verification"
_print_line
printf "${CG}%-30s%-20s${CW}\n" SCRIPT RESULT
_print_line
for t in "${targets[@]}"
do
    case ${t} in
        challenge1)  _eval "${t}" "" "Hello, world!" ;;
        challenge2)  _eval "${t}" "" "Welcome to the Linux class!" ;;
        challenge3)  _eval "${t}" "" "Hello Alice, Welcome to Wonderland!" ;;
        challenge4)  _eval "${t}" "" "File /etc/linux_version not found" ;;
        challenge5)  _eval "${t}" "Learning Linux challenging it also fun very rewarding" "Learning Linux is challenging but it is also fun and very rewarding" ;;
        challenge6)  _eval "${t}" "" "Multiplication: 50" ;;
        challenge7)  _eval "${t}" "" "We are in the era of AI and agriculture is still more important in the year 2024!" ;;
        challenge8)  _eval "${t}" "" "/etc/passwd exists!" ;;
        challenge9)  _eval "${t}" "" ". Like in the Beatles song, Hello, Goodbye!" ;;
        homeChecker) _eval "${t}" "" "/home/goneuser" ;;
        processFile) _eval "${t}" "/etc/passwd"   "Method" ;;
        rabbitJumps) _eval "${t}" "" "The Rabbit made it!" ;;
        testString)  _eval "${t}" "1" "Binary or positive integer" ;;
        userValidator) _eval "${t}" "jmedina" "Valid user" ;;
        *) echo "Unknown" ;;
    esac
done
_print_line
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
