<?php
// Zabbix GUI configuration file.
global $DB;

$DB['TYPE']     = 'MYSQL';
$DB['SERVER']   = '{{ DBHost }}';
$DB['PORT']     = '{{ DBPort }}';
$DB['DATABASE'] = '{{ DBName }}';
$DB['USER']     = '{{ DBUser }}';
$DB['PASSWORD'] = '{{ DBPassword }}';

// Schema name. Used for IBM DB2 and PostgreSQL.
$DB['SCHEMA'] = '';

$ZBX_SERVER      = '{{ ansible_host }}';
$ZBX_SERVER_PORT = '10051';
$ZBX_SERVER_NAME = 'Zabbix server';

$IMAGE_FORMAT_DEFAULT = IMAGE_FORMAT_PNG;
