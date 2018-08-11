-- 修改 root 密码
alter user user() identified by '{{mysql_password}}';

-- 创建 admin 用户
create user 'admin'@'192.168.%.%' identified by '{{mysql_password}}';
grant all on *.* to 'admin'@'192.168.%.%';

-- 创建 app 用户
create user 'app'@'192.168.%.%' identified by '{{mysql_password}}';
grant select,insert,update,delete,index,create,drop on *.* to 'app'@'192.168.%.%';
