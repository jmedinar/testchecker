#!/usr/bin/env bash
# Script: assignment7.sh
# Author: Professor Juan Medina
# Email: jmedina@collin.edu
# Date: 03/23/2024

# Black           # Red             # Green         # Yellow
CB='\e[0;30m';    CR='\e[0;31m';    CG='\e[0;32m';  CY='\e[0;33m';
# Blue            # Purple          # Cyan          # White
CL='\e[0;34m';    CP='\e[0;35m';    CC='\e[0;36m';  CW='\e[0;37m'; 

version=7
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

_msg "The cheese application has been successfully uninstalled"
if [[ $(rpm -qa | grep cheese-[[:digit:]] &>/dev/null; echo $?) -ne 0 ]]; then _pass; else _fail; fi

_msg "Apache(httpd) must be installed"
if [[ $(rpm -qa | grep ^httpd-[[:digit:]] &>/dev/null; echo $?) -eq 0 ]]; then _pass; else _fail; fi

_msg "Typora must be installed at the /opt directory"
if [[ $(ls /opt/bin/T*/Typora &>/dev/null; echo $?) -eq 0 ]]; then _pass; else _fail; fi

_msg "The TuxPaint application must be installed"
if [[ $(rpm -qa | grep tuxpaint &>/dev/null; echo $?) -eq 0 ]]; then _pass; else _fail; fi

_msg "The requested website was created"
if [[ $(grep -E "Assignment 7|Learning Linux" /var/www/html/index.html &>/dev/null; echo $?) -eq 0 ]]; then _pass; else _fail; fi

printf "$CP FINAL GRADE: $CC %.0f $CW" $(echo "(100/$total_questions)*$correct_answers" | bc -l)
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
