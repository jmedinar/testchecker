#!/bin/bash
#
# Challenge 6:
#
# Using what you have learned about math in shell scripts, 
# identify and fix any issues in the provided script 
# to ensure that it produces the expected results.
#
# Expected Output:
# Addition: 15
# Subraction: 5
# Division: 2
# Multiplication: 50
# 
# After making the required modifications, execute the script 
# and verify that it behaves as expected.

NUM1=10
NUM2=5

ADD=$($NUM1 + $NUM2)
echo "Addition: $ADD"
echo "Subraction: ((NUM1 - NUM2))"
MUL=$($(($NUM1 x $NUM2)))
echo "Multiplication: $MUL"
DIV=$(($NUM1 % $NUM2))
echo "Division: DIV"
