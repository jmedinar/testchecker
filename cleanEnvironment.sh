#!/usr/bin/env bash
# Author: Juan Medina
# Email: jmedina@collin.edu

if [[ $UID -ne 0 ]]; then echo "Run as root!"; exit; fi 

echo Clean class related stuff
rm -rf ~/class 

echo Clean assignment 2
rm -rf ~/backup

echo Clean assignment 3
rm -rf /opt/enterprise*

echo Clean assignment 4
users=(cyen mpearl jgreen dpaul msmith poto mkhan llopez jramirez)
for user in ${users[@]}
do
  userdel -r $user
done
groups=(finances direction it hr technology humanresources finances directionboard)
for group in ${groups[@]}
do
  groupdel $group
done

echo Clean assignment 5 and 6
rm -rf /sysadm

echo Clean assignment 7
dnf -yqq remove tuxpaint httpd cheese 
rm -rf /var/www/html/index.html /opt/bin /opt/Typora*

echo Clean testchecker info 
rm -rf ~/Downloads/*.db
rm -rf ~/Downloads/testchecker*

