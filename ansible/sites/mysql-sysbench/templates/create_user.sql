-- 修改 root 密码
alter user user() identified by '{{mysql_password}}';

-- 创建 admin 用户
create user 'admin'@'%' identified by '{{mysql_password}}';
grant all on *.* to 'admin'@'%' with GRANT OPTION;

-- 创建 app 用户
create user 'app{{mysql_port}}'@'192.168.%.%' identified by '{{mysql_password}}';
grant select,insert,update,delete,index,create,drop,alter on *.* to 'app{{mysql_port}}'@'192.168.%.%';
grant TRIGGER,EXECUTE  on *.* to 'app{{mysql_port}}'@'192.168.%.%';

CREATE USER 'fpmmm_agent'@'127.0.0.1' IDENTIFIED BY 'fpmmm4pwd';
GRANT PROCESS ON *.* TO 'fpmmm_agent'@'127.0.0.1';
GRANT REPLICATION CLIENT ON *.* TO 'fpmmm_agent'@'127.0.0.1';
GRANT SELECT ON `mysql`.`user` TO 'fpmmm_agent'@'127.0.0.1';
