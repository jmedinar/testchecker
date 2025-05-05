#!/bin/bash

# Cause pipelines to return the exit status of the last command that failed.
set -o pipefail

# --- Configuration ---
STRESS_DURATION_SECONDS=3600 # 1 hour
MEMORY_STRESS_BYTES="256M"   # Amount of memory for the memory stressor
LOG_FACILITY="user.notice" # Syslog facility for logger
# --- End Configuration ---

if ! command -v stress-ng -V &>/dev/null; then sudo dnf install -yq stress-ng &>/dev/null; else echo "no stress binary found!"; exit 1; fi

quotes=( 
    "Bugs Bunny - What's up, doc?"
    "Homer Simpson - D'oh!"
    "Bart Simpson - Eat my shorts!"
    "Mickey Mouse - Oh boy!"
    "Daffy Duck - You're despicable!"
    "Yogi Bear - Smarter than the average bear."
    "Winnie the Pooh - Oh bother."
    "Dora the Explorer - Come on, vamonos!"
    "Optimus Prime - Autobots, roll out!"
    "Pink Panther - It's not easy being pink."
    "Bender - Bite my shiny metal ass!"
    "Porky Pig - Th-th-th-that's all, folks!"
    "Scooby-Doo - Scooby-Dooby-Doo, where are you?"
    "He-Man - I have the power!"
)

# Check if stress-ng is already running using pgrep for exact match
if pgrep -x "stress-ng" > /dev/null; then
    echo "A 'stress-ng' process is already running. Skipping..."
    echo "Use performance tools (top, htop, vmstat, iostat), lsof, and journalctl to investigate."
    exit 0 # Exit successfully, as the goal state (a running process) is met
else
    # Define the types of stress tests
    procs=(cpu mem io)
    # Select a random stress type
    selected_proc=${procs[$((RANDOM % ${#procs[@]}))]}
    # Select a random quote
    random_quote=${quotes[$((RANDOM % ${#quotes[@]}))]}

    case $selected_proc in
        cpu)
            /usr/bin/logger -p "$LOG_FACILITY" "STRESS-TEST-SCRIPT: stress-ng-cpu is now impacting your CPU - ${random_quote}"
            /usr/bin/stress-ng --quiet --timeout "${STRESS_DURATION_SECONDS}s" --cpu 1 --oom-avoid & disown
            ;;
        mem)
            /usr/bin/logger -p "$LOG_FACILITY" "STRESS-TEST-SCRIPT: stress-ng-vm is now impacting your MEMORY - ${random_quote}"
            /usr/bin/stress-ng --quiet --timeout "${STRESS_DURATION_SECONDS}s" --vm 1 --vm-bytes "$MEMORY_STRESS_BYTES" & disown
            ;;
         io)
            /usr/bin/logger -p "$LOG_FACILITY" "STRESS-TEST-SCRIPT: stress-ng-io is now impacting your IO - ${random_quote}"
            /usr/bin/stress-ng --quiet --timeout "${STRESS_DURATION_SECONDS}s" --io 1 & disown
            ;;
         *)
            echo "Error: Unknown stress type selected. This should not happen." >&2
            exit 2
            ;;
    esac

    sleep 2

    # Final confirmation check (silent)
    if ! pgrep -x "stress-ng" > /dev/null; then
        # Log error if it failed to start, but don't echo to user
        /usr/bin/logger -p user.error "STRESS-TEST-SCRIPT: 'stress-ng' process failed to start or exited immediately."
        exit 3
    fi

fi

exit 0