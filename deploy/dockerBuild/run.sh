#!/bin/bash
FILE=$(find /opt/config/*.ini)
DIR="/mnt/azurefiles"
LOGS="/mnt/azurefiles/logs"
echo "Using fio config file: $FILE"
if [[ ! -f "$FILE" ]]; then 
    echo "Configuration file does not exist"
    exit 1
fi

if [[ ! -d "$DIR" ]]; then 
    echo "$DIR does not exist."    
    echo "Check that Azure Files has been mounted by running mount | grep -i azurefiles"
    exit 1
else
    echo "Found $DIR"
    mkdir -p $LOGS
    echo "NOTE: $DIR may be a local drive and not an actual mounted Azure Files volume" 
fi

[ -z "$RUNTIME" ] && echo "No RUNTIME was found. Setting default of 60 seconds" && RUNTIME="${RUNTIME:=30}";
[ -z "$OUTPUT" ] && echo "No OUTPUT was specified, using default tmp directory" && OUTPUT="${OUTPUT:=/tmp/$HOSTNAME-fio.output}";

echo "Running fio benchmark using the following file $FILE with a runtime of $RUNTIME"

fio --runtime $RUNTIME --output=$OUTPUT $FILE 

echo "Testing gh actions"
echo "Copying Test Results to logs"
cp $OUTPUT $LOGS
cat $OUTPUT
