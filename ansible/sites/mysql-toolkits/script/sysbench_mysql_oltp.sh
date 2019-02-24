#!/usr/bin/env bash
# Usage:
# ./sysbench_mysql_oltp.sh -h127.0.0.1 -P6033 -uapp -paaaaaa 10 600 oltp_read_write
# ./sysbench_mysql_oltp.sh -h127.0.0.1 -P6033 -uapp -paaaaaa 10 600 oltp_read_only


# 默认值
HOST=127.0.0.1
PORT=3306
USER=admin
PASSWORD=aaaaaa
SOCKET=/tmp/mysql3306.sock
DB=dbtest1

# 日志目录
LOG_DIR=/vagrant/mysqladmin-tools/ansible/sites/mysql-toolkits/script/logs
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
            echo "Usage: `basename $0` [-h host -P port -S socket -u user -p password] THREADS TIME SCRIPT_NAME"
            echo "SCRIPT_NAME:[oltp_read_write oltp_read_only]"
            echo "eg:"
            echo "./sysbench_mysql_oltp.sh -h127.0.0.1 -P6033 -uapp -pxxxxxx 10 600 oltp_read_write"
            echo "./sysbench_mysql_oltp.sh -h127.0.0.1 -P6033 -uapp -pxxxxxx 10 600 oltp_read_only"
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
# 第三个参数为测试模式,默认oltp_read_write
if [ -z $3 ]; then SCRIPT_NAME=oltp_read_write; else SCRIPT_NAME=$3; fi

echo "HOST:" $HOST
echo "PORT:" $PORT
echo "THREADS:" $THREADS
echo "TIME:" $TIME

ARGS="\
--mysql-host=$HOST \
--mysql-user=$USER \
--mysql-port=$PORT \
--mysql-password=$PASSWORD \
--mysql-db=$DB \
--report-interval=10 \
--time=$TIME \
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
--table_size=10000 \
--tables=10 \
--mysql-ignore-errors=all \
"

TESTNAME=/usr/local/sysbench/share/sysbench/$SCRIPT_NAME.lua


CMD_PREPARE="sysbench $TESTNAME $ARGS $OLTP_ARGS prepare"
CMD_RUN="sysbench $TESTNAME $ARGS $OLTP_ARGS run "
CMD_CLEANUP="sysbench $TESTNAME $ARGS $OLTP_ARGS cleanup"
#echo $CMD_PREPARE
#echo $CMD_RUN
#echo $CMD_CLEANUP
$CMD_PREPARE
$CMD_RUN | tee -a $LOG_DIR/`date +%Y%m%d`_${HOST}_`basename $TESTNAME .lua`_${THREADS}_`date +%Y%m%d_%H%M%S`.log
#$CMD_CLEANUP