
## Redis sentinel
```
ansible -i hosts sentinel_host -m shell -a "pkill redis-server;pkill redis-sentinel;"
ansible -i hosts sentinel_host -m shell -a "rm -rf /data/redis;rm -rf /usr/local/redis*;"
ansible -i hosts sentinel_host -m shell -a "rm -rf /data/redis;rm -rf /usr/local/redis*; rm -rf /etc/init.d/redis*;"
ansible -i hosts sentinel_host -m shell -a "/usr/local/redis/bin/redis-server /data/redis/6380/redis.conf;"
ansible -i hosts sentinel_host -m shell -a "/usr/local/redis/bin/redis-sentinel /data/redis/6380/sentinel.conf;"

# 初始化 主从
redis-cli -h 192.168.1.102 -p 6380 -a 123456  slaveof 192.168.1.101 6380
redis-cli -h 192.168.1.103 -p 6380 -a 123456  slaveof 192.168.1.101 6380
redis-cli -h 192.168.1.101 -p 6380 -a 123456  INFO replication

# 日志
tail -f /data/redis/6380/redis-sentinel.logs

# 模拟故障
redis-cli -h 192.168.1.101 -p 6380 -a 123456  shutdown

```

## consul
```
dig @192.168.1.100 -p 8600 w-6380-redis.service.consul
dig @192.168.1.100 -p 8600 r-6380-redis.service.consul

```

## named
```
参考资料:
http://blog.51cto.com/sweetpotato/1598225

# 安装
ansible-playbook -i host named.yml

# 测试
dig @192.168.1.101 www.mysqldba.com  # 内网主机都可以
ping www.mysqldba.com                # 需要指定 dns 服务器,named server上已经暴力修改 /etc/resolv.conf,可以直接测试
```

## inception
```
# 安装
ansible-playbook -i host inception.yml

# 启动
nohup inception --defaults-file=/etc/inception/inc.cnf &

# 测试
mysql -uroot -h127.0.0.1 -P6669 -e "inception get variables"
```