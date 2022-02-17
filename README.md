# OneMinuteForensics

I am a learning bash scripter with minimal knowledge. This script is offered through the GPL 3.0 license \n
There is no warranty offered and I could not promise this script will work on your system. \n
Never run code if you are not sure what is does. Do not experiment with this script in a production environment. \n
\n
Please join along in making changes to improve this script \n
\n
Gives ~1 minute of information about load. In progress and far from done. \n
This program was written to be used on Ubuntu server \n
It should, however, work on any system \n
\n
I currently run this using: \n
sudo ./omf.sh > /path/to/error.txt 2>&1 \n
It will sometimes give math errors (mostly solved using the multiplier) and they will be written to this file as well. \n
\n
Things I am still working on \n
  \>using sed, awk, or bouncing the "buffer" to a file to trim the earlier lines to keep the resource usage low \n
  \>cleaning up the script and beautifying it to improve readability \n
  \>find more errors that can occur and create error exits for them \n
  \>making the script run a service which can be left to run in the background \n
  \>may add email alerts to the script or to the service \n
\n
After copying the script; \n
chmod +x omf.sh \n
sudo vim omf.sh \n
  \>edit the max and load differences to reflect what you want to see \n
  \>change the path to error.txt and the log files \n
  \>make any other desired changes \n
