#!/usr/bin/env bash

# 默认值
HOST=127.0.0.1
PORT=3306
USER=admin
PASSWORD=
SOCKET=/tmp/mysql3306.sock
DB=dbtest1

# 短选项值
while getopts "h:u:P:p:S:" arg
do
    case $arg in
        h) HOST=$OPTARG ;;
        P) PORT=$OPTARG ;;
        p) PASSWORD=$OPTARG ;;
        u) USER=$OPTARG ;;
        S) SOCKET=$OPTARG ;;
        ?)
            echo "Usage: `basename $0` [-h host -P port -s socket -u user -p password] THREADS TIME"
            exit 1
            ;;
    esac
done

# 去掉选项后,再解析参数
shift $((OPTIND-1))
# 第一个参数为线程数,默认1
if [ -z $1 ]; then THREADS=1; else THREADS=$1; fi
# 第二个参数为测试时间,默认1分钟
if [ -z $2 ]; then TIME=60; else TIME=$2; fi

echo "HOST:" $HOST
echo "PORT:" $PORT
echo "THREADS:" $THREADS
echo "TIME:" $TIME

ARGS="
--mysql-host=$HOST
--mysql-user=$USER
--mysql-port=$PORT
--mysql-password=$PASSWORD
--mysql-db=$DB
--report-interval=10
--time=$TIME
--threads=$THREADS
"

# OLTP参数含义查看:
# sysbench /usr/local/sysbench/share/sysbench/oltp_read_write.lua help
OLTP_ARGS="
--auto_inc=on
--create_secondary=on
--delete_inserts=1
--distinct_ranges=1
--index_updates=1
--mysql_storage_engine=innodb
--non_index_updates=0
--order_ranges=1
--point_selects=10
--range_selects=on
--range_size=100
--secondary=off
--simple_ranges=1
--skip_trx=on
--sum_ranges=1
--table_size=10
--tables=2
"

TESTNAME=/usr/local/sysbench/share/sysbench/oltp_read_only.lua
#TESTNAME=/usr/local/sysbench/share/sysbench/oltp_read_write.lua

sysbench $TESTNAME $ARGS $OLTP_ARGS prepare
sysbench $TESTNAME $ARGS $OLTP_ARGS run | tee -a /tmp/"$HOST"_`basename $TESTNAME .lua`_"$THREADS"_`date +%Y%m%d_%H%M%S`.log
sysbench $TESTNAME $ARGS $OLTP_ARGS cleanup