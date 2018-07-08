#!/usr/bin/env bash
# test mode {seqwr, seqrd, seqrewr, rndrd, rndwr, rndrw}
export LD_LIBRARY_PATH=/usr/local/mysql/lib/

# 第一个参数为线程数,默认1
if [ -z $1 ]; then THREADS=1; else THREADS=$1; fi
# 第二个参数为测试时间,默认1分钟
if [ -z $2 ]; then TIME=30; else TIME=$2; fi
MODE=seqwr
TEST_NAME=fileio

ARGS="
--file-num=2
--file-test-mode=$MODE
--report-interval=10
--threads=$THREADS
--time=$TIME
"
sysbench $TEST_NAME $ARGS prepare
sysbench $TEST_NAME $ARGS run | tee -a  ~/log/fileio_"$MODE"_X_"$THREADS"_`date +"%Y%m%d_%H%M%S"`.log
sysbench $TEST_NAME $ARGS cleanup