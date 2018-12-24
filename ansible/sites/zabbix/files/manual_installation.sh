# zabbix server安装(Centos7.x)
yum install -y php httpd

# 安装zabbix官方yum源
rpm -ivh https://repo.zabbix.com/zabbix/3.0/rhel/7/x86_64/zabbix-release-3.0-1.el7.noarch.rpm

# 安装zabbix server（使用MySQL作为数据存储）
yum install zabbix-server-mysql zabbix-web-mysql

# 创建zabbix数据库
mysql -u root -p
mysql> create database zabbix character set utf8 collate utf8_bin;
mysql> grant all privileges on zabbix.* to 'zabbix'@'192.168.0.%' identified by 'zabbix';

# 导入数据表及初始数据
zcat /usr/share/doc/zabbix-server-mysql-3.2.*/create.sql.gz | mysql -u zabbix -p

# 修改zabbix_server.conf配置文件
vim /etc/zabbix/zabbix_server.conf
DBHost = 192.168.100.100
DBName = zabbix
DBUser = zabbix
DBPassword = zabbix

# 启动zabbix-server服务
systemctl enable zabbix-server
systemctl start zabbix-server

# 修改PHP配置
vim /etc/httpd/conf.d/zabbix.conf
php_value max_execution_time 300
php_value memory_limit 128M
php_value post_max_size 16M
php_value upload_max_filesize 2M
php_value max_input_time 300
php_value always_populate_raw_post_data -1
php_value date.timezone Asia/Shanghai

# 启动httpd服务
systemctl enable httpd
systemctl start httpd

## ===================

# zabbix agent安装(CentOS7.x/Windows2008R2)

CentOS7.x
# 安装zabbix官方yum源
rpm -ivh https://repo.zabbix.com/zabbix/3.0/rhel/7/x86_64/zabbix-release-3.0-1.el7.noarch.rpm

# 安装zabbix agent
yum install zabbix-agent

# 修改zabbix_agentd.conf配置文件
vim /etc/zabbix/zabbix_agentd.conf
Server=192.168.100.101
ServerActive=192.168.100.101
Hostname=192.168.100.100

# 启动zabbix-agent服务
systemctl enable zabbix-agent
systemctl start zabbix-agent

Windows2008R2
# 下载安装包并解压至"C:\Program Files\zabbix_agents_3.2.0.win"(解压目录不强制规定)
下载地址：http://www.zabbix.com/downloads/3.2.0/zabbix_agents_3.2.0.win.zip

# 修改zabbix_agentd.win.conf配置文件
Server=192.168.100.101
ServerActive=192.168.100.101
Hostname=192.168.100.102

# 注册windows服务
"C:\Program Files\zabbix_agents_3.2.0.win\bin\win64\zabbix_agentd.exe" --config "C:\Program Files\zabbix_agents_3.2.0.win\conf\zabbix_agentd.win.conf" --install

# 启动zabbix-agent服务
net start "Zabbix Agent"
