#!/usr/bin/env bash
# Script: mod6-init.sh
# Author: Juan Medina
# Date: Apr 2024
# Description: Setup challenge for module six - downloads and runs the performance stress script.

# --- Configuration ---
PERF_SCRIPT_URL="https://raw.githubusercontent.com/jmedinar/testchecker/main/performance/perf-challenge1.sh"

# Color Codes
CR='\e[0;31m' # Red
CG='\e[0;32m' # Green
CY='\e[0;33m' # Yellow
CW='\e[0;37m' # White (reset)

# --- Pre-flight Checks ---

# 1. Check for root privileges
if [[ ${UID} -ne 0 ]]; then
    echo -e "${CR}Error: This script must be executed with sudo.${CW}" >&2
    exit 1
fi

# 2. Check for internet connectivity (using curl)
if ! curl -sI --fail --connect-timeout 5 http://google.com > /dev/null; then
    echo -e "${CR}Error: Internet connection check failed. Please ensure connectivity.${CW}" >&2
    exit 2
fi

# --- Execution ---

# Use process substitution to source the script directly from curl output.
# curl flags: -s (silent), --fail (error on HTTP failure), -L (follow redirects)
# If curl fails (e.g., 404), --fail causes curl to exit non-zero, and set -e stops the script.
source <(curl -s --fail -L -H 'Cache-Control: no-cache' "${PERF_SCRIPT_URL}")

echo -e "${CG}Performance challenge script initiated.${CW}"
echo -e "${CY}Use performance tools (ps, top, htop), lsof, and journalctl to investigate.${CW}"

exit 0
