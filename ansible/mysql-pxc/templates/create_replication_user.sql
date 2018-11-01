SET SQL_LOG_BIN=0;

create user {{ mysql_repl_user }}@'192.168.%.%' identified by '{{ mysql_repl_password }}';
grant replication slave on *.* to {{ mysql_repl_user }}@'192.168.%.%';

create user {{ wsrep_sst_auth_user }}@'localhost' identified by '{{ wsrep_sst_auth_pwd }}';
grant reload,lock tables,replication client,process  on *.* to {{ wsrep_sst_auth_user }}@'192.168.%.%';

SET SQL_LOG_BIN=1;
