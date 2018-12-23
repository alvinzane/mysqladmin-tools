# MySQL DBA 工具 之 zabbix安装

自动化安装zabbix + fpmmm及其依赖.

## hosts
```
[zabbix_server]
192.168.1.105

[zabbix_agent]
192.168.1.101
192.168.1.102
192.168.1.103
```

## 安装说明

### MySQL集群安装:
 - mysql-pxc
 - mysql-mgr
 - mysql-multi-tier-slave-gtid


## 默认配置:
### zabbix server

```
# var\main.yml

# MySQL管理员帐号,用于创建zabbix帐号及监控帐号
mysql_admin_user: admin
mysql_admin_pwd: aaaaaa

DBHost: 127.0.0.1
DBName: zabbix
DBUser: zabbix
DBPassword: zabbixx
DBPort: 3306
```


### zabbix agent & fpmmm

```
# MySQL管理员帐号,用于创建fpmmm监控帐号
mysql_admin_user: admin
mysql_admin_pwd: aaaaaa

fpmmm_user: fpmmm_agent
fpmmm_pwd: fpmmm4pwd
```

### 路径说明
```
# 安装路径
/usr/local/zabbix
/opt/fpmmm

# 配置文件
/etc/zabbix
/etc/fpmmm

# 日志
/var/log/zabbix
/var/log/fpmmm
```

## 配置修改方法
 - 直接修改 var\main.yml 文件
 - 修改site.yml中的 role,如:
```
  roles:
    - zabbix-agent
    - { role: fpmmm, mysql_admin_user: root }
```

## 安装步骤

```
# 安装前请确保,ZabbixServer的MySQL和Agent节点的MySQL处理运行状态
ansible-playbook -i hosts site.yml
ansible-playbook -i hosts setup_zabbix_web.yml
```

## fpmmm验证
```
# fpmmm
/opt/fpmmm/bin/fpmmm --config=/etc/fpmmm/fpmmm.conf
cat /var/log/fpmmm/fpmmm.log

crontab -l # 查看定时任务
```

## 启动方法
```
# zabbix 由于国内网络问题,均采用源码安装方式,并自动配置了systemd服务
systemctl start zabbix-server
systemctl start zabbix-agent
```

## zabbix config备份
```
mysqldump -uroot -p --databases zabbix  --ignore-table=zabbix.alerts --ignore-table=zabbix.auditlog  --ignore-table=zabbix.events  --ignore-table=zabbix.history  --ignore-table=zabbix.history_log --ignore-table=zabbix.str --ignore-table=zabbix.str_sync  --ignore-table=zabbix.sync  --ignore-table=zabbix.text --ignore-table=zabbix.uint  --ignore-table=zabbix.uint_sync  --ignore-table=zabbix.node_cksum  --ignore-table=zabbix.proxy_dhistory --ignore-table=zabbix.proxy_history --ignore-table=zabbix.service_alarms --ignore-table=zabbix.services_times --ignore-table=zabbix.trends --ignore-table=zabbix.trends_uint > zabbix_config.sql
```