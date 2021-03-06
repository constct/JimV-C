-- DROP DATABASE IF EXISTS jimv;
CREATE DATABASE IF NOT EXISTS jimv CHARACTER SET utf8;
USE jimv;


CREATE TABLE IF NOT EXISTS user(
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    login_name VARCHAR(30) NOT NULL UNIQUE,
    password VARCHAR(100) NOT NULL,
    create_time BIGINT UNSIGNED NOT NULL,
    mobile_phone VARCHAR(13) NOT NULL DEFAULT '',
    email VARCHAR(30) NOT NULL DEFAULT '',
    mobile_phone_verified BOOLEAN NOT NULL DEFAULT FALSE,
    email_verified BOOLEAN NOT NULL DEFAULT FALSE,
    enabled BOOLEAN NOT NULL DEFAULT TRUE,
    role_id BIGINT NOT NULL DEFAULT 0,
    PRIMARY KEY (id))
    ENGINE=InnoDB
    DEFAULT CHARSET=utf8;

ALTER TABLE user ADD INDEX (login_name);
ALTER TABLE user ADD INDEX (mobile_phone);
ALTER TABLE user ADD INDEX (email);
INSERT INTO user (login_name, password, create_time) VALUES
    ('admin', 'ji_pbkdf2$sha1$1000$b8UzawEs5kJ68TmbqQEqD07jgZGCYJsa$d3593420edee742499a974f2f377e5b220927dc7', UNIX_TIMESTAMP(NOW()) * 1000000);
# password jimv.pswd.com


CREATE TABLE IF NOT EXISTS guest(
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    uuid CHAR(36) NOT NULL,
    label VARCHAR(64) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    remark VARCHAR(255) NOT NULL DEFAULT '',
    os_template_id BIGINT UNSIGNED NOT NULL,
    create_time BIGINT UNSIGNED NOT NULL,
    -- 运行时的状态用 status;
    status TINYINT UNSIGNED NOT NULL DEFAULT 0,
    progress TINYINT UNSIGNED NOT NULL DEFAULT 0,
    node_id BIGINT UNSIGNED NOT NULL,
    cpu TINYINT UNSIGNED NOT NULL,
    memory INT UNSIGNED NOT NULL,
    ip CHAR(15) NOT NULL,
    network VARCHAR(64) NOT NULL,
    manage_network VARCHAR(64) NOT NULL,
    vnc_port INT UNSIGNED NOT NULL,
    vnc_password VARCHAR(255) NOT NULL,
    xml TEXT NOT NULL,
    PRIMARY KEY (id))
    ENGINE=InnoDB
    DEFAULT CHARSET=utf8;

ALTER TABLE guest ADD INDEX (uuid);
ALTER TABLE guest ADD INDEX (label);
ALTER TABLE guest ADD INDEX (node_id);
ALTER TABLE guest ADD INDEX (ip);
ALTER TABLE guest ADD INDEX (remark);


CREATE TABLE IF NOT EXISTS guest_migrate_info(
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    uuid CHAR(36) NOT NULL,
    type TINYINT UNSIGNED NOT NULL DEFAULT 0,
    time_elapsed BIGINT UNSIGNED NOT NULL DEFAULT 0,
    time_remaining BIGINT UNSIGNED NOT NULL DEFAULT 0,
    data_total BIGINT UNSIGNED NOT NULL DEFAULT 0,
    data_processed BIGINT UNSIGNED NOT NULL DEFAULT 0,
    data_remaining BIGINT UNSIGNED NOT NULL DEFAULT 0,
    mem_total BIGINT UNSIGNED NOT NULL DEFAULT 0,
    mem_processed BIGINT UNSIGNED NOT NULL DEFAULT 0,
    mem_remaining BIGINT UNSIGNED NOT NULL DEFAULT 0,
    file_total BIGINT UNSIGNED NOT NULL DEFAULT 0,
    file_processed BIGINT UNSIGNED NOT NULL DEFAULT 0,
    file_remaining BIGINT UNSIGNED NOT NULL DEFAULT 0,
    PRIMARY KEY (id))
    ENGINE=InnoDB
    DEFAULT CHARSET=utf8;

ALTER TABLE guest_migrate_info ADD INDEX (uuid);


CREATE TABLE IF NOT EXISTS disk(
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    uuid CHAR(36) NOT NULL,
    path VARCHAR(255) NOT NULL,
    size INT UNSIGNED NOT NULL,
    node_id BIGINT UNSIGNED NOT NULL,
    remark VARCHAR(255) NOT NULL DEFAULT '',
    sequence TINYINT NOT NULL,
    format CHAR(16) NOT NULL DEFAULT 'qcow2',
    -- 实例固有的状态用 state;
    state TINYINT UNSIGNED NOT NULL DEFAULT 0,
    create_time BIGINT UNSIGNED NOT NULL,
    guest_uuid CHAR(36) NOT NULL,
    iops BIGINT UNSIGNED NOT NULL DEFAULT 0,
    iops_rd BIGINT UNSIGNED NOT NULL DEFAULT 0,
    iops_wr BIGINT UNSIGNED NOT NULL DEFAULT 0,
    iops_max BIGINT UNSIGNED NOT NULL DEFAULT 0,
    iops_max_length BIGINT UNSIGNED NOT NULL DEFAULT 0,
    bps BIGINT UNSIGNED NOT NULL DEFAULT 0,
    bps_rd BIGINT UNSIGNED NOT NULL DEFAULT 0,
    bps_wr BIGINT UNSIGNED NOT NULL DEFAULT 0,
    bps_max BIGINT UNSIGNED NOT NULL DEFAULT 0,
    bps_max_length BIGINT UNSIGNED NOT NULL DEFAULT 0,
    PRIMARY KEY (id))
    ENGINE=InnoDB
    DEFAULT CHARSET=utf8;

ALTER TABLE disk ADD INDEX (size);
ALTER TABLE disk ADD INDEX (guest_uuid);
ALTER TABLE disk ADD INDEX (node_id);
ALTER TABLE disk ADD INDEX (remark);


CREATE TABLE IF NOT EXISTS os_template(
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    label VARCHAR(255) NOT NULL,
    path VARCHAR(255) NOT NULL,
    os_type TINYINT UNSIGNED NOT NULL,
    active BOOLEAN NOT NULL DEFAULT TRUE,
    icon VARCHAR(255) NOT NULL,
    boot_job_id BIGINT UNSIGNED NOT NULL DEFAULT 0,
    PRIMARY KEY (id))
    ENGINE=InnoDB
    DEFAULT CHARSET=utf8;


CREATE TABLE IF NOT EXISTS boot_job(
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    use_for TINYINT UNSIGNED NOT NULL DEFAULT 0,
    remark VARCHAR(255) NOT NULL DEFAULT '',
    PRIMARY KEY (id))
    ENGINE=InnoDB
    DEFAULT CHARSET=utf8;


CREATE TABLE IF NOT EXISTS operate_rule(
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    boot_job_id BIGINT UNSIGNED NOT NULL,
    kind TINYINT UNSIGNED NOT NULL DEFAULT 0,
    sequence TINYINT UNSIGNED NOT NULL DEFAULT 0,
    path VARCHAR(255) NOT NULL,
    content TEXT NOT NULL DEFAULT '',
    command TEXT NOT NULL DEFAULT '',
    PRIMARY KEY (id))
    ENGINE=InnoDB
    DEFAULT CHARSET=utf8;


CREATE TABLE IF NOT EXISTS config(
    id BIGINT UNSIGNED NOT NULL DEFAULT 1,
    jimv_edition TINYINT UNSIGNED NOT NULL DEFAULT 0,
    storage_mode TINYINT UNSIGNED NOT NULL DEFAULT 0,
    dfs_volume VARCHAR(255) NOT NULL DEFAULT '',
    storage_path VARCHAR(255) NOT NULL,
    vm_network VARCHAR(255) NOT NULL,
    vm_manage_network VARCHAR(255) NOT NULL,
    start_ip CHAR(15) NOT NULL,
    end_ip CHAR(15) NOT NULL,
    start_vnc_port INT UNSIGNED NOT NULL,
    netmask CHAR(15) NOT NULL,
    gateway CHAR(15) NOT NULL,
    dns1 CHAR(15) NOT NULL DEFAULT '223.5.5.5',
    dns2 CHAR(15) NOT NULL DEFAULT '8.8.8.8',
    iops_base BIGINT UNSIGNED NOT NULL DEFAULT 0,
    iops_pre_unit BIGINT UNSIGNED NOT NULL DEFAULT 0,
    iops_cap BIGINT UNSIGNED NOT NULL DEFAULT 0,
    iops_max BIGINT UNSIGNED NOT NULL DEFAULT 0,
    iops_max_length BIGINT UNSIGNED NOT NULL DEFAULT 0,
    bps_base BIGINT UNSIGNED NOT NULL DEFAULT 0,
    bps_pre_unit BIGINT UNSIGNED NOT NULL DEFAULT 0,
    bps_cap BIGINT UNSIGNED NOT NULL DEFAULT 0,
    bps_max BIGINT UNSIGNED NOT NULL DEFAULT 0,
    bps_max_length BIGINT UNSIGNED NOT NULL DEFAULT 0,
    PRIMARY KEY (id))
    ENGINE=InnoDB
    DEFAULT CHARSET=utf8;


CREATE TABLE IF NOT EXISTS log(
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    type TINYINT UNSIGNED NOT NULL,
    timestamp BIGINT UNSIGNED NOT NULL,
    host CHAR(15),
    message VARCHAR(255) NOT NULL DEFAULT '',
    full_message TEXT,
    PRIMARY KEY (id))
    ENGINE=Innodb
    DEFAULT CHARSET=utf8;

ALTER TABLE log ADD INDEX (host);


CREATE TABLE IF NOT EXISTS guest_cpu_memory(
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    guest_uuid CHAR(36) NOT NULL,
    cpu_load INT UNSIGNED NOT NULL,
    memory_available BIGINT UNSIGNED NOT NULL,
    memory_unused BIGINT UNSIGNED NOT NULL,
    timestamp BIGINT UNSIGNED NOT NULL,
    PRIMARY KEY (id))
    ENGINE=Innodb
    DEFAULT CHARSET=utf8;

ALTER TABLE guest_cpu_memory ADD INDEX (guest_uuid);
ALTER TABLE guest_cpu_memory ADD INDEX (cpu_load);
ALTER TABLE guest_cpu_memory ADD INDEX (timestamp);
ALTER TABLE guest_cpu_memory ADD INDEX (guest_uuid, timestamp);


CREATE TABLE IF NOT EXISTS guest_traffic(
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    guest_uuid CHAR(36) NOT NULL,
    name VARCHAR(36) NOT NULL,
    rx_bytes BIGINT UNSIGNED NOT NULL,
    rx_packets BIGINT UNSIGNED NOT NULL,
    rx_errs BIGINT UNSIGNED NOT NULL,
    rx_drop BIGINT UNSIGNED NOT NULL,
    tx_bytes BIGINT UNSIGNED NOT NULL,
    tx_packets BIGINT UNSIGNED NOT NULL,
    tx_errs BIGINT UNSIGNED NOT NULL,
    tx_drop BIGINT UNSIGNED NOT NULL,
    timestamp BIGINT UNSIGNED NOT NULL,
    PRIMARY KEY (id))
    ENGINE=Innodb
    DEFAULT CHARSET=utf8;

ALTER TABLE guest_traffic ADD INDEX (guest_uuid);
ALTER TABLE guest_traffic ADD INDEX (rx_bytes);
ALTER TABLE guest_traffic ADD INDEX (rx_packets);
ALTER TABLE guest_traffic ADD INDEX (tx_bytes);
ALTER TABLE guest_traffic ADD INDEX (tx_packets);
ALTER TABLE guest_traffic ADD INDEX (timestamp);
ALTER TABLE guest_traffic ADD INDEX (guest_uuid, timestamp);


CREATE TABLE IF NOT EXISTS guest_disk_io(
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    disk_uuid CHAR(36) NOT NULL,
    rd_req BIGINT UNSIGNED NOT NULL,
    rd_bytes BIGINT UNSIGNED NOT NULL,
    wr_req BIGINT UNSIGNED NOT NULL,
    wr_bytes BIGINT UNSIGNED NOT NULL,
    timestamp BIGINT UNSIGNED NOT NULL,
    PRIMARY KEY (id))
    ENGINE=Innodb
    DEFAULT CHARSET=utf8;

ALTER TABLE guest_disk_io ADD INDEX (disk_uuid);
ALTER TABLE guest_disk_io ADD INDEX (rd_req);
ALTER TABLE guest_disk_io ADD INDEX (rd_bytes);
ALTER TABLE guest_disk_io ADD INDEX (wr_req);
ALTER TABLE guest_disk_io ADD INDEX (wr_bytes);
ALTER TABLE guest_disk_io ADD INDEX (timestamp);
ALTER TABLE guest_disk_io ADD INDEX (disk_uuid, timestamp);


CREATE TABLE IF NOT EXISTS host_cpu_memory(
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    node_id BIGINT UNSIGNED NOT NULL,
    cpu_load INT UNSIGNED NOT NULL,
    memory_available BIGINT UNSIGNED NOT NULL,
    timestamp BIGINT UNSIGNED NOT NULL,
    PRIMARY KEY (id))
    ENGINE=Innodb
    DEFAULT CHARSET=utf8;

ALTER TABLE host_cpu_memory ADD INDEX (node_id);
ALTER TABLE host_cpu_memory ADD INDEX (timestamp);
ALTER TABLE host_cpu_memory ADD INDEX (node_id, timestamp);


CREATE TABLE IF NOT EXISTS host_traffic(
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    node_id BIGINT UNSIGNED NOT NULL,
    name VARCHAR(36) NOT NULL,
    rx_bytes BIGINT UNSIGNED NOT NULL,
    rx_packets BIGINT UNSIGNED NOT NULL,
    rx_errs BIGINT UNSIGNED NOT NULL,
    rx_drop BIGINT UNSIGNED NOT NULL,
    tx_bytes BIGINT UNSIGNED NOT NULL,
    tx_packets BIGINT UNSIGNED NOT NULL,
    tx_errs BIGINT UNSIGNED NOT NULL,
    tx_drop BIGINT UNSIGNED NOT NULL,
    timestamp BIGINT UNSIGNED NOT NULL,
    PRIMARY KEY (id))
    ENGINE=Innodb
    DEFAULT CHARSET=utf8;

ALTER TABLE host_traffic ADD INDEX (node_id);
ALTER TABLE host_traffic ADD INDEX (rx_bytes);
ALTER TABLE host_traffic ADD INDEX (rx_packets);
ALTER TABLE host_traffic ADD INDEX (tx_bytes);
ALTER TABLE host_traffic ADD INDEX (tx_packets);
ALTER TABLE host_traffic ADD INDEX (timestamp);
ALTER TABLE host_traffic ADD INDEX (node_id, timestamp);
ALTER TABLE host_traffic ADD INDEX (node_id, name, timestamp);


CREATE TABLE IF NOT EXISTS host_disk_usage_io(
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    node_id BIGINT UNSIGNED NOT NULL,
    mountpoint VARCHAR(255) NOT NULL,
    used BIGINT UNSIGNED NOT NULL,
    rd_req BIGINT UNSIGNED NOT NULL,
    rd_bytes BIGINT UNSIGNED NOT NULL,
    wr_req BIGINT UNSIGNED NOT NULL,
    wr_bytes BIGINT UNSIGNED NOT NULL,
    timestamp BIGINT UNSIGNED NOT NULL,
    PRIMARY KEY (id))
    ENGINE=Innodb
    DEFAULT CHARSET=utf8;

ALTER TABLE host_disk_usage_io ADD INDEX (node_id);
ALTER TABLE host_disk_usage_io ADD INDEX (mountpoint);
ALTER TABLE host_disk_usage_io ADD INDEX (used);
ALTER TABLE host_disk_usage_io ADD INDEX (rd_req);
ALTER TABLE host_disk_usage_io ADD INDEX (rd_bytes);
ALTER TABLE host_disk_usage_io ADD INDEX (wr_req);
ALTER TABLE host_disk_usage_io ADD INDEX (wr_bytes);
ALTER TABLE host_disk_usage_io ADD INDEX (timestamp);
ALTER TABLE host_disk_usage_io ADD INDEX (node_id, mountpoint, timestamp);


INSERT INTO boot_job (name, use_for, remark) VALUES ('Reset password for Linux', 1, '重置 Linux 平台管理员密码。');
INSERT INTO boot_job (name, use_for, remark) VALUES ('CentOS-Systemd', 0, '用作 Redhat Systemd 系列的系统初始化。初始化操作依据 CentOS 7 来实现。');
INSERT INTO boot_job (name, use_for, remark) VALUES ('CentOS-SysV', 0, '用作 Redhat SysV 系列的系统初始化。初始化操作依据 CentOS 6.8 来实现。');
INSERT INTO boot_job (name, use_for, remark) VALUES ('Gentoo-OpenRC', 0, '用作 Gentoo OpenRC 系列的系统初始化。');
INSERT INTO boot_job (name, use_for, remark) VALUES ('Windows', 0, '用作 MS-Windos 系列的系统初始化。初始化操作依据 Windows 2012 来实现。');

-- For Reset password for Linux
INSERT INTO operate_rule (boot_job_id, kind, sequence, path, content, command) VALUES (1, 0, 0, '', '', 'echo "root:{PASSWORD}" | chpasswd');

-- For CentOS-Systemd
INSERT INTO operate_rule (boot_job_id, kind, sequence, path, content, command) VALUES (2, 1, 0, '/etc/resolv.conf', 'nameserver {DNS1}
nameserver {DNS2}', '');
INSERT INTO operate_rule (boot_job_id, kind, sequence, path, content, command) VALUES (2, 1, 0, '/etc/sysconfig/network-scripts/ifcfg-eth0', 'DEVICE=eth0
TYPE=Ethernet
ONBOOT=yes
BOOTPROTO="static"
IPADDR={IP}
NETMASK={NETMASK}
GATEWAY={GATEWAY}
DNS1={DNS1}
DNS2={DNS2}
IPV6INIT=no
NAME=eth0', '');
INSERT INTO operate_rule (boot_job_id, kind, sequence, path, content, command) VALUES (2, 1, 0, '/etc/hostname', '{HOSTNAME}', '');

-- For CentOS-SysV
INSERT INTO operate_rule (boot_job_id, kind, sequence, path, content, command) VALUES (3, 1, 0, '/etc/resolv.conf', 'nameserver {DNS1}
nameserver {DNS2}', '');
INSERT INTO operate_rule (boot_job_id, kind, sequence, path, content, command) VALUES (3, 1, 0, '/etc/sysconfig/network-scripts/ifcfg-eth0', 'DEVICE=eth0
TYPE=Ethernet
ONBOOT=yes
BOOTPROTO="static"
IPADDR={IP}
NETMASK={NETMASK}
GATEWAY={GATEWAY}
IPV6INIT=no
NAME=eth0', '');
INSERT INTO operate_rule (boot_job_id, kind, sequence, path, content, command) VALUES (3, 1, 0, '/etc/sysconfig/network', 'NETWORKING=yes
HOSTNAME="{HOSTNAME}"', '');

-- For Gentoo-OpenRC
INSERT INTO operate_rule (boot_job_id, kind, sequence, path, content, command) VALUES (4, 1, 0, '/etc/resolv.conf', 'nameserver {DNS1}
nameserver {DNS2}', '');
INSERT INTO operate_rule (boot_job_id, kind, sequence, path, content, command) VALUES (4, 1, 0, '/etc/conf.d/net', 'config_eth0="{IP}/{NETMASK}"
routes_eth0="default via {GATEWAY}"', '');
INSERT INTO operate_rule (boot_job_id, kind, sequence, path, content, command) VALUES (4, 1, 0, '/etc/conf.d/hostname', 'hostname="{HOSTNAME}"', '');

-- For Windows
INSERT INTO operate_rule (boot_job_id, kind, sequence, path, content, command) VALUES (5, 1, 0, '/Windows/jimv_init.bat', 'netsh interface ip set address name="Ethernet" source=static {IP} {NETMASK} {GATEWAY}
netsh interface ip set dns "Ethernet" static {DNS1} primary
netsh interface ip add dns "Ethernet" {DNS2}
wmic computersystem where name="%COMPUTERNAME%" call rename name="{HOSTNAME}"
net user Administrator {PASSWORD}
timeout 3 > NUL
sc delete JimVInit
del C:\\Windows\\jimv_init.bat
timeout 2 > NUL
shutdown -r -t 0', '');

