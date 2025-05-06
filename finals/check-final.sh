#!/usr/bin/bash
# Author: Professor Juan Medina
# Email: jmedina@collin.edu
# Date: Mar 2025
# Description: Verification script for Midterm and Final exams.

# Exit immediately if a command exits with a non-zero status.
set -e
# Treat unset variables as an error when substituting.
set -u
# Cause pipelines to return the exit status of the last command that failed.
set -o pipefail

# --- Script Arguments ---

if [[ "$#" -ne 3 ]]; then
    echo "Error: This script requires 3 arguments: <version> <student_id> <username>" >&2
    exit 1
fi

readonly version="${1}"
readonly student_id="${2}"
readonly realuser="${3}"

# --- Configuration ---

correct_answers=0 # Counter for correct answers
total_questions=0 # Counter for total questions checked (will be set per exam)

# Color Codes
CR='\e[0;31m' # Red
CG='\e[0;32m' # Green
CY='\e[0;33m' # Yellow
CL='\e[0;34m' # Blue
CP='\e[0;35m' # Purple
CC='\e[0;36m' # Cyan
CW='\e[0;37m' # White (reset)

ENCODER_SCRIPT_URL="https://raw.githubusercontent.com/jmedinar/testchecker/main/encoder.sh"

# --- Helper Functions ---

function _print_line() {
    printf "${CC}%0.s==${CW}" {1..40} # Prints 80 '=' characters
    printf "\n"
}

function _pass(){
    # $1: Task number/ID
    printf "\t${CY}Task %-3s: ${CG}PASS${CW}\n" "${1}"
}

function _fail(){
    # $1: Task number/ID
    # $2 (Optional): Reason for failure
    local reason="${2:-}"
    printf "\t${CY}Task %-3s: ${CR}FAIL${CW}" "${1}"
    if [[ -n "${reason}" ]]; then
        printf " ${CR}(%s)${CW}" "${reason}"
    fi
    printf "\n"
}

# --- Dependency Check Function ---

function _check_dependencies() {
    local missing_deps=0
    # Add all commands used by both midterm and final checks
    local deps=("id" "userdbctl" "pamtester" "find" "grep" "nproc" "groupmems" "awk" "sed" "date" "hostname" \
                "ps" "journalctl" "stat" "curl" "rpm" "systemctl" "bc")
    echo -e "${CY}Checking for required command dependencies...${CW}"
    for cmd in "${deps[@]}"; do
        if ! command -v "$cmd" &> /dev/null; then
            echo -e "\t${CR}Error: Required command '$cmd' not found.${CW}" >&2
            missing_deps=1
        fi
    done
    if [[ ${missing_deps} -eq 1 ]]; then
        echo -e "${CR}Please install missing dependencies before proceeding.${CW}" >&2
        exit 1
    fi
    echo -e "${CG}All dependencies found.${CW}"
}

# --- Midterm Verification Function ---

function _midterm() {
    echo -e "${CL}--- Verifying Midterm Exam Tasks for ${realuser} (ID: ${student_id}) ---${CW}"
    local midterm_user="midterm_${realuser}"
    local security_user="security_${realuser}"
    local report_dir="/tuxquack-reports-${student_id}"
    local current_month_short=$(date +'%b')
    local report_file_path="${report_dir}/${current_month_short}/system-report-${realuser}.ini"

    # Task 1: Create midterm_user
    ((total_questions++))
    if id "${midterm_user}" &>/dev/null; then ((correct_answers++)); _pass "1 (User ${midterm_user} created)"; else _fail "1 (User ${midterm_user} not found)"; fi

    # Task 2: Add midterm_user to 'wheel' group
    ((total_questions++))
    if id -nG "${midterm_user}" 2>/dev/null | grep -qw 'wheel'; then ((correct_answers++)); _pass "2 (User ${midterm_user} in wheel)"; else _fail "2 (User ${midterm_user} not in wheel)"; fi

    # Task 3: Set password for midterm_user
    ((total_questions++))
    if echo 'password123!' | pamtester login "${midterm_user}" authenticate &>/dev/null; then ((correct_answers++)); _pass "3 (Password for ${midterm_user})"; else _fail "3 (Password for ${midterm_user} incorrect/not set)"; fi

    # Task 4: Create report directory
    ((total_questions++))
    if [[ -d "${report_dir}" ]]; then ((correct_answers++)); _pass "4 (Directory ${report_dir} created)"; else _fail "4 (Directory ${report_dir} not found)"; fi

    # Task 5: Create month subdirectories
    ((total_questions++))
    local months_ok=true
    local months_arr=('Jan' 'Feb' 'Mar' 'Apr' 'May' 'Jun' 'Jul' 'Aug' 'Sep' 'Oct' 'Nov' 'Dec')
    if [[ -d "${report_dir}" ]]; then # Only check if parent dir exists
        for m_short in "${months_arr[@]}"; do
            if [[ ! -d "${report_dir}/${m_short}" ]]; then
                months_ok=false
                _fail "5 (Month dir ${m_short} missing)"; # Fail early for specific month
                break
            fi
        done
        if [[ "$months_ok" == true ]]; then ((correct_answers++)); _pass "5 (All month directories created)"; fi
    else
        _fail "5 (Cannot check month dirs, parent ${report_dir} missing)"
    fi

    # Task 6: Create system-report.ini
    ((total_questions++))
    if [[ -f "${report_file_path}" ]]; then
        ((correct_answers++)); _pass "6 (Report file created)"

        # Task 7: Populate system-report.ini (Only if file exists)
        ((total_questions++))
        local report_content_ok=true
        local labels=("HOSTNAME" "TOTAL_CPUS" "LOGIN_USERS" "NO_LOGIN_USERS" "WHEEL_USERS")
        for label in "${labels[@]}"; do
            local expected_value=""
            case "${label}" in
                "HOSTNAME") expected_value=$(hostname -f) ;; # Use FQDN for consistency
                "TOTAL_CPUS") expected_value=$(nproc) ;;
                "LOGIN_USERS") expected_value=$(getent passwd | awk -F: '$NF !~ /nologin|false$/ {count++} END {print count}') ;;
                "NO_LOGIN_USERS") expected_value=$(getent passwd | awk -F: '$NF ~ /nologin|false$/ {count++} END {print count}') ;;
                "WHEEL_USERS") expected_value=$(getent group wheel | cut -d: -f4 | tr ',' '\n' | wc -l) ;; # Counts members in wheel
            esac
            local actual_value
            actual_value=$(grep -w "^${label}:" "${report_file_path}" 2>/dev/null | awk -F': ' '{print $2}' | tr -d '[:space:]') # Trim whitespace
            if [[ "${actual_value}" != "${expected_value}" ]]; then
                report_content_ok=false
                _fail "7 (${label}=${actual_value}, Exp=${expected_value})"; # Fail early for specific label
                break
            fi
        done
        if [[ "$report_content_ok" == true ]]; then ((correct_answers++)); _pass "7 (Report content correct)"; fi
    else
        _fail "6 (Report file ${report_file_path} not found)"
        _fail "7 (Cannot check report content)" # Auto-fail task 7 if 6 fails
        ((total_questions++)) # Still count task 7 as attempted
    fi

    # Task 8: Set permissions for report directory
    ((total_questions++))
    if [[ -d "${report_dir}" ]]; then # Only check if dir exists
        # Find any file or directory within report_dir that does NOT have 700 (owner rwx) permissions
        if [[ $(find "${report_dir}" -not -perm 700 2>/dev/null | wc -l) -eq 0 ]]; then
            ((correct_answers++)); _pass "8 (Permissions 700 for ${report_dir} content)"
        else
            _fail "8 (Incorrect permissions in ${report_dir})"
        fi
    else
         _fail "8 (Cannot check permissions, ${report_dir} missing)"
    fi

    # Task 9: Create security_user with GECOS and group
    ((total_questions++))
    local security_user_gecos=""
    local security_user_groups=""
    if id "${security_user}" &>/dev/null; then
        security_user_gecos=$(getent passwd "${security_user}" | cut -d: -f5)
        security_user_groups=$(id -nG "${security_user}" 2>/dev/null)
    fi
    if [[ "${security_user_gecos}" == "Security Auditor" ]] && echo "${security_user_groups}" | grep -qw 'auditors'; then
        ((correct_answers++)); _pass "9 (User ${security_user} created with GECOS/group)"
    else
        _fail "9 (User ${security_user} GECOS/group incorrect or user not found)"
    fi

    # Task 10: Set password for security_user
    ((total_questions++))
    if echo 'P4ssw0rd!' | pamtester login "${security_user}" authenticate &>/dev/null; then ((correct_answers++)); _pass "10 (Password for ${security_user})"; else _fail "10 (Password for ${security_user} incorrect/not set)"; fi

    # Task 11: Grant sudo access to security_user
    ((total_questions++))
    local sudoers_file="/etc/sudoers.d/${security_user}"
    if [[ -f "${sudoers_file}" ]] && grep -qE "^${security_user}\s+ALL=\(ALL\)\s+NOPASSWD:ALL" "${sudoers_file}"; then
        ((correct_answers++)); _pass "11 (Sudo access for ${security_user})"
    else
        _fail "11 (Sudo access for ${security_user} incorrect or file missing)"
    fi
}

# --- Final Exam Verification Function ---

function _final() {
    echo -e "${CL}--- Verifying Final Exam Tasks for ${realuser} ---${CW}"
    local report_file_path="/home/${realuser}/performance-report-${realuser}.yml"
    local web_report_path="/var/www/html/performance-report-${realuser}.yml"

    # --- Check 1-5: Report Content ---
    if [[ ! -f "${report_file_path}" ]]; then
        _fail "1-5" "(Report file ${report_file_path} not found)"
        ((total_questions+=5)) # Count all 5 report-related tasks
    else
        # Task 1: PPID of stress-ng
        ((total_questions++))
        local stress_pid stress_ppid stress_name
        stress_pid=$(pgrep -x stress-ng)
        if [[ -n "${stress_pid}" ]]; then
            stress_ppid=$(ps -o ppid= -p "${stress_pid}" | awk '{print $1}')
            local reported_ppid=$(grep -w "PPID:" "${report_file_path}" | awk '{print $NF}')
            if [[ "${reported_ppid}" == "${stress_ppid}" ]]; then ((correct_answers++)); _pass "1 (PPID)"; else _fail "1 (PPID mismatch. Rep: ${reported_ppid}, Act: ${stress_ppid})"; fi
        else
             _fail "1 (stress-ng not running for PPID check)"
        fi

        # Task 2: Resource Impacted (CPU, as stressor is -c 1)
        ((total_questions++))
        local reported_resource=$(grep -w "RESOURCE_IMPACTED:" "${report_file_path}" | awk '{print $NF}')
        # The main_exam_script always starts a CPU stressor (-c 1)
        if [[ "${reported_resource^^}" == "CPU" ]]; then
            ((correct_answers++)); _pass "2 (Resource Impacted CPU)"
        else
            _fail "2 (Resource Impacted. Rep: ${reported_resource}, Exp: CPU)"
        fi

        # Task 3: Largest Open File (should be /usr/bin/stress-ng)
        ((total_questions++))
        local reported_largest_file=$(grep -w "LARGEST_OPEN_FILE:" "${report_file_path}" | awk '{print $NF}')
        if [[ "${reported_largest_file}" == "/usr/bin/stress-ng" ]]; then
            ((correct_answers++)); _pass "3 (Largest Open File)"
        else
            _fail "3 (Largest Open File. Rep: ${reported_largest_file}, Exp: /usr/bin/stress-ng)"
        fi

        # Task 4: Logged Message
        ((total_questions++))
        local actual_log_msg
        # The main_exam_script logs with tag FINAL-EXAM-STRESS and emerg priority
        actual_log_msg=$(journalctl -t "FINAL-EXAM-STRESS" -p emerg --since="3 hours ago" --no-pager -o cat | tail -n 1 | sed 's/.*FINAL-EXAM-STRESS\[[0-9]*\]: //')
        local reported_log_msg=$(grep "LOGGED_MESSAGE:" "${report_file_path}" | cut -d':' -f2- | sed 's/^[[:space:]]*//;s/[[:space:]]*$//') # Trim whitespace

        if [[ -n "${actual_log_msg}" && "${reported_log_msg}" == "${actual_log_msg}" ]]; then
            ((correct_answers++)); _pass "4 (Logged Message)"
        else
            _fail "4 (Logged Message mismatch or not found. Rep: '${reported_log_msg}', Act: '${actual_log_msg}')"
        fi
        
        # Task 5: PID and Name in report (PID was already checked for PPID)
        ((total_questions++))
        if [[ -n "${stress_pid}" ]]; then
            stress_name=$(ps -o comm= -p "${stress_pid}")
            local reported_pid=$(grep -w "PID:" "${report_file_path}" | awk '{print $NF}')
            local reported_name=$(grep -w "NAME:" "${report_file_path}" | awk '{print $NF}')
            if [[ "${reported_pid}" == "${stress_pid}" && "${reported_name}" == "${stress_name}" ]]; then
                ((correct_answers++)); _pass "5 (PID & Name in report)"
            else
                _fail "5 (PID/Name mismatch. Rep PID: ${reported_pid}, Act PID: ${stress_pid}. Rep Name: ${reported_name}, Act Name: ${stress_name})"
            fi
        else
             _fail "5 (stress-ng not running for PID/Name check)"
        fi
    fi

    # Task 6: Apache (httpd) installed
    ((total_questions++))
    if rpm -q httpd &>/dev/null; then ((correct_answers++)); _pass "6 (httpd installed)"; else _fail "6 (httpd not installed)"; fi

    # Task 7: httpd service enabled and active
    ((total_questions++))
    local active_status="unknown" enabled_status="unknown"
    if command -v systemctl &>/dev/null; then # Check if systemctl is available
        active_status=$(systemctl is-active httpd 2>/dev/null || echo "inactive")
        enabled_status=$(systemctl is-enabled httpd 2>/dev/null || echo "disabled")
    fi
    if [[ "${active_status}" == "active" ]] && [[ "${enabled_status}" == "enabled" ]]; then
        ((correct_answers++)); _pass "7 (httpd enabled and active)"
    else
        _fail "7 (httpd not active/enabled. Act: ${active_status}, En: ${enabled_status})"
    fi

    # Task 8: Report copied to /var/www/html/
    ((total_questions++))
    if [[ -f "${web_report_path}" ]]; then ((correct_answers++)); _pass "8 (Report copied to web root)"; else _fail "8 (Report not found in web root)"; fi

    # Task 9: Report ownership in web root
    ((total_questions++))
    local web_report_owner_group=""
    if [[ -f "${web_report_path}" ]]; then
        web_report_owner_group=$(stat -c '%U:%G' "${web_report_path}" 2>/dev/null || echo "error")
    fi
    if [[ "${web_report_owner_group}" == "apache:apache" ]]; then
        ((correct_answers++)); _pass "9 (Web report ownership correct)"
    else
        _fail "9 (Web report ownership incorrect: ${web_report_owner_group}, Exp: apache:apache)"
    fi

    # Task 10: Report accessible via HTTP
    ((total_questions++))
    if curl -s -I "http://localhost/$(basename "${web_report_path}")" | grep -q "HTTP/1.1 200 OK"; then
        ((correct_answers++)); _pass "10 (Report accessible via HTTP)"
    else
        _fail "10 (Report not accessible via HTTP or wrong status code)"
    fi
}

# --- Main Execution ---

_check_dependencies # Run dependency check first

_print_line
printf "${CL}Grading ${version} exam for ${realuser} (ID: ${student_id})...${CW}\n"
sleep 3
case "${version}" in
    "midterm")
        _midterm
        ;;
    "final")
        _final
        ;;
    *)
        echo -e "${CR}Error: Invalid exam version specified: '${version}'. Expected 'midterm' or 'final'.${CW}" >&2
        exit 1
        ;;
esac
_print_line

# --- Grade Calculation & Reporting ---

final_grade=0

if [[ ${total_questions} -gt 0 ]]; then
    final_grade=$(printf "%.0f" "$(echo "scale=2; (100 / ${total_questions}) * ${correct_answers}" | bc -l)")
else
    echo -e "${CR}Warning: Total questions is zero. Grade cannot be calculated.${CW}"
fi

printf "${CP}Final Grade: ${CY}%s%%${CW} (%d/%d tasks correct)\n" "${final_grade}" "${correct_answers}" "${total_questions}"
_print_line
source <(curl -s --fail -L -H 'Cache-Control: no-cache' "${ENCODER_SCRIPT_URL}") "${final_grade}" "${version}" "${realuser}"

exit 0
