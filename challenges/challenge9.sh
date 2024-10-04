#!/bin/bash
#
# Challenge name:        challenge9.sh
# Description:           Using what you have learned about functions in shell scripts,
#                        identify and fix any issues in the provided script to
#                        ensure that it produces the expected results.
# Script Purpose:        This script will make use of functions to generate strings
#                        in direct and indirect ways while modifying the value of
#                        a global variable
#
# Expected Output:       What's your name: <name>
#                        Hello student.!
#                        Goodbye student!
#                        Hey! student. Like the Beatles song, Hello, Goodbye!
#
# Testing:               After making the required modifications, execute the script
#                        and verify that it behaves as expected.
# 

name=""
get_name(){
    #read -p "What's your name: " name
    name="student"
}

hello() {
    echo "Hello ${name}!"
}

goodbye() {
    echo "Goodbye ${name}!"
}

beatles() {
    echo -n "Hey! ${name}. Like in the Beatles song, hello $(goodbye)"
    echo ""
}

get_name
hello
beatles
