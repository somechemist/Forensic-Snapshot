# {BUGGED! DO NOT USE} OneMinuteForensics

No warranty offered. Run at your own risk. <br />
<br />
Please join along in making changes to improve this script <br />
<br />
buffers information over time (about one minute) and then dumps that information into a log file IF you exceed the max allowed load<br />
This program was written to be used on Ubuntu server <br />
It should, however, work on any system (using systemd at least)<br />
<br />
<br />
<br />
## To Be Fixed:
  -[ ] if the files exceed X size, append, zip, rotate, etc. This functionality is needed for production <br />
  <br />
## To use: <br />
  -[ ] Clone the repository <br />
  -[ ] `cd <path/to/directory>` <br />
  -[ ] Edit the setup.sh, forensicSnap.sh and forensicSnap.service files as needed. <br />
  -[ ] `chmod +x setup.sh` <br />
  -[ ] `sudo ./setup.sh` <br />
  If you do not want to uncomment the last like of setup.sh then: <br />
  -[ ] `sudo systemctl daemon-reload` <br />
  -[ ] `sudo systemctl enable forensicSnap.service` <br />
  -[ ] `sudo systemctl start forensicSnap.service` <br />
