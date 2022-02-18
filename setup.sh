#!/usr/bin/env bash
#
# Written by Justin Powell
# 02/18/2022
#
# Forensic snapshot setup file. Used to rapidly setup the system to use my forensicSnap.sh tool
#
# Change these directory names to desired directory
# WARNING: If you change these directories here or in the script, it will not properly behave! MAKE SURE THE DIRECTORIES ALL MATCH
sudo mkdir /var/log/forensics &> /dev/null
sudo mkdir /var/log/forensics/snapshots &> /dev/null
#
# Copies associated files to correct directory
sudo cp forensicsSnap.sh /usr/local/bin/forensicsSnap;
sudo cp forensicsSnap.service /lib/systemd/system/forensicsSnap.service;
sudo touch /var/log/forensics/snapshots/error.log;
