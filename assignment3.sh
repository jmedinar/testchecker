#!/usr/bin/env bash
# Script: assignment3.sh
# Author: Professor Juan Medina
# Email: jmedina@collin.edu
# Date: 03/23/2024

# Black       Red           Green         Yellow        Blue          Purple        Cyan          White
CB='\e[0;30m' CR='\e[0;31m' CG='\e[0;32m' CY='\e[0;33m' CL='\e[0;34m' CP='\e[0;35m' CC='\e[0;36m' CW='\e[0;37m'
assignment=3
ca=0
tq=0
base_dir="/opt/enterprise-app"
realuser=$(who am i | awk '{print $1}')

_msg() {
   echo -ne "$CY $1"
   ((tq++))
}

_pass() {
   echo -e "$CG PASS $CR"
   ((ca++))
}

_fail() {
   echo -e "$CR FAIL $CG"
}

_file() {
    _msg "Verify $1 exist"
    if [[ $(ls $1 &>/dev/null; echo $?) -eq 0 ]]
    then 
        _pass
        return 0
    else 
        _fail
        return 1
    fi
}

_mode() {
    _msg "Permissions (mode) of $1"
    if [[ $(stat -c %a $1) -eq $2 ]]; then _pass; else _fail; fi
}

_own() {
    _msg "Ownership of $1"
    if [[ $(stat -c %U $1) == "$2" ]]; then _pass; else _fail; fi
}

_stat() {
    report=$base_dir/docs/report.out
    _msg "Report presents the value $1 for file $2"
    if [[ $(grep -sE "$1:*.*$2:" ${report} &>/dev/null; echo $?) -eq 0 ]]; then _pass; else _fail; fi
}

echo -e "$CC ========================================================================="
echo -e "$CP Assignment ${assignment} Verification $CW"
echo -e "$CC ========================================================================="

_dir(){
   _msg "Verify $1 exist"
   if [[ $(ls -d $1 &>/dev/null; echo $?) -eq 0 ]]
   then 
       _pass
       return 0
   else 
       _fail
       return 1
   fi
}

_dir $base_dir
if [[ $? -eq 0 ]]
then
    _msg "root owns the $base_dir folder"
        if [[ $(stat -c %U $base_dir) == "root" ]]; then _pass; else _fail; fi

    echo -e "$CL Verifying $base_dir/bin requirements$CW"
    _dir $base_dir/bin
    if [[ $? -eq 0 ]]
    then
        _own $base_dir/bin root
        _file $base_dir/bin/app.py
        _mode $base_dir/bin/app.py 700
    fi

    echo -e "$CL Verifying $base_dir/code requirements$CW"
    _dir $base_dir/code
    if [[ $? -eq 0 ]]
    then
        _own $base_dir/code $realuser
        _file $base_dir/code/alt_app_access
        _msg "Correctness of symbolic link"
        if [[ $(stat -c %N $base_dir/code/alt_app_access &>/dev/null; echo $?) -eq 0 ]]; then _pass; else _fail; fi
    fi

    echo -e "$CL Verifying $base_dir/flags requirements$CW"
    _dir $base_dir/flags
    if [[ $? -eq 0 ]]
    then 
        _own $base_dir/flags $realuser
        _file $base_dir/flags/pid.info
    fi

    echo -e "$CL Verifying $base_dir/libs requirements$CW"
    _dir $base_dir/libs
    _own $base_dir/libs $realuser

    echo -e "$CL Verifying $base_dir/logs requirements$CW"
    _dir $base_dir/logs
    if [[ $? -eq 0 ]]
    then
        _own  $base_dir/logs $realuser
        _file $base_dir/logs/stdout.log
        _mode $base_dir/logs/stdout.log 644
        _own  $base_dir/logs/stdout.log $realuser
        _file $base_dir/logs/stderr.log
        _mode $base_dir/logs/stderr.log 644
        _own  $base_dir/logs/stderr.log $realuser
    fi

    echo -e "$CL Verifying $base_dir/scripts requirements$CW"
    _dir $base_dir/scripts
    if [[ $? -eq 0 ]]
    then
        _own  $base_dir/scripts $realuser
        _file $base_dir/scripts/clean.sh
        _mode $base_dir/scripts/clean.sh 755
    fi

    echo -e "$CL Verifying $base_dir/docs requirements$CW"
    _dir $base_dir/docs
    if [[ $? -eq 0 ]]
    then
        _own  $base_dir/docs $realuser
        _file $base_dir/docs/README.txt
        _file $base_dir/docs/report.out
        if [[ $? -eq 0 ]]
        then
            _stat OWNER bin/app.py
            _stat OWNER scripts/clean.sh
            _stat PERMISSIONS bin/app.py
            _stat PERMISSIONS scripts/clean.sh
            _stat INODE bin/app.py
            _stat INODE scripts/clean.sh
        else
            echo -e "$CR The verification process cannot proceed without the presence of the $base_dir/docs/report.out file"
        fi
    fi
else
    echo -e "$CR The verification process cannot proceed without the presence of the $base_dir directory"
    exit 1
fi


printf "$CP FINAL GRADE: $CC %.0f $CW" $(echo "(100/$tq)*$ca" | bc -l)
echo ""

# CHALLENGE:
# Create the following folder structure
# /opt
# ├── enterprise-app
#     ├── bin
#     ├── code
#     ├── docs
#     ├── flags
#     ├── libs
#     ├── logs
#     └── scripts
#
#     Ensure the user root is the owner of the enterprise-app folder.
#     Ensure your regular user account owns all the other folders in the structure except the bin/ folder.
#     Create the following files:
#         app.py in the bin folder
#         stdout.log and stderr.log in the logs folder
#         README.txt in the docs folder
#         clean.sh in the scripts folder
#         pid.info in the flags folder
#     Set the permissions for the created files as follows:
#         Anyone can execute the script scripts/clean.sh.
#         The files inside logs can be read by anyone, cannot be executed, and can only be written by the owner (your regular account).
#         The file bin/app.py should have the mode. 700.
#     Create a symbolic link named alt_app_access under the code folder of the structure. The link must point to the bin/app.py file.
#     Generate a report of the enterprise application by extracting information about the files we have created. 
#     Create the file docs/report.out and redirect the following information from two files, bin/app.py and scripts/clean.sh:
#           File owner in the format: OWNER:<FileName>:<Information>
#           File octal mode permissions in the format: PERMISSIONS:<FileName>:<Information>
#           File inode number in the format: INODE:<FileName>:<Information>
#     Create the enterprise_app_backup.tar.gz file of the /opt/enterprise-app structure at the /tmp directory.
