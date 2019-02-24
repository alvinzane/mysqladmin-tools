
spider1 << EOF
DROP SERVER IF EXISTS sharding1;
CREATE SERVER sharding1
  FOREIGN DATA WRAPPER mysql
OPTIONS(
  HOST '192.168.1.201',
  DATABASE 'sharding',
  USER 'admin',
  PASSWORD 'aaaaaa',
  PORT 3307
);

DROP SERVER IF EXISTS sharding2;
CREATE SERVER sharding2
  FOREIGN DATA WRAPPER mysql
OPTIONS(
  HOST '192.168.1.202',
  DATABASE 'sharding',
  USER 'admin',
  PASSWORD 'aaaaaa',
  PORT 3307
);

DROP SERVER IF EXISTS sharding3;
CREATE SERVER sharding3
  FOREIGN DATA WRAPPER mysql
OPTIONS(
  HOST '192.168.1.203',
  DATABASE 'sharding',
  USER 'admin',
  PASSWORD 'aaaaaa',
  PORT 3307
);

CREATE DATABASE IF NOT EXISTS sharding;
CREATE  TABLE sharding.sbtest
(
  id int(10) unsigned NOT NULL AUTO_INCREMENT,
  k int(10) unsigned NOT NULL DEFAULT '0',
  c char(120) NOT NULL DEFAULT '',
  pad char(60) NOT NULL DEFAULT '',
  PRIMARY KEY (id),
  KEY k (k)
) ENGINE=spider COMMENT='wrapper "mysql", table "sbtest"'
PARTITION BY KEY (id)
(
PARTITION pt1 COMMENT = 'srv "sharding1"',
PARTITION pt2 COMMENT = 'srv "sharding2"'
) ;
EOF

backend1 << EOF
DROP DATABASE IF EXISTS sharding;
CREATE DATABASE sharding;
CREATE TABLE sharding.sbtest (
  id int(10) unsigned NOT NULL AUTO_INCREMENT,
  k int(10) unsigned NOT NULL DEFAULT '0',
  c char(120) NOT NULL DEFAULT '',
  pad char(60) NOT NULL DEFAULT '',
  PRIMARY KEY (id),
  KEY k (k)
) ENGINE=InnoDB;
EOF

backend2 << EOF
DROP DATABASE IF EXISTS sharding;
CREATE DATABASE sharding;
CREATE TABLE sharding.sbtest (
  id int(10) unsigned NOT NULL AUTO_INCREMENT,
  k int(10) unsigned NOT NULL DEFAULT '0',
  c char(120) NOT NULL DEFAULT '',
  pad char(60) NOT NULL DEFAULT '',
  PRIMARY KEY (id),
  KEY k (k)
) ENGINE=InnoDB;
EOF

spider1 << EOF
use sharding;
insert into sbtest select 1,1,'aaa','aaaaaa';
insert into sbtest select 2,1,'bbb','bbbbbb';
insert into sbtest select 3,1,'ccc','cccccc';
insert into sbtest select 4,2,'ddd','dddddd';
insert into sbtest select 5,2,'eee','eeeeee';
insert into sbtest select 6,2,'eee','eeeeee';
insert into sbtest select 7,3,'fff','ffffff';
insert into sbtest select 8,4,'ggg','gggggg';
insert into sbtest select 9,3,'hhh','hhhhhh';
insert into sbtest select 10,4,'iii','iiiiii';
insert into sbtest select 11,3,'kkk','kkkkkk';
insert into sbtest select 12,4,'lll','llllll';
EOF

--  增加global区域
backend1 << EOF
DROP SERVER IF EXISTS global_zone;
CREATE DATABASE global_zone;
CREATE TABLE global_zone.sbtest_idx (
  id int(10) unsigned NOT NULL AUTO_INCREMENT,
  k int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (id),
  KEY k (k)
) ENGINE=InnoDB;
EOF

spider1 << EOF
DROP SERVER IF EXISTS global_zone;
CREATE SERVER global_zone
  FOREIGN DATA WRAPPER mysql
OPTIONS(
  HOST '192.168.1.201',
  DATABASE 'global_zone',
  USER 'admin',
  PASSWORD 'aaaaaa',
  PORT 3307
);


CREATE DATABASE IF NOT EXISTS global_zone;
CREATE  TABLE global_zone.sbtest_idx
(
  id int(10) unsigned NOT NULL AUTO_INCREMENT,
  k int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (id),
  KEY k (k)
) ENGINE=spider COMMENT='wrapper "mysql",srv "global_zone"';
EOF

spider1 << EOF
use global_zone;
insert into global_zone.sbtest_idx select id,k from sharding.sbtest;
EOF


-- 变更server
spider1 << EOF
DROP SERVER IF EXISTS global_zone;
CREATE SERVER global_zone3
  FOREIGN DATA WRAPPER mysql
OPTIONS(
  HOST '192.168.1.203',
  DATABASE 'global_zone',
  USER 'admin',
  PASSWORD 'aaaaaa',
  PORT 3307
);
EOF


backend3 << EOF
DROP SERVER IF EXISTS global_zone;
CREATE DATABASE global_zone;
CREATE TABLE global_zone.sbtest_idx (
  id int(10) unsigned NOT NULL AUTO_INCREMENT,
  k int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (id),
  KEY k (k)
) ENGINE=InnoDB;

DROP SERVER IF EXISTS sharding;
CREATE DATABASE sharding;
CREATE TABLE sharding.sbtest_idx (
  id int(10) unsigned NOT NULL AUTO_INCREMENT,
  k int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (id),
  KEY k (k)
) ENGINE=InnoDB;
EOF

alter table sbtest_idx comment='wrapper "mysql",srv "global_zone3"';
alter table sbtest_idx comment='wrapper "mysql",srv "global_zone"';
alter table sbtest_idx comment='wrapper "mysql",srv "sharding3"';

ALTER SERVER global_zone3 OPTIONS (HOST '192.168.1.203');
alter table sbtest_idx comment='wrapper "mysql",srv "global_zone3"';

spider1 << EOF
CREATE SERVER bsbackend1 FOREIGN DATA WRAPPER mysql OPTIONS( HOST '192.168.1.201', DATABASE 'bsbackend1',USER 'amdin', PASSWORD 'aaaaaa',PORT 5054);
CREATE SERVER bsbackend2 FOREIGN DATA WRAPPER mysql OPTIONS( HOST '192.168.1.201', DATABASE 'bsbackend2',USER 'amdin', PASSWORD 'aaaaaa',PORT 5054);
CREATE SERVER bsbackend3 FOREIGN DATA WRAPPER mysql OPTIONS( HOST '192.168.1.201', DATABASE 'bsbackend3',USER 'amdin', PASSWORD 'aaaaaa',PORT 5054);
CREATE SERVER bsbackend4 FOREIGN DATA WRAPPER mysql OPTIONS( HOST '192.168.1.201', DATABASE 'bsbackend4',USER 'amdin', PASSWORD 'aaaaaa',PORT 5054);
CREATE SERVER bsbackend5 FOREIGN DATA WRAPPER mysql OPTIONS( HOST '192.168.1.202', DATABASE 'bsbackend5',USER 'amdin', PASSWORD 'aaaaaa',PORT 5054);
CREATE SERVER bsbackend6 FOREIGN DATA WRAPPER mysql OPTIONS( HOST '192.168.1.202', DATABASE 'bsbackend6',USER 'amdin', PASSWORD 'aaaaaa',PORT 5054);
CREATE SERVER bsbackend7 FOREIGN DATA WRAPPER mysql OPTIONS( HOST '192.168.1.202', DATABASE 'bsbackend7',USER 'amdin', PASSWORD 'aaaaaa',PORT 5054);
CREATE SERVER bsbackend8 FOREIGN DATA WRAPPER mysql OPTIONS( HOST '192.168.1.202', DATABASE 'bsbackend8',USER 'amdin', PASSWORD 'aaaaaa',PORT 5054);

CREATE DATABASE IF NOT EXISTS bsbackend;
CREATE  TABLE bsbackend.sbtest
(
  id int(10) unsigned NOT NULL AUTO_INCREMENT,
  k int(10) unsigned NOT NULL DEFAULT '0',
  c char(120) NOT NULL DEFAULT '',
  pad char(60) NOT NULL DEFAULT '',
  PRIMARY KEY (id),
  KEY k (k)
) ENGINE=spider COMMENT='wrapper "mysql", table "sbtest"'
 PARTITION BY KEY (id) 
(
 PARTITION pt1 COMMENT = 'srv "bsbackend1"',
 PARTITION pt2 COMMENT = 'srv "bsbackend2"', 
 PARTITION pt3 COMMENT = 'srv "bsbackend3"',
 PARTITION pt4 COMMENT = 'srv "bsbackend4"', 
 PARTITION pt5 COMMENT = 'srv "bsbackend5"',
 PARTITION pt6 COMMENT = 'srv "bsbackend6"',
 PARTITION pt7 COMMENT = 'srv "bsbackend7"',
 PARTITION pt8 COMMENT = 'srv "bsbackend8"'
) ;
EOF
INSERT INTO  bsbackend.sbtest SELECT * FROM backend.sbtest;