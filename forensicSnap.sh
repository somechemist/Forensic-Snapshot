#!/usr/bin/env bash
#
# Written by Justin Powell
# 02/16/2022
#
# This script keeps load levels in a buffer and looks for a 2:1 change in load or a load >= 5
# If such an event occurs, the buffered load logs are dumped to a file, other log files are appended to this file and an alert is sent


#
# Configure this variables to match your needs
MAX_LOAD=3 #load average max allowed value
MAX_SIZE=0.4 #Max allowed size for the log files in MB
#
#Match the variables to the directories set in setup.sh (current settings match)
CD_PATH=/var/log/forensics/snapshots/
FILE_NAME=/var/log/forensics/snapshots/snapshot_$HOSTNAME.log
RFILE_NAME=/var/log/forensics/snapshots/snapshot_$HOSTNAME.log.1
RRFILE_NAME=/var/log/forensics/snapshots/snapshot_$HOSTNAME.log.2
SSMF=/var/log/forensics/snapshots/MASTER_snapshot_$HOSTNAME.log
SSMFT=/var/log/forensics/snapshots/MASTER_snapshot_$HOSTNAME.log.1
SSMFTh=/var/log/forensics/snapshots/MASTER_snapshot_$HOSTNAME.log.2
ErrFILE=/var/log/forensics/snapshots/error.log;
RErrFILE=/var/log/forensics/snapshots/error.log.1;
#
# Static, Should not need changed
cd $CD_PATH;
multiplier=100000
MAX_LOAD=$(awk '{print $1*$2}' <<<"${MAX_LOAD} ${multiplier}")
MAX_SIZE=$(awk '{print $1*$2}' <<<"${MAX_SIZE} ${multiplier}")
alert="false"
scount=$((0+0))
scmin="false"
load_count=$((0+0))
KILL_SWITCH=$((0+0))
FILE_SIZE=$((0+0))
buffer=""
touch $FILE_NAME $RFILE_NAME $RRFILE_NAME $SSMF $SSMFT $SSMFTh $ErrFILE $RErrFILE
#
# Rotate Error log
if [[ -f "$ErrFILE" ]];
then
    touch $RErrFILE
    mv $ErrFILE $RErrFILE
fi
#
# Functions
write_to_file () {

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
}
trim_buffer () {
        cd $CD_PATH;
        touch buffer.txt;
        echo -e "$buffer" > buffer.txt;
        sed -i '1,60d' buffer.txt;
        buffer="$(<buffer.txt)";
        rm buffer.txt;
        scount=$((0+0));
}
while (( $KILL_SWITCH < 1 ));
do
    #
    # After 120 logs, the top 120 are removed. Changing these to Cases might make this look a lot better
    if [ "$scmin" != "true" ] && (( "$scount" >= 120 ));
    then
        scmin="true"
        cd $CD_PATH;
        trim_buffer
    fi
    #
    # Now every logs, the first 60 will be removed
    if [ "$scmin" == "true" ] && (( "$scount" >= 60 ));
    then
        cd $CD_PATH;
        trim_buffer
    fi
    #
    # This is where the magic happens. Load averages are saved in a buffer
    var=$(uptime | cut -d ' ' -f 14 | rev | cut -c 2- | rev)
    nvar=$(awk '{print $1*$2}' <<<"${var} ${multiplier}")
    buffer+="\n$(date)        $var\n$(free -h)\n"
    sleep 1
    scount=$(($scount+1))
    FILE_SIZE="$(stat -c%s "FILE_NAME")"
    if (( $FILE_SIZE > $MAX_SIZE ));
    then
	KILL_SWITCH=$KILL_SWITCH+1; service forensicSnap stop && echo "Max file size exceeded" >> $ErrFILE;
    fi
    FILE_SIZE="$(stat -c%s "RFILE_NAME")"
    if (( $FILE_SIZE > $MAX_SIZE ));
    then
        KILL_SWITCH=$KILL_SWITCH+1; service forensicSnap stop && echo "Max file size exceeded" >> $ErrFILE;
    fi
    FILE_SIZE="$(stat -c%s "RRFILE_NAME")"
    if (( $FILE_SIZE > $MAX_SIZE ));
    then
        KILL_SWITCH=$KILL_SWITCH+1; service forensicSnap stop && echo "Max file size exceeded" >> $ErrFILE;
    fi
    FILE_SIZE="$(stat -c%s "ErrFILE")"
    if (( $FILE_SIZE > $MAX_SIZE ));
    then
        KILL_SWITCH=$KILL_SWITCH+1; service forensicSnap stop && echo "Max file size exceeded" >> $ErrFILE;
    fi
    FILE_SIZE="$(stat -c%s "RErrFILE")"
    if (( $FILE_SIZE > $MAX_SIZE ));
    then
        KILL_SWITCH=$KILL_SWITCH+1; service forensicSnap stop && echo "Max file size exceeded" >> $ErrFILE;
    fi
    #
    # This block will make and rotate log files && dump the buffer to a file if it executes
    if (( $nvar>=$MAX_LOAD ));
    then
        #
        # It is possible to infinite loop, this will prevent that and log the error
        echo "Acheived MAX LOAD" >> $ErrFILE
	load_count=$(($load_count+1))
        if (( $load_count>=3 ));
        then
            cd $CD_PATH;
            ErrorMSG="You have written to all three log files, waiting";
            echo -e "Master File Created $(date) $ErrorMSG\n"  >> $ErrFILE;
            if [[ -f "$SSMF" ]];
            then
                if [[ -f "$SSMFT" ]]; then
                    mv $SSMFT $SSMFTh
                fi
                mv $SSMF $SSMFT
            fi
            touch $SSMF;
            cat $RRFILE_NAME $RFILE_NAME $FILE_NAME > $SSMF;
            sleep 10
            load_count=$((0+0))
        fi
        #
        # Generate/Rotate directories and files
        if [[ -f "$FILE_NAME" ]];
        then
            if [[ -f "$RFILE_NAME" ]]; then
                mv $RFILE_NAME $RRFILE_NAME
            fi
            mv $FILE_NAME $RFILE_NAME
        fi
        touch $FILE_NAME;
        write_to_file
    fi
done
