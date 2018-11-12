CREATE USER '{{fpmmm_user}}'@'127.0.0.1' IDENTIFIED BY '{{fpmmm_pwd}}';
GRANT PROCESS ON *.* TO '{{fpmmm_user}}'@'127.0.0.1';
GRANT REPLICATION CLIENT ON *.* TO '{{fpmmm_user}}'@'127.0.0.1';
GRANT SELECT ON `mysql`.`user` TO '{{fpmmm_user}}'@'127.0.0.1';
