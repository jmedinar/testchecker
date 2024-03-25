#!/usr/bin/env bash
# Script: assignment4.sh
# Author: Professor Juan Medina
# Email: jmedina@collin.edu
# Date: 03/23/2024

# Black           # Red             # Green         # Yellow
CB='\e[0;30m';    CR='\e[0;31m';    CG='\e[0;32m';  CY='\e[0;33m';
# Blue            # Purple          # Cyan          # White
CL='\e[0;34m';    CP='\e[0;35m';    CC='\e[0;36m';  CW='\e[0;37m'; 

version=4
correct_answers=0
total_questions=0

_msg() {
   echo -ne "$CY $1"
   ((total_questions++))
}

_pass() {
   echo -e "$CG PASS $CR"
   ((correct_answers++))
}

_fail() {
   echo -e "$CR FAIL $CG"
}

echo -e "$CC ===================================================="
echo -e "$CP Assignment ${version} Verification $CW"
echo -e "$CC ===================================================="

_user() {
    _msg "Verifying user: $1"
    if [[ $(id $1 2>/dev/null | grep -E $2 &>/dev/null && grep $1@wedbit.com /etc/passwd &>/dev/null; echo $?) -eq 0 ]]; then _pass; else _fail; fi
}

_user cyen 'accounting'
_user mpearl 'accounting'
_user jgreen 'accounting|technology|directionboard|humanresources'
_user dpaul 'technology'
_user msmith 'technology'
_user poto 'technology'
_user mkhan 'technology'
_user llopez 'accounting|technology|directionboard|humanresources'
_user jramirez 'technology|accounting'

(( final_grade = (100 / ${total_questions}) * ${correct_answers} ))
echo -e "$CP FINAL GRADE: $CC ${final_grade} $CW"
echo ""

# CHALLENGE:
#
# Employee Name 	      Position 	         Department 	      Email
# CHIN YEN              Accountant           Accounting        cyen@wedbit.com
# MIKE PEARL            Senior Accountant    Accounting        mpearl@wedbit.com
# JOHN GREEN            CEO                  Direction Board   jgreen@wedbit.com
# DEWAYNE PAUL          Programmer           Technology        dpaul@wedbit.com
# MATT SMITH            Sr. Programmer       Technology        msmith@wedbit.com
# PLANK OTO             Network Support      Technology        poto@wedbit.com
# MOHAMMED KHAN         Desk Support         Technology        mkhan@wedbit.com
# LAURA LOPEZ           Project Manager      Direction Board   llopez@wedbit.com
# JOSE ANGEL RAMIREZ    Human Resources      Human Resources   jramirez@wedbit.com
#
#     Create a group for each department.
#     Create a user for each employee following these rules:
#         The username should be the same as the one already assigned in the employee email without the domain.
#         Every employee must have their primary group set to the department to which they belong.
#         Every employee must have their email included in the Comment/GECOS Field.
#         Employees of the Direction Board should have all other departments as supplementary groups.
#         Employees in the Human Resources department should have Accounting as a supplementary group.
#     All usernames and groups should be in lowercase.
