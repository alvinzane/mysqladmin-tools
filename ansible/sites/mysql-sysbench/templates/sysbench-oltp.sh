#!/bin/bash
## 用sysbench执行MySQL OLTP基准测试的脚本。


export LD_LIBRARY_PATH=/usr/local/mysql/lib/

. ~/.bash_profile

# 需要启用DEBUG模式时将下面三行注释去掉即可
#set -u
#set -x
#set -e

BASEDIR="/home/sysbench"

# 并发压测的线程数，根据机器配置实际情况进行调整
RUN_NUMBER="16 32 64 128 256 512 1024"
TIME=1200
SLEEP=300

# 第一个参数为压测时间
if [ -z $1 ]; then TIME=${TIME}; else TIME=$1; fi
# 第二个参数为暂停时间
if [ -z $2 ]; then SLEEP=${SLEEP}; else SLEEP=$2; fi

round=1
# 一般至少跑3轮测试
while [ ${round} -lt 3 ]
do
    round_dir="${BASEDIR}/`date +%Y%m%d`-logs-round${round}"
    mkdir -p ${round_dir}
    cd ${round_dir}

    for thread in `echo "${RUN_NUMBER}"`
    do
        ${BASEDIR}/sysbench-mysql-oltp.sh ${thread} ${TIME} 2> ${BASEDIR}/sysbench.log
    sleep ${SLEEP}
    done

    round=`expr ${round} + 1`
sleep ${SLEEP}
done
