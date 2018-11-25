# MySQL DBA 工具 之 proxysql

自动化安装proxysql

## hosts
```
[mysql_server]
192.168.1.101
192.168.1.102
192.168.1.103

[proxy_server]
192.168.1.100
```

## 常用命令
```
# 详细:stats_mysql_connection_pool + mysql_servers + stats_mysql_commands_counters
watch -n 1 'mysql -h 127.0.0.1 -P 6032 -uadmin -padmin -t -e "select * from stats_mysql_connection_pool order by hostgroup,srv_host ;" -e " select hostgroup_id,hostname,status,weight,comment from mysql_servers order by hostgroup_id,hostname ;" -e "select * from stats_mysql_commands_counters where Command in (\"BEGIN\",\"COMMIT\",\"SELECT\",\"SELECT_FOR_UPDATE\",\"DELETE\",\"INSERT\",\"UPDATE\");"'

# 精简:stats_mysql_connection_pool + mysql_servers
watch -n 1 'mysql -h 127.0.0.1 -P 6032 -uadmin -padmin -t -e "select hostgroup,srv_host,srv_port,status from stats_mysql_connection_pool order by hostgroup,srv_host ;" -e " select hostgroup_id,hostname,status from mysql_servers order by hostgroup_id,hostname ;" '

# 精简:stats_mysql_connection_pool + stats_mysql_commands_counters
watch -n 1 'mysql -h 127.0.0.1 -P 6032 -uadmin -padmin -t -e "select hostgroup,srv_host,srv_port,status from stats_mysql_connection_pool order by hostgroup,srv_host ;" -e "select * from stats_mysql_commands_counters where Command in (\"BEGIN\",\"COMMIT\",\"SELECT\",\"SELECT_FOR_UPDATE\",\"DELETE\",\"INSERT\",\"UPDATE\");" '

watch -n 1 'mysql -S /tmp/mysql5506.sock -paaaaaa -e "show global status like \"wsrep_local_state_comment\"";'
watch -n 1 'tail general.log'
watch -n 1 'mysql -h 192.168.1.100 -P6033 -uapp -paaaaaa -e "begin;SELECT @@hostname;commit;"'
watch -n 1 'mysql -S /tmp/mysql5506.sock -paaaaaa -e "show global status like \"wsrep%\";"'

```

## 连接数测试
```
ansible -i hosts mysql_server -m shell -a "mysql -S /tmp/mysql5506.sock -paaaaaa -e 'set global max_connections=20'"
ansible -i hosts mysql_server -m shell -a "mysql -S /tmp/mysql5506.sock -paaaaaa -e 'show global variables like \"max_connections\"' 2>/dev/null"

mysql -h 127.0.0.1 -P 6032 -uadmin -padmin -e "update mysql_users set max_connections=50;LOAD MYSQL USERS TO RUNTIME;"
mysql -h 127.0.0.1 -P 6032 -uadmin -padmin -e "update mysql_servers set max_connections=10;LOAD MYSQL SERVERS TO RUNTIME;"

python3 /vagrant/mysqladmin-tools/ansible/sites/mysql-toolkits/script/multi_thread_run.py -c 20 -e "mysql -h 127.0.0.1 -P 6033 -uapp5506 -paaaaaa -e 'select sleep(5);select @@server_id;' |grep ERROR"
python3 /vagrant/mysqladmin-tools/ansible/sites/mysql-toolkits/script/multi_thread_run.py -c 20 -e "mysql -h 192.168.1.103 -P 5506 -uapp5506 -paaaaaa -e 'select sleep(3);select @@server_id' |grep ERROR"

watch -n 1 'mysql -h 192.168.1.100 -P 6033 -uapp5506 -paaaaaa -e "select THREAD_ID,PROCESSLIST_ID,PROCESSLIST_USER,PROCESSLIST_TIME,PROCESSLIST_STATE,PROCESSLIST_INFO from performance_schema.threads where TYPE=\"FOREGROUND\" and  PROCESSLIST_INFO not like \"%PROCESSLIST_INFO%\";"'

```

### 测试结论:
  - multi_thread_run.py 直接数据库时,会不断创建新的连接,general_log中可以观察到connetcion Id 一直增长;
  - multi_thread_run.py 连接proxy时,会重复利用"连接池"中的连接,general_log中的Id不会增长
  - 并发超过 mysql_users.max_connections时,proxysql直接返回错误:ERROR 1226 (42000): User 'app5506' has exceeded the 'max_user_connections' resource (current value: 5)
  - 并发超过 mysql_servers.max_connections时,proxysql会控制后端mysql连接数量,排队处理请求,
  - 如果mysql_servers.max_connections超后端连接数,会报错:ERROR 9001 (HY000) at line 1 at line 1: Max connect timeout reached while reaching hostgroup 550620 after 11070ms
  - 并发超过后端mysql的max_connections,proxysql返回超过最大连接数:ERROR 1040 (HY000): Too many connectionsnon-zero return code

### 遇到的坑:
```
update mysql_servers set max_connections=10;LOAD MYSQL SERVERS TO RUNTIME;
在使用mysql_galera_hostgroups,mysql_group_replication_hostgroups时,系统会产生 backup_writer_hostgroup, reader_hostgroup,LOAD TO RUNTIME后,不会更新这两个组的max_connections.
害我测试一下午,各种怀疑人生 !!!
```
