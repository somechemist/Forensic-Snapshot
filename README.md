# OneMinuteForensics

I am a learning bash scripter with minimal knowledge. This script is offered through the GPL 3.0 license
There is no warranty offered and I could not promise this script will work on your system.
Never run code if you are not sure what is does. Do not experiment with this script in a production environment.

Please join along in making changes to improve this script

Gives ~1 minute of information about load. In progress and far from done.
This program was written to be used on Ubuntu server
It should, however, work on any system

I currently run this using:
sudo ./omf.sh > /path/to/error.txt 2>&1
It will sometimes give math errors (mostly solved using the multiplier) and they will be written to this file as well. 

Things I am still working on
  \>using sed, awk, or bouncing the "buffer" to a file to trim the earlier lines to keep the resource usage low
  \>cleaning up the script and beautifying it to improve readability
  \>find more errors that can occur and create error exits for them
  \>making the script run a service which can be left to run in the background
  \>may add email alerts to the script or to the service

After copying the script;
chmod +x omf.sh
sudo vim omf.sh 
  \>edit the max and load differences to reflect what you want to see
  \>change the path to error.txt and the log files
  \>make any other desired changes
