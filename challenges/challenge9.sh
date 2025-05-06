#!/bin/bash
# -----------------------------------------------------------------------------
# Challenge Name:   challenge9.sh
# Student Task:     Fix errors related to function definition, function calls,
#                   global variables, and command substitution within functions.
# Description:      Functions allow you to group commands for reuse. Scripts can
#                   define functions and then call them. Functions can access and
#                   modify global variables. Command substitution `$(...)` can be
#                   used inside functions or when calling them. This script defines
#                   several functions to print messages but has errors in how one
#                   function calls others and constructs its output.
# Script Purpose:   This script defines functions to get a name (hardcoded here),
#                   print greetings, and print a final message combining text and
#                   the output of other functions.
# -----------------------------------------------------------------------------
# Problem:          The script does not produce the exact expected output,
#                   specifically the last line. The issues are primarily in the
#                   `beatles` function:
#                   1. It attempts to call both `hello` and `goodbye` using command
#                      substitution `$(...)`, but the expected output only requires
#                      the output of `goodbye`.
#                   2. The literal word "hello" is included before the command
#                      substitution for `goodbye`, which doesn't match the expected
#                      output structure.
#                   3. The commented-out `read` command in `get_name` suggests an
#                      alternative way to get the name, but the current implementation
#                      hardcodes it to "student", which matches the expected output's use.
#                      (This part isn't strictly an error *for the expected output*, but
#                      worth noting).
#
# Your Task:        Modify *only* the `beatles` function.
#                   1. Adjust the `echo` command inside the `beatles` function so that
#                      it correctly constructs the final sentence.
#                   2. Ensure it correctly calls the `goodbye` function using command
#                      substitution `$(...)` to embed its output ("Goodbye student!")
#                      at the right place in the sentence.
#                   3. Remove the incorrect call to the `hello` function and the literal
#                      word "hello" if they are not needed for the expected output.
#
# Expected Output:  When executed correctly (e.g., ./challenge9.sh), the
#                   script should print *exactly*:
#                   Hello student!
#                   Goodbye student!
#                   Hey! student. Like in the Beatles song, Hello, Goodbye!
#
# Hints:
#                   * Functions are called by simply using their name (e.g., `hello`).
#                   * To capture the *output* of a function (what it echoes) and use it
#                     within another command, you use command substitution: `$(function_name)`.
#                   * Carefully compare the structure of the `echo` command inside the
#                     `beatles` function with the last line of the "Expected Output".
#                   * Does the last line of the expected output contain the output of the
#                     `hello` function? Does it contain the literal word "hello"?
#
# Testing:          After making the required modification to the `beatles` function,
#                   make the script executable (`chmod +x challenge9.sh`) and run it
#                   (`./challenge9.sh`). Verify the output matches the "Expected Output"
#                   above exactly.
# -----------------------------------------------------------------------------

# --- Script Code (Contains Errors) ---

# Global variable accessible by functions
name=""

# Function to set the global 'name' variable
get_name(){
    name="student"
    # This function doesn't print anything itself, it just sets the variable.
}

# Function to print a hello message
hello() {
    echo "Hello ${name}!"
}

# Function to print a goodbye message
goodbye() {
    echo "Goodbye ${name}!"
}

# Function intended to print the final complex message
beatles() {
    # Problem Area: This echo command incorrectly includes "hello" literally
    #               and tries to embed the output of goodbye() incorrectly.
    #               It should produce: "Hey! student. Like in the Beatles song, Hello, Goodbye!"
    #               The "Hello, Goodbye!" part comes from the song title reference,
    #               not necessarily from calling the hello() and goodbye() functions here.
    #               The expected output implies only the *reference* to the song title.
    #               Let's assume the goal IS to embed the output of goodbye() based on the original code attempt.
    echo -n "Hey! ${name}. Like in the Beatles song, hello $(goodbye)" # Incorrect structure and call
    echo "" # Prints a newline separately
}

# --- Script Execution Flow ---

# Call functions in sequence
get_name # Sets the name variable
hello    # Prints the hello message
goodbye  # Prints the goodbye message
beatles  # Attempts to print the final message (needs fixing)

# --- End of Script ---
