#!/usr/bin/environment bash/korn
#
# Challenge name:        processFile.sh
# Description:           Using correct script formatting rules for shell scripts,
#                        identify and fix any issues in the provided script to
#                        ensure that it produces the expected results.
# Script Purpose:        This script will test three different methods for parsing
#                        a file, a file must be given as the first argument.
#
# Expected Output:       Hello, world!
#
# Testing:               After making the required modifications, execute the script
#                        and verify that it behaves as expected.
#

InFile=${1}
OutFile=tempfile.out

# Color Variables
CB='\e[0;30m' # Black - Regular
CR='\e[0;31m' # Red
CG='\e[0;32m' # Green
CY='\e[0;33m' # Yellow
CL='\e[0;34m' # Blue
CP='\e[0;35m' # Purple
CC='\e[0;36m' # Cyan
CW='\e[0;37m' # White

function method1(){
    echo -e "${CG} Method 1: Using cat to print the file while reading line by line ${CY}"
    cat ${InFile} | while read LINE
    do
        echo "${LINE}" >> ${OutFile}
        :
    done
}

function method2(){
    echo -e "${CG} Method 2: Directly reading the line in a while ${CY}"
    while read LINE
    do
        echo "${LINE}" >> ${OutFile}
        :
    done < ${InFile}
}

function method3(){
    echo -e "${CG} Method 3: Using a for to loop the lines of a file printed using cat ${CY}"
    for LINE in $(cat ${InFile})
    do
        echo "${LINE}" >> ${OutFile}
    done
}

# Main 

# Looking for exactly one parameter
if (( $# != 1 ))
then 
    echo -e "${CR} A target file is required as parameter ${CW}"
    exit 1
fi

# Does the file exist as a regular file?
if [[ ! -f 1 ]]
then 
    echo -e "${CR} $1 file doesn't exist ${CW}"
    exit 2
fi

methods=(method1 method2 method3)
for method in ${methods[@]}
do
    # Zero out the $OutFile
    >${OutFile}
    time $method
    echo -e "${CW}"
done

rm -rf ${OutFile}

# EOF
