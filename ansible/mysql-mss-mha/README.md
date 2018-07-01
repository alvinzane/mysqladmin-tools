# MySQL 一主多从 + MHA 环境安装(未完成)

## 环境
```
| Hosts      | IP            | 角色                            |
| ---------- | ------------- | ------------------------------- |
| MHA-Manager| 192.168.20.100| Monitor host                    |
| VIP        | 192.168.20.10 | VIP                             |
| master     | 192.168.20.101| Master and MHA-Node             |
| slave1     | 192.168.20.102| Slave  and MHA-Node             |
| slave2     | 192.168.20.103| Slave  and MHA-Node             |
```
## 用法:

    # 生产环境
	ansible-playbook -i inventories/production/hosts mysql-servers.yml

	# 测试环境
	ansible-playbook -i inventories/staging/hosts mysql-servers.yml

## 主配置文件:

    var/main.yml

## 启动mysql:

	ansible all -i hosts -m shell -a "/data/mysql/start_mysql.sh 3309"

## 检查Slave Status:

	ansible all -i hosts -m shell -a "mysql -S /tmp/mysql3306.sock -paaaaaa -e 'show slave status\G'"

## 测试方法

## 参考raw安装

    sshpass -p 'vagrant' ssh-copy-id  -o StrictHostKeyChecking=no root@192.168.20.103



