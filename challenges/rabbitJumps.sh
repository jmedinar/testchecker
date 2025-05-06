#!/usr/bin/env bash
# -----------------------------------------------------------------------------
# Challenge Name:   rabbitJumps.sh
# Student Task:     Fix errors related to shebang, variable assignment, function
#                   syntax, arithmetic operations, and command execution within a loop.
# Description:      This script simulates a rabbit hopping along a numbered path.
#                   The rabbit starts at position 0 and tries to reach position 10.
#                   Each "turn" consists of jumping forward 2 steps and then
#                   backward 1 step. The script attempts to visualize this by
#                   replacing the number at the rabbit's position with an 'X'.
#                   It contains multiple syntax and logical errors.
# Script Purpose:   To simulate the rabbit's movement and print the state of the
#                   path after each forward and backward jump until the rabbit
#                   reaches the finish line (position 10).
# -----------------------------------------------------------------------------
# Problem:          The script fails to execute correctly or produces incorrect
#                   output due to several issues:
#                   1. Shebang: The script starts with `#!/usr/bin/env bash` which is correct,
#                      but the initial variable assignment syntax on the next line is incorrect.
#                   2. Variable Assignment: The line `finish=10 pos=0` is not the standard
#                      way to assign multiple variables in Bash. While it might work in
#                      some contexts (like prefixing a command), it's not reliable for
#                      general assignment. Variables should typically be assigned on
#                      separate lines or using specific Bash constructs if needed on one line.
#                   3. Function Definition: The `_jump_backwards` function definition
#                      is missing the `function` keyword or the `()` syntax required
#                      for defining functions in Bash.
#                   4. Arithmetic Syntax: The forward jump `(( pos + = 2 ))` has incorrect
#                      spacing around the `+=` operator. Bash arithmetic requires specific syntax.
#                   5. `sed` Command Error: The `sed` command used inside the loop to show the
#                      backward jump is missing the actual `sed` command keyword before the
#                      expression `-e "s/--$pos--/--X--/g"`.
#                   6. Loop Logic/Output: The expected output shows the state *after* the forward
#                      jump and *after* the backward jump in each iteration. The current loop
#                      structure needs to correctly implement this sequence.
#
# Your Task:        Identify and correct the syntax and logical errors:
#                   1. Fix the initial variable assignment for `finish` and `pos`.
#                   2. Correct the function definition syntax for `_jump_backwards`.
#                   3. Fix the arithmetic syntax in the `_jump_forward` function.
#                   4. Add the missing `sed` command keyword in the loop for the backward jump visualization.
#                   5. Ensure the loop correctly calls the jump functions and prints the field state
#                      using `sed` after each jump (forward and backward) until the finish line is reached.
#
# Expected Output:  When executed correctly (e.g., ./rabbitJumps.sh), the script should print
#                   a sequence of lines showing the rabbit's position ('X') moving forward
#                   and backward, eventually reaching position 10, followed by the final message.
#                   (See the detailed multi-line expected output in the original description).
#                   The final line should be:
#                   The Rabbit made it!
#
# Hints:
#                   * How do you typically assign multiple variables in Bash (usually separate lines)?
#                   * What are the two standard ways to define a function in Bash? (`function name { ... }` or `name() { ... }`)
#                   * Review Bash arithmetic syntax: `$((...))` or `((...))`. Check spacing rules for operators like `+=`, `-=`.
#                   * The `sed` command needs to be explicitly called: `sed -e '...'`.
#                   * Ensure the loop structure correctly reflects the "jump forward, print, jump back, print" sequence.
#
# Testing:          After making the required modifications, make the script executable
#                   (`chmod +x rabbitJumps.sh`) and run it (`./rabbitJumps.sh`).
#                   Verify the output matches the multi-line "Expected Output" sequence exactly.
# -----------------------------------------------------------------------------

# --- Script Code ---

finish=10
pos=0
field="START --0--1--2--3--4--5--6--7--8--9--10-- FINISH"

function _jump_forward() {
    (( pos + = 2 ))
}

_jump_backwards() {
    ((pos-=1))
}

# Print initial state
echo ${field}

# Loop until the rabbit reaches the finish line
while [[ ${pos} -ne ${finish} ]]
do
    # Visualize position after forward jump
    echo "${field}" | sed -e "s/--$pos--/--X--/g
    _jump_forward

    # Visualize position after backward jump
    echo ${field}" | sed -e "s/--$pos--/--X--/g"
    _jump_backwards
done

echo "The Rabbit made it!"

# --- End of Script ---
