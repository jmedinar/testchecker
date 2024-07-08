#!/usr/bin/env bash
# Script: assignment6.sh
# Author: Professor Juan Medina
# Email: jmedina@collin.edu
# Date: 03/23/2024

# Red           Green         Yellow        Blue          Purple        Cyan          White
CR='\e[0;31m' CG='\e[0;32m' CY='\e[0;33m' CL='\e[0;34m' CP='\e[0;35m' CC='\e[0;36m' CW='\e[0;37m'
assignment=6    tq=0    ca=0
quotes=(
    "Bugs Bunny - What's up, doc?"
    "Homer Simpson - D'oh!"
    "Bart Simpson - Eat my shorts!"
    "Mickey Mouse - Oh boy!"
    "Daffy Duck - You're despicable!"
    "Yogi Bear - Smarter than the average bear."
    "Winnie the Pooh - Oh bother."
    "Dora the Explorer - Come on, vamonos!"
    "Optimus Prime - Autobots, roll out!"
    "Pink Panther - It's not easy being pink."
    "Bender - Bite my shiny metal ass!"
    "Porky Pig - Th-th-th-that's all, folks!"
    "Scooby-Doo - Scooby-Dooby-Doo, where are you?"
    "He-Man - I have the power!"
)

_print_line() {
    printf "${CC}%0.s=" {1..80}
    printf "${CW}\n"
}

_print_line
echo -e "${CP} Assignment ${assignment} Verification"
_print_line

process=$(ps -ef | grep  stress-ng | grep run | awk '{print $3}')
name=$(ps -ef | grep  stress-ng | grep run | awk '{print $8}')
type=$(journalctl --since="3 hours ago" --priority=err --user -n 1 | awk -F ':' '{print $(NF-1)}' | awk '{print $NF}')
funny=$(journalctl --since="3 hours ago" --priority=err --user -n 1 | awk -F ':' '{print $NF}' | sed 's/^ //')

echo "From the process causing performance issues:"

read -p "   1. Identify the PID: " _pid
((tq++))
if [[ "${_pid}" == "${process}" ]]
then
    _pid=true
    ((ca++))
else
    _pid=false
fi



read -p "   2. Identify the name: " _name
((tq++))
if [[ "${_name}" == "${name}" ]]
then
    _name=true
    ((ca++))
else
    _name=false
fi



read -p "   3. Determine which resource (CPU, MEMORY, or IO) is being impacted: " _resource
((tq++))
if [[ "${_resource^^}" == "${type}" ]]
then
    _resource=true
    ((ca++))
else
    _resource=false
fi



read -p "   4. Identify the name of the largest file open by the process: " _file
((tq++))
if [[ "/usr/bin/stress-ng" == *"${_file}"* ]]
then
    _file=true
    ((ca++))
else
    _file=false
fi



echo "   5. Identify the message logged by the process from the following list:"
pos=0
for q in "${quotes[@]}"
do
    echo "      [${pos}] ${q}"
    ((pos+=1))
done
read -p "       Choose a number: " _selection
((tq++))
if [[ "${quotes[${_selection}]}" == "${funny}" ]]
then
    _selection=true
    ((ca++))
else
    _selection=false
fi

_print_line
printf "${CG}%-10s%-10s%-10s%-10s%-10s${CW}\n" Q1 Q2 Q3 Q4 Q5
printf "${CG}%-10s%-10s%-10s%-10s%-10s${CW}\n" $_pid $_name $_resource $_file $_selection
_print_line
printf "${CP} FINAL GRADE: ${CC} %.0f ${CW}" $(echo "(100/${tq})*${ca}" | bc -l)
echo ""
