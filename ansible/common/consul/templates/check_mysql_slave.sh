#!/bin/bash
port=$1
user="root"
passwod="123"
repl_check_user="root"
repl_check_pwd="123"

master_comm="/usr/local/mysql/bin/mysql -u$user -h 127.0.0.1 -P $port -p$passwod"
slave_comm="/usr/local/mysql/bin/mysql -u$repl_check_user  -P $port -p$repl_check_pwd"

# 判断mysql是否存活
value=`$master_comm -Nse "select 1"`
if [ -z $value ]
then
   echo "MySQL Server is Down....."
   exit 2
fi

get_slave_count=0
is_slave_role=0
slave_mode_repl_delay=0
master_mode_repl_delay=0
master_mode_repl_dead=0
slave_mode_repl_status=0
max_delay=120

get_slave_hosts=`$master_comm -Nse "select substring_index(HOST,':',1) from information_schema.PROCESSLIST where user='repl' and COMMAND like '%Binlog Dump%';" `
get_slave_count=`$master_comm -Nse "select count(1) from information_schema.PROCESSLIST where user='repl' and COMMAND like '%Binlog Dump%';" `
is_slave_role=`$master_comm -e "show slave status\G"|grep -Ewc "Slave_SQL_Running|Slave_IO_Running"`


### 单点模式(如果 get_slave_count=0 and is_slave_role=0)
function single_mode
{
if [ $get_slave_count -eq 0 -a $is_slave_role -eq 0 ]
then
    echo "MySQL $port  Instance is Single Master........"
    exit 0
fi
}

### 从节点模式(如果 get_slave_count=0 and is_slave_role=2 )
function slave_mode
{
#如果是从节点,必须满足不延迟,
if [  $is_slave_role -ge 2 ]
then
        echo "MySQL $port  Instance is Slave........"
        $master_comm -e "show slave status\G" | egrep -w "Master_Host|Master_User|Master_Port|Master_Log_File|Read_Master_Log_Pos|Relay_Log_File|Relay_Log_Pos|Relay_Master_Log_File|Slave_IO_Running|Slave_SQL_Running|Exec_Master_Log_Pos|Relay_Log_Space|Seconds_Behind_Master"
        slave_mode_repl_delay=`$master_comm -e "show slave status\G" | grep -w "Seconds_Behind_Master" | awk '{print $NF}'`
        slave_mode_repl_status=`$master_comm -e "show slave status\G"|grep -Ec "Slave_IO_Running: Yes|Slave_SQL_Running: Yes"`
if [ X"$slave_mode_repl_delay" == X"NULL" ]
then
        slave_mode_repl_delay=99999
fi
        if [ $slave_mode_repl_delay != "NULL" -a $slave_mode_repl_delay -lt $max_delay -a $slave_mode_repl_status -ge 2 ]
        then
             exit 0
        fi
fi
}

function master_mode
{
###如果是主节点，必须满足从节点为延迟或复制错误。才可读
if [ $get_slave_count -gt 0 -a $is_slave_role -eq  0 ]
then
    echo "MySQL $port  Instance is Master........"
    $master_comm -e "select * from information_schema.PROCESSLIST where user='repl' and COMMAND like '%Dump%'"
    for my_slave in $get_slave_hosts
do
master_mode_repl_delay=`$slave_comm -h $my_slave -e "show slave status\G" | grep -w "Seconds_Behind_Master" | awk '{print $NF}' `
master_mode_repl_thread=`$slave_comm -h $my_slave -e "show slave status\G"|grep -Ec "Slave_IO_Running: Yes|Slave_SQL_Running: Yes"`
if [ X"$master_mode_repl_delay" == X"NULL" ]
then
     master_mode_repl_delay=99999
fi

if [ $master_mode_repl_delay -lt $max_delay -a $master_mode_repl_thread -ge 2 ]
then
    exit 2
fi
done
exit 0
fi
}

single_mode
slave_mode
master_mode
exit 2