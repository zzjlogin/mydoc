.. _mysql_multi_instance:

======================================================================================================================================================
MySQL多实例安装
======================================================================================================================================================

:Date: 2018-11

.. contents::

MySQL多实例介绍
======================================================================================================================================================

MySQL多实例特点：
    - 安装一套MySQL程序
    - 启用多个服务，每个实例一个服务
    - 每个服务一个端口。例如双实例可以监听到3306、3307端口
    - 每个实例使用指定的配置文件
    - 每个实例指定MySQL数据根目录
MySQL多实例作用：
    - 充分利用MySQL服务器的资源。
    - 可以节约服务器资源。
MySQL多实例问题：
    - 某一实例资源占用过多时，其他实例会服务质量下降


多实例安装方式：
    - 编译安装多实例
    - rpm安装，然后修改成多实例

MySQL双实例安装(编译安装)
======================================================================================================================================================

MySQL下载
------------------------------------------------------------------------------------------------------------------------------------------------------

.. code-block:: bash
    :linenos:

    [root@mysql_001 tools]# pwd
    /data/tools
    [root@mysql_001 tools]# wget http://ftp.iij.ad.jp/pub/db/mysql/Downloads/MySQL-5.5/mysql-5.5.60.tar.gz


MySQL多实例编译安装
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



.. code-block:: bash
    :linenos:

    [root@mysql_001 tools]# cd mysql-5.5.60
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
    > -DENABLED_LOCAL_INFILE=ON \
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

数据目录创建：

.. code-block:: bash
    :linenos:

    [root@mysql_001 ~]# mkdir /data/{3306,3307}/data -p

    [root@mysql_001 ~]# tree -L 2 /data/ 
    /data/
    ├── 3306
    │   └── data
    ├── 3307
    │   └── data
    ├── lost+found
    └── tools
        ├── mysql-5.5.60
        └── mysql-5.5.60.tar.gz

    7 directories, 1 file

更改数据目录所属用户和组：

.. code-block:: bash
    :linenos:

    id mysql
    useradd -s /sbin/nologin -M mysql
    id mysql
    
    ll /data/
    chown -R mysql.mysql /data/{3306,3307}
    ll /data/

多实例配置文件配置
------------------------------------------------------------------------------------------------------------------------------------------------------

3306配置清单

.. code-block:: bash
    :linenos:

    vi /data/3306/my.cnf

具体配置内容：

.. code-block:: bash
    :linenos:

    [client]
    port      = 3306
    socket    =/data/3306/mysql.sock
    [mysql]
    no-auto-rehash
    [mysqld]
    user    = mysql
    port    = 3306
    socket  =/data/3306/mysql.sock
    basedir = /app/mysql
    datadir = /data/3306/data
    open_files_limit    = 1024
    back_log = 600
    max_connections = 800
    max_connect_errors = 3000
    table_open_cache = 614
    external-locking = FALSE
    max_allowed_packet =8M
    sort_buffer_size = 1M
    join_buffer_size = 1M
    thread_cache_size = 100
    thread_concurrency = 2
    query_cache_size = 2M
    query_cache_limit = 1M
    query_cache_min_res_unit = 2k
    #default_table_type = InnoDB
    thread_stack = 192K
    #transaction_isolation = READ-COMMITTED
    tmp_table_size = 2M
    max_heap_table_size = 2M
    #long_query_time = 1
    #log_long_format
    #log-error = /data/3306/error.log
    #log-slow-queries = /data/3306/slow.log
    pid-file = /data/3306/mysql.pid
    #log-bin = /data/3306/mysql-bin
    relay-log = /data/3306/relay-bin
    relay-log-info-file = /data/3306/relay-log.info
    binlog_cache_size = 1M
    max_binlog_cache_size = 1M
    max_binlog_size = 2M
    expire_logs_days = 7
    key_buffer_size = 16M
    read_buffer_size = 1M
    read_rnd_buffer_size = 1M
    bulk_insert_buffer_size = 1M
    lower_case_table_names = 1
    skip-name-resolve
    slave-skip-errors = 1032,1062
    replicate-ignore-db=mysql
    server-id = 6
    innodb_additional_mem_pool_size = 4M
    innodb_buffer_pool_size = 32M
    innodb_data_file_path = ibdata1:128M:autoextend
    innodb_file_io_threads = 4
    innodb_thread_concurrency = 8
    innodb_flush_log_at_trx_commit = 2
    innodb_log_buffer_size = 2M
    innodb_log_file_size = 4M
    innodb_log_files_in_group = 3
    innodb_max_dirty_pages_pct = 90
    innodb_lock_wait_timeout = 120
    innodb_file_per_table = 0
    [mysqldump]
    quick
    max_allowed_packet = 2M
    [mysqld_safe]
    log-error=/data/3306/mysql_3306.err
    pid-file=/data/3306/mysql.pid


3307配置清单

.. code-block:: bash
    :linenos:

    vi /data/3307/my.cnf

具体配置内容：

.. code-block:: bash
    :linenos:

    [client]
    port      = 3307
    socket    =/data/3307/mysql.sock
    [mysql]
    no-auto-rehash
    [mysqld]
    user    = mysql
    port    = 3307
    socket  =/data/3307/mysql.sock
    basedir = /app/mysql
    datadir = /data/3307/data
    open_files_limit    = 1024
    back_log = 600
    max_connections = 800
    max_connect_errors = 3000
    table_open_cache = 614
    external-locking = FALSE
    max_allowed_packet =8M
    sort_buffer_size = 1M
    join_buffer_size = 1M
    thread_cache_size = 100
    thread_concurrency = 2
    query_cache_size = 2M
    query_cache_limit = 1M
    query_cache_min_res_unit = 2k
    #default_table_type = InnoDB
    thread_stack = 192K
    #transaction_isolation = READ-COMMITTED
    tmp_table_size = 2M
    max_heap_table_size = 2M
    #long_query_time = 1
    #log_long_format
    #log-error = /data/3307/error.log
    #log-slow-queries = /data/3307/slow.log
    pid-file = /data/3307/mysql.pid
    #log-bin = /data/3307/mysql-bin
    relay-log = /data/3307/relay-bin
    relay-log-info-file = /data/3307/relay-log.info
    binlog_cache_size = 1M
    max_binlog_cache_size = 1M
    max_binlog_size = 2M
    expire_logs_days = 7
    key_buffer_size = 16M
    read_buffer_size = 1M
    read_rnd_buffer_size = 1M
    bulk_insert_buffer_size = 1M
    lower_case_table_names = 1
    skip-name-resolve
    slave-skip-errors = 1032,1062
    replicate-ignore-db=mysql
    server-id = 7
    innodb_additional_mem_pool_size = 4M
    innodb_buffer_pool_size = 32M
    innodb_data_file_path = ibdata1:128M:autoextend
    innodb_file_io_threads = 4
    innodb_thread_concurrency = 8
    innodb_flush_log_at_trx_commit = 2
    innodb_log_buffer_size = 2M
    innodb_log_file_size = 4M
    innodb_log_files_in_group = 3
    innodb_max_dirty_pages_pct = 90
    innodb_lock_wait_timeout = 120
    innodb_file_per_table = 0
    [mysqldump]
    quick
    max_allowed_packet = 2M
    [mysqld_safe]
    log-error=/data/3307/mysql_3307.err
    pid-file=/data/3307/mysql.pid


MySQL多实例数据库初始化
------------------------------------------------------------------------------------------------------------------------------------------------------

.. code-block:: bash
    :linenos:

    /app/mysql/scripts/mysql_install_db  --defaults-file=/data/3306/my.cnf --basedir=/app/mysql/ --datadir=/data/3306/data --user=mysql

    /app/mysql/scripts/mysql_install_db  --defaults-file=/data/3307/my.cnf --basedir=/app/mysql/ --datadir=/data/3307/data --user=mysql

MySQL多实例启动
------------------------------------------------------------------------------------------------------------------------------------------------------

经测试用下面命令启动正常：

.. code-block:: bash
    :linenos:

    mysqld --defaults-file=/data/3306/my.cnf 2>&1 >/dev/null &
    mysqld --defaults-file=/data/3307/my.cnf 2>&1 >/dev/null &

查看服务端口：

.. code-block:: bash
    :linenos:

    ss -lntup|grep 330|column -t
    netstat -lntp|grep 330

多实例数据库配置账号密码
------------------------------------------------------------------------------------------------------------------------------------------------------

.. code-block:: bash
    :linenos:

    mysqladmin -u root -S /data/3306/mysql.sock password '3306'
    mysqladmin -u root -S /data/3307/mysql.sock password '3307'

多实例数据库登录
------------------------------------------------------------------------------------------------------------------------------------------------------


没有配置用户密码：

.. code-block:: bash
    :linenos:

    mysql -S /data/3307/mysql.sock
    mysql -S /data/3306/mysql.sock

配置了账号密码：

.. code-block:: bash
    :linenos:

    mysql -uroot -p3306 -S /data/3306/mysql.sock

或者：mysql -uroot -p'3306' -S /data/3306/mysql.sock
或者：mysql -uroot -p -S /data/3306/mysql.sock 


清除不中的账号
------------------------------------------------------------------------------------------------------------------------------------------------------

.. code-block:: bash
    :linenos:

    select user,host from mysql.user;
    drop user "root"@"::1";
    drop user ""@"localhost";
    drop user ""@"demo";
    drop user "root"@"demo";
    flush privileges;
    drop database test;
    select user,host from mysql.user;
    
MySQL多实例关闭
------------------------------------------------------------------------------------------------------------------------------------------------------


有账号密码：

.. code-block:: bash
    :linenos:

    mysqladmin -u root -p3306 -S /data/3306/mysql.sock shutdown
没有账号密码：

.. code-block:: bash
    :linenos:

    mysqladmin -S /data/3306/mysql.sock shutdown





MySQL双实例添加一个实例
======================================================================================================================================================





MySQL使用rpm安装配置多实例
======================================================================================================================================================





