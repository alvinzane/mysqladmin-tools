# MySQL DBA 工具 之 ansible

## 介绍
MySQL ansible roles 是提供给MySQL DBA及学习爱好者的一个基于ansible的快速环境搭建工具集.

## Windows 环境配置

### 安装virtualbox:
    官方网址:
    https://www.virtualbox.org/wiki/Downloads

### 安装vagrant:
    官方网址:
    https://www.vagrantup.com/downloads.html
    配置文件参考:
    mysqladmin-tools/ansible/files/Vagrantfile

### 安装配置ansible
    vagrant up
    vagrant ssh ansible_node
    yum -y install ansible sshpass

    vi /etc/ansible/hosts
    [dev_hosts]
    192.168.20.100
    192.168.20.101
    192.168.20.102
    192.168.20.103

    # 设置 SSH 公钥认证,
    ssh-keygen -t rsa
    # 方式一:
    ansible -i hosts all -u root -m copy -a "src=/root/.ssh/id_rsa.pub dest=/tmp/id_rsa.pub" --ask-pass -c paramiko
    ansible -i hosts all -u root -m shell -a "cat /tmp/id_rsa.pub >> /root/.ssh/authorized_keys" --ask-pass -c paramiko

    # 方式二:
    sshpass -p vagrant ssh-copy-id -o StrictHostKeyChecking=no 192.168.1.101
    sshpass -p vagrant ssh-copy-id -o StrictHostKeyChecking=no 192.168.1.102
    sshpass -p vagrant ssh-copy-id -o StrictHostKeyChecking=no 192.168.1.103

    # 验证方法
    ansible -i hosts all -m ping

## 安装mysqladmin-tools
    git clone mysqladmin-tools.git

### 配置ansible role path

    # 将common roles 路径加到 roles_path中
    grep roles_path /etc/ansible/ansible.cfg
    roles_path    = /etc/ansible/roles:/usr/share/ansible/roles:/vagrant/mysqladmin-tools/ansible/common

## 使用mysqladmin-tools

### mysql-standalone 独立MySQL安装
    vagrant ssh ansible_node
    cd /vagrant/mysqladmin-tools/ansible/mysql-standalone
    # 详细参数见 [mysql-standalone/README.md]
    ansible-playbook -i hosts site.yml

### mysql-mm-keepalived MySQL双主+keepalived高可用
    cd /vagrant/mysqladmin-tools/ansible/mysql-standalone
    # 详细参数见 [mysql-mm-keepalived/README.md]
    ansible-playbook -i hosts site.yml
