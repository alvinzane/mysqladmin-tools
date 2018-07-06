#!/usr/bin/env bash
# test mode {seqwr, seqrd, seqrewr, rndrd, rndwr, rndrw}
export LD_LIBRARY_PATH=/usr/local/mysql/lib/

THREADS=$1
MODE=rndwr
TEST_NAME=fileio

ARGS="
--file-num=2
--file-test-mode=$MODE
--report-interval=10
--threads=$THREADS
--time=30
"
sysbench $TEST_NAME $ARGS prepare
sysbench $TEST_NAME $ARGS run | tee -a  ~/log/fileio_"$MODE"_X_"$THREADS"_`date +"%Y%m%d_%H%M%S"`.log
sysbench $TEST_NAME $ARGS cleanup