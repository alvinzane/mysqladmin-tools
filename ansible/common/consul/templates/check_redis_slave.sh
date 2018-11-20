#!/bin/bash
myport=$1
auth=$2
if [ ! -n "$auth" ]
then
auth='\"\"'
fi
comm="/usr/local/redis/bin/redis-cli -p $myport -a $auth "
role=`echo 'INFO Replication'|$comm |grep -Ec '^role:slave|^master_link_status:up'`
single=`echo 'INFO Replication'|$comm |grep -Ec '^role:master|^connected_slaves:0'`
echo 'INFO Replication'|$comm

if [ $role -ne 2 -a $single -ne 2  ]
then
    exit 2
fi