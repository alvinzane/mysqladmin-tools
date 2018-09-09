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

    sshpass -p 'vagrant' ssh-copy-id  -o StrictHostKeyChecking=no 192.168.20.103
    sshpass -p 'vagrant' ssh-copy-id  -o StrictHostKeyChecking=no 192.168.20.201

## MHA 脚本
```
# 状态查看
masterha_check_ssh --conf=/etc/masterha/app1.cnf
masterha_check_repl --conf=/etc/masterha/app1.cnf
masterha_check_status --conf=/etc/masterha/app1.cnf

# 手动绑定vip
/sbin/ifconfig enp0s8:1 192.168.20.10/24
/sbin/ifconfig enp0s8:2 192.168.20.20/24
/sbin/ifconfig enp0s8:1 down

# 开启MHA Manager监控
nohup masterha_manager --conf=/etc/masterha/app1.cnf --remove_dead_master_conf --ignore_last_failover < /dev/null > /var/log/masterha/app1/manager.log 2>&1 &

# 手动切换
# https://github.com/yoshinorim/mha4mysql-manager/wiki/masterha_master_switch
masterha_master_switch  --master_state=alive --conf=/etc/masterha/app2.cnf --new_master_host=192.168.20.102 --new_master_port=3307
masterha_master_switch --master_state=dead --conf=/etc/masterha/app1.cnf --dead_master_host=192.168.20.101 --dead_master_port=3306 --new_master_host=192.168.20.102 --new_master_port=3306 --ignore_last_failover

```

