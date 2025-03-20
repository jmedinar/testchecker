#!/bin/bash

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

if ps -ef | grep stress-ng | grep run &>/dev/null
then
    echo "The process is already running and will continue for a max of three hours. Skipping..."
    exit 1
else
    procs=(cpu mem io)
    case ${procs[$((RANDOM % ${#procs[@]}))]} in
        cpu) /usr/bin/logger "stress-ng-cpu is now impacting your CPU - ${quotes[$((RANDOM % ${#quotes[@]}))]}" -p local3.error
             /usr/bin/stress-ng -q --timeout 3600 -c 1 --oom-avoid &>/dev/null & disown
             ;;
        mem) /usr/bin/logger "stress-ng-vm is now impacting your MEMORY - ${quotes[$((RANDOM % ${#quotes[@]}))]}" -p local3.error
             /usr/bin/stress-ng -q --timeout 3600 -m 1 --vm-bytes 32M &>/dev/null & disown
             ;;
         io) /usr/bin/logger "stress-ng-io is now impacting your IO - ${quotes[$((RANDOM % ${#quotes[@]}))]}" -p local3.error
             /usr/bin/stress-ng -q --timeout 3600 -i 1 &>/dev/null & disown
             ;;
         *) echo "unknown" ;;
    esac
fi
