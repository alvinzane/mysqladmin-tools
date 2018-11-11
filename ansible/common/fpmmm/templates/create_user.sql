CREATE USER 'fpmmm'@'127.0.0.1' IDENTIFIED BY 'secret';
GRANT PROCESS ON *.* TO 'fpmmm'@'127.0.0.1';
GRANT REPLICATION CLIENT ON *.* TO 'fpmmm'@'127.0.0.1';
GRANT SELECT ON `mysql`.`user` TO 'fpmmm'@'127.0.0.1';
