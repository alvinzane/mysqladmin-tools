create database {{ DBName }};
grant all privileges on {{ DBName }}.* to '{{ DBUser }}'@'%' identified by '{{ DBPassword }}';