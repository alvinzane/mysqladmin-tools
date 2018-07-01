alter user user() identified by '{{mysql_password}}';
create user 'admin'@'192.168.%.%' identified by '{{mysql_password}}';
grant all on *.* to 'admin'@'192.168.%.%';

INSTALL PLUGIN rpl_semi_sync_master SONAME 'semisync_master.so';
INSTALL PLUGIN rpl_semi_sync_slave SONAME 'semisync_slave.so';