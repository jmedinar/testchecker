#!/usr/bin/env bash
#
# Challenge name:        rabbitJumps.sh
# Description:           Using correct script formatting rules for shell scripts,
#                        identify and fix any issues in the provided script to
#                        ensure that it produces the expected results.
# Script Purpose:        To simulate a rabbit jumping 10 times with a pattern of moving two steps 
#                        forward and one step backward each time.
#
# Expected Output:       Hello, world!
#
# Testing:               After making the required modifications, execute the script
#                        and verify that it behaves as expected.
#
start=0 finish=10 pos=0
field="START --0--1--2--3--4--5--6--7--8--9--10-- FINISH"

function _jump_forward(){
    (( pos + = 2 ))
}

_jump_backwards(){
    ((pos-=1))
}

echo ${field}
while ${start} < ${finish}
do
    echo "${field}" | sed -e "s/--$pos--/--X--/g"
    _jump_forward

    echo "${field}" | sed -e "s/--$pos--/--X--/g
    _jump_backwards
done
echo "The Rabbit made it!"
