#!/usr/bin/env bash

# sysbench /usr/local/sysbench/share/sysbench/oltp_read_write.lua help
export LD_LIBRARY_PATH=/usr/local/mysql/lib/

HOST=192.168.20.101
PORT=3306
USER=admin
PASSWORD=aaaaaa

TEST_NAME=/usr/local/sysbench/share/sysbench/oltp_read_write.lua
THREADS=1

sysbench $TEST_NAME \
--mysql-host=$HOST \
--mysql-port=$PORT \
--mysql-user=$USER \
--mysql-password=$PASSWORD \
--mysql-db=sbtest \
--table_size=50000 \
--tables=10 \
--report-interval=5 \
--threads=$THREADS \
--time=60 \
prepare

sysbench $TEST_NAME \
--mysql-host=$HOST \
--mysql-port=$PORT \
--mysql-user=$USER \
--mysql-password=$PASSWORD \
--table_size=50000 \
--tables=10 \
--report-interval=5 \
--threads=$THREADS \
--time=60 \
run | tee -a  ~/log/sysbench_oltp_read_writeX_"$THREADS"_`date +"%Y%m%d_%H%M%S"`.log