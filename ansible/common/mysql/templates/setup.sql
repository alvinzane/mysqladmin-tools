alter user user() identified by '{{mysql_password}}';
create user 'admin'@'192.168.%.%' identified by '{{mysql_password}}';
grant all on *.* to 'admin'@'192.168.%.%';
