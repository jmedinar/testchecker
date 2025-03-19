#!/usr/bin/bash
#Author: Professor Juan Medina
#Email: jmedina@collin.edu
#Date: Mar 2025

#Red            Green           Yellow          Blue            Purple          Cyan            White
CR='\e[0;31m'   CG='\e[0;32m'   CY='\e[0;33m'   CL='\e[0;34m'   CP='\e[0;35m'   CC='\e[0;36m'   CW='\e[0;37m'
ca=0 # Correct Answers
tq=0 # Total Questions
version=$1
studentid=$2
username=$3

_print_line() {
    printf "${CC}%0.s=" {1..80}
    printf "${CW}\n"
}

_pass(){
    printf "${CY}Task ${1}: ${CG}PASS${CW}\n"
}

_fail(){
    printf "${CY}Task ${1}: ${CR}FAIL${CW}\n"
}

_midterm() {
    if id midterm_${username} &>/dev/null; then ((ca++)); _pass 1 ; else _fail 1; fi
    if [[ "$(userdbctl user midterm_${username} 2>/dev/null | grep Aux)" == *"wheel"* ]]; then ((ca++)); _pass 2; else _fail 2; fi
    if echo 'password123!' | pamtester login "midterm_${username}" authenticate &>/dev/null; then ((ca++)); _pass 3; else _fail 3; fi
    if [[ -d /tuxquack-reports-${studentid}/ ]]; then ((ca++)); _pass 4; else _fail 4; fi

    months='Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec'    r5=0
    for m in ${months}; do if [[ ! -d /tuxquack-reports-${studentid}/${m} ]]; then r5=1; fi; done
    if [[ $r5 -eq 0 ]]; then ((ca++)); _pass 5; else _fail 5; fi

    if [[ -e /tuxquack-reports-${studentid}/$(date +'%b')/system-report-${username}.ini ]]; then ((ca++)); _pass 6; else _fail 6; fi

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
        if [[ "${exp}" != "$(grep -w ^${l} /tuxquack-reports-${studentid}/$(date +'%b')/system-report-${username}.ini | awk '{print $NF}')" ]]; then r7=1; fi
    done
    if [[ $r7 -eq 0 ]]; then ((ca++)); _pass 7; else _fail 7; fi

    if [[ $(find /tuxquack-reports-${studentid} -not -perm 700 | wc -l) -eq 0 ]]; then ((ca++)); _pass 8; else _fail 8; fi

    r9=$(userdbctl user security-${username} | grep -E "Real|GID")
    if [[ "$(echo $r9)" == *"security auditor"* ]] && [[ "$(echo $r9)" == *"auditors"* ]]; then ((ca++)); _pass 9; else _fail 9; fi
    if echo 'P4ssw0rd!' | pamtester login "security-${username}" authenticate &>/dev/null; then ((ca++)); _pass 10; else _fail 10; fi
    if grep "security-${username}*.*NOPASSWD*.*" /etc/sudoers.d/security-${username} &>/dev/null; then ((ca++)); _pass 11; else _fail 11; fi
    tq=11
}

_final() {
    t=/home/${username}/performance-report-${username}.yml
    if [[ -e $t ]]
    then
        res=$(ps -ef | grep  stress-ng | grep run)
        if [[ "$(echo ${res} | awk '{print $3}')" != "$(grep PPID $t | awk '{print $NF}')" ]]; then ((ca++)); _pass 1; else _fail 1; fi
        if [[ "$(echo ${res} | awk '{print $(NF-1)}')" != "$(grep NAME $t | awk '{print $NF}')" ]]; then ((ca++)); _pass 2; else _fail 2; fi
        if [[ "$(echo ${res} | tr '[:lower:]' '[:upper:]' | awk '{print $(NF-1)}' | sed 's/-/ /g' | awk '{print $NF}')" != "$(grep RESOURCE $t | awk '{print $NF}')" ]]; then ((ca++)); _pass 3; else _fail 3; fi
        if [[ "$(lsof -p $(echo ${res} |  awk '{print $2}' 2>/dev/null | awk '{print $7,$9}' | sort -n | tail -1 | awk '{print $NF}'))" != "$(grep LARGEST_FILE $t | awk '{print $NF}')" ]]; then ((ca++)); _pass 4; else _fail 4; fi
        if [[ "$(journalctl --priority emerg --facility user --since "2 hours ago" --no-pager | tail -1 | cut -d: -f4-)" != "$(grep LOGGED_MESSAGE $t | cut -d: -f2-)" ]]; then ((ca++)); _pass 5; else _fail 5; fi
    else
        _fail 1
        _fail 2
        _fail 3
        _fail 4
        _fail 5
    fi
    if [[ ! -z "$(rpm -qa httpd)" ]]; then ((ca++)); _pass 6; else _fail 6; fi
    if [[ "active" == "$(systemctl is-active httpd)" ]] && [[ "enabled" == "$(systemctl is-enabled httpd)" ]]; then ((ca++)); _pass 7; else _fail 7; fi
    if [[ -e /var/www/html/performance-report-${username}.yml ]]; then ((ca++)); _pass 8; else _fail 8; fi
    if [[ "apache:apache" == "$(stat -c '%U:%U' /var/www/html/performance-report-${username}.yml)" ]]; then ((ca++)); _pass 9; else _fail 9; fi
    if [[ "200 OK" == "$(curl -I http://localhost/performance-report-${username}.yml | grep 200 | awk '{print $(NF-1),$NF}')" ]]; then ((ca++)); _pass 10; else _fail 10; fi
    tq=10
}

# clear
_print_line
# figlet "${version} Exam" | lolcat

case ${version} in
    "midterm") _midterm ;;
    "final") _final ;;
esac

grade=$(printf "%.0f" $(echo "100 / $tq * $ca" | bc -l))
# figlet "Grade: ${grade}" | lolcat
printf "${CC}Final Grade: ${CY}${grade}${CW}\n\n"
