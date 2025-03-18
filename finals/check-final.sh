#!/usr/bin/bash
#Author: Professor Juan Medina
#Email: jmedina@collin.edu
#Date: Mar 2025

#Red            Green           Yellow          Blue            Purple          Cyan            White
CR='\e[0;31m'   CG='\e[0;32m'   CY='\e[0;33m'   CL='\e[0;34m'   CP='\e[0;35m'   CC='\e[0;36m'   CW='\e[0;37m'
ca=0 # Correct Answers
tq=0 # Total Questions
version=$1
username=$(who am i | awk '{print $1}')
student_id=$2

_print_line() {
    printf "${CC}%0.s=" {1..80}
    printf "${CW}\n"
}

_midterm() {
    if id midterm_${username} &>/dev/null; then echo "Task 1: PASS"; else echo "Task 1: FAIL"; fi
    if [[ "$(userdbctl user midterm_${username} | grep Aux)" == *"wheel"* ]]; then echo "Task 2: PASS"; else echo "Task 2: FAIL"; fi
    if echo 'password123!' | su - midterm_${username} &>/dev/null; then echo "Task 3: PASS"; else echo "Task 3: FAIL"; fi
    if [[ -d /tuxquack-reports-${student_id}/ ]]; then echo "Task 4: PASS"; else echo "Task 4: FAIL"; fi

    months='Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec'    r5=0
    for m in ${months}; do if [[ ! -d /tuxquack-reports-${student_id}/${m} ]]; then r5=1; fi; done
    if [[ $r5 -eq 0 ]]; then echo "Task 5: PASS"; else echo "Task 5: FAIL"; fi

    if [[ -e /tuxquack-reports-${student_id}/$(date +'%b')/system-report-${username}.ini ]]; then echo "Task 6: PASS"; else echo "Task 6: FAIL"; fi

    labels="HOSTNAME TOTAL_CPUS LOGIN_USERS NO_LOGIN_USERS WHEEL_USERS"  r7=0
    for l in ${labels}
    do
        case ${l} in
            "HOSTNAME") exp=$(hostname) ;;
            "TOTAL_CPUS") exp=$(nproc) ;;
            "LOGIN_USERS") exp=$(grep -wE 'bash|sh' /etc/passwd | wc -l) ;; 
            "NO_LOGIN_USERS") exp=$(grep -wE 'nologin' /etc/passwd | wc -l) ;; 
            "WHEEL_USERS") exp=$(groupmems -g wheel -l | wc -w) ;;
        esac
        if [[ "${exp}" != "$(grep ${l} /tuxquack-reports-${student_id}/$(date +'%b')/system-report-${username}.ini | awk '{print $NF}')" ]]; then r7=1; fi
    done
    if [[ $r7 -eq 0 ]]; then echo "Task 7: PASS"; else echo "Task 7: FAIL"; fi

    if [[ $(find /tuxquack-reports-${student_id} -not -perm 700 | wc -l) -eq 0 ]]; then echo "Task 8: PASS"; else echo "Task 8: FAIL"; fi

    r9=$(userdbctl user security-${username} | grep -E "Real|GID")
    if [[ "$(echo $r9)" == *"security auditor"* ]] && [[ "$(echo $r9)" == *"auditors"* ]]; then echo "Task 9: PASS"; else echo "Task 9: FAIL"; fi
    if echo 'P4ssw0rd!' | su - security-${username} &>/dev/null; then echo "Task 10: PASS"; else echo "Task 10: FAIL"; fi
    if grep "security-${username}*.*NOPASSWD*.*" /etc/sudoers.d/security-${username} &>/dev/null; then echo "Task 11: PASS"; else echo "Task 11: FAIL"; fi
}

_final() {
    t=/home/${username}/performance-report-${username}.yml
    if [[ -e $t ]]
    then
        res=$(ps -ef | grep  stress-ng | grep run)
        if [[ "$(echo ${res} | awk '{print $3}')" != "$(grep PPID $t | awk '{print $NF}')" ]]; then echo "Task 1: PASS"; else echo "Task 1: FAIL"; fi
        if [[ "$(echo ${res} | awk '{print $(NF-1)}')" != "$(grep NAME $t | awk '{print $NF}')" ]]; then echo "Task 2: PASS"; else echo "Task 2: FAIL"; fi
        if [[ "$(echo ${res} | tr '[:lower:]' '[:upper:]' | awk '{print $(NF-1)}' | sed 's/-/ /g' | awk '{print $NF}')" != "$(grep RESOURCE $t | awk '{print $NF}')" ]]; then echo "Task 3: PASS"; else echo "Task 3: FAIL"; fi
        if [[ "$(lsof -p $(echo ${res} |  awk '{print $2}' 2>/dev/null | awk '{print $7,$9}' | sort -n | tail -1 | awk '{print $NF}'))" != "$(grep LARGEST_FILE $t | awk '{print $NF}')" ]]; then echo "Task 4: PASS"; else echo "Task 4: FAIL"; fi
        if [[ "$(journalctl --priority emerg --facility user --since "2 hours ago" --no-pager | tail -1 | cut -d: -f4-)" != "$(grep LOGGED_MESSAGE $t | cut -d: -f2-)" ]]; then echo "Task 5: PASS"; else echo "Task 5: FAIL"; fi
    else
        echo -e "Task 1: FAIL\nTask 2: FAIL\nTask 3: FAIL\nTask 4: FAIL\nTask 5: FAIL"
    fi
    if [[ ! -z "$(rpm -qa httpd)" ]]; then echo "Task 6: PASS"; else echo "Task 6: FAIL"; fi
    if [[ "active" == "$(systemctl is-active httpd)" ]] && [[ "enabled" == "$(systemctl is-enabled httpd)" ]]; then echo "Task 7: PASS"; else echo "Task 7: FAIL"; fi
    if [[ -e /var/www/html/performance-report-${username}.yml ]]; then echo "Task 8: PASS"; else echo "Task 8: FAIL"; fi
    if [[ "apache:apache" == "$(stat -c '%U:%U' /var/www/html/performance-report-${username}.yml)" ]]; then echo "Task 9: PASS"; else echo "Task 9: FAIL"; fi
    if [[ "200 OK" == "$(curl -I http://localhost/performance-report-${username}.yml | grep 200 | awk '{print $(NF-1),$NF}')" ]]; then echo "Task 10: PASS"; else echo "Task 10: FAIL"; fi
}

clear
_print_line
figlet "Linux ${version} Exam" | lolcat

case ${version} in
    "midterm") _midterm ;;
    "final") _final ;;
esac

_print_line
((grade = 100 / tq * ca )) &>/dev/null
figlet "Final Grade: ${grade}" | lolcat
echo ""
