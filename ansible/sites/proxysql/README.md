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