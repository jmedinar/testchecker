#!/bin/bash
# -----------------------------------------------------------------------------
# Challenge Name:   challenge6.sh
# Student Task:     Fix errors related to arithmetic operations in Bash.
# Description:      Bash provides several ways to perform mathematical calculations.
#                   This script attempts basic arithmetic (addition, subtraction,
#                   multiplication, division) using two predefined variables,
#                   but contains syntax errors in how these operations are performed
#                   and how their results are captured and displayed.
# Script Purpose:   This script defines two numbers and aims to calculate and print
#                   their sum, difference, product, and quotient.
# -----------------------------------------------------------------------------
# Problem:          The script fails to produce the correct arithmetic results or
#                   generates errors because:
#                   1. Incorrect syntax is used for command substitution and arithmetic
#                      expansion (e.g., `$($NUM1 + $NUM2)`, `$($(($NUM1 x $NUM2)))`).
#                   2. Incorrect operators are used (e.g., `x` for multiplication, `%` for division
#                      instead of quotient). Note: `%` is the *modulo* operator.
#                   3. Variables are not correctly expanded within arithmetic contexts
#                      or within the final `echo` statements (e.g., `echo "..." ((...))`
#                      and `echo "... DIV"`).
#
# Your Task:        Identify and correct the syntax errors in each arithmetic
#                   operation line (ADD, SUB, MUL, DIV).
#                   1. Use the standard Bash arithmetic expansion syntax `$((...))`
#                      for all calculations.
#                   2. Use the correct arithmetic operators (`+`, `-`, `*`, `/`) inside
#                      the arithmetic expansion.
#                   3. Ensure the results are correctly assigned to the variables (ADD, MUL, DIV).
#                   4. Fix the `echo` statements for Subtraction and Division to correctly
#                      perform the calculation (or print the calculated variable) rather
#                      than printing literal strings.
#
# Expected Output:  When executed correctly the script should print exactly:
#
#                   Addition: 15
#                   Subtraction: 5
#                   Multiplication: 50
#                   Division: 2
#
# Hints:
#                   * The primary method for arithmetic in modern Bash is `$((expression))`.
#                     Variables inside `$((...))` usually don't need a preceding `$`.
#                   * What are the standard symbols for addition, subtraction,
#                     multiplication, and division in most programming contexts?
#                   * How do you capture the result of `$((...))` into a variable?
#                     (e.g., `RESULT=$((NUM1 / NUM2))`)
#                   * How do you print the *value* of a variable using `echo`?
#                     (e.g., `echo "Result: $RESULT"`)
#                   * Can you perform the calculation directly within the echo statement
#                     if needed? (e.g., `echo "Result: $((NUM1 - NUM2))"`)
# -----------------------------------------------------------------------------

# --- Script Code ---

NUM1=10
NUM2=5

ADD=$($NUM1 + $NUM2)
echo "Addition: $ADD"
echo "Subtraction: ((NUM1 - NUM2))"
MUL=$($(($NUM1 x $NUM2)))
echo "Multiplication: $MUL"
DIV=$(($NUM1 % $NUM2))
echo "Division: DIV" 

# --- End of Script ---
