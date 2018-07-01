#!/bin/sh
port=$1
if [ -z $port ]; then
    echo "Useage: start_mysql.sh port"
    exit 1
fi
running=`ps aux|grep -v grep |grep -E "mysqld.*$port" |wc -l`
cmd="/usr/local/mysql/bin/mysqld --defaults-file=/data/mysql/$port/my.cnf"

if [ "$running" = "0" ]; then
    echo "MySQL $port start."

    echo $cmd
    $cmd &
else
   echo "MySQL $port is already running."
   exit 1
fi