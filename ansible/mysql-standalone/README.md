## MySQL 双主 + keepalived 环境安装

### MySQL 全局默认配置文件,不建议更改:
    # ansible/common/mysql/defaults/main.yml

    # MySQL 二进制包目录,MySQL的二进制包需要手动下载到此目录
    software_files_path: "/vagrant/downloads"
    # MySQL 安装目录
    software_install_path: "/usr/local"

    mysql_version: "5.7.20"
    mysql_package: "mysql-5.7.20-linux-glibc2.12-x86_64.tar.gz"

    mysql_dirname: "mysql-{{ mysql_version }}"
    mysql_basedir: "{{ software_install_path }}/mysql"

    # 端口号
    mysql_port: "3306"
    mysql_user: "mysql"
    # root 密码
    mysql_password: "abcd@1234"
    # MySQL全局 Datahome
    mysql_datahome: "/data/mysql"
    # MySQL实例 Datahome,使用端口号
    mysql_portdir: "{{ mysql_datahome }}/{{ mysql_port }}"
    mysql_datadir: "{{ mysql_portdir }}/data"
    mysql_sock: "/tmp/mysql{{ mysql_port }}.sock"

    # 多实例service name,用于 systemctl start mysql_servicename
    mysql_servicename : "mysql{{ mysql_port }}"

    mysql_innodb_buffer_pool_size: "32M"


### MySQL roles配置文件,可自行配置,安装时优先生效:
    # ansible/common/mysql/defaults/main.yml

    # MySQL 实例端口
    mysql_port: 3306
    # root 密码
    mysql_password: aaaaaa

### MySQL 多实例目录结构
    /data/mysql
    ├── 3306
    │   ├── data
    │   │   ├── auto.cnf
    │   │   ├── error.log
    │   │   ├── ib_buffer_pool
    │   │   ├── ibdata1
    │   │   ├── ib_logfile0
    │   │   ├── ib_logfile1
    │   │   ├── ib_logfile2
    │   │   ├── ibtmp1
    │   │   ├── mysql
    │   │   ├── performance_schema
    │   │   ├── slow.log
    │   │   └── sys
    │   ├── logs
    │   │   ├── mysql-bin.000001
    │   │   └── mysql-bin.index
    │   ├── my.cnf
    │   ├── mysqld.pid
    │   └── tmp
    ├── 3307
    │   ├── data
    │   │   ├── auto.cnf
    │   │   ├── error.log
    │   │   ├── ib_buffer_pool
    │   │   ├── ibdata1
    │   │   ├── ib_logfile0
    │   │   ├── ib_logfile1
    │   │   ├── ib_logfile2
    │   │   ├── ibtmp1
    │   │   ├── mysql
    │   │   ├── performance_schema
    │   │   ├── slow.log
    │   │   └── sys
    │   ├── logs
    │   │   ├── mysql-bin.000001
    │   │   └── mysql-bin.index
    │   ├── my.cnf
    │   ├── mysqld.pid
    │   └── tmp
    └── start_mysql.sh


### 用法:
    # 修改主机地址
    vi hosts
    [node]
    192.168.1.101

	# 默认安装: 3306 实例
	ansible-playbook -i hosts site.yml

	# 安装多实例
	# vi site.yml
	  roles:
    - { role: mysql , mysql_port: 3306 }
    - { role: mysql , mysql_port: 3307 }


### MySQL 启动方式
    # 1:
    /usr/local/mysql/bin/mysqld --defaults-file=/data/mysql/3306/my.cnf
    # 2:
    /data/mysql/start_mysql.sh 3306
    # 3:
    systemctl start mysql3306