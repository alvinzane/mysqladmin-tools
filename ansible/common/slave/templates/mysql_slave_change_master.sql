change master to
    master_host='{{master_ip}}',
    master_port={{mysql_port}},
    master_user='{{mysql_repl_user}}',
    master_password='{{mysql_repl_password}}',
    master_auto_position=1;

start slave;