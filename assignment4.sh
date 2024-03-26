#!/usr/bin/env bash
# Script: assignment4.sh
# Author: Professor Juan Medina
# Email: jmedina@collin.edu
# Date: 03/23/2024

# Black           # Red             # Green         # Yellow
CB='\e[0;30m';    CR='\e[0;31m';    CG='\e[0;32m';  CY='\e[0;33m';
# Blue            # Purple          # Cyan          # White
CL='\e[0;34m';    CP='\e[0;35m';    CC='\e[0;36m';  CW='\e[0;37m'; 

version=4
ca=0
tq=36  # Total number of user times verified items (9*4=36)

echo -e "$CC ===================================================="
echo -e "$CP Assignment ${version} Verification $CW"
echo -e "$CC ===================================================="


_user() {
   exist=""
   primary=""
   auxiliar=""
   gecos=""
   if [[ $(id $1 &>/dev/null; echo $?) -eq 0 ]]
   then
      exist="true"
      ((ca++))

      # Primary group verification
      if [[ "$(id -gn $1)" == "$2" ]]
      then 
         ((ca++))
         primary="true"
      else 
         primary="false"
      fi

      # auxiliar groups verification
      case $2 in
         accounting | technology) 
            if [[ "$(userdbctl user $1 | grep Aux)" == "" ]]
            then 
               ((ca++))
               auxiliar="true"
            else 
               auxiliar="false"
            fi 
            ;;
         humanresources)
            for g in $(id -nG $1)
            do
               if [[ $g != "humanresources" ]]
               then
                  if [[ $g == "accounting" ]]
                  then 
                     ((ca++)) 
                     auxiliar="true"
                  else 
                     auxiliar="false"
                  fi
               fi
            done
            ;;
         directionboard)  
            count=0
            for g in $(id -nG $1)
            do
               if [[ $g != "directionboard" ]]
               then
                  if [[ $g == "technology" ]]; then ((count++))
                  elif [[ $g == "humanresources" ]]; then ((count++))
                  elif  [[ $g == "accounting" ]]; then ((count++)); fi
               fi
            done
            if [[ $count -eq 3 ]]
            then
               ((ca++))
               auxiliar="true"
            else
               auxiliar="false"
            fi
            ;;
      esac

      # gecos field verification
      if [[ $(grep "$1@wedbit.com" /etc/passwd &>/dev/null; echo $?) -eq 0 ]]
      then
         ((ca++))
         gecos="true"
      else
         gecos="false"
      fi
   else
      exist="false"
   fi
   printf "$CY%-20s%-20s%-20s%-20s%-20s$CW\n" $1 $exist $primary $auxiliar $gecos
}

printf "$CG%-20s%-20s%-20s%-20s%-20s$CW\n"  USER EXIST PRIMARY AUXILIARY GECOS
echo -e "$CL=========================================================================================$CW"
_user cyen accounting
_user mpearl accounting
_user jgreen directionboard
_user dpaul technology
_user msmith technology
_user poto technology
_user mkhan technology
_user llopez directionboard
_user jramirez humanresources
echo -e "$CL=========================================================================================$CW"

printf "$CP FINAL GRADE: $CC %.0f $CW" $( echo "( 100 / $tq ) * $ca" | bc -l )
echo ""

# CHALLENGE:
#
# Employee Name 		         Department 	      Email
# CHIN YEN              Accountant           Accounting        cyen@wedbit.com
# MIKE PEARL            Senior Accountant    Accounting        mpearl@wedbit.com
# JOHN GREEN            CEO                  Direction Board   jgreen@wedbit.com
# DEWAYNE PAUL          Programmer           Technology        dpaul@wedbit.com
# MATT SMITH            Sr. Programmer       Technology        msmith@wedbit.com
# PLANK OTO             Network Support      Technology        poto@wedbit.com
# MOHAMMED KHAN         Desk Support         Technology        mkhan@wedbit.com
# LAURA LOPEZ           Project Manager      Direction Board   llopez@wedbit.com
# JOSE ANGEL RAMIREZ    Human Resources      Human Resources   jramirez@wedbit.com
#
#     Create a group for each department.
#     Create a user for each employee following these rules:
#         The username should be the same as the one already assigned in the employee email without the domain.
#         Every employee must have their primary group set to the department to which they belong.
#         Every employee must have their email included in the Comment/GECOS Field.
#         Employees of the Direction Board should have all other departments as supplementary groups.
#         Employees in the Human Resources department should have Accounting as a supplementary group.
#     All usernames and groups should be in lowercase.a
#
