#!/bin/sh
BACKUP_BIN=/usr/local/mysql/bin/mysqlbinlog
LOCAL_BACKUP_DIR=/data/backup/mysql/binlog_{{mysql_port}}
BACKUP_LOG=/data/backup/mysql/binlog_{{mysql_port}}/backup_{{mysql_port}}.log

FIRST_BINLOG=mysql-bin.000001
#time to wait before reconnecting after failure
SLEEP_SECONDS=10
##create local_backup_dir if necessary
mkdir -p ${LOCAL_BACKUP_DIR}
cd ${LOCAL_BACKUP_DIR}
##  Function while loop ， After the connection is disconnected, wait for the specified time. ， Reconnect
while :
do
 if [ `ls -A "${LOCAL_BACKUP_DIR}" |wc -l` -eq 0 ];then
 LAST_FILE=${FIRST_BINLOG}
 else
 LAST_FILE=`ls -l ${LOCAL_BACKUP_DIR} | grep -v backuplog |tail -n 1 |awk '{print $9}'`
 fi
 source /etc/binlog_server_{{mysql_port}}.conf
 ${BACKUP_BIN} --raw --read-from-remote-server --stop-never --host=${REMOTE_HOST} --port=${REMOTE_PORT} --user=${REMOTE_USER} --password=${REMOTE_PASS} ${LAST_FILE}
 echo "`date +"%Y/%m/%d %H:%M:%S"` mysqlbinlog Stop it ， Return code ：$?" | tee -a ${BACKUP_LOG}
 echo "${SLEEP_SECONDS} After the second connect and continue to backup " | tee -a ${BACKUP_LOG}
 sleep ${SLEEP_SECONDS}
done
