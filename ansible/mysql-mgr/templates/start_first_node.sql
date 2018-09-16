
CHANGE MASTER TO MASTER_USER='{{ mysql_repl_user }}', MASTER_PASSWORD='{{ mysql_repl_password }}' FOR CHANNEL 'group_replication_recovery';

SET GLOBAL group_replication_bootstrap_group = ON;
START GROUP_REPLICATION;
SET GLOBAL group_replication_bootstrap_group = off;