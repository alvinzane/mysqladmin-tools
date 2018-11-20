#!/bin/bash
myport=$1
auth=$2
if [ ! -n "$auth" ]
then
auth='\"\"'
fi
comm="/usr/local/redis/bin/redis-cli -p $myport -a $auth "
role=`echo 'INFO Replication'|$comm |grep -Ec 'role:master'`
echo 'INFO Replication'|$comm

if [ $role -ne 1 ]
then
    exit 2
fi