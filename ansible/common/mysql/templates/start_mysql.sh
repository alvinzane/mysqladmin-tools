#!/bin/sh

# 第一个参数为port,其它参数放进 args,如 --wsrep-new-cluster
port=$1
shift
args=$@

if [ -z $port ]; then
    echo "Useage: start_mysql.sh port"
    exit 1
fi
running=`ps aux|grep -v grep |grep -E "mysqld.*$port" |wc -l`
cmd="{{mysql_basedir}}/bin/mysqld --defaults-file={{ mysql_datahome }}/$port/my.cnf $args"

if [ "$running" = "0" ]; then
    echo "MySQL $port start. "
    echo $cmd
    $cmd &

    # 检测pid文件,修改权限
    {{ mysql_datahome }}/chmod_mysql_pid.sh {{ mysql_datahome }}/$port/mysqld.pid
    if [ $? ]; then
        exit 2
    fi
    echo "MySQL $port is done."
else
   echo "MySQL $port is already running."
   exit 1
fi