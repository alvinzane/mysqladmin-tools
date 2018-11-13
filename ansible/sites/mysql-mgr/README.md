# MySQL MGR 自动化安装

## 环境
```
| Hosts      | IP            | 说明                  |
| ---------- | ------------- | --------------------- |
| node1      | 192.168.1.101| MGR-Node              |
| node2      | 192.168.1.102| MGR-Node              |
| node3      | 192.168.1.103| MGR-Node              |
```
## 用法:

	# 安装 MySQL
	ansible-playbook -i hosts site.yml
	# 安装 MGR
	ansible-playbook -i hosts setup_mgr.yml

## 主配置文件:

    var/main.yml

## 启动MGR:
```
# first node:
systemctl start mysql7706
mysql -S /tmp/mysql7706.sock -p
CHANGE MASTER TO MASTER_USER='repl', MASTER_PASSWORD='repl@1234' FOR CHANNEL 'group_replication_recovery';
SET GLOBAL group_replication_bootstrap_group = ON;
START GROUP_REPLICATION;
SET GLOBAL group_replication_bootstrap_group = off;

# other node:
systemctl start mysql7706
mysql -S /tmp/mysql7706.sock -p
CHANGE MASTER TO MASTER_USER='repl', MASTER_PASSWORD='repl@1234' FOR CHANNEL 'group_replication_recovery';
START GROUP_REPLICATION;
```

## 状态查看
```
# 状态
mysql -S /tmp/mysql7706.sock -paaaaaa -e "select * from sys.gr_member_routing_candidate_status"

# 成员
mysql -S /tmp/mysql7706.sock -paaaaaa -e "select * from performance_schema.replication_group_members"
```