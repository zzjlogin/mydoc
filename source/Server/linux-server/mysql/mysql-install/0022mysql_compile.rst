.. _mysql_compile_install:

======================================================================================================================================================
MySQL编译安装
======================================================================================================================================================

:Date: 2018-11

.. contents::


环境说明
======================================================================================================================================================




MySQL安装
======================================================================================================================================================

MySQL安装准备
------------------------------------------------------------------------------------------------------------------------------------------------------

1. 防火墙、selinux、时间同步配置系统准备命令集合



.. code-block:: bash
    :linenos:

    ntpdate pool.ntp.org
    sed -i 's/SELINUX=enforcing/SELINUX=disabled/' /etc/selinux/config
    setenforce 0
    /etc/init.d/iptables stop 
    chkconfig iptables off

.. attention::
    时间同步最好加入到定时任务。这样保证以后时间如果有错误的时候会自动更正。
    	- ``echo "#time sysc by myhome at 2018-03-30" >>/var/spool/cron/root``
        - ``echo "*/5 * * * * /usr/sbin/ntpdate pool.ntp.org >/dev/null 2&1" >>/var/spool/cron/root``

2. 安装MySQL需要预安装的依赖包

.. code-block:: bash
    :linenos:

    [root@mysql_001 ~]# yum install ncurses-devel libaio-devel cmake -y


MySQL下载
------------------------------------------------------------------------------------------------------------------------------------------------------


.. code-block:: bash
    :linenos:

    [root@mysql_001 ~]# cd /data/tools/
    [root@mysql_001 tools]# wget http://ftp.iij.ad.jp/pub/db/mysql/Downloads/MySQL-5.5/mysql-5.5.60.tar.gz
    [root@mysql_001 tools]# ls
    mysql-5.5.60.tar.gz

MySQL编译安装
------------------------------------------------------------------------------------------------------------------------------------------------------

编译参数官方解释：
    - 5.5版本：https://dev.mysql.com/doc/refman/5.5/en/source-configuration-options.html

.. code-block:: bash
    :linenos:

    [root@mysql_001 tools]# mkdir /app
    [root@mysql_001 tools]# ll -d /app/
    drwxr-xr-x 2 root root 4096 Nov 26 23:48 /app/

    [root@mysql_001 mysql-5.5.60]# cmake . -DCMAKE_INSTALL_PREFIX=/app/mysql-5.5.60 \
    > -DMYSQL_DATADIR=/app/mysql-5.5.60/data \
    > -DMYSQL_UNIX_ADDR=/app/mysql-5.5.60/tmp/mysql.sock \
    > -DDEFAULT_CHARSET=utf8 \
    > -DDEFAULT_COLLATION=utf8_general_ci \
    > -DWITH_EXTRA_CHARSETS=all \
    > -DWITH_INNOBASE_STORAGE_ENGINE=1 \
    > -DWITH_FEDERATED_STORAGE_ENGINE=1 \
    > -DWITH_BLACKHOLE_STORAGE_ENGINE=1 \
    > -DWITHOUT_EXAMPLE_STORAGE_ENGINE=1 \
    > -DWITH_ZLIB=bundled \
    > -DWITH_SSL=bundled \
    > -DENABLED_LOCAL_INFILE=1 \
    > -DWITH_EMBEDDED_SERVER=1 \
    > -DENABLE_DOWNLOADS=1 \
    > -DWITH_DEBUG=0

.. code-block:: bash
    :linenos:

    cmake . -DCMAKE_INSTALL_PREFIX=/app/mysql-5.5.60 \
    -DMYSQL_DATADIR=/app/mysql-5.5.60/data \
    -DMYSQL_UNIX_ADDR=/app/mysql-5.5.60/tmp/mysql.sock \
    -DDEFAULT_CHARSET=utf8 \
    -DDEFAULT_COLLATION=utf8_general_ci \
    -DWITH_EXTRA_CHARSETS=all \
    -DWITH_INNOBASE_STORAGE_ENGINE=1 \
    -DWITH_FEDERATED_STORAGE_ENGINE=1 \
    -DWITH_BLACKHOLE_STORAGE_ENGINE=1 \
    -DWITHOUT_EXAMPLE_STORAGE_ENGINE=1 \
    -DWITH_ZLIB=bundled \
    -DWITH_SSL=bundled \
    -DENABLED_LOCAL_INFILE=ON \
    -DWITH_EMBEDDED_SERVER=1 \
    -DENABLE_DOWNLOADS=1 \
    -DWITH_DEBUG=0


.. code-block:: bash
    :linenos:

    [root@mysql_001 mysql-5.5.60]# make && make install

创建软连接

.. code-block:: bash
    :linenos:

    [root@mysql_001 mysql-5.5.60]# ln -s /app/mysql-5.5.60 /app/mysql

    [root@mysql_001 mysql-5.5.60]# ll /app/mysql
    lrwxrwxrwx 1 root root 17 Nov 27 00:30 /app/mysql -> /app/mysql-5.5.60


配置系统环境变量，使mysql命令可以直接使用不用输入全路径

.. code-block:: bash
    :linenos:

    echo "export PATH=/app/mysql/bin:$PATH" >>/etc/profile
    source /etc/profile
    echo $PATH

设置socket目录权限：

.. code-block:: bash
    :linenos:

    [root@mysql_001 mysql]# chmod 1777 /app/mysql-5.5.60/tmp/

启动脚本

.. code-block:: bash
    :linenos:

    [root@mysql_001 mysql-5.5.60]# pwd
    /data/tools/mysql-5.5.60
    [root@mysql_001 mysql-5.5.60]# cd support-files/

    [root@mysql_001 support-files]# cp mysql.server /etc/init.d/mysqld
    [root@mysql_001 support-files]# chmod 700 /etc/init.d/mysqld

MySQL数据库初始化
------------------------------------------------------------------------------------------------------------------------------------------------------

更改数据目录所属用户和组：

.. code-block:: bash
    :linenos:

    id mysql
    useradd -s /sbin/nologin -M mysql
    id mysql
    
    chown -R mysql.mysql /app/mysql/data/
    ll /app/mysql/data/

.. code-block:: none
    :linenos:

    [root@mysql_001 mysql-5.5.60]# pwd
    /data/tools/mysql-5.5.60
    [root@mysql_001 mysql-5.5.60]# cp support-files/my-small.cnf /etc/my.cnf
    cp: overwrite `/etc/my.cnf'? y`

.. code-block:: bash
    :linenos:

    [root@mysql_001 mysql-5.5.60]# chown -R mysql.mysql /app/mysql/data/
    [root@mysql_001 mysql-5.5.60]# ll -d /app/mysql/data/
    drwxr-xr-x 3 mysql mysql 4096 Nov 27 00:25 /app/mysql/data/

.. code-block:: bash
    :linenos:

    [root@mysql_001 mysql-5.5.60]# cd /app/mysql/scripts/
    [root@mysql_001 scripts]# ./mysql_install_db --defaults-file=/etc/my.cnf --basedir=/app/mysql/ --datadir=/app/mysql/data --user=mysql




MySQL启动
------------------------------------------------------------------------------------------------------------------------------------------------------

.. code-block:: bash
    :linenos:

    [root@mysql_001 ~]# /etc/init.d/mysqld start


MySQL登陆测试并加登陆密码
------------------------------------------------------------------------------------------------------------------------------------------------------

没有设置密码时用默认MySQL客户端登陆MySQL数据库：

.. code-block:: bash
    :linenos:

    [root@mysql_001 ~]# mysql
    Welcome to the MySQL monitor.  Commands end with ; or \g.
    Your MySQL connection id is 1
    Server version: 5.5.60 Source distribution

    Copyright (c) 2000, 2018, Oracle and/or its affiliates. All rights reserved.

    Oracle is a registered trademark of Oracle Corporation and/or its
    affiliates. Other names may be trademarks of their respective
    owners.

    Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

    mysql> show databases;
    +--------------------+
    | Database           |
    +--------------------+
    | information_schema |
    | mysql              |
    | performance_schema |
    | test               |
    +--------------------+
    4 rows in set (0.00 sec)


初始设置MySQL的root密码，设置密码为 ``test`` ：

.. code-block:: bash
    :linenos:

    [root@mysql_001 ~]# mysqladmin -u root password 'test'  
    [root@mysql_001 ~]# mysql -uroot -ptest
    Welcome to the MySQL monitor.  Commands end with ; or \g.
    Your MySQL connection id is 3
    Server version: 5.5.60 Source distribution

    Copyright (c) 2000, 2018, Oracle and/or its affiliates. All rights reserved.

    Oracle is a registered trademark of Oracle Corporation and/or its
    affiliates. Other names may be trademarks of their respective
    owners.

    Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

    mysql>










