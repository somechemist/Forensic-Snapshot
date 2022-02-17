# OneMinuteForensics

I am a learning bash scripter with minimal knowledge. This script is offered through the GPL 3.0 license <br />
There is no warranty offered and I could not promise this script will work on your system. <br />
Never run code if you are not sure what is does. Do not experiment with this script in a production environment. <br />
<br />
Please join along in making changes to improve this script <br />
<br />
Gives ~1 minute of information about load. In progress and far from done. <br />
This program was written to be used on Ubuntu server <br />
It should, however, work on any system <br />

I currently run this using: <br />
`sudo ./omf.sh > /path/to/error.txt 2>&1` <br />
It will sometimes give math errors (mostly solved using the multiplier) and they will be written to this file as well. <br />
<br />
## Things I am still working on: <br />
  -[ ]using sed, awk, or bouncing the "buffer" to a file to trim the earlier lines to keep the resource usage low <br />
  -[ ]cleaning up the script and beautifying it to improve readability <br />
  -[ ]find more errors that can occur and create error exits for them <br />
  -[ ]making the script run a service which can be left to run in the background <br />
  -[ ]may add email alerts to the script or to the service <br />
<br />
## After copying the script; <br />
`chmod +x omf.sh` <br />
`sudo vim omf.sh` <br />
  -[ ]edit the max and load differences to reflect what you want to see <br />
  -[ ]change the path to error.txt and the log files <br />
  -[ ]make any other desired changes <br />
