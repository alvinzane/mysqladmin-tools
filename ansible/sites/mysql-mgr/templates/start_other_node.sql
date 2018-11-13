CHANGE MASTER TO MASTER_USER='{{ mysql_repl_user }}', MASTER_PASSWORD='{{ mysql_repl_password }}' FOR CHANNEL 'group_replication_recovery';
START GROUP_REPLICATION;
