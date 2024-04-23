#!/bin/bash
#
# Challenge 9:
#
# Using what you have learned about functions in shell scripts, 
# identify and fix any issues in the provided script 
# to ensure that it produces the expected results.
#
# Expected Output:
# What's your name: <name>
# Hello <name>!
# Goodbye <name>!
# Like the beatles song, Hello ! Goodbye !
# 
# After making the required modifications, execute the script 
# and verify that it behaves as expected.

name=""
get_name(){
    read -p "What's your name: " name
}

hello() {
    echo "Hello ${name}!"
}

goodbye() {
    echo "Goodbye ${name}!"
}

beatles() {
    echo -n "Like in the Beatles song, hello $(goodbye)"
    echo ""
}

get_name
hello
beatles
