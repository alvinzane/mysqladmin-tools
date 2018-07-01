# MySQL 双主 + keepalived 环境安装

## 用法:

    # 生产环境
	ansible-playbook -i inventories/production/hosts site.yml

	# 测试环境
	ansible-playbook -i inventories/staging/hosts site.yml

## 主配置文件:

    var/main.yml

## 启动mysql:

	ansible all -i hosts -m shell -a "/data/mysql/start_mysql.sh 3309"

## 检查Slave Status:

	ansible all -i hosts -m shell -a "mysql -S /tmp/mysql3306.sock -paaaaaa -e 'show slave status\G'"

## 测试方法

    # node1
    systemctl start keepalived
    tailf /var/log/messages

    # node2
    systemctl start keepalived
    tailf /var/log/messages

    # vip
    mysql -S /tmp/mysql3306.sock -p
