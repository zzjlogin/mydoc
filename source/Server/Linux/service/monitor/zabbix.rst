.. _zzjlogin-zabbix:

========================================
zabbix
========================================


zabbix简介
========================================

参考:
    `zabbix百度百科 <https://baike.baidu.com/item/Zabbix>`_
    `zabbix维基百科 <https://zh.wikipedia.org/wiki/Zabbix>`_
    `zabbix官网 <https://www.zabbix.com/>`_

zabbix是一个基于WEB界面的提供分布式系统监视以及网络监视功能的企业级的开源解决方案。Zabbix的授权是属于GPLv2。

zabbix服务模式:
    是cs架构，需要专门安装客户端，从而让服务器监控到客户端。

Zabbix使用MySQL、PostgreSQL、SQLite、Oracle或IBMDB2储存资料。Server端基于C语言、Web前端则是基于PHP所制作的。Zabbix可以使用多种方式监视。
可以只使用Simple Check不需要安装Client端，亦可基于SMTP或HTTP等各种协定做死活监视。
在客户端如UNIX、Windows中安装Zabbix Agent之后，可监视CPU负荷、网络使用状况、硬盘容量等各种状态。
而就算没有安装Agent在监视对象中，Zabbix也可以经由SNMP、TCP、ICMP检查，以及利用IPMI、SSH、telnet对目标进行监视。

安装
========================================

zabbix安装参考:
    https://www.zabbix.com/download

链接参考:
    - http://repo.zabbix.com/zabbix/3.4/rhel/7/x86_64/
    - http://repo.zabbix.com/zabbix/3.4/rhel/6/x86_64/


CentOS6安装配置(编译安装)
-----------------------------------------

1. 安装php/http，并配置

[root@zzjlogin ~]# yum install php56w php56w-gd php56w-mysql php56w-bcmath php56w-bcmath php56w-mbstring php56w-xml php56w-ldap -y


CentOS6.6官方源直接安装会包错，具体错误信息如下:
    Loading mirror speeds from cached hostfile
    * base: mirrors.huaweicloud.com
    * extras: ftp.sjtu.edu.cn
    * updates: mirrors.huaweicloud.com
    No package php56w available.
    No package php56w-gd available.
    No package php56w-mysql available.
    No package php56w-bcmath available.
    No package php56w-mbstring available.
    No package php56w-xml available.
    No package php56w-ldap available.

有上面报错，所以有下面源的转换:

[root@zzjlogin ~]# rpm -Uvh https://mirror.webtatic.com/yum/el6/latest.rpm

[root@zzjlogin ~]# yum install php56w php56w-gd php56w-mysql php56w-bcmath php56w-bcmath php56w-mbstring php56w-xml php56w-ldap -y

.. attention::
    注意安装php56w-mysql.x86_64 0:5.6.37-1.w6 ，否则会出现php链接mysql时失败。



[root@zzjlogin zabbix-3.4.13]# yum install httpd libxml2-devel net-snmp-devel libcurl-devel -y

配置php:

[root@zzjlogin zabbix-3.4.13]# vim /etc/php.ini
date.timezone = Asia/Shanghai
post_max_size = 32M
max_execution_time = 300
max_input_time = 300
always_populate_raw_post_data = -1

.. attention::
    上面信息需要修改，如果不修改，安装zabbix后通过网页访问的时候会报错。

2. 安装并配置数据库

安装并检查安装结果:

[root@zzjlogin zabbix-3.4.13]# yum install mysql mysql-devel mysql-server -y

[root@zzjlogin ~]# rpm -qa mysql*

启动数据库，并配置密码:

[root@zzjlogin ~]# /etc/init.d/mysqld start

[root@zzjlogin ~]# /usr/bin/mysqladmin -u root password '123'

登陆数据库，清理空账号信息，创建zabbix数据库:

[root@zzjlogin ~]# mysql -uroot -p
Enter password: 
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 3
Server version: 5.1.73 Source distribution

Copyright (c) 2000, 2013, Oracle and/or its affiliates. All rights reserved.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> use mysql;
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Database changed
mysql> show databases;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| mysql              |
| test               |
+--------------------+
3 rows in set (0.00 sec)

mysql> select user,host from user;
+------+-----------+
| user | host      |
+------+-----------+
| root | 127.0.0.1 |
|      | localhost |
| root | localhost |
|      | zzjlogin  |
| root | zzjlogin  |
+------+-----------+
5 rows in set (0.00 sec)

mysql> drop user ""@"localhost"
    -> ;
Query OK, 0 rows affected (0.00 sec)

mysql> drop user ""@"zzjlogin";
Query OK, 0 rows affected (0.00 sec)

mysql> drop user "root"@"zzjlogin";
Query OK, 0 rows affected (0.00 sec)

mysql> select user,host from user;
+------+-----------+
| user | host      |
+------+-----------+
| root | 127.0.0.1 |
| root | localhost |
+------+-----------+
2 rows in set (0.00 sec)

mysql> create database zabbix;
Query OK, 1 row affected (0.00 sec)

mysql> show databases;            
+--------------------+
| Database           |
+--------------------+
| information_schema |
| mysql              |
| test               |
| zabbix             |
+--------------------+
4 rows in set (0.00 sec)

mysql> grant all privileges on zabbix.* to zabbix@localhost identified by 'password';
Query OK, 0 rows affected (0.00 sec)

mysql> exit
Bye




3. 准备环境并下载软件包编译安装

[root@zzjlogin ~]# yum install zabbix-server-mysql zabbix-web-mysql zabbix-agent -y


[root@zzjlogin ~]# rpm -i http://repo.zabbix.com/zabbix/3.4/rhel/7/x86_64/zabbix-release-3.4-2.el7.noarch.rpm
warning: /var/tmp/rpm-tmp.NfLb4n: Header V4 RSA/SHA512 Signature, key ID a14fe591: NOKEY
[root@zzjlogin ~]# rpm -qa zabbix*
zabbix-release-3.4-2.el7.noarch

下载软件包:

[root@zzjlogin ~]# wget https://sourceforge.net/projects/zabbix/files/ZABBIX%20Latest%20Stable/3.4.13/zabbix-3.4.13.tar.gz/download

[root@zzjlogin ~]# ls
[root@zzjlogin ~]# tar xf download
[root@zzjlogin ~]# cd zabbix-3.4.13/
[root@zzjlogin zabbix-3.4.13]#

把zabbix软件包对应的zabbix数据库表结构信息导入mysql数据库:

[root@zzjlogin zabbix-3.4.13]# mysql -uzabbix -ppassword zabbix < database/mysql/schema.sql
[root@zzjlogin zabbix-3.4.13]# mysql -uzabbix -ppassword zabbix < database/mysql/images.sql 
[root@zzjlogin zabbix-3.4.13]# mysql -uzabbix -ppassword zabbix < database/mysql/data.sql

.. attention::
    这些表信息是zabbix已经提供的，直接导入即可，如果不导入数据库，是不能访问zabbix的。

编译安装:

[root@zzjlogin zabbix-3.4.13]# ./configure --prefix=/usr/local/zabbix --sysconfdir=/etc/zabbix/ --enable-server --enable-agent --with-net-snmp --with-libcurl --with-mysql --with-libxml2

.. warning::
    报错: ``configure: error: MySQL library not found``
    [root@zzjlogin zabbix-3.4.13]# yum install mysql-devel -y


.. warning::
    报错 ``configure: error: Unable to use libevent (libevent check failed)``
    然后就可以通过安装即可: [root@zzjlogin zabbix-3.4.13]# yum install libevent -y

    然后参考:https://www.zabbix.com/forum/zabbix-troubleshooting-and-problems/50959-zabbix-3-4-compile-problem
    安装:yum install libevent-devel -y

.. warning::
    报错 ``configure: error: Unable to use libpcre (libpcre check failed)``

    参考:https://www.zabbix.com/forum/zabbix-troubleshooting-and-problems/52600-zabbix-3-4-4

    [root@zzjlogin zabbix-3.4.13]# rpm -qa pcre*
    pcre-7.8-6.el6.x86_64

    [root@zzjlogin zabbix-3.4.13]# yum install pcre-devel -y

.. warning::
    报错 ``configure: error: LIBXML2 library not found``
    参考:https://support.zabbix.com/browse/ZBX-12324
    [root@zzjlogin zabbix-3.4.13]# rpm -qa libxml*
    libxml2-2.7.6-14.el6_5.2.x86_64
    libxml2-python-2.7.6-14.el6_5.2.x86_64
    [root@zzjlogin zabbix-3.4.13]# yum install libxml2-devel -y

创建命令软连接:

[root@zzjlogin zabbix-3.4.13]# ln -s /usr/local/zabbix/sbin/zabbix_server /usr/sbin/zabbix_server
[root@zzjlogin zabbix-3.4.13]# ln -s /usr/local/zabbix/sbin/zabbix_agentd /usr/sbin/zabbix_agentd

把zabbix启动脚本拷贝到 ``/etc/init.d/``

[root@zzjlogin zabbix-3.4.13]# cp /root/zabbix-3.4.13/misc/init.d/fedora/core/zabbix_server /etc/init.d/

修改脚本默认的zabbix命令路径:

[root@zzjlogin zabbix-3.4.13]# sed -i "s@BASEDIR=/usr/local@BASEDIR=/usr/local/zabbix@g" /etc/init.d/zabbix_server

修改zabbix服务器配置信息:

[root@zzjlogin zabbix-3.4.13]# vim /etc/zabbix/zabbix_server.conf

DBHost=localhost  数据库ip地址
DBName=zabbix
DBUser=zabbix
DBPassword=password
ListenIP=192.168.161.132        #zabbix server ip地址

把zabbix网页信息拷贝到httpd服务器的网页存放目录:

[root@zzjlogin zabbix-3.4.13]# cp -r /root/zabbix-3.4.13/frontends/php/* /var/www/html/

创建zabbix运行账户:

[root@zzjlogin zabbix-3.4.13]# useradd -M zabbix -s /sbin/nologin

启动mysql数据库:

[root@zzjlogin zabbix-3.4.13]# /etc/init.d/mysqld start

启动httpd服务:

[root@zzjlogin zabbix-3.4.13]# /etc/init.d/httpd start

启动zabbix服务:

[root@zzjlogin zabbix-3.4.13]# /etc/init.d/zabbix_server start


至此zabbix可以访问。然后通过浏览器输入zabbix服务器IP地址，然后通过网页配置zabbix即可。


.. code-block:: bash
    :linenos:

    # 安装配置数据库
    [root@centos-151 ~]# yum install mariadb-server  

    [root@centos-151 ~]# systemctl start mariadb
    [root@centos-151 ~]# mysql_secure_installation 

    [root@centos-151 ~]# mysql -uroot -ppanda 
    Welcome to the MariaDB monitor.  Commands end with ; or \g.
    Your MariaDB connection id is 10
    Server version: 5.5.56-MariaDB MariaDB Server

    Copyright (c) 2000, 2017, Oracle, MariaDB Corporation Ab and others.

    Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

    MariaDB [(none)]> create database zabbix character set utf8 collate utf8_bin;
    Query OK, 1 row affected (0.00 sec)

    MariaDB [(none)]> grant all privileges on zabbix.* to zabbix@localhost identified by 'password';
    Query OK, 0 rows affected (0.00 sec)

    MariaDB [(none)]> exit
    Bye

    # 安装zabbix
    [root@centos-151 ~]# rpm -i http://repo.zabbix.com/zabbix/3.4/rhel/7/x86_64/zabbix-release-3.4-2.el7.noarch.rpm
    [root@centos-151 ~]# yum install zabbix-server-mysql zabbix-web-mysql zabbix-agent

    # 导库
    [root@centos-151 ~]# zcat /usr/share/doc/zabbix-server-mysql*/create.sql.gz | mysql -uzabbix -ppassword zabbix

    # 配置文件添加密码
    [root@centos-151 ~]# vim /etc/zabbix/zabbix_server.conf 
    DBPassword=password
    # 修改时区信息
    [root@centos-151 ~]# vim /etc/httpd/conf.d/zabbix.conf 
    php_value date.timezone Asia/Shanghai
    # 重启web
    [root@centos-151 ~]# systemctl start httpd


图形安装配置
========================================




准备工作
========================================

.. code-block:: bash
    :linenos:

    [root@centos-152 ~]# rpm -i http://repo.zabbix.com/zabbix/3.4/rhel/7/x86_64/zabbix-release-3.4-2.el7.noarch.rpm
    [root@centos-152 ~]# yum install zabbix-agent
    [root@centos-152 ~]# cd /etc/zabbix/
    [root@centos-152 zabbix]# ls
    zabbix_agentd.conf  zabbix_agentd.d
    [root@centos-152 zabbix]# vim zabbix_agentd.conf 
    # 修改如下3行
    Server=192.168.46.151
    ServerActive=192168.46.151
    Hostname=centos-152.linuxpanda.tech

    [root@centos-153 ~]# rpm -i http://repo.zabbix.com/zabbix/3.4/rhel/7/x86_64/zabbix-release-3.4-2.el7.noarch.rpm
    [root@centos-153 ~]# yum install zabbix-agent
    [root@centos-153 ~]# cd /etc/zabbix/
    [root@centos-153 zabbix]# ls
    zabbix_agentd.conf  zabbix_agentd.d
    [root@centos-153 zabbix]# vim zabbix_agentd.conf 
    # 修改如下3行
    Server=192.168.46.151
    ServerActive=192168.46.151
    Hostname=centos-153.linuxpanda.tech


    # 启动服务并查看监听
    [root@centos-152 zabbix]# systemctl restart zabbix-agent
    [root@centos-153 zabbix]# systemctl restart zabbix-agent

    [root@centos-152 zabbix]# ss -tul 
    Netid  State      Recv-Q Send-Q                                       Local Address:Port                                                        Peer Address:Port                
    tcp    LISTEN     0      128                                                      *:ssh                                                                    *:*                    
    tcp    LISTEN     0      100                                              127.0.0.1:smtp                                                                   *:*                    
    tcp    LISTEN     0      128                                                      *:zabbix-agent                                                           *:*                    
    tcp    LISTEN     0      128                                                     :::ssh                                                                   :::*                    
    tcp    LISTEN     0      100                                                    ::1:smtp                                                                  :::*                    
    tcp    LISTEN     0      128                                                     :::zabbix-agent                                                          :::*              

    [root@centos-153 zabbix]# ss -tul
    Netid  State      Recv-Q Send-Q                                       Local Address:Port                                                        Peer Address:Port                
    tcp    LISTEN     0      128                                                      *:ssh                                                                    *:*                    
    tcp    LISTEN     0      100                                              127.0.0.1:smtp                                                                   *:*                    
    tcp    LISTEN     0      128                                                      *:zabbix-agent                                                           *:*                    
    tcp    LISTEN     0      128                                                     :::ssh                                                                   :::*                    
    tcp    LISTEN     0      100                                                    ::1:smtp                                                                  :::*                    
    tcp    LISTEN     0      128                                                     :::zabbix-agent                                                          :::*      



host group(主机组)
========================================


template(模板)
========================================

创建template



item
========================================


graph
========================================




discover(发现)
========================================




等会查看图形显示问题






trigger(触发器)
========================================


这里以152的web应用为例说明trigger的使用

安装web
----------------------------------------

.. code-block:: bash
    :linenos:

    [root@centos-152 zabbix]# yum install nginx 
    [root@centos-152 zabbix]# systemctl restart nginx
    [root@centos-152 zabbix]# hostname
    centos-152.linuxpanda.tech
    [root@centos-152 zabbix]# hostname > /usr/share/nginx/html/index.html
    [root@centos-152 zabbix]# curl localhost
    centos-152.linuxpanda.tech



停下服务，测试监控

.. code-block:: bash
    :linenos:

    [root@centos-152 zabbix]# systemctl stop nginx





配置远程权限

.. code-block:: bash
    :linenos:

    # 配置sudo 
    zabbix  ALL=(ALL)       NOPASSWD: ALL
    [root@centos-152 zabbix]# vim /etc/zabbix/zabbix_agentd.conf
    EnableRemoteCommands=1

    [root@centos-152 zabbix]# systemctl start nginx
    [root@centos-152 zabbix]# systemctl stop nginx




