
-- 监控帐号
UPDATE global_variables SET variable_value='monitor' WHERE variable_name='mysql-monitor_username';
UPDATE global_variables SET variable_value='monitorpwd' WHERE variable_name='mysql-monitor_password';
LOAD MYSQL VARIABLES TO RUNTIME;
SAVE MYSQL VARIABLES TO DISK;

-- 后端MySQL应用帐号
INSERT INTO mysql_users(username,password,default_hostgroup) VALUES ('app','{{mysql_password}}',500);
LOAD MYSQL USERS TO RUNTIME;
SAVE MYSQL USERS TO DISK;

-- Galera HG定义
{% for node in groups['pxc_node'] %}
INSERT INTO mysql_servers (hostname,hostgroup_id,port,weight) VALUES ('{{ node }}',520,'{{ mysql_port }}',1);
{% endfor %}
INSERT INTO mysql_galera_hostgroups(writer_hostgroup, backup_writer_hostgroup, reader_hostgroup, offline_hostgroup, active)
 VALUES (500,510,520,900,1);
LOAD MYSQL SERVERS TO RUNTIME;
SAVE MYSQL SERVERS TO DISK;

-- 读写分离
INSERT INTO mysql_query_rules (rule_id,active,match_digest,destination_hostgroup,apply)
VALUES
(1,1,'^SELECT.*FOR UPDATE$',500,1),
(2,1,'^SELECT',520,1);
LOAD MYSQL QUERY RULES TO RUNTIME;
SAVE MYSQL QUERY RULES TO DISK;
