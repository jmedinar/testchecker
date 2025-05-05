#!/usr/bin/env bash
# Script: perf-challenge1.sh
# Author: Professor Juan Medina
# Email: jmedina@collin.edu
# Date: Mar 2024

# --- Configuration ---
STRESS_DURATION_SECONDS=3600 # 1 hour
MEMORY_STRESS_BYTES="256M"   # Amount of memory for the memory stressor
LOG_FACILITY="user.error" # Syslog facility for logger

# Check if stress-ng is installed, install if necessary (Fedora only)
if ! command -v stress-ng &>/dev/null; then
    if command -v dnf &>/dev/null; then
        dnf install -y -q stress-ng &>/dev/null
    else
        echo "no stress binary found!"
        exit 1
    fi
fi

# --- Quotes for Logging ---

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
    exit 0
else
    # Define the types of stress tests
    procs=(cpu mem io)
    # Select a random stress type
    selected_proc=${procs[$((RANDOM % ${#procs[@]}))]}
    # Select a random quote
    random_quote=${quotes[$((RANDOM % ${#quotes[@]}))]}

    case $selected_proc in
        cpu)
            /usr/bin/logger -p ${LOG_FACILITY} "stress-ng is now impacting your CPU, ${random_quote}"
            /usr/bin/stress-ng --quiet --timeout "${STRESS_DURATION_SECONDS}s" --cpu 1 --oom-avoid & disown
            ;;
        mem)
            /usr/bin/logger -p ${LOG_FACILITY} "stress-ng is now impacting your MEMORY, ${random_quote}"
            /usr/bin/stress-ng --quiet --timeout "${STRESS_DURATION_SECONDS}s" --vm 1 --vm-bytes "$MEMORY_STRESS_BYTES" & disown
            ;;
         io)
            /usr/bin/logger -p ${LOG_FACILITY} "stress-ng is now impacting your IO, ${random_quote}"
            /usr/bin/stress-ng --quiet --timeout "${STRESS_DURATION_SECONDS}s" --io 1 & disown
            ;;
    esac

    sleep 2

fi

exit 0
