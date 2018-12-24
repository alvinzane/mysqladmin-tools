#!/usr/bin/env bash
# Usage:
# ./sysbench_mysql_prepare.sh 50 50 100000
# 第一个参数为线程数
# 第二个参数为表数量
# 第三个参数为表大小
# 第四个参数为库名
# 说明: 进程数和表数据量一致, 会比较快

# 默认值
HOST=localhost
PORT=3306
USER=root
PASSWORD=aaaaaa
SOCKET=/tmp/mysql3306.sock
DB=dbtest1
TABLES=50
SIZE=10000

# 日志目录
LOG_DIR=/home/sysbench/logs
# 默认测试模式
SCRIPT_NAME=oltp_read_write

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
            echo "Usage: `basename $0` [-h host -P port -s socket -u user -p password] THREADS TABLES SIZE DB"
            echo "eg:"
            echo "./sysbench_mysql_oltp.sh -h127.0.0.1 -P6033 -uapp  10 50 10000"
            exit 1
            ;;
    esac
done

# 去掉选项后,再解析参数
shift $((OPTIND-1))
# 第一个参数为线程数
if [ -z $1 ]; then THREADS=10; else THREADS=$1; fi
# 第二个参数为表数量
if [ -z $2 ]; then TABLES=$TABLES; else TABLES=$2; fi
# 第三个参数为表大小
if [ -z $3 ]; then SIZE=$SIZE; else SIZE=$3; fi
# 第四个参数为库名
if [ -z $4 ]; then DB=$DB; else DB=$4; fi

echo "HOST:" $HOST
echo "PORT:" $PORT
echo "THREADS:" $THREADS
echo "TABLES:" $TABLES
echo "SIZE:" $SIZE
echo "DB:" $DB

ARGS="\
--mysql-host=$HOST \
--mysql-user=$USER \
--mysql-port=$PORT \
--mysql-password=$PASSWORD \
--mysql-db=$DB \
--mysql-socket=$SOCKET \
--report-interval=10 \
--threads=$THREADS \
"

# OLTP参数含义查看:
# sysbench /usr/local/sysbench/share/sysbench/oltp_read_write.lua help
OLTP_ARGS="\
--auto_inc=on \
--create_secondary=on \
--delete_inserts=1 \
--distinct_ranges=1 \
--index_updates=1 \
--mysql_storage_engine=innodb \
--non_index_updates=0 \
--order_ranges=1 \
--point_selects=10 \
--range_selects=on \
--range_size=100 \
--secondary=off \
--simple_ranges=1 \
--skip_trx=off \
--sum_ranges=1 \
--tables=$TABLES \
--table_size=$SIZE \
--mysql-ignore-errors=all \
"

TESTNAME=/usr/local/sysbench/share/sysbench/$SCRIPT_NAME.lua

CMD_PREPARE="sysbench $TESTNAME $ARGS $OLTP_ARGS prepare"
#echo $CMD_PREPARE
$CMD_PREPARE