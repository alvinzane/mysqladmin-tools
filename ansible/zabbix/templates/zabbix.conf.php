<?php
// Zabbix GUI configuration file.
global $DB;

$DB['TYPE']     = 'MYSQL';
$DB['SERVER']   = '192.168.1.100';
$DB['PORT']     = '3306';
$DB['DATABASE'] = 'zabbix34';
$DB['USER']     = 'zabbix';
$DB['PASSWORD'] = 'zabbixx';

// Schema name. Used for IBM DB2 and PostgreSQL.
$DB['SCHEMA'] = '';

$ZBX_SERVER      = '192.168.1.104';
$ZBX_SERVER_PORT = '10051';
$ZBX_SERVER_NAME = 'Zabbix server';

$IMAGE_FORMAT_DEFAULT = IMAGE_FORMAT_PNG;
