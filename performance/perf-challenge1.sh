#!/bin/bash

# Ensure stress-ng is present
if ! command -v stress-ng -V &>/dev/null; then sudo dnf install -yqq stress-ng &>/dev/null; fi

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

_log(){
    logger "${1} is now impacting your ${2} : ${quotes[$((RANDOM % ${#quotes[@]}))]}" -p local3.error
}
    
# If the process is running in the background don't start it again.
if ps -ef | grep stress-ng | grep -v grep &>/dev/null
then
    echo "The process is already running until the completion of three hours. Skipping..."
    exit 1
else
    procs=(cpu mem io)
    case ${procs[$((RANDOM % ${#procs[@]}))]} in
        cpu) _log "stress-ng-cpu" "CPU";   (stress-ng --quiet --timeout 3600 --cpu 1 &) ;;
        mem) _log "stress-ng-vm" "MEMORY"; (stress-ng --quiet --timeout 3600 --vm 1 --vm-bytes 512M &) ;;
         io) _log "stress-ng-aiol" "IO";  (stress-ng --quiet --timeout 3600 --aiol 1 &) ;;
         *) echo "unknown" ;;
    esac
fi

##TODO: Verifications
# 1. Identify the PID of the process causing performance issues
# 2. Which is the largest file of the process causing performance issues
# 3. Find the funny message in logs
# 4. Find the name of the process causing performance issues
# 5. What is being impacted by the process causing performance issues
