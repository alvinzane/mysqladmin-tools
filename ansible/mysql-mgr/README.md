# MySQL MGR 自动化安装

## 环境
```
| Hosts      | IP            | 说明                  |
| ---------- | ------------- | --------------------- |
| node1      | 192.168.20.101| MGR-Node              |
| node2      | 192.168.20.102| MGR-Node              |
| node3      | 192.168.20.103| MGR-Node              |
```
## 用法:

	# 安装 MySQL
	ansible-playbook -i hosts site.yml
	# 安装 MGR
	ansible-playbook -i hosts setup_mgr.yml

## 主配置文件:

    var/main.yml

## 启动mysql:

	ansible all -i hosts -m shell -a "/data/mysql/start_mysql.sh 3309"
