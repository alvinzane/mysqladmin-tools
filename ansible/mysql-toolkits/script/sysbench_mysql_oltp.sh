#!/usr/bin/env bash

# sysbench /usr/local/sysbench/share/sysbench/oltp_read_write.lua help
export LD_LIBRARY_PATH=/usr/local/mysql/lib/

TEST_NAME=/usr/local/sysbench/share/sysbench/oltp_read_write.lua
THREADS=1

ARGS="
--mysql-host=192.168.20.101
--mysql-port=3306
--mysql-user=admin
--mysql-password=aaaaaa
--mysql-db=sbtest
--table_size=50000
--tables=10
--report-interval=5
--threads=$THREADS
--time=60
"

sysbench $TEST_NAME $ARGS prepare
sysbench $TEST_NAME $ARGS run | tee -a  ~/log/sysbench_oltp_read_write_X_"$THREADS"_`date +"%Y%m%d_%H%M%S"`.log
sysbench $TEST_NAME $ARGS cleanup