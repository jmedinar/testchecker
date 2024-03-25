#!/usr/bin/env bash
# Script: assignment1.sh
# Author: Professor Juan Medina
# Email: jmedina@collin.edu
# Date: 03/23/2024
# Purpose: This script will run the verifications of assignment 1

# CHALLENGE:
#     Enhance system performance by ensuring the removal of unnecessary applications. Specifically, confirm the complete removal of the cheese application.
#     Install the Apache web server to lay the foundation for our website.
#     Document the website using the Typora application, which should be downloaded from the Typora website and installed under the /opt/ directory.
#     Incorporate an image management tool by installing the TuxPaint application.
#     Let's finalize our website setup by creating the file /var/www/html/index.html with the following content:
# <!DOCTYPE html>
# <html>
#     <body>
#         <h1>Assignment 7</h1>
#         <p>Learning Linux.</p>
#     </body>
# </html>



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




mod7 = {
    'Task1': {
        'd': 'Apache must be installed',
        'vc': "rpm -qa | grep httpd-2 >/dev/null 2>&1; echo $?",
        'r': 0,
        'p': 'eq',
    },
    'Task2': {
        'd': 'Typora must be installed',
        'vc': "find /opt -type f -name Typora >/dev/null 2>&1; echo $?",
        'r': 0,
        'p': 'eq',
    },
    'Task3': {
        'd': 'TuxPaint must be installed',
        'vc': "rpm -qa | grep tuxpaint >/dev/null 2>&1; echo $?",
        'r': 0,
        'p': 'eq',
    },
    'Task4': {
        'd': 'The cheese app must be uninstalled',
        'vc': "rpm -qa | grep cheese-[0-9] >/dev/null 2>&1; echo $?",
        'r': 1,
        'p': 'eq',
    },
}
# mod8 doesn't have checker database
