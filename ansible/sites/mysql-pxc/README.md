# MySQL PXC 自动化安装

## 环境
```
| Hosts      | IP            | 说明                  |
| ---------- | ------------- | --------------------- |
| node1      | 192.168.1.101 | PXC-Node              |
| node2      | 192.168.1.102 | PXC-Node              |
| node3      | 192.168.1.103 | PXC-Node              |
```
## 用法:

	# 安装 PXC
	ansible-playbook -i hosts site.yml
	# 配置 PXC
	ansible-playbook -i hosts setup_pxc.yml

## 主配置文件:

    var/main.yml

## 启动PXC:

```
# first node:
/data/pxc/start_mysql.sh 5506 --wsrep-new-cluster

# other node:
/data/pxc/start_mysql.sh 5506
systemctl start mysql5506
```

## 查看状态
```
mysql -S /tmp/mysql5506.sock -paaaaaa -e "show global status like 'wsrep%'"
```