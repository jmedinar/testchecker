#!/usr/bin/env bash
# Script: assignment7.sh
# Author: Professor Juan Medina
# Email: jmedina@collin.edu
# Date: 03/23/2024

# Red           Green         Yellow        Blue          Purple        Cyan          White
CR='\e[0;31m' CG='\e[0;32m' CY='\e[0;33m' CL='\e[0;34m' CP='\e[0;35m' CC='\e[0;36m' CW='\e[0;37m'
assignment=7
ca=0
tq=5

_print_line() {
    printf "${CC}%0.s=" {1..80}
    printf "${CW}\n"
}

_print_line
echo -e "${CP} Assignment ${assignment} Verification"
_print_line

printf "${CG}%-10s%-10s%-10s%-10s%-10s\n" Cheese Apache Typora TuxPaint Website
cheese="false" apache="false" typora="false" tuxpaint="false" website="false"
if ! rpm -qa | grep "cheese-[[:digit:]]" &>/dev/null; then cheese="true"; ((ca++)); fi
if rpm -qa | grep "^httpd-[[:digit:]]" &>/dev/null; then apache="true"; ((ca++)); fi
if ls /opt/bin/T*/Typora &>/dev/null; then typora="true"; ((ca++)); fi
if rpm -qa | grep "tuxpaint" &>/dev/null; then tuxpaint="true"; ((ca++)); fi
if grep -E "Assignment 7|Learning Linux" /var/www/html/index.html &>/dev/null; then website="true"; ((ca++)); fi
printf "${CY}%-10s%-10s%-10s%-10s%-10s\n" ${cheese} ${apache} ${typora} ${tuxpaint} ${website}
printf "${CP} FINAL GRADE: ${CC} %.0f ${CW}" "$(echo "(100/${tq})*${ca}" | bc -l)"
echo ""

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
#
