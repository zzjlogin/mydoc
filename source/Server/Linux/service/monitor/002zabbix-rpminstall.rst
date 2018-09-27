
.. _server-linux-zabbix-rpminstall:

========================================
zabbix rpm安装
========================================

环境
========================================

服务器：

[root@zzjlogin ~]# hostname
zzjlogin
[root@zzjlogin ~]# uname -a
Linux zzjlogin 2.6.32-504.el6.x86_64 #1 SMP Wed Oct 15 04:27:16 UTC 2014 x86_64 x86_64 x86_64 GNU/Linux
[root@zzjlogin ~]# uname -r
2.6.32-504.el6.x86_64
[root@zzjlogin ~]# cat /etc/redhat-release
CentOS release 6.6 (Final)

[root@zzjlogin ~]# cat /proc/version
Linux version 2.6.32-504.el6.x86_64 (mockbuild@c6b9.bsys.dev.centos.org) (gcc version 4.4.7 20120313 (Red Hat 4.4.7-11) (GCC) ) #1 SMP Wed Oct 15 04:27:16 UTC 2014

客户端：


准备
========================================

zabbix安装参考:
    https://www.zabbix.com/download

需要使用的链接:
    - http://repo.zabbix.com/zabbix/3.4/rhel/7/x86_64/
    - http://repo.zabbix.com/zabbix/3.4/rhel/6/x86_64/
    - https://sourceforge.net/projects/zabbix/files/

需要的软件包：
    
网络时间同步
----------------------------------------

[root@zzjlogin ~]# date
Thu Sep  6 21:07:25 CST 2018
[root@zzjlogin ~]# ntpdate pool.ntp.org
28 Sep 00:53:38 ntpdate[1577]: step time server 5.103.139.163 offset 1827966.915121 sec

LNMP安装
----------------------------------------


安装
========================================


[root@zzjlogin ~]# rpm -ivh http://repo.zabbix.com/zabbix/3.4/rhel/6/x86_64/zabbix-release-3.4-1.el6.noarch.rpm
Retrieving http://repo.zabbix.com/zabbix/3.4/rhel/6/x86_64/zabbix-release-3.4-1.el6.noarch.rpm
Preparing...                ########################################### [100%]
   1:zabbix-release         ########################################### [100%]





安装zabbix
----------------------------------------

[root@zzjlogin ~]# yum install zabbix-server-mysql zabbix-web-mysql zabbix-agent -y

配置PHP
----------------------------------------

配置数据库
----------------------------------------


安装并检查安装结果:


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



.. attention::
    这些表信息是zabbix已经提供的，直接导入即可，如果不导入数据库，是不能访问zabbix的。


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





