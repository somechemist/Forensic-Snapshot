#!/bin/bash
#
# Written by Justin Powell
# 02/16/2022
#
# This script keeps load levels in a buffer and looks for a 2:1 change in load or a load >= 5
# If such an event occurs, the buffered load logs are dumped to a file, other log files are appended to this file and an alert is sent
#
#Configure these variables to match your needs
MAX_LOAD=3 #load average max allowed value
LOAD_RATIO=2 #biggest possible difference second-to-second in load average
#
#Static, Should not need changed
multiplier=100000
MAX_LOAD=$(awk '{print $1*$2}' <<<"${MAX_LOAD} ${multiplier}")
LOAD_RATIO=$(awk '{print $1*$2}' <<<"${LOAD_RATIO} ${multiplier}")
alert="false"
scount=$((0+0))
scmin="false"
load_count=$((0+0))
buffer=""
while [ "$alert" != "true" ];
do
    #
    #After 60 logs, the top 30 are removed
    if [ "$scmin" != "true" ] && (( "$scount" >= 120 ));
    then
        scmin="true"
        #echo "scmin is now true" #logging
        #~~~sed or awk
        scount=$((0+0))
    fi
    #
    #Now every logs, the first 30 will be removed
    if [ "$scmin" == "true" ] && (( "$scount" >= 60 ));
    then
        #echo "scmin is true and scount is at or equal to 60"
        #~~~sed or awk
        scount=$((0+0))
        #alert="true"
    fi
    #
    #This is where the magic happens. Load averages are saved in a buffer
    var=$(uptime | cut -d ' ' -f 14 | rev | cut -c 2- | rev)
    buffer+="$(date)        $var\n"
    sleep 1
    scount=$(($scount+1))
    nvar=$(uptime | cut -d ' ' -f 14 | rev | cut -c 2- | rev)
    buffer+="$(date)       $nvar\n"
    sleep 1
    scount=$(($scount+1))
    var=$(awk '{print $1*$2}' <<<"${var} ${multiplier}")
    nvar=$(awk '{print $1*$2}' <<<"${nvar} ${multiplier}")
    result=$(awk '{print $1-$2}' <<<"${nvar} ${var}")
    result=$(awk '{print $1*$2}' <<<"${result} ${multiplier}")
    #echo "$result"
    #
    #This block will make and rotate log files && dump the buffer to a file if it executes
    if (( $result>=$LOAD_RATIO )) || (( $var>=$MAX_LOAD )) || (( $nvar>=$MAX_LOAD ));
    then
        #
        #It is possible to infinite loop, this will prevent that and log the error
        load_count=$(($load_count+1))
        if (( $load_count>=3 ));
        then
            ErrorMSG="Script got caught in an infinite loop during the log rotation. Please increase the MAX_LOAD and/or LOAD_RATIO";
            ErrFILE=/var/log/forensics/snapshots/error.txt;
            touch $ErrFILE;
            echo -e "Fatal Error $(date) $ErrorMSG\n"  >> $ErrFILE;
            #
            #If it somehow fails to exit here, setting alert to true should break the parent loop
            alert="true"
            exit 1
        fi
        #
        #Generate/Rotate directories and files
        mkdir /var/log/forensics &> /dev/null
        mkdir /var/log/forensics/snapshots &> /dev/null
        cd /var/log/forensics/snapshots/;
        FILE_NAME=/var/log/forensics/snapshots/snapshot_$HOSTNAME.txt
        RFILE_NAME=/var/log/forensics/snapshots/snapshot_$HOSTNAME.txt.1
        RRFILE_NAME=/var/log/forensics/snapshots/snapshot_$HOSTNAME.txt.2
        if [[ -f "$FILE_NAME" ]];
        then
            if [[ -f "$RFILE_NAME" ]]; then
                mv $RFILE_NAME $RRFILE_NAME
            fi
            mv $FILE_NAME $RFILE_NAME
        fi
        touch $FILE_NAME;
        #
        #Generate log file from buffer
        echo "           DATE                    LOAD AVG" >> $FILE_NAME;
        echo -e "$buffer" >> $FILE_NAME;
        echo -e "\nPrinting syslog\n" >> $FILE_NAME;
        echo "$(tail -n 20 /var/log/syslog)" >> $FILE_NAME;
        echo -e "\nPrinting dmesg\n" >> $FILE_NAME;
        echo "$(tail -n 20 /var/log/dmesg)" >> $FILE_NAME;
        echo -e "\nPrinting last 10 of each apache log\n" >> $FILE_NAME;
        echo "$(tail -n 10 /var/log/apache2/*.log)" >> $FILE_NAME;
        echo -e "\nPrinting netstat\n" >> $FILE_NAME;
        echo "$(netstat)" >> $FILE_NAME;
    fi
done
