# MySQL 一主多从 + MHA 环境安装

## 环境
```
| Hosts      | IP            | 角色                            |
| ---------- | ------------- | ------------------------------- |
| MHA-Manager| 192.168.1.100| Monitor host                    |
| VIP        | 192.168.1.10 | VIP                             |
| master     | 192.168.1.101| Master and MHA-Node             |
| slave1     | 192.168.1.102| Slave  and MHA-Node             |
| slave2     | 192.168.1.103| Slave  and MHA-Node             |
```
## 用法:

	# 安装 MySQL
	ansible-playbook -i hosts site.yml
	# 配置 MHA manager
	ansible-playbook -i hosts setup_mha_manager.yml
	# 配置 MHA node
	ansible-playbook -i hosts setup_mha_node.yml

## 主配置文件:

    var/main.yml

## 启动mysql:

	ansible all -i hosts -m shell -a "/data/mysql/start_mysql.sh 3309"

## 检查Slave Status:

	ansible all -i hosts -m shell -a "mysql -S /tmp/mysql3306.sock -paaaaaa -e 'show slave status\G'"

## 测试方法

## 参考raw安装

    sshpass -p 'vagrant' ssh-copy-id  -o StrictHostKeyChecking=no 192.168.1.103
    sshpass -p 'vagrant' ssh-copy-id  -o StrictHostKeyChecking=no 192.168.1.201

## MHA 脚本
```
# 状态查看
masterha_check_ssh --conf=/etc/masterha/app1.cnf
masterha_check_repl --conf=/etc/masterha/app1.cnf
masterha_check_status --conf=/etc/masterha/app1.cnf

# 手动绑定vip
/sbin/ifconfig enp0s8:1 192.168.1.10/24
/sbin/ifconfig enp0s8:2 192.168.1.20/24
/sbin/ifconfig enp0s8:1 down

# 开启MHA Manager监控
masterha_manager --conf=/etc/masterha/app1.cnf --remove_dead_master_conf --ignore_last_failover &
nohup masterha_manager --conf=/etc/masterha/app1.cnf --remove_dead_master_conf --ignore_last_failover < /dev/null > /var/log/masterha/manager_app1.log 2>&1 &

# 手动切换
# https://github.com/yoshinorim/mha4mysql-manager/wiki/masterha_master_switch
masterha_master_switch  --master_state=alive --conf=/etc/masterha/app1.cnf --new_master_host=192.168.1.102 --new_master_port=3306
masterha_master_switch --master_state=dead --conf=/etc/masterha/app1.cnf --dead_master_host=192.168.1.101 --dead_master_port=3307 --new_master_host=192.168.1.102 --new_master_port=3307 --ignore_last_failover

```

## 注意事项
 - mha failover后,会自动把master节点从配置文件中删除,集群修复后,需要人工修改配置文件.
 - 手动故障切换后,需要人工修改配置文件,移出指定节点.