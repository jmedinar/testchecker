#!/bin/bash
# Author: Juan Medina
# Date: Mar 2025
# Description: Setup Linux Class student account (user-specific only).
#              System-wide image prep is done separately via class-image-setup.yml.

# Cause pipelines to return the exit status of the last command that failed.
set -o pipefail

# --- Configuration ---
CURRENT_PLAYBOOK="class-setup-v2.yml"
PLAYBOOK_URL="https://raw.githubusercontent.com/jmedinar/testchecker/refs/heads/main/${CURRENT_PLAYBOOK}"
BOOTSTRAP_USERS="setup setupaccount liveuser vboxuser"
# --- End Configuration ---

# === Pre-flight Checks ===

# 1. Check for root privileges
if [[ ${UID} -ne 0 ]]; then
    echo "Error: This script must be executed with sudo." >&2
    exit 1
fi

# 2. Must know the invoking user
if [[ -z "${SUDO_USER}" ]]; then
    echo "Error: Could not determine the original user. Run this with sudo from your student account." >&2
    exit 1
fi

# 3. Reject bootstrap / reserved accounts
for reserved in ${BOOTSTRAP_USERS}; do
    if [[ "${SUDO_USER}" == "${reserved}" ]]; then
        echo "Error: Do not run account setup as '${SUDO_USER}'." >&2
        echo "Create your own user, log in as that user, then run: sudo init.sh" >&2
        exit 1
    fi
done

# 4. Check if running in a live environment
if id "liveuser" &>/dev/null || [ -f /etc/live-release ] || [[ "$(findmnt -n -o FSTYPE /)" =~ (squashfs|overlay) ]]; then
    echo "Error: This script should not be run as the 'liveuser' or from the live ISO environment." >&2
    echo "Please complete the Fedora installation and log in as a regular user before running this script." >&2
    exit 1
fi

# 5. Check if running on Fedora
if ! grep -q '^ID=fedora$' /etc/os-release || [ ! -f /etc/fedora-release ] || ! command -v dnf &>/dev/null; then
    echo "Error: This script is designed to run on Fedora Linux only." >&2
    echo "Please run this script on a Fedora Linux System." >&2
    exit 1
fi

# 6. Check for internet connectivity
if [[ $(wget -q --spider http://google.com; echo $?) -ne 0 ]]; then
    echo "Internet connection required"
    exit 2
fi

# === Setup ===

# 7. Ensure ansible is available (normally installed by class-image-setup.yml)
echo "Preflight configuration..."
if ! command -v ansible-playbook &>/dev/null; then
    dnf install -yq ansible
fi
if ! command -v figlet &>/dev/null || ! command -v lolcat &>/dev/null; then
    dnf install -yq figlet lolcat
fi

# 8. Prepare visuals
clear
echo "Starting Linux student account setup..."
sleep 3
figlet "Account Setup" | lolcat

# 9. Download the playbook to a temporary file
TEMP_PLAYBOOK=$(mktemp /tmp/class-setup.XXXXXX.yml)
if ! curl -fL --connect-timeout 15 --max-time 60 -o "$TEMP_PLAYBOOK" "$PLAYBOOK_URL"; then
    echo "Error: Failed to download playbook from $PLAYBOOK_URL" >&2
    exit 3
fi

# === Execution ===

ansible-playbook "$TEMP_PLAYBOOK"
PLAYBOOK_RC=$?
rm -f "$TEMP_PLAYBOOK"

if [[ ${PLAYBOOK_RC} -ne 0 ]]; then
    echo "Error: Account setup playbook failed (exit ${PLAYBOOK_RC})." >&2
    exit "${PLAYBOOK_RC}"
fi

# === Completion ===

figlet "Setup completed!" | lolcat
echo "The system will automatically reboot in 20 seconds..."
echo "      press Ctrl+c if you need to cancel the reboot process"
sleep 20
echo "Rebooting now!"
reboot
