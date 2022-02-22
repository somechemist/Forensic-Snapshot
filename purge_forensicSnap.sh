#!/usr/bin/env bash

#
# Written by Justin Powell
#
#
# This script purges the files created by setup.sh

sudo service forensicSnap stop;
echo "please kill any processes running here before continuing. (say no at prompt or press CTRL +C now)"
echo
ps -aux | grep "forensicSnap"
echo
echo
echo "would you like to remove all associated files? "
read answer
case $answer in
	y | Y | yes | YES | Yes)
	echo "Removing script";
	sudo rm /usr/local/bin/forensicSnap;
	echo "Removing service file";
	sudo rm /lib/systemd/system/forensicSnap.service;
	echo "Removing logs";
	sudo rm -r /var/log/forensics;
	echo "Reloading daemons";
	sudo systemctl daemon-reload;
	;;

	*)
	echo "Exiting"
	exit 0
	;;
esac
