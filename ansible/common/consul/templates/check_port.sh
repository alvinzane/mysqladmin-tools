#!/bin/bash
port=$1

listening=`netstat -nltp |grep -E "$port" |wc -l`

if [ ${listening} -lt 1 ]
then
    exit 2
fi

echo port $port is listening
