# MySQL PXC 自动化安装

## 环境
```
| Hosts      | IP            | 说明                  |
| ---------- | ------------- | --------------------- |
| node0      | 192.168.1.100 | Proxysql              |
| node1      | 192.168.1.101 | PXC-Node              |
| node2      | 192.168.1.102 | PXC-Node              |
| node3      | 192.168.1.103 | PXC-Node              |
```
## 用法:

	# 安装 MySQL
	ansible-playbook -i hosts site.yml
	# 安装 MGR
	ansible-playbook -i hosts setup_pxc.yml

## 主配置文件:

    var/main.yml

## 启动mysql:

	ansible all -i hosts -m shell -a "/data/mysql/start_mysql.sh 3309"

## ProxySQL 状态查看
```
watch -n 1 'mysql -h 127.0.0.1 -P 6032 -uadmin -padmin -t -e "select * from stats_mysql_connection_pool order by hostgroup,srv_host ;" -e " select hostgroup_id,hostname,status,weight,comment from mysql_servers order by hostgroup_id,hostname ;" -e "select * from stats_mysql_commands_counters where Command in (\"BEGIN\",\"COMMIT\",\"SELECT\",\"SELECT_FOR_UPDATE\",\"DELETE\",\"INSERT\",\"UPDATE\");"'

watch -n 1 'mysql -h 127.0.0.1 -P 6032 -uadmin -padmin -t -e "select hostgroup,srv_host,srv_port,status from stats_mysql_connection_pool order by hostgroup,srv_host ;" -e " select hostgroup_id,hostname,status,weight,comment from mysql_servers order by hostgroup_id,hostname ;" -e "select command,total_time_us,total_cnt  from stats_mysql_commands_counters where Command in (\"BEGIN\",\"COMMIT\",\"SELECT\",\"SELECT_FOR_UPDATE\",\"DELETE\",\"INSERT\",\"UPDATE\");"'

watch -n 2 'tail -n30 general.log'

watch -n 2 'mysql -h 192.168.1.102 -P6033 -uapp -paaaaaa -e "begin;SELECT @@hostname;commit;"'
```