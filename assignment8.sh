#!/usr/bin/env bash
# Script: assignment8.sh
# Author: Professor Juan Medina
# Email: jmedina@collin.edu
# Date: 03/23/2024
# Purpose: This script will run the verifications of assignment 1

CB='\e[0;30m' # Black - Regular
CR='\e[0;31m' # Red
CG='\e[0;32m' # Green
CY='\e[0;33m' # Yellow
CL='\e[0;34m' # Blue
CP='\e[0;35m' # Purple
CC='\e[0;36m' # Cyan
CW='\e[0;37m' # White

TITLE="Assignment 8 Verification"
echo -e "$CP $TITLE $CW"

echo -e "$CY Congratulations on completing the class! $CW"
echo -e "$CG You've undoubtedly gained a lot of knowledge, and while questions may arise, continuous practice is the key to solidifying your skills. $CW"
echo -e "$CL With dedication, you'll soon find yourself evolving into a Linux expert.
 $CW"
echo -e "$CP Embrace the world of Linux! $CW"
echo -e "$CC Wishing you the best of luck on your journey! $CW"


cat /hosted.file
echo "Adding a line to the file..." > /hosted.file
touch /hosted.file2

