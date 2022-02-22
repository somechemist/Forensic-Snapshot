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
sudo chmod +x forensicSnap.sh
sudo cp forensicSnap.sh /usr/local/bin/forensicSnap;
sudo cp forensicSnap.service /lib/systemd/system/forensicSnap.service;
sudo touch /var/log/forensics/snapshots/error.log;
#
# Uncomment next line for total automation with this script
# sudo systemctl daemon-reload; sudo systemctl enable forensicSnap.service; sudo systemctl start forensicSnap.service;
