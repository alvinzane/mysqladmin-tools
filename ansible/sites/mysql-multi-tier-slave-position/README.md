# MySQL 一主多从 级联复制

## 环境
```
| Hosts      | IP            | 角色                |
| ---------- | ------------- | ------------------- |
| master     | 192.168.1.101| Master              |
| slave1     | 192.168.1.102| Slave-Master        |
| slave2     | 192.168.1.103| Slave               |
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




