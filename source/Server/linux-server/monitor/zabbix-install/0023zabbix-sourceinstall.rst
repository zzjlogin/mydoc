
.. _server-linux-zabbix-sourceinstall:

======================================================================================================================================================
zabbix 编译安装
======================================================================================================================================================

环境
======================================================================================================================================================

服务器系统环境：
    系统：
        CentOS6.6 64位
    内核：
        2.6.32
    主机名：
        zzjlogin


CentOS6安装配置(编译安装)
======================================================================================================================================================

参考4.0LST编译安装：
    https://www.zabbix.com/documentation/4.0/zh/manual/installation/install


1. 安装php/http，并配置

.. attention::
    ``http://mirror.webtatic.com/yum/el6/latest.rpm`` 链接也可是 ``https`` ，但是如果rpm安装使用https则会安装失败，因为ca证书问题。

安装php环境：

.. code-block:: bash
    :linenos:

    [root@zzjlogin ~]# rpm -Uvh http://mirror.webtatic.com/yum/el6/latest.rpm
    [root@zzjlogin ~]# yum install php56w php56w-gd php56w-mysql php56w-bcmath php56w-bcmath php56w-mbstring php56w-xml php56w-ldap -y

.. attention::
    注意安装php56w-mysql.x86_64 0:5.6.37-1.w6 ，否则会出现php链接mysql时失败。



yum安装报错可以参考：
    :ref:`linux-faq-yuminstallerr`

安装http及依赖(apache)：

.. code-block:: bash
    :linenos:
    
    [root@zzjlogin zabbix-3.4.13]# yum install httpd libxml2-devel net-snmp-devel libcurl-devel -y

配置php:

.. code-block:: bash
    :linenos:

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

.. code-block:: bash
    :linenos:

    [root@zzjlogin zabbix-3.4.13]# yum install mysql mysql-devel mysql-server -y

    [root@zzjlogin ~]# rpm -qa mysql*

启动数据库，并配置密码:

.. code-block:: bash
    :linenos:

    [root@zzjlogin ~]# /etc/init.d/mysqld start

    [root@zzjlogin ~]# /usr/bin/mysqladmin -u root password '123'

登陆数据库，清理空账号信息，创建zabbix数据库:

.. code-block:: bash
    :linenos:

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

.. code-block:: bash
    :linenos:

    [root@zzjlogin ~]# rpm -i http://repo.zabbix.com/zabbix/3.4/rhel/7/x86_64/zabbix-release-3.4-2.el7.noarch.rpm
    warning: /var/tmp/rpm-tmp.NfLb4n: Header V4 RSA/SHA512 Signature, key ID a14fe591: NOKEY
    [root@zzjlogin ~]# rpm -qa zabbix*
    zabbix-release-3.4-2.el7.noarch

下载软件包:

.. code-block:: bash
    :linenos:

    [root@zzjlogin ~]# wget https://sourceforge.net/projects/zabbix/files/ZABBIX%20Latest%20Stable/3.4.13/zabbix-3.4.13.tar.gz/download

    [root@zzjlogin ~]# ls
    [root@zzjlogin ~]# tar xf download
    [root@zzjlogin ~]# cd zabbix-3.4.13/
    [root@zzjlogin zabbix-3.4.13]#

把zabbix软件包对应的zabbix数据库表结构信息导入mysql数据库:

.. code-block:: bash
    :linenos:

    [root@zzjlogin zabbix-3.4.13]# mysql -uzabbix -ppassword zabbix < database/mysql/schema.sql
    [root@zzjlogin zabbix-3.4.13]# mysql -uzabbix -ppassword zabbix < database/mysql/images.sql 
    [root@zzjlogin zabbix-3.4.13]# mysql -uzabbix -ppassword zabbix < database/mysql/data.sql

.. attention::
    这些表信息是zabbix已经提供的，直接导入即可，如果不导入数据库，是不能访问zabbix的。

编译安装:

.. code-block:: bash
    :linenos:

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

.. code-block:: bash
    :linenos:

    [root@zzjlogin zabbix-3.4.13]# ln -s /usr/local/zabbix/sbin/zabbix_server /usr/sbin/zabbix_server
    [root@zzjlogin zabbix-3.4.13]# ln -s /usr/local/zabbix/sbin/zabbix_agentd /usr/sbin/zabbix_agentd

把zabbix启动脚本拷贝到 ``/etc/init.d/``

.. code-block:: bash
    :linenos:
    
    [root@zzjlogin zabbix-3.4.13]# cp /root/zabbix-3.4.13/misc/init.d/fedora/core/zabbix_server /etc/init.d/

修改脚本默认的zabbix命令路径:

.. code-block:: bash
    :linenos:
    
    [root@zzjlogin zabbix-3.4.13]# sed -i "s@BASEDIR=/usr/local@BASEDIR=/usr/local/zabbix@g" /etc/init.d/zabbix_server

修改zabbix服务器配置信息:

.. code-block:: bash
    :linenos:
    
    [root@zzjlogin zabbix-3.4.13]# vim /etc/zabbix/zabbix_server.conf

    DBHost=localhost  数据库ip地址
    DBName=zabbix
    DBUser=zabbix
    DBPassword=password
    ListenIP=192.168.161.132        #zabbix server ip地址

把zabbix网页信息拷贝到httpd服务器的网页存放目录:

.. code-block:: bash
    :linenos:

    [root@zzjlogin zabbix-3.4.13]# cp -r /root/zabbix-3.4.13/frontends/php/* /var/www/html/

创建zabbix运行账户:

.. code-block:: bash
    :linenos:
    
    [root@zzjlogin zabbix-3.4.13]# useradd -M zabbix -s /sbin/nologin

启动mysql数据库:

.. code-block:: bash
    :linenos:
    
    [root@zzjlogin zabbix-3.4.13]# /etc/init.d/mysqld start

启动httpd服务:

.. code-block:: bash
    :linenos:

    [root@zzjlogin zabbix-3.4.13]# /etc/init.d/httpd start

启动zabbix服务:

.. code-block:: bash
    :linenos:
    
    [root@zzjlogin zabbix-3.4.13]# /etc/init.d/zabbix_server start


至此zabbix可以访问。然后通过浏览器输入zabbix服务器IP地址，然后通过网页配置zabbix即可。








