#!/usr/bin/env bash
# Script: assignment1.sh
# Author: Professor Juan Medina
# Email: jmedina@collin.edu
# Date: 03/23/2024
# Purpose: This script will run the verifications of assignment 1

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

# CHALLENGE:
# Warning: Read carefully!
#     Create a group for each department.
#     Create a user for each employee following these rules:
#         The username should be the same as the one already assigned in the employee email without the domain.
#         Every employee must have their primary group set to the department to which they belong.
#         Every employee must have their email included in the Comment/GECOS Field.
#         Employees of the Direction Board should have all other departments as supplementary groups.
#         Employees in the Human Resources department should have Accounting as a supplementary group.
#     All usernames and groups should be in lowercase.


CB='\e[0;30m' # Black - Regular
CR='\e[0;31m' # Red
CG='\e[0;32m' # Green
CY='\e[0;33m' # Yellow
CL='\e[0;34m' # Blue
CP='\e[0;35m' # Purple
CC='\e[0;36m' # Cyan
CW='\e[0;37m' # White

TITLE="Assignment 1 Verification"
echo -e "$CP $TITLE $CW"

echo -e "$CY At least 2 GB of Memory $CW"
echo -e "$CY One Virtual Disk of at least 20 GB in size (Fixed size) $CW"
echo -e "$CY At least 1 CPU $CW"
echo -e "$CY Ensure the Virtual Machine can reach the Internet $CW"




mod4 = {
    'Task1': {
        'd': 'Verifying user: CHIN YEN',
        'vc': "id cyen 2>/dev/null | grep -E 'finances' >/dev/null 2>&1 && grep cyen /etc/passwd  | grep '@tuxquack.com' >/dev/null 2>&1; echo $?",
        'r': 0,
        'p': 'eq',
    },
    'Task2': {
        'd': 'Verifying user: MIKE PEARL',
        'vc': "id mpearl 2>/dev/null | grep -E 'finances' >/dev/null 2>&1 && grep mpearl /etc/passwd | grep '@tuxquack.com' >/dev/null 2>&1; echo $?",
        'r': 0,
        'p': 'eq',
    },
    'Task3': {
        'd': 'Verifying user: JOHN GREEN',
        'vc': "id jgreen 2>/dev/null | grep -E 'finances|it|direction|hr' >/dev/null 2>&1 && grep jgreen /etc/passwd | grep '@tuxquack.com' >/dev/null 2>&1; echo $?",
        'r': 0,
        'p': 'eq',
    },
    'Task4': {
        'd': 'Verifying user: DEWAYNE PAUL',
        'vc': "id dpaul 2>/dev/null | grep -E 'it' >/dev/null 2>&1 && grep dpaul /etc/passwd | grep '@tuxquack.com' >/dev/null 2>&1; echo $?",
        'r': 0,
        'p': 'eq',
    },
    'Task5': {
        'd': 'Verifying user: MATTS SMITH',
        'vc': "id msmith 2>/dev/null | grep -E 'it' >/dev/null 2>&1 && grep msmith /etc/passwd | grep '@tuxquack.com' >/dev/null 2>&1; echo $?",
        'r': 0,
        'p': 'eq',
    },
    'Task6': {
        'd': 'Verifying user: PLANK OTO',
        'vc': "id poto 2>/dev/null | grep -E 'it' >/dev/null 2>&1 && grep poto /etc/passwd | grep '@tuxquack.com' >/dev/null 2>&1; echo $?",
        'r': 0,
        'p': 'eq',
    },
    'Task7': {
        'd': 'Verifying user: MOHAMMED KHAN',
        'vc': "id mkhan 2>/dev/null | grep -E 'it' >/dev/null 2>&1 && grep mkhan /etc/passwd | grep '@tuxquack.com' >/dev/null 2>&1; echo $?",
        'r': 0,
        'p': 'eq',
    },
    'Task8': {
        'd': 'Verifying user: LAURA LOPEZ',
        'vc': "id llopez 2>/dev/null | grep -E 'finances|it|direction|hr' >/dev/null 2>&1 && grep llopez /etc/passwd | grep '@tuxquack.com' >/dev/null 2>&1; echo $?",
        'r': 0,
        'p': 'eq',
    },
    'Task9': {
        'd': 'Verifying user: JOSE ANGEL RAMIREZ',
        'vc': "id jramirez 2>/dev/null | grep -E 'it|finances' >/dev/null 2>&1 && grep jramirez /etc/passwd | grep '@tuxquack.com' >/dev/null 2>&1; echo $?",
        'r': 0,
        'p': 'eq',
    },
}
