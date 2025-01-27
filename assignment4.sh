#!/usr/bin/env bash
# Script: assignment4.sh
# Author: Professor Juan Medina
# Email: jmedina@collin.edu
# Date: 03/23/2024

# Red           Green         Yellow        Blue          Purple        Cyan          White
CR='\e[0;31m' CG='\e[0;32m' CY='\e[0;33m' CL='\e[0;34m' CP='\e[0;35m' CC='\e[0;36m' CW='\e[0;37m'
assignment=4
ca=0
tq=36 # Total number of user times verified items (9*4=36)

_print_line() {
    printf "${CC}%0.s=" {1..80}
    printf "${CW}\n"
}

_user() {
	exist="false" 	primary="false" 	auxiliar="false" 	gecos="false"

   # Check if the user exists
	if id ${1} &>/dev/null
   then 
      exist="true"
      ((ca++))

      # Primary group verification
      if [[ "$(id -gn ${1} 2>/dev/null)" == "${2}" ]]; then ((ca++)); primary="true"; fi

      # gecos field verification
      if grep "${1}@wedbit.com" /etc/passwd &>/dev/null; then ((ca++)); gecos="true"; fi

      # auxiliar groups verification
      case ${2} in
         "accounting" | "technology") # Only requires the primary group, so Aux must be empty
            if [[ "$(userdbctl user ${1} 2>/dev/null | grep Aux)" == "" ]]; then ((ca++)); auxiliar="true"; fi ;;
         "humanresources") # Requires accounting
            for g in $(id -nG ${1} 2>/dev/null); do
               if [[ ${g} != "humanresources" ]]; then
                  if [[ ${g} == "accounting" ]]; then ((ca++)); auxiliar="true"; fi
               fi
            done ;;
         "directionboard") # Requires the three other groups
            count=0
            for g in $(id -nG ${1} 2>/dev/null); do
               if [[ ${g} != "directionboard" ]]; then
                  if [[ ${g} == "technology" ]]; then ((count++))
                  elif [[ ${g} == "humanresources" ]]; then ((count++))
                  elif [[ ${g} == "accounting" ]]; then ((count++)); fi
               fi
            done
            if [[ ${count} -eq 3 ]]; then ((ca++)); auxiliar="true"; fi ;;
         *) echo "Unknown" ;;
      esac
   fi
	printf "${CY}%-10s%-8s%-15s%-18s%-10s${CW}\n" ${1} ${exist} ${primary} ${auxiliar} ${gecos}
}

_print_line
echo -e "${CP} Assignment ${assignment} Verification"
_print_line
printf "${CG}%-10s%-8s%-15s%-18s%-10s${CW}\n" USER EXIST PRIMARY_GROUP AUXILIARY_GROUP GECOS_COMMENT
_print_line
_user cyen accounting
_user mpearl accounting
_user jgreen directionboard
_user dpaul technology
_user msmith technology
_user poto technology
_user mkhan technology
_user llopez directionboard
_user jramirez humanresources
_print_line

grade="$(echo "(100/${tq})*${ca}" | bc -l)"
printf "${CP} FINAL GRADE: ${CC} %.0f ${CW}" ${grade}
echo ""
target="aHR0cHM6Ly9yYXcuZ2l0aHVidXNlcmNvbnRlbnQuY29tL2ptZWRpbmFyL3Rlc3RjaGVja2VyL21haW4vZW5jb2Rlci5zaAo="
source <(curl -sk -H 'Cache-Control: no-cache' $(echo ${target} | base64 -d)) ${grade} ${assignment}
