create user {{mysql_repl_user}}@'192.168.%.%' identified by '{{mysql_repl_password}}';
grant replication slave,replication client on *.* to {{mysql_repl_user}}@'192.168.%.%';

reset master;