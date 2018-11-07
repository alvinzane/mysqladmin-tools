SET SQL_LOG_BIN=0;

create user {{ mysql_repl_user }}@'192.168.%.%' identified by '{{ mysql_repl_password }}';
grant replication slave on *.* to {{mysql_repl_user}}@'192.168.%.%';

create user monitor@'192.168.%.%' identified by 'monitorpwd';
grant replication client  on *.* to monitor@'192.168.%.%';

SET SQL_LOG_BIN=1;

