# MySQL 一主多从 级联复制

## playbooks_variables
    https://docs.ansible.com/ansible/latest/user_guide/playbooks_variables.html
## 环境
```
| Hosts      | IP            | 角色                |
| ---------- | ------------- | ------------------- |
| master     | 192.168.20.101| Master              |
| slave1     | 192.168.20.102| Slave-Master        |
| slave2     | 192.168.20.103| Slave               |

# hosts 配置
$ cat hosts
[mysql-servers]
192.168.20.101
192.168.20.102 slave=True master_ip=192.168.20.101
192.168.20.103 slave=True master_ip=192.168.20.102

# MySQL 配置
$ cat var/main.yml
mysql_repl_user: repl
mysql_repl_password: repl@1234
mysql_port: 3310
mysql_password: aaaaaa
gtid: True
semi_replication: True
```

## 用法:

    # 生产环境
	ansible-playbook -i inventories/production/hosts site.yml

	# 测试环境
	ansible-playbook -i inventories/staging/hosts site.yml

## 主配置文件:

    var/main.yml

## 启动mysql:

	ansible all -i hosts -m shell -a "/data/mysql/start_mysql.sh 3310"

## 检查Slave Status:

	ansible all -i hosts -m shell -a "mysql -S /tmp/mysql3310.sock -paaaaaa -e 'show slave status\G'"

## 测试方法




