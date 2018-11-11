
-- 监控帐号
UPDATE global_variables SET variable_value='{{mysql_monitor_user}}' WHERE variable_name='mysql-monitor_username';
UPDATE global_variables SET variable_value='{{mysql_monitor_pwd}}' WHERE variable_name='mysql-monitor_password';
LOAD MYSQL VARIABLES TO RUNTIME;
SAVE MYSQL VARIABLES TO DISK;

-- 后端MySQL应用帐号
INSERT INTO mysql_users(username,password,default_hostgroup) VALUES ('{{mysql_app_user}}','{{mysql_app_pwd}}',{{mysql_port}}10);
LOAD MYSQL USERS TO RUNTIME;
SAVE MYSQL USERS TO DISK;

-- Galera HG定义
{% for node in groups['mysql_server'] %}
INSERT INTO mysql_servers (hostname,hostgroup_id,port,weight) VALUES ('{{ node }}',{{mysql_port}}10,'{{ mysql_port }}',1);
{% endfor %}

{% if rep_type == 'pxc' %}
INSERT INTO mysql_galera_hostgroups(writer_hostgroup, backup_writer_hostgroup, reader_hostgroup, offline_hostgroup, active, max_transactions_behind)
 VALUES ({{mysql_port}}10,{{mysql_port}}20,{{mysql_port}}30,{{mysql_port}}90,1,300);
{% endif %}

{% if rep_type == 'mgr' %}
INSERT INTO mysql_group_replication_hostgroups(writer_hostgroup, backup_writer_hostgroup, reader_hostgroup, offline_hostgroup, active, max_transactions_behind)
 VALUES ({{mysql_port}}10,{{mysql_port}}20,{{mysql_port}}30,{{mysql_port}}90,1,300);
{% endif %}

{% if rep_type == 'rep' %}
 INSERT INTO mysql_replication_hostgroups(writer_hostgroup, reader_hostgroup)
 VALUES ({{mysql_port}}10,{{mysql_port}}20);
{% endif %}

LOAD MYSQL SERVERS TO RUNTIME;
SAVE MYSQL SERVERS TO DISK;

-- 读写分离
INSERT INTO mysql_query_rules (rule_id,active,match_digest,destination_hostgroup,apply)
VALUES
(1,1,'^SELECT.*FOR UPDATE$',{{mysql_port}}10,1),
(2,1,'^SELECT',{{mysql_port}}20,1);
LOAD MYSQL QUERY RULES TO RUNTIME;
SAVE MYSQL QUERY RULES TO DISK;
