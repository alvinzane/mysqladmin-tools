#!/bin/bash
port=$1
user="root"
passwod="123"

comm="/usr/local/mysql/bin/mysql -u$user -h 127.0.0.1 -P $port -p$passwod"
slave_info=`$comm -e "show slave status" |wc -l`
value=`$comm -Nse "select 1"`

# 判断是不是从库
if [ $slave_info -ne 0 ]
then
   echo "MySQL $port  Instance is Slave........"
   $comm -e "show slave status\G" | egrep -w "Master_Host|Master_User|Master_Port|Master_Log_File|Read_Master_Log_Pos|Relay_Log_File|Relay_Log_Pos|Relay_Master_Log_File|Slave_IO_Running|Slave_SQL_Running|Exec_Master_Log_Pos|Relay_Log_Space|Seconds_Behind_Master"
   exit 2
fi


# 判断mysql是否存活
if [ -z $value ]
then
   exit 2
fi

echo "MySQL $port  Instance is Master........"
$comm -e "select * from information_schema.PROCESSLIST where user='repl' and COMMAND like '%Dump%'"