
-- 后端MySQL应用帐号
delete from mysql_users where username = 'admin';
INSERT INTO mysql_users(username,password,default_hostgroup) VALUES ('admin','aaaaaa', 330710);
LOAD MYSQL USERS TO RUNTIME;
SAVE MYSQL USERS TO DISK;

INSERT INTO mysql_servers (hostname,hostgroup_id,port,weight) VALUES ('192.168.1.201',330710,'3307',1);

LOAD MYSQL SERVERS TO RUNTIME;
SAVE MYSQL SERVERS TO DISK;


